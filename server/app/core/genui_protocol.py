"""GenUI A2UI Protocol Definitions

This module defines standard A2UI protocol message types for server-driven UI.
All messages follow GenUI's fromJson() parsing requirements: nested structure with wrapper keys.

Architecture:
- Payload classes: Pure data structures (e.g., SurfaceUpdatePayload)
- Wrapper classes: GenUI-compliant wrappers (e.g., SurfaceUpdate with 'surfaceUpdate' key)

Key Insight:
GenUI's A2uiMessage.fromJson() does NOT use a 'type' field. Instead, it uses the
outer key name as the discriminator:
  ❌ Wrong: {"type": "surface_update", "surfaceId": "..."}
  ✅ Right: {"surfaceUpdate": {"surfaceId": "..."}}
"""

from __future__ import annotations

from typing import Any

from pydantic import BaseModel

# ============================================================================
# 1. Component Definition
# ============================================================================


class Component(BaseModel):
    """UI component with properties.

    GenUI Format (CRITICAL - matches GenUI's Component.fromJson):
    {
      "id": "comp_123",
      "component": {                    // NOT componentProperties!
        "WeatherCard": {"temperature": 25, "city": "Beijing"}
      }
    }

    GenUI's fromJson expects json['component'], not json['componentProperties']!
    """

    id: str
    component: dict[str, Any]  # Changed from componentProperties to component


# ============================================================================
# 2. SurfaceUpdate - Define/Update UI Components
# ============================================================================


class SurfaceUpdatePayload(BaseModel):
    """Payload for surface update."""

    surfaceId: str
    components: list[Component]


class SurfaceUpdate(BaseModel):
    """GenUI SurfaceUpdate message.

    GenUI expects:
    {
      "surfaceUpdate": {
        "surfaceId": "surface_123",
        "components": [...]
      }
    }
    """

    surfaceUpdate: SurfaceUpdatePayload


# ============================================================================
# 3. BeginRendering - Start Rendering a Surface
# ============================================================================


class BeginRenderingPayload(BaseModel):
    """Payload for begin rendering."""

    surfaceId: str
    root: str  # Root component ID


class BeginRendering(BaseModel):
    """GenUI BeginRendering message.

    GenUI expects:
    {
      "beginRendering": {
        "surfaceId": "surface_123",
        "root": "comp_456"
      }
    }
    """

    beginRendering: BeginRenderingPayload


# ============================================================================
# 4. TextChunk - Stream Text Content
# ============================================================================


class TextChunkPayload(BaseModel):
    """Payload for text chunk."""

    text: str


class TextChunk(BaseModel):
    """GenUI TextChunk message.

    GenUI expects:
    {
      "textChunk": {
        "text": "Hello world"
      }
    }
    """

    textChunk: TextChunkPayload


# ============================================================================
# 5. UserInteraction - User Action (Frontend → Backend)
# ============================================================================


class UserInteractionPayload(BaseModel):
    """Payload for user interaction."""

    surfaceId: str
    componentId: str
    action: str
    data: dict[str, Any] | None = None


class UserInteraction(BaseModel):
    """GenUI UserInteraction message.

    GenUI expects:
    {
      "userInteraction": {
        "surfaceId": "surface_123",
        "componentId": "comp_456",
        "action": "confirm",
        "data": {...}
      }
    }
    """

    userInteraction: UserInteractionPayload


# ============================================================================
# 6. DataModelUpdate - Update Surface Data (Reactive Updates)
# ============================================================================


class DataModelUpdatePayload(BaseModel):
    """Payload for data model update.

    Used for reactive updates: only widgets bound to the specified path
    will rebuild, instead of the entire surface.
    """

    surfaceId: str
    path: str  # JSONPath format, e.g., "/amount" or "/user/name"
    value: Any  # The new value at the specified path


class DataModelUpdate(BaseModel):
    """GenUI DataModelUpdate message.

    Used to update a specific data path in the Surface's DataModel,
    triggering reactive rebuilds of bound widgets.

    GenUI expects:
    {
      "dataModelUpdate": {
        "surfaceId": "surface_123",
        "path": "/amount",
        "value": 2000.0
      }
    }

    Use cases:
    - User changes amount: update only the AmountDisplay widget
    - User selects account: update only the AccountDisplay widget
    - AI corrects a value: seamless update without full rebuild
    """

    dataModelUpdate: DataModelUpdatePayload


# ============================================================================
# 7. DeleteSurface - Remove a Surface from UI
# ============================================================================


class DeleteSurfacePayload(BaseModel):
    """Payload for surface deletion."""

    surfaceId: str


class DeleteSurface(BaseModel):
    """GenUI DeleteSurface message.

    Used to explicitly remove a Surface from the UI.

    GenUI expects:
    {
      "deleteSurface": {
        "surfaceId": "surface_123"
      }
    }
    """

    deleteSurface: DeleteSurfacePayload
