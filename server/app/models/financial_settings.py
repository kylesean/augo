"""Financial settings model for storing user's financial preferences."""

from datetime import datetime
from decimal import Decimal
from enum import Enum
from typing import TYPE_CHECKING, Optional
from uuid import UUID

import sqlalchemy as sa
from sqlalchemy import Numeric
from sqlalchemy.dialects.postgresql import UUID as PGUUID
from sqlmodel import Column, Field, Relationship

from app.models.base import BaseModel
from app.utils.currency_utils import BASE_CURRENCY

if TYPE_CHECKING:
    from app.models.user import User


class BurnRateMode(str, Enum):
    """Burn rate calculation mode."""

    MANUAL = "MANUAL"
    AI_AUTO = "AI_AUTO"


class FinancialSettings(BaseModel, table=True):
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

    user_uuid: UUID = Field(
        sa_column=Column(
            PGUUID(as_uuid=True), sa.ForeignKey("users.uuid", ondelete="CASCADE"), primary_key=True, nullable=False
        )
    )
    safety_threshold: Decimal = Field(
        default=Decimal("1000.00"), sa_column=Column(Numeric(20, 8), nullable=False, default=1000.00)
    )
    daily_burn_rate: Decimal = Field(default=Decimal("100.00"), sa_column=Column(Numeric(20, 8), default=100.00))
    burn_rate_mode: str = Field(default="AI_AUTO", max_length=20)
    primary_currency: str = Field(default=BASE_CURRENCY, max_length=3)
    month_start_day: int = Field(default=1)
    # updated_at is inherited from BaseModel (timezone-aware)

    # Relationship
    user: Optional["User"] = Relationship(
        sa_relationship_kwargs={
            "foreign_keys": "[FinancialSettings.user_uuid]",
            "primaryjoin": "FinancialSettings.user_uuid == User.uuid",
        }
    )

    @property
    def safety_threshold_float(self) -> float:
        """Get safety threshold as float."""
        return float(self.safety_threshold)

    @property
    def daily_burn_rate_float(self) -> float:
        """Get daily burn rate as float."""
        return float(self.daily_burn_rate)
