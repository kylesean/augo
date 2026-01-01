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
    # shared_spaces - Collaborative financial spaces (matches SharedSpace model)
    # =========================================================================
    op.create_table(
        "shared_spaces",
        # Model uses: id: Optional[UUID]
        sa.Column(
            "id",
            postgresql.UUID(as_uuid=True),
            primary_key=True,
            server_default=sa.text("gen_random_uuid()"),
        ),
        sa.Column("name", sa.String(50), nullable=False),
        # Model uses: creator_uuid (not owner_uuid)
        sa.Column(
            "creator_uuid",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.uuid", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("status", sa.String(50), nullable=False, server_default="ACTIVE"),
        sa.Column("description", sa.Text, nullable=True),
        # Model uses: invite_code, invite_code_expires_at
        sa.Column("invite_code", sa.String(20), nullable=True),
        sa.Column("invite_code_expires_at", sa.DateTime(timezone=True), nullable=True),
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
    
    op.create_index("ix_shared_spaces_creator_uuid", "shared_spaces", ["creator_uuid"])
    
    # =========================================================================
    # space_members - Space membership (matches SpaceMember model)
    # Composite primary key: (space_id, user_uuid)
    # =========================================================================
    op.create_table(
        "space_members",
        # Model uses composite primary key: space_id + user_uuid (both UUID)
        sa.Column(
            "space_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("shared_spaces.id", ondelete="CASCADE"),
            primary_key=True,
            nullable=False,
        ),
        sa.Column(
            "user_uuid",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.uuid", ondelete="CASCADE"),
            primary_key=True,
            nullable=False,
        ),
        sa.Column("role", sa.String(50), nullable=False, server_default="MEMBER"),
        sa.Column("status", sa.String(50), nullable=False, server_default="ACCEPTED"),
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
    
    # =========================================================================
    # space_transactions - Transactions within shared spaces (matches SpaceTransaction model)
    # =========================================================================
    op.create_table(
        "space_transactions",
        # Model uses: id: Optional[UUID]
        sa.Column(
            "id",
            postgresql.UUID(as_uuid=True),
            primary_key=True,
            server_default=sa.text("gen_random_uuid()"),
        ),
        # Model uses: space_id, transaction_id, added_by_user_uuid (all UUID)
        sa.Column(
            "space_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("shared_spaces.id", ondelete="NO ACTION"),
            nullable=False,
        ),
        sa.Column(
            "transaction_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("transactions.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "added_by_user_uuid",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.uuid", ondelete="CASCADE"),
            nullable=False,
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
    
    op.create_index("ix_space_transactions_space_id", "space_transactions", ["space_id"])
    op.create_index("ix_space_transactions_transaction_id", "space_transactions", ["transaction_id"])
    
    # Add deferred FK constraint for budgets.shared_space_id (table created in 0007)
    op.create_foreign_key(
        "fk_budgets_shared_space_id",
        "budgets",
        "shared_spaces",
        ["shared_space_id"],
        ["id"],
        ondelete="SET NULL",
    )


def downgrade() -> None:
    """Drop shared_spaces tables."""
    # Drop deferred FK first
    op.drop_constraint("fk_budgets_shared_space_id", "budgets", type_="foreignkey")
    
    op.drop_index("ix_space_transactions_transaction_id")
    op.drop_index("ix_space_transactions_space_id")
    op.drop_table("space_transactions")
    
    op.drop_index("ix_space_members_user_uuid")
    op.drop_index("ix_space_members_space_id")
    op.drop_table("space_members")
    
    op.drop_index("ix_shared_spaces_creator_uuid")
    op.drop_table("shared_spaces")
