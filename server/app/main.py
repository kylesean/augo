"""This file contains the main application entry point."""

import os
from contextlib import asynccontextmanager
from datetime import datetime
from pathlib import Path
from typing import (
    Any,
    Dict,
)

from dotenv import load_dotenv
from fastapi import (
    FastAPI,
    Request,
    status,
)
from fastapi.exceptions import RequestValidationError
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from fastapi.staticfiles import StaticFiles
from fastapi_pagination import add_pagination
from langfuse import Langfuse
from slowapi import _rate_limit_exceeded_handler
from slowapi.errors import RateLimitExceeded
from starlette.exceptions import HTTPException as StarletteHTTPException

from app.api.v1.api import api_router
from app.core.config import settings
from app.core.database import db_manager
from app.core.exceptions import (
    AppException,
    AuthenticationError,
    AuthorizationError,
    BusinessError,
    NotFoundError,
    ValidationError as AppValidationError,
)
from app.core.limiter import limiter
from app.core.logging import logger
from app.core.metrics import setup_metrics
from app.core.middleware import (
    LoggingContextMiddleware,
    MetricsMiddleware,
)
from app.core.responses import error_response, get_error_code_int, success_response

load_dotenv()

# Initialize Langfuse
langfuse = Langfuse(
    public_key=settings.LANGFUSE_PUBLIC_KEY,
    secret_key=settings.LANGFUSE_SECRET_KEY,
    host=settings.LANGFUSE_HOST,
)


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Handle application startup and shutdown events."""
    logger.info(
        "application_startup",
        project_name=settings.PROJECT_NAME,
        version=settings.VERSION,
        api_prefix=settings.API_V1_STR,
    )

    # Initialize database
    from app.core.database import close_db, init_db

    await init_db()

    # Initialize Redis cache
    from app.core.cache import close_cache, init_cache

    await init_cache()

    # Initialize application scheduler
    from app.services.scheduler import init_scheduler, shutdown_scheduler

    await init_scheduler()

    yield

    # Cleanup connections
    await shutdown_scheduler()
    await close_cache()
    await close_db()
    logger.info("application_shutdown")


app = FastAPI(
    title=settings.PROJECT_NAME,
    version=settings.VERSION,
    description=settings.DESCRIPTION,
    openapi_url=f"{settings.API_V1_STR}/openapi.json",
    lifespan=lifespan,
)

# Add fastapi-pagination support
add_pagination(app)

# Set up Prometheus metrics
setup_metrics(app)

# Add logging context middleware (must be added before other middleware to capture context)
app.add_middleware(LoggingContextMiddleware)

# Add custom metrics middleware
app.add_middleware(MetricsMiddleware)

# Set up rate limiter exception handler
app.state.limiter = limiter
app.add_exception_handler(RateLimitExceeded, _rate_limit_exceeded_handler)


# ============================================================================
# Exception Handlers - Unified Response Format
# ============================================================================


@app.exception_handler(AppException)
async def app_exception_handler(request: Request, exc: AppException):
    """Handle custom application exceptions.

    Returns unified {code, message, data} format.
    For business errors, HTTP status is 200 and code indicates the error.
    For system/auth errors, HTTP status reflects the error type.

    Args:
        request: The request that caused the exception
        exc: The application exception

    Returns:
        JSONResponse: Unified response envelope
    """
    # Log the exception with context
    logger.error(
        "application_exception",
        error_code=exc.error_code,
        message=exc.message,
        status_code=exc.status_code,
        path=request.url.path,
        method=request.method,
        client_host=request.client.host if request.client else "unknown",
        details=exc.details if exc.details else None,
        exception_type=type(exc).__name__,
    )

    # Convert string error code to integer
    code_int = get_error_code_int(exc.error_code)

    # For business logic errors (400), use HTTP 200 and let code indicate error
    # For auth/permission/system errors, keep the HTTP status
    http_status = 200 if exc.status_code == 400 else exc.status_code

    # Include details in data field if present
    data = exc.details if exc.details else None

    return error_response(
        code=code_int,
        message=exc.message,
        data=data,
        http_status=http_status,
    )


@app.exception_handler(RequestValidationError)
async def validation_exception_handler(request: Request, exc: RequestValidationError):
    """Handle validation errors from request data.

    Returns unified {code, message, data} format with field errors in data.

    Args:
        request: The request that caused the validation error
        exc: The validation error

    Returns:
        JSONResponse: Unified response envelope
    """
    # Format the errors to be more user-friendly
    formatted_errors = []
    for error in exc.errors():
        # Filter out 'body' from location path
        loc_parts = [str(loc_part) for loc_part in error["loc"] if loc_part != "body"]
        msg = error["msg"]

        # Remove "Value error, " prefix added by Pydantic
        if msg.startswith("Value error, "):
            msg = msg[len("Value error, ") :]

        # For model_validator errors, check if message contains "field_name: message" format
        if not loc_parts and ": " in msg:
            # Extract field name from message like "account: Invalid email format"
            parts = msg.split(": ", 1)
            if len(parts) == 2 and parts[0].isidentifier():
                loc_parts = [parts[0]]
                msg = parts[1]

        field = " -> ".join(loc_parts) if loc_parts else "_root"
        formatted_errors.append({"field": field, "message": msg})

    # For _root errors, try to get more context about the request body
    log_extra = {}
    if any(err["field"] == "_root" for err in formatted_errors):
        try:
            # Try to read the raw body for debugging
            body = await request.body()
            content_type = request.headers.get("content-type", "")
            log_extra["content_type"] = content_type
            log_extra["body_length"] = len(body)
            log_extra["body_preview"] = body[:200].decode("utf-8", errors="replace") if body else "<empty>"
        except Exception as e:
            log_extra["body_read_error"] = str(e)

    # Log the validation error
    logger.warning(
        "validation_error",
        client_host=request.client.host if request.client else "unknown",
        path=request.url.path,
        method=request.method,
        errors=formatted_errors,
        **log_extra,
    )

    return error_response(
        code=get_error_code_int("VALIDATION_ERROR"),
        message="Validation error",
        data={"field_errors": formatted_errors},
        http_status=status.HTTP_422_UNPROCESSABLE_ENTITY,
    )


@app.exception_handler(ValueError)
async def value_error_handler(request: Request, exc: ValueError):
    """Handle ValueError exceptions.

    Many legacy services raise ValueError with error codes.
    Returns unified {code, message, data} format.

    Args:
        request: The request that caused the error
        exc: The ValueError exception

    Returns:
        JSONResponse: Unified response envelope
    """
    error_message = str(exc)

    # Try to extract error code from message (format: "ERROR_CODE: message")
    error_code_str = "VALIDATION_ERROR"
    message = error_message

    if ": " in error_message:
        parts = error_message.split(": ", 1)
        potential_code = parts[0]
        # Check if it looks like an error code (all caps with underscores)
        if potential_code.isupper() and "_" in potential_code:
            error_code_str = potential_code
            message = parts[1] if len(parts) > 1 else error_message

    # Log the error
    logger.error(
        "value_error",
        error_code=error_code_str,
        message=message,
        path=request.url.path,
        method=request.method,
        client_host=request.client.host if request.client else "unknown",
    )

    # Convert to integer code
    code_int = get_error_code_int(error_code_str)

    # Determine HTTP status code based on error type
    http_status = 200  # Default to 200 for business errors
    if "NOT_EXIST" in error_code_str or "NOT_FOUND" in error_code_str:
        http_status = 404
    elif "AUTH" in error_code_str or "PASSWORD" in error_code_str:
        http_status = 401
    elif "PERMISSION" in error_code_str:
        http_status = 403

    return error_response(
        code=code_int,
        message=message,
        http_status=http_status,
    )


@app.exception_handler(StarletteHTTPException)
async def http_exception_handler(request: Request, exc: StarletteHTTPException):
    """Handle HTTP exceptions (404, 405, etc).

    Returns unified {code, message, data} format.

    Args:
        request: The request that caused the exception
        exc: The HTTP exception

    Returns:
        JSONResponse: Unified response envelope
    """
    logger.warning(
        "http_exception",
        status_code=exc.status_code,
        detail=exc.detail,
        path=request.url.path,
        method=request.method,
        client_host=request.client.host if request.client else "unknown",
    )

    # Map HTTP status codes to error codes
    error_code_map = {
        404: get_error_code_int("NOT_FOUND"),
        403: get_error_code_int("PERMISSION_DENIED"),
        401: get_error_code_int("AUTH_FAILED"),
    }

    code = error_code_map.get(exc.status_code, exc.status_code)

    return error_response(
        code=code,
        message=str(exc.detail),
        http_status=exc.status_code,
    )


@app.exception_handler(Exception)
async def general_exception_handler(request: Request, exc: Exception):
    """Handle all unhandled exceptions.

    Returns unified {code, message, data} format.

    Args:
        request: The request that caused the exception
        exc: The unhandled exception

    Returns:
        JSONResponse: Unified response envelope
    """
    # Log the full exception with traceback
    logger.exception(
        "unhandled_exception",
        exception_type=type(exc).__name__,
        exception_message=str(exc),
        path=request.url.path,
        method=request.method,
        client_host=request.client.host if request.client else "unknown",
    )

    # Prepare error data
    data = None
    if settings.DEBUG:
        data = {
            "exception_type": type(exc).__name__,
            "exception_message": str(exc),
        }

    return error_response(
        code=get_error_code_int("INTERNAL_ERROR"),
        message="An internal error occurred",
        data=data,
        http_status=status.HTTP_500_INTERNAL_SERVER_ERROR,
    )


# Set up CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.allowed_origins_list,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include API router
app.include_router(api_router, prefix=settings.API_V1_STR)

# Mount static files for user-generated artifacts (e.g., frontend-design skill outputs)
# Files are stored in: server/artifacts/{user_id}/...
# Accessible via: /artifacts/{user_id}/...
_artifacts_dir = Path(__file__).parent.parent / "artifacts"
_artifacts_dir.mkdir(parents=True, exist_ok=True)
app.mount("/artifacts", StaticFiles(directory=str(_artifacts_dir), html=True), name="artifacts")
logger.info("artifacts_static_mount", path=str(_artifacts_dir))


@app.get("/")
@limiter.limit(settings.RATE_LIMIT_ENDPOINTS["root"][0])
async def root(request: Request):
    """Root endpoint returning basic API information."""
    logger.info("root_endpoint_called")
    body = {
        "name": settings.PROJECT_NAME,
        "version": settings.VERSION,
        "status": "healthy",
        "environment": settings.ENVIRONMENT.value,
        "swagger_url": "/docs",
        "redoc_url": "/redoc",
    }
    return JSONResponse(status_code=status.HTTP_200_OK, content=body)


@app.get("/health")
@limiter.limit(settings.RATE_LIMIT_ENDPOINTS["health"][0])
async def health_check(request: Request) -> JSONResponse:
    """Health check endpoint with environment-specific information.

    Returns:
        JSONResponse: Unified response with health status
    """
    logger.info("health_check_called")

    # Check database connectivity
    db_healthy = await db_manager.health_check()

    # Check Redis connectivity
    from app.core.cache import cache_manager

    redis_healthy = await cache_manager.health_check()

    # Check scheduler status
    from app.services.scheduler import app_scheduler

    scheduler_running = app_scheduler.is_running()

    all_healthy = db_healthy  # Redis is optional, don't block health check

    health_data = {
        "status": "healthy" if all_healthy else "degraded",
        "version": settings.VERSION,
        "environment": settings.ENVIRONMENT.value,
        "components": {
            "api": "healthy",
            "database": "healthy" if db_healthy else "unhealthy",
            "cache": "healthy" if redis_healthy else "unhealthy",
            "scheduler": "running" if scheduler_running else "stopped",
        },
        "timestamp": datetime.now().isoformat(),
    }

    # If any component is unhealthy, set the appropriate status code
    http_status = status.HTTP_200_OK if all_healthy else status.HTTP_503_SERVICE_UNAVAILABLE

    return success_response(data=health_data, http_status=http_status)
