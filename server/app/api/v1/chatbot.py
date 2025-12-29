"""Chatbot API endpoints for handling chat interactions.

This module provides endpoints for chat interactions, including regular chat,
streaming chat, message history management, and chat history clearing.

Authentication: All endpoints use access token (user authentication).
Authorization: Session ownership is verified via get_authorized_session.
"""

import json
import uuid
from typing import Optional

from fastapi import (
    APIRouter,
    Depends,
    HTTPException,
    Query,
    Request,
)
from fastapi.responses import StreamingResponse
from sqlalchemy.ext.asyncio import AsyncSession

from app.api.v1.auth import (
    get_authorized_session,
    get_current_user,
)
from app.core.config import settings
from app.core.database import get_session, get_session_context, session_repository
from app.core.langgraph.simple_agent import SimpleLangChainAgent as LangGraphAgent
from app.core.limiter import limiter
from app.core.logging import logger
from app.core.responses import error_response, get_error_code_int, success_response
from app.models.session import Session
from app.models.user import User
from app.schemas.chat import (
    ChatRequest,
    ChatRequestWithAttachments,
    ChatResponse,
    Message,
)
from app.schemas.genui import GenUIEvent

router = APIRouter(prefix="/chatbot", tags=["chatbot"])
agent = LangGraphAgent()


async def resolve_chat_session(
    session_id: Optional[str],
    current_user: User,
) -> tuple[Session, bool]:
    """Resolve session for chat: get existing or create new.

    This function handles session resolution:
    - If session_id is provided: verify ownership and return existing session
    - If session_id is None: create a new session for the user

    Args:
        session_id: Optional session ID (None for new session)
        current_user: The authenticated user

    Returns:
        tuple[Session, bool]: (Session object, is_new_session flag)

    Raises:
        HTTPException: If session not found or access denied
    """
    async with get_session_context() as db:
        if session_id:
            # Existing session - verify ownership
            session = await get_authorized_session(session_id, current_user, db)
            logger.info(
                "using_existing_session",
                session_id=session.id,
                user_uuid=current_user.uuid,
            )
            return session, False
        else:
            # Create new session
            new_session_id = str(uuid.uuid4())
            session = await session_repository.create(db, new_session_id, str(current_user.uuid), name="New Chat")
            logger.info(
                "created_new_session",
                session_id=new_session_id,
                user_uuid=current_user.uuid,
            )
            return session, True


