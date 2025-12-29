"""Type utilities for consistent UUID handling across the application.

This module provides type aliases and helper functions for handling UUIDs
in a type-safe manner that works with both mypy and runtime.
"""

import uuid
from typing import Union

# Type alias for accepting both UUID objects and strings
# Use this in function signatures that accept UUIDs from various sources
UUIDLike = Union[uuid.UUID, str]


def ensure_uuid(value: UUIDLike) -> uuid.UUID:
    """Convert a UUID-like value to a uuid.UUID object.

    Args:
        value: Either a uuid.UUID object or a string representation

    Returns:
        uuid.UUID: The UUID object

    Raises:
        ValueError: If the string is not a valid UUID
    """
    if isinstance(value, uuid.UUID):
        return value
    return uuid.UUID(str(value))


def ensure_str(value: UUIDLike) -> str:
    """Convert a UUID-like value to its string representation.

    Args:
        value: Either a uuid.UUID object or a string representation

    Returns:
        str: The string representation of the UUID
    """
    return str(value)
