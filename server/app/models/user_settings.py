"""User settings model for storing user preferences.

This model has been migrated to SQLAlchemy 2.0 with Mapped[...] annotations.
"""

from __future__ import annotations

from datetime import datetime
from typing import TYPE_CHECKING, Optional
from uuid import UUID

from pydantic import field_validator
from sqlalchemy import String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.models.base import Base, col

if TYPE_CHECKING:
    from app.models.user import User


class UserSettings(Base):
    """User settings model for storing user preferences.

    Note: user_uuid is the primary key (no separate id field).

    Attributes:
        user_uuid: Primary key, references users.uuid
        currency: User's preferred currency (default: CNY)
        timezone: User's timezone (default: Asia/Shanghai)
        avg_daily_spending: Estimated average daily spending
        safety_balance_threshold: Minimum safe balance threshold
        created_at: When the settings were created
        updated_at: When the settings were last updated
        user: Relationship to user
    """

    __tablename__ = "user_settings"

    user_uuid: Mapped[UUID] = col.uuid_pk()
    currency: Mapped[str] = mapped_column(String(10), default="CNY")
    timezone: Mapped[str] = mapped_column(String(100), default="Asia/Shanghai")
    avg_daily_spending: Mapped[str] = mapped_column(String, default="100.00")
    safety_balance_threshold: Mapped[str] = mapped_column(String, default="500.00")
    created_at: Mapped[datetime] = col.timestamptz()
    updated_at: Mapped[datetime | None] = col.timestamptz(nullable=True)

    user: Mapped[User | None] = relationship(
        "User",
        back_populates="settings",
        uselist=False,
        foreign_keys="[UserSettings.user_uuid]",
        primaryjoin="UserSettings.user_uuid == User.uuid",
    )

    @field_validator("safety_balance_threshold", "avg_daily_spending")
    @classmethod
    def validate_decimal_string(cls, v: str) -> str:
        """Validate that the string represents a valid decimal number."""
        from decimal import Decimal

        try:
            decimal_val = Decimal(v)
            if decimal_val < 0:
                raise ValueError("Value must be non-negative")
            return f"{decimal_val:.2f}"
        except Exception as e:
            raise ValueError(f"Invalid decimal format: {e}")

    @property
    def safety_threshold_float(self) -> float:
        """Get safety threshold as float."""
        return float(self.safety_balance_threshold)

    @property
    def avg_spending_float(self) -> float:
        """Get average spending as float."""
        return float(self.avg_daily_spending)
