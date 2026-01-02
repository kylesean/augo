from unittest.mock import AsyncMock, patch
from uuid import uuid4

import pytest

from app.models.user import User
from app.services.auth_service import AuthService
from app.core.exceptions import AuthenticationError, BusinessError


@pytest.mark.asyncio
async def test_register_success(db_session):
    # Setup
    service = AuthService(db_session)
    email = "newuser@example.com"
    password = "securepassword"
    code = "123456"

    # Mock verify_code to return True
    # We patch the verify_code method of the global code_manager instance
    with patch("app.services.code_manager.code_manager.verify_code", new_callable=AsyncMock) as mock_verify:
        mock_verify.return_value = True

        # Action
        user = await service.register("email", email, password, code)

        # Assert
        assert user is not None
        assert user.email == email
        assert user.verify_password(password)

        # Verify DB persistence
        db_user = await service.is_account_exists("email", email)
        assert db_user is True


@pytest.mark.asyncio
async def test_register_invalid_code(db_session):
    # Setup
    service = AuthService(db_session)
    email = "badcode@example.com"
    password = "securepassword"
    code = "000000"

    with patch("app.services.code_manager.code_manager.verify_code", new_callable=AsyncMock) as mock_verify:
        mock_verify.return_value = False

        # Action & Assert
        with pytest.raises(BusinessError, match="Verification code is invalid or expired"):
            await service.register("email", email, password, code)


@pytest.mark.asyncio
async def test_login_success(db_session):
    # Setup: Create user
    service = AuthService(db_session)
    email = "loginuser@example.com"
    password = "loginpass"

    # Create user manually
    user = User(
        uuid=uuid4(),
        username="login_user",
        email=email,
        password=User.hash_password(password),
        registration_type="email",
    )
    db_session.add(user)
    await db_session.commit()

    # Action
    user_obj, token = await service.login("email", email, password, "UTC")

    # Assert
    assert user_obj.uuid == user.uuid
    assert token is not None
    assert len(token) > 10


@pytest.mark.asyncio
async def test_login_failure_wrong_password(db_session):
    # Setup
    service = AuthService(db_session)
    email = "failuser@example.com"
    password = "correctpass"

    user = User(
        uuid=uuid4(),
        username="fail_user",
        email=email,
        password=User.hash_password(password),
        registration_type="email",
    )
    db_session.add(user)
    await db_session.commit()

    # Action & Assert
    with pytest.raises(AuthenticationError, match="Invalid password"):
        await service.login("email", email, "wrongpass", "UTC")


@pytest.mark.asyncio
async def test_login_failure_user_not_found(db_session):
    service = AuthService(db_session)
    with pytest.raises(AuthenticationError, match="User does not exist"):
        await service.login("email", "nonexistent@example.com", "pass", "UTC")
