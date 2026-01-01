"""Authentication endpoints.

This module provides endpoints for user authentication including:
- Send verification code (email/mobile)
- User registration
- User login
- Token verification and user/session dependencies
"""

import uuid
from typing import List

from fastapi import APIRouter, Depends, Form, HTTPException, Request, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from fastapi_pagination import Params
from pydantic import BaseModel, Field
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import SessionRepository, get_session, get_session_context
from app.core.logging import bind_context, logger
from app.models.session import Session as ChatSession
from app.models.user import User
from app.schemas.auth import AuthResponse, LoginRequest, RegisterRequest, SendCodeRequest, SessionResponse, UserInfo
from app.services.auth_service import AuthService
from app.utils.auth import create_access_token, verify_token
from app.utils.sanitization import sanitize_string

router = APIRouter(prefix="/auth", tags=["auth"])
security = HTTPBearer()


class SessionItem(BaseModel):
    """Session item for paginated list response.

    Attributes:
        session_id: The unique identifier for the chat session
        name: Name of the session
        token: The authentication token for the session
        created_at: When the session was created (ISO 8601 format)
        updated_at: When the session was last updated (ISO 8601 format)
    """

    session_id: str = Field(..., description="The unique identifier for the chat session")
    name: str = Field(default="", description="Name of the session")
    token: str = Field(..., description="The authentication token for the session")
    created_at: str = Field(..., description="When the session was created")
    updated_at: str = Field(..., description="When the session was last updated")


async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: AsyncSession = Depends(get_session),
) -> User:
    """Get the current user from JWT token.

    Args:
        credentials: HTTP authorization credentials
        db: Database session

    Returns:
        User: The authenticated user

    Raises:
        HTTPException: If token is invalid or user not found
    """
    try:
        token = credentials.credentials
        user_uuid = verify_token(token)

        if user_uuid is None:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid authentication credentials",
                headers={"WWW-Authenticate": "Bearer"},
            )

        # Get user from database by UUID
        result = await db.execute(select(User).where(User.uuid == user_uuid))
        user = result.scalar_one_or_none()
        if user is None:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="User not found",
                headers={"WWW-Authenticate": "Bearer"},
            )

        return user

    except ValueError:
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            detail="Invalid token format",
            headers={"WWW-Authenticate": "Bearer"},
        )


async def get_authorized_session(
    session_id: str,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
) -> ChatSession:
    """Get session with ownership verification.

    This function verifies both:
    1. The session exists in the database
    2. The current user owns the session

    Args:
        session_id: The session ID from path/body parameter
        current_user: The authenticated user from access token
        db: Database session

    Returns:
        ChatSession: The verified session

    Raises:
        HTTPException: 404 if session not found, 403 if access denied
    """
    # Sanitize session_id
    sanitized_session_id = sanitize_string(session_id)

    # Verify session exists using repository
    repo = SessionRepository(db)
    session = await repo.get(sanitized_session_id)
    if session is None:
        logger.error("session_not_found", session_id=sanitized_session_id)
        raise HTTPException(
            status_code=404,
            detail="Session not found",
        )

    # Verify ownership
    if str(session.user_uuid) != str(current_user.uuid):
        logger.warning(
            "session_access_denied",
            session_id=sanitized_session_id,
            session_owner=session.user_uuid,
            requesting_user=current_user.uuid,
        )
        raise HTTPException(
            status_code=403,
            detail="Access denied to this session",
        )

    # Bind user_uuid to logging context
    bind_context(user_uuid=session.user_uuid)

    return session


@router.post("/send-code")
async def send_code(
    data: SendCodeRequest,
    db: AsyncSession = Depends(get_session),
):
    """Send verification code to email or mobile.

    Args:
        data: Send code request data
        db: Database session

    Returns:
        JSONResponse: Unified response format with code=0 on success

    Raises:
        BusinessError: If account already exists (handled by exception handler)
    """
    from app.core.responses import success_response

    auth_service = AuthService(db, None)

    # Send verification code
    await auth_service.send_verification_code(
        account_type=data.type,
        account=data.account,
    )

    logger.info(
        "verification_code_request_accepted",
        account_type=data.type,
        account=data.account[:3] + "***",  # Mask account for privacy
    )

    return success_response(message="Verification code sent successfully")


