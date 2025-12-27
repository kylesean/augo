"""Forecast service for cash flow prediction.

This service implements the hybrid prediction model:
1. Deterministic Layer (recurring_transactions) - 60% weight
2. Probabilistic Layer (historical average) - 40% weight
3. Semantic Layer (scenario simulation from LLM) - contextual

Architecture:
    - Pure business logic, no LLM calls
    - RAG context retrieval for AI feedback preferences
    - Compatible with GenUI streaming via tools layer
"""

from dataclasses import dataclass, field
from datetime import date, datetime, timedelta, timezone
from decimal import Decimal
from typing import Any, Dict, List, Optional, Tuple
from uuid import UUID

from sqlalchemy import and_, case, func, or_, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.logging import logger
from app.models.financial_account import FinancialAccount
from app.models.forecast import AIFeedbackMemory
from app.models.transaction import RecurringTransaction, Transaction


@dataclass
class ForecastEvent:
    """A single event in the cash flow forecast."""

    date: date
    description: str
    amount: Decimal
    event_type: str  # RECURRING, PREDICTED_VARIABLE, SIMULATED
    source_id: Optional[str] = None  # recurring_transaction.id if applicable
    category_key: Optional[str] = None
    confidence: float = 1.0  # 1.0 for deterministic, < 1.0 for predicted


@dataclass
class ForecastDataPoint:
    """A single data point in the forecast time series."""

    date: date
    predicted_balance: Decimal
    lower_bound: Decimal  # Conservative estimate
    upper_bound: Decimal  # Optimistic estimate
    events: List[ForecastEvent] = field(default_factory=list)


@dataclass
class ForecastWarning:
    """A warning about potential financial issues."""

    date: date
    warning_type: str  # BELOW_SAFETY, NEGATIVE_BALANCE
    message: str


@dataclass
class ForecastSummary:
    """Summary statistics for the forecast period."""

    total_recurring_income: Decimal
    total_recurring_expense: Decimal
    predicted_variable_expense: Decimal
    net_change: Decimal

    @property
    def to_dict(self) -> Dict[str, Any]:
        """Convert the forecast summary to a serializable dictionary."""
        return {
            "total_recurring_income": float(self.total_recurring_income),
            "total_recurring_expense": float(self.total_recurring_expense),
            "predicted_variable_expense": float(self.predicted_variable_expense),
            "net_change": float(self.net_change),
        }


@dataclass
class CashFlowForecastResult:
    """Complete cash flow forecast result."""

    success: bool
    forecast_period: Dict[str, Any]
    current_balance: Decimal
    data_points: List[ForecastDataPoint]
    warnings: List[ForecastWarning]
    summary: ForecastSummary
    user_preferences: List[Dict[str, Any]] = field(default_factory=list)

    def to_dict(self) -> Dict[str, Any]:
        """Convert to dictionary for JSON serialization."""
        return {
            "success": self.success,
            "forecast_period": self.forecast_period,
            "current_balance": float(self.current_balance),
            "data_points": [
                {
                    "date": dp.date.isoformat(),
                    "predicted_balance": float(dp.predicted_balance),
                    "lower_bound": float(dp.lower_bound),
                    "upper_bound": float(dp.upper_bound),
                    "events": [
                        {
                            "type": e.event_type,
                            "description": e.description,
                            "amount": float(e.amount),
                            "source_id": e.source_id,
                            "category_key": e.category_key,
                            "confidence": e.confidence,
                        }
                        for e in dp.events
                    ],
                }
                for dp in self.data_points
            ],
            "warnings": [
                {
                    "date": w.date.isoformat(),
                    "type": w.warning_type,
                    "message": w.message,
                }
                for w in self.warnings
            ],
            "summary": self.summary.to_dict,
            "user_preferences": self.user_preferences,
        }


