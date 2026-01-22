"""Session model for storing chat sessions.

This model has been migrated to SQLAlchemy 2.0 with Mapped[...] annotations.
"""

from __future__ import annotations

from datetime import UTC, datetime
from typing import TYPE_CHECKING
from uuid import UUID, uuid4 as uuid4_factory

from sqlalchemy.orm import Mapped, mapped_column

from app.models.base import Base, col

if TYPE_CHECKING:
    pass


class Session(Base):
    """Session model for storing chat sessions.

    Attributes:
        id: The primary key (UUID)
        user_uuid: User's UUID
        name: Name of the session (defaults to empty string)
        created_at: When the session was created
        updated_at: When the session was updated
    """

    __tablename__ = "sessions"

    id: Mapped[UUID] = col.uuid_pk(uuid4_factory)
    user_uuid: Mapped[UUID] = col.uuid_column(index=True)
    name: Mapped[str] = mapped_column(default="")
    created_at: Mapped[datetime] = col.timestamptz()
    updated_at: Mapped[datetime | None] = col.timestamptz(nullable=True)
