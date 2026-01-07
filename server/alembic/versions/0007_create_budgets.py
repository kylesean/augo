"""Create budgets tables.

Revision ID: 0007
Revises: 0006
Create Date: 2026-01-01

Budget management including periods and settings.
"""

from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql


revision: str = "0007"
down_revision: Union[str, None] = "0006"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Create budgets tables."""

    # =========================================================================
    # budgets - Budget definitions (matches Budget model)
    # =========================================================================
    op.create_table(
        "budgets",
        # Model uses: id: UUID
        sa.Column(
            "id",
            postgresql.UUID(as_uuid=True),
            primary_key=True,
            server_default=sa.text("gen_random_uuid()"),
        ),
        # Model uses: owner_uuid, shared_space_id
        sa.Column(
            "owner_uuid",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.uuid", ondelete="CASCADE"),
            nullable=False,
        ),
        # shared_space_id FK added in 0008 after shared_spaces table is created
        sa.Column(
            "shared_space_id",
            postgresql.UUID(as_uuid=True),
            nullable=True,
        ),
        sa.Column("name", sa.String(100), nullable=False),
        # Model uses: type, scope
        sa.Column("type", sa.String(20), nullable=False, server_default="EXPENSE_LIMIT"),
        sa.Column("scope", sa.String(20), nullable=False),
        sa.Column("category_key", sa.String(25), nullable=True),
        sa.Column("amount", sa.Numeric(precision=20, scale=8), nullable=False),
        sa.Column("currency_code", sa.String(3), nullable=False, server_default="CNY"),
        sa.Column("period_type", sa.String(20), nullable=False, server_default="MONTHLY"),
        sa.Column("period_anchor_day", sa.Integer, nullable=False, server_default="1"),
        sa.Column("rollover_enabled", sa.Boolean, nullable=False, server_default="true"),
        sa.Column("rollover_balance", sa.Numeric(precision=20, scale=8), nullable=False, server_default="0"),
        sa.Column("source", sa.String(20), nullable=False, server_default="USER_DEFINED"),
        sa.Column("ai_confidence", sa.Numeric(precision=5, scale=4), nullable=True),
        sa.Column("status", sa.String(20), nullable=False, server_default="ACTIVE"),
        # Savings goal fields
        sa.Column("target_date", sa.Date, nullable=True),
        sa.Column(
            "linked_account_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("financial_accounts.id", ondelete="SET NULL"),
            nullable=True,
        ),
        sa.Column("current_progress", sa.Numeric(precision=20, scale=8), nullable=True),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.text("CURRENT_TIMESTAMP"),
        ),
        sa.Column(
            "updated_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.text("CURRENT_TIMESTAMP"),
        ),
        # Constraints
        sa.CheckConstraint("type IN ('EXPENSE_LIMIT', 'SAVINGS_GOAL')", name="chk_budgets_type"),
        sa.CheckConstraint("scope IN ('TOTAL', 'CATEGORY')", name="chk_budgets_scope"),
        sa.CheckConstraint("period_type IN ('WEEKLY', 'BIWEEKLY', 'MONTHLY', 'YEARLY')", name="chk_budgets_period_type"),
        sa.CheckConstraint("period_anchor_day >= 1 AND period_anchor_day <= 31", name="chk_budgets_anchor_day"),
        sa.CheckConstraint("source IN ('AI_SUGGESTED', 'USER_DEFINED')", name="chk_budgets_source"),
        sa.CheckConstraint("status IN ('ACTIVE', 'PAUSED', 'ARCHIVED')", name="chk_budgets_status"),
        sa.CheckConstraint("amount >= 0", name="chk_budgets_amount_positive"),
    )

    op.create_index("ix_budgets_owner_uuid", "budgets", ["owner_uuid"])
    op.create_index("ix_budgets_shared_space_id", "budgets", ["shared_space_id"])
    op.create_index("ix_budgets_category_key", "budgets", ["category_key"])

    # =========================================================================
    # budget_periods - Budget period tracking (matches BudgetPeriod model)
    # =========================================================================
    op.create_table(
        "budget_periods",
        # Model uses: id: UUID
        sa.Column(
            "id",
            postgresql.UUID(as_uuid=True),
            primary_key=True,
            server_default=sa.text("gen_random_uuid()"),
        ),
        sa.Column(
            "budget_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("budgets.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("period_start", sa.Date, nullable=False),
        sa.Column("period_end", sa.Date, nullable=False),
        sa.Column("spent_amount", sa.Numeric(precision=20, scale=8), nullable=False, server_default="0"),
        sa.Column("rollover_in", sa.Numeric(precision=20, scale=8), nullable=False, server_default="0"),
        sa.Column("rollover_out", sa.Numeric(precision=20, scale=8), nullable=False, server_default="0"),
        sa.Column("adjusted_target", sa.Numeric(precision=20, scale=8), nullable=False),
        sa.Column("status", sa.String(20), nullable=False, server_default="ON_TRACK"),
        sa.Column("ai_forecast", sa.Numeric(precision=20, scale=8), nullable=True),
        sa.Column("notes", sa.Text, nullable=True),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.text("CURRENT_TIMESTAMP"),
        ),
        sa.Column(
            "updated_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.text("CURRENT_TIMESTAMP"),
        ),
        # Constraints
        sa.CheckConstraint("period_end >= period_start", name="chk_budget_periods_dates"),
        sa.CheckConstraint("status IN ('ON_TRACK', 'WARNING', 'EXCEEDED', 'ACHIEVED')", name="chk_budget_periods_status"),
        sa.CheckConstraint("spent_amount >= 0", name="chk_budget_periods_spent_positive"),
    )

    op.create_index("ix_budget_periods_budget_id", "budget_periods", ["budget_id"])
    op.create_index("ix_budget_periods_dates", "budget_periods", ["period_start", "period_end"])

    # =========================================================================
    # budget_settings - User budget preferences (matches BudgetSettings model)
    # Primary key is user_uuid (one-to-one with user)
    # =========================================================================
    op.create_table(
        "budget_settings",
        sa.Column(
            "user_uuid",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.uuid", ondelete="CASCADE"),
            primary_key=True,
        ),
        sa.Column("warning_threshold", sa.Integer, nullable=False, server_default="70"),
        sa.Column("alert_threshold", sa.Integer, nullable=False, server_default="90"),
        sa.Column("overspend_behavior", sa.String(20), nullable=False, server_default="WARN"),
        sa.Column("weekly_summary_enabled", sa.Boolean, nullable=False, server_default="true"),
        sa.Column("weekly_summary_day", sa.String(10), nullable=False, server_default="'sunday'"),
        sa.Column("monthly_summary_enabled", sa.Boolean, nullable=False, server_default="true"),
        sa.Column("anomaly_detection_enabled", sa.Boolean, nullable=False, server_default="true"),
        sa.Column("anomaly_threshold", sa.Numeric(precision=20, scale=8), nullable=False, server_default="500"),
        sa.Column("quiet_hours_start", sa.Time, nullable=True),
        sa.Column("quiet_hours_end", sa.Time, nullable=True),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.text("CURRENT_TIMESTAMP"),
        ),
        sa.Column(
            "updated_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.text("CURRENT_TIMESTAMP"),
        ),
        # Constraints
        sa.CheckConstraint("warning_threshold >= 0 AND warning_threshold <= 100", name="chk_budget_settings_warning"),
        sa.CheckConstraint("alert_threshold >= 0 AND alert_threshold <= 100", name="chk_budget_settings_alert"),
        sa.CheckConstraint("warning_threshold <= alert_threshold", name="chk_budget_settings_thresholds"),
        sa.CheckConstraint("overspend_behavior IN ('WARN', 'SUGGEST_REBALANCE')", name="chk_budget_settings_overspend"),
        sa.CheckConstraint(
            "weekly_summary_day IN ('monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday')",
            name="chk_budget_settings_week_day",
        ),
        sa.CheckConstraint("anomaly_threshold >= 0", name="chk_budget_settings_anomaly"),
    )


def downgrade() -> None:
    """Drop budgets tables."""
    op.drop_table("budget_settings")

    op.drop_index("ix_budget_periods_dates")
    op.drop_index("ix_budget_periods_budget_id")
    op.drop_table("budget_periods")

    op.drop_index("ix_budgets_category_key")
    op.drop_index("ix_budgets_shared_space_id")
    op.drop_index("ix_budgets_owner_uuid")
    op.drop_table("budgets")
