"""Cash flow service for forecasting and analysis."""

from datetime import date, datetime, timedelta
from decimal import Decimal
from typing import TYPE_CHECKING, Optional
from uuid import UUID

import structlog
from sqlalchemy import and_, case, func, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.financial_account import FinancialAccount
from app.models.transaction import RecurringTransaction, Transaction

if TYPE_CHECKING:
    from app.services.transaction.recurring_service import RecurringTransactionService

logger = structlog.get_logger(__name__)


class CashFlowService:
    """Service for cash flow forecasting and analysis."""

    def __init__(self, db: AsyncSession, recurring_service: "RecurringTransactionService"):
        self.db = db
        self._recurring = recurring_service

    async def forecast_cash_flow(
        self,
        user_uuid: UUID,
        forecast_days: int = 60,
        granularity: str = "daily",
        scenarios: Optional[list[dict]] = None,
    ) -> dict:
        """Forecast future cash flow."""
        from app.models.financial_settings import FinancialSettings

        # 1. Get base data
        # Get user settings (change to read FinancialSettings)
        settings_query = select(FinancialSettings).where(FinancialSettings.user_uuid == user_uuid)
        settings_result = await self.db.execute(settings_query)
        settings = settings_result.scalar_one_or_none()
        safety_threshold = settings.safety_threshold if settings else Decimal("0.00")

        # Calculate current total balance (from financial_accounts table)
        # Assets (ASSET) are added as positive values, liabilities (LIABILITY) are added as negative values
        accounts_query = select(
            func.coalesce(
                func.sum(
                    case(
                        (FinancialAccount.nature == "ASSET", FinancialAccount.initial_balance),
                        (FinancialAccount.nature == "LIABILITY", -FinancialAccount.initial_balance),
                        else_=0,
                    )
                ),
                0,
            )
        ).where(and_(FinancialAccount.user_uuid == user_uuid, FinancialAccount.include_in_net_worth.is_(True)))
        balance_result = await self.db.execute(accounts_query)
        current_balance = balance_result.scalar() or Decimal("0.00")
        current_balance_str = str(current_balance)

        # Calculate average daily consumption (past 30 days of expense records)
        thirty_days_ago = datetime.now() - timedelta(days=30)
        # First get the daily total expenses
        daily_expense_query = (
            select(
                func.date(Transaction.transaction_at).label("tx_date"),
                func.sum(Transaction.amount).label("daily_total"),
            )
            .where(
                and_(
                    Transaction.user_uuid == user_uuid,
                    Transaction.amount < 0,  # Expenses are negative
                    Transaction.transaction_at >= thirty_days_ago,
                )
            )
            .group_by(func.date(Transaction.transaction_at))
        )

        daily_expense_result = await self.db.execute(daily_expense_query)
        daily_expenses = daily_expense_result.all()

        if daily_expenses:
            total_spending = sum(row.daily_total for row in daily_expenses)
            days_with_spending = len(daily_expenses)
            avg_daily_spending = total_spending / max(days_with_spending, 1)
        else:
            avg_daily_spending = Decimal("-100.00")  # Default value

        avg_daily_spending_str = str(avg_daily_spending)

        # Ensure it's negative (expenses should be negative)
        if Decimal(avg_daily_spending_str) > 0:
            avg_daily_spending_str = str(-abs(Decimal(avg_daily_spending_str)))

        # 2. Aggregate all future events
        events_by_date = {}
        start_date = datetime.now().date()
        forecast_end_date = start_date + timedelta(days=forecast_days)

        # a. Process recurring events
        recurring_query = select(RecurringTransaction).where(
            and_(
                RecurringTransaction.user_uuid == user_uuid,
                RecurringTransaction.is_active.is_(True),
            )
        )
        recurring_result = await self.db.execute(recurring_query)
        recurring_txs = recurring_result.scalars().all()

        for tx in recurring_txs:
            try:
                # Get exception_dates list
                exception_dates_list = tx.exception_dates or []
                exception_dates_set = set(exception_dates_list)

                occurrences = self._recurring.parse_rrule_occurrences(
                    tx.recurrence_rule,
                    tx.start_date,
                    tx.end_date,
                    start_date,
                    forecast_end_date,
                )
                for occ_date in occurrences:
                    date_str = occ_date.isoformat()
                    # Skip excluded dates
                    if date_str in exception_dates_set:
                        continue
                    if date_str not in events_by_date:
                        events_by_date[date_str] = []
                    events_by_date[date_str].append(
                        {
                            "description": tx.description or "周期性交易",
                            "amount": str(tx.amount),  
                        }
                    )
            except Exception as e:
                logger.error(f"Error processing recurring transaction {tx.id}: {e}")
                continue

        # b. Process scenario events
        if scenarios:
            for scenario in scenarios:
                date_str = scenario["date"]
                if date_str not in events_by_date:
                    events_by_date[date_str] = []
                events_by_date[date_str].append(
                    {
                        "description": scenario["description"],
                        "amount": str(scenario["amount"]),
                    }
                )

        # 3. Loop through daily balance calculation
        raw_daily_breakdown = []
        balance = Decimal(current_balance_str)

        for i in range(forecast_days):
            current_date = start_date + timedelta(days=i)
            date_str = current_date.isoformat()

            daily_events = events_by_date.get(date_str, []).copy()
            daily_events.append(
                {
                    "description": "日常消费(预测)",
                    "amount": avg_daily_spending_str,
                }
            )

            daily_net = Decimal("0.00")
            for event in daily_events:
                daily_net += Decimal(event["amount"])

            balance += daily_net

            raw_daily_breakdown.append(
                {
                    "date": date_str,
                    "closingBalance": str(balance),
                    "events": daily_events,
                }
            )

        # 4. Aggregate results based on granularity parameter
        aggregated_breakdown = self._aggregate_breakdown(raw_daily_breakdown, granularity)

        # 5. Calculate warnings and summary information
        warnings = self._calculate_warnings(raw_daily_breakdown, safety_threshold)
        summary = self._calculate_summary(current_balance_str, raw_daily_breakdown)

        return {
            "dailyBreakdown": aggregated_breakdown,
            "warnings": warnings,
            "summary": summary,
        }

    def _aggregate_breakdown(self, daily_breakdown: list[dict], granularity: str) -> list[dict]:
        """Aggregate data based on granularity parameter

        Args:
            daily_breakdown: List of daily details
            granularity: Granularity ('daily', 'weekly', 'monthly')

        Returns:
            Aggregated details list
        """
        if granularity == "daily" or not daily_breakdown:
            return daily_breakdown

        from collections import defaultdict

        grouped_data = defaultdict(list)

        for day in daily_breakdown:
            date_obj = datetime.fromisoformat(day["date"])

            if granularity == "weekly":
                # Use ISO week number as group key
                group_key = date_obj.strftime("%Y-W%W")
            elif granularity == "monthly":
                # Use year-month as group key
                group_key = date_obj.strftime("%Y-%m")
            else:
                group_key = day["date"]

            grouped_data[group_key].append(day)

        # Format aggregated results
        aggregated = []
        for _group_key, days_in_group in grouped_data.items():
            last_day_data = days_in_group[-1]

            # Collect all key events (exclude daily spending prediction)
            all_events = []
            for day in days_in_group:
                for event in day["events"]:
                    if event["description"] != "日常消费(预测)":
                        all_events.append(event)

            aggregated.append(
                {
                    "date": last_day_data["date"],
                    "closingBalance": last_day_data["closingBalance"],
                    "events": all_events,
                }
            )

        return aggregated

    def _calculate_warnings(self, raw_daily_breakdown: list[dict], safety_threshold: Decimal) -> list[dict]:
        """Calculate warning information

        Args:
            raw_daily_breakdown: Original daily details
            safety_threshold: Safety threshold

        Returns:
            Warning list
        """
        warnings = {}
        threshold = safety_threshold

        for day in raw_daily_breakdown:
            balance = Decimal(day["closingBalance"])
            if balance < threshold:
                date_obj = datetime.fromisoformat(day["date"])
                date_str = day["date"]
                warnings[date_str] = {
                    "date": date_str,
                    "message": f"在 {date_obj.month}月{date_obj.day}日后, 您的余额将低于安心线。",
                }

        return list(warnings.values())

    def _calculate_summary(self, start_balance: str, raw_daily_breakdown: list[dict]) -> dict:
        """Calculate summary information

        Args:
            start_balance: Starting balance
            raw_daily_breakdown: Original daily details

        Returns:
            Summary dictionary
        """
        if not raw_daily_breakdown:
            return {
                "startBalance": start_balance,
                "endBalance": start_balance,
                "totalIncome": "0.00",
                "totalExpense": "0.00",
            }

        total_income = Decimal("0.00")
        total_expense = Decimal("0.00")

        for day in raw_daily_breakdown:
            for event in day["events"]:
                amount = Decimal(event["amount"])
                if amount > 0:
                    total_income += amount
                else:
                    total_expense += amount

        return {
            "startBalance": start_balance,
            "endBalance": raw_daily_breakdown[-1]["closingBalance"],
            "totalIncome": str(total_income),
            "totalExpense": str(total_expense),
        }
