"""Create shared_spaces tables.

Revision ID: 0008
Revises: 0007
Create Date: 2026-01-01

Shared financial spaces for collaborative budgeting.
"""

from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql


revision: str = "0008"
down_revision: Union[str, None] = "0007"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Create shared_spaces tables."""
    
    # =========================================================================
    # shared_spaces - Collaborative financial spaces
    # =========================================================================
    op.create_table(
        "shared_spaces",
        sa.Column("id", sa.Integer, primary_key=True, autoincrement=True),
        sa.Column(
            "uuid",
            postgresql.UUID(as_uuid=True),
            nullable=False,
            unique=True,
            server_default=sa.text("gen_random_uuid()"),
        ),
        sa.Column("name", sa.String(100), nullable=False),
        sa.Column("description", sa.Text, nullable=True),
        sa.Column("icon", sa.String(50), nullable=True),
        sa.Column("color", sa.String(20), nullable=True),
        sa.Column(
            "owner_uuid",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.uuid", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("currency", sa.String(3), nullable=False, server_default="CNY"),
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
    
    op.create_index("ix_shared_spaces_owner_uuid", "shared_spaces", ["owner_uuid"])
    
    # =========================================================================
    # space_members - Space membership
    # =========================================================================
    op.create_table(
        "space_members",
        sa.Column("id", sa.Integer, primary_key=True, autoincrement=True),
        sa.Column(
            "uuid",
            postgresql.UUID(as_uuid=True),
            nullable=False,
            unique=True,
            server_default=sa.text("gen_random_uuid()"),
        ),
        sa.Column(
            "space_id",
            sa.Integer,
            sa.ForeignKey("shared_spaces.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "user_uuid",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.uuid", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("role", sa.String(20), nullable=False, server_default="member"),
        sa.Column("is_active", sa.Boolean, nullable=False, server_default="true"),
        sa.Column("joined_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.text("CURRENT_TIMESTAMP")),
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
    
    op.create_index("ix_space_members_space_id", "space_members", ["space_id"])
    op.create_index("ix_space_members_user_uuid", "space_members", ["user_uuid"])
    op.create_unique_constraint("uq_space_member", "space_members", ["space_id", "user_uuid"])
    
    # =========================================================================
    # space_transactions - Transactions within shared spaces
    # =========================================================================
    op.create_table(
        "space_transactions",
        sa.Column("id", sa.Integer, primary_key=True, autoincrement=True),
        sa.Column(
            "uuid",
            postgresql.UUID(as_uuid=True),
            nullable=False,
            unique=True,
            server_default=sa.text("gen_random_uuid()"),
        ),
        sa.Column(
            "space_id",
            sa.Integer,
            sa.ForeignKey("shared_spaces.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "transaction_id",
            sa.Integer,
            sa.ForeignKey("transactions.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "added_by_uuid",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.uuid", ondelete="SET NULL"),
            nullable=True,
        ),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.text("CURRENT_TIMESTAMP"),
        ),
    )
    
    op.create_index("ix_space_transactions_space_id", "space_transactions", ["space_id"])
    op.create_index("ix_space_transactions_transaction_id", "space_transactions", ["transaction_id"])


def downgrade() -> None:
    """Drop shared_spaces tables."""
    op.drop_index("ix_space_transactions_transaction_id")
    op.drop_index("ix_space_transactions_space_id")
    op.drop_table("space_transactions")
    
    op.drop_constraint("uq_space_member", "space_members")
    op.drop_index("ix_space_members_user_uuid")
    op.drop_index("ix_space_members_space_id")
    op.drop_table("space_members")
    
    op.drop_index("ix_shared_spaces_owner_uuid")
    op.drop_table("shared_spaces")
