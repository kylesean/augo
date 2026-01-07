"""Transaction models for financial management."""

from datetime import date, datetime
from decimal import Decimal
from typing import TYPE_CHECKING, Optional
from uuid import UUID, uuid4

import sqlalchemy as sa
from pydantic import field_validator
from sqlalchemy import Numeric
from sqlalchemy.dialects.postgresql import (
    JSONB,
    TIMESTAMP,
    UUID as PGUUID,
)
from sqlalchemy.types import DateTime
from sqlmodel import Column, Field, Relationship

from app.models.base import BaseModel

if TYPE_CHECKING:
    from app.models.financial_account import FinancialAccount
    from app.models.user import User


class Transaction(BaseModel, table=True):
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

    id: Optional[UUID] = Field(default=None, sa_column=Column(PGUUID(as_uuid=True), primary_key=True))
    user_uuid: UUID = Field(sa_column=Column(PGUUID(as_uuid=True), nullable=False, index=True))
    type: str = Field(max_length=20)  # EXPENSE, INCOME, TRANSFER
    source_account_id: Optional[UUID] = Field(
        default=None,
        sa_column=Column(
            PGUUID(as_uuid=True),
            sa.ForeignKey("financial_accounts.id", ondelete="SET NULL"),
            nullable=True,
            index=True,
        ),
    )
    target_account_id: Optional[UUID] = Field(
        default=None,
        sa_column=Column(
            PGUUID(as_uuid=True),
            sa.ForeignKey("financial_accounts.id", ondelete="SET NULL"),
            nullable=True,
            index=True,
        ),
    )
    amount_original: Decimal = Field(sa_column=Column(Numeric(20, 8)))
    amount: Decimal = Field(sa_column=Column(Numeric(20, 8)))
    currency: str = Field(max_length=3, default="CNY")
    exchange_rate: Optional[Decimal] = Field(default=None, sa_column=Column(Numeric(20, 8)))
    transaction_at: datetime = Field(sa_column=Column(DateTime(timezone=True), nullable=False, index=True))
    transaction_timezone: str = Field(max_length=50, default="UTC")
    tags: Optional[list[str]] = Field(default=None, sa_column=Column(JSONB))
    location: Optional[str] = Field(default=None, max_length=255)
    latitude: Optional[Decimal] = Field(default=None, sa_column=Column(Numeric(9, 6)))
    longitude: Optional[Decimal] = Field(default=None, sa_column=Column(Numeric(9, 6)))
    source: str = Field(max_length=20, default="MANUAL")
    status: str = Field(max_length=20, default="CLEARED")
    description: Optional[str] = None
    raw_input: str = Field(default="")  # NOT NULL in DDL
    category_key: str = Field(max_length=25, default="")
    subject: str = Field(max_length=20, default="SELF")  # Transaction beneficiary
    intent: str = Field(max_length=20, default="SURVIVAL")  # Transaction motivation
    source_thread_id: Optional[UUID] = Field(
        default=None,
        sa_column=Column(PGUUID(as_uuid=True), nullable=True, index=True),
        description="Source AI chat session ID for message anchor navigation",
    )

    # Relationships
    comments: list["TransactionComment"] = Relationship(
        back_populates="transaction", sa_relationship_kwargs={"cascade": "all, delete-orphan"}
    )
    shares: list["TransactionShare"] = Relationship(
        back_populates="transaction", sa_relationship_kwargs={"cascade": "all, delete-orphan"}
    )

    source_account: Optional["FinancialAccount"] = Relationship(
        sa_relationship_kwargs={
            "foreign_keys": "[Transaction.source_account_id]",
        }
    )

    target_account: Optional["FinancialAccount"] = Relationship(
        sa_relationship_kwargs={
            "foreign_keys": "[Transaction.target_account_id]",
        }
    )

    @property
    def amount_float(self) -> float:
        """Get amount as float.

        Returns:
            float: Amount value
        """
        return float(self.amount)

    @property
    def amount_original_float(self) -> float:
        """Get original amount as float.

        Returns:
            float: Original amount value
        """
        return float(self.amount_original)

    @property
    def absolute_amount(self) -> float:
        """Get absolute value of amount.

        Returns:
            float: Absolute amount value
        """
        return abs(float(self.amount))

    @property
    def is_income(self) -> bool:
        """Check if transaction is income.

        Returns:
            bool: True if type is 'income'
        """
        return self.type == "INCOME"

    @property
    def is_expense(self) -> bool:
        """Check if transaction is expense.

        Returns:
            bool: True if type is 'expense'
        """
        return self.type == "EXPENSE"

    @property
    def is_transfer(self) -> bool:
        """Check if transaction is transfer.

        Returns:
            bool: True if type is 'transfer'
        """
        return self.type == "TRANSFER"


