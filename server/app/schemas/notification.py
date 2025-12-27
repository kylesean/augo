from datetime import datetime
from typing import Any, Dict, List, Optional

from pydantic import BaseModel, ConfigDict, Field


class NotificationResponse(BaseModel):
    """Response schema for a single notification."""

    id: int
    user_uuid: str
    type: str
    title: str
    content: Optional[str] = None
    data: Optional[Dict[str, Any]] = None
    is_read: bool
    read_at: Optional[datetime] = None
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)


class NotificationListResponse(BaseModel):
    """Response schema for notification list."""

    notifications: List[NotificationResponse]
    total: int
    unread_count: int
    page: int
    limit: int