@router.post("/chat", response_model=ChatResponse)
@limiter.limit(settings.RATE_LIMIT_ENDPOINTS["chat"][0])
async def chat(
    request: Request,
    chat_request: ChatRequest,
    current_user: User = Depends(get_current_user),
):
    """Process a chat request using LangGraph.

    Args:
        request: The FastAPI request object for rate limiting.
        chat_request: The chat request containing messages and optional session_id.
        current_user: The authenticated user.

    Returns:
        ChatResponse: The processed chat response.

    Raises:
        HTTPException: If there's an error processing the request.
    """
    try:
        # Get session_id from request if available
        session_id = getattr(chat_request, "session_id", None)
        session, is_new = await resolve_chat_session(session_id, current_user)

        result = await agent.get_response(chat_request.messages, session.id, user_uuid=session.user_uuid)

        response = ChatResponse(messages=result)

        # If we created a new session, include the session_id in the response
        if is_new:
            response.session_id = session.id
            logger.info(
                "new_session_info_in_response",
                session_id=session.id,
            )

        return response
    except HTTPException:
        raise
    except Exception as e:
        logger.error(
            "chat_request_failed",
            session_id=session.id if "session" in dir() else None,
            error=str(e),
            exc_info=True,
        )
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/chat/stream")
@limiter.limit(settings.RATE_LIMIT_ENDPOINTS["chat_stream"][0])
async def chat_stream(
    request: Request,
    chat_request: ChatRequestWithAttachments,
    current_user: User = Depends(get_current_user),
):
    """Process a chat request with streaming response.

    Session handling:
    - If session_id in request: use existing session (with ownership verification)
    - If no session_id: create new session, return session_id in first SSE frame

    For new sessions, title is generated concurrently and streamed via title_update event.

    Args:
        request: The FastAPI request object for rate limiting.
        chat_request: The chat request containing messages and optional session_id.
        current_user: The authenticated user.

    Returns:
        StreamingResponse: A streaming response of the chat completion.
    """
    import asyncio

    from app.services.title_service import generate_session_title

    # Get session_id from request
    session_id = getattr(chat_request, "session_id", None)
    logger.info(
        "chat_stream_request_received",
        request_session_id=session_id,
        user_uuid=current_user.uuid,
        message_count=len(chat_request.messages) if chat_request.messages else 0,
    )
    session, is_new = await resolve_chat_session(session_id, current_user)
    logger.info(
        "chat_stream_session_resolved",
        resolved_session_id=str(session.id),
        is_new_session=is_new,
        original_request_session_id=session_id,
    )

    # Extract user message for title generation
    user_message = ""
    if chat_request.messages:
        user_message = chat_request.messages[-1].content

    # Extract attachment IDs from messages
    attachment_ids = []
    for msg in chat_request.messages:
        if msg.attachments:
            attachment_ids.extend([att.id for att in msg.attachments])

    async def event_generator():
        title_task = None
        title_sent = False

        try:
            # 1. Session init event (only for new sessions)
            if is_new:
                # Start title generation task concurrently
                title_task = asyncio.create_task(generate_session_title(user_message))

                init_event = GenUIEvent(
                    type="session_init",
                    metadata={
                        "session_id": session.id,
                    },
                )
                yield f"data: {json.dumps(init_event.model_dump(mode='json', exclude_none=True), ensure_ascii=False)}\n\n"

            # 2. GenUI 原子模式：直接传递 client_state 给 get_genui_stream
            # 状态校验在 simple_agent 层处理
            client_state = chat_request.client_state
            if client_state:
                logger.info(
                    "genui_atomic_mode_request",
                    session_id=session.id,
                    ui_mode=client_state.ui_mode,
                )

            # 2.5 设置会话语言（用于技能脚本本地化）
            from app.core.langgraph.tools import current_session_language, current_user_id

            # 优先使用 X-App-Language 头，否则从 Accept-Language 解析
            app_language = request.headers.get("X-App-Language")
            if not app_language:
                accept_language = request.headers.get("Accept-Language", "zh")
                # 解析 Accept-Language: zh-CN,zh;q=0.9,en;q=0.8
                app_language = accept_language.split(",")[0].split(";")[0].strip()

            # 规范化语言代码
            if app_language.startswith("zh-TW") or app_language.startswith("zh-Hant"):
                app_language = "zh-Hant"
            elif app_language.startswith("zh"):
                app_language = "zh"
            elif app_language.startswith("ja"):
                app_language = "ja"
            elif app_language.startswith("ko"):
                app_language = "ko"
            elif app_language.startswith("en"):
                app_language = "en"
            else:
                app_language = "zh"  # 默认中文

            lang_token = current_session_language.set(app_language)
            user_token = current_user_id.set(str(session.user_uuid)) if session.user_uuid else None

            try:
                # 3. Stream agent events with concurrent title check
                async for event in agent.get_genui_stream(
                    chat_request.messages,
                    session.id,
                    user_uuid=session.user_uuid,
                    attachment_ids=attachment_ids,
                    client_state=client_state,
                ):
                    # Check if title task is ready (non-blocking)
                    if title_task and not title_sent and title_task.done():
                        try:
                            title = title_task.result()
                            # Update session name in database
                            async with get_session_context() as db:
                                await session_repository.update_name(db, session.id, title)
                            # Send title update event
                            title_event = GenUIEvent(type="title_update", title=title)
                            yield f"data: {json.dumps(title_event.model_dump(mode='json', exclude_none=True), ensure_ascii=False)}\n\n"
                            title_sent = True
                            logger.info("title_update_sent", session_id=session.id, title=title)
                        except Exception as e:
                            logger.error("title_update_failed", error=str(e))
                            title_sent = True  # Mark as sent to avoid retry

                    # Yield main stream event
                    yield f"data: {json.dumps(event.model_dump(mode='json', exclude_none=True), ensure_ascii=False)}\n\n"

                # 3. If title task not yet finished, wait and send before closing
                if title_task and not title_sent:
                    try:
                        title = await title_task
                        async with get_session_context() as db:
                            await session_repository.update_name(db, session.id, title)
                        title_event = GenUIEvent(type="title_update", title=title)
                        yield f"data: {json.dumps(title_event.model_dump(mode='json', exclude_none=True), ensure_ascii=False)}\n\n"
                        logger.info("title_update_sent_after_stream", session_id=session.id, title=title)
                    except Exception as e:
                        logger.error("title_update_failed_after_stream", error=str(e))
            finally:
                # 重置 ContextVar
                # 注意：如果连接断开触发 GeneratorExit，清理操作可能在不同 Context 中执行，
                # 这种情况下 reset 会抛出 ValueError，我们捕获它以保证稳定性。
                try:
                    current_session_language.reset(lang_token)
                except ValueError:
                    pass

                if user_token:
                    try:
                        current_user_id.reset(user_token)
                    except ValueError:
                        pass

                # Update long-term memory after conversation completes
                # This runs in background to not block response
                if user_message and session.user_uuid:
                    try:
                        # Build conversation messages for memory extraction
                        memory_messages = [{"role": "user", "content": user_message}]
                        # Note: We don't have AI response here as it's streamed
                        # Memory extraction will work with user message context
                        await agent._update_long_term_memory(
                            user_uuid=str(session.user_uuid),
                            messages=memory_messages,
                            session_id=str(session.id),
                            category="conversation",
                        )
                    except Exception as mem_error:
                        # Don't fail the response if memory update fails
                        logger.warning(
                            "memory_update_in_stream_failed",
                            session_id=str(session.id),
                            error=str(mem_error),
                        )

        except Exception as e:
            logger.error(f"Stream error: {e}", exc_info=True)
            error_event = GenUIEvent(type="error", content=str(e))
            yield f"data: {json.dumps(error_event.model_dump(mode='json'), ensure_ascii=False)}\n\n"

    return StreamingResponse(event_generator(), media_type="text/event-stream")


