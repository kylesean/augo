"""Create users and user_settings tables.

Revision ID: 0002
Revises: 0001
Create Date: 2026-01-01

Core user authentication and profile tables.
"""

from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql


revision: str = "0002"
down_revision: Union[str, None] = "0001"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Create users and user_settings tables."""
    
    # =========================================================================
    # users - Core user authentication table
    # =========================================================================
    op.create_table(
        "users",
        sa.Column("id", sa.Integer, primary_key=True, autoincrement=True),
        sa.Column(
            "uuid",
            postgresql.UUID(as_uuid=True),
            nullable=False,
            unique=True,
            server_default=sa.text("gen_random_uuid()"),
        ),
        sa.Column("username", sa.String(50), nullable=True),
        sa.Column("email", sa.String(255), nullable=True, unique=True),
        sa.Column("mobile", sa.String(20), nullable=True, unique=True),
        sa.Column("hashed_password", sa.String(255), nullable=True),
        sa.Column("avatar_url", sa.String(500), nullable=True),
        sa.Column("timezone", sa.String(50), nullable=True, server_default="UTC"),
        sa.Column(
            "registration_type",
            sa.String(20),
            nullable=False,
            server_default="email",
        ),
        sa.Column("last_login_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("last_login_ip", sa.String(45), nullable=True),
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
    
    # Indexes for users
    op.create_index("ix_users_uuid", "users", ["uuid"])
    op.create_index("ix_users_email", "users", ["email"])
    op.create_index("ix_users_mobile", "users", ["mobile"])
    
    # =========================================================================
    # user_settings - User preferences
    # =========================================================================
    op.create_table(
        "user_settings",
        sa.Column("id", sa.Integer, primary_key=True, autoincrement=True),
        sa.Column(
            "user_uuid",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.uuid", ondelete="CASCADE"),
            nullable=False,
            unique=True,
        ),
        sa.Column("primary_currency", sa.String(3), nullable=False, server_default="CNY"),
        sa.Column("timezone", sa.String(50), nullable=True, server_default="Asia/Shanghai"),
        sa.Column("average_daily_spending", sa.String(20), nullable=True),
        sa.Column("safety_balance", sa.String(20), nullable=True),
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
    
    op.create_index("ix_user_settings_user_uuid", "user_settings", ["user_uuid"])


def downgrade() -> None:
    """Drop users and user_settings tables."""
    op.drop_index("ix_user_settings_user_uuid")
    op.drop_table("user_settings")
    
    op.drop_index("ix_users_mobile")
    op.drop_index("ix_users_email")
    op.drop_index("ix_users_uuid")
    op.drop_table("users")
