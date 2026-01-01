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
    # budgets - Budget definitions
    # =========================================================================
    op.create_table(
        "budgets",
        sa.Column("id", sa.Integer, primary_key=True, autoincrement=True),
        sa.Column(
            "uuid",
            postgresql.UUID(as_uuid=True),
            nullable=False,
            unique=True,
            server_default=sa.text("gen_random_uuid()"),
        ),
        sa.Column(
            "user_uuid",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.uuid", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("name", sa.String(100), nullable=False),
        sa.Column("category_key", sa.String(50), nullable=True),
        sa.Column(
            "amount",
            sa.Numeric(precision=20, scale=8),
            nullable=False,
        ),
        sa.Column("currency", sa.String(3), nullable=False, server_default="CNY"),
        sa.Column("period_type", sa.String(20), nullable=False, server_default="monthly"),
        sa.Column("start_date", sa.Date, nullable=False),
        sa.Column("end_date", sa.Date, nullable=True),
        sa.Column("is_active", sa.Boolean, nullable=False, server_default="true"),
        sa.Column("rollover", sa.Boolean, nullable=False, server_default="false"),
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
    )
    
    op.create_index("ix_budgets_user_uuid", "budgets", ["user_uuid"])
    op.create_index("ix_budgets_category", "budgets", ["category_key"])
    
    # =========================================================================
    # budget_periods - Budget period tracking
    # =========================================================================
    op.create_table(
        "budget_periods",
        sa.Column("id", sa.Integer, primary_key=True, autoincrement=True),
        sa.Column(
            "uuid",
            postgresql.UUID(as_uuid=True),
            nullable=False,
            unique=True,
            server_default=sa.text("gen_random_uuid()"),
        ),
        sa.Column(
            "budget_id",
            sa.Integer,
            sa.ForeignKey("budgets.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("period_start", sa.Date, nullable=False),
        sa.Column("period_end", sa.Date, nullable=False),
        sa.Column(
            "budgeted_amount",
            sa.Numeric(precision=20, scale=8),
            nullable=False,
        ),
        sa.Column(
            "spent_amount",
            sa.Numeric(precision=20, scale=8),
            nullable=False,
            server_default="0",
        ),
        sa.Column(
            "rollover_amount",
            sa.Numeric(precision=20, scale=8),
            nullable=False,
            server_default="0",
        ),
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
    )
    
    op.create_index("ix_budget_periods_budget_id", "budget_periods", ["budget_id"])
    op.create_index("ix_budget_periods_dates", "budget_periods", ["period_start", "period_end"])
    
    # =========================================================================
    # budget_settings - User budget preferences
    # =========================================================================
    op.create_table(
        "budget_settings",
        sa.Column("id", sa.Integer, primary_key=True, autoincrement=True),
        sa.Column(
            "user_uuid",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.uuid", ondelete="CASCADE"),
            nullable=False,
            unique=True,
        ),
        sa.Column("warning_threshold", sa.Float, nullable=False, server_default="0.8"),
        sa.Column("alert_threshold", sa.Float, nullable=False, server_default="0.95"),
        sa.Column("email_notifications", sa.Boolean, nullable=False, server_default="true"),
        sa.Column("push_notifications", sa.Boolean, nullable=False, server_default="true"),
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
    )
    
    op.create_index("ix_budget_settings_user_uuid", "budget_settings", ["user_uuid"])


def downgrade() -> None:
    """Drop budgets tables."""
    op.drop_index("ix_budget_settings_user_uuid")
    op.drop_table("budget_settings")
    
    op.drop_index("ix_budget_periods_dates")
    op.drop_index("ix_budget_periods_budget_id")
    op.drop_table("budget_periods")
    
    op.drop_index("ix_budgets_category")
    op.drop_index("ix_budgets_user_uuid")
    op.drop_table("budgets")
