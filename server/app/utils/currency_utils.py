"""Currency utilities for multi-currency support.

This module provides helper functions for currency conversion
and user display currency preferences.
"""
from __future__ import annotations

from decimal import Decimal
from uuid import UUID

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.logging import logger


async def get_user_display_currency(db: AsyncSession, user_uuid: UUID) -> str:
    """Get user's preferred display currency.

    Args:
        db: Database session
        user_uuid: User's UUID

    Returns:
        str: Currency code (default: CNY)
    """
    from app.models.financial_settings import FinancialSettings

    try:
        result = await db.execute(
            select(FinancialSettings.primary_currency).where(
                FinancialSettings.user_uuid == user_uuid
            )
        )
        currency = result.scalar_one_or_none()
        return currency or "CNY"
    except Exception as e:
        logger.warning(
            "get_user_display_currency_failed",
            user_uuid=str(user_uuid),
            error=str(e),
        )
        return "CNY"


async def convert_to_display_currency(
    amount: Decimal,
    from_currency: str,
    to_currency: str,
) -> Decimal:
    """Convert amount from one currency to another.

    Args:
        amount: Amount to convert
        from_currency: Source currency code
        to_currency: Target currency code

    Returns:
        Decimal: Converted amount (original if conversion fails)
    """
    if from_currency.upper() == to_currency.upper():
        return amount

    try:
        from app.services.exchange_rate_service import exchange_rate_service

        converted = await exchange_rate_service.convert(
            amount=float(amount),
            from_currency=from_currency,
            to_currency=to_currency,
        )

        if converted is not None:
            return Decimal(str(converted))

        logger.warning(
            "currency_conversion_failed",
            from_currency=from_currency,
            to_currency=to_currency,
            amount=str(amount),
        )
        return amount

    except Exception as e:
        logger.error(
            "currency_conversion_error",
            error=str(e),
            from_currency=from_currency,
            to_currency=to_currency,
        )
        return amount


# System default base currency for database storage and aggregate statistics.
# All values stored in Transaction.amount use this currency.
# Using USD as the international standard base currency, consistent with exchange rate API base_code.
BASE_CURRENCY = "USD"


async def convert_base_to_display(
    amount: float,
    display_currency: str,
) -> float:
    """Convert amount from base currency (USD) to user's display currency.

    This is the core function for the base currency approach:
    - All transaction amounts are stored in USD (base currency)
    - When displaying, convert USD -> user's preferred currency

    Args:
        amount: Amount in USD (base currency)
        display_currency: Target currency code

    Returns:
        float: Converted amount (original if conversion fails or same currency)
    """
    if display_currency.upper() == BASE_CURRENCY:
        return amount

    if amount == 0:
        return 0.0

    try:
        from app.services.exchange_rate_service import exchange_rate_service

        converted = await exchange_rate_service.convert(
            amount=amount,
            from_currency=BASE_CURRENCY,
            to_currency=display_currency,
        )

        if converted is not None:
            return round(converted, 2)

        logger.warning(
            "base_to_display_conversion_failed",
            display_currency=display_currency,
            amount=amount,
        )
        return amount

    except Exception as e:
        logger.error(
            "base_to_display_conversion_error",
            error=str(e),
            display_currency=display_currency,
        )
        return amount


async def get_exchange_rate_from_base(display_currency: str) -> float:
    """Get exchange rate from base currency (USD) to display currency.

    Uses convert(1, USD, target) to get the exchange rate.

    Args:
        display_currency: Target currency code

    Returns:
        float: Exchange rate (1.0 if same currency or conversion fails)
    """
    if display_currency.upper() == BASE_CURRENCY:
        return 1.0

    try:
        from app.services.exchange_rate_service import exchange_rate_service

        # Convert 1 USD to target currency to get the rate
        rate = await exchange_rate_service.convert(
            amount=1.0,
            from_currency=BASE_CURRENCY,
            to_currency=display_currency,
        )

        return rate if rate is not None else 1.0

    except Exception as e:
        logger.error(
            "get_exchange_rate_error",
            error=str(e),
            display_currency=display_currency,
        )
        return 1.0


def get_currency_symbol(currency_code: str) -> str:
    """Get currency symbol for display.

    Args:
        currency_code: ISO 4217 currency code

    Returns:
        str: Currency symbol
    """
    # G9 countries + TWD + HKD
    CURRENCY_SYMBOLS = {
        "USD": "$",
        "EUR": "€",
        "GBP": "£",
        "JPY": "¥",
        "CAD": "C$",
        "AUD": "A$",
        "CNY": "¥",
        "INR": "₹",
        "RUB": "₽",
        "HKD": "HK$",
        "TWD": "NT$",
    }

    return CURRENCY_SYMBOLS.get(currency_code.upper(), currency_code)


# Supported currencies: G9 countries + TWD + HKD
# Order: USD, CNY, then others
SUPPORTED_CURRENCIES = [
    {"code": "USD", "name": "US Dollar", "symbol": "$", "flag": "🇺🇸"},
    {"code": "CNY", "name": "Chinese Yuan", "symbol": "¥", "flag": "🇨🇳"},
    {"code": "EUR", "name": "Euro", "symbol": "€", "flag": "🇪🇺"},
    {"code": "GBP", "name": "British Pound", "symbol": "£", "flag": "🇬🇧"},
    {"code": "JPY", "name": "Japanese Yen", "symbol": "¥", "flag": "🇯🇵"},
    {"code": "CAD", "name": "Canadian Dollar", "symbol": "C$", "flag": "🇨🇦"},
    {"code": "AUD", "name": "Australian Dollar", "symbol": "A$", "flag": "🇦🇺"},
    {"code": "INR", "name": "Indian Rupee", "symbol": "₹", "flag": "🇮🇳"},
    {"code": "RUB", "name": "Russian Ruble", "symbol": "₽", "flag": "🇷🇺"},
    {"code": "HKD", "name": "Hong Kong Dollar", "symbol": "HK$", "flag": "🇭🇰"},
    {"code": "TWD", "name": "New Taiwan Dollar", "symbol": "NT$", "flag": "🇹🇼"},
]