@router.post("/register")
async def register(
    request: Request,
    data: RegisterRequest,
    db: AsyncSession = Depends(get_session),
):
    """Register a new user.

    Args:
        request: FastAPI request object
        data: Registration request data
        db: Database session

    Returns:
        JSONResponse: Unified response with token and user info (code=0 on success)

    Raises:
        Returns error_response with appropriate error code on failure
    """
    from app.core.responses import error_response, get_error_code_int, success_response

    try:
        auth_service = AuthService(db, None)

        # Get client IP
        client_ip = request.client.host if request.client else None

        # Register user
        user = await auth_service.register(
            account_type=data.type,
            account=data.account,
            password=data.password,
            code=data.code,
            timezone=data.timezone,
            client_ip=client_ip,
            locale=data.locale,
        )

        # Generate token using user UUID
        from app.utils.auth import create_access_token

        token_obj = create_access_token(user.uuid)
        token = token_obj.access_token

        # Build user info response
        user_info = UserInfo(
            id=user.uuid,
            email=user.email,
            mobile=user.mobile,
            username=user.username or user.email or user.mobile or f"user_{str(user.uuid)[:8]}",
            avatarUrl=user.avatar_url,
            createdAt=user.created_at.isoformat(),
            updatedAt=user.updated_at.isoformat(),
            clientLastLoginAt=user.last_login_at.isoformat() if user.last_login_at else None,
        )

        logger.info(
            "user_registered",
            user_uuid=user.uuid,
            account_type=data.type,
            account=data.account[:3] + "***",
        )

        # 返回统一格式
        auth_response = AuthResponse(token=token, user=user_info)
        return success_response(data=auth_response.model_dump(), message="Registration successful")

    except ValueError as e:
        logger.error("registration_failed", error=str(e), account_type=data.type)
        # Parse error code from ValueError message (format: "ERROR_CODE: message")
        error_msg = str(e)
        if ":" in error_msg:
            error_code_str, message = error_msg.split(":", 1)
            error_code_str = error_code_str.strip()
            message = message.strip()
        else:
            error_code_str = "VALIDATION_ERROR"
            message = error_msg

        return error_response(code=get_error_code_int(error_code_str), message=message, http_status=400)
    except Exception as e:
        logger.exception("registration_unexpected_error", error=str(e))
        return error_response(
            code=get_error_code_int("INTERNAL_ERROR"), message="Registration failed", http_status=500
        )


@router.post("/login")
async def login(
    request: Request,
    data: LoginRequest,
    db: AsyncSession = Depends(get_session),
):
    """User login.

    Args:
        request: FastAPI request object
        data: Login request data
        db: Database session

    Returns:
        JSONResponse: Unified response with token and user info (code=0 on success)

    Raises:
        Returns error_response with appropriate error code on failure
    """
    from app.core.responses import error_response, get_error_code_int, success_response

    try:
        auth_service = AuthService(db, None)

        # Get client IP
        client_ip = request.client.host if request.client else None

        # Login user (returns tuple of user and token)
        user, token = await auth_service.login(
            account_type=data.type,
            account=data.account,
            password=data.password,
            timezone=data.timezone,
            client_ip=client_ip,
        )

        # Build user info response
        user_info = UserInfo(
            id=user.uuid,
            email=user.email,
            mobile=user.mobile,
            username=user.username or user.email or user.mobile or f"user_{str(user.uuid)[:8]}",
            avatarUrl=user.avatar_url,
            createdAt=user.created_at.isoformat(),
            updatedAt=user.updated_at.isoformat(),
            clientLastLoginAt=user.last_login_at.isoformat() if user.last_login_at else None,
        )

        logger.info(
            "user_logged_in",
            user_uuid=str(user.uuid),
            account_type=data.type,
            account=data.account[:3] + "***",
        )

        # 返回统一格式
        auth_response = AuthResponse(token=token, user=user_info)
        return success_response(data=auth_response.model_dump(), message="Login successful")

    except ValueError as e:
        logger.error("login_failed", error=str(e), account_type=data.type)
        # Parse error code from ValueError message (format: "ERROR_CODE: message")
        error_msg = str(e)
        if ":" in error_msg:
            error_code_str, message = error_msg.split(":", 1)
            error_code_str = error_code_str.strip()
            message = message.strip()
        else:
            error_code_str = "AUTH_FAILED"
            message = error_msg

        return error_response(code=get_error_code_int(error_code_str), message=message, http_status=401)
    except Exception as e:
        logger.exception("login_unexpected_error", error=str(e))
        return error_response(code=get_error_code_int("INTERNAL_ERROR"), message="Login failed", http_status=500)


@router.post("/session")
async def create_session(user: User = Depends(get_current_user)):
    """Create a new chat session for the authenticated user.

    Args:
        user: The authenticated user

    Returns:
        Unified response with session data
    """
    from app.core.responses import error_response, get_error_code_int, success_response

    try:
        # Generate a unique session ID
        session_id = str(uuid.uuid4())

        # Create session in database with default name "New Chat"
        async with get_session_context() as db:
            repo = SessionRepository(db)
            session = await repo.create(session_id, current_user.uuid, name="New Chat")

        logger.info(
            "session_created",
            session_id=session_id,
            user_uuid=user.uuid,
            name=session.name,
        )

        return success_response(
            data={
                "session_id": session_id,
                "name": session.name,
            },
            message="Session created successfully",
        )
    except ValueError as ve:
        logger.error("session_creation_validation_failed", error=str(ve), user_uuid=user.uuid, exc_info=True)
        return error_response(code=get_error_code_int("VALIDATION_ERROR"), message=str(ve), http_status=422)


