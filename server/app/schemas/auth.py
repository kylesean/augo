"""This file contains the authentication schema for the application."""

import re
from datetime import datetime
from typing import Literal
from uuid import UUID

from pydantic import (
    BaseModel,
    ConfigDict,
    EmailStr,
    Field,
    SecretStr,
    field_validator,
    model_validator,
)


class Token(BaseModel):
    """Token model for authentication.

    Attributes:
        access_token: The JWT access token.
        token_type: The type of token (always "bearer").
        expires_at: The token expiration timestamp.
    """

    access_token: str = Field(..., description="The JWT access token")
    token_type: str = Field(default="bearer", description="The type of token")
    expires_at: datetime = Field(..., description="The token expiration timestamp")


class TokenResponse(BaseModel):
    """Response model for login endpoint.

    Attributes:
        access_token: The JWT access token
        token_type: The type of token (always "bearer")
        expires_at: When the token expires
    """

    access_token: str = Field(..., description="The JWT access token")
    token_type: str = Field(default="bearer", description="The type of token")
    expires_at: datetime = Field(..., description="When the token expires")


class UserCreate(BaseModel):
    """Request model for user registration.

    Attributes:
        email: User's email address
        password: User's password
    """

    email: EmailStr = Field(..., description="User's email address")
    password: SecretStr = Field(..., description="User's password", min_length=6, max_length=32)

    @field_validator("password")
    @classmethod
    def validate_password(cls, v: SecretStr) -> SecretStr:
        """Validate password strength.

        Args:
            v: The password to validate

        Returns:
            SecretStr: The validated password

        Raises:
            ValueError: If the password is not strong enough
        """
        password = v.get_secret_value()

        # Check for common password requirements
        if len(password) < 6:
            raise ValueError("Password must be at least 8 characters long")

        return v


class UserResponse(BaseModel):
    """Response model for user operations.

    Attributes:
        id: User's ID
        email: User's email address
        token: Authentication token
    """

    id: int = Field(..., description="User's ID")
    email: str = Field(..., description="User's email address")
    token: Token = Field(..., description="Authentication token")


class SessionResponse(BaseModel):
    """Response model for session creation.

    Attributes:
        session_id: The unique identifier for the chat session
        name: Name of the session (defaults to empty string)
        token: The authentication token for the session
    """

    session_id: str = Field(..., description="The unique identifier for the chat session")
    name: str = Field(default="", description="Name of the session", max_length=100)
    token: Token = Field(..., description="The authentication token for the session")

    @field_validator("name")
    @classmethod
    def sanitize_name(cls, v: str) -> str:
        """Sanitize the session name.

        Args:
            v: The name to sanitize

        Returns:
            str: The sanitized name
        """
        # Remove any potentially harmful characters
        sanitized = re.sub(r'[<>{}[\]()\'"`]', "", v)
        return sanitized


def _validate_email(email: str) -> bool:
    """Validate email format."""
    return "@" in email and "." in email.split("@")[-1]


def _validate_mobile(mobile: str) -> bool:
    """Validate Chinese mobile number format."""
    return bool(re.match(r"^1[3-9]\d{9}$", mobile))


class SendCodeRequest(BaseModel):
    """Request model for sending verification code.

    Attributes:
        type: Account type ('email' or 'mobile')
        account: Email address or mobile number
    """

    model_config = ConfigDict(json_schema_extra={"examples": [{"type": "email", "account": "user@example.com"}]})

    type: Literal["email", "mobile"] = Field(..., description="Account type", examples=["email"])
    account: str = Field(..., description="Email address or mobile number", examples=["user@example.com"])

    @field_validator("account")
    @classmethod
    def validate_account_not_empty(cls, v: str) -> str:
        """Validate account is not empty."""
        if not v or not v.strip():
            raise ValueError("Account cannot be empty")
        return v.strip()

    @model_validator(mode="after")
    def validate_account_format(self) -> "SendCodeRequest":
        """Validate account format based on type."""
        if self.type == "email" and not _validate_email(self.account):
            raise ValueError("account: Invalid email format")
        elif self.type == "mobile" and not _validate_mobile(self.account):
            raise ValueError("account: Invalid mobile number format")
        return self


