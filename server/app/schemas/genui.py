"""GenUI Event and Component Schemas

This module defines the data structures for Generative UI events and components,
supporting both real-time streaming and historical message restoration using Pydantic.

Schema Version: 2.0 (Refactored)
"""
from __future__ import annotations

from enum import Enum
from typing import Any

from pydantic import BaseModel, ConfigDict
from pydantic.alias_generators import to_camel

# ============================================================================
# Event Type Enums
# ============================================================================


class GenUIEventType(str, Enum):
    """GenUI event type enum.

    Eliminates magic strings and provides type-safe event type references.
    """

    # Session lifecycle
    SESSION_INIT = "session_init"
    DONE = "done"
    ERROR = "error"

    # Text stream
    TEXT_DELTA = "text_delta"
    REASONING_DELTA = "reasoning_delta"

    # Tool calls
    TOOL_CALL_START = "tool_call_start"
    TOOL_CALL_END = "tool_call_end"

    # UI components
    A2UI_MESSAGE = "a2ui_message"

    # Metadata
    TITLE_UPDATE = "title_update"


class UIComponentMode(str, Enum):
    """UI component rendering mode."""

    LIVE = "live"
    HISTORICAL = "historical"


# ============================================================================
# Core Data Models
# ============================================================================


class UIComponentData(BaseModel):
    """Complete UI component data for rendering."""

    model_config = ConfigDict(alias_generator=to_camel, populate_by_name=True)

    surface_id: str
    component_type: str
    data: dict[str, Any]
    mode: UIComponentMode = UIComponentMode.LIVE
    user_selection: dict[str, Any] | None = None
    created_at: str | None = None
    tool_call_id: str | None = None
    tool_name: str | None = None


class GenUIEvent(BaseModel):
    """GenUI streaming event.

    Attributes:
        type: Event type (recommend using GenUIEventType enum)
        content: Text content (for text_delta, etc.)
        data: Structured data (for tool_call_start, a2ui_message, etc.)
        surface_id: Surface ID
        title: Title (for title_update)
        metadata: Additional metadata
    """

    model_config = ConfigDict(alias_generator=to_camel, populate_by_name=True)

    type: str
    content: str | None = None
    data: dict[str, Any] | None = None
    surface_id: str | None = None
    title: str | None = None
    metadata: dict[str, Any] | None = None
    insight_slot_id: str | None = None

    def to_sse(self) -> str:
        """Convert to SSE format."""
        payload_json = self.model_dump_json(by_alias=True, exclude_none=True)
        return f"data: {payload_json}\n\n"


class HistoricalUIComponent(BaseModel):
    """UI component from historical message."""

    model_config = ConfigDict(alias_generator=to_camel, populate_by_name=True)

    surface_id: str
    component_type: str
    data: dict[str, Any]
    mode: str = "historical"
    user_selection: dict[str, Any] | None = None
