"""User service for managing user information, settings, and financial accounts."""
from __future__ import annotations

from datetime import datetime
from decimal import Decimal
from typing import Any, cast
from uuid import UUID

from sqlmodel import select
from sqlmodel.ext.asyncio.session import AsyncSession

from app.core.exceptions import NotFoundError
from app.core.logging import logger
from app.models.base import utc_now
from app.models.financial_account import FinancialAccount
from app.models.financial_settings import FinancialSettings
from app.models.transaction import RecurringTransaction
from app.models.user import User, UserSettings
from app.utils.currency_utils import (
    convert_to_display_currency,
    get_user_display_currency,
)


def _format_decimal(value: Decimal, precision: int = 8) -> str:
    """Format a Decimal to a fixed-point string, avoiding scientific notation.

    Args:
        value: The Decimal value to format
        precision: Number of decimal places (default: 8 for DB precision)

    Returns:
        str: Formatted decimal string (e.g., "0.00000000" instead of "0E-8")
    """
    # Use quantize to ensure fixed-point representation
    format_str = Decimal(f"1.{'0' * precision}")
    return str(value.quantize(format_str))


def _format_iso_datetime(dt: datetime | None) -> str | None:
    """Format a datetime to ISO 8601 string with Z suffix.

    Ensures consistent formatting by replacing timezone offset with Z suffix.

    Args:
        dt: The datetime to format (may be None or timezone-aware)

    Returns:
        str: ISO 8601 formatted string ending with Z, or None if input is None
    """
    if dt is None:
        return None
    # Convert to ISO format and replace timezone info with Z
    iso_str = dt.isoformat()
    # Remove any existing timezone info and append Z
    if "+" in iso_str:
        iso_str = iso_str.split("+")[0] + "Z"
    elif iso_str.endswith("Z"):
        pass  # Already has Z suffix
    else:
        iso_str += "Z"
    return iso_str


