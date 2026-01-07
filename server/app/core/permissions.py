"""Permission and role-based access control (RBAC) system.

This module provides:
- Role definitions and management
- Permission checking decorators
- Resource ownership validation
"""

from __future__ import annotations

from collections.abc import Callable
from enum import Enum
from functools import wraps
from typing import Any

from fastapi import Depends, HTTPException, status

from app.core.dependencies import get_current_user
from app.core.logging import logger
from app.models.user import User


class Role(str, Enum):
    """User roles in the system.

    Attributes:
        ADMIN: System administrator with full access
        USER: Regular user with standard permissions
        GUEST: Guest user with limited access
    """

    ADMIN = "admin"
    USER = "user"
    GUEST = "guest"


class Permission(str, Enum):
    """System permissions.

    Attributes:
        READ: Read access to resources
        WRITE: Write/modify access to resources
        DELETE: Delete access to resources
        ADMIN: Administrative access
    """

    READ = "read"
    WRITE = "write"
    DELETE = "delete"
    ADMIN = "admin"


# Role to permissions mapping
ROLE_PERMISSIONS = {
    Role.ADMIN: [Permission.READ, Permission.WRITE, Permission.DELETE, Permission.ADMIN],
    Role.USER: [Permission.READ, Permission.WRITE, Permission.DELETE],
    Role.GUEST: [Permission.READ],
}


def get_user_role(user: User) -> Role:
    """Get the role for a user.

    Args:
        user: The user object

    Returns:
        Role: The user's role (defaults to USER)
    """
    # In a real system, this would check a role field on the user model
    # For now, we'll default all users to USER role
    # You can extend the User model to include a role field
    return Role.USER


def has_permission(user: User, permission: Permission) -> bool:
    """Check if a user has a specific permission.

    Args:
        user: The user object
        permission: The permission to check

    Returns:
        bool: True if user has the permission
    """
    user_role = get_user_role(user)
    role_permissions = ROLE_PERMISSIONS.get(user_role, [])
    return permission in role_permissions


def require_permission(permission: Permission) -> Callable[[Callable[..., Any]], Callable[..., Any]]:
    """Decorator to require a specific permission for an endpoint.

    Args:
        permission: The required permission

    Returns:
        Callable: Decorated function

    Raises:
        HTTPException: If user doesn't have the required permission
    """

    def decorator(func: Callable[..., Any]) -> Callable[..., Any]:
        @wraps(func)
        async def wrapper(*args: Any, user: User = Depends(get_current_user), **kwargs: Any) -> Any:
            if not has_permission(user, permission):
                logger.warning("permission_denied", user_uuid=user.uuid, required_permission=permission.value)
                raise HTTPException(
                    status_code=status.HTTP_403_FORBIDDEN, detail=f"Permission denied: {permission.value} required"
                )
            return await func(*args, user=user, **kwargs)

        return wrapper

    return decorator


def require_role(required_role: Role) -> Callable[[Callable[..., Any]], Callable[..., Any]]:
    """Decorator to require a specific role for an endpoint.

    Args:
        required_role: The required role

    Returns:
        Callable: Decorated function

    Raises:
        HTTPException: If user doesn't have the required role
    """

    def decorator(func: Callable[..., Any]) -> Callable[..., Any]:
        @wraps(func)
        async def wrapper(*args: Any, user: User = Depends(get_current_user), **kwargs: Any) -> Any:
            user_role = get_user_role(user)
            if user_role != required_role:
                logger.warning(
                    "role_check_failed",
                    user_uuid=user.uuid,
                    user_role=user_role.value,
                    required_role=required_role.value,
                )
                raise HTTPException(
                    status_code=status.HTTP_403_FORBIDDEN, detail=f"Role {required_role.value} required"
                )
            return await func(*args, user=user, **kwargs)

        return wrapper

    return decorator


