"""Pydantic schemas for user management endpoints."""

from decimal import Decimal
from typing import List, Literal, Optional
from uuid import UUID

from pydantic import BaseModel, ConfigDict, Field, field_validator, model_validator

from app.schemas.transaction import TransactionDisplayValue

# =============================================================================
# Financial Account Schemas
# =============================================================================


class FinancialAccountItem(BaseModel):
    """Schema for a single financial account item.

    Attributes:
        name: Account name (e.g., "招商银行储蓄卡")
        nature: Account nature ('ASSET' or 'LIABILITY')
        type: Account type (e.g., 'CASH', 'DEPOSIT', 'CREDIT_CARD')
        initialBalance: Initial balance amount
        currencyCode: Currency code (default: 'CNY')
        includeInNetWorth: Whether to include in net worth calculation
        status: Account status (default: 'ACTIVE')
    """

    name: str = Field(..., description="Account name", max_length=100)
    nature: Literal["ASSET", "LIABILITY"] = Field(..., description="Account nature")
    type: Optional[
        Literal["CASH", "DEPOSIT", "E_MONEY", "INVESTMENT", "RECEIVABLE", "CREDIT_CARD", "LOAN", "PAYABLE"]
    ] = Field(None, description="Account type", max_length=50)
    initialBalance: str = Field(default="0", description="Initial balance", alias="initial_balance")
    currentBalance: str = Field(default="0", description="Current balance", alias="current_balance")
    currencyCode: str = Field(default="CNY", description="Currency code", alias="currency_code", max_length=3)
    includeInNetWorth: bool = Field(
        default=True, description="Include in net worth calculation", alias="include_in_net_worth"
    )
    includeInCashFlow: bool = Field(
        default=False, description="Include in cash flow forecast", alias="include_in_cash_flow"
    )
    display: Optional[TransactionDisplayValue] = Field(None, description="Display value object")
    status: Literal["ACTIVE", "INACTIVE", "CLOSED"] = Field(default="ACTIVE", description="Account status")

    model_config = ConfigDict(populate_by_name=True)

    @field_validator("initialBalance")
    @classmethod
    def validate_balance(cls, v: str) -> str:
        """Validate balance is a valid decimal string.

        Args:
            v: Balance string to validate

        Returns:
            str: Validated balance string

        Raises:
            ValueError: If balance is invalid
        """
        try:
            decimal_val = Decimal(v)
            return f"{decimal_val:.8f}"  # 8 decimal places to match DB precision
        except Exception as e:
            raise ValueError(f"Invalid balance format: {e}")

    @field_validator("currentBalance")
    @classmethod
    def validate_current_balance(cls, v: str) -> str:
        """Validate current balance is a valid decimal string."""
        try:
            decimal_val = Decimal(v)
            return f"{decimal_val:.8f}"
        except Exception as e:
            raise ValueError(f"Invalid balance format: {e}")

    @field_validator("nature")
    @classmethod
    def validate_nature(cls, v: str) -> str:
        """Validate nature is either ASSET or LIABILITY."""
        if v not in ("ASSET", "LIABILITY"):
            raise ValueError("nature must be 'ASSET' or 'LIABILITY'")
        return v


class SaveFinancialAccountsRequest(BaseModel):
    """Request schema for saving financial accounts.

    Attributes:
        accounts: List of financial account items
    """

    accounts: List[FinancialAccountItem] = Field(..., description="List of financial accounts")

    @field_validator("accounts")
    @classmethod
    def validate_accounts_not_empty(cls, v: List[FinancialAccountItem]) -> List[FinancialAccountItem]:
        """Validate that accounts list is not empty.

        Args:
            v: List of accounts to validate

        Returns:
            List[FinancialAccountItem]: Validated accounts list

        Raises:
            ValueError: If accounts list is empty
        """
        if not v:
            raise ValueError("Accounts list cannot be empty")
        return v


class FinancialAccountResponse(BaseModel):
    """Response schema for a single financial account.

    Attributes:
        id: Account ID (UUID)
        name: Account name
        nature: Account nature
        type: Account type
        currencyCode: Currency code
        initialBalance: Initial balance
        includeInNetWorth: Whether included in net worth
        status: Account status
        createdAt: Creation timestamp
        updatedAt: Last update timestamp
    """

    id: str  # UUID as string
    name: str
    nature: str
    type: Optional[str] = None
    currencyCode: str
    initialBalance: str
    currentBalance: str = "0"
    includeInNetWorth: bool
    includeInCashFlow: bool = False
    display: Optional[TransactionDisplayValue] = None
    status: str = Field(default="ACTIVE")
    createdAt: Optional[str] = None
    updatedAt: Optional[str] = None


class FinancialAccountsResponse(BaseModel):
    """Response schema for get financial accounts endpoint.

    Attributes:
        accounts: List of financial accounts
        totalBalance: Net worth (assets - liabilities)
        lastUpdatedAt: ISO 8601 timestamp of last update
    """

    accounts: List[FinancialAccountResponse]
    totalBalance: str
    lastUpdatedAt: str


