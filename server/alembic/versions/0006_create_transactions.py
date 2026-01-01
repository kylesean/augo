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
    # transactions - Core transaction records (matches Transaction model)
    # =========================================================================
    op.create_table(
        "transactions",
        # Primary key is UUID (matches model: id: Optional[UUID])
        sa.Column(
            "id",
            postgresql.UUID(as_uuid=True),
            primary_key=True,
            server_default=sa.text("gen_random_uuid()"),
        ),
        sa.Column(
            "user_uuid",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.uuid", ondelete="CASCADE"),
            nullable=False,
        ),
        # Model uses: type: str (not transaction_type)
        sa.Column("type", sa.String(20), nullable=False),
        # Account references are UUID (foreign key to financial_accounts.id which is now UUID)
        sa.Column(
            "source_account_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("financial_accounts.id", ondelete="SET NULL"),
            nullable=True,
        ),
        sa.Column(
            "target_account_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("financial_accounts.id", ondelete="SET NULL"),
            nullable=True,
        ),
        # Model uses: amount_original and amount
        sa.Column("amount_original", sa.Numeric(precision=20, scale=8), nullable=False),
        sa.Column("amount", sa.Numeric(precision=20, scale=8), nullable=False),
        # Model uses: currency (not source_currency/target_currency)
        sa.Column("currency", sa.String(3), nullable=False, server_default="CNY"),
        sa.Column("exchange_rate", sa.Numeric(precision=20, scale=8), nullable=True),
        sa.Column(
            "transaction_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.text("CURRENT_TIMESTAMP"),
        ),
        # Model uses: transaction_timezone
        sa.Column("transaction_timezone", sa.String(50), nullable=False, server_default="UTC"),
        sa.Column("tags", postgresql.JSONB, nullable=True),
        sa.Column("location", sa.String(255), nullable=True),
        # Model uses: latitude, longitude
        sa.Column("latitude", sa.Numeric(precision=9, scale=6), nullable=True),
        sa.Column("longitude", sa.Numeric(precision=9, scale=6), nullable=True),
        sa.Column("source", sa.String(20), nullable=False, server_default="MANUAL"),
        sa.Column("status", sa.String(20), nullable=False, server_default="CLEARED"),
        sa.Column("description", sa.Text, nullable=True),
        # Model uses: raw_input with default=""
        sa.Column("raw_input", sa.Text, nullable=False, server_default=""),
        sa.Column("category_key", sa.String(25), nullable=False, server_default=""),
        # Model uses: subject, intent
        sa.Column("subject", sa.String(20), nullable=False, server_default="SELF"),
        sa.Column("intent", sa.String(20), nullable=False, server_default="SURVIVAL"),
        sa.Column("source_thread_id", postgresql.UUID(as_uuid=True), nullable=True),
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
    op.create_index("ix_transactions_source_account_id", "transactions", ["source_account_id"])
    op.create_index("ix_transactions_target_account_id", "transactions", ["target_account_id"])
    
    # =========================================================================
    # transaction_comments - Comments on transactions (matches TransactionComment model)
    # =========================================================================
    op.create_table(
        "transaction_comments",
        # Model uses: id: Optional[int] (auto-increment)
        sa.Column("id", sa.Integer, primary_key=True, autoincrement=True),
        # Model uses: transaction_id: UUID (references transactions.id which is now UUID)
        sa.Column(
            "transaction_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("transactions.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "user_uuid",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.uuid", ondelete="CASCADE"),
            nullable=False,
        ),
        # Model uses: parent_comment_id, comment_text, mentioned_user_ids
        sa.Column(
            "parent_comment_id",
            sa.Integer,
            sa.ForeignKey("transaction_comments.id", ondelete="CASCADE"),
            nullable=True,
        ),
        sa.Column("comment_text", sa.Text, nullable=False),
        sa.Column("mentioned_user_ids", postgresql.JSONB, nullable=True),
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
    op.create_index("ix_transaction_comments_user_uuid", "transaction_comments", ["user_uuid"])
    
    # =========================================================================
    # transaction_shares - Shared transactions (matches TransactionShare model)
    # =========================================================================
    op.create_table(
        "transaction_shares",
        # Model uses: id: Optional[UUID]
        sa.Column(
            "id",
            postgresql.UUID(as_uuid=True),
            primary_key=True,
            server_default=sa.text("gen_random_uuid()"),
        ),
        # Model uses: transaction_id: UUID
        sa.Column(
            "transaction_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("transactions.id", ondelete="CASCADE"),
            nullable=False,
        ),
        # Model uses: sharer_user_uuid, shared_with_user_uuid
        sa.Column(
            "sharer_user_uuid",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.uuid", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "shared_with_user_uuid",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.uuid", ondelete="CASCADE"),
            nullable=False,
        ),
        # Model uses: can_view, shared_at, expires_at
        sa.Column("can_view", sa.Boolean, nullable=False, server_default="true"),
        sa.Column("shared_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("expires_at", sa.DateTime(timezone=True), nullable=False),
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
    op.create_index("ix_transaction_shares_sharer_user_uuid", "transaction_shares", ["sharer_user_uuid"])
    op.create_index("ix_transaction_shares_shared_with_user_uuid", "transaction_shares", ["shared_with_user_uuid"])
    
    # =========================================================================
    # recurring_transactions - Recurring transaction rules (matches RecurringTransaction model)
    # =========================================================================
    op.create_table(
        "recurring_transactions",
        # Model uses: id: Optional[UUID]
        sa.Column(
            "id",
            postgresql.UUID(as_uuid=True),
            primary_key=True,
            server_default=sa.text("gen_random_uuid()"),
        ),
        sa.Column(
            "user_uuid",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.uuid", ondelete="CASCADE"),
            nullable=False,
        ),
        # Model uses: type (not transaction_type)
        sa.Column("type", sa.String(20), nullable=False),
        # Model uses: source_account_id, target_account_id as UUID
        sa.Column("source_account_id", postgresql.UUID(as_uuid=True), nullable=True),
        sa.Column("target_account_id", postgresql.UUID(as_uuid=True), nullable=True),
        # Model uses: amount_type, requires_confirmation
        sa.Column("amount_type", sa.String(20), nullable=False, server_default="FIXED"),
        sa.Column("requires_confirmation", sa.Boolean, nullable=False, server_default="false"),
        sa.Column("amount", sa.Numeric(precision=28, scale=8), nullable=False),
        sa.Column("currency", sa.String(3), nullable=False, server_default="CNY"),
        sa.Column("category_key", sa.String(50), nullable=False, server_default="OTHERS"),
        sa.Column("tags", postgresql.JSONB, nullable=True),
        # Model uses: recurrence_rule (not rrule)
        sa.Column("recurrence_rule", sa.String(255), nullable=False),
        sa.Column("timezone", sa.String(50), nullable=False, server_default="Asia/Shanghai"),
        sa.Column("start_date", sa.Date, nullable=False),
        sa.Column("end_date", sa.Date, nullable=True),
        # Model uses: exception_dates, last_generated_at, next_execution_at
        sa.Column("exception_dates", postgresql.JSONB, nullable=True),
        sa.Column("last_generated_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("next_execution_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("description", sa.Text, nullable=True),
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
    
    op.drop_index("ix_transaction_shares_shared_with_user_uuid")
    op.drop_index("ix_transaction_shares_sharer_user_uuid")
    op.drop_index("ix_transaction_shares_transaction_id")
    op.drop_table("transaction_shares")
    
    op.drop_index("ix_transaction_comments_user_uuid")
    op.drop_index("ix_transaction_comments_transaction_id")
    op.drop_table("transaction_comments")
    
    op.drop_index("ix_transactions_target_account_id")
    op.drop_index("ix_transactions_source_account_id")
    op.drop_index("ix_transactions_source_thread_id")
    op.drop_index("ix_transactions_status")
    op.drop_index("ix_transactions_category")
    op.drop_index("ix_transactions_transaction_at")
    op.drop_index("ix_transactions_user_uuid")
    op.drop_table("transactions")