class TransactionComment(BaseModel, table=True):
    """Transaction comment model for storing comments on transactions.

    Attributes:
        id: The primary key
        transaction_id: Foreign key to transactions table
        user_uuid: Foreign key to users table (commenter, references users.uuid)
        parent_comment_id: Foreign key to parent comment (for nested comments)
        comment_text: The comment text
        mentioned_user_ids: Array of mentioned user IDs
        created_at: When the comment was created
        updated_at: When the comment was last updated
        transaction: Relationship to transaction
        user: Relationship to user (commenter)
    """

    __tablename__ = "transaction_comments"

    id: Optional[int] = Field(default=None, primary_key=True, sa_column_kwargs={"autoincrement": True})
    transaction_id: UUID = Field(
        sa_column=Column(
            PGUUID(as_uuid=True), sa.ForeignKey("transactions.id", ondelete="CASCADE"), nullable=False, index=True
        )
    )
    user_uuid: UUID = Field(
        sa_column=Column(
            PGUUID(as_uuid=True), sa.ForeignKey("users.uuid", ondelete="CASCADE"), nullable=False, index=True
        )
    )
    parent_comment_id: Optional[int] = Field(default=None, foreign_key="transaction_comments.id")
    comment_text: str
    mentioned_user_ids: Optional[list[int]] = Field(default=None, sa_column=Column(JSONB))

    # Relationships
    transaction: Optional[Transaction] = Relationship(back_populates="comments")
    user: Optional["User"] = Relationship(
        sa_relationship_kwargs={
            "foreign_keys": "[TransactionComment.user_uuid]",
            "primaryjoin": "TransactionComment.user_uuid == User.uuid",
        }
    )

    @field_validator("comment_text")
    @classmethod
    def validate_comment_text(cls, v: str) -> str:
        """Validate comment text is not empty.

        Args:
            v: Comment text to validate

        Returns:
            str: Validated comment text

        Raises:
            ValueError: If comment is empty
        """
        if not v or not v.strip():
            raise ValueError("Comment text cannot be empty")
        return v.strip()