@router.post("/sessions/{session_id}/state")
@limiter.limit(settings.RATE_LIMIT_ENDPOINTS["messages"][0])
async def update_session_state(
    request: Request,
    session_id: str,
    updates: dict,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
):
    """Update session state directly.

    Args:
        request: The FastAPI request object for rate limiting.
        session_id: The session ID to update.
        updates: The updates to apply to the state.
        current_user: The authenticated user.

    Returns:
        dict: A message indicating the state was updated.
    """
    # Verify session ownership
    session = await get_authorized_session(session_id, current_user, db)

    logger.info(
        "update_state_request_received",
        session_id=session.id,
        update_keys=list(updates.keys()),
        updates=updates,
    )

    try:
        await agent.update_state(session.id, updates)
        logger.info("update_state_success", session_id=session.id)
        return success_response(message="State updated successfully")
    except Exception as e:
        logger.error(
            "update_state_failed",
            session_id=session.id,
            error=str(e),
            exc_info=True,
        )
        return error_response(
            code=get_error_code_int("INTERNAL_ERROR"),
            message="Failed to update state",
            http_status=500,
        )


@router.get("/sessions/{session_id}/messages")
@limiter.limit(settings.RATE_LIMIT_ENDPOINTS["messages"][0])
async def get_session_messages(
    request: Request,
    session_id: str,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
):
    """Get detailed messages for a session including tool calls and UI components.

    Returns complete message history with:
    - User/assistant messages with text content
    - Tool calls and their results
    - UI component data for GenUI rendering
    - Attachment info with signed URLs

    Args:
        request: The FastAPI request object for rate limiting.
        session_id: The session ID from URL path.
        current_user: The authenticated user.

    Returns:
        Unified response with detailed messages in data field.
    """
    # Verify session ownership
    session = await get_authorized_session(session_id, current_user, db)

    try:
        # Use new detailed history method
        messages = await agent.get_detailed_history(session.id, user_uuid=str(session.user_uuid))

        return success_response(
            data={
                "messages": messages,
                "session_id": session.id,
                "title": session.name,
            },
            message="Messages retrieved successfully",
        )
    except Exception as e:
        logger.error(
            "get_messages_failed",
            session_id=session.id,
            error=str(e),
            exc_info=True,
        )
        return error_response(
            code=get_error_code_int("INTERNAL_ERROR"),
            message="Failed to retrieve session messages",
            http_status=500,
        )


