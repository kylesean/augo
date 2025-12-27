"""Storage configuration API endpoints.

Provides REST API for managing user storage configurations:
- Create storage configs (S3, WebDAV, local)
- List user storage configs
- Update storage configs
- Delete storage configs
"""

from typing import List, Optional

from fastapi import APIRouter, Depends, status
from pydantic import BaseModel, ConfigDict, Field
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_session
from app.core.dependencies import get_current_user
from app.core.exceptions import BusinessException
from app.core.logging import logger
from app.core.responses import success_response
from app.models.storage_config import ProviderType
from app.models.user import User
from app.services.storage_config_service import StorageConfigService

router = APIRouter(prefix="/storage-configs", tags=["storage-configs"])


# --- Pydantic Schemas ---


class StorageConfigCreate(BaseModel):
    """Request schema for creating a storage config."""

    provider_type: str = Field(..., description="Provider type: local_uploads, s3_compatible, webdav")
    name: str = Field(..., max_length=100, description="Display name")
    base_path: str = Field(..., max_length=255, description="Root path or bucket name")
    credentials: Optional[dict] = Field(
        default=None, description="Connection credentials (endpoint, access_key, secret_key, etc.)"
    )
    is_readonly: bool = Field(default=True, description="Whether to prevent write operations")


class StorageConfigUpdate(BaseModel):
    """Request schema for updating a storage config."""

    name: Optional[str] = Field(None, max_length=100)
    base_path: Optional[str] = Field(None, max_length=255)
    credentials: Optional[dict] = None
    is_readonly: Optional[bool] = None


class StorageConfigResponse(BaseModel):
    """Response schema for storage config."""

    id: int
    provider_type: str
    name: str
    base_path: str
    credentials: dict  # Masked credentials
    is_readonly: bool
    created_at: str
    updated_at: str

    model_config = ConfigDict(from_attributes=True)


# --- Endpoints ---


@router.post("", status_code=status.HTTP_201_CREATED)
async def create_storage_config(
    data: StorageConfigCreate,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
):
    """Create a new storage configuration.

    Creates a storage config for the authenticated user.
    Credentials are encrypted before storage.

    Args:
        data: Storage config details
        current_user: Authenticated user
        db: Database session

    Returns:
        Created storage config (credentials masked)
    """
    service = StorageConfigService(db)

    try:
        config = await service.create(
            user_uuid=current_user.uuid,
            provider_type=data.provider_type,
            name=data.name,
            base_path=data.base_path,
            credentials=data.credentials,
            is_readonly=data.is_readonly,
        )
    except ValueError as e:
        raise BusinessException(message=str(e), status_code=400, error_code="INVALID_PROVIDER_TYPE")

    return success_response(
        data={
            "id": config.id,
            "providerType": config.provider_type,
            "name": config.name,
            "basePath": config.base_path,
            "credentials": service.mask_credentials(config),
            "isReadonly": config.is_readonly,
            "createdAt": config.created_at.isoformat() + "Z",
            "updatedAt": config.updated_at.isoformat() + "Z",
        },
        message="存储配置创建成功",
    )


@router.get("")
async def list_storage_configs(
    provider_type: Optional[str] = None,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
):
    """List all storage configurations for the user.

    Args:
        provider_type: Optional filter by provider type
        current_user: Authenticated user
        db: Database session

    Returns:
        List of storage configs (credentials masked)
    """
    service = StorageConfigService(db)
    configs = await service.get_user_configs(user_uuid=current_user.uuid, provider_type=provider_type)

    return success_response(
        data=[
            {
                "id": c.id,
                "providerType": c.provider_type,
                "name": c.name,
                "basePath": c.base_path,
                "credentials": service.mask_credentials(c),
                "isReadonly": c.is_readonly,
                "createdAt": c.created_at.isoformat() + "Z",
                "updatedAt": c.updated_at.isoformat() + "Z",
            }
            for c in configs
        ]
    )


@router.get("/{config_id}")
async def get_storage_config(
    config_id: int,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
):
    """Get a specific storage configuration.

    Args:
        config_id: Storage config ID
        current_user: Authenticated user
        db: Database session

    Returns:
        Storage config (credentials masked)
    """
    service = StorageConfigService(db)
    config = await service.get_by_id(config_id, current_user.id)

    if not config:
        raise BusinessException(message="存储配置不存在或无权访问", status_code=404, error_code="CONFIG_NOT_FOUND")

    return success_response(
        data={
            "id": config.id,
            "providerType": config.provider_type,
            "name": config.name,
            "basePath": config.base_path,
            "credentials": service.mask_credentials(config),
            "isReadonly": config.is_readonly,
            "createdAt": config.created_at.isoformat() + "Z",
            "updatedAt": config.updated_at.isoformat() + "Z",
        }
    )


@router.patch("/{config_id}")
async def update_storage_config(
    config_id: int,
    data: StorageConfigUpdate,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
):
    """Update a storage configuration.

    Args:
        config_id: Storage config ID
        data: Fields to update
        current_user: Authenticated user
        db: Database session

    Returns:
        Updated storage config (credentials masked)
    """
    service = StorageConfigService(db)
    config = await service.update(
        config_id=config_id,
        user_uuid=current_user.uuid,
        name=data.name,
        base_path=data.base_path,
        credentials=data.credentials,
        is_readonly=data.is_readonly,
    )

    if not config:
        raise BusinessException(message="存储配置不存在或无权访问", status_code=404, error_code="CONFIG_NOT_FOUND")

    return success_response(
        data={
            "id": config.id,
            "providerType": config.provider_type,
            "name": config.name,
            "basePath": config.base_path,
            "credentials": service.mask_credentials(config),
            "isReadonly": config.is_readonly,
            "createdAt": config.created_at.isoformat() + "Z",
            "updatedAt": config.updated_at.isoformat() + "Z",
        },
        message="存储配置更新成功",
    )


@router.delete("/{config_id}", status_code=status.HTTP_200_OK)
async def delete_storage_config(
    config_id: int,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
):
    """Delete a storage configuration.

    Note: Cannot delete if attachments still reference this config.

    Args:
        config_id: Storage config ID
        current_user: Authenticated user
        db: Database session

    Returns:
        Success message
    """
    service = StorageConfigService(db)

    try:
        deleted = await service.delete(config_id, current_user.id)
    except Exception as e:
        if "foreign key" in str(e).lower():
            raise BusinessException(
                message="无法删除：仍有文件使用此存储配置", status_code=400, error_code="CONFIG_IN_USE"
            )
        raise

    if not deleted:
        raise BusinessException(message="存储配置不存在或无权访问", status_code=404, error_code="CONFIG_NOT_FOUND")

    return success_response(data=None, message="存储配置删除成功")


@router.get("/providers/list")
async def list_providers():
    """List available storage provider types.

    Returns:
        List of supported provider types with descriptions
    """
    return success_response(
        data=[
            {"type": ProviderType.LOCAL_UPLOADS.value, "name": "本地存储", "description": "服务器本地文件系统存储"},
            {
                "type": ProviderType.S3_COMPATIBLE.value,
                "name": "S3 兼容存储",
                "description": "支持 AWS S3、MinIO 等 S3 兼容的对象存储",
            },
            {
                "type": ProviderType.WEBDAV.value,
                "name": "WebDAV",
                "description": "支持群晖 NAS、NextCloud 等 WebDAV 协议存储",
            },
        ]
    )