class RecurringTransaction(BaseModel, table=True):
    """Recurring transaction model for scheduled transactions (RRULE rules).

    Attributes:
        id: The primary key (UUID)
        user_uuid: Foreign key to users.uuid
        type: Transaction type (EXPENSE, INCOME, TRANSFER)
        source_account_id: Source/expense account UUID
        target_account_id: Target/income account UUID
        amount_type: Amount type (FIXED for fixed amounts, ESTIMATE for references)
        requires_confirmation: If true, requires confirmation before generating transaction
        amount: Transaction amount (Decimal, high precision)
        currency: Currency code (CNY, USD, JPY, etc.)
        category_key: Category key string
        tags: Fine-grained tags (JSONB array)
        recurrence_rule: RRULE format recurrence rule (iCalendar standard)
        timezone: Timezone for the rule (important for cross-timezone handling)
        start_date: Start date for recurrence
        end_date: End date for recurrence (optional, NULL means infinite)
        exception_dates: List of exception dates (JSON array)
        last_generated_at: Last time a Transaction was generated
        next_execution_at: Next scheduled execution time
        description: Transaction description
        is_active: Whether the recurring transaction is active
        created_at: When the record was created
        updated_at: When the record was last updated
    """

    __tablename__ = "recurring_transactions"

    id: Optional[UUID] = Field(default_factory=uuid4, sa_column=Column(PGUUID(as_uuid=True), primary_key=True))
    user_uuid: UUID = Field(
        sa_column=Column(
            PGUUID(as_uuid=True), sa.ForeignKey("users.uuid", ondelete="CASCADE"), nullable=False, index=True
        )
    )

    # Transaction type: EXPENSE, INCOME, TRANSFER
    type: str = Field(max_length=20)

    # Account references
    source_account_id: Optional[UUID] = Field(default=None, sa_column=Column(PGUUID(as_uuid=True), nullable=True))
    target_account_id: Optional[UUID] = Field(default=None, sa_column=Column(PGUUID(as_uuid=True), nullable=True))

    # Amount settings
    amount_type: str = Field(max_length=20, default="FIXED")  # FIXED or ESTIMATE
    requires_confirmation: bool = Field(default=False)
    amount: Decimal = Field(sa_column=Column(Numeric(28, 8), nullable=False))
    currency: str = Field(max_length=3, default="CNY")

    # Classification
    category_key: str = Field(max_length=50, default="OTHERS")
    tags: Optional[list[str]] = Field(default=None, sa_column=Column(JSONB))

    # Rule engine
    recurrence_rule: str = Field(max_length=255)  # RRULE format (iCalendar)
    timezone: str = Field(max_length=50, default="Asia/Shanghai")
    start_date: date
    end_date: Optional[date] = None

    # Execution control
    exception_dates: Optional[list[str]] = Field(default=None, sa_column=Column(JSONB, default=[]))
    last_generated_at: Optional[datetime] = Field(
        default=None, sa_column=Column(TIMESTAMP(timezone=True), nullable=True)
    )
    next_execution_at: Optional[datetime] = Field(
        default=None, sa_column=Column(TIMESTAMP(timezone=True), nullable=True)
    )

    # Metadata
    description: Optional[str] = None
    is_active: bool = Field(default=True)

    @field_validator("recurrence_rule")
    @classmethod
    def validate_recurrence_rule(cls, v: str) -> str:
        """Validate RRULE format using dateutil.

        Args:
            v: RRULE string to validate

        Returns:
            str: Validated RRULE string

        Raises:
            ValueError: If RRULE format is invalid
        """
        if not v or not v.strip():
            raise ValueError("Recurrence rule cannot be empty")

        rule = v.strip().upper()

        # Basic validation - should start with FREQ=
        if not rule.startswith("FREQ="):
            raise ValueError("Invalid RRULE format: must start with FREQ=")

        # Validate FREQ value
        valid_freqs = {"DAILY", "WEEKLY", "MONTHLY", "YEARLY"}
        freq_part = rule.split(";")[0].replace("FREQ=", "")
        if freq_part not in valid_freqs:
            raise ValueError(f"Invalid frequency: {freq_part}. Must be one of {valid_freqs}")

        # Parse and validate each part
        parts = rule.split(";")
        for part in parts:
            if "=" not in part:
                raise ValueError(f"Invalid RRULE part: {part}")
            key, value = part.split("=", 1)
            if key == "INTERVAL":
                try:
                    interval = int(value)
                except ValueError:
                    raise ValueError(f"Invalid INTERVAL value: {value}")

                if interval < 1:
                    raise ValueError("INTERVAL must be >= 1")
            elif key == "BYDAY":
                valid_days = {"MO", "TU", "WE", "TH", "FR", "SA", "SU"}
                days = value.split(",")
                for day in days:
                    # Handle ordinal weekdays like 1MO, -1FR
                    clean_day = day.lstrip("-0123456789")
                    if clean_day not in valid_days:
                        raise ValueError(f"Invalid day: {day}")
            elif key == "BYMONTHDAY":
                try:
                    day_num = int(value)
                except ValueError:
                    raise ValueError(f"Invalid BYMONTHDAY value: {value}")

                if day_num < 1 or day_num > 31:
                    raise ValueError("BYMONTHDAY must be 1-31")

        return rule

    @field_validator("type")
    @classmethod
    def validate_type(cls, v: str) -> str:
        """Validate transaction type.

        Args:
            v: Type string to validate

        Returns:
            str: Validated type string

        Raises:
            ValueError: If type is invalid
        """
        valid_types = {"EXPENSE", "INCOME", "TRANSFER"}
        if v.upper() not in valid_types:
            raise ValueError(f"Type must be one of: {', '.join(valid_types)}")
        return v.upper()

    @field_validator("amount_type")
    @classmethod
    def validate_amount_type(cls, v: str) -> str:
        """Validate amount type.

        Args:
            v: Amount type string to validate

        Returns:
            str: Validated amount type string

        Raises:
            ValueError: If amount type is invalid
        """
        valid_types = {"FIXED", "ESTIMATE"}
        if v.upper() not in valid_types:
            raise ValueError(f"Amount type must be one of: {', '.join(valid_types)}")
        return v.upper()

    @property
    def amount_float(self) -> float:
        """Get amount as float.

        Returns:
            float: Amount value
        """
        return float(self.amount)


