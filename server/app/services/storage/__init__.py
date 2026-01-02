"""Storage package.

Provides unified storage abstraction for multi-source file management.
"""

from app.services.storage.adapters import StorageAdapter, StorageAdapterFactory

__all__ = [
    "StorageAdapter",
    "StorageAdapterFactory",
]
