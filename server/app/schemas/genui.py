"""GenUI Event and Component Schemas

This module defines the data structures for Generative UI events and components,
supporting both real-time streaming and historical message restoration using Pydantic.

Schema Version: 2.0 (Refactored)
"""

from enum import Enum
from typing import Any, Dict, Optional

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
    data: Dict[str, Any]
    mode: UIComponentMode = UIComponentMode.LIVE
    user_selection: Optional[Dict[str, Any]] = None
    created_at: Optional[str] = None
    tool_call_id: Optional[str] = None
    tool_name: Optional[str] = None


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
    content: Optional[str] = None
    data: Optional[Dict[str, Any]] = None
    surface_id: Optional[str] = None
    title: Optional[str] = None
    metadata: Optional[Dict[str, Any]] = None
    insight_slot_id: Optional[str] = None

    def to_sse(self) -> str:
        """Convert to SSE format."""
        payload_json = self.model_dump_json(by_alias=True, exclude_none=True)
        return f"data: {payload_json}\n\n"


class HistoricalUIComponent(BaseModel):
    """UI component from historical message."""

    model_config = ConfigDict(alias_generator=to_camel, populate_by_name=True)

    surface_id: str
    component_type: str
    data: Dict[str, Any]
    mode: str = "historical"
    user_selection: Optional[Dict[str, Any]] = None
