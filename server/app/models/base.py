"""Base models and common imports for all models."""
from __future__ import annotations

from datetime import UTC, datetime

from sqlalchemy.types import DateTime
from sqlmodel import Field, SQLModel


def utc_now() -> datetime:
    """Get current UTC time with timezone info."""
    return datetime.now(UTC)


class BaseModel(SQLModel):
    """Base model with common fields.

    All datetime fields use timezone-aware datetimes (UTC).
    PostgreSQL stores them as timestamptz.

    Note: We use sa_type to specify DateTime with timezone support.
    This avoids Column object sharing issues across multiple tables.
    """

    created_at: datetime = Field(default_factory=utc_now, sa_type=DateTime(timezone=True), nullable=False)
    updated_at: datetime = Field(default_factory=utc_now, sa_type=DateTime(timezone=True), nullable=False)
