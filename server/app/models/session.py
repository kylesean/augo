"""This file contains the session model for the application."""

import uuid as uuid_lib

from sqlalchemy.dialects.postgresql import UUID
from sqlmodel import Field

from app.models.base import BaseModel


class Session(BaseModel, table=True):
    """Session model for storing chat sessions.

    Attributes:
        id: The primary key (UUID)
        user_uuid: User's UUID
        name: Name of the session (defaults to empty string)
        created_at: When the session was created
        updated_at: When the session was updated
    """

    __tablename__ = "sessions"

    id: uuid_lib.UUID = Field(
        default_factory=uuid_lib.uuid4,
        primary_key=True,
        sa_type=UUID(as_uuid=True),
    )
    user_uuid: uuid_lib.UUID = Field(
        sa_type=UUID(as_uuid=True),
        index=True,
    )
    name: str = Field(default="")
