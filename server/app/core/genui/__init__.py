"""GenUI Core Module

Provides core GenUI components for server-side A2UI protocol support.
"""

from app.core.genui.surface_tracker import SurfaceInfo, SurfaceTracker
from app.core.genui.persistent_surface_tracker import PersistentSurfaceTracker

__all__ = ["SurfaceInfo", "SurfaceTracker", "PersistentSurfaceTracker"]