class TransactionShare(BaseModel, table=True):
    """Transaction share model for sharing transactions between users.

    Attributes:
        id: The primary key (UUID)
        transaction_id: Foreign key to transactions table (UUID)
        sharer_user_uuid: Foreign key to users.uuid (user who shares)
        shared_with_user_uuid: Foreign key to users.uuid (user shared with)
        can_view: Whether the shared user can view the transaction
        shared_at: When the share was created
        expires_at: When the share expires
        created_at: Record creation timestamp
        updated_at: Record update timestamp
        transaction: Relationship to transaction
        sharer: Relationship to sharer user
        shared_with: Relationship to user shared with
    """

    __tablename__ = "transaction_shares"

    id: Optional[UUID] = Field(default=None, sa_column=Column(PGUUID(as_uuid=True), primary_key=True))
    transaction_id: UUID = Field(
        sa_column=Column(PGUUID(as_uuid=True), sa.ForeignKey("transactions.id", ondelete="CASCADE"), nullable=False)
    )
    sharer_user_uuid: UUID = Field(
        sa_column=Column(PGUUID(as_uuid=True), sa.ForeignKey("users.uuid", ondelete="CASCADE"), nullable=False)
    )
    shared_with_user_uuid: UUID = Field(
        sa_column=Column(PGUUID(as_uuid=True), sa.ForeignKey("users.uuid", ondelete="CASCADE"), nullable=False)
    )
    can_view: bool = Field(default=True)
    shared_at: datetime = Field(sa_column=Column(TIMESTAMP(timezone=True), nullable=False))
    expires_at: datetime = Field(sa_column=Column(TIMESTAMP(timezone=True), nullable=False))

    # Relationships
    transaction: Optional[Transaction] = Relationship(back_populates="shares")
    sharer: Optional["User"] = Relationship(
        sa_relationship_kwargs={
            "foreign_keys": "[TransactionShare.sharer_user_uuid]",
            "primaryjoin": "TransactionShare.sharer_user_uuid == User.uuid",
        }
    )
    shared_with: Optional["User"] = Relationship(
        sa_relationship_kwargs={
            "foreign_keys": "[TransactionShare.shared_with_user_uuid]",
            "primaryjoin": "TransactionShare.shared_with_user_uuid == User.uuid",
        }
    )


# Avoid circular imports
from app.models.user import User  # noqa: E402
