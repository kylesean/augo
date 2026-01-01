"""Create forecast tables.

Revision ID: 0011
Revises: 0010
Create Date: 2026-01-01

Forecast analytics tables:
- account_daily_snapshots: Daily balance snapshots for time series analysis
- ai_feedback_memory: User feedback on AI predictions for RAG context
"""

from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql


revision: str = "0011"
down_revision: Union[str, None] = "0010"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Create forecast tables."""
    
    # =========================================================================
    # account_daily_snapshots - Daily balance snapshots for charts
    # =========================================================================
    op.create_table(
        "account_daily_snapshots",
        sa.Column("id", sa.Integer, primary_key=True, autoincrement=True),
        sa.Column("snapshot_date", sa.Date, nullable=False),
        sa.Column(
            "account_id",
            sa.Integer,
            sa.ForeignKey("financial_accounts.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "user_uuid",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.uuid", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("currency", sa.String(3), nullable=False),
        sa.Column(
            "balance",
            sa.Numeric(precision=20, scale=8),
            nullable=False,
        ),
        sa.Column(
            "total_incoming",
            sa.Numeric(precision=20, scale=8),
            nullable=False,
            server_default="0",
        ),
        sa.Column(
            "total_outgoing",
            sa.Numeric(precision=20, scale=8),
            nullable=False,
            server_default="0",
        ),
        sa.Column("exchange_rate_snapshot", postgresql.JSONB, nullable=True),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.text("CURRENT_TIMESTAMP"),
        ),
    )
    
    op.create_index("ix_account_daily_snapshots_user_uuid", "account_daily_snapshots", ["user_uuid"])
    op.create_index("ix_account_daily_snapshots_account_id", "account_daily_snapshots", ["account_id"])
    op.create_index("ix_account_daily_snapshots_date", "account_daily_snapshots", ["snapshot_date"])
    op.create_unique_constraint(
        "uq_account_daily_snapshot",
        "account_daily_snapshots",
        ["account_id", "snapshot_date"],
    )
    
    # =========================================================================
    # ai_feedback_memory - User feedback on AI predictions for RAG
    # =========================================================================
    op.create_table(
        "ai_feedback_memory",
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
        sa.Column("insight_type", sa.String(50), nullable=False),
        sa.Column("user_action", sa.String(50), nullable=False),
        sa.Column("ai_content_snapshot", sa.Text, nullable=True),
        sa.Column("user_correction_data", postgresql.JSONB, nullable=True),
        sa.Column("preference_rule", sa.Text, nullable=True),
        sa.Column("context_tags", postgresql.JSONB, nullable=True),
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
    
    op.create_index("ix_ai_feedback_memory_user_uuid", "ai_feedback_memory", ["user_uuid"])
    op.create_index("ix_ai_feedback_memory_insight_type", "ai_feedback_memory", ["insight_type"])
    op.create_index("ix_ai_feedback_memory_created_at", "ai_feedback_memory", ["created_at"])


def downgrade() -> None:
    """Drop forecast tables."""
    op.drop_index("ix_ai_feedback_memory_created_at")
    op.drop_index("ix_ai_feedback_memory_insight_type")
    op.drop_index("ix_ai_feedback_memory_user_uuid")
    op.drop_table("ai_feedback_memory")
    
    op.drop_constraint("uq_account_daily_snapshot", "account_daily_snapshots")
    op.drop_index("ix_account_daily_snapshots_date")
    op.drop_index("ix_account_daily_snapshots_account_id")
    op.drop_index("ix_account_daily_snapshots_user_uuid")
    op.drop_table("account_daily_snapshots")
