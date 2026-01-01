"""Create transactions and related tables.

Revision ID: 0006
Revises: 0005
Create Date: 2026-01-01

Transaction management including comments, shares, and recurring transactions.
"""

from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql


revision: str = "0006"
down_revision: Union[str, None] = "0005"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Create transactions and related tables."""
    
    # =========================================================================
    # transactions - Core transaction records
    # =========================================================================
    op.create_table(
        "transactions",
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
        sa.Column(
            "transaction_type",
            sa.String(20),
            nullable=False,
        ),
        sa.Column(
            "source_account_id",
            sa.Integer,
            sa.ForeignKey("financial_accounts.id", ondelete="SET NULL"),
            nullable=True,
        ),
        sa.Column(
            "target_account_id",
            sa.Integer,
            sa.ForeignKey("financial_accounts.id", ondelete="SET NULL"),
            nullable=True,
        ),
        sa.Column(
            "amount",
            sa.Numeric(precision=20, scale=8),
            nullable=False,
        ),
        sa.Column(
            "source_currency",
            sa.String(3),
            nullable=True,
        ),
        sa.Column(
            "target_currency",
            sa.String(3),
            nullable=True,
        ),
        sa.Column(
            "target_amount",
            sa.Numeric(precision=20, scale=8),
            nullable=True,
        ),
        sa.Column(
            "exchange_rate",
            sa.Numeric(precision=20, scale=10),
            nullable=True,
        ),
        sa.Column(
            "transaction_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.text("CURRENT_TIMESTAMP"),
        ),
        sa.Column("tags", postgresql.JSONB, nullable=True),
        sa.Column("location", sa.String(255), nullable=True),
        sa.Column("source", sa.String(50), nullable=True, server_default="manual"),
        sa.Column("status", sa.String(20), nullable=False, server_default="CLEARED"),
        sa.Column("description", sa.Text, nullable=True),
        sa.Column("raw_input", sa.Text, nullable=True),
        sa.Column("category_key", sa.String(50), nullable=True),
        sa.Column("subject", sa.String(100), nullable=True),
        sa.Column("intent", sa.String(50), nullable=True),
        sa.Column(
            "source_thread_id",
            postgresql.UUID(as_uuid=True),
            nullable=True,
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
    
    op.create_index("ix_transactions_user_uuid", "transactions", ["user_uuid"])
    op.create_index("ix_transactions_transaction_at", "transactions", ["transaction_at"])
    op.create_index("ix_transactions_category", "transactions", ["category_key"])
    op.create_index("ix_transactions_status", "transactions", ["status"])
    op.create_index("ix_transactions_source_thread_id", "transactions", ["source_thread_id"])
    
    # =========================================================================
    # transaction_comments - Comments on transactions
    # =========================================================================
    op.create_table(
        "transaction_comments",
        sa.Column("id", sa.Integer, primary_key=True, autoincrement=True),
        sa.Column(
            "uuid",
            postgresql.UUID(as_uuid=True),
            nullable=False,
            unique=True,
            server_default=sa.text("gen_random_uuid()"),
        ),
        sa.Column(
            "transaction_id",
            sa.Integer,
            sa.ForeignKey("transactions.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "user_uuid",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.uuid", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("content", sa.Text, nullable=False),
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
    
    op.create_index("ix_transaction_comments_transaction_id", "transaction_comments", ["transaction_id"])
    
    # =========================================================================
    # transaction_shares - Shared transactions (split bills)
    # =========================================================================
    op.create_table(
        "transaction_shares",
        sa.Column("id", sa.Integer, primary_key=True, autoincrement=True),
        sa.Column(
            "uuid",
            postgresql.UUID(as_uuid=True),
            nullable=False,
            unique=True,
            server_default=sa.text("gen_random_uuid()"),
        ),
        sa.Column(
            "transaction_id",
            sa.Integer,
            sa.ForeignKey("transactions.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "payer_uuid",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.uuid", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "participant_uuid",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.uuid", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "share_amount",
            sa.Numeric(precision=20, scale=8),
            nullable=False,
        ),
        sa.Column("is_settled", sa.Boolean, nullable=False, server_default="false"),
        sa.Column("settled_at", sa.DateTime(timezone=True), nullable=True),
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
    
    op.create_index("ix_transaction_shares_transaction_id", "transaction_shares", ["transaction_id"])
    op.create_index("ix_transaction_shares_payer_uuid", "transaction_shares", ["payer_uuid"])
    op.create_index("ix_transaction_shares_participant_uuid", "transaction_shares", ["participant_uuid"])
    
    # =========================================================================
    # recurring_transactions - Recurring transaction rules
    # =========================================================================
    op.create_table(
        "recurring_transactions",
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
            "transaction_type",
            sa.String(20),
            nullable=False,
        ),
        sa.Column(
            "source_account_id",
            sa.Integer,
            sa.ForeignKey("financial_accounts.id", ondelete="SET NULL"),
            nullable=True,
        ),
        sa.Column(
            "target_account_id",
            sa.Integer,
            sa.ForeignKey("financial_accounts.id", ondelete="SET NULL"),
            nullable=True,
        ),
        sa.Column(
            "amount",
            sa.Numeric(precision=20, scale=8),
            nullable=False,
        ),
        sa.Column("currency", sa.String(3), nullable=False, server_default="CNY"),
        sa.Column("category_key", sa.String(50), nullable=True),
        sa.Column("description", sa.Text, nullable=True),
        sa.Column("rrule", sa.Text, nullable=False),
        sa.Column("start_date", sa.Date, nullable=False),
        sa.Column("end_date", sa.Date, nullable=True),
        sa.Column("last_generated_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("is_active", sa.Boolean, nullable=False, server_default="true"),
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
    
    op.create_index("ix_recurring_transactions_user_uuid", "recurring_transactions", ["user_uuid"])
    op.create_index("ix_recurring_transactions_active", "recurring_transactions", ["is_active"])


def downgrade() -> None:
    """Drop transactions and related tables."""
    op.drop_index("ix_recurring_transactions_active")
    op.drop_index("ix_recurring_transactions_user_uuid")
    op.drop_table("recurring_transactions")
    
    op.drop_index("ix_transaction_shares_participant_uuid")
    op.drop_index("ix_transaction_shares_payer_uuid")
    op.drop_index("ix_transaction_shares_transaction_id")
    op.drop_table("transaction_shares")
    
    op.drop_index("ix_transaction_comments_transaction_id")
    op.drop_table("transaction_comments")
    
    op.drop_index("ix_transactions_source_thread_id")
    op.drop_index("ix_transactions_status")
    op.drop_index("ix_transactions_category")
    op.drop_index("ix_transactions_transaction_at")
    op.drop_index("ix_transactions_user_uuid")
    op.drop_table("transactions")