@router.delete("/sessions/{session_id}/messages")
@limiter.limit(settings.RATE_LIMIT_ENDPOINTS["messages"][0])
async def clear_session_messages(
    request: Request,
    session_id: str,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
):
    """Clear all messages for a session.

    Args:
        request: The FastAPI request object for rate limiting.
        session_id: The session ID from URL path.
        current_user: The authenticated user.

    Returns:
        dict: A message indicating the chat history was cleared.

    Raises:
        HTTPException: If session not found, access denied, or error clearing messages.
    """
    # Verify session ownership
    session = await get_authorized_session(session_id, current_user, db)

    try:
        await agent.clear_chat_history(session.id)
        logger.info(
            "chat_history_cleared",
            session_id=session.id,
            user_uuid=current_user.uuid,
        )
        return success_response(message="Chat history cleared successfully")
    except Exception as e:
        logger.error(
            "clear_chat_history_failed",
            session_id=session.id,
            error=str(e),
            exc_info=True,
        )
        return error_response(
            code=get_error_code_int("INTERNAL_ERROR"),
            message="Failed to clear session messages",
            http_status=500,
        )


@router.post("/sessions/{session_id}/cancel")
@limiter.limit(settings.RATE_LIMIT_ENDPOINTS["messages"][0])
async def cancel_last_turn(
    request: Request,
    session_id: str,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
):
    """Cancel the last turn and remove incomplete messages from checkpoint.

    This endpoint is called when user cancels an ongoing SSE stream.
    It removes any incomplete messages from the last turn, ensuring
    the next request starts from a clean state.

    LangGraph recommended approach: Use RemoveMessage to clean up state.

    Args:
        request: The FastAPI request object for rate limiting.
        session_id: The session ID from URL path.
        current_user: The authenticated user.

    Returns:
        dict: A message indicating the cancellation result.
    """
    # Verify session ownership
    session = await get_authorized_session(session_id, current_user, db)

    try:
        result = await agent.cancel_last_turn(str(session.id))
        logger.info(
            "last_turn_cancelled",
            session_id=session.id,
            user_uuid=current_user.uuid,
            removed_count=result.get("removed_count", 0),
        )
        return success_response(
            message="Last turn cancelled successfully",
            data=result,
        )
    except Exception as e:
        logger.error(
            "cancel_last_turn_failed",
            session_id=session.id,
            error=str(e),
            exc_info=True,
        )
        return error_response(
            code=get_error_code_int("INTERNAL_ERROR"),
            message="Failed to cancel last turn",
            http_status=500,
        )


