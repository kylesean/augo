"""Budget models for financial budget management.

Includes Budget, BudgetPeriod, and BudgetSettings models.
This model has been migrated to SQLAlchemy 2.0 with Mapped[...] annotations.
"""

from __future__ import annotations

from datetime import date, datetime, time
from decimal import Decimal
from enum import Enum
from typing import TYPE_CHECKING, Optional
from uuid import UUID, uuid4 as uuid4_factory

import sqlalchemy as sa
from sqlalchemy import Boolean, CheckConstraint, ForeignKey, Integer, String
from sqlalchemy.dialects.postgresql import UUID as PGUUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.models.base import Base, col

if TYPE_CHECKING:
    from app.models.user import User


# ============================================================================
# Enums
# ============================================================================


class BudgetScope(str, Enum):
    """Budget scope - total or category-specific."""

    TOTAL = "TOTAL"
    CATEGORY = "CATEGORY"


class BudgetType(str, Enum):
    """Budget type - expense limit or savings goal."""

    EXPENSE_LIMIT = "EXPENSE_LIMIT"
    SAVINGS_GOAL = "SAVINGS_GOAL"


class BudgetPeriodType(str, Enum):
    """Budget period type."""

    WEEKLY = "WEEKLY"
    BIWEEKLY = "BIWEEKLY"
    MONTHLY = "MONTHLY"
    YEARLY = "YEARLY"


class BudgetSource(str, Enum):
    """Budget creation source."""

    AI_SUGGESTED = "AI_SUGGESTED"
    USER_DEFINED = "USER_DEFINED"


class BudgetStatus(str, Enum):
    """Budget status."""

    ACTIVE = "ACTIVE"
    PAUSED = "PAUSED"
    ARCHIVED = "ARCHIVED"


class BudgetPeriodStatus(str, Enum):
    """Budget period tracking status."""

    ON_TRACK = "ON_TRACK"
    WARNING = "WARNING"
    EXCEEDED = "EXCEEDED"
    ACHIEVED = "ACHIEVED"


class OverspendBehavior(str, Enum):
    """User preference for overspend handling."""

    WARN = "WARN"
    SUGGEST_REBALANCE = "SUGGEST_REBALANCE"


# ============================================================================
# Budget Model
# ============================================================================