class SaveFinancialAccountsResponse(BaseModel):
    """Response schema for save financial accounts endpoint.

    Attributes:
        totalBalance: Net worth after saving
        lastUpdatedAt: ISO 8601 timestamp of save operation
    """

    totalBalance: str
    lastUpdatedAt: str


class CreateFinancialAccountRequest(BaseModel):
    """Request schema for creating a single financial account."""

    name: str = Field(..., description="Account name", max_length=100)
    nature: Literal["ASSET", "LIABILITY"] = Field(..., description="Account nature")
    type: Optional[
        Literal["CASH", "DEPOSIT", "E_MONEY", "INVESTMENT", "RECEIVABLE", "CREDIT_CARD", "LOAN", "PAYABLE"]
    ] = Field(None, description="Account type", max_length=50)
    initialBalance: str = Field(default="0", description="Initial balance")
    currentBalance: str = Field(default="0", description="Current balance")
    currencyCode: str = Field(default="CNY", description="Currency code", max_length=3)
    includeInNetWorth: bool = Field(default=True, description="Include in net worth calculation")
    includeInCashFlow: bool = Field(default=False, description="Include in cash flow forecast")
    status: Literal["ACTIVE", "INACTIVE", "CLOSED"] = Field(default="ACTIVE", description="Account status")

    @field_validator("initialBalance")
    @classmethod
    def validate_balance(cls, v: str) -> str:
        """Validate that the balance string is a valid decimal format."""
        try:
            decimal_val = Decimal(v)
            return f"{decimal_val:.8f}"
        except Exception as e:
            raise ValueError(f"Invalid balance format: {e}")


class UpdateFinancialAccountRequest(BaseModel):
    """Request schema for updating a financial account."""

    name: Optional[str] = Field(None, max_length=100)
    nature: Optional[Literal["ASSET", "LIABILITY"]] = None
    type: Optional[
        Literal["CASH", "DEPOSIT", "E_MONEY", "INVESTMENT", "RECEIVABLE", "CREDIT_CARD", "LOAN", "PAYABLE"]
    ] = Field(None, max_length=50)
    initialBalance: Optional[str] = None
    currentBalance: Optional[str] = None
    currencyCode: Optional[str] = Field(None, max_length=3)
    includeInNetWorth: Optional[bool] = None
    includeInCashFlow: Optional[bool] = None
    status: Optional[Literal["ACTIVE", "INACTIVE", "CLOSED"]] = None

    @field_validator("initialBalance", "currentBalance")
    @classmethod
    def validate_balance(cls, v: Optional[str]) -> Optional[str]:
        """Validate that the balance string is a valid decimal format or None."""
        if v is None:
            return v
        try:
            decimal_val = Decimal(v)
            return f"{decimal_val:.8f}"
        except Exception as e:
            raise ValueError(f"Invalid balance format: {e}")


# =============================================================================
# Financial Safety Line Schemas
# =============================================================================


class FinancialSafetyLineRequest(BaseModel):
    """Request schema for updating financial safety line.

    Attributes:
        safetyBalanceThreshold: The safety threshold value
        threshold: Alias for safetyBalanceThreshold (for compatibility)
    """

    safetyBalanceThreshold: str = Field(..., description="Safety balance threshold", alias="threshold")

    model_config = ConfigDict(populate_by_name=True)  # Allow both field names

    @field_validator("safetyBalanceThreshold")
    @classmethod
    def validate_threshold(cls, v: str) -> str:
        """Validate threshold is a valid decimal string.

        Args:
            v: Threshold string to validate

        Returns:
            str: Validated threshold string

        Raises:
            ValueError: If threshold is invalid
        """
        try:
            decimal_val = Decimal(v)
            if decimal_val < 0:
                raise ValueError("Threshold must be non-negative")
            return f"{decimal_val:.2f}"
        except Exception as e:
            raise ValueError(f"Invalid threshold format: {e}")


class FinancialSafetyLineResponse(BaseModel):
    """Response schema for financial safety line update.

    Attributes:
        safetyBalanceThreshold: The updated threshold value
        updatedAt: ISO 8601 timestamp of update
    """

    safetyBalanceThreshold: str
    updatedAt: str


# =============================================================================
# Onboarding Schemas
# =============================================================================


class OnboardingStatusResponse(BaseModel):
    """Response schema for onboarding status check.

    Attributes:
        isCompleted: Whether onboarding is complete
    """

    isCompleted: bool


# =============================================================================
# User Settings Schemas
# =============================================================================