class UserService:
    """Service for managing user-related operations.

    Handles user information retrieval, settings management,
    financial account CRUD operations, and onboarding status checks.
    """

    def __init__(self, db: AsyncSession):
        """Initialize the user service.

        Args:
            db: Database session for executing queries
        """
        self.db = db

    async def get_user_info(self, user_id: int) -> User:
        """Get user information by ID.

        Args:
            user_id: The user's database ID

        Returns:
            User: The user object

        Raises:
            NotFoundError: If user is not found
        """
        result = await self.db.execute(select(User).where(User.id == user_id))
        user = result.scalar_one_or_none()

        if not user:
            raise NotFoundError("User")

        from typing import cast

        return cast(User, user)

    async def get_user_by_uuid(self, user_uuid: UUID) -> User:
        """Get user information by UUID.

        Args:
            user_uuid: The user's UUID

        Returns:
            User: The user object

        Raises:
            NotFoundError: If user is not found
        """
        result = await self.db.execute(select(User).where(User.uuid == user_uuid))
        user = result.scalar_one_or_none()

        if not user:
            raise NotFoundError("User")

        from typing import cast

        return cast(User, user)

    async def update_user_profile(
        self, user_uuid: UUID, username: str | None = None, avatar_url: str | None = None
    ) -> dict[str, Any]:
        """Update user profile (username and/or avatar).

        Args:
            user_uuid: The user's UUID
            username: Optional new username
            avatar_url: Optional new avatar URL

        Returns:
            Dict containing updated user info

        Raises:
            NotFoundError: If user is not found
        """
        result = await self.db.execute(select(User).where(User.uuid == user_uuid))
        user = result.scalar_one_or_none()

        if not user:
            raise NotFoundError("User")

        now = utc_now()

        if username is not None:
            user.username = username
        if avatar_url is not None:
            user.avatar_url = avatar_url

        user.updated_at = now

        await self.db.commit()
        await self.db.refresh(user)

        logger.info(
            "user_profile_updated",
            user_uuid=str(user_uuid),
            username=user.username,
            has_avatar=user.avatar_url is not None,
        )

        return {
            "id": str(user.uuid),
            "email": user.email,
            "mobile": user.mobile,
            "username": user.username,
            "avatarUrl": user.avatar_url,
            "createdAt": _format_iso_datetime(cast(datetime | None, user.created_at)),
            "updatedAt": _format_iso_datetime(cast(datetime | None, user.updated_at)),
            "lastLoginAt": _format_iso_datetime(cast(datetime | None, user.last_login_at)),
        }

    async def save_financial_accounts(self, user_uuid: UUID, accounts: list[dict[str, Any]]) -> dict[str, Any]:
        """Save or update user's financial accounts.

        Deletes all existing financial accounts and creates new ones based on input.

        Args:
            user_uuid: The user's UUID
            accounts: List of financial account dictionaries with keys:
                - name: str (account name)
                - nature: str ('ASSET' or 'LIABILITY')
                - type: Optional[str] (account type like 'SAVINGS', 'CREDIT_CARD')
                - initialBalance: str (decimal as string)
                - currencyCode: Optional[str] (default: 'CNY')
                - includeInNetWorth: Optional[bool] (default: True)

        Returns:
            Dict containing:
                - totalBalance: str (sum of all balances)
                - lastUpdatedAt: str (ISO 8601 timestamp)

        Raises:
            BusinessError: If validation fails
        """
        # Delete existing financial accounts
        existing_accounts = await self.db.execute(
            select(FinancialAccount).where(FinancialAccount.user_uuid == user_uuid)
        )
        for account in existing_accounts.scalars().all():
            await self.db.delete(account)

        # Calculate total balance and create new accounts
        total_balance = Decimal("0.00")
        now = utc_now()

        for account_data in accounts:
            balance = Decimal(str(account_data.get("initialBalance", "0")))
            nature = account_data.get("nature", "ASSET")

            # Assets contribute positively, liabilities contribute negatively to total
            if nature == "ASSET":
                total_balance += balance
            else:
                total_balance -= abs(balance)

            # Create new financial account
            financial_account = FinancialAccount(
                user_uuid=user_uuid,
                name=account_data["name"],
                nature=nature,
                type=account_data.get("type"),
                currency_code=account_data.get("currencyCode", "CNY"),
                initial_balance=balance,
                current_balance=balance,  # Sync initial_balance to current_balance
                include_in_net_worth=account_data.get("includeInNetWorth", True),
                status=account_data.get("status", "ACTIVE"),
                created_at=now,
                updated_at=now,
            )
            self.db.add(financial_account)

        await self.db.commit()

        logger.info(
            "financial_accounts_saved",
            user_uuid=str(user_uuid),
            account_count=len(accounts),
            total_balance=str(total_balance),
        )

        # get user display currency
        display_currency = await get_user_display_currency(self.db, user_uuid)

        # re-calculate total balance and convert to display currency
        # note: here we need to consider each account's own currency_code
        result = await self.db.execute(
            select(FinancialAccount)
            .where(FinancialAccount.user_uuid == user_uuid)
            .where(FinancialAccount.status == "ACTIVE")
            .where(FinancialAccount.include_in_net_worth == True)  # noqa: E712
        )
        active_accounts = result.scalars().all()

        total_display_balance = Decimal("0.00")
        for acc in active_accounts:
            val = acc.current_balance if acc.current_balance is not None else acc.initial_balance
            conv_val = await convert_to_display_currency(val, acc.currency_code or "CNY", display_currency)
            if acc.nature == "ASSET":
                total_display_balance += conv_val
            else:
                total_display_balance -= abs(conv_val)

        return {"totalBalance": f"{total_display_balance:.2f}", "lastUpdatedAt": _format_iso_datetime(now)}

    async def get_user_financial_accounts(self, user_uuid: UUID) -> dict[str, Any]:
        """Get user's financial accounts.

        Args:
            user_uuid: The user's UUID

        Returns:
            Dict containing:
                - accounts: List of financial account dictionaries
                - totalBalance: str (net worth: assets - liabilities)
                - lastUpdatedAt: str (ISO 8601 timestamp of most recent update)
        """
        result = await self.db.execute(
            select(FinancialAccount)
            .where(FinancialAccount.user_uuid == user_uuid)
            .order_by(FinancialAccount.created_at)
        )
        accounts = result.scalars().all()

        # 1. 基础汇总逻辑
        total_balance = Decimal("0.00")
        max_updated_at = None

        # 首页列表逻辑回归：直接使用原始金额，不再强制匹配用户全局设置
        # 但为了提供一个汇总值，这里可以统一累加（不考虑汇率，由前端决定展示逻辑）
        # 或者统计一个基于 CNY 的本位币总额作为参考
        account_list = []
        for account in accounts:
            # 1. 计算原始金额（用于返回）
            orig_balance = account.current_balance if account.current_balance is not None else account.initial_balance

            # 2. 统计总资产（Net worth）- 使用原始金额累加（简化逻辑）
            if account.include_in_net_worth and account.status == "ACTIVE":
                if account.nature == "ASSET":
                    total_balance += orig_balance
                else:
                    total_balance -= abs(orig_balance)

            # Track most recent update
            if max_updated_at is None or account.updated_at > max_updated_at:
                max_updated_at = account.updated_at

            account_list.append(
                {
                    "id": str(account.id),
                    "name": account.name,
                    "nature": account.nature,
                    "type": account.type,
                    "currencyCode": account.currency_code or "CNY",
                    "initialBalance": f"{account.initial_balance:.2f}",
                    "currentBalance": f"{orig_balance:.2f}",
                    "includeInNetWorth": account.include_in_net_worth,
                    "includeInCashFlow": getattr(account, "include_in_cash_flow", False),
                    "status": account.status,
                    "createdAt": _format_iso_datetime(cast(datetime | None, account.created_at)),
                    "updatedAt": _format_iso_datetime(cast(datetime | None, account.updated_at)),
                }
            )

        # Use current time if no accounts exist
        if max_updated_at is None:
            max_updated_at = utc_now()

        return {
            "accounts": account_list,
            "totalBalance": f"{total_balance:.2f}",
            "lastUpdatedAt": _format_iso_datetime(max_updated_at),
        }

    async def create_financial_account(self, user_uuid: UUID, account_data: dict[str, Any]) -> dict[str, Any]:
        """Create a single financial account.

        Args:
            user_uuid: The user's UUID
            account_data: Financial account data

        Returns:
            Dict: The created account data
        """
        now = utc_now()
        balance = Decimal(str(account_data.get("initialBalance", "0")))

        financial_account = FinancialAccount(
            user_uuid=user_uuid,
            name=account_data["name"],
            nature=account_data.get("nature", "ASSET"),
            type=account_data.get("type"),
            currency_code=account_data.get("currencyCode", "CNY"),
            initial_balance=balance,
            current_balance=balance,  # Sync initial_balance to current_balance
            include_in_net_worth=account_data.get("includeInNetWorth", True),
            status=account_data.get("status", "ACTIVE"),
            created_at=now,
            updated_at=now,
        )
        self.db.add(financial_account)
        await self.db.commit()
        await self.db.refresh(financial_account)

        logger.info(
            "financial_account_created",
            user_uuid=str(user_uuid),
            account_id=financial_account.id,
            account_name=financial_account.name,
        )

        return {
            "id": str(financial_account.id),  # UUID as string
            "name": financial_account.name,
            "nature": financial_account.nature,
            "type": financial_account.type,
            "currencyCode": financial_account.currency_code,
            "initialBalance": _format_decimal(financial_account.initial_balance),
            "includeInNetWorth": financial_account.include_in_net_worth,
            "status": financial_account.status,
            "createdAt": _format_iso_datetime(cast(datetime | None, financial_account.created_at)),
            "updatedAt": _format_iso_datetime(cast(datetime | None, financial_account.updated_at)),
        }

    async def update_financial_account(
        self, user_uuid: UUID, account_id: UUID, account_data: dict[str, Any]
    ) -> dict[str, Any] | None:
        """Update a financial account.

        Args:
            user_uuid: The user's UUID
            account_id: The account ID
            account_data: Updated account data

        Returns:
            Dict: The updated account data, or None if not found
        """
        result = await self.db.execute(
            select(FinancialAccount).where(FinancialAccount.id == account_id, FinancialAccount.user_uuid == user_uuid)
        )
        account = result.scalar_one_or_none()

        if not account:
            return None

        # Update fields
        if "name" in account_data:
            account.name = account_data["name"]
        if "nature" in account_data:
            account.nature = account_data["nature"]
        if "type" in account_data:
            account.type = account_data["type"]
        if "currencyCode" in account_data:
            account.currency_code = account_data["currencyCode"]
        if "initialBalance" in account_data:
            new_balance = Decimal(str(account_data["initialBalance"]))
            account.initial_balance = new_balance
            account.current_balance = new_balance  # Sync to current_balance
        if "includeInNetWorth" in account_data:
            account.include_in_net_worth = account_data["includeInNetWorth"]
        if "status" in account_data:
            account.status = account_data["status"]

        account.updated_at = utc_now()

        await self.db.commit()
        await self.db.refresh(account)

        logger.info("financial_account_updated", user_uuid=str(user_uuid), account_id=account.id)

        return {
            "id": str(account.id),  # UUID as string
            "name": account.name,
            "nature": account.nature,
            "type": account.type,
            "currencyCode": account.currency_code,
            "initialBalance": _format_decimal(account.initial_balance),
            "includeInNetWorth": account.include_in_net_worth,
            "status": account.status,
            "createdAt": _format_iso_datetime(cast(datetime | None, account.created_at)),
            "updatedAt": _format_iso_datetime(cast(datetime | None, account.updated_at)),
        }

    async def delete_financial_account(self, user_uuid: UUID, account_id: UUID) -> bool:
        """Delete a financial account.

        Args:
            user_uuid: The user's UUID
            account_id: The account ID

        Returns:
            bool: True if deleted, False if not found
        """
        result = await self.db.execute(
            select(FinancialAccount).where(FinancialAccount.id == account_id, FinancialAccount.user_uuid == user_uuid)
        )
        account = result.scalar_one_or_none()

        if not account:
            return False

        await self.db.delete(account)
        await self.db.commit()

        logger.info("financial_account_deleted", user_uuid=str(user_uuid), account_id=account_id)

        return True

    async def update_financial_safety_line(self, user_uuid: UUID, safety_balance_threshold: str) -> dict[str, Any]:
        """Update user's financial safety line threshold.

        Args:
            user_uuid: The user's UUID
            safety_balance_threshold: The new threshold value (decimal as string)

        Returns:
            Dict containing:
                - safetyBalanceThreshold: str (the updated threshold)
                - updatedAt: str (ISO 8601 timestamp)

        Raises:
            NotFoundError: If user is not found
        """
        # Get or create user settings
        result = await self.db.execute(select(UserSettings).where(UserSettings.user_uuid == user_uuid))
        settings = result.scalar_one_or_none()

        now = utc_now()

        if settings is None:
            # Create new settings
            settings = UserSettings(
                user_uuid=user_uuid, safety_balance_threshold=safety_balance_threshold, created_at=now, updated_at=now
            )
            self.db.add(settings)
        else:
            # Update existing settings
            settings.safety_balance_threshold = safety_balance_threshold
            settings.updated_at = now

        await self.db.commit()
        await self.db.refresh(settings)

        logger.info("financial_safety_line_updated", user_uuid=str(user_uuid), threshold=safety_balance_threshold)

        return {"safetyBalanceThreshold": settings.safety_balance_threshold, "updatedAt": _format_iso_datetime(now)}

    async def check_onboarding_status(self, user_uuid: UUID) -> dict[str, bool]:
        """Check if user has completed onboarding.

        Onboarding is considered complete when:
        1. User has at least one financial account
        2. User has at least one recurring income transaction
        3. User has at least one recurring expense transaction

        Args:
            user_uuid: The user's UUID

        Returns:
            Dict containing:
                - isCompleted: bool (True if all onboarding steps are complete)
        """
        # Check if user has at least one financial account
        account_result = await self.db.execute(
            select(FinancialAccount).where(FinancialAccount.user_uuid == user_uuid).limit(1)
        )
        has_financial_account = account_result.scalar_one_or_none() is not None

        # Check if user has at least one recurring income (amount > 0)
        income_result = await self.db.execute(
            select(RecurringTransaction)
            .where(RecurringTransaction.user_uuid == user_uuid)
            .where(RecurringTransaction.amount > 0)
            .limit(1)
        )
        has_recurring_income = income_result.scalar_one_or_none() is not None

        # Check if user has at least one recurring expense (amount < 0)
        expense_result = await self.db.execute(
            select(RecurringTransaction)
            .where(RecurringTransaction.user_uuid == user_uuid)
            .where(RecurringTransaction.amount < 0)
            .limit(1)
        )
        has_recurring_expense = expense_result.scalar_one_or_none() is not None

        is_completed = has_financial_account and has_recurring_income and has_recurring_expense

        logger.info(
            "onboarding_status_checked",
            user_uuid=str(user_uuid),
            is_completed=is_completed,
            has_financial_account=has_financial_account,
            has_recurring_income=has_recurring_income,
            has_recurring_expense=has_recurring_expense,
        )

        return {"isCompleted": is_completed}

    async def update_user_settings(
        self,
        user_uuid: UUID,
        safety_balance_threshold: str | None = None,
        estimated_avg_daily_spending: str | None = None,
    ) -> UserSettings:
        """Update user settings.

        Args:
            user_uuid: The user's UUID
            safety_balance_threshold: Optional new safety threshold
            estimated_avg_daily_spending: Optional new estimated daily spending

        Returns:
            UserSettings: The updated settings object

        Raises:
            NotFoundError: If user is not found
        """
        # Get or create user settings
        result = await self.db.execute(select(UserSettings).where(UserSettings.user_uuid == user_uuid))
        settings = result.scalar_one_or_none()

        now = utc_now()

        if settings is None:
            # Create new settings with provided values or defaults
            settings = UserSettings(
                user_uuid=user_uuid,
                safety_balance_threshold=safety_balance_threshold or "0.00",
                avg_daily_spending=estimated_avg_daily_spending or "0.00",
                created_at=now,
                updated_at=now,
            )
            self.db.add(settings)
        else:
            # Update existing settings
            if safety_balance_threshold is not None:
                settings.safety_balance_threshold = safety_balance_threshold
            if estimated_avg_daily_spending is not None:
                settings.avg_daily_spending = estimated_avg_daily_spending
            settings.updated_at = now

        await self.db.commit()
        await self.db.refresh(settings)

        logger.info(
            "user_settings_updated",
            user_uuid=str(user_uuid),
            safety_threshold=settings.safety_balance_threshold,
            avg_spending=settings.avg_daily_spending,
        )

        return settings

    # =========================================================================
    # Financial Settings Methods (NEW financial_settings table)
    # =========================================================================

    async def get_financial_settings(self, user_uuid: UUID) -> FinancialSettings:
        """Get or create user's financial settings.

        If settings don't exist, creates default settings.

        Args:
            user_uuid: The user's UUID

        Returns:
            FinancialSettings: The settings object
        """
        result = await self.db.execute(select(FinancialSettings).where(FinancialSettings.user_uuid == user_uuid))
        settings = result.scalar_one_or_none()

        if settings is None:
            # Create default settings
            settings = await self.create_default_financial_settings(user_uuid)

        return settings

    async def create_default_financial_settings(self, user_uuid: UUID) -> FinancialSettings:
        """Create default financial settings for a user.

        Called during user registration or when settings don't exist.
        Uses USD as the default currency. Users can change this in settings.

        Args:
            user_uuid: The user's UUID

        Returns:
            FinancialSettings: The created settings object
        """
        settings = FinancialSettings(
            user_uuid=user_uuid,
            safety_threshold=Decimal("1000.00"),
            daily_burn_rate=Decimal("100.00"),
            burn_rate_mode="AI_AUTO",
            primary_currency="USD",
            month_start_day=1,
            updated_at=utc_now(),
        )
        self.db.add(settings)
        await self.db.commit()
        await self.db.refresh(settings)

        logger.info("financial_settings_created", user_uuid=str(user_uuid), primary_currency="USD")

        return settings

    async def update_financial_settings(
        self,
        user_uuid: UUID,
        safety_threshold: str | None = None,
        daily_burn_rate: str | None = None,
        burn_rate_mode: str | None = None,
        primary_currency: str | None = None,
        month_start_day: int | None = None,
    ) -> FinancialSettings:
        """Update user's financial settings using UPSERT.

        If settings don't exist, creates them with provided values.

        Args:
            user_uuid: The user's UUID
            safety_threshold: Optional new safety threshold
            daily_burn_rate: Optional new daily burn rate
            burn_rate_mode: Optional new burn rate mode
            primary_currency: Optional new primary currency
            month_start_day: Optional new month start day

        Returns:
            FinancialSettings: The updated settings object
        """
        result = await self.db.execute(select(FinancialSettings).where(FinancialSettings.user_uuid == user_uuid))
        settings = result.scalar_one_or_none()

        now = utc_now()

        if settings is None:
            # Create new settings with provided values or defaults (UPSERT behavior)
            settings = FinancialSettings(
                user_uuid=user_uuid,
                safety_threshold=Decimal(safety_threshold) if safety_threshold else Decimal("1000.00"),
                daily_burn_rate=Decimal(daily_burn_rate) if daily_burn_rate else Decimal("100.00"),
                burn_rate_mode=burn_rate_mode or "AI_AUTO",
                primary_currency=primary_currency or "CNY",
                month_start_day=month_start_day or 1,
                updated_at=now,
            )
            self.db.add(settings)
        else:
            # Update existing settings
            if safety_threshold is not None:
                settings.safety_threshold = Decimal(safety_threshold)
            if daily_burn_rate is not None:
                settings.daily_burn_rate = Decimal(daily_burn_rate)
            if burn_rate_mode is not None:
                settings.burn_rate_mode = burn_rate_mode
            if primary_currency is not None:
                settings.primary_currency = primary_currency
            if month_start_day is not None:
                settings.month_start_day = month_start_day
            settings.updated_at = now

        await self.db.commit()
        await self.db.refresh(settings)

        logger.info(
            "financial_settings_updated",
            user_uuid=str(user_uuid),
            safety_threshold=str(settings.safety_threshold),
            daily_burn_rate=str(settings.daily_burn_rate),
        )

        return settings
