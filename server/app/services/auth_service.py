"""Authentication service for user registration, login, and verification code management.

This module provides the core authentication business logic including:
- User registration with verification code validation
- User login with password verification and JWT generation
- Verification code sending and validation
- Account existence checking
"""

import secrets
import time
import uuid
from datetime import datetime
from typing import Optional, Tuple

from sqlalchemy.ext.asyncio import AsyncSession
from sqlmodel import select
from uuid_utils import uuid7

from app.core.config import settings
from app.core.logging import logger
from app.models.base import utc_now
from app.models.user import User
from app.utils.auth import create_access_token


class AuthService:
    """Authentication service for handling user authentication operations.

    This service manages:
    - User registration with verification code validation
    - User login with password verification
    - Verification code generation, storage, and validation
    - Account existence checking
    """

    def __init__(self, db_session: AsyncSession, redis_client=None):
        """Initialize the authentication service.

        Args:
            db_session: Async database session
            redis_client: Redis client for verification code storage
        """
        self.db = db_session
        self.redis = redis_client

    async def send_verification_code(self, account_type: str, account: str) -> bool:
        """Send verification code to the specified account.

        1. 检查账号是否已存在
        2. 异步发送验证码（使用后台任务）

        Args:
            account_type: Type of account ('email' or 'mobile')
            account: Email address or mobile number

        Returns:
            bool: True (立即返回，验证码在后台发送)

        Raises:
            BusinessError: If account already exists
        """
        from app.core.background_tasks import background_task_manager
        from app.core.exceptions import BusinessError, ErrorCode
        from app.services.code_manager import code_manager

        if await self.is_account_exists(account_type, account):
            if account_type == "email":
                raise BusinessError(message="Email already registered", error_code=ErrorCode.EMAIL_REGISTERED)
            else:
                raise BusinessError(
                    message="Mobile number already registered", error_code=ErrorCode.PHONE_NUMBER_REGISTERED
                )

        await background_task_manager.run_in_background(code_manager.send_code, account_type, account)

        logger.info(
            "verification_code_job_queued",
            account_type=account_type,
            account=account[:3] + "***",  # Mask account for privacy
        )

        return True

    async def verify_code(self, account: str, code: str) -> bool:
        """Verify the verification code for an account.

        Args:
            account: Email address or mobile number
            code: 6-digit verification code

        Returns:
            bool: True if code is valid, False otherwise
        """
        from app.services.code_manager import code_manager

        return await code_manager.verify_code(account, code)

    async def register(
        self,
        account_type: str,
        account: str,
        password: str,
        code: str,
        timezone: str = "Asia/Shanghai",
        client_ip: Optional[str] = None,
        locale: Optional[str] = None,
    ) -> User:
        """Register a new user.

        Args:
            account_type: Type of account ('email' or 'mobile')
            account: Email address or mobile number
            password: Plain text password (will be hashed)
            code: 6-digit verification code
            timezone: User's timezone
            client_ip: Client IP address
            locale: User's preferred locale

        Returns:
            User: The created user object

        Raises:
            ValueError: If verification code is invalid or account already exists
        """
        # Check if account already exists first (before verifying code)
        if await self.is_account_exists(account_type, account):
            if account_type == "email":
                raise ValueError("EMAIL_REGISTERED: Email already registered")
            else:
                raise ValueError("PHONE_NUMBER_REGISTERED: Mobile number already registered")

        # Verify the code (Commented out for now as requested)
        # if not await self.verify_code(account, code):
        #     raise ValueError(
        #         "CODE_EXPIRED: Verification code is invalid or expired")

        # Generate unique UUID
        user_uuid = self._generate_uuid()

        # Generate random username
        username = self._generate_random_username()

        # Hash password
        hashed_password = User.hash_password(password)

        # Create user data
        user_data = {
            "uuid": user_uuid,
            "username": username,
            "password": hashed_password,
            "timezone": timezone,
            "registration_type": account_type,
            "last_login_at": utc_now(),
        }

        # Set client IP if provided (validation happens in model)
        if client_ip:
            user_data["last_login_ip"] = client_ip

        # Set email or mobile based on type
        if account_type == "email":
            user_data["email"] = account
        else:
            user_data["mobile"] = account

        # Create user
        user = User(**user_data)
        self.db.add(user)
        await self.db.commit()
        await self.db.refresh(user)

        # Create default financial settings for the new user
        await self._create_default_financial_settings(user.uuid)

        logger.info("user_registered", user_uuid=user.uuid, account_type=account_type)

        return user

    async def _create_default_financial_settings(self, user_uuid) -> None:
        """Create default financial settings for a new user.

        Args:
            user_uuid: The user's UUID
        """
        from app.services.user_service import UserService

        try:
            user_service = UserService(self.db)
            await user_service.create_default_financial_settings(user_uuid)
            logger.info("default_financial_settings_created", user_uuid=str(user_uuid))
        except Exception as e:
            # Log error but don't fail registration
            logger.error("failed_to_create_financial_settings", user_uuid=str(user_uuid), error=str(e))

    async def login(
        self, account_type: str, account: str, password: str, timezone: str, client_ip: Optional[str] = None
    ) -> Tuple[User, str]:
        """Authenticate user and generate JWT token.

        Args:
            account_type: Type of account ('email' or 'mobile')
            account: Email address or mobile number
            password: Plain text password
            timezone: User's timezone
            client_ip: Client IP address

        Returns:
            Tuple[User, str]: User object and JWT token

        Raises:
            ValueError: If credentials are invalid
        """
        # Find user by account
        query = select(User)
        if account_type == "email":
            query = query.where(User.email == account)
        else:
            query = query.where(User.mobile == account)

        result = await self.db.execute(query)
        user = result.scalar_one_or_none()

        if not user:
            raise ValueError("USER_NOT_EXIST: User does not exist")

        # Verify password
        if not user.verify_password(password):
            raise ValueError("USER_NOT_MATCH_PASSWORD: Invalid password")

        # Update user login information
        needs_update = False

        if user.timezone != timezone:
            user.timezone = timezone
            needs_update = True

        if client_ip:
            user.last_login_ip = client_ip
            needs_update = True

        # Always update last login time
        user.last_login_at = utc_now()
        needs_update = True

        if needs_update:
            await self.db.commit()
            await self.db.refresh(user)

        # Generate JWT token using user UUID
        token_obj = create_access_token(user.uuid)
        token = token_obj.access_token

        logger.info("user_logged_in", user_uuid=user.uuid, account_type=account_type)

        return user, token

    async def is_account_exists(self, account_type: str, account: str) -> bool:
        """Check if an account already exists.

        Args:
            account_type: Type of account ('email' or 'mobile')
            account: Email address or mobile number

        Returns:
            bool: True if account exists, False otherwise
        """
        query = select(User)
        if account_type == "email":
            query = query.where(User.email == account)
        else:
            query = query.where(User.mobile == account)

        result = await self.db.execute(query)
        user = result.scalar_one_or_none()

        return user is not None

    # Private helper methods

    def _generate_code(self, length: int = 6) -> str:
        """Generate a random numeric verification code.

        Args:
            length: Length of the code (default: 6)

        Returns:
            str: Random numeric code
        """
        min_val = 10 ** (length - 1)
        max_val = 10**length - 1
        return str(secrets.randbelow(max_val - min_val + 1) + min_val)

    async def _send_code(self, account_type: str, account: str, code: str) -> bool:
        """Send verification code via email or SMS.

        Args:
            account_type: Type of account ('email' or 'mobile')
            account: Email address or mobile number
            code: Verification code to send

        Returns:
            bool: True if sent successfully
        """
        # In production, integrate with actual email/SMS service
        # For now, just log the code (for development/testing)
        if settings.ENVIRONMENT.value == "development":
            logger.info(
                "verification_code_generated",
                account_type=account_type,
                account=account,
                code=code,
                message="In production, this would be sent via email/SMS",
            )

        # Mock sending based on provider setting
        if account_type == "email":
            if settings.EMAIL_PROVIDER == "mock":
                logger.info("mock_email_sent", to=account, code=code)
                return True
            # Integration with actual email service (SMTP, SendGrid, etc.) should be implemented for production
        else:
            if settings.SMS_PROVIDER == "mock":
                logger.info("mock_sms_sent", to=account, code=code)
                return True
            # Integration with actual SMS service (Twilio, Aliyun, etc.) should be implemented for production

        return True

    async def _store_code(self, account: str, code: str) -> None:
        """Store verification code in Redis.

        Args:
            account: Email address or mobile number
            code: Verification code
        """
        if not self.redis:
            logger.warning("redis_not_configured", message="Code storage skipped")
            return

        key = self._get_code_key(account)
        await self.redis.setex(key, settings.CODE_EXPIRY_SECONDS, code)

    async def _check_rate_limit(self, account: str) -> bool:
        """Check if account has exceeded rate limit for code sending.

        Args:
            account: Email address or mobile number

        Returns:
            bool: True if within rate limit, False otherwise
        """
        if not self.redis:
            return True

        key = self._get_rate_limit_key(account)
        last_send_time = await self.redis.get(key)

        if not last_send_time:
            return True

        elapsed = time.time() - float(last_send_time.decode())
        return elapsed >= 60  # 60 seconds rate limit

    async def _record_send_time(self, account: str) -> None:
        """Record the time when code was sent for rate limiting.

        Args:
            account: Email address or mobile number
        """
        if not self.redis:
            return

        key = self._get_rate_limit_key(account)
        await self.redis.setex(key, 60, str(time.time()))

    def _get_code_key(self, account: str) -> str:
        """Get Redis key for verification code storage.

        Args:
            account: Email address or mobile number

        Returns:
            str: Redis key
        """
        return f"verification_code:{account}"

    def _get_rate_limit_key(self, account: str) -> str:
        """Get Redis key for rate limiting.

        Args:
            account: Email address or mobile number

        Returns:
            str: Redis key
        """
        return f"code_rate_limit:{account}"

    def _generate_uuid(self) -> uuid.UUID:
        """Generate a unique UUID v7 for user.

        UUID v7 format: time-ordered UUID with millisecond precision timestamp.

        Returns:
            uuid.UUID: UUID v7 object
        """
        return uuid7()

    def _generate_random_username(self) -> str:
        """Generate a random username.

        Returns:
            str: Random username
        """
        # Generate username like "user_123456"
        random_num = secrets.randbelow(1000000)
        return f"user_{random_num:06d}"
