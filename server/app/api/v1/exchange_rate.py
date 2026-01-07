"""Exchange rate API endpoints.

This module provides API endpoints for managing and accessing exchange rate data.
"""

from typing import Any, Dict, Optional

from fastapi import APIRouter, Depends, Query
from fastapi.responses import JSONResponse
from pydantic import BaseModel, Field

from app.core.dependencies import get_current_user
from app.core.logging import logger
from app.core.responses import error_response, success_response
from app.services.exchange_rate_service import exchange_rate_service

router = APIRouter(prefix="/exchange-rates", tags=["Exchange Rates"])


class ExchangeRateResponse(BaseModel):
    """Exchange rate data response model."""

    base_code: str = Field(description="Base currency code (e.g., USD)")
    last_update_utc: Optional[str] = Field(default=None, description="Last update time in UTC")
    cached_at: Optional[str] = Field(default=None, description="When the data was cached")
    conversion_rates: Dict[str, float] = Field(description="Exchange rates for supported currencies")


class ConversionRequest(BaseModel):
    """Currency conversion request model."""

    amount: float = Field(ge=0, description="Amount to convert")
    from_currency: str = Field(min_length=3, max_length=3, description="Source currency code")
    to_currency: str = Field(min_length=3, max_length=3, description="Target currency code")


class ConversionResponse(BaseModel):
    """Currency conversion response model."""

    original_amount: float = Field(description="Original amount")
    from_currency: str = Field(description="Source currency code")
    to_currency: str = Field(description="Target currency code")
    converted_amount: float = Field(description="Converted amount")
    rate: float = Field(description="Exchange rate used for conversion")


@router.get("", response_model=Dict[str, Any])
async def get_exchange_rates(
    _: Any = Depends(get_current_user),
) -> JSONResponse:
    """Get cached exchange rates.

    Returns the latest cached exchange rate data from Redis.
    The data is updated daily at 08:00 Beijing Time (00:00 UTC).

    Returns:
        Response containing exchange rate data
    """
    logger.info("get_exchange_rates_requested")

    data = await exchange_rate_service.get_cached_rates()

    if data is None:
        # Try to fetch fresh data if cache is empty
        logger.info("exchange_rate_cache_empty_fetching")
        await exchange_rate_service.update_cache()
        data = await exchange_rate_service.get_cached_rates()

    if data is None:
        return error_response(
            code=50001,
            message="Exchange rate data is not available",
            data=None,
        )

    return success_response(data=data)


@router.get("/rate/{currency}", response_model=Dict[str, Any])
async def get_single_rate(
    currency: str,
    _: Any = Depends(get_current_user),
) -> JSONResponse:
    """Get exchange rate for a specific currency.

    Args:
        currency: Target currency code (e.g., CNY, EUR, JPY)

    Returns:
        Response containing the exchange rate for the specified currency
    """
    currency = currency.upper()
    logger.info("get_single_rate_requested", currency=currency)

    rate = await exchange_rate_service.get_rate(currency)

    if rate is None:
        return error_response(
            code=40004,
            message=f"Exchange rate for {currency} is not available",
            data=None,
        )

    return success_response(
        data={
            "base": "USD",
            "target": currency,
            "rate": rate,
        }
    )


@router.post("/convert", response_model=Dict[str, Any])
async def convert_currency(
    request: ConversionRequest,
    _: Any = Depends(get_current_user),
) -> JSONResponse:
    """Convert amount between currencies.

    Args:
        request: Conversion request containing amount, source and target currencies

    Returns:
        Response containing conversion result
    """
    logger.info(
        "currency_conversion_requested",
        amount=request.amount,
        from_currency=request.from_currency,
        to_currency=request.to_currency,
    )

    converted_amount = await exchange_rate_service.convert(
        amount=request.amount,
        from_currency=request.from_currency,
        to_currency=request.to_currency,
    )

    if converted_amount is None:
        return error_response(
            code=40004,
            message=f"Unable to convert from {request.from_currency} to {request.to_currency}",
            data=None,
        )

    # Calculate the effective rate
    if request.amount > 0:
        effective_rate = converted_amount / request.amount
    else:
        effective_rate = 0.0

    return success_response(
        data={
            "original_amount": request.amount,
            "from_currency": request.from_currency.upper(),
            "to_currency": request.to_currency.upper(),
            "converted_amount": converted_amount,
            "rate": round(effective_rate, 6),
        }
    )


@router.post("/refresh", response_model=Dict[str, Any])
async def refresh_exchange_rates(
    _: Any = Depends(get_current_user),
) -> JSONResponse:
    """Manually refresh exchange rates.

    Fetches the latest exchange rates from the API and updates the cache.
    This endpoint is rate-limited and should be used sparingly.

    Returns:
        Response indicating success or failure of the refresh operation
    """
    logger.info("exchange_rates_manual_refresh_requested")

    success = await exchange_rate_service.update_cache()

    if success:
        data = await exchange_rate_service.get_cached_rates()
        return success_response(
            data=data,
        )
    else:
        return error_response(
            code=50002,
            message="Failed to refresh exchange rates",
            data=None,
        )
