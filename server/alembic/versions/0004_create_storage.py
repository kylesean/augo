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
    
    # =========================================================================
    # storage_configs - S3/local storage configuration
    # =========================================================================
    op.create_table(
        "storage_configs",
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
            "provider_type",
            sa.String(20),
            nullable=False,
            server_default="local",
        ),
        sa.Column("endpoint_url", sa.String(500), nullable=True),
        sa.Column("bucket_name", sa.String(100), nullable=True),
        sa.Column("access_key_id", sa.String(255), nullable=True),
        sa.Column("secret_access_key_encrypted", sa.Text, nullable=True),
        sa.Column("region", sa.String(50), nullable=True),
        sa.Column("base_path", sa.String(255), nullable=True),
        sa.Column("is_default", sa.Boolean, nullable=False, server_default="false"),
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
    
    op.create_index("ix_storage_configs_user_uuid", "storage_configs", ["user_uuid"])
    
    # =========================================================================
    # attachments - File attachments
    # =========================================================================
    op.create_table(
        "attachments",
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
            "storage_config_id",
            sa.Integer,
            sa.ForeignKey("storage_configs.id", ondelete="SET NULL"),
            nullable=True,
        ),
        sa.Column("original_filename", sa.String(255), nullable=False),
        sa.Column("stored_filename", sa.String(255), nullable=False),
        sa.Column("file_path", sa.String(500), nullable=False),
        sa.Column("file_size", sa.BigInteger, nullable=False),
        sa.Column("mime_type", sa.String(100), nullable=False),
        sa.Column("file_hash", sa.String(64), nullable=True),
        sa.Column("entity_type", sa.String(50), nullable=True),
        sa.Column("entity_id", sa.String(50), nullable=True),
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
    op.create_index("ix_attachments_entity", "attachments", ["entity_type", "entity_id"])


def downgrade() -> None:
    """Drop storage tables."""
    op.drop_index("ix_attachments_entity")
    op.drop_index("ix_attachments_user_uuid")
    op.drop_table("attachments")
    
    op.drop_index("ix_storage_configs_user_uuid")
    op.drop_table("storage_configs")