class UserSettingsRequest(BaseModel):
    """Request schema for updating user settings.

    Attributes:
        safetyBalanceThreshold: Optional safety threshold
        estimatedAvgDailySpending: Optional estimated daily spending
    """

    safetyBalanceThreshold: Optional[str] = Field(None, description="Safety balance threshold")
    estimatedAvgDailySpending: Optional[str] = Field(None, description="Estimated average daily spending")

    @field_validator("safetyBalanceThreshold", "estimatedAvgDailySpending")
    @classmethod
    def validate_decimal_fields(cls, v: Optional[str]) -> Optional[str]:
        """Validate decimal fields.

        Args:
            v: Value to validate

        Returns:
            Optional[str]: Validated value

        Raises:
            ValueError: If value is invalid
        """
        if v is None:
            return v
        try:
            decimal_val = Decimal(v)
            if decimal_val < 0:
                raise ValueError("Value must be non-negative")
            return f"{decimal_val:.2f}"
        except Exception as e:
            raise ValueError(f"Invalid decimal format: {e}")

    @model_validator(mode="after")
    def validate_at_least_one_field(self) -> "UserSettingsRequest":
        """Validate that at least one field is provided.

        Returns:
            UserSettingsRequest: The validated instance

        Raises:
            ValueError: If no fields are provided
        """
        if self.safetyBalanceThreshold is None and self.estimatedAvgDailySpending is None:
            raise ValueError("At least one field must be provided")
        return self


class UserSettingsResponse(BaseModel):
    """Response schema for user settings.

    Attributes:
        defaultCurrency: Default currency (placeholder, not implemented yet)
        timezone: User's timezone (placeholder, not implemented yet)
        estimatedAvgDailySpending: Estimated average daily spending
        safetyBalanceThreshold: Safety balance threshold
        createdAt: ISO 8601 timestamp of creation
        updatedAt: ISO 8601 timestamp of last update
    """

    defaultCurrency: str = "CNY"  # Placeholder
    timezone: str = "Asia/Shanghai"  # Placeholder
    estimatedAvgDailySpending: str
    safetyBalanceThreshold: str
    createdAt: str
    updatedAt: str


# =============================================================================
# User Info Schemas
# =============================================================================


class UserInfoResponse(BaseModel):
    """Response schema for user information.

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

    id: str
    email: Optional[str] = None
    mobile: Optional[str] = None
    username: str
    avatarUrl: Optional[str] = None
    createdAt: str
    updatedAt: str
    clientLastLoginAt: Optional[str] = None


class UpdateUserProfileRequest(BaseModel):
    """Request schema for updating user profile.

    Attributes:
        username: New username (optional)
        avatarUrl: New avatar URL (optional)
    """

    username: Optional[str] = Field(None, min_length=1, max_length=50, description="User's display name")
    avatarUrl: Optional[str] = Field(None, max_length=500, description="Avatar image URL")

    @model_validator(mode="after")
    def validate_at_least_one_field(self) -> "UpdateUserProfileRequest":
        """Validate that at least one field is provided."""
        if self.username is None and self.avatarUrl is None:
            raise ValueError("At least one field (username or avatarUrl) must be provided")
        return self


# =============================================================================
# Financial Settings Schemas (NEW)
# =============================================================================


class FinancialSettingsResponseSchema(BaseModel):
    """Response schema for financial settings.

    Attributes:
        safetyThreshold: Minimum safe balance threshold
        dailyBurnRate: Daily spending estimate
        burnRateMode: How burn rate is calculated (MANUAL or AI_AUTO)
        primaryCurrency: Default display currency
        monthStartDay: Day of month to start calculations
        updatedAt: Last update timestamp
    """

    safetyThreshold: str
    dailyBurnRate: str
    burnRateMode: Literal["MANUAL", "AI_AUTO"] = "AI_AUTO"
    primaryCurrency: str = "CNY"
    monthStartDay: int = 1
    updatedAt: Optional[str] = None


class UpdateFinancialSettingsRequest(BaseModel):
    """Request schema for updating financial settings.

    All fields are optional - only provided fields will be updated.
    """

    safetyThreshold: Optional[str] = Field(None, description="Minimum safe balance threshold")
    dailyBurnRate: Optional[str] = Field(None, description="Daily spending estimate")
    burnRateMode: Optional[Literal["MANUAL", "AI_AUTO"]] = Field(None, description="Burn rate mode")
    primaryCurrency: Optional[str] = Field(None, max_length=3, description="Primary currency code")
    monthStartDay: Optional[int] = Field(None, ge=1, le=31, description="Month start day")

    @field_validator("safetyThreshold", "dailyBurnRate")
    @classmethod
    def validate_decimal_fields(cls, v: Optional[str]) -> Optional[str]:
        """Validate decimal fields."""
        if v is None:
            return v
        try:
            decimal_val = Decimal(v)
            if decimal_val < 0:
                raise ValueError("Value must be non-negative")
            return f"{decimal_val:.8f}"
        except Exception as e:
            raise ValueError(f"Invalid decimal format: {e}")

    @model_validator(mode="after")
    def validate_at_least_one_field(self) -> "UpdateFinancialSettingsRequest":
        """Validate that at least one field is provided."""
        if all(
            v is None
            for v in [
                self.safetyThreshold,
                self.dailyBurnRate,
                self.burnRateMode,
                self.primaryCurrency,
                self.monthStartDay,
            ]
        ):
            raise ValueError("At least one field must be provided")
        return self
