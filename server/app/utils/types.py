"""Type utilities and helper functions for the application."""

from __future__ import annotations

import uuid


def ensure_uuid(value: uuid.UUID | str) -> uuid.UUID:
    """Convert a value to a uuid.UUID object.

    This remains as a utility for edge cases where raw strings might still exist
    (e.g., from external logs or legacy data), but business logic should
    prefer using UUID objects directly.

    Args:
        value: Either a uuid.UUID object or a string representation

    Returns:
        uuid.UUID: The UUID object
    """
    if isinstance(value, uuid.UUID):
        return value
    return uuid.UUID(str(value))
