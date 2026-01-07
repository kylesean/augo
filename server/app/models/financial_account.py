"""Financial account model for storing user's financial accounts."""

from decimal import Decimal
from enum import Enum
from typing import TYPE_CHECKING, Optional
from uuid import UUID, uuid4

import sqlalchemy as sa
from sqlalchemy import CheckConstraint, Numeric
from sqlalchemy.dialects.postgresql import UUID as PGUUID
from sqlmodel import Column, Field, Relationship

from app.models.base import BaseModel

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


class FinancialAccount(BaseModel, table=True):
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

    id: UUID = Field(default_factory=uuid4, sa_column=Column(PGUUID(as_uuid=True), primary_key=True))
    user_uuid: UUID = Field(
        sa_column=Column(
            PGUUID(as_uuid=True), sa.ForeignKey("users.uuid", ondelete="CASCADE"), nullable=False, index=True
        )
    )
    name: str = Field(max_length=100)
    nature: str = Field(max_length=20)  # 'ASSET' or 'LIABILITY'
    type: Optional[str] = Field(default=None, max_length=50)
    currency_code: str = Field(default="CNY", max_length=3)
    initial_balance: Decimal = Field(default=Decimal("0"), sa_column=Column(Numeric(20, 8), default=0))
    current_balance: Decimal = Field(default=Decimal("0"), sa_column=Column(Numeric(20, 8), default=0))
    include_in_net_worth: bool = Field(default=True)
    include_in_cash_flow: bool = Field(default=False)
    status: str = Field(default="ACTIVE", max_length=20)

    # Relationships
    user: Optional["User"] = Relationship(
        sa_relationship_kwargs={
            "foreign_keys": "[FinancialAccount.user_uuid]",
            "primaryjoin": "FinancialAccount.user_uuid == User.uuid",
            "overlaps": "financial_accounts",
        }
    )

    @property
    def balance_float(self) -> float:
        """Get initial balance as float.

        Returns:
            float: Balance value
        """
        return float(self.initial_balance)

    @property
    def is_asset(self) -> bool:
        """Check if account is an asset.

        Returns:
            bool: True if nature is 'ASSET'
        """
        return self.nature == AccountNature.ASSET.value

    @property
    def is_liability(self) -> bool:
        """Check if account is a liability.

        Returns:
            bool: True if nature is 'LIABILITY'
        """
        return self.nature == AccountNature.LIABILITY.value

    @property
    def is_active(self) -> bool:
        """Check if account is active.

        Returns:
            bool: True if status is 'ACTIVE'
        """
        return self.status == AccountStatus.ACTIVE.value

    @property
    def net_worth_contribution(self) -> Decimal:
        """Calculate this account's contribution to net worth.

        Assets contribute positively, liabilities contribute negatively.
        Inactive/closed accounts or accounts excluded from net worth return 0.

        Returns:
            Decimal: Net worth contribution
        """
        if not self.include_in_net_worth or not self.is_active:
            return Decimal("0")
        if self.is_liability:
            return -abs(self.initial_balance)
        return self.initial_balance
