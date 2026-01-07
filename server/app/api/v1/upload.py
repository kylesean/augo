"""File upload API endpoints.

提供 RESTful 文件上传接口:
- POST /api/files/upload - 单文件/多文件上传
- GET /api/files/view/{id} - 查看/下载文件
- DELETE /api/files/{id} - 删除文件
"""

from typing import List, Optional

from fastapi import APIRouter, Depends, File, Query, UploadFile, status
from fastapi.responses import FileResponse, JSONResponse
from pydantic import BaseModel
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.database import get_session
from app.core.dependencies import get_current_user
from app.core.exceptions import BusinessException
from app.core.logging import logger
from app.core.responses import success_response
from app.models.user import User
from app.services.upload_service import (
    ALLOWED_EXTENSIONS,
    DOCUMENT_EXTENSIONS,
    IMAGE_EXTENSIONS,
    UploadService,
)

router = APIRouter(prefix="/files", tags=["files"])


# =============================================================================
# 响应模型
# =============================================================================


class UploadResultItem(BaseModel):
    """单个上传结果"""

    id: str  # UUID
    attachmentId: str  # UUID
    originalName: str
    filename: str
    fileKey: str
    uri: str
    size: int
    mimeType: str
    hash: str
    compressed: bool
    threadId: Optional[str] = None


class UploadFailureItem(BaseModel):
    """上传失败项"""

    filename: str
    error: str
    errorCode: str


class UploadSummary(BaseModel):
    """上传汇总"""

    total: int
    successfulCount: int
    failedCount: int


class UploadResponse(BaseModel):
    """上传响应"""

    summary: UploadSummary
    uploads: List[UploadResultItem]
    failures: List[UploadFailureItem]


# =============================================================================
# 上传端点
# =============================================================================


@router.post("/upload", status_code=status.HTTP_200_OK)
async def upload_files(
    files: List[UploadFile] = File(
        ...,
        alias="files[]",
        description="要上传的文件列表。支持的格式: 图片(jpg/png/gif/webp等), 文档(pdf/doc/docx/xls/xlsx/ppt/pptx/txt/md等)",
    ),
    compress: bool = Query(default=True, description="是否压缩图片（仅对 jpg/jpeg/png/webp 有效）"),
    thread_id: Optional[str] = Query(
        default=None, alias="threadId", description="关联的会话 ID（用于 LangGraph 对话）"
    ),
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
) -> JSONResponse:
    """上传一个或多个文件。

    支持并发上传多个文件，每个文件独立处理。

    **支持的文件类型:**

    - **图片**: jpg, jpeg, png, gif, webp, bmp, ico, svg
    - **文档**: pdf, doc, docx, xls, xlsx, ppt, pptx, txt, md, csv, json, xml, html, rtf, odt, ods, odp

    **请求示例:**

    ```
    POST /api/files/upload
    Content-Type: multipart/form-data

    files[]: (binary)
    files[]: (binary)
    compress: true
    threadId: conv_xxx
    ```

    **响应示例:**

    ```json
    {
        "summary": {
            "total": 2,
            "successfulCount": 2,
            "failedCount": 0
        },
        "uploads": [
            {
                "id": 1,
                "attachmentId": 1,
                "originalName": "photo.jpg",
                "filename": "photo.jpg",
                "fileKey": "2024/12/05/up_xxx_yyy.jpg",
                "uri": "http://localhost:8000/api/files/view/1",
                "size": 102400,
                "mimeType": "image/jpeg",
                "hash": "sha256...",
                "compressed": true
            }
        ],
        "failures": []
    }
    ```

    Args:
        files: 文件列表 (multipart/form-data, 字段名: files[])
        compress: 是否压缩图片
        thread_id: 会话 ID
        current_user: 当前认证用户
        db: 数据库会话

    Returns:
        包含上传结果的 JSON 响应

    Raises:
        400: 所有文件上传失败
        401: 未认证
        413: 文件过大
    """
    # 校验文件数量
    if not files:
        raise BusinessException(
            message="请选择至少一个文件",
            status_code=400,
            error_code="NO_FILES",
        )

    if len(files) > 20:
        raise BusinessException(
            message="单次最多上传 20 个文件",
            status_code=400,
            error_code="TOO_MANY_FILES",
        )

    # 批量上传：先处理所有文件，再统一写入数据库
    upload_service = UploadService(db)
    successful, failed = await upload_service.upload_files(
        files=files,
        user_uuid=current_user.uuid,
        compress=compress,
        thread_id=thread_id,
    )

    # 检查是否全部失败
    if not successful and failed:
        raise BusinessException(
            message="所有文件上传失败",
            status_code=400,
            error_code="UPLOAD_ALL_FAILED",
        )

    return success_response(
        data={
            "summary": {
                "total": len(files),
                "successfulCount": len(successful),
                "failedCount": len(failed),
            },
            "uploads": successful,
            "failures": failed,
        },
        message="上传完成",
    )