@router.patch("/session/{session_id}/name", response_model=SessionResponse)
async def update_session_name(
    session_id: str,
    name: str = Form(...),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
):
    """Update a session's name.

    Args:
        session_id: The ID of the session to update
        name: The new name for the session
        current_user: The authenticated user
        db: Database session

    Returns:
        SessionResponse: The updated session information
    """
    from app.core.responses import success_response

    # Verify session ownership (this will use the same db session via Depends)
    session = await get_authorized_session(session_id, current_user, db)

    # Sanitize name
    sanitized_name = sanitize_string(name)

    # Update the session name
    repo = SessionRepository(db)
    updated_session = await repo.update_name(session.id, sanitized_name)

    logger.info(
        "session_name_updated",
        session_id=session.id,
        user_uuid=current_user.uuid,
        new_name=sanitized_name,
    )

    return success_response(
        data={
            "session_id": session.id,
            "name": updated_session.name,
        },
        message="Session name updated",
    )


@router.delete("/session/{session_id}")
async def delete_session(
    session_id: str,
    current_user: User = Depends(get_current_user),
):
    """Delete a session for the authenticated user.

    This endpoint performs cascade deletion:
    1. Delete session metadata from sessions table
    2. Delete LangGraph checkpoints (checkpoint_blobs, checkpoint_writes, checkpoints)
    3. Delete searchable_messages for the thread

    Note: Attachments are NOT deleted as they may be reused.

    Args:
        session_id: The ID of the session to delete
        current_user: The authenticated user

    Returns:
        Success response
    """
    from app.api.v1.chatbot import agent as chatbot_agent
    from app.core.responses import error_response, get_error_code_int, success_response

    # Verify session ownership
    async with get_session_context() as db:
        repo = SessionRepository(db)
        session = await repo.get(session_id)
        if session is None:
            raise HTTPException(status_code=404, detail="Session not found")
            
        if str(session.user_uuid) != str(current_user.uuid):
            logger.warning(
                "session_delete_unauthorized",
                session_id=session_id,
                user_uuid=current_user.uuid,
                owner_uuid=session.user_uuid,
            )
            raise HTTPException(status_code=403, detail="Access denied to this session")

    try:
        # 1. Use the chatbot agent to cascade delete history
        # This handles LangGraph checkpoints (via official API) and searchable_messages
        await chatbot_agent.delete_session_history(str(session.id))

        # 2. Delete the session metadata
        async with get_session_context() as db:
            repo = SessionRepository(db)
            await repo.delete(session.id)

        logger.info(
            "session_deleted_with_history",
            session_id=session.id,
            user_uuid=current_user.uuid,
        )

        return success_response(message="Session deleted")

    except Exception as e:
        logger.error(
            "session_delete_failed",
            session_id=session.id,
            error=str(e),
            exc_info=True,
        )
        return error_response(
            code=get_error_code_int("INTERNAL_ERROR"),
            message="Failed to delete session",
            http_status=500,
        )


@router.get("/sessions")
async def get_user_sessions(
    user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
    params: Params = Depends(),
):
    """Get paginated session list for the authenticated user.

    This endpoint returns sessions with pagination support in unified response format.
    Use query parameters `page` (default: 1) and `size` (default: 50) to control pagination.

    Args:
        user: The authenticated user
        db: Database session
        params: Pagination parameters (injected by fastapi-pagination)

    Returns:
        JSONResponse: Unified response with paginated sessions
    """
    from fastapi_pagination import Params
    from fastapi_pagination.ext.sqlalchemy import paginate

    from app.core.responses import error_response, get_error_code_int, success_response

    try:
        # Build query for user's sessions, ordered by most recent first
        query = select(ChatSession).where(ChatSession.user_uuid == user.uuid).order_by(ChatSession.created_at.desc())

        # Use fastapi-pagination to paginate the query
        page_result = await paginate(
            db,
            query,
            params=params,
            transformer=lambda items: [
                {
                    "session_id": session.id,
                    "name": session.name or "",
                    # Use standard ISO 8601 format: replace +00:00 with Z for UTC
                    "created_at": (
                        session.created_at.isoformat().replace("+00:00", "Z") if session.created_at else ""
                    ),
                    "updated_at": (
                        session.updated_at.isoformat().replace("+00:00", "Z") if session.updated_at else ""
                    ),
                }
                for session in items
            ],
        )

        # Wrap fastapi-pagination result in unified response format
        return success_response(
            data={
                "items": page_result.items,
                "page": page_result.page,
                "size": page_result.size,
                "total": page_result.total,
                "pages": page_result.pages,
                "has_more": page_result.page < page_result.pages if page_result.pages else False,
            },
            message="Sessions retrieved successfully",
        )
    except Exception as e:
        logger.error(
            "get_sessions_failed",
            user_uuid=user.uuid,
            error=str(e),
            exc_info=True,
        )
        return error_response(
            code=get_error_code_int("INTERNAL_ERROR"),
            message="Failed to retrieve sessions",
            http_status=500,
        )
