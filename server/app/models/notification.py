"""Notification model for user notifications."""

from datetime import datetime
from typing import TYPE_CHECKING, Optional

from pydantic import field_validator
from sqlalchemy.dialects.postgresql import JSONB
from sqlmodel import Column, Field, Relationship

from app.models.base import BaseModel

if TYPE_CHECKING:
    from app.models.user import User


class Notification(BaseModel, table=True):
    """Notification model for storing user notifications.

    Attributes:
        id: The primary key
        user_uuid: Foreign key to users table
        type: Notification type
        title: Notification title
        content: Notification content (optional)
        data: Additional JSON data (optional)
        is_read: Whether the notification has been read
        read_at: When the notification was read
        created_at: When the notification was created
        updated_at: When the notification was last updated
        user: Relationship to user
    """

    __tablename__ = "notifications"

    id: Optional[int] = Field(default=None, primary_key=True, sa_column_kwargs={"autoincrement": True})
    user_uuid: int = Field(foreign_key="users.id", index=True)
    type: str = Field(max_length=50)
    title: str = Field(max_length=255)
    content: Optional[str] = None
    data: Optional[dict] = Field(default=None, sa_column=Column(JSONB))
    is_read: bool = Field(default=False, index=True)
    read_at: Optional[datetime] = None

    # Relationship
    user: Optional["User"] = Relationship()

    @field_validator("title")
    @classmethod
    def validate_title(cls, v: str) -> str:
        """Validate title is not empty.

        Args:
            v: Title to validate

        Returns:
            str: Validated title

        Raises:
            ValueError: If title is empty
        """
        if not v or not v.strip():
            raise ValueError("Notification title cannot be empty")
        return v.strip()

    @field_validator("type")
    @classmethod
    def validate_type(cls, v: str) -> str:
        """Validate notification type.

        Args:
            v: Type to validate

        Returns:
            str: Validated type
        """
        if not v or not v.strip():
            raise ValueError("Notification type cannot be empty")
        return v.strip()

    def mark_as_read(self) -> None:
        """Mark this notification as read."""
        self.is_read = True
        self.read_at = datetime.now()

    @property
    def is_unread(self) -> bool:
        """Check if notification is unread.

        Returns:
            bool: True if notification is unread
        """
        return not self.is_read


# Avoid circular imports
from app.models.user import User  # noqa: E402