class PermissionChecker:
    """Dependency class for checking permissions.

    Usage:
        @router.get("/admin")
        async def admin_endpoint(
            user: User = Depends(PermissionChecker(Permission.ADMIN))
        ):
            ...
    """

    def __init__(self, required_permission: Permission):
        """Initialize permission checker.

        Args:
            required_permission: The permission required to access the endpoint
        """
        self.required_permission = required_permission

    async def __call__(self, user: User = Depends(get_current_user)) -> User:
        """Check if user has required permission.

        Args:
            user: The authenticated user

        Returns:
            User: The user if they have permission

        Raises:
            HTTPException: If user lacks required permission
        """
        if not has_permission(user, self.required_permission):
            logger.warning(
                "permission_denied", user_uuid=user.uuid, required_permission=self.required_permission.value
            )
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail=f"Permission denied: {self.required_permission.value} required",
            )
        return user


class RoleChecker:
    """Dependency class for checking roles.

    Usage:
        @router.get("/admin")
        async def admin_endpoint(
            user: User = Depends(RoleChecker(Role.ADMIN))
        ):
            ...
    """

    def __init__(self, required_role: Role):
        """Initialize role checker.

        Args:
            required_role: The role required to access the endpoint
        """
        self.required_role = required_role

    async def __call__(self, user: User = Depends(get_current_user)) -> User:
        """Check if user has required role.

        Args:
            user: The authenticated user

        Returns:
            User: The user if they have the role

        Raises:
            HTTPException: If user lacks required role
        """
        user_role = get_user_role(user)
        if user_role != self.required_role:
            logger.warning(
                "role_check_failed",
                user_uuid=user.uuid,
                user_role=user_role.value,
                required_role=self.required_role.value,
            )
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN, detail=f"Role {self.required_role.value} required"
            )
        return user


async def check_resource_ownership(resource_user_uuid: str, current_user: User, allow_admin: bool = True) -> bool:
    """Check if user owns a resource or is an admin.

    Args:
        resource_user_uuid: The user UUID that owns the resource
        current_user: The current authenticated user
        allow_admin: Whether to allow admin access regardless of ownership

    Returns:
        bool: True if user owns the resource or is admin
    """
    # Check if user owns the resource
    if resource_user_uuid == current_user.id:
        return True

    # Check if user is admin (if allowed)
    if allow_admin:
        user_role = get_user_role(current_user)
        if user_role == Role.ADMIN:
            return True

    return False


async def require_resource_ownership(
    resource_user_uuid: str, current_user: User = Depends(get_current_user), allow_admin: bool = True
) -> User:
    """Dependency to require resource ownership.

    Args:
        resource_user_uuid: The user UUID that owns the resource
        current_user: The current authenticated user
        allow_admin: Whether to allow admin access

    Returns:
        User: The current user if they own the resource

    Raises:
        HTTPException: If user doesn't own the resource
    """
    if not await check_resource_ownership(resource_user_uuid, current_user, allow_admin):
        logger.warning("resource_access_denied", user_uuid=current_user.id, resource_owner_uuid=resource_user_uuid)
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN, detail="You don't have permission to access this resource"
        )

    return current_user


# Convenience functions for common permission checks


async def require_admin(user: User = Depends(get_current_user)) -> User:
    """Require admin role for an endpoint.

    Args:
        user: The authenticated user

    Returns:
        User: The user if they are admin

    Raises:
        HTTPException: If user is not admin
    """
    checker = RoleChecker(Role.ADMIN)
    return await checker(user)


async def require_write_permission(user: User = Depends(get_current_user)) -> User:
    """Require write permission for an endpoint.

    Args:
        user: The authenticated user

    Returns:
        User: The user if they have write permission

    Raises:
        HTTPException: If user lacks write permission
    """
    checker = PermissionChecker(Permission.WRITE)
    return await checker(user)


async def require_delete_permission(user: User = Depends(get_current_user)) -> User:
    """Require delete permission for an endpoint.

    Args:
        user: The authenticated user

    Returns:
        User: The user if they have delete permission

    Raises:
        HTTPException: If user lacks delete permission
    """
    checker = PermissionChecker(Permission.DELETE)
    return await checker(user)
