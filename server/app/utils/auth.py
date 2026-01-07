"""This file contains the authentication utilities for the application."""

from __future__ import annotations

import re
from datetime import (
    UTC,
    datetime,
    timedelta,
)
from typing import Any, cast
from uuid import UUID

from jose import (
    JWTError,
    jwt,
)

from app.core.config import settings
from app.core.logging import logger
from app.schemas.auth import Token
from app.utils.sanitization import sanitize_string


def create_access_token(
    subject: str | UUID | Any = None,
    expires_delta: timedelta | None = None,
    data: dict[str, Any] | None = None,
) -> Token:
    """Create a new access token.

    Args:
        subject: The subject (user UUID). Can be str or UUID.
        expires_delta: Optional expiration time delta.
        data: Optional additional data to include in the token.
    """
    to_encode = data.copy() if data else {}

    if subject:
        # Convert UUID to string if needed
        subject_str = str(subject)
        to_encode["sub"] = subject_str
    else:
        subject_str = str(to_encode.get("sub", "unknown"))

    if expires_delta:
        expire = datetime.now(UTC) + expires_delta
    else:
        expire = datetime.now(UTC) + timedelta(days=settings.JWT_ACCESS_TOKEN_EXPIRE_DAYS)

    to_encode.update(
        {
            "exp": expire,
            "iat": datetime.now(UTC),
            # Add unique token identifier
            "jti": sanitize_string(f"{subject_str}-{datetime.now(UTC).timestamp()}"),
        }
    )

    encoded_jwt = jwt.encode(to_encode, settings.JWT_SECRET_KEY, algorithm=settings.JWT_ALGORITHM)

    logger.info("token_created", subject=subject_str, expires_at=expire.isoformat())

    return Token(access_token=encoded_jwt, expires_at=expire)


def verify_token(token: str) -> str | None:
    """Verify a JWT token and return the subject (user UUID).

    Args:
        token: The JWT token to verify.

    Returns:
        Optional[str]: The subject ID if token is valid, None otherwise.

    Raises:
        ValueError: If the token format is invalid
    """
    if not token or not isinstance(token, str):
        logger.warning("token_invalid_format")
        raise ValueError("Token must be a non-empty string")

    # Basic format validation before attempting decode
    if not re.match(r"^[A-Za-z0-9-_]+\.[A-Za-z0-9-_]+\.[A-Za-z0-9-_]+$", token):
        logger.warning("token_suspicious_format")
        raise ValueError("Token format is invalid - expected JWT format")

    try:
        payload = jwt.decode(token, settings.JWT_SECRET_KEY, algorithms=[settings.JWT_ALGORITHM])

        subject_id: str = payload.get("sub")
        if subject_id is None:
            logger.warning("token_missing_subject")
            return None

        logger.info("token_verified", subject=subject_id)
        return subject_id

    except JWTError as e:
        logger.error("token_verification_failed", error=str(e))
        return None


def refresh_token(old_token: str) -> Token | None:
    """Refresh an existing JWT token.

    Args:
        old_token: The existing JWT token to refresh.

    Returns:
        Optional[Token]: A new token if the old token is valid, None otherwise.

    Raises:
        ValueError: If the token format is invalid
    """
    # Verify the old token first
    thread_id = verify_token(old_token)
    if thread_id is None:
        logger.warning("token_refresh_failed_invalid_token")
        return None

    # Create a new token with the same thread_id
    new_token = create_access_token(thread_id)

    logger.info("token_refreshed", thread_id=thread_id, expires_at=new_token.expires_at.isoformat())

    return new_token


def decode_token_payload(token: str) -> dict | None:
    """Decode a JWT token and return its payload without verification.

    This is useful for extracting information from expired tokens or for debugging.
    WARNING: Do not use this for authentication - always use verify_token() instead.

    Args:
        token: The JWT token to decode.

    Returns:
        Optional[dict]: The token payload if decodable, None otherwise.
    """
    try:
        # Decode without verification (for inspection only)
        payload = jwt.decode(
            token,
            settings.JWT_SECRET_KEY,
            algorithms=[settings.JWT_ALGORITHM],
            options={"verify_signature": False, "verify_exp": False},
        )
        return cast(dict[Any, Any] | None, payload)
    except Exception as e:
        logger.error("token_decode_failed", error=str(e))
        return None