class ForecastService:
    """Service for generating cash flow forecasts.

    Implements the hybrid prediction model:
    - Deterministic Layer: Expand recurring_transactions rules
    - Probabilistic Layer: Historical average spending
    - Semantic Layer: LLM-triggered scenario simulation
    """

    # Confidence interval margin for probabilistic predictions
    CONFIDENCE_MARGIN = Decimal("0.15")  # ±15% for variable spending

    def __init__(self, db: AsyncSession):
        self.db = db

    async def generate_cash_flow_forecast(
        self,
        user_uuid: UUID,
        forecast_days: int = 30,
        scenarios: Optional[List[Dict[str, Any]]] = None,
        include_variable_spending: bool = True,
        safety_threshold: Optional[Decimal] = None,
    ) -> CashFlowForecastResult:
        """Generate a complete cash flow forecast.

        Args:
            user_uuid: User's UUID
            forecast_days: Number of days to forecast (default 30, max 90)
            scenarios: Optional list of simulated events from LLM
            include_variable_spending: Whether to include predicted daily spending
            safety_threshold: Optional custom safety threshold, overrides user settings

        Returns:
            CashFlowForecastResult with all data points and analysis
        """
        forecast_days = min(max(forecast_days, 7), 90)

        start_date = date.today()
        end_date = start_date + timedelta(days=forecast_days)

        # 1. Get current balance
        current_balance = await self._get_total_balance(user_uuid)

        # 2. Get deterministic events (recurring transactions)
        deterministic_events = await self._get_deterministic_events(user_uuid, start_date, end_date)

        # 3. Get financial settings (safety threshold and manual daily burn rate)
        s_threshold, manual_burn_rate = await self._get_financial_settings(user_uuid)
        if safety_threshold is None:
            safety_threshold = s_threshold

        # 4. Get probabilistic predictions (average daily spending)
        avg_daily_spending = Decimal("0")
        if include_variable_spending:
            avg_daily_spending = await self._get_average_daily_spending(user_uuid, manual_fallback=manual_burn_rate)

        # 5. Process simulated scenarios
        scenario_events = self._process_scenarios(scenarios or [])

        # 6. Get user preferences for AI context
        user_preferences = await self._get_user_preferences(user_uuid, "SPENDING_FORECAST")

        # 7. Build forecast data points
        data_points = self._build_data_points(
            start_date=start_date,
            end_date=end_date,
            current_balance=current_balance,
            deterministic_events=deterministic_events,
            scenario_events=scenario_events,
            avg_daily_spending=avg_daily_spending,
        )

        # 8. Generate warnings
        warnings = self._generate_warnings(
            data_points=data_points,
            safety_threshold=safety_threshold,
        )

        # 9. Calculate summary
        summary = self._calculate_summary(deterministic_events, avg_daily_spending, forecast_days)

        logger.info(
            "forecast_generated",
            user_uuid=str(user_uuid),
            forecast_days=forecast_days,
            deterministic_events=len(deterministic_events),
            scenario_count=len(scenario_events),
            warnings_count=len(warnings),
        )

        return CashFlowForecastResult(
            success=True,
            forecast_period={
                "start": start_date.isoformat(),
                "end": end_date.isoformat(),
                "days": forecast_days,
            },
            current_balance=current_balance,
            data_points=data_points,
            warnings=warnings,
            summary=summary,
            user_preferences=user_preferences,
        )

    async def _get_total_balance(self, user_uuid: UUID) -> Decimal:
        """Get total balance across all ASSET accounts."""
        query = select(
            func.coalesce(
                func.sum(
                    case(
                        (FinancialAccount.nature == "ASSET", FinancialAccount.current_balance),
                        (FinancialAccount.nature == "LIABILITY", -FinancialAccount.current_balance),
                        else_=Decimal("0"),
                    )
                ),
                Decimal("0"),
            )
        ).where(
            and_(
                FinancialAccount.user_uuid == user_uuid,
                FinancialAccount.status == "ACTIVE",
                FinancialAccount.include_in_net_worth.is_(True),
            )
        )

        result = await self.db.execute(query)
        return result.scalar() or Decimal("0")

    async def _get_deterministic_events(
        self,
        user_uuid: UUID,
        start_date: date,
        end_date: date,
    ) -> List[ForecastEvent]:
        """Get all deterministic events from recurring transactions."""
        from dateutil.rrule import rrulestr

        query = select(RecurringTransaction).where(
            and_(
                RecurringTransaction.user_uuid == user_uuid,
                RecurringTransaction.is_active.is_(True),
                or_(
                    RecurringTransaction.end_date.is_(None),
                    RecurringTransaction.end_date >= start_date,
                ),
            )
        )

        result = await self.db.execute(query)
        recurring_txs = result.scalars().all()

        events = []

        for tx in recurring_txs:
            try:
                # Parse RRULE and generate occurrences
                dtstart = datetime.combine(tx.start_date, datetime.min.time(), tzinfo=timezone.utc)
                rrule = rrulestr(tx.recurrence_rule, dtstart=dtstart)

                exception_set = set(tx.exception_dates or [])

                for occurrence in rrule:
                    occ_date = occurrence.date()

                    # Skip dates outside range
                    if occ_date < start_date:
                        continue
                    if occ_date > end_date:
                        break

                    # Skip exception dates
                    if occ_date.isoformat() in exception_set:
                        continue

                    # Skip if past end_date of rule
                    if tx.end_date and occ_date > tx.end_date:
                        break

                    # Determine amount sign based on transaction type
                    amount = tx.amount
                    if tx.type == "EXPENSE":
                        amount = -abs(amount)
                    elif tx.type == "INCOME":
                        amount = abs(amount)
                    # TRANSFER: amount stays as-is (could be positive or negative)

                    events.append(
                        ForecastEvent(
                            date=occ_date,
                            description=tx.description or tx.category_key or tx.type,
                            amount=amount,
                            event_type="RECURRING",
                            source_id=str(tx.id),
                            category_key=tx.category_key,
                            confidence=1.0,  # Deterministic = 100% confidence
                        )
                    )

            except Exception as e:
                logger.warning(
                    "rrule_parse_error",
                    recurring_id=str(tx.id),
                    error=str(e),
                )
                continue

        return events

    async def _get_average_daily_spending(
        self,
        user_uuid: UUID,
        lookback_days: int = 30,
        manual_fallback: Optional[Decimal] = None,
    ) -> Decimal:
        """Calculate predicted daily variable spending using scientific methods.

        改进点：
        1. 使用中位数而非平均数（对异常值更健壮）
        2. 排除周期性交易（避免重复计算）
        3. 使用完整时间范围计算（lookback_days 而非只有消费的天数）

        Priority:
        1. 如果用户手动设置了 daily_burn_rate > 0 → 优先使用用户设定
        2. 历史中位数（if enough data points exist）
        3. System default (100.00)
        """
        # 如果用户手动设置了值，优先使用（表示用户想覆盖）
        if manual_fallback is not None and manual_fallback > Decimal("0"):
            logger.debug(
                "forecast_using_user_override", user_uuid=str(user_uuid), daily_burn_rate=float(manual_fallback)
            )
            return -abs(manual_fallback)

        lookback_start = datetime.now(timezone.utc) - timedelta(days=lookback_days)

        # 获取周期性交易的金额集合（用于排除）
        recurring_amounts = set()
        recurring_query = select(RecurringTransaction.amount).where(
            and_(
                RecurringTransaction.user_uuid == user_uuid,
                RecurringTransaction.is_active.is_(True),
                RecurringTransaction.type == "EXPENSE",
            )
        )
        try:
            result = await self.db.execute(recurring_query)
            for row in result.all():
                # 添加周期金额（允许小误差匹配）
                recurring_amounts.add(float(abs(row[0])))
        except Exception:
            pass

        # 查询每笔支出交易（而非每日汇总）
        query = (
            select(
                Transaction.amount,
                Transaction.transaction_at,
            )
            .where(
                and_(
                    Transaction.user_uuid == user_uuid,
                    Transaction.type == "EXPENSE",
                    Transaction.status == "CLEARED",
                    Transaction.transaction_at >= lookback_start,
                )
            )
            .order_by(Transaction.transaction_at)
        )

        result = await self.db.execute(query)
        transactions = result.all()

        # 过滤掉周期性交易（金额匹配）
        variable_expenses = []
        for tx in transactions:
            tx_amount = float(abs(tx.amount))
            # 如果金额与任何周期交易匹配（允许 1% 误差），则排除
            is_recurring = (
                any(
                    abs(tx_amount - recurring_amt) / max(recurring_amt, 1) < 0.01
                    for recurring_amt in recurring_amounts
                )
                if recurring_amounts
                else False
            )

            if not is_recurring:
                variable_expenses.append(tx_amount)

        if len(variable_expenses) >= 5:
            # 使用中位数（对异常值更健壮）
            sorted_expenses = sorted(variable_expenses)
            n = len(sorted_expenses)
            if n % 2 == 0:
                median = (sorted_expenses[n // 2 - 1] + sorted_expenses[n // 2]) / 2
            else:
                median = sorted_expenses[n // 2]

            # 计算日均：总可变支出 / 完整天数（而非只有消费的天数）
            total_variable = sum(variable_expenses)
            daily_avg = Decimal(str(total_variable)) / Decimal(str(lookback_days))

            # 使用中位数和日均的加权平均（中位数权重更高）
            # 这样既考虑了典型消费水平，也考虑了消费频率
            avg = Decimal(str(median)) * Decimal("0.4") + daily_avg * Decimal("0.6")

            logger.debug(
                "forecast_using_scientific_method",
                user_uuid=str(user_uuid),
                median=median,
                daily_avg=float(daily_avg),
                weighted_avg=float(avg),
                variable_transactions=len(variable_expenses),
                excluded_recurring=len(transactions) - len(variable_expenses),
            )
        else:
            # 数据不足，使用默认值
            avg = Decimal("100.00")
            logger.debug(
                "forecast_using_system_default",
                user_uuid=str(user_uuid),
                reason="insufficient_data",
                data_points=len(variable_expenses),
            )

        # Return as negative (expense)
        return -abs(avg)

    def _process_scenarios(
        self,
        scenarios: List[Dict[str, Any]],
    ) -> List[ForecastEvent]:
        """Convert LLM-generated scenarios to ForecastEvents."""
        events = []

        for scenario in scenarios:
            try:
                # Parse date
                if isinstance(scenario.get("date"), str):
                    scenario_date = date.fromisoformat(scenario["date"])
                else:
                    scenario_date = scenario.get("date", date.today())

                # Parse amount
                amount = Decimal(str(scenario.get("amount", 0)))

                events.append(
                    ForecastEvent(
                        date=scenario_date,
                        description=scenario.get("description", "模拟场景"),
                        amount=amount,
                        event_type="SIMULATED",
                        confidence=0.8,  # Simulated events have lower confidence
                    )
                )

            except Exception as e:
                logger.warning("scenario_parse_error", scenario=scenario, error=str(e))
                continue

        return events

    async def _get_user_preferences(
        self,
        user_uuid: UUID,
        insight_type: str,
        limit: int = 10,
    ) -> List[Dict[str, Any]]:
        """Get user's AI feedback preferences for RAG context."""
        query = (
            select(AIFeedbackMemory)
            .where(
                and_(
                    AIFeedbackMemory.user_uuid == user_uuid,
                    AIFeedbackMemory.insight_type == insight_type,
                )
            )
            .order_by(AIFeedbackMemory.created_at.desc())
            .limit(limit)
        )

        try:
            result = await self.db.execute(query)
            feedbacks = result.scalars().all()
        except Exception:
            # Table might not exist yet
            return []

        preferences = []
        for fb in feedbacks:
            if fb.preference_rule:
                preferences.append(
                    {
                        "action": fb.user_action,
                        "rule": fb.preference_rule,
                        "created_at": fb.created_at.isoformat() if fb.created_at else None,
                    }
                )

        return preferences

    async def _get_financial_settings(self, user_uuid: UUID) -> Tuple[Decimal, Decimal]:
        """Get user's financial settings (safety_threshold, daily_burn_rate)."""
        from app.models.financial_settings import FinancialSettings

        query = select(FinancialSettings.safety_threshold, FinancialSettings.daily_burn_rate).where(
            FinancialSettings.user_uuid == user_uuid
        )

        try:
            result = await self.db.execute(query)
            settings = result.first()
            if settings:
                return settings.safety_threshold, settings.daily_burn_rate
            return Decimal("0"), Decimal("100.00")
        except Exception:
            return Decimal("0"), Decimal("100.00")

    def _build_data_points(
        self,
        start_date: date,
        end_date: date,
        current_balance: Decimal,
        deterministic_events: List[ForecastEvent],
        scenario_events: List[ForecastEvent],
        avg_daily_spending: Decimal,
    ) -> List[ForecastDataPoint]:
        """Build the complete forecast time series."""
        # Group events by date
        events_by_date: Dict[date, List[ForecastEvent]] = {}

        for event in deterministic_events + scenario_events:
            if event.date not in events_by_date:
                events_by_date[event.date] = []
            events_by_date[event.date].append(event)

        # Generate data points
        data_points = []
        running_balance = current_balance
        running_lower = current_balance
        running_upper = current_balance

        current_date = start_date
        while current_date <= end_date:
            # Get events for this day
            day_events = events_by_date.get(current_date, [])

            # Add predicted variable spending (if not already covered by events)
            if avg_daily_spending != Decimal("0"):
                day_events.append(
                    ForecastEvent(
                        date=current_date,
                        description="日常消费(预测)",
                        amount=avg_daily_spending,
                        event_type="PREDICTED_VARIABLE",
                        confidence=0.7,
                    )
                )

            # Calculate day's net change
            daily_change = sum(e.amount for e in day_events)

            # Calculate confidence interval
            # For variable spending, apply ±15% margin
            variable_amount = sum(abs(e.amount) for e in day_events if e.event_type == "PREDICTED_VARIABLE")
            margin = variable_amount * self.CONFIDENCE_MARGIN

            # Update running balances
            running_balance += daily_change
            running_lower += daily_change - margin
            running_upper += daily_change + margin

            data_points.append(
                ForecastDataPoint(
                    date=current_date,
                    predicted_balance=running_balance,
                    lower_bound=running_lower,
                    upper_bound=running_upper,
                    events=day_events,
                )
            )

            current_date += timedelta(days=1)

        return data_points

    def _generate_warnings(
        self,
        data_points: List[ForecastDataPoint],
        safety_threshold: Decimal,
    ) -> List[ForecastWarning]:
        """Generate warnings for potential financial issues."""
        warnings = []
        warned_below_safety = False
        warned_negative = False

        for dp in data_points:
            # Check for negative balance
            if dp.predicted_balance < 0 and not warned_negative:
                warnings.append(
                    ForecastWarning(
                        date=dp.date,
                        warning_type="NEGATIVE_BALANCE",
                        message=f"预计在 {dp.date.month}月{dp.date.day}日 余额将变为负数",
                    )
                )
                warned_negative = True

            # Check for below safety threshold
            elif dp.predicted_balance < safety_threshold and dp.predicted_balance >= 0 and not warned_below_safety:
                warnings.append(
                    ForecastWarning(
                        date=dp.date,
                        warning_type="BELOW_SAFETY",
                        message=f"预计在 {dp.date.month}月{dp.date.day}日 余额将低于安心线",
                    )
                )
                warned_below_safety = True

        return warnings

    def _calculate_summary(
        self,
        deterministic_events: List[ForecastEvent],
        avg_daily_spending: Decimal,
        forecast_days: int,
    ) -> ForecastSummary:
        """Calculate forecast summary statistics."""
        total_recurring_income = sum(e.amount for e in deterministic_events if e.amount > 0)
        total_recurring_expense = abs(sum(e.amount for e in deterministic_events if e.amount < 0))
        predicted_variable = abs(avg_daily_spending * forecast_days)

        net_change = total_recurring_income - total_recurring_expense - predicted_variable

        return ForecastSummary(
            total_recurring_income=total_recurring_income,
            total_recurring_expense=total_recurring_expense,
            predicted_variable_expense=predicted_variable,
            net_change=net_change,
        )

    async def simulate_purchase(
        self,
        user_uuid: UUID,
        amount: Decimal,
        purchase_date: Optional[date] = None,
        description: str = "模拟购买",
    ) -> CashFlowForecastResult:
        """Simulate a one-time purchase and show its impact.

        Convenience method for "What if I buy X?" scenarios.
        """
        if purchase_date is None:
            purchase_date = date.today() + timedelta(days=7)

        scenario = {
            "date": purchase_date.isoformat(),
            "amount": -abs(float(amount)),  # Ensure it's negative (expense)
            "description": description,
        }

        return await self.generate_cash_flow_forecast(
            user_uuid=user_uuid,
            forecast_days=30,
            scenarios=[scenario],
        )