class Budget(Base):
    """Budget model for managing spending limits.

    Supports both total budgets and category-specific budgets.
    Designed for future extension to savings goals and shared budgets.

    Attributes:
        id: Primary key (UUID)
        owner_uuid: Foreign key to users.uuid
        shared_space_id: Optional shared space for collaborative budgets
        name: Budget display name
        type: EXPENSE_LIMIT or SAVINGS_GOAL
        scope: TOTAL or CATEGORY
        category_key: Category key for category budgets (NULL for total)
        amount: Budget limit amount
        currency_code: Currency code (default CNY)
        period_type: WEEKLY, BIWEEKLY, MONTHLY, or YEARLY
        period_anchor_day: Day of month/week to start new period (1-31)
        rollover_enabled: Whether unused budget rolls over
        rollover_balance: Current rollover balance (can be negative)
        source: AI_SUGGESTED or USER_DEFINED
        ai_confidence: Confidence score for AI suggestions
        status: ACTIVE, PAUSED, or ARCHIVED
        target_date: Target date for savings goals
        linked_account_id: Linked account for savings goals
        current_progress: Current progress for savings goals
    """

    __tablename__ = "budgets"
    __table_args__ = (
        CheckConstraint("type IN ('EXPENSE_LIMIT', 'SAVINGS_GOAL')", name="chk_budgets_type"),
        CheckConstraint("scope IN ('TOTAL', 'CATEGORY')", name="chk_budgets_scope"),
        CheckConstraint("period_type IN ('WEEKLY', 'BIWEEKLY', 'MONTHLY', 'YEARLY')", name="chk_budgets_period_type"),
        CheckConstraint("period_anchor_day >= 1 AND period_anchor_day <= 31", name="chk_budgets_anchor_day"),
        CheckConstraint("source IN ('AI_SUGGESTED', 'USER_DEFINED')", name="chk_budgets_source"),
        CheckConstraint("status IN ('ACTIVE', 'PAUSED', 'ARCHIVED')", name="chk_budgets_status"),
        CheckConstraint("amount >= 0", name="chk_budgets_amount_positive"),
    )

    id: Mapped[UUID] = col.uuid_pk(uuid4_factory)
    owner_uuid: Mapped[UUID] = col.uuid_fk("users", ondelete="CASCADE", index=True, column="uuid")
    shared_space_id: Mapped[UUID | None] = col.uuid_column(index=True, nullable=True)

    name: Mapped[str] = mapped_column(String(100))
    type: Mapped[str] = mapped_column(String(20), default="EXPENSE_LIMIT")
    scope: Mapped[str] = mapped_column(String(20))
    category_key: Mapped[str | None] = mapped_column(String(25), nullable=True)

    amount: Mapped[Decimal] = col.numeric(precision=20, scale=8)
    currency_code: Mapped[str] = mapped_column(String(3), default="CNY")

    period_type: Mapped[str] = mapped_column(String(20), default="MONTHLY")
    period_anchor_day: Mapped[int] = mapped_column(Integer, default=1)

    rollover_enabled: Mapped[bool] = mapped_column(Boolean, default=True)
    rollover_balance: Mapped[Decimal] = col.numeric(precision=20, scale=8, default=Decimal("0"))

    source: Mapped[str] = mapped_column(String(20), default="USER_DEFINED")
    ai_confidence: Mapped[Decimal | None] = col.numeric(precision=5, scale=4, nullable=True)
    status: Mapped[str] = mapped_column(String(20), default="ACTIVE")

    target_date: Mapped[date | None] = col.date_column(nullable=True)
    linked_account_id: Mapped[UUID | None] = col.uuid_column(nullable=True)
    current_progress: Mapped[Decimal | None] = col.numeric(precision=20, scale=8, nullable=True)
    created_at: Mapped[datetime] = col.timestamptz()
    updated_at: Mapped[datetime | None] = col.timestamptz(nullable=True)

    owner: Mapped[User | None] = relationship(
        "User",
        foreign_keys="[Budget.owner_uuid]",
        primaryjoin="Budget.owner_uuid == User.uuid",
    )
    periods: Mapped[list[BudgetPeriod]] = relationship(
        "BudgetPeriod",
        back_populates="budget",
        cascade="all, delete-orphan",
    )

    @property
    def amount_float(self) -> float:
        """Get amount as float."""
        return float(self.amount)

    @property
    def rollover_balance_float(self) -> float:
        """Get rollover balance as float."""
        return float(self.rollover_balance)

    @property
    def is_total_budget(self) -> bool:
        """Check if this is a total budget."""
        return self.scope == BudgetScope.TOTAL.value

    @property
    def is_category_budget(self) -> bool:
        """Check if this is a category-specific budget."""
        return self.scope == BudgetScope.CATEGORY.value

    @property
    def is_active(self) -> bool:
        """Check if budget is active."""
        return self.status == BudgetStatus.ACTIVE.value


# ============================================================================
# BudgetPeriod Model
# ============================================================================


class BudgetPeriod(Base):
    """Budget period tracking model.

    Tracks spending progress for each budget period (week/month/year).

    Attributes:
        id: Primary key (UUID)
        budget_id: Foreign key to budgets
        period_start: Start date of the period
        period_end: End date of the period
        spent_amount: Amount spent in this period
        rollover_in: Amount rolled over from previous period
        rollover_out: Amount to roll over to next period
        adjusted_target: Adjusted budget target (original + rollover_in)
        status: ON_TRACK, WARNING, EXCEEDED, or ACHIEVED
        ai_forecast: AI-predicted end-of-period spending
        notes: Optional notes
    """

    __tablename__ = "budget_periods"
    __table_args__ = (
        CheckConstraint("period_end >= period_start", name="chk_budget_periods_dates"),
        CheckConstraint("status IN ('ON_TRACK', 'WARNING', 'EXCEEDED', 'ACHIEVED')", name="chk_budget_periods_status"),
        CheckConstraint("spent_amount >= 0", name="chk_budget_periods_spent_positive"),
    )

    id: Mapped[UUID] = col.uuid_pk(uuid4_factory)
    budget_id: Mapped[UUID] = col.uuid_fk("budgets", ondelete="CASCADE", index=True)

    period_start: Mapped[date] = col.date_column()
    period_end: Mapped[date] = col.date_column()

    spent_amount: Mapped[Decimal] = col.numeric(precision=20, scale=8, default=Decimal("0"))
    rollover_in: Mapped[Decimal] = col.numeric(precision=20, scale=8, default=Decimal("0"))
    rollover_out: Mapped[Decimal] = col.numeric(precision=20, scale=8, default=Decimal("0"))
    adjusted_target: Mapped[Decimal] = col.numeric(precision=20, scale=8)

    status: Mapped[str] = mapped_column(String(20), default="ON_TRACK")
    ai_forecast: Mapped[Decimal | None] = col.numeric(precision=20, scale=8, nullable=True)

    notes: Mapped[str | None] = mapped_column(String, nullable=True)

    budget: Mapped[Budget | None] = relationship("Budget", back_populates="periods")

    @property
    def spent_amount_float(self) -> float:
        """Get spent amount as float."""
        return float(self.spent_amount)

    @property
    def adjusted_target_float(self) -> float:
        """Get adjusted target as float."""
        return float(self.adjusted_target)

    @property
    def remaining_amount(self) -> Decimal:
        """Calculate remaining budget."""
        return self.adjusted_target - self.spent_amount

    @property
    def remaining_amount_float(self) -> float:
        """Get remaining amount as float."""
        return float(self.remaining_amount)

    @property
    def usage_percentage(self) -> float:
        """Calculate usage percentage."""
        if self.adjusted_target == 0:
            return 0.0
        return float(self.spent_amount / self.adjusted_target * 100)

    @property
    def is_exceeded(self) -> bool:
        """Check if budget is exceeded."""
        return self.spent_amount > self.adjusted_target


