from __future__ import annotations

from datetime import datetime
from typing import Any

from pydantic import BaseModel, ConfigDict


class NotificationResponse(BaseModel):
    """Response schema for a single notification."""

    id: int
    user_uuid: str
    type: str
    title: str
    content: str | None = None
    data: dict[str, Any] | None = None
    is_read: bool
    read_at: datetime | None = None
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)


class NotificationListResponse(BaseModel):
    """Response schema for notification list."""

    notifications: list[NotificationResponse]
    total: int
    unread_count: int
    page: int
    limit: int