@router.get("/sessions/{session_id}/resume-status")
@limiter.limit(settings.RATE_LIMIT_ENDPOINTS["messages"][0])
async def get_resume_status(
    request: Request,
    session_id: str,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
):
    """检查会话是否有可恢复的未完成执行。

    利用 LangGraph checkpoint 机制，检查 state.next 是否有待执行节点。
    如果 canResume 为 true，客户端可调用 /resume 端点恢复执行。

    Args:
        request: The FastAPI request object for rate limiting.
        session_id: The session ID from URL path.
        current_user: The authenticated user.

    Returns:
        dict: 包含 canResume 和 nextNodes 字段
    """
    # Verify session ownership
    session = await get_authorized_session(session_id, current_user, db)

    try:
        state = await agent.get_session_state(str(session.id))

        # state.next 是一个元组，包含待执行的节点名称
        can_resume = state.next is not None and len(state.next) > 0
        next_nodes = list(state.next) if state.next else []

        logger.info(
            "resume_status_checked",
            session_id=session.id,
            can_resume=can_resume,
            next_nodes=next_nodes,
        )

        return success_response(
            data={
                "canResume": can_resume,
                "nextNodes": next_nodes,
            }
        )
    except Exception as e:
        logger.error(
            "resume_status_check_failed",
            session_id=session.id,
            error=str(e),
            exc_info=True,
        )
        return error_response(
            code=get_error_code_int("INTERNAL_ERROR"),
            message="Failed to check resume status",
            http_status=500,
        )


@router.post("/sessions/{session_id}/resume")
@limiter.limit(settings.RATE_LIMIT_ENDPOINTS["chat_stream"][0])
async def resume_session(
    request: Request,
    session_id: str,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
):
    """从 checkpoint 恢复会话的未完成执行。

    返回 SSE 流，继续接收剩余的流式响应。
    建议先调用 /resume-status 检查是否有可恢复状态。

    Args:
        request: The FastAPI request object for rate limiting.
        session_id: The session ID from URL path.
        current_user: The authenticated user.

    Returns:
        StreamingResponse: SSE 流式响应
    """
    # Verify session ownership
    session = await get_authorized_session(session_id, current_user, db)

    async def event_generator():
        try:
            async for event in agent.resume_stream(
                str(session.id),
                user_uuid=str(session.user_uuid),
            ):
                yield f"data: {json.dumps(event.model_dump(mode='json', exclude_none=True), ensure_ascii=False)}\n\n"
        except Exception as e:
            logger.error(f"Resume stream error: {e}", exc_info=True)
            error_event = GenUIEvent(type="error", content=str(e))
            yield f"data: {json.dumps(error_event.model_dump(mode='json'), ensure_ascii=False)}\n\n"

    return StreamingResponse(event_generator(), media_type="text/event-stream")


@router.get("/sessions/messages/search")
@limiter.limit(settings.RATE_LIMIT_ENDPOINTS["messages"][0])
async def search_conversations(
    request: Request,
    q: str = Query(..., min_length=1, description="Search query"),
    limit: int = Query(20, ge=1, le=50, description="Maximum results to return"),
    current_user: User = Depends(get_current_user),
):
    """Search user's conversation history.

    Currently searches session titles with Chinese tokenization support.
    Returns matching sessions with highlight positions for the query terms.

    Args:
        request: The FastAPI request object for rate limiting.
        q: Search query string (min 1 character).
        limit: Maximum number of results (1-50, default 20).
        current_user: The authenticated user.

    Returns:
        Unified response with search results in data field.
    """
    from app.services.search_service import search_service

    try:
        # Use combined_search for both session titles and message content
        results = await search_service.combined_search(
            user_uuid=current_user.uuid,
            query=q,
            limit=limit,
        )

        # Convert to camelCase for frontend compatibility
        data = [
            {
                "id": r.id,
                "title": r.title,
                "snippet": r.snippet,
                "messageId": r.message_id,
                "createdAt": r.created_at.isoformat() if r.created_at else None,
                "updatedAt": r.updated_at.isoformat() if r.updated_at else None,
                "highlights": [{"start": h.start, "end": h.end, "field": h.field} for h in r.highlights],
            }
            for r in results
        ]

        return success_response(
            data=data,
            message="Search completed successfully",
        )

    except Exception as e:
        logger.error(
            "search_conversations_failed",
            user_uuid=current_user.uuid,
            query=q,
            error=str(e),
            exc_info=True,
        )
        return error_response(
            code=get_error_code_int("INTERNAL_ERROR"),
            message="Search failed",
            http_status=500,
        )
