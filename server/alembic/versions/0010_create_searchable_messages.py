"""Create searchable_messages table.

Revision ID: 0010
Revises: 0009
Create Date: 2026-01-01

Searchable chat message index.
"""

from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql


revision: str = "0010"
down_revision: Union[str, None] = "0009"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Create searchable_messages table."""
    op.create_table(
        "searchable_messages",
        # Model uses: id (UUID primary key)
        sa.Column(
            "id",
            postgresql.UUID(as_uuid=True),
            primary_key=True,
            server_default=sa.text("gen_random_uuid()"),
        ),
        # Model uses: thread_id (UUID)
        sa.Column(
            "thread_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("sessions.id", ondelete="CASCADE"),
            nullable=False,
        ),
        # Model uses: user_uuid (UUID)
        sa.Column(
            "user_uuid",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.uuid", ondelete="CASCADE"),
            nullable=False,
        ),
        # Model uses: role
        sa.Column("role", sa.String(20), nullable=False),
        # Model uses: content
        sa.Column("content", sa.Text, nullable=False),
        # BaseModel fields
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

    op.create_index("ix_searchable_messages_user_uuid", "searchable_messages", ["user_uuid"])
    op.create_index("ix_searchable_messages_thread_id", "searchable_messages", ["thread_id"])

    # Full-text search index on content
    op.execute("""
        CREATE INDEX ix_searchable_messages_content_gin
        ON searchable_messages
        USING gin(to_tsvector('simple', content))
    """)


def downgrade() -> None:
    """Drop searchable_messages table."""
    op.execute("DROP INDEX IF EXISTS ix_searchable_messages_content_gin")
    op.drop_index("ix_searchable_messages_thread_id")
    op.drop_index("ix_searchable_messages_user_uuid")
    op.drop_table("searchable_messages")