class RegisterRequest(BaseModel):
    """Request model for user registration.

    Attributes:
        type: Account type ('email' or 'mobile')
        account: Email address or mobile number
        password: User's password (6-20 characters)
        code: 6-digit verification code
        timezone: User's timezone (default: Asia/Shanghai)
    """

    model_config = ConfigDict(
        validate_default=True,
        json_schema_extra={
            "examples": [
                {
                    "type": "email",
                    "account": "user@example.com",
                    "password": "password123",
                    "code": "123456",
                    "timezone": "Asia/Shanghai",
                }
            ]
        },
    )

    type: Literal["email", "mobile"] = Field(..., description="Account type", examples=["email"])
    account: str = Field(..., description="Email address or mobile number", examples=["user@example.com"])
    password: str = Field(..., min_length=6, max_length=20, description="User's password", examples=["password123"])
    code: str = Field(default="", description="Verification code (Optional in current dev mode)", examples=["123456"])
    timezone: str = Field(default="Asia/Shanghai", description="User's timezone", examples=["Asia/Shanghai"])
    locale: str | None = Field(
        default=None,
        description="Device locale for smart currency defaults (e.g., 'zh_CN', 'en_US', 'ja_JP')",
        examples=["zh_CN", "en_US"],
    )

    @field_validator("account")
    @classmethod
    def validate_account_not_empty(cls, v: str) -> str:
        """Validate account is not empty."""
        if not v or not v.strip():
            raise ValueError("Account cannot be empty")
        return v.strip()

    # Commented out for development testing
    # @field_validator("code")
    # @classmethod
    # def validate_code_numeric(cls, v: str) -> str:
    @model_validator(mode="after")
    def validate_account_format(self) -> "RegisterRequest":
        """Validate account format based on type."""
        if self.type == "email" and not _validate_email(self.account):
            raise ValueError("account: Invalid email format")
        elif self.type == "mobile" and not _validate_mobile(self.account):
            raise ValueError("account: Invalid mobile number format")
        return self


class LoginRequest(BaseModel):
    """Request model for user login.

    Attributes:
        type: Account type ('email' or 'mobile')
        account: Email address or mobile number
        password: User's password
        timezone: User's timezone
    """

    model_config = ConfigDict(
        json_schema_extra={
            "examples": [{"type": "email", "account": "jkx@qq.com", "password": "123456", "timezone": "Asia/Shanghai"}]
        }
    )

    type: Literal["email", "mobile"] = Field(..., description="Account type", examples=["email"])
    account: str = Field(..., description="Email address or mobile number", examples=["jkx@qq.com"])
    password: str = Field(..., description="User's password", examples=["123456"])
    timezone: str = Field(..., description="User's timezone", examples=["Asia/Shanghai"])

    @model_validator(mode="after")
    def validate_account_format(self) -> "LoginRequest":
        """Validate account format based on type.

        Returns:
            LoginRequest: The validated instance

        Raises:
            ValueError: If account format doesn't match type
        """
        if self.type == "email":
            if "@" not in self.account or "." not in self.account.split("@")[-1]:
                raise ValueError("Invalid email format")
        elif self.type == "mobile":
            if not re.match(r"^1[3-9]\d{9}$", self.account):
                raise ValueError("Invalid mobile number format")
        return self


class UserInfo(BaseModel):
    """User information model.

    Attributes:
        id: User's UUID
        email: User's email
        mobile: User's mobile number
        username: User's username
        avatarUrl: User's avatar URL
        createdAt: Account creation timestamp
        updatedAt: Last update timestamp
        clientLastLoginAt: Last login timestamp
    """

    id: UUID = Field(..., description="User's UUID")
    email: str | None = Field(None, description="User's email")
    mobile: str | None = Field(None, description="User's mobile number")
    username: str = Field(..., description="User's username")
    avatarUrl: str | None = Field(None, description="User's avatar URL")
    createdAt: str = Field(..., description="Account creation timestamp (ISO 8601)")
    updatedAt: str = Field(..., description="Last update timestamp (ISO 8601)")
    clientLastLoginAt: str | None = Field(None, description="Last login timestamp (ISO 8601)")


class AuthResponse(BaseModel):
    """Response model for authentication endpoints (register/login).

    Attributes:
        token: JWT authentication token
        user: User information
    """

    token: str = Field(..., description="JWT authentication token")
    user: UserInfo = Field(..., description="User information")
