from typing import Optional

from fastapi import APIRouter, Depends, Query, status
from sqlalchemy import and_, func, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_session
from app.core.dependencies import get_current_user
from app.core.responses import error_response, get_error_code_int, success_response
from app.models.notification import Notification
from app.models.user import User
from app.schemas.notification import NotificationListResponse, NotificationResponse

router = APIRouter(prefix="/notifications", tags=["notifications"])


@router.get("", response_model=NotificationListResponse)
async def get_notifications(
    page: int = 1,
    limit: int = 20,
    unread_only: bool = False,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
):
    """Get user notifications with pagination."""
    # Base filters
    filters = [
        Notification.user_uuid == current_user.id
    ]  # Wait, let me check if user.id is what notification.user_uuid expects
    if unread_only:
        filters.append(Notification.is_read.is_(False))

    # Count total
    count_query = select(func.count(Notification.id)).where(and_(*filters))
    count_result = await db.execute(count_query)
    total = count_result.scalar() or 0

    # Get unread count
    unread_count_query = select(func.count(Notification.id)).where(
        and_(Notification.user_uuid == current_user.id, Notification.is_read.is_(False))
    )
    unread_result = await db.execute(unread_count_query)
    unread_count = unread_result.scalar() or 0

    # Get notifications
    query = (
        select(Notification)
        .where(and_(*filters))
        .order_by(Notification.created_at.desc())
        .offset((page - 1) * limit)
        .limit(limit)
    )
    result = await db.execute(query)
    notifications = result.scalars().all()

    # Convert to response objects
    items = []
    for n in notifications:
        items.append(
            {
                "id": str(n.id),
                "userId": str(current_user.uuid),
                "type": n.type,
                "title": n.title,
                "message": n.content or "",
                "data": n.data,
                "isRead": n.is_read,
                "createdAt": n.created_at,
                "readAt": n.read_at,
            }
        )

    return success_response(
        data={"notifications": items, "total": total, "unreadCount": unread_count, "page": page, "limit": limit}
    )


@router.get("/unread-count")
async def get_unread_count(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
):
    """Get unread notifications count."""
    query = select(func.count(Notification.id)).where(
        and_(Notification.user_uuid == current_user.id, Notification.is_read.is_(False))
    )
    result = await db.execute(query)
    count = result.scalar() or 0
    return success_response(data={"count": count})


@router.patch("/{notification_id}/read")
async def mark_as_read(
    notification_id: int,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
):
    """Mark notification as read."""
    query = select(Notification).where(
        and_(Notification.id == notification_id, Notification.user_uuid == current_user.id)
    )
    result = await db.execute(query)
    notification = result.scalar_one_or_none()

    if not notification:
        return error_response(code=get_error_code_int("NOT_FOUND"), message="Notification not found", http_status=404)

    notification.mark_as_read()
    await db.commit()
    return success_response(data={"message": "Marked as read"})


@router.patch("/mark-all-read")
async def mark_all_read(
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
):
    """Mark all notifications as read."""
    from sqlalchemy import update

    query = (
        update(Notification)
        .where(and_(Notification.user_uuid == current_user.id, Notification.is_read.is_(False)))
        .values(is_read=True, read_at=func.now())
    )
    await db.execute(query)
    await db.commit()
    return success_response(data={"message": "All marked as read"})


@router.delete("/{notification_id}")
async def delete_notification(
    notification_id: int,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
):
    """Delete a notification."""
    query = select(Notification).where(
        and_(Notification.id == notification_id, Notification.user_uuid == current_user.id)
    )
    result = await db.execute(query)
    notification = result.scalar_one_or_none()

    if not notification:
        return error_response(code=get_error_code_int("NOT_FOUND"), message="Notification not found", http_status=404)

    await db.delete(notification)
    await db.commit()
    return success_response(data={"message": "Notification deleted"})
