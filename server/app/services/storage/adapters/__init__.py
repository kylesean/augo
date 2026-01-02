"""Storage adapters package.

This package provides storage adapters for different backends:
- LocalAdapter: Local filesystem storage
- S3Adapter: S3-compatible object storage (AWS S3, MinIO)
- WebDAVAdapter: WebDAV protocol storage (NAS, cloud drives)
"""

from app.services.storage.adapters.base import StorageAdapter
from app.services.storage.adapters.factory import StorageAdapterFactory

__all__ = [
    "StorageAdapter",
    "StorageAdapterFactory",
]
