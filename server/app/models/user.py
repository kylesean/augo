"""This file contains the user model for the application."""

import uuid as uuid_lib
from datetime import datetime
from typing import (
    TYPE_CHECKING,
    Optional,
)

import bcrypt
from psycopg.types.net import ip_address
from pydantic import field_validator, model_validator
from sqlalchemy import Column, DateTime
from sqlalchemy.dialects import postgresql
from sqlmodel import (
    Field,
    Relationship,
)

from app.models.base import BaseModel

if TYPE_CHECKING:
    from app.models.financial_account import FinancialAccount


class User(BaseModel, table=True):
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

    id: Optional[int] = Field(default=None, primary_key=True, sa_column_kwargs={"autoincrement": True})
    uuid: uuid_lib.UUID = Field(unique=True, index=True)
    username: str = Field(max_length=50)
    email: Optional[str] = Field(default=None, unique=True, index=True, max_length=100)
    mobile: Optional[str] = Field(default=None, unique=True, index=True, max_length=20)
    password: str = Field(max_length=255)
    avatar_url: Optional[str] = Field(default=None, max_length=500)
    timezone: str = Field(default="Asia/Shanghai", max_length=100)
    registration_type: str = Field(max_length=20)  # 'email' or 'mobile'
    last_login_ip: Optional[str] = Field(default=None, sa_column=Column(postgresql.INET, nullable=True))
    last_login_at: Optional[datetime] = Field(default=None, sa_type=DateTime(timezone=True))
    # Relationships
    settings: Optional["UserSettings"] = Relationship(
        sa_relationship_kwargs={
            "foreign_keys": "[UserSettings.user_uuid]",
            "primaryjoin": "User.uuid == UserSettings.user_uuid",
            "uselist": False,
            "overlaps": "user",
        }
    )
    financial_accounts: list["FinancialAccount"] = Relationship(
        sa_relationship_kwargs={
            "foreign_keys": "[FinancialAccount.user_uuid]",
            "primaryjoin": "User.uuid == FinancialAccount.user_uuid",
            "overlaps": "user",
        }
    )

    @field_validator("email")
    @classmethod
    def validate_email(cls, v: Optional[str]) -> Optional[str]:
        """Validate and normalize email format.

        Args:
            v: Email value to validate

        Returns:
            Optional[str]: Validated and normalized email or None

        Raises:
            ValueError: If email format is invalid
        """
        if v is None:
            return v

        v_stripped = v.strip() if isinstance(v, str) else str(v)
        if not v_stripped:
            return None

        # Basic email validation
        if "@" not in v_stripped or "." not in v_stripped.split("@")[-1]:
            raise ValueError("Invalid email format")

        return v_stripped.lower()

    @field_validator("mobile")
    @classmethod
    def validate_mobile(cls, v: Optional[str]) -> Optional[str]:
        """Validate mobile number format.

        Args:
            v: Mobile number to validate

        Returns:
            Optional[str]: Validated mobile or None

        Raises:
            ValueError: If mobile format is invalid
        """
        if v is not None and v.strip():
            # Remove common separators
            cleaned = v.strip().replace("-", "").replace(" ", "").replace("(", "").replace(")", "")
            # Basic validation: should be digits and reasonable length
            if not cleaned.isdigit() or len(cleaned) < 8 or len(cleaned) > 15:
                raise ValueError("Invalid mobile number format")
            return cleaned
        return v

    @field_validator("last_login_ip")
    @classmethod
    def validate_ip_address(cls, v: Optional[str]) -> Optional[str]:
        """Validate IP address format for PostgresSQL INET type.

        Args:
            v: IP address string to validate

        Returns:
            Optional[str]: Validated IP address or None

        Raises:
            ValueError: If IP address format is invalid
        """
        if v is None or not v.strip():
            return None
        try:
            ip_obj = ip_address(v.strip())
            return str(ip_obj)
        except ValueError as e:
            raise ValueError(f"Invalid IP address format: {e}")

    @model_validator(mode="after")
    def validate_contact_info(self) -> "User":
        """Ensure at least one contact method (email or mobile) is provided.

        Returns:
            User: The validated user instance

        Raises:
            ValueError: If neither email nor mobile is provided
        """
        if not self.email and not self.mobile:
            raise ValueError("Either email or mobile must be provided")
        return self

    def verify_password(self, password: str) -> bool:
        """Verify if the provided password matches the hash.

        Args:
            password: Plain text password to verify

        Returns:
            bool: True if password matches, False otherwise
        """
        return bcrypt.checkpw(password.encode("utf-8"), self.password.encode("utf-8"))

    @staticmethod
    def hash_password(password: str) -> str:
        """Hash a password using bcrypt.

        Args:
            password: Plain text password to hash

        Returns:
            str: Bcrypt hashed password
        """
        salt = bcrypt.gensalt()
        return bcrypt.hashpw(password.encode("utf-8"), salt).decode("utf-8")

    @property
    def hashed_password(self) -> str:
        """Alias for password field to maintain compatibility.

        Returns:
            str: The hashed password
        """
        return self.password

    @property
    def display_name(self) -> str:
        """Get display name for the user.

        Returns:
            str: Username or email/mobile as fallback
        """
        return self.username or self.email or self.mobile or "Unknown User"

    @property
    def contact_info(self) -> str:
        """Get primary contact information.

        Returns:
            str: Email or mobile number
        """
        return self.email or self.mobile or ""


class UserSettings(BaseModel, table=True):
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

    user_uuid: uuid_lib.UUID = Field(sa_column=Column(postgresql.UUID(as_uuid=True), primary_key=True, nullable=False))
    currency: str = Field(default="CNY", max_length=10)
    timezone: str = Field(default="Asia/Shanghai", max_length=100)
    avg_daily_spending: str = Field(default="100.00")  # Decimal(12,2) as string
    safety_balance_threshold: str = Field(default="500.00")  # Decimal(12,2) as string

    # Relationship
    user: Optional[User] = Relationship(
        sa_relationship_kwargs={
            "foreign_keys": "[UserSettings.user_uuid]",
            "primaryjoin": "UserSettings.user_uuid == User.uuid",
            "overlaps": "settings",
        }
    )

    @field_validator("safety_balance_threshold", "avg_daily_spending")
    @classmethod
    def validate_decimal_string(cls, v: str) -> str:
        """Validate that the string represents a valid decimal number.

        Args:
            v: Decimal string to validate

        Returns:
            str: Validated decimal string

        Raises:
            ValueError: If the string is not a valid decimal
        """
        try:
            from decimal import Decimal

            # Validate it's a valid decimal
            decimal_val = Decimal(v)
            # Ensure it's non-negative
            if decimal_val < 0:
                raise ValueError("Value must be non-negative")
            # Format to 2 decimal places
            return f"{decimal_val:.2f}"
        except Exception as e:
            raise ValueError(f"Invalid decimal format: {e}")

    @property
    def safety_threshold_float(self) -> float:
        """Get safety threshold as float.

        Returns:
            float: Safety threshold value
        """
        return float(self.safety_balance_threshold)

    @property
    def avg_spending_float(self) -> float:
        """Get average spending as float.

        Returns:
            float: Average spending value
        """
        return float(self.avg_daily_spending)
