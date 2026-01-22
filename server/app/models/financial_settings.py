"""Financial settings model for storing user's financial preferences.

This model has been migrated to SQLAlchemy 2.0 with Mapped[...] annotations.
"""

from __future__ import annotations

from datetime import datetime
from decimal import Decimal
from enum import Enum
from typing import TYPE_CHECKING, Optional
from uuid import UUID

import sqlalchemy as sa
from sqlalchemy import ForeignKey, Integer, String
from sqlalchemy.dialects.postgresql import UUID as PGUUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.models.base import Base, col

if TYPE_CHECKING:
    from app.models.user import User


class BurnRateMode(str, Enum):
    """Burn rate calculation mode."""

    MANUAL = "MANUAL"
    AI_AUTO = "AI_AUTO"


class FinancialSettings(Base):
    """Financial settings model for storing user's financial preferences.

    This model stores user-specific financial configuration such as
    safety thresholds, daily burn rates, and display preferences.

    Attributes:
        user_uuid: Primary key, references users.uuid
        safety_threshold: Minimum safe balance threshold (default: 1000)
        daily_burn_rate: Daily spending estimate (default: 100)
        burn_rate_mode: How burn rate is calculated (MANUAL or AI_AUTO)
        primary_currency: Default display currency (default: CNY)
        month_start_day: Day of month to start calculations (default: 1)
        updated_at: Last update timestamp
        user: Relationship to user
    """

    __tablename__ = "financial_settings"

    user_uuid: Mapped[UUID] = mapped_column(
        PGUUID(as_uuid=True),
        sa.ForeignKey("users.uuid", ondelete="CASCADE"),
        primary_key=True,
    )
    safety_threshold: Mapped[Decimal] = col.numeric(precision=20, scale=8, default=Decimal("1000.00"))
    daily_burn_rate: Mapped[Decimal] = col.numeric(precision=20, scale=8, default=Decimal("100.00"))
    burn_rate_mode: Mapped[str] = mapped_column(String(20), default="AI_AUTO")
    primary_currency: Mapped[str] = mapped_column(String(3), default="CNY")
    month_start_day: Mapped[int] = mapped_column(Integer, default=1)
    updated_at: Mapped[datetime | None] = col.timestamptz(nullable=True)

    user: Mapped[User | None] = relationship(
        "User",
        foreign_keys="[FinancialSettings.user_uuid]",
        primaryjoin="FinancialSettings.user_uuid == User.uuid",
    )

    @property
    def safety_threshold_float(self) -> float:
        """Get safety threshold as float."""
        return float(self.safety_threshold)

    @property
    def daily_burn_rate_float(self) -> float:
        """Get daily burn rate as float."""
        return float(self.daily_burn_rate)
