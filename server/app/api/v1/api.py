"""API v1 router configuration.

This module sets up the main API router and includes all sub-routers for different
endpoints like authentication and chatbot functionality.
"""

from fastapi import APIRouter

from app.api.budget import router as budget_router
from app.api.v1.auth import router as auth_router
from app.api.v1.chatbot import router as chatbot_router
from app.api.v1.exchange_rate import router as exchange_rate_router
from app.api.v1.financial_settings import router as financial_settings_router
from app.api.v1.home import router as home_router
from app.api.v1.memory import router as memory_router
from app.api.v1.notification import router as notification_router
from app.api.v1.shared_space import router as shared_space_router
from app.api.v1.statistics import router as statistics_router
from app.api.v1.storage_config import router as storage_config_router
from app.api.v1.transaction import router as transaction_router
from app.api.v1.upload import router as upload_router
from app.api.v1.user import router as user_router
from app.core.logging import logger

api_router = APIRouter()

# Include routers
api_router.include_router(auth_router)
api_router.include_router(chatbot_router)
api_router.include_router(home_router)
api_router.include_router(storage_config_router)
api_router.include_router(transaction_router)
api_router.include_router(upload_router)
api_router.include_router(user_router)
api_router.include_router(financial_settings_router)
api_router.include_router(statistics_router)
api_router.include_router(shared_space_router)
api_router.include_router(notification_router)
api_router.include_router(exchange_rate_router)
api_router.include_router(memory_router)
api_router.include_router(budget_router)


@api_router.get("/health")
async def health_check() -> dict[str, str]:
    """Health check endpoint.

    Returns:
        dict: Health status information.
    """
    logger.info("health_check_called")
    return {"status": "healthy", "version": "0.1.2"}
