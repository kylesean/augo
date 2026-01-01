"""Enable PostgreSQL extensions.

Revision ID: 0001
Revises: None
Create Date: 2026-01-01

Enables required PostgreSQL extensions:
- uuid-ossp: UUID generation functions
- pgvector: Vector similarity search (for AI features)
"""

from typing import Sequence, Union

from alembic import op


revision: str = "0001"
down_revision: Union[str, None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Enable PostgreSQL extensions."""
    # UUID generation
    op.execute('CREATE EXTENSION IF NOT EXISTS "uuid-ossp"')
    
    # Vector similarity search (required for Mem0 and AI features)
    op.execute('CREATE EXTENSION IF NOT EXISTS "vector"')


def downgrade() -> None:
    """Disable extensions (use with caution)."""
    # Note: Dropping extensions may fail if objects depend on them
    op.execute('DROP EXTENSION IF EXISTS "vector"')
    op.execute('DROP EXTENSION IF EXISTS "uuid-ossp"')
