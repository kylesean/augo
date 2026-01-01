"""Create storage_configs and attachments tables.

Revision ID: 0004
Revises: 0003
Create Date: 2026-01-01

File storage configuration and attachment management.
"""

from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql


revision: str = "0004"
down_revision: Union[str, None] = "0003"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Create storage tables."""
    
    # storage_configs
    op.create_table(
        "storage_configs",
        sa.Column("id", sa.Integer, primary_key=True, autoincrement=True),
        sa.Column(
            "user_uuid",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.uuid", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("provider_type", sa.String(50), nullable=False),
        sa.Column("name", sa.String(100), nullable=False),
        sa.Column("base_path", sa.String(255), nullable=False),
        sa.Column("credentials", postgresql.JSONB, nullable=True, server_default=sa.text("'{}'::jsonb")),
        sa.Column("is_readonly", sa.Boolean, nullable=False, server_default="true"),
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
    op.create_index("ix_storage_configs_user_uuid", "storage_configs", ["user_uuid"])
    
    # attachments
    op.create_table(
        "attachments",
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
        sa.Column(
            "storage_config_id",
            sa.Integer,
            sa.ForeignKey("storage_configs.id", ondelete="SET NULL"),
            nullable=True,
        ),
        sa.Column("thread_id", sa.Text, nullable=True),
        sa.Column("filename", sa.String(255), nullable=False),
        sa.Column("object_key", sa.String(1024), nullable=False),
        sa.Column("mime_type", sa.String(100), nullable=True),
        sa.Column("size", sa.BigInteger, nullable=True),
        sa.Column("hash", sa.String(64), nullable=True),
        sa.Column("meta_info", postgresql.JSONB, nullable=True, server_default=sa.text("'{}'::jsonb")),
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
    op.create_index("ix_attachments_user_uuid", "attachments", ["user_uuid"])
    op.create_index("ix_attachments_storage_config_id", "attachments", ["storage_config_id"])
    op.create_index("ix_attachments_thread_id", "attachments", ["thread_id"])
    op.create_index("ix_attachments_hash", "attachments", ["hash"])


def downgrade() -> None:
    """Drop storage tables."""
    op.drop_table("attachments")
    op.drop_table("storage_configs")
