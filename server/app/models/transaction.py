"""Transaction models for financial management.

This model has been migrated to SQLAlchemy 2.0 with Mapped[...] annotations.
"""

from __future__ import annotations

from datetime import date, datetime
from decimal import Decimal
from typing import TYPE_CHECKING, Any, Optional
from uuid import UUID, uuid4 as uuid4_factory

from pydantic import field_validator
from sqlalchemy import Boolean, Integer, String
from sqlalchemy.dialects.postgresql import JSONB
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.models.base import Base, col

if TYPE_CHECKING:
    from app.models.financial_account import FinancialAccount
    from app.models.user import User


class Transaction(Base):
    """Transaction model for storing financial transactions.

    Attributes:
        id: The primary key (UUID)
        user_uuid: Foreign key to users table (UUID)
        type: Transaction type (e.g., "EXPENSE", "INCOME", "TRANSFER")
        source_account_id: Source financial account ID (foreign key to finance_accounts.id)
        target_account_id: Target financial account ID (foreign key to finance_accounts.id)
        amount_original: Original transaction amount (high precision)
        amount: Transaction amount in base currency (high precision)
        currency: Currency code (e.g., "CNY")
        exchange_rate: Exchange rate used (optional)
        transaction_at: When the transaction occurred
        transaction_timezone: Timezone of the transaction
        tags: List of tags (JSON array)
        location: Transaction location
        latitude: Location latitude
        longitude: Location longitude
        source: Source of transaction (MANUAL, AI, IMPORT, etc.)
        status: Transaction status (CLEARED, PENDING, etc.)
        description: Transaction description
        raw_input: Raw input text from user (for AI-created transactions)
        shared_space_id: Shared space ID (optional)
        created_at: When the record was created
        updated_at: When the record was last updated
        comments: Relationship to transaction comments
        shares: Relationship to transaction shares
    """

    __tablename__ = "transactions"

    id: Mapped[UUID | None] = mapped_column(primary_key=True)
    user_uuid: Mapped[UUID] = col.uuid_column(index=True)
    type: Mapped[str] = mapped_column(String(20))
    source_account_id: Mapped[UUID | None] = col.uuid_column(index=True, nullable=True)
    target_account_id: Mapped[UUID | None] = col.uuid_column(index=True, nullable=True)
    amount_original: Mapped[Decimal] = col.numeric(precision=20, scale=8)
    amount: Mapped[Decimal] = col.numeric(precision=20, scale=8)
    currency: Mapped[str] = mapped_column(String(3), default="CNY")
    exchange_rate: Mapped[Decimal | None] = col.numeric(precision=20, scale=8, nullable=True)
    transaction_at: Mapped[datetime] = col.datetime_tz()
    transaction_timezone: Mapped[str] = mapped_column(String(50), default="UTC")
    tags: Mapped[list[str] | None] = mapped_column(JSONB, nullable=True)
    location: Mapped[str | None] = mapped_column(String(255), nullable=True)
    latitude: Mapped[Decimal | None] = col.numeric(precision=9, scale=6, nullable=True)
    longitude: Mapped[Decimal | None] = col.numeric(precision=9, scale=6, nullable=True)
    source: Mapped[str] = mapped_column(String(20), default="MANUAL")
    status: Mapped[str] = mapped_column(String(20), default="CLEARED")
    description: Mapped[str | None] = mapped_column(String, nullable=True)
    raw_input: Mapped[str] = mapped_column(String, default="")
    category_key: Mapped[str] = mapped_column(String(25), default="")
    subject: Mapped[str] = mapped_column(String(20), default="SELF")
    intent: Mapped[str] = mapped_column(String(20), default="SURVIVAL")
    source_thread_id: Mapped[UUID | None] = col.uuid_column(index=True, nullable=True)
    created_at: Mapped[datetime] = col.timestamptz()
    updated_at: Mapped[datetime | None] = col.timestamptz(nullable=True)

    comments: Mapped[list[TransactionComment]] = relationship(
        "TransactionComment",
        back_populates="transaction",
        cascade="all, delete-orphan",
    )
    shares: Mapped[list[TransactionShare]] = relationship(
        "TransactionShare",
        back_populates="transaction",
        cascade="all, delete-orphan",
    )

    source_account: Mapped[FinancialAccount | None] = relationship(
        "FinancialAccount",
        foreign_keys="[Transaction.source_account_id]",
        primaryjoin="Transaction.source_account_id == FinancialAccount.id",
    )

    target_account: Mapped[FinancialAccount | None] = relationship(
        "FinancialAccount",
        foreign_keys="[Transaction.target_account_id]",
        primaryjoin="Transaction.target_account_id == FinancialAccount.id",
    )

    @property
    def amount_float(self) -> float:
        """Get amount as float."""
        return float(self.amount)

    @property
    def amount_original_float(self) -> float:
        """Get original amount as float."""
        return float(self.amount_original)

    @property
    def absolute_amount(self) -> float:
        """Get absolute value of amount."""
        return abs(float(self.amount))

    @property
    def is_income(self) -> bool:
        """Check if transaction is income."""
        return self.type == "INCOME"

    @property
    def is_expense(self) -> bool:
        """Check if transaction is expense."""
        return self.type == "EXPENSE"

    @property
    def is_transfer(self) -> bool:
        """Check if transaction is transfer."""
        return self.type == "TRANSFER"


