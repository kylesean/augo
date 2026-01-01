"""Create financial_accounts table.

Revision ID: 0005
Revises: 0004
Create Date: 2026-01-01

User financial accounts (bank accounts, wallets, etc.).
"""

from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql


revision: str = "0005"
down_revision: Union[str, None] = "0004"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Create financial_accounts table."""
    op.create_table(
        "financial_accounts",
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
        sa.Column(
            "account_type",
            sa.String(20),
            nullable=False,
            server_default="ASSET",
        ),
        sa.Column("currency_code", sa.String(3), nullable=False, server_default="CNY"),
        sa.Column(
            "initial_balance",
            sa.Numeric(precision=20, scale=8),
            nullable=False,
            server_default="0",
        ),
        sa.Column(
            "current_balance",
            sa.Numeric(precision=20, scale=8),
            nullable=False,
            server_default="0",
        ),
        sa.Column("icon", sa.String(50), nullable=True),
        sa.Column("color", sa.String(20), nullable=True),
        sa.Column("description", sa.Text, nullable=True),
        sa.Column("is_included_in_total", sa.Boolean, nullable=False, server_default="true"),
        sa.Column("is_archived", sa.Boolean, nullable=False, server_default="false"),
        sa.Column("display_order", sa.Integer, nullable=False, server_default="0"),
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
    
    op.create_index("ix_financial_accounts_user_uuid", "financial_accounts", ["user_uuid"])
    op.create_index("ix_financial_accounts_type", "financial_accounts", ["account_type"])


def downgrade() -> None:
    """Drop financial_accounts table."""
    op.drop_index("ix_financial_accounts_type")
    op.drop_index("ix_financial_accounts_user_uuid")
    op.drop_table("financial_accounts")
