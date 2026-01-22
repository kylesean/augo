"""Financial account model for storing user's financial accounts.

This model has been migrated to SQLAlchemy 2.0 with Mapped[...] annotations.
"""

from __future__ import annotations

from datetime import datetime
from decimal import Decimal
from enum import Enum
from typing import TYPE_CHECKING, Optional
from uuid import UUID, uuid4 as uuid4_factory

from sqlalchemy import Boolean, CheckConstraint, String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.models.base import Base, col

if TYPE_CHECKING:
    from app.models.user import User


class AccountNature(str, Enum):
    """Account nature enum - defines whether account is an asset or liability."""

    ASSET = "ASSET"
    LIABILITY = "LIABILITY"


class AccountType(str, Enum):
    """Account type enum - specific account categories."""

    CASH = "CASH"
    DEPOSIT = "DEPOSIT"
    E_MONEY = "E_MONEY"
    INVESTMENT = "INVESTMENT"
    RECEIVABLE = "RECEIVABLE"
    CREDIT_CARD = "CREDIT_CARD"
    LOAN = "LOAN"
    PAYABLE = "PAYABLE"


class AccountStatus(str, Enum):
    """Account status enum."""

    ACTIVE = "ACTIVE"
    INACTIVE = "INACTIVE"
    CLOSED = "CLOSED"


class FinancialAccount(Base):
    """Financial account model for storing user's financial accounts.

    This model represents various financial accounts like bank accounts,
    credit cards, cash wallets, etc.

    Attributes:
        id: Primary key (UUID)
        user_uuid: Foreign key to users table (UUID)
        name: Account name (e.g., "招商银行储蓄卡")
        nature: Account nature ('ASSET' or 'LIABILITY')
        type: Account type (e.g., 'CASH', 'DEPOSIT', 'CREDIT_CARD')
        currency_code: Currency code (default: 'CNY')
        initial_balance: Initial account balance (precision: 20,8)
        current_balance: Current account balance (precision: 20,8)
        include_in_net_worth: Whether to include in net worth calculation
        include_in_cash_flow: Whether to include in daily cash flow forecast
        status: Account status ('ACTIVE', 'INACTIVE', 'CLOSED')
        created_at: Record creation timestamp
        updated_at: Record update timestamp
        user: Relationship to user
    """

    __tablename__ = "financial_accounts"
    __table_args__ = (
        CheckConstraint("nature IN ('ASSET', 'LIABILITY')", name="check_nature"),
        CheckConstraint("status IN ('ACTIVE', 'INACTIVE', 'CLOSED')", name="check_status"),
    )

    id: Mapped[UUID] = col.uuid_pk(uuid4_factory)
    user_uuid: Mapped[UUID] = col.uuid_fk("users", ondelete="CASCADE", index=True, column="uuid")
    name: Mapped[str] = mapped_column(String(100))
    nature: Mapped[str] = mapped_column(String(20))
    type: Mapped[str | None] = mapped_column(String(50), nullable=True)
    currency_code: Mapped[str] = mapped_column(String(3), default="CNY")
    initial_balance: Mapped[Decimal] = col.numeric(precision=20, scale=8, default=Decimal("0"))
    current_balance: Mapped[Decimal] = col.numeric(precision=20, scale=8, default=Decimal("0"))
    include_in_net_worth: Mapped[bool] = mapped_column(Boolean, default=True)
    include_in_cash_flow: Mapped[bool] = mapped_column(Boolean, default=False)
    status: Mapped[str] = mapped_column(String(20), default="ACTIVE")
    created_at: Mapped[datetime] = col.timestamptz()
    updated_at: Mapped[datetime | None] = col.timestamptz(nullable=True)

    user: Mapped[User | None] = relationship(
        "User",
        back_populates="financial_accounts",
        foreign_keys="[FinancialAccount.user_uuid]",
        primaryjoin="FinancialAccount.user_uuid == User.uuid",
    )

    @property
    def balance_float(self) -> float:
        """Get initial balance as float."""
        return float(self.initial_balance)

    @property
    def is_asset(self) -> bool:
        """Check if account is an asset."""
        return self.nature == AccountNature.ASSET.value

    @property
    def is_liability(self) -> bool:
        """Check if account is a liability."""
        return self.nature == AccountNature.LIABILITY.value

    @property
    def is_active(self) -> bool:
        """Check if account is active."""
        return self.status == AccountStatus.ACTIVE.value

    @property
    def net_worth_contribution(self) -> Decimal:
        """Calculate this account's contribution to net worth."""
        if not self.include_in_net_worth or not self.is_active:
            return Decimal("0")
        if self.is_liability:
            return -abs(self.initial_balance)
        return self.initial_balance
