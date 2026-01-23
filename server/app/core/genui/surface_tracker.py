"""GenUI Surface Tracker

Tracks active Surfaces and their associated state for reactive updates and reuse.

Key Capabilities:
1. Surface lifecycle management (register, update, delete)
2. Find reusable Surfaces for "update existing UI" scenarios
3. Track component data for DataModelUpdate generation
"""

from __future__ import annotations

import time
from dataclasses import dataclass, field
from typing import Any
from uuid import UUID

from app.core.logging import logger


@dataclass
class SurfaceInfo:
    """Information about an active Surface."""

    surface_id: str
    session_id: str
    component_type: str
    tool_call_id: str | None
    data: dict[str, Any]
    created_at: float = field(default_factory=time.time)
    last_updated_at: float = field(default_factory=time.time)
    is_active: bool = True

    def update_data(self, path: str, value: Any) -> None:
        """Update a specific path in the surface data."""
        # Handle root path
        if path == "/" or not path:
            self.data = value if isinstance(value, dict) else {"value": value}
        else:
            # Parse JSONPath-like path (e.g., "/amount" -> ["amount"])
            keys = [k for k in path.split("/") if k]
            current = self.data
            for key in keys[:-1]:
                if key not in current:
                    current[key] = {}
                current = current[key]
            current[keys[-1]] = value

        self.last_updated_at = time.time()


class SurfaceTracker:
    """Manages active Surfaces across sessions.

    Provides:
    1. Surface registration and lifecycle management
    2. Reusable Surface discovery for reactive updates
    3. Data tracking for DataModelUpdate generation

    Thread Safety:
    - This class is NOT thread-safe. Use one instance per request/session.
    """

    def __init__(self) -> None:
        # Primary index: surface_id -> SurfaceInfo
        self._surfaces: dict[str, SurfaceInfo] = {}

        # Secondary index: (session_id, component_type) -> [surface_id, ...]
        self._session_component_index: dict[tuple[str, str], list[str]] = {}

        # TTL for surface expiration (default: 30 minutes)
        self._surface_ttl_seconds: float = 30 * 60

    def register_surface(
        self,
        session_id: str | UUID,
        surface_id: str,
        component_type: str,
        data: dict[str, Any],
        tool_call_id: str | None = None,
    ) -> SurfaceInfo:
        """Register a new Surface or update an existing one.

        Args:
            session_id: The session this Surface belongs to
            surface_id: Unique identifier for the Surface
            component_type: The type of component rendered (e.g., "TransactionCard")
            data: The component data
            tool_call_id: Optional tool call ID for tracing

        Returns:
            The created or updated SurfaceInfo
        """
        session_str = str(session_id)

        info = SurfaceInfo(
            surface_id=surface_id,
            session_id=session_str,
            component_type=component_type,
            tool_call_id=tool_call_id,
            data=data,
        )

        self._surfaces[surface_id] = info

        # Update secondary index
        index_key = (session_str, component_type)
        if index_key not in self._session_component_index:
            self._session_component_index[index_key] = []
        if surface_id not in self._session_component_index[index_key]:
            self._session_component_index[index_key].append(surface_id)

        logger.debug(
            "surface_registered",
            surface_id=surface_id,
            session_id=session_str,
            component_type=component_type,
        )

        return info

    def find_reusable_surface(
        self,
        session_id: str | UUID,
        component_type: str,
    ) -> str | None:
        """Find an active Surface of the same type that can be reused.

        Used for "update existing UI" scenarios, e.g.:
        - User: "Transfer 500 yuan" -> TransferPathBuilder created
        - User: "No, make it 800" -> Reuse the same Surface, update amount

        Args:
            session_id: The session to search in
            component_type: The component type to match

        Returns:
            The surface_id if a reusable Surface is found, None otherwise
        """
        session_str = str(session_id)
        index_key = (session_str, component_type)

        surface_ids = self._session_component_index.get(index_key, [])

        # Find the most recent active Surface
        now = time.time()
        best_surface_id: str | None = None
        best_time: float = 0

        for sid in surface_ids:
            info = self._surfaces.get(sid)
            if info is None:
                continue
            if not info.is_active:
                continue
            # Check TTL
            if now - info.created_at > self._surface_ttl_seconds:
                info.is_active = False
                continue
            if info.last_updated_at > best_time:
                best_time = info.last_updated_at
                best_surface_id = sid

        if best_surface_id:
            logger.debug(
                "reusable_surface_found",
                surface_id=best_surface_id,
                session_id=session_str,
                component_type=component_type,
            )

        return best_surface_id

    def update_surface_data(
        self,
        surface_id: str,
        path: str,
        value: Any,
    ) -> bool:
        """Update a specific data path in a Surface.

        Args:
            surface_id: The Surface to update
            path: JSONPath-like path (e.g., "/amount")
            value: The new value

        Returns:
            True if the Surface was found and updated, False otherwise
        """
        info = self._surfaces.get(surface_id)
        if info is None:
            logger.warning("surface_not_found_for_update", surface_id=surface_id)
            return False

        info.update_data(path, value)
        logger.debug(
            "surface_data_updated",
            surface_id=surface_id,
            path=path,
            value=value,
        )
        return True

    def get_surface(self, surface_id: str) -> SurfaceInfo | None:
        """Get a Surface by ID."""
        return self._surfaces.get(surface_id)

    def get_surface_data(self, surface_id: str) -> dict[str, Any] | None:
        """Get the current data of a Surface."""
        info = self._surfaces.get(surface_id)
        return info.data if info else None

    def delete_surface(self, surface_id: str) -> bool:
        """Mark a Surface as inactive (soft delete)."""
        info = self._surfaces.get(surface_id)
        if info is None:
            return False

        info.is_active = False
        logger.debug("surface_deleted", surface_id=surface_id)
        return True

    def cleanup_expired(self) -> int:
        """Remove expired Surfaces. Returns the number of cleaned up Surfaces."""
        now = time.time()
        expired = []

        for sid, info in self._surfaces.items():
            if now - info.created_at > self._surface_ttl_seconds:
                expired.append(sid)

        for sid in expired:
            if sid in self._surfaces:
                surface_info = self._surfaces[sid]
                del self._surfaces[sid]
                index_key = (surface_info.session_id, surface_info.component_type)
                if index_key in self._session_component_index:
                    surfs = self._session_component_index[index_key]
                    if sid in surfs:
                        surfs.remove(sid)

        if expired:
            logger.info("surfaces_cleaned_up", count=len(expired))

        return len(expired)

    def clear_session(self, session_id: str | UUID) -> int:
        """Clear all Surfaces for a session. Returns the number cleared."""
        session_str = str(session_id)
        to_remove = [sid for sid, info in self._surfaces.items() if info.session_id == session_str]

        for sid in to_remove:
            self.delete_surface(sid)

        return len(to_remove)

    def get_session_surfaces(self, session_id: str | UUID) -> list[SurfaceInfo]:
        """Get all active Surfaces for a session."""
        session_str = str(session_id)
        return [info for info in self._surfaces.values() if info.session_id == session_str and info.is_active]