# =============================================================================
# 查看/下载端点
# =============================================================================


@router.get("/view/{attachment_id}", response_class=FileResponse)
async def view_attachment(
    attachment_id: str,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
) -> FileResponse:
    """查看或下载文件。

    根据 MIME 类型返回文件:
    - 图片/PDF: 浏览器内联显示
    - 其他文件: 作为附件下载

    Args:
        attachment_id: 附件 ID
        current_user: 当前认证用户
        db: 数据库会话

    Returns:
        文件内容

    Raises:
        404: 文件不存在或无权访问
    """
    upload_service = UploadService(db)

    try:
        file_path, attachment = await upload_service.get_file_path(
            attachment_id=attachment_id,
            user_uuid=current_user.uuid,
        )

        # 确定 Content-Disposition
        mime_type = attachment.mime_type or "application/octet-stream"
        if mime_type.startswith("image/") or mime_type == "application/pdf":
            disposition = "inline"
        else:
            disposition = "attachment"

        # 对非 ASCII 文件名进行 URL 编码 (RFC 5987)
        from urllib.parse import quote

        filename = attachment.filename

        # 创建 ASCII 安全的文件名用于兼容性
        try:
            filename.encode("ascii")
            # 文件名是纯 ASCII，直接使用
            content_disposition = f'{disposition}; filename="{filename}"'
        except UnicodeEncodeError:
            # 文件名包含非 ASCII 字符，使用 RFC 5987 编码
            encoded_filename = quote(filename)
            content_disposition = f"{disposition}; filename*=UTF-8''{encoded_filename}"

        return FileResponse(
            path=file_path,
            filename=filename,
            media_type=mime_type,
            headers={"Content-Disposition": content_disposition},
        )

    except BusinessException:
        raise
    except Exception as e:
        logger.error(
            "file_view_error",
            attachment_id=attachment_id,
            error=str(e),
            error_type=type(e).__name__,
        )
        raise BusinessException(
            message="文件访问失败",
            status_code=500,
            error_code="FILE_ACCESS_ERROR",
        )


# =============================================================================
# 删除端点
# =============================================================================


@router.delete("/{attachment_id}", status_code=status.HTTP_200_OK)
async def delete_file(
    attachment_id: str,
    current_user: User = Depends(get_current_user),
    db: AsyncSession = Depends(get_session),
) -> JSONResponse:
    """删除文件。

    删除物理文件和数据库记录。

    Args:
        attachment_id: 附件 ID
        current_user: 当前认证用户
        db: 数据库会话

    Returns:
        成功响应

    Raises:
        404: 文件不存在或无权访问
    """
    upload_service = UploadService(db)

    try:
        await upload_service.delete_file(
            attachment_id=attachment_id,
            user_uuid=current_user.uuid,
        )

        return success_response(
            data=None,
            message="文件删除成功",
        )

    except BusinessException:
        raise
    except Exception:
        raise BusinessException(
            message="文件删除失败",
            status_code=500,
            error_code="FILE_DELETE_ERROR",
        )


# =============================================================================
# 支持的文件类型信息
# =============================================================================


@router.get("/supported-types")
async def get_supported_types() -> JSONResponse:
    """获取支持的文件类型列表。

    Returns:
        支持的文件扩展名和 MIME 类型
    """
    return success_response(
        data={
            "imageExtensions": sorted(IMAGE_EXTENSIONS),
            "documentExtensions": sorted(DOCUMENT_EXTENSIONS),
            "allExtensions": sorted(ALLOWED_EXTENSIONS),
        },
        message="支持的文件类型",
    )
