"""Statistics service for financial analysis."""

from datetime import datetime, timedelta, timezone
from decimal import Decimal
from typing import List, Optional, Tuple
from uuid import UUID

from sqlalchemy import and_, case, func, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.logging import logger
from app.models.financial_account import FinancialAccount
from app.models.transaction import Transaction
from app.schemas.statistics import (
    CashFlowResponse,
    CategoryBreakdownItem,
    CategoryBreakdownResponse,
    HealthScoreDimension,
    HealthScoreResponse,
    StatisticsOverviewResponse,
    TopTransactionItem,
    TopTransactionsResponse,
    TrendDataPoint,
    TrendDataResponse,
)
from app.utils.currency_utils import BASE_CURRENCY, get_exchange_rate_from_base, get_user_display_currency


class StatisticsService:
    """Service for calculating financial statistics."""

    def __init__(self, db: AsyncSession):
        self.db = db

    def _build_account_filter(
        self,
        user_uuid: UUID,
        account_types: Optional[List[str]],
    ):
        """Build account type filter subquery if account_types is provided."""
        if not account_types:
            return None
        # Return a subquery for filtering by account type
        return select(FinancialAccount.id).where(
            FinancialAccount.user_uuid == user_uuid,
            FinancialAccount.type.in_(account_types),
        )

    def _calc_change_percent(self, prev: Decimal, current: Decimal) -> float:
        """Safely calculate change percentage between two values."""
        if prev == 0 and current == 0:
            return 0.0
        if prev == 0:
            return 100.0 if current > 0 else -100.0
        return float((current - prev) / abs(prev) * 100)

    def _get_date_range(
        self,
        time_range: str,
        start_date: Optional[str] = None,
        end_date: Optional[str] = None,
    ) -> Tuple[datetime, datetime]:
        """Calculate date range based on time_range parameter."""
        now = datetime.now(timezone.utc)

        if time_range == "week":
            # Start of current week (Monday) to end of current week (Sunday)
            start = now - timedelta(days=now.weekday())
            start = start.replace(hour=0, minute=0, second=0, microsecond=0)
            # End of current week (Sunday 23:59:59)
            end = start + timedelta(days=6)
            end = end.replace(hour=23, minute=59, second=59, microsecond=999999)
        elif time_range == "month":
            # Start of current month to end of current month
            start = now.replace(day=1, hour=0, minute=0, second=0, microsecond=0)
            # Calculate end of month
            if now.month == 12:
                next_month = now.replace(year=now.year + 1, month=1, day=1)
            else:
                next_month = now.replace(month=now.month + 1, day=1)
            end = next_month - timedelta(seconds=1)
        elif time_range == "year":
            # Start of current year to end of current year
            start = now.replace(month=1, day=1, hour=0, minute=0, second=0, microsecond=0)
            end = now.replace(month=12, day=31, hour=23, minute=59, second=59, microsecond=999999)
        elif time_range == "custom" and start_date and end_date:
            start = datetime.fromisoformat(start_date.replace("Z", "+00:00"))
            end = datetime.fromisoformat(end_date.replace("Z", "+00:00"))
        else:
            # Default to current month
            start = now.replace(day=1, hour=0, minute=0, second=0, microsecond=0)
            if now.month == 12:
                next_month = now.replace(year=now.year + 1, month=1, day=1)
            else:
                next_month = now.replace(month=now.month + 1, day=1)
            end = next_month - timedelta(seconds=1)

        return start, end

    def _get_previous_period_range(
        self,
        start: datetime,
        end: datetime,
    ) -> Tuple[datetime, datetime]:
        """Get the previous period range for comparison."""
        duration = end - start
        prev_end = start - timedelta(seconds=1)
        prev_start = prev_end - duration
        return prev_start, prev_end

    async def get_overview(
        self,
        user_uuid: UUID,
        time_range: str = "month",
        start_date: Optional[str] = None,
        end_date: Optional[str] = None,
        account_types: Optional[List[str]] = None,
    ) -> StatisticsOverviewResponse:
        """Get statistics overview for the period."""
        period_start, period_end = self._get_date_range(time_range, start_date, end_date)
        prev_start, prev_end = self._get_previous_period_range(period_start, period_end)

        # Build base query conditions
        base_conditions = [
            Transaction.user_uuid == user_uuid,
            Transaction.transaction_at >= period_start,
            Transaction.transaction_at <= period_end,
        ]

        # Apply account type filter if specified
        account_filter = self._build_account_filter(user_uuid, account_types)
        if account_filter is not None:
            base_conditions.append(Transaction.source_account_id.in_(account_filter))

        # Calculate current period totals
        income_query = select(func.coalesce(func.sum(Transaction.amount), 0)).where(
            and_(*base_conditions, Transaction.type == "INCOME")
        )
        expense_query = select(func.coalesce(func.sum(Transaction.amount), 0)).where(
            and_(*base_conditions, Transaction.type == "EXPENSE")
        )

        income_result = await self.db.execute(income_query)
        expense_result = await self.db.execute(expense_query)

        total_income = Decimal(str(income_result.scalar() or 0))
        total_expense = Decimal(str(expense_result.scalar() or 0))

        # Get total balance from financial accounts
        balance_conditions = [
            FinancialAccount.user_uuid == user_uuid,
            FinancialAccount.status == "ACTIVE",
            FinancialAccount.include_in_net_worth.is_(True),
        ]
        # Also filter balance by account types if specified
        if account_types:
            balance_conditions.append(FinancialAccount.type.in_(account_types))

        balance_query = select(
            func.coalesce(
                func.sum(
                    case(
                        (FinancialAccount.nature == "ASSET", FinancialAccount.current_balance),
                        else_=-FinancialAccount.current_balance,
                    )
                ),
                0,
            )
        ).where(*balance_conditions)
        balance_result = await self.db.execute(balance_query)
        total_balance = Decimal(str(balance_result.scalar() or 0))

        # Calculate previous period for comparison
        prev_conditions = [
            Transaction.user_uuid == user_uuid,
            Transaction.transaction_at >= prev_start,
            Transaction.transaction_at <= prev_end,
        ]
        # Apply same account type filter to previous period
        if account_filter is not None:
            prev_conditions.append(Transaction.source_account_id.in_(account_filter))

        prev_income_query = select(func.coalesce(func.sum(Transaction.amount), 0)).where(
            and_(*prev_conditions, Transaction.type == "INCOME")
        )
        prev_expense_query = select(func.coalesce(func.sum(Transaction.amount), 0)).where(
            and_(*prev_conditions, Transaction.type == "EXPENSE")
        )

        prev_income_result = await self.db.execute(prev_income_query)
        prev_expense_result = await self.db.execute(prev_expense_query)

        prev_income = Decimal(str(prev_income_result.scalar() or 0))
        prev_expense = Decimal(str(prev_expense_result.scalar() or 0))

        # 获取汇率
        display_currency = await get_user_display_currency(self.db, user_uuid)
        exchange_rate = await get_exchange_rate_from_base(display_currency)

        # 应用汇率换算
        total_balance = total_balance * Decimal(str(exchange_rate))
        total_income = total_income * Decimal(str(exchange_rate))
        total_expense = total_expense * Decimal(str(exchange_rate))
        prev_income = prev_income * Decimal(str(exchange_rate))
        prev_expense = prev_expense * Decimal(str(exchange_rate))

        # Calculate separate change percentages using helper method
        prev_net = prev_income - prev_expense
        current_net = total_income - total_expense

        income_change = self._calc_change_percent(prev_income, total_income)
        expense_change = self._calc_change_percent(prev_expense, total_expense)
        net_change = self._calc_change_percent(prev_net, current_net)

        return StatisticsOverviewResponse(
            totalBalance=f"{total_balance:.2f}",
            totalIncome=f"{total_income:.2f}",
            totalExpense=f"{total_expense:.2f}",
            incomeChangePercent=round(income_change, 1),
            expenseChangePercent=round(expense_change, 1),
            netChangePercent=round(net_change, 1),
            balanceNote=f"实时资产余额 ({display_currency})",
            periodStart=period_start,
            periodEnd=period_end,
        )

    async def get_trend_data(
        self,
        user_uuid: UUID,
        time_range: str = "month",
        transaction_type: str = "expense",
        start_date: Optional[str] = None,
        end_date: Optional[str] = None,
        account_types: Optional[List[str]] = None,
    ) -> TrendDataResponse:
        """Get trend data for chart visualization."""
        period_start, period_end = self._get_date_range(time_range, start_date, end_date)

        tx_type = transaction_type.upper()

        # Determine grouping granularity based on time range
        if time_range == "week":
            # Group by day of week
            date_trunc = func.date_trunc("day", Transaction.transaction_at)
            # Use raw dates; frontend will handle localization
        elif time_range == "month":
            # Group by day of month (simplified to ~6 points)
            date_trunc = func.date_trunc("day", Transaction.transaction_at)
        elif time_range == "year":
            # Group by month
            date_trunc = func.date_trunc("month", Transaction.transaction_at)
            # Use raw dates; frontend will handle localization
        else:
            date_trunc = func.date_trunc("day", Transaction.transaction_at)
            _labels = None

        # Build base conditions
        base_conditions = [
            Transaction.user_uuid == user_uuid,
            Transaction.type == tx_type,
            Transaction.transaction_at >= period_start,
            Transaction.transaction_at <= period_end,
        ]

        # Apply account type filter if specified
        account_filter = self._build_account_filter(user_uuid, account_types)
        if account_filter is not None:
            base_conditions.append(Transaction.source_account_id.in_(account_filter))

        # Query aggregated data
        query = (
            select(date_trunc.label("period"), func.coalesce(func.sum(Transaction.amount), 0).label("total"))
            .where(and_(*base_conditions))
            .group_by(date_trunc)
            .order_by(date_trunc)
        )

        result = await self.db.execute(query)
        rows = result.all()

        # 获取汇率
        display_currency = await get_user_display_currency(self.db, user_uuid)
        exchange_rate = Decimal(str(await get_exchange_rate_from_base(display_currency)))

        # Build date to amount mapping from query results
        date_amount_map = {}
        for row in rows:
            period_dt = row.period
            amount = Decimal(str(row.total)) * exchange_rate

            if time_range == "year":
                date_key = period_dt.strftime("%Y-%m")
            else:
                date_key = period_dt.strftime("%Y-%m-%d")

            date_amount_map[date_key] = amount

        # Generate complete date sequence and fill missing dates with 0
        data_points = []
        current = period_start

        while current <= period_end:
            if time_range == "year":
                date_key = current.strftime("%Y-%m")
                # Return standard YYYY-MM format as label for Year view
                # This allows frontend to parse and format it (e.g. "Jan", "1月")
                label = date_key
                # Move to next month
                if current.month == 12:
                    current = current.replace(year=current.year + 1, month=1)
                else:
                    current = current.replace(month=current.month + 1)
            else:
                date_key = current.strftime("%Y-%m-%d")
                if time_range == "week":
                    # For week view, use the date string YYYY-MM-DD as label
                    # Frontend will format it to Mon/Tue etc.
                    label = date_key
                else:
                    # For month view (days), also use date key or Day number
                    # Keeping it simple: use date_key so frontend parses it consistently
                    label = date_key
                # Move to next day
                current = current + timedelta(days=1)

            amount = date_amount_map.get(date_key, Decimal("0"))
            data_points.append(
                TrendDataPoint(
                    date=date_key,
                    amount=f"{amount:.2f}",
                    label=label,
                )
            )

        return TrendDataResponse(
            dataPoints=data_points,
            timeRange=time_range,
            transactionType=transaction_type.lower(),
        )

    async def get_category_breakdown(
        self,
        user_uuid: UUID,
        time_range: str = "month",
        start_date: Optional[str] = None,
        end_date: Optional[str] = None,
        account_types: Optional[List[str]] = None,
        transaction_type: str = "expense",
        limit: int = 10,
    ) -> CategoryBreakdownResponse:
        """Get breakdown by category for specified transaction type."""
        period_start, period_end = self._get_date_range(time_range, start_date, end_date)

        tx_type = transaction_type.upper()

        # Build base conditions
        base_conditions = [
            Transaction.user_uuid == user_uuid,
            Transaction.type == tx_type,
            Transaction.transaction_at >= period_start,
            Transaction.transaction_at <= period_end,
        ]

        # Apply account type filter if specified
        account_filter = self._build_account_filter(user_uuid, account_types)
        if account_filter is not None:
            base_conditions.append(Transaction.source_account_id.in_(account_filter))

        # Query category totals for expenses
        query = (
            select(Transaction.category_key, func.sum(Transaction.amount).label("total"))
            .where(and_(*base_conditions))
            .group_by(Transaction.category_key)
            .order_by(func.sum(Transaction.amount).desc())
            .limit(limit)
        )

        result = await self.db.execute(query)
        rows = result.all()

        # 获取汇率
        display_currency = await get_user_display_currency(self.db, user_uuid)
        exchange_rate = Decimal(str(await get_exchange_rate_from_base(display_currency)))

        # Calculate total for percentages
        grand_total = sum(Decimal(str(row.total)) for row in rows) * exchange_rate

        items = []
        for row in rows:
            category_key = row.category_key or "OTHERS"
            amount = Decimal(str(row.total)) * exchange_rate

            percentage = float(amount / grand_total * 100) if grand_total > 0 else 0.0

            items.append(
                CategoryBreakdownItem(
                    categoryKey=category_key,
                    categoryName=category_key,  # Client should translate
                    amount=f"{amount:.2f}",
                    percentage=round(percentage, 1),
                    color="",  # Client should determine color
                    icon="",  # Client should determine icon
                )
            )

        return CategoryBreakdownResponse(
            items=items,
            total=f"{grand_total:.2f}",
        )

    async def get_top_transactions(
        self,
        user_uuid: UUID,
        time_range: str = "month",
        start_date: Optional[str] = None,
        end_date: Optional[str] = None,
        account_types: Optional[List[str]] = None,
        transaction_type: str = "expense",
        sort_by: str = "amount",
        page: int = 1,
        size: int = 10,
    ) -> TopTransactionsResponse:
        """Get top transactions for the period."""
        period_start, period_end = self._get_date_range(time_range, start_date, end_date)

        tx_type = transaction_type.upper()

        # Build base conditions
        base_conditions = [
            Transaction.user_uuid == user_uuid,
            Transaction.type == tx_type,
            Transaction.transaction_at >= period_start,
            Transaction.transaction_at <= period_end,
        ]

        # Apply account type filter if specified
        account_filter = self._build_account_filter(user_uuid, account_types)
        if account_filter is not None:
            base_conditions.append(Transaction.source_account_id.in_(account_filter))

        # Build query
        query = select(Transaction).where(and_(*base_conditions))

        # Apply sorting
        if sort_by == "date":
            query = query.order_by(Transaction.transaction_at.desc())
        else:  # default to amount
            query = query.order_by(Transaction.amount.desc())

        # Get total count
        count_query = select(func.count()).select_from(query.subquery())
        total_count_result = await self.db.execute(count_query)
        total_count = total_count_result.scalar() or 0

        # Apply pagination
        query = query.offset((page - 1) * size).limit(size)

        result = await self.db.execute(query)
        transactions = result.scalars().all()

        # 获取汇率
        display_currency = await get_user_display_currency(self.db, user_uuid)
        exchange_rate = Decimal(str(await get_exchange_rate_from_base(display_currency)))

        items = []
        for tx in transactions:
            category_key = tx.category_key or "OTHERS"

            items.append(
                TopTransactionItem(
                    id=str(tx.id),
                    description=tx.description or tx.raw_input or "",
                    amount=f"{(Decimal(str(tx.amount)) * exchange_rate):.2f}",
                    categoryKey=category_key,
                    categoryName=category_key,  # Client should translate
                    transactionAt=tx.transaction_at,
                    icon="",  # Client should determine icon
                )
            )

        return TopTransactionsResponse(
            items=items,
            sortBy=sort_by,
            total=total_count,
            page=page,
            pageSize=size,
            hasMore=total_count > (page * size),
        )

    # Essential expense categories (housing, food, transport, medical)
    ESSENTIAL_CATEGORIES = {"HOUSING_UTILITIES", "FOOD_DINING", "TRANSPORTATION", "MEDICAL_HEALTH"}
    # Discretionary expense categories (entertainment, shopping)
    DISCRETIONARY_CATEGORIES = {"ENTERTAINMENT", "SHOPPING_RETAIL"}

    async def get_cash_flow(
        self,
        user_uuid: UUID,
        time_range: str = "month",
        start_date: Optional[str] = None,
        end_date: Optional[str] = None,
        account_types: Optional[List[str]] = None,
    ) -> CashFlowResponse:
        """Get comprehensive cash flow analysis for the period."""
        period_start, period_end = self._get_date_range(time_range, start_date, end_date)
        prev_start, prev_end = self._get_previous_period_range(period_start, period_end)

        # Build base query conditions
        base_conditions = [
            Transaction.user_uuid == user_uuid,
            Transaction.transaction_at >= period_start,
            Transaction.transaction_at <= period_end,
        ]

        # Apply account type filter if specified
        account_filter = self._build_account_filter(user_uuid, account_types)
        if account_filter is not None:
            base_conditions.append(Transaction.source_account_id.in_(account_filter))

        # Calculate current period totals
        income_query = select(func.coalesce(func.sum(Transaction.amount), 0)).where(
            and_(*base_conditions, Transaction.type == "INCOME")
        )
        expense_query = select(func.coalesce(func.sum(Transaction.amount), 0)).where(
            and_(*base_conditions, Transaction.type == "EXPENSE")
        )

        income_result = await self.db.execute(income_query)
        expense_result = await self.db.execute(expense_query)

        total_income = Decimal(str(income_result.scalar() or 0))
        total_expense = Decimal(str(expense_result.scalar() or 0))

        # Calculate previous period for comparison
        prev_conditions = [
            Transaction.user_uuid == user_uuid,
            Transaction.transaction_at >= prev_start,
            Transaction.transaction_at <= prev_end,
        ]
        if account_filter is not None:
            prev_conditions.append(Transaction.source_account_id.in_(account_filter))

        prev_income_query = select(func.coalesce(func.sum(Transaction.amount), 0)).where(
            and_(*prev_conditions, Transaction.type == "INCOME")
        )
        prev_expense_query = select(func.coalesce(func.sum(Transaction.amount), 0)).where(
            and_(*prev_conditions, Transaction.type == "EXPENSE")
        )

        prev_income_result = await self.db.execute(prev_income_query)
        prev_expense_result = await self.db.execute(prev_expense_query)

        prev_income = Decimal(str(prev_income_result.scalar() or 0))
        prev_expense = Decimal(str(prev_expense_result.scalar() or 0))

        # 获取汇率
        display_currency = await get_user_display_currency(self.db, user_uuid)
        exchange_rate = Decimal(str(await get_exchange_rate_from_base(display_currency)))

        # 应用汇率换算
        total_income = total_income * exchange_rate
        total_expense = total_expense * exchange_rate
        net_cash_flow = total_income - total_expense
        prev_income = prev_income * exchange_rate
        prev_expense = prev_expense * exchange_rate

        # Calculate savings rate and expense ratio
        if total_income > 0:
            savings_rate = float((total_income - total_expense) / total_income * 100)
            expense_to_income_ratio = float(total_expense / total_income * 100)
        else:
            savings_rate = 0.0 if total_expense == 0 else -100.0
            expense_to_income_ratio = 100.0 if total_expense > 0 else 0.0

        # Calculate category-based expense ratios
        essential_expense = Decimal("0")
        discretionary_expense = Decimal("0")

        if total_expense > 0:
            # Query essential expenses (in BASE currency)
            essential_query = select(func.coalesce(func.sum(Transaction.amount), 0)).where(
                and_(
                    *base_conditions,
                    Transaction.type == "EXPENSE",
                    Transaction.category_key.in_(self.ESSENTIAL_CATEGORIES),
                )
            )
            essential_result = await self.db.execute(essential_query)
            # Use original amount and calculate ratio (conversion not needed for internal ratio)
            essential_expense = Decimal(str(essential_result.scalar() or 0))

            # Query discretionary expenses
            discretionary_query = select(func.coalesce(func.sum(Transaction.amount), 0)).where(
                and_(
                    *base_conditions,
                    Transaction.type == "EXPENSE",
                    Transaction.category_key.in_(self.DISCRETIONARY_CATEGORIES),
                )
            )
            discretionary_result = await self.db.execute(discretionary_query)
            discretionary_expense = Decimal(str(discretionary_result.scalar() or 0))

        # Re-fetch total_expense in BASE for ratio calculation to be safe,
        # but we already have it in BASE before line 589.
        # Let's just use the converted values since both are scaled by exchange_rate.
        # However, it's cleaner to use the BASE ones.
        # But wait, we don't have the BASE total_expense anymore (it was overwritten at 589).
        # We'll use the converted ones.
        total_expense_val = total_expense
        essential_ratio = (
            float((essential_expense * exchange_rate) / total_expense_val * 100) if total_expense_val > 0 else 0.0
        )
        discretionary_ratio = (
            float((discretionary_expense * exchange_rate) / total_expense_val * 100) if total_expense_val > 0 else 0.0
        )

        # Calculate previous savings rate
        if prev_income > 0:
            prev_savings_rate = float((prev_income - prev_expense) / prev_income * 100)
        else:
            prev_savings_rate = 0.0 if prev_expense == 0 else -100.0

        # Calculate change percentages
        income_change = self._calc_change_percent(prev_income, total_income)
        expense_change = self._calc_change_percent(prev_expense, total_expense)
        savings_rate_change = savings_rate - prev_savings_rate

        return CashFlowResponse(
            totalIncome=f"{total_income:.2f}",
            totalExpense=f"{total_expense:.2f}",
            netCashFlow=f"{net_cash_flow:.2f}",
            savingsRate=round(savings_rate, 1),
            expenseToIncomeRatio=round(expense_to_income_ratio, 1),
            essentialExpenseRatio=round(essential_ratio, 1),
            discretionaryExpenseRatio=round(discretionary_ratio, 1),
            incomeChangePercent=round(income_change, 1),
            expenseChangePercent=round(expense_change, 1),
            savingsRateChange=round(savings_rate_change, 1),
            periodStart=period_start,
            periodEnd=period_end,
        )

    async def get_health_score(
        self,
        user_uuid: UUID,
        time_range: str = "month",
        start_date: Optional[str] = None,
        end_date: Optional[str] = None,
        account_types: Optional[List[str]] = None,
    ) -> HealthScoreResponse:
        """Calculate comprehensive financial health score based on multiple dimensions."""
        # First get cash flow data as base
        cash_flow = await self.get_cash_flow(user_uuid, time_range, start_date, end_date, account_types)

        period_start, period_end = self._get_date_range(time_range, start_date, end_date)

        dimensions = []
        suggestions = []

        # Dimension 1: Savings Rate (weight: 40%)
        # Excellent: 30%+, Good: 15-29%, Fair: 5-14%, Poor: <5%
        savings_rate = cash_flow.savingsRate
        if savings_rate >= 30:
            savings_score = 100
            savings_status = "excellent"
        elif savings_rate >= 20:
            savings_score = 85
            savings_status = "good"
        elif savings_rate >= 10:
            savings_score = 70
            savings_status = "fair"
        elif savings_rate >= 0:
            savings_score = 50
            savings_status = "fair"
            suggestions.append("储蓄率较低，建议减少非必要支出以提高储蓄")
        else:
            savings_score = int(round(max(0, 30 + savings_rate)))  # Negative savings
            savings_status = "poor"
            suggestions.append("支出超过收入，需要紧急调整预算或增加收入")

        dimensions.append(
            HealthScoreDimension(
                name="储蓄能力",
                score=savings_score,
                weight=0.4,
                description=f"储蓄率 {savings_rate:.1f}%",
                status=savings_status,
            )
        )

        # Dimension 2: Expense Control (weight: 35%)
        # Based on essential vs discretionary ratio
        essential_ratio = cash_flow.essentialExpenseRatio
        discretionary_ratio = cash_flow.discretionaryExpenseRatio

        # Ideal: essential 50-70%, discretionary <20%
        if essential_ratio >= 50 and discretionary_ratio <= 20:
            expense_score = 100
            expense_status = "excellent"
        elif essential_ratio >= 40 and discretionary_ratio <= 30:
            expense_score = 80
            expense_status = "good"
        elif discretionary_ratio <= 40:
            expense_score = 60
            expense_status = "fair"
            suggestions.append("可选消费占比较高，考虑制定预算控制娱乐和购物支出")
        else:
            expense_score = 40
            expense_status = "poor"
            suggestions.append("支出结构不合理，必要支出不足或可选消费过高")

        dimensions.append(
            HealthScoreDimension(
                name="支出控制",
                score=expense_score,
                weight=0.35,
                description=f"必要支出 {essential_ratio:.1f}%，可选消费 {discretionary_ratio:.1f}%",
                status=expense_status,
            )
        )

        # Dimension 3: Income Stability (weight: 25%)
        # Based on income change vs previous period
        income_change = cash_flow.incomeChangePercent
        if income_change >= 10:
            income_score = 100
            income_status = "excellent"
        elif income_change >= 0:
            income_score = 85
            income_status = "good"
        elif income_change >= -10:
            income_score = 65
            income_status = "fair"
            suggestions.append("收入有所下降，建议开拓额外收入来源")
        else:
            income_score = int(round(max(30, 50 + income_change)))
            income_status = "poor"
            suggestions.append("收入显著下降，需要评估职业发展或寻找新收入机会")

        dimensions.append(
            HealthScoreDimension(
                name="收入稳定性",
                score=income_score,
                weight=0.25,
                description=f"同比变化 {income_change:+.1f}%",
                status=income_status,
            )
        )

        # Calculate total weighted score
        total_score = sum(d.score * d.weight for d in dimensions)
        total_score = int(round(total_score))

        # Determine grade
        if total_score >= 90:
            grade = "A"
        elif total_score >= 75:
            grade = "B"
        elif total_score >= 60:
            grade = "C"
        elif total_score >= 45:
            grade = "D"
        else:
            grade = "F"

        return HealthScoreResponse(
            totalScore=total_score,
            grade=grade,
            dimensions=dimensions,
            suggestions=suggestions[:3],  # Limit to top 3 suggestions
            periodStart=period_start,
            periodEnd=period_end,
        )