class TransactionComment(Base):
    """Transaction comment model for storing comments on transactions."""

    __tablename__ = "transaction_comments"

    id: Mapped[int | None] = mapped_column(primary_key=True, autoincrement=True)
    transaction_id: Mapped[UUID] = col.uuid_fk("transactions", ondelete="CASCADE", index=True)
    user_uuid: Mapped[UUID] = col.uuid_fk("users", ondelete="CASCADE", index=True, column="uuid")
    parent_comment_id: Mapped[int | None] = mapped_column(Integer, nullable=True)
    comment_text: Mapped[str] = mapped_column(String)
    mentioned_user_ids: Mapped[list[int] | None] = mapped_column(JSONB, nullable=True)
    created_at: Mapped[datetime] = col.timestamptz()
    updated_at: Mapped[datetime | None] = col.timestamptz(nullable=True)

    transaction: Mapped[Transaction | None] = relationship("Transaction", back_populates="comments")
    user: Mapped[User | None] = relationship(
        "User",
        foreign_keys="[TransactionComment.user_uuid]",
        primaryjoin="TransactionComment.user_uuid == User.uuid",
    )

    @field_validator("comment_text")
    @classmethod
    def validate_comment_text(cls, v: str) -> str:
        """Validate comment text is not empty."""
        if not v or not v.strip():
            raise ValueError("Comment text cannot be empty")
        return v.strip()


class RecurringTransaction(Base):
    """Recurring transaction model for scheduled transactions (RRULE rules)."""

    __tablename__ = "recurring_transactions"

    id: Mapped[UUID] = col.uuid_pk(uuid4_factory)
    user_uuid: Mapped[UUID] = col.uuid_fk("users", ondelete="CASCADE", index=True, column="uuid")

    type: Mapped[str] = mapped_column(String(20))

    source_account_id: Mapped[UUID | None] = col.uuid_column(nullable=True)
    target_account_id: Mapped[UUID | None] = col.uuid_column(nullable=True)

    amount_type: Mapped[str] = mapped_column(String(20), default="FIXED")
    requires_confirmation: Mapped[bool] = mapped_column(Boolean, default=False)
    amount: Mapped[Decimal] = col.numeric(precision=28, scale=8)
    currency: Mapped[str] = mapped_column(String(3), default="CNY")

    category_key: Mapped[str] = mapped_column(String(50), default="OTHERS")
    tags: Mapped[list[str] | None] = mapped_column(JSONB, nullable=True)

    recurrence_rule: Mapped[str] = mapped_column(String(255))
    timezone: Mapped[str] = mapped_column(String(50), default="Asia/Shanghai")
    start_date: Mapped[date] = col.date_column()
    end_date: Mapped[date | None] = col.date_column(nullable=True)

    exception_dates: Mapped[list[str] | None] = mapped_column(JSONB, nullable=True)
    last_generated_at: Mapped[datetime | None] = col.datetime_tz(nullable=True)
    next_execution_at: Mapped[datetime | None] = col.datetime_tz(nullable=True)

    description: Mapped[str | None] = mapped_column(String, nullable=True)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    created_at: Mapped[datetime] = col.timestamptz()
    updated_at: Mapped[datetime | None] = col.timestamptz(nullable=True)

    @field_validator("recurrence_rule")
    @classmethod
    def validate_recurrence_rule(cls, v: str) -> str:
        """Validate RRULE format using dateutil."""
        if not v or not v.strip():
            raise ValueError("Recurrence rule cannot be empty")

        rule = v.strip().upper()

        if not rule.startswith("FREQ="):
            raise ValueError("Invalid RRULE format: must start with FREQ=")

        valid_freqs = {"DAILY", "WEEKLY", "MONTHLY", "YEARLY"}
        freq_part = rule.split(";")[0].replace("FREQ=", "")
        if freq_part not in valid_freqs:
            raise ValueError(f"Invalid frequency: {freq_part}. Must be one of {valid_freqs}")

        return rule

    @field_validator("type")
    @classmethod
    def validate_type(cls, v: str) -> str:
        """Validate transaction type."""
        valid_types = {"EXPENSE", "INCOME", "TRANSFER"}
        if v.upper() not in valid_types:
            raise ValueError(f"Type must be one of: {', '.join(valid_types)}")
        return v.upper()

    @field_validator("amount_type")
    @classmethod
    def validate_amount_type(cls, v: str) -> str:
        """Validate amount type."""
        valid_types = {"FIXED", "ESTIMATE"}
        if v.upper() not in valid_types:
            raise ValueError(f"Amount type must be one of: {', '.join(valid_types)}")
        return v.upper()

    @property
    def amount_float(self) -> float:
        """Get amount as float."""
        return float(self.amount)


class TransactionShare(Base):
    """Transaction share model for sharing transactions between users."""

    __tablename__ = "transaction_shares"

    id: Mapped[UUID | None] = mapped_column(primary_key=True)
    transaction_id: Mapped[UUID] = col.uuid_fk("transactions", ondelete="CASCADE")
    sharer_user_uuid: Mapped[UUID] = col.uuid_fk("users", ondelete="CASCADE", column="uuid")
    shared_with_user_uuid: Mapped[UUID] = col.uuid_fk("users", ondelete="CASCADE", column="uuid")
    can_view: Mapped[bool] = mapped_column(Boolean, default=True)
    shared_at: Mapped[datetime] = col.datetime_tz()
    expires_at: Mapped[datetime] = col.datetime_tz()

    transaction: Mapped[Transaction | None] = relationship("Transaction", back_populates="shares")
    sharer: Mapped[User | None] = relationship(
        "User",
        foreign_keys="[TransactionShare.sharer_user_uuid]",
        primaryjoin="TransactionShare.sharer_user_uuid == User.uuid",
    )
    shared_with: Mapped[User | None] = relationship(
        "User",
        foreign_keys="[TransactionShare.shared_with_user_uuid]",
        primaryjoin="TransactionShare.shared_with_user_uuid == User.uuid",
    )
