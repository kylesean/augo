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
            "session_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("sessions.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("message_id", sa.String(100), nullable=False),
        sa.Column("role", sa.String(20), nullable=False),
        sa.Column("content", sa.Text, nullable=False),
        sa.Column("content_type", sa.String(50), nullable=True, server_default="text"),
        sa.Column("metadata", postgresql.JSONB, nullable=True),
        sa.Column(
            "message_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.text("CURRENT_TIMESTAMP"),
        ),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.text("CURRENT_TIMESTAMP"),
        ),
    )
    
    op.create_index("ix_searchable_messages_user_uuid", "searchable_messages", ["user_uuid"])
    op.create_index("ix_searchable_messages_session_id", "searchable_messages", ["session_id"])
    op.create_index("ix_searchable_messages_message_at", "searchable_messages", ["message_at"])
    
    # Full-text search index on content
    op.execute("""
        CREATE INDEX ix_searchable_messages_content_gin 
        ON searchable_messages 
        USING gin(to_tsvector('simple', content))
    """)


def downgrade() -> None:
    """Drop searchable_messages table."""
    op.execute("DROP INDEX IF EXISTS ix_searchable_messages_content_gin")
    op.drop_index("ix_searchable_messages_message_at")
    op.drop_index("ix_searchable_messages_session_id")
    op.drop_index("ix_searchable_messages_user_uuid")
    op.drop_table("searchable_messages")
