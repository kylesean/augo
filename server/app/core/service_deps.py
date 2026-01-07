"""Service dependencies for FastAPI endpoints.

This module provides factory functions for creating service instances
as FastAPI dependencies. Following FastAPI best practices:

1. Services are request-scoped (created per request)
2. Database session is injected via Depends()
3. Services can be easily mocked in tests
4. Centralized service instantiation

Usage:
    @router.get("/transactions")
    async def get_transactions(
        service: TransactionService = Depends(get_transaction_service),
    ):
        return await service.get_transaction_feed(...)
"""

from typing import Annotated

from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_session

# Type alias for injected database session
DbSession = Annotated[AsyncSession, Depends(get_session)]


# ============================================================================
# Transaction Services
# ============================================================================


async def get_transaction_service(
    db: DbSession,
) -> "TransactionService":
    """Get TransactionService instance.

    Args:
        db: Database session (injected)

    Returns:
        TransactionService instance
    """
    from app.services.transaction_service import TransactionService

    return TransactionService(db)


async def get_transaction_query_service(
    db: DbSession,
) -> "TransactionQueryService":
    """Get TransactionQueryService instance.

    Args:
        db: Database session (injected)

    Returns:
        TransactionQueryService instance
    """
    from app.services.transaction_query_service import TransactionQueryService

    return TransactionQueryService(db)


# ============================================================================
# User & Auth Services
# ============================================================================


async def get_user_service(
    db: DbSession,
) -> "UserService":
    """Get UserService instance.

    Args:
        db: Database session (injected)

    Returns:
        UserService instance
    """
    from app.services.user_service import UserService

    return UserService(db)


async def get_auth_service(
    db: DbSession,
) -> "AuthService":
    """Get AuthService instance.

    Args:
        db: Database session (injected)

    Returns:
        AuthService instance
    """
    from app.services.auth_service import AuthService

    return AuthService(db)


# ============================================================================
# Budget & Statistics Services
# ============================================================================


async def get_budget_service(
    db: DbSession,
) -> "BudgetService":
    """Get BudgetService instance.

    Args:
        db: Database session (injected)

    Returns:
        BudgetService instance
    """
    from app.services.budget_service import BudgetService

    return BudgetService(db)


async def get_statistics_service(
    db: DbSession,
) -> "StatisticsService":
    """Get StatisticsService instance.

    Args:
        db: Database session (injected)

    Returns:
        StatisticsService instance
    """
    from app.services.statistics_service import StatisticsService

    return StatisticsService(db)


async def get_forecast_service(
    db: DbSession,
) -> "ForecastService":
    """Get ForecastService instance.

    Args:
        db: Database session (injected)

    Returns:
        ForecastService instance
    """
    from app.services.forecast_service import ForecastService

    return ForecastService(db)


# ============================================================================
# Shared Space Services
# ============================================================================


async def get_shared_space_service(
    db: DbSession,
) -> "SharedSpaceService":
    """Get SharedSpaceService instance.

    Args:
        db: Database session (injected)

    Returns:
        SharedSpaceService instance
    """
    from app.services.shared_space_service import SharedSpaceService

    return SharedSpaceService(db)


# ============================================================================
# Storage & Upload Services
# ============================================================================


async def get_storage_config_service(
    db: DbSession,
) -> "StorageConfigService":
    """Get StorageConfigService instance.

    Args:
        db: Database session (injected)

    Returns:
        StorageConfigService instance
    """
    from app.services.storage_config_service import StorageConfigService

    return StorageConfigService(db)


async def get_upload_service(
    db: DbSession,
) -> "UploadService":
    """Get UploadService instance.

    Args:
        db: Database session (injected)

    Returns:
        UploadService instance
    """
    from app.services.upload_service import UploadService

    return UploadService(db)


# ============================================================================
# Stateless Services (singleton-like, no db dependency)
# ============================================================================


def get_exchange_rate_service() -> "ExchangeRateService":
    """Get ExchangeRateService instance.

    This service is stateless and doesn't require a database session.
    It can be treated as a singleton.

    Returns:
        ExchangeRateService instance
    """
    from app.services.exchange_rate_service import exchange_rate_service

    return exchange_rate_service


# ============================================================================
# Type annotations for forward references
# ============================================================================

# These are imported at the end to avoid circular imports
# and are only used for type hints
if False:  # TYPE_CHECKING equivalent that works at runtime
    from app.services.auth_service import AuthService
    from app.services.budget_service import BudgetService
    from app.services.exchange_rate_service import ExchangeRateService
    from app.services.forecast_service import ForecastService
    from app.services.shared_space_service import SharedSpaceService
    from app.services.statistics_service import StatisticsService
    from app.services.storage_config_service import StorageConfigService
    from app.services.transaction_query_service import TransactionQueryService
    from app.services.transaction_service import TransactionService
    from app.services.upload_service import UploadService
    from app.services.user_service import UserService
