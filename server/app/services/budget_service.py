"""Budget service for managing budgets and budget periods."""

from calendar import monthrange
from datetime import date, datetime, timedelta
from decimal import Decimal
from typing import List, Optional
from uuid import UUID

from sqlalchemy import and_, func, or_, select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from app.core.logging import logger
from app.models.budget import (
    Budget,
    BudgetPeriod,
    BudgetPeriodStatus,
    BudgetPeriodType,
    BudgetScope,
    BudgetSettings,
    BudgetSource,
    BudgetStatus,
    BudgetType,
)
from app.models.transaction import Transaction
from app.schemas.budget import (
    BudgetAlert,
    BudgetCreateRequest,
    BudgetPeriodResponse,
    BudgetResponse,
    BudgetSettingsResponse,
    BudgetSettingsUpdateRequest,
    BudgetSuggestion,
    BudgetSummaryResponse,
    BudgetUpdateRequest,
)


class BudgetService:
    """Service for budget management operations."""

    def __init__(self, session: AsyncSession):
        self.session = session

    # ========================================================================
    # CRUD Operations
    # ========================================================================

    async def create_budget(
        self,
        user_uuid: UUID,
        request: BudgetCreateRequest,
        source: BudgetSource = BudgetSource.USER_DEFINED,
        ai_confidence: Optional[float] = None,
    ) -> Budget:
        """Create a new budget.

        Args:
            user_uuid: User UUID
            request: Budget creation request
            source: Creation source (AI or user)
            ai_confidence: AI confidence score if AI-suggested

        Returns:
            Created budget
        """
        # Generate name if not provided
        name = request.name
        if not name:
            if request.scope == BudgetScope.TOTAL:
                # Use a stable key instead of a human-readable English string
                name = "TOTAL"
            else:
                # Use category key as the default name
                name = request.category_key or "CATEGORY"

        budget = Budget(
            owner_uuid=user_uuid,
            name=name,
            type=BudgetType.EXPENSE_LIMIT.value,
            scope=request.scope.value if isinstance(request.scope, BudgetScope) else request.scope,
            category_key=request.category_key,
            amount=request.amount,
            currency_code=request.currency_code,
            period_type=request.period_type.value
            if isinstance(request.period_type, BudgetPeriodType)
            else request.period_type,
            period_anchor_day=request.period_anchor_day,
            rollover_enabled=request.rollover_enabled,
            source=source.value if isinstance(source, BudgetSource) else source,
            ai_confidence=Decimal(str(ai_confidence)) if ai_confidence else None,
            status=BudgetStatus.ACTIVE.value,
        )

        self.session.add(budget)
        await self.session.flush()

        # Create initial period
        period_start, period_end = self._calculate_period_range(
            budget.period_type, budget.period_anchor_day, date.today()
        )

        initial_period = BudgetPeriod(
            budget_id=budget.id,
            period_start=period_start,
            period_end=period_end,
            spent_amount=Decimal("0"),
            rollover_in=Decimal("0"),
            rollover_out=Decimal("0"),
            adjusted_target=budget.amount,
            status=BudgetPeriodStatus.ON_TRACK.value,
        )

        self.session.add(initial_period)
        await self.session.commit()
        await self.session.refresh(budget)

        logger.info(
            "budget_created",
            budget_id=str(budget.id),
            user_uuid=str(user_uuid),
            scope=budget.scope,
            category_key=budget.category_key,
            amount=str(budget.amount),
        )

        return budget

    async def get_budget(self, budget_id: UUID, user_uuid: UUID) -> Optional[Budget]:
        """Get a budget by ID.

        Args:
            budget_id: Budget ID
            user_uuid: User UUID for authorization

        Returns:
            Budget or None if not found
        """
        result = await self.session.execute(
            select(Budget)
            .options(selectinload(Budget.periods))
            .where(Budget.id == budget_id, Budget.owner_uuid == user_uuid)
        )
        return result.scalar_one_or_none()

    async def get_user_budgets(
        self,
        user_uuid: UUID,
        status: Optional[BudgetStatus] = None,
        scope: Optional[BudgetScope] = None,
    ) -> List[Budget]:
        """Get all budgets for a user.

        Args:
            user_uuid: User UUID
            status: Optional status filter
            scope: Optional scope filter

        Returns:
            List of budgets
        """
        query = select(Budget).options(selectinload(Budget.periods)).where(Budget.owner_uuid == user_uuid)

        if status:
            query = query.where(Budget.status == status.value)
        if scope:
            query = query.where(Budget.scope == scope.value)

        query = query.order_by(Budget.scope.asc(), Budget.category_key.asc())

        result = await self.session.execute(query)
        return list(result.scalars().all())

    async def update_budget(
        self,
        budget_id: UUID,
        user_uuid: UUID,
        request: BudgetUpdateRequest,
    ) -> Optional[Budget]:
        """Update a budget.

        Args:
            budget_id: Budget ID
            user_uuid: User UUID for authorization
            request: Update request

        Returns:
            Updated budget or None
        """
        budget = await self.get_budget(budget_id, user_uuid)
        if not budget:
            return None

        # Update fields
        if request.name is not None:
            budget.name = request.name
        if request.amount is not None:
            budget.amount = request.amount
            # Also update current period's adjusted target
            current_period = await self._get_current_period(budget)
            if current_period:
                current_period.adjusted_target = request.amount + current_period.rollover_in
        if request.rollover_enabled is not None:
            budget.rollover_enabled = request.rollover_enabled
        if request.status is not None:
            budget.status = request.status.value if isinstance(request.status, BudgetStatus) else request.status
        if request.period_anchor_day is not None:
            budget.period_anchor_day = request.period_anchor_day

        await self.session.commit()
        await self.session.refresh(budget)

        logger.info(
            "budget_updated",
            budget_id=str(budget_id),
            user_uuid=str(user_uuid),
        )

        return budget

    async def delete_budget(self, budget_id: UUID, user_uuid: UUID) -> bool:
        """Delete a budget.

        Args:
            budget_id: Budget ID
            user_uuid: User UUID for authorization

        Returns:
            True if deleted, False if not found
        """
        budget = await self.get_budget(budget_id, user_uuid)
        if not budget:
            return False

        await self.session.delete(budget)
        await self.session.commit()

        logger.info(
            "budget_deleted",
            budget_id=str(budget_id),
            user_uuid=str(user_uuid),
        )

        return True

    # ========================================================================
    # Period Management
    # ========================================================================

    async def _get_current_period(self, budget: Budget) -> Optional[BudgetPeriod]:
        """Get current active period for a budget."""
        today = date.today()

        result = await self.session.execute(
            select(BudgetPeriod).where(
                BudgetPeriod.budget_id == budget.id,
                BudgetPeriod.period_start <= today,
                BudgetPeriod.period_end >= today,
            )
        )
        return result.scalar_one_or_none()

    async def get_or_create_current_period(self, budget: Budget) -> BudgetPeriod:
        """Get current period, creating if necessary.

        Also handles rollover from previous period.
        """
        current_period = await self._get_current_period(budget)

        if current_period:
            return current_period

        # Need to create new period
        today = date.today()
        period_start, period_end = self._calculate_period_range(budget.period_type, budget.period_anchor_day, today)

        # Calculate rollover from previous period
        rollover_in = Decimal("0")
        if budget.rollover_enabled:
            # Get previous period
            result = await self.session.execute(
                select(BudgetPeriod)
                .where(BudgetPeriod.budget_id == budget.id)
                .order_by(BudgetPeriod.period_end.desc())
                .limit(1)
            )
            prev_period = result.scalar_one_or_none()

            if prev_period:
                # Calculate unused amount
                unused = prev_period.adjusted_target - prev_period.spent_amount
                rollover_in = unused
                prev_period.rollover_out = unused

                # Update budget's rollover balance
                budget.rollover_balance = budget.rollover_balance + unused

        # Create new period
        new_period = BudgetPeriod(
            budget_id=budget.id,
            period_start=period_start,
            period_end=period_end,
            spent_amount=Decimal("0"),
            rollover_in=rollover_in,
            rollover_out=Decimal("0"),
            adjusted_target=budget.amount + rollover_in,
            status=BudgetPeriodStatus.ON_TRACK.value,
        )

        self.session.add(new_period)
        await self.session.commit()
        await self.session.refresh(new_period)

        logger.info(
            "budget_period_created",
            budget_id=str(budget.id),
            period_start=str(period_start),
            period_end=str(period_end),
            rollover_in=str(rollover_in),
        )

        return new_period

    def _calculate_period_range(
        self,
        period_type: str,
        anchor_day: int,
        reference_date: date,
    ) -> tuple[date, date]:
        """Calculate period start and end dates.

        Args:
            period_type: WEEKLY, BIWEEKLY, MONTHLY, or YEARLY
            anchor_day: Day of period to anchor on
            reference_date: Reference date to calculate from

        Returns:
            Tuple of (period_start, period_end)
        """
        if period_type == BudgetPeriodType.MONTHLY.value:
            # Monthly: anchor_day to anchor_day-1 next month
            year = reference_date.year
            month = reference_date.month

            # Clamp anchor_day to valid day in month
            max_day = monthrange(year, month)[1]
            actual_anchor = min(anchor_day, max_day)

            if reference_date.day >= actual_anchor:
                # Current period started this month
                period_start = date(year, month, actual_anchor)
                # End is next month
                if month == 12:
                    next_year, next_month = year + 1, 1
                else:
                    next_year, next_month = year, month + 1
                next_max_day = monthrange(next_year, next_month)[1]
                next_anchor = min(anchor_day, next_max_day)
                period_end = date(next_year, next_month, next_anchor) - timedelta(days=1)
            else:
                # Current period started last month
                if month == 1:
                    prev_year, prev_month = year - 1, 12
                else:
                    prev_year, prev_month = year, month - 1
                prev_max_day = monthrange(prev_year, prev_month)[1]
                prev_anchor = min(anchor_day, prev_max_day)
                period_start = date(prev_year, prev_month, prev_anchor)
                period_end = date(year, month, actual_anchor) - timedelta(days=1)

        elif period_type == BudgetPeriodType.WEEKLY.value:
            # Weekly: anchor_day is day of week (1=Monday, 7=Sunday)
            days_since_anchor = (reference_date.weekday() - (anchor_day - 1)) % 7
            period_start = reference_date - timedelta(days=days_since_anchor)
            period_end = period_start + timedelta(days=6)

        elif period_type == BudgetPeriodType.BIWEEKLY.value:
            # Biweekly: every 2 weeks starting from anchor_day
            days_since_anchor = (reference_date.weekday() - (anchor_day - 1)) % 7
            period_start = reference_date - timedelta(days=days_since_anchor)
            # Adjust to 2-week cycle (use week number)
            week_num = period_start.isocalendar()[1]
            if week_num % 2 == 1:
                period_start -= timedelta(days=7)
            period_end = period_start + timedelta(days=13)

        elif period_type == BudgetPeriodType.YEARLY.value:
            # Yearly: Jan 1 to Dec 31
            period_start = date(reference_date.year, 1, 1)
            period_end = date(reference_date.year, 12, 31)

        else:
            # Default to monthly
            period_start = date(reference_date.year, reference_date.month, 1)
            period_end = date(
                reference_date.year + (1 if reference_date.month == 12 else 0), (reference_date.month % 12) + 1, 1
            ) - timedelta(days=1)

        return period_start, period_end

    # ========================================================================
    # Spending Calculation
    # ========================================================================

    async def calculate_spent_amount(
        self,
        user_uuid: UUID,
        period_start: date,
        period_end: date,
        category_key: Optional[str] = None,
    ) -> Decimal:
        """Calculate total spending for a period.

        Args:
            user_uuid: User UUID
            period_start: Period start date
            period_end: Period end date
            category_key: Optional category filter

        Returns:
            Total spent amount
        """
        query = select(func.coalesce(func.sum(Transaction.amount), 0)).where(
            Transaction.user_uuid == user_uuid,
            Transaction.type == "EXPENSE",
            Transaction.status == "CLEARED",
            func.date(Transaction.transaction_at) >= period_start,
            func.date(Transaction.transaction_at) <= period_end,
        )

        if category_key:
            query = query.where(Transaction.category_key == category_key)

        result = await self.session.execute(query)
        spent = result.scalar_one()
        # 设计意图：金额应该以正数存储，通过 type 区分收支。
        # 使用 abs() 确保兼容历史可能存在的负数数据。
        return abs(Decimal(str(spent))) if spent else Decimal("0")

    async def update_period_spent_amount(
        self,
        budget: Budget,
        period: BudgetPeriod,
    ) -> BudgetPeriod:
        """Update spent amount and status for a period."""
        spent = await self.calculate_spent_amount(
            budget.owner_uuid,
            period.period_start,
            period.period_end,
            budget.category_key,
        )

        period.spent_amount = spent

        # Update status based on thresholds
        settings = await self.get_or_create_settings(budget.owner_uuid)
        usage_pct = period.usage_percentage

        if spent > period.adjusted_target:
            period.status = BudgetPeriodStatus.EXCEEDED.value
        elif usage_pct >= settings.alert_threshold:
            period.status = BudgetPeriodStatus.WARNING.value
        elif usage_pct >= settings.warning_threshold:
            period.status = BudgetPeriodStatus.WARNING.value
        else:
            period.status = BudgetPeriodStatus.ON_TRACK.value

        await self.session.commit()
        return period

    # ========================================================================
    # Budget Summary
    # ========================================================================

    async def get_budget_summary(
        self,
        user_uuid: UUID,
        include_paused: bool = False,
    ) -> BudgetSummaryResponse:
        """Get budget summary for a user.

        Args:
            user_uuid: User UUID
            include_paused: If True, also include paused budgets

        Returns all active (and optionally paused) budgets with current period status.
        """
        # 获取活跃预算
        budgets = await self.get_user_budgets(user_uuid, status=BudgetStatus.ACTIVE)

        # 如果需要包含暂停的预算
        if include_paused:
            paused_budgets = await self.get_user_budgets(user_uuid, status=BudgetStatus.PAUSED)
            budgets = list(budgets) + list(paused_budgets)

        total_budget_response = None
        category_budgets = []
        alerts = []
        overall_spent = Decimal("0")
        overall_target = Decimal("0")
        period_start = None
        period_end = None

        for budget in budgets:
            period = await self.get_or_create_current_period(budget)
            period = await self.update_period_spent_amount(budget, period)

            response = await self._build_budget_response(budget, period)

            if budget.is_total_budget:
                total_budget_response = response
                period_start = period.period_start
                period_end = period.period_end
            else:
                category_budgets.append(response)

            overall_spent += period.spent_amount
            overall_target += period.adjusted_target

            # Generate alerts
            if period.status == BudgetPeriodStatus.EXCEEDED.value:
                alerts.append(
                    BudgetAlert(
                        budget_id=budget.id,
                        budget_name=budget.name,
                        category_key=budget.category_key,
                        alert_type="exceeded",
                        # Message is a key for frontend to translate, with data for interpolation
                        message=f"budget.alert.exceeded:{period.spent_amount - period.adjusted_target:.2f}",
                        usage_percentage=period.usage_percentage,
                        remaining_amount=float(period.remaining_amount),
                    )
                )
            elif period.status == BudgetPeriodStatus.WARNING.value:
                alerts.append(
                    BudgetAlert(
                        budget_id=budget.id,
                        budget_name=budget.name,
                        category_key=budget.category_key,
                        alert_type="warning",
                        # Message is a key for frontend to translate, with data for interpolation
                        message=f"budget.alert.warning:{period.usage_percentage:.0f}:{period.remaining_amount:.2f}",
                        usage_percentage=period.usage_percentage,
                        remaining_amount=float(period.remaining_amount),
                    )
                )

        overall_pct = float(overall_spent / overall_target * 100) if overall_target > 0 else 0.0

        return BudgetSummaryResponse(
            total_budget=total_budget_response,
            category_budgets=category_budgets,
            overall_spent=float(overall_spent),
            overall_remaining=float(overall_target - overall_spent),
            overall_percentage=overall_pct,
            alerts=alerts,
            period_start=period_start,
            period_end=period_end,
        )

    async def _build_budget_response(
        self,
        budget: Budget,
        period: BudgetPeriod,
    ) -> BudgetResponse:
        """Build response object for a budget."""
        return BudgetResponse(
            id=budget.id,
            name=budget.name,
            scope=budget.scope,
            category_key=budget.category_key,
            amount=float(budget.amount),
            currency_code=budget.currency_code,
            period_type=budget.period_type,
            period_anchor_day=budget.period_anchor_day,
            rollover_enabled=budget.rollover_enabled,
            rollover_balance=float(budget.rollover_balance),
            source=budget.source,
            ai_confidence=float(budget.ai_confidence) if budget.ai_confidence else None,
            status=budget.status,
            spent_amount=float(period.spent_amount),
            remaining_amount=float(period.remaining_amount),
            usage_percentage=period.usage_percentage,
            period_status=period.status,
            period_start=period.period_start,
            period_end=period.period_end,
            ai_forecast=float(period.ai_forecast) if period.ai_forecast else None,
            created_at=budget.created_at.isoformat() if budget.created_at else None,
            updated_at=budget.updated_at.isoformat() if budget.updated_at else None,
        )

    # ========================================================================
    # AI Suggestions
    # ========================================================================

    async def suggest_budget(
        self,
        user_uuid: UUID,
        category_key: Optional[str] = None,
        months: int = 3,
    ) -> BudgetSuggestion:
        """Generate AI budget suggestion based on historical data.

        Args:
            user_uuid: User UUID
            category_key: Optional category for category-specific suggestion
            months: Number of months to analyze

        Returns:
            Budget suggestion
        """
        # Calculate date range
        end_date = date.today()
        start_date = end_date - timedelta(days=months * 30)

        # Get historical spending
        query = select(
            func.sum(Transaction.amount).label("total"),
            func.count(Transaction.id).label("count"),
            func.avg(Transaction.amount).label("avg"),
        ).where(
            Transaction.user_uuid == user_uuid,
            Transaction.type == "EXPENSE",
            Transaction.status == "CLEARED",
            func.date(Transaction.transaction_at) >= start_date,
            func.date(Transaction.transaction_at) <= end_date,
        )

        if category_key:
            query = query.where(Transaction.category_key == category_key)

        result = await self.session.execute(query)
        row = result.one()

        total_spent = Decimal(str(row.total or 0))
        tx_count = row.count or 0

        if tx_count == 0:
            # No historical data - return structured reasoning for frontend to translate
            return BudgetSuggestion(
                scope=BudgetScope.CATEGORY.value if category_key else BudgetScope.TOTAL.value,
                category_key=category_key,
                suggested_amount=0,
                confidence=0.0,
                # Structured format: key|data for frontend interpolation
                reasoning="budget.suggestion.noData",
                based_on_months=months,
            )

        # Calculate monthly average
        monthly_avg = total_spent / months

        # Add buffer (10-20% based on variance)
        buffer_pct = Decimal("1.15")  # 15% buffer
        suggested_amount = monthly_avg * buffer_pct

        # Calculate confidence based on data quantity
        # More transactions = higher confidence
        confidence = min(0.95, 0.5 + (tx_count / 100) * 0.45)

        scope = BudgetScope.CATEGORY.value if category_key else BudgetScope.TOTAL.value

        # Return structured reasoning with numeric data
        # Frontend can use: t.budget.suggestion.reasoning({months, monthlyAvg, suggestedAmount})
        reasoning = f"budget.suggestion.reasoning|months={months}|monthlyAvg={monthly_avg:.0f}|suggestedAmount={suggested_amount:.0f}"

        return BudgetSuggestion(
            scope=scope,
            category_key=category_key,
            suggested_amount=float(suggested_amount),
            confidence=confidence,
            reasoning=reasoning,
            based_on_months=months,
        )

    async def detect_problem_categories(
        self,
        user_uuid: UUID,
        months: int = 3,
    ) -> List[str]:
        """Detect categories with high variance that might benefit from budgeting.

        Args:
            user_uuid: User UUID
            months: Number of months to analyze

        Returns:
            List of category keys with high variance
        """
        end_date = date.today()
        start_date = end_date - timedelta(days=months * 30)

        # Get spending by category and month
        query = (
            select(
                Transaction.category_key,
                func.sum(Transaction.amount).label("total"),
                func.count(Transaction.id).label("count"),
            )
            .where(
                Transaction.user_uuid == user_uuid,
                Transaction.type == "EXPENSE",
                Transaction.status == "CLEARED",
                func.date(Transaction.transaction_at) >= start_date,
                func.date(Transaction.transaction_at) <= end_date,
            )
            .group_by(Transaction.category_key)
            .having(func.count(Transaction.id) >= 5)  # At least 5 transactions
            .order_by(func.sum(Transaction.amount).desc())
        )

        result = await self.session.execute(query)
        rows = result.all()

        # Return top categories by spending
        problem_categories = []
        for row in rows[:5]:  # Top 5 categories
            if row.category_key:
                problem_categories.append(row.category_key)

        return problem_categories

    # ========================================================================
    # Settings
    # ========================================================================

    async def get_or_create_settings(self, user_uuid: UUID) -> BudgetSettings:
        """Get or create budget settings for a user."""
        result = await self.session.execute(select(BudgetSettings).where(BudgetSettings.user_uuid == user_uuid))
        settings = result.scalar_one_or_none()

        if not settings:
            settings = BudgetSettings(user_uuid=user_uuid)
            self.session.add(settings)
            await self.session.commit()
            await self.session.refresh(settings)

        return settings

    async def update_settings(
        self,
        user_uuid: UUID,
        request: BudgetSettingsUpdateRequest,
    ) -> BudgetSettings:
        """Update budget settings."""
        settings = await self.get_or_create_settings(user_uuid)

        for field, value in request.model_dump(exclude_unset=True).items():
            if value is not None:
                setattr(settings, field, value)

        await self.session.commit()
        await self.session.refresh(settings)

        return settings