# ============================================================================
# BudgetSettings Model
# ============================================================================


class BudgetSettings(Base):
    """User budget preferences and notification settings.

    One-to-one relationship with User (user_uuid is primary key).

    Attributes:
        user_uuid: Primary key, references users.uuid
        warning_threshold: Percentage threshold for warning (default 70)
        alert_threshold: Percentage threshold for alert (default 90)
        overspend_behavior: WARN or SUGGEST_REBALANCE
        weekly_summary_enabled: Whether to send weekly summaries
        weekly_summary_day: Day of week for weekly summary
        monthly_summary_enabled: Whether to send monthly summaries
        anomaly_detection_enabled: Whether to detect anomalies
        anomaly_threshold: Amount threshold for anomaly detection
        quiet_hours_start: Start of quiet hours
        quiet_hours_end: End of quiet hours
    """

    __tablename__ = "budget_settings"
    __table_args__ = (
        CheckConstraint("warning_threshold >= 0 AND warning_threshold <= 100", name="chk_budget_settings_warning"),
        CheckConstraint("alert_threshold >= 0 AND alert_threshold <= 100", name="chk_budget_settings_alert"),
        CheckConstraint("warning_threshold <= alert_threshold", name="chk_budget_settings_thresholds"),
        CheckConstraint("overspend_behavior IN ('WARN', 'SUGGEST_REBALANCE')", name="chk_budget_settings_overspend"),
        CheckConstraint(
            "weekly_summary_day IN ('monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday')",
            name="chk_budget_settings_week_day",
        ),
        CheckConstraint("anomaly_threshold >= 0", name="chk_budget_settings_anomaly"),
    )

    user_uuid: Mapped[UUID] = mapped_column(
        PGUUID(as_uuid=True),
        sa.ForeignKey("users.uuid", ondelete="CASCADE"),
        primary_key=True,
    )

    warning_threshold: Mapped[int] = mapped_column(Integer, default=70)
    alert_threshold: Mapped[int] = mapped_column(Integer, default=90)

    overspend_behavior: Mapped[str] = mapped_column(String(20), default="WARN")

    weekly_summary_enabled: Mapped[bool] = mapped_column(Boolean, default=True)
    weekly_summary_day: Mapped[str] = mapped_column(String(10), default="sunday")
    monthly_summary_enabled: Mapped[bool] = mapped_column(Boolean, default=True)

    anomaly_detection_enabled: Mapped[bool] = mapped_column(Boolean, default=True)
    anomaly_threshold: Mapped[Decimal] = col.numeric(precision=20, scale=8, default=Decimal("500"))

    quiet_hours_start: Mapped[time | None] = col.time_column()
    quiet_hours_end: Mapped[time | None] = col.time_column()

    user: Mapped[User | None] = relationship(
        "User",
        foreign_keys="[BudgetSettings.user_uuid]",
        primaryjoin="BudgetSettings.user_uuid == User.uuid",
    )

    @property
    def anomaly_threshold_float(self) -> float:
        """Get anomaly threshold as float."""
        return float(self.anomaly_threshold)
