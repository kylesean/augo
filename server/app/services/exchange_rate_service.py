"""Exchange rate service for fetching and caching currency exchange rates.

This module provides functionality to fetch exchange rates from external APIs
and cache them in Redis for use in currency conversion across the application.
"""

from datetime import datetime, timezone
from typing import Any, Dict, Optional, cast

import httpx

from app.core.cache import cache_manager
from app.core.config import settings
from app.core.logging import logger


class ExchangeRateService:
    """Service for managing exchange rate data.

    Fetches exchange rates from external API and caches them in Redis
    for efficient access across the application.
    """

    def __init__(self) -> None:
        """Initialize the exchange rate service."""
        self._api_url = settings.EXCHANGE_RATE_API_URL
        self._cache_key = settings.EXCHANGE_RATE_CACHE_KEY
        self._cache_ttl = settings.EXCHANGE_RATE_CACHE_TTL

    async def fetch_exchange_rates(self) -> Optional[Dict[str, Any]]:
        """Fetch latest exchange rates from the external API.

        Returns:
            Optional[Dict[str, Any]]: Exchange rate data from API, or None on failure
        """
        if not self._api_url:
            logger.warning(
                "exchange_rate_api_url_not_configured", message="EXCHANGE_RATE_API_URL environment variable is not set"
            )
            return None

        try:
            async with httpx.AsyncClient(timeout=30.0) as client:
                response = await client.get(self._api_url)
                response.raise_for_status()

                data = response.json()

                # Validate response structure
                if data.get("result") != "success":
                    logger.error(
                        "exchange_rate_api_error",
                        result=data.get("result"),
                        error_type=data.get("error-type"),
                    )
                    return None

                logger.info(
                    "exchange_rate_fetched_successfully",
                    base_code=data.get("base_code"),
                    rates_count=len(data.get("conversion_rates", {})),
                    last_update=data.get("time_last_update_utc"),
                )

                return cast(Optional[Dict[str, Any]], data)

        except httpx.TimeoutException:
            logger.error(
                "exchange_rate_api_timeout",
                url=self._api_url,
            )
            return None
        except httpx.HTTPStatusError as e:
            logger.error(
                "exchange_rate_api_http_error",
                status_code=e.response.status_code,
                url=self._api_url,
            )
            return None
        except Exception as e:
            logger.error(
                "exchange_rate_fetch_failed",
                error=str(e),
                url=self._api_url,
            )
            return None

    async def update_cache(self) -> bool:
        """Fetch latest rates and update the Redis cache.

        Returns:
            bool: True if cache was updated successfully, False otherwise
        """
        data = await self.fetch_exchange_rates()

        if data is None:
            logger.warning("exchange_rate_cache_update_skipped", reason="fetch_failed")
            return False

        # Extract and structure the cache data
        cache_data = {
            "base_code": data.get("base_code", "USD"),
            "last_update_utc": data.get("time_last_update_utc"),
            "next_update_utc": data.get("time_next_update_utc"),
            "conversion_rates": data.get("conversion_rates", {}),
            "cached_at": datetime.now(timezone.utc).isoformat(),
        }

        success = await cache_manager.set(
            key=self._cache_key,
            value=cache_data,
            ttl=self._cache_ttl,
        )

        if success:
            logger.info(
                "exchange_rate_cache_updated",
                cache_key=self._cache_key,
                ttl=self._cache_ttl,
                rates_count=len(cache_data["conversion_rates"]),
            )
        else:
            logger.error(
                "exchange_rate_cache_update_failed",
                cache_key=self._cache_key,
            )

        return success

    async def get_cached_rates(self) -> Optional[Dict[str, Any]]:
        """Get cached exchange rates from Redis.

        Returns:
            Optional[Dict[str, Any]]: Cached exchange rate data, or None if not available
        """
        data = await cache_manager.get(self._cache_key)

        if data is None:
            logger.debug("exchange_rate_cache_miss", cache_key=self._cache_key)
            return None

        logger.debug(
            "exchange_rate_cache_hit",
            cache_key=self._cache_key,
            base_code=data.get("base_code"),
            cached_at=data.get("cached_at"),
        )

        return cast(Optional[Dict[str, Any]], data)

    async def get_rate(self, target_currency: str) -> Optional[float]:
        """Get exchange rate for a specific currency.

        Args:
            target_currency: Target currency code (e.g., "CNY", "EUR")

        Returns:
            Optional[float]: Exchange rate from USD to target currency, or None if not available
        """
        data = await self.get_cached_rates()

        if data is None:
            # Try to fetch fresh data if cache is empty
            logger.info("exchange_rate_cache_empty_fetching_fresh")
            await self.update_cache()
            data = await self.get_cached_rates()

        if data is None:
            return None

        rates = data.get("conversion_rates", {})
        rate = rates.get(target_currency.upper())

        if rate is None:
            logger.warning(
                "exchange_rate_currency_not_found",
                target_currency=target_currency,
            )

        return cast(Optional[float], rate)

    async def convert(
        self,
        amount: float,
        from_currency: str,
        to_currency: str,
    ) -> Optional[float]:
        """Convert amount between currencies.

        Args:
            amount: Amount to convert
            from_currency: Source currency code
            to_currency: Target currency code

        Returns:
            Optional[float]: Converted amount, or None if conversion not possible
        """
        from_currency = from_currency.upper()
        to_currency = to_currency.upper()

        # Same currency, no conversion needed
        if from_currency == to_currency:
            return amount

        data = await self.get_cached_rates()

        if data is None:
            await self.update_cache()
            data = await self.get_cached_rates()

        if data is None:
            return None

        base_code = data.get("base_code", "USD")
        rates = data.get("conversion_rates", {})

        # Get rates for both currencies
        from_rate = rates.get(from_currency)
        to_rate = rates.get(to_currency)

        # Handle base currency (USD)
        if from_currency == base_code:
            from_rate = 1.0
        if to_currency == base_code:
            to_rate = 1.0

        if from_rate is None or to_rate is None:
            logger.warning(
                "exchange_rate_conversion_failed",
                from_currency=from_currency,
                to_currency=to_currency,
                from_rate_found=from_rate is not None,
                to_rate_found=to_rate is not None,
            )
            return None

        # Convert: amount in from_currency -> USD -> to_currency
        amount_in_usd = amount / from_rate
        converted_amount = amount_in_usd * to_rate

        return cast(float, round(converted_amount, 4))


# Global service instance
exchange_rate_service = ExchangeRateService()


async def update_exchange_rates() -> bool:
    """Scheduled task to update exchange rates.

    This function is called by the scheduler to periodically
    fetch and cache the latest exchange rates.
    """
    logger.info("exchange_rate_scheduled_update_started")

    success = await exchange_rate_service.update_cache()

    if success:
        logger.info("exchange_rate_scheduled_update_completed")
    else:
        logger.error("exchange_rate_scheduled_update_failed")

    return success
