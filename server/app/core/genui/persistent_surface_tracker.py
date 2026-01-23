from __future__ import annotations

from datetime import datetime
from typing import Any, cast
from uuid import UUID

from sqlalchemy import select, and_, update
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.genui_surface import GenUISurface
from app.models.base import utc_now
from app.core.logging import logger


class PersistentSurfaceTracker:
    """Manages active Surfaces with database persistence.

    Fulfills the GenUI principle: 'Server-side awareness of client state'
    by persisting Surface state across requests in a session.
    """

    def __init__(self, db: AsyncSession, session_id: UUID):
        self.db = db
        self.session_id = session_id

    async def register_surface(
        self,
        surface_id: str,
        component_type: str,
        data: dict[str, Any],
        tool_call_id: str | None = None,
    ) -> GenUISurface:
        """Register a new Surface or update an existing one in DB."""
        # Check if it already exists
        query = select(GenUISurface).where(
            and_(
                GenUISurface.session_id == self.session_id,
                GenUISurface.surface_id == surface_id,
            )
        )
        result = await self.db.execute(query)
        surface = result.scalar_one_or_none()

        if surface:
            # Update existing
            surface.component_type = component_type
            surface.data = data
            surface.tool_call_id = tool_call_id
            surface.last_updated_at = utc_now()
            surface.is_active = True
        else:
            # Create new
            surface = GenUISurface(
                session_id=self.session_id,
                surface_id=surface_id,
                component_type=component_type,
                data=data,
                tool_call_id=tool_call_id,
            )
            self.db.add(surface)

        await self.db.commit()
        await self.db.refresh(surface)
        
        logger.debug(
            "surface_persisted",
            session_id=str(self.session_id),
            surface_id=surface_id,
            component_type=component_type,
        )
        return surface

    async def find_reusable_surface(
        self,
        component_type: str,
    ) -> str | None:
        """Find the most recent active Surface of the same type in this session."""
        query = (
            select(GenUISurface.surface_id)
            .where(
                and_(
                    GenUISurface.session_id == self.session_id,
                    GenUISurface.component_type == component_type,
                    GenUISurface.is_active == True,
                )
            )
            .order_by(GenUISurface.last_updated_at.desc())
            .limit(1)
        )
        result = await self.db.execute(query)
        return result.scalar_one_or_none()

    async def update_surface_data(
        self,
        surface_id: str,
        path: str,
        value: Any,
    ) -> bool:
        """Update a specific data path in a persisted Surface."""
        query = select(GenUISurface).where(
            and_(
                GenUISurface.session_id == self.session_id,
                GenUISurface.surface_id == surface_id,
            )
        )
        result = await self.db.execute(query)
        surface = result.scalar_one_or_none()

        if not surface:
            return False

        # Apply update to local data copy
        data = dict(surface.data)
        self._apply_path_update(data, path, value)
        
        # Apply to model
        surface.data = data
        surface.last_updated_at = utc_now()
        
        await self.db.commit()
        return True

    def _apply_path_update(self, data: dict[str, Any], path: str, value: Any) -> None:
        """Helper to apply JSONPath-like update to a dict."""
        if path == "/" or not path:
            if isinstance(value, dict):
                data.clear()
                data.update(value)
            return

        keys = [k for k in path.split("/") if k]
        current = data
        for key in keys[:-1]:
            if key not in current:
                current[key] = {}
            current = current[key]
        current[keys[-1]] = value

    async def get_surface_data(self, surface_id: str) -> dict[str, Any] | None:
        """Get current data for a persisted Surface."""
        query = select(GenUISurface.data).where(
            and_(
                GenUISurface.session_id == self.session_id,
                GenUISurface.surface_id == surface_id,
            )
        )
        result = await self.db.execute(query)
        return cast(dict[str, Any], result.scalar_one_or_none())

    async def delete_surface(self, surface_id: str) -> bool:
        """Mark a Surface as inactive in DB."""
        stmt = (
            update(GenUISurface)
            .where(
                and_(
                    GenUISurface.session_id == self.session_id,
                    GenUISurface.surface_id == surface_id,
                )
            )
            .values(is_active=False, last_updated_at=utc_now())
        )
        result = await self.db.execute(stmt)
        await self.db.commit()
        return cast(Any, result).rowcount > 0

    async def clear_session(self) -> int:
        """Mark all surfaces in this session as inactive."""
        stmt = (
            update(GenUISurface)
            .where(GenUISurface.session_id == self.session_id)
            .values(is_active=False, last_updated_at=utc_now())
        )
        result = await self.db.execute(stmt)
        await self.db.commit()
        return cast(Any, result).rowcount
