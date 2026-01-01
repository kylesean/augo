"""Create financial_settings table.

Revision ID: 0012
Revises: 0011
Create Date: 2026-01-01

User financial settings and preferences.
"""

from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql


revision: str = "0012"
down_revision: Union[str, None] = "0011"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Create financial_settings table."""
    op.create_table(
        "financial_settings",
        sa.Column("id", sa.Integer, primary_key=True, autoincrement=True),
        sa.Column(
            "user_uuid",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.uuid", ondelete="CASCADE"),
            nullable=False,
            unique=True,
        ),
        sa.Column("primary_currency", sa.String(3), nullable=False, server_default="CNY"),
        sa.Column(
            "safety_balance",
            sa.Numeric(precision=20, scale=8),
            nullable=True,
        ),
        sa.Column(
            "daily_burn_rate",
            sa.Numeric(precision=20, scale=8),
            nullable=True,
        ),
        sa.Column(
            "burn_rate_mode",
            sa.String(20),
            nullable=False,
            server_default="AUTO",
        ),
        sa.Column("payday", sa.Integer, nullable=True),
        sa.Column("excluded_categories", postgresql.JSONB, nullable=True),
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
    
    op.create_index("ix_financial_settings_user_uuid", "financial_settings", ["user_uuid"])


def downgrade() -> None:
    """Drop financial_settings table."""
    op.drop_index("ix_financial_settings_user_uuid")
    op.drop_table("financial_settings")
