from __future__ import annotations

from datetime import datetime
from typing import Any, TYPE_CHECKING
from uuid import UUID

from sqlalchemy import Index, String
from sqlalchemy.orm import Mapped, mapped_column

from app.models.base import Base, col, utc_now

if TYPE_CHECKING:
    pass


class GenUISurface(Base):
    """GenUI Surface persistence model.

    Stores the state of active UI components (Surfaces) to enable
    reactive updates across multiple requests in the same session.

    This model fulfills the GenUI principle of 'Server-side awareness of client state'.
    """

    __tablename__ = "genui_surfaces"

    # Session this surface belongs to (Maps to Thread ID in LangGraph)
    session_id: Mapped[UUID] = mapped_column(index=True, primary_key=True)

    # Unique identifier for the Surface (e.g. 'surface_001')
    # Use String here as it's often a custom formatted ID
    surface_id: Mapped[str] = mapped_column(String(255), primary_key=True)

    # The type of component being rendered (e.g. 'TransactionReceipt')
    component_type: Mapped[str] = mapped_column(String(100), index=True)

    # Optional tool call ID that generated this surface
    tool_call_id: Mapped[str | None] = mapped_column(String(100), nullable=True)

    # The full reactive data model for this surface
    data: Mapped[dict[str, Any]] = col.jsonb_column()

    # Lifecycle timestamps
    created_at: Mapped[datetime] = col.timestamptz(default=utc_now)
    last_updated_at: Mapped[datetime] = col.timestamptz(default=utc_now)

    # Is the surface essentially 'deleted' from view but kept in DB for history?
    is_active: Mapped[bool] = mapped_column(default=True, server_default="true")

    # Index for fast lookup of the most recent reusable surface of a specific type in a session
    __table_args__ = (
        Index(
            "ix_genui_session_component_recent",
            "session_id",
            "component_type",
            "is_active",
            "last_updated_at",
        ),
    )

    def __repr__(self) -> str:
        return f"<GenUISurface(session_id={self.session_id}, surface_id={self.surface_id}, type={self.component_type})>"
