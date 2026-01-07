"""Create sessions table.

Revision ID: 0003
Revises: 0002
Create Date: 2026-01-01

Chat session management table.
"""

from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql


revision: str = "0003"
down_revision: Union[str, None] = "0002"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Create sessions table."""
    op.create_table(
        "sessions",
        # Model uses: id: uuid (primary key)
        sa.Column(
            "id",
            postgresql.UUID(as_uuid=True),
            primary_key=True,
            server_default=sa.text("gen_random_uuid()"),
        ),
        # Model uses: user_uuid
        sa.Column(
            "user_uuid",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.uuid", ondelete="CASCADE"),
            nullable=False,
        ),
        # Model uses: name (NOT title)
        sa.Column("name", sa.String(255), nullable=False, server_default=""),
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

    op.create_index("ix_sessions_user_uuid", "sessions", ["user_uuid"])
    op.create_index("ix_sessions_created_at", "sessions", ["created_at"])


def downgrade() -> None:
    """Drop sessions table."""
    op.drop_index("ix_sessions_created_at")
    op.drop_index("ix_sessions_user_uuid")
    op.drop_table("sessions")
