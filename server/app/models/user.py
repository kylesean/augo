"""User model for the application.

This model has been migrated to SQLAlchemy 2.0 with Mapped[...] annotations.
"""

from __future__ import annotations

from datetime import datetime
from typing import TYPE_CHECKING, Optional
from uuid import UUID

import bcrypt
from pydantic import field_validator, model_validator
from sqlalchemy import Integer, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.models.base import Base, col

if TYPE_CHECKING:
    from app.models.financial_account import FinancialAccount
    from app.models.user_settings import UserSettings


class User(Base):
    """User model for storing user accounts.

    Attributes:
        id: The primary key (BigInteger)
        uuid: Unique identifier UUID
        username: User's username
        email: User's email (unique, optional)
        mobile: User's mobile number (unique, optional)
        password: Bcrypt hashed password
        avatar_url: URL to user's avatar image
        timezone: User's timezone (default: Asia/Shanghai)
        registration_type: How user registered ('email' or 'mobile')
        last_login_ip: Last IP address used by client
        last_login_at: Last login timestamp
        created_at: When the user was created
        updated_at: When the user was last updated
        settings: Relationship to user settings
        financial_accounts: Relationship to user's financial accounts
    """

    __tablename__ = "users"

    id: Mapped[int | None] = mapped_column(primary_key=True, autoincrement=True)
    uuid: Mapped[UUID] = mapped_column(unique=True, index=True)
    username: Mapped[str] = mapped_column(String(50))
    email: Mapped[str | None] = mapped_column(String(100), unique=True, index=True, nullable=True)
    mobile: Mapped[str | None] = mapped_column(String(20), unique=True, index=True, nullable=True)
    password: Mapped[str] = mapped_column(String(255))
    avatar_url: Mapped[str | None] = mapped_column(String(500), nullable=True)
    timezone: Mapped[str] = mapped_column(String(100), default="Asia/Shanghai")
    registration_type: Mapped[str] = mapped_column(String(20))
    last_login_ip: Mapped[str | None] = col.inet_column()
    last_login_at: Mapped[datetime | None] = col.datetime_tz(nullable=True)
    created_at: Mapped[datetime] = col.timestamptz()
    updated_at: Mapped[datetime | None] = col.timestamptz(nullable=True)

    settings: Mapped[UserSettings | None] = relationship(
        "UserSettings",
        back_populates="user",
        uselist=False,
        foreign_keys="[UserSettings.user_uuid]",
        primaryjoin="User.uuid == UserSettings.user_uuid",
    )

    financial_accounts: Mapped[list[FinancialAccount]] = relationship(
        "FinancialAccount",
        back_populates="user",
        foreign_keys="[FinancialAccount.user_uuid]",
        primaryjoin="User.uuid == FinancialAccount.user_uuid",
    )

    @field_validator("email")
    @classmethod
    def validate_email(cls, v: str | None) -> str | None:
        """Validate and normalize email format."""
        if v is None:
            return v

        v_stripped = v.strip() if isinstance(v, str) else str(v)
        if not v_stripped:
            return None

        if "@" not in v_stripped or "." not in v_stripped.split("@")[-1]:
            raise ValueError("Invalid email format")

        return v_stripped.lower()

    @field_validator("mobile")
    @classmethod
    def validate_mobile(cls, v: str | None) -> str | None:
        """Validate mobile number format."""
        if v is not None and v.strip():
            cleaned = v.strip().replace("-", "").replace(" ", "").replace("(", "").replace(")", "")
            if not cleaned.isdigit() or len(cleaned) < 8 or len(cleaned) > 15:
                raise ValueError("Invalid mobile number format")
            return cleaned
        return v

    @field_validator("last_login_ip")
    @classmethod
    def validate_ip_address(cls, v: str | None) -> str | None:
        """Validate IP address format."""
        if v is None or not v.strip():
            return None
        return v.strip()

    @model_validator(mode="after")
    def validate_contact_info(self) -> User:
        """Ensure at least one contact method is provided."""
        if not self.email and not self.mobile:
            raise ValueError("Either email or mobile must be provided")
        return self

    def verify_password(self, password: str) -> bool:
        """Verify if the provided password matches the hash."""
        return bcrypt.checkpw(password.encode("utf-8"), self.password.encode("utf-8"))

    @staticmethod
    def hash_password(password: str) -> str:
        """Hash a password using bcrypt."""
        salt = bcrypt.gensalt()
        return bcrypt.hashpw(password.encode("utf-8"), salt).decode("utf-8")

    @property
    def hashed_password(self) -> str:
        """Alias for password field."""
        return self.password

    @property
    def display_name(self) -> str:
        """Get display name for the user."""
        return self.username or self.email or self.mobile or "Unknown User"

    @property
    def contact_info(self) -> str:
        """Get primary contact information."""
        return self.email or self.mobile or ""
