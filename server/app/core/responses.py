"""Unified response envelope for all API endpoints.

This module provides a standardized response format that maintains compatibility
with existing client applications expecting {code, message, data} structure.

Design principles:
1. All responses use the same envelope: {code, message, data}
2. HTTP status codes indicate request/system-level issues (4xx/5xx)
3. Business logic success/failure is indicated by the 'code' field
4. code=0 means success, non-zero means business error
"""

from typing import Any, Dict, Generic, Optional, TypeVar

from fastapi.encoders import jsonable_encoder
from fastapi.responses import JSONResponse
from pydantic import BaseModel, ConfigDict

T = TypeVar("T")


class ResponseEnvelope(BaseModel, Generic[T]):
    """Generic response envelope for type-safe API responses.

    This model is used for OpenAPI documentation and type hints.
    It ensures all responses follow the same structure.

    Attributes:
        code: Business status code (0 = success, non-zero = error)
        message: Human-readable message describing the result
        data: Response payload (only present on success)
    """

    code: int
    message: str
    data: Optional[T] = None

    model_config = ConfigDict(
        json_schema_extra={
            "example": {
                "code": 0,
                "message": "Success",
                "data": {"id": 1, "name": "example"},
            }
        }
    )


def success_response(
    data: Any = None,
    message: str = "Success",
    http_status: int = 200,
) -> JSONResponse:
    """Create a successful response with code=0.

    Args:
        data: Response data (will be JSON-encoded)
        message: Success message
        http_status: HTTP status code (default: 200)

    Returns:
        JSONResponse with standardized envelope

    Example:
        >>> return success_response(data={"user_uuid": 123})
        # Returns: {"code": 0, "message": "Success", "data": {"user_uuid": 123}}
    """
    body: Dict[str, Any] = {
        "code": 0,
        "message": message,
    }

    if data is not None:
        body["data"] = jsonable_encoder(data)

    return JSONResponse(status_code=http_status, content=body)


def error_response(
    code: int,
    message: str,
    data: Any = None,
    http_status: int = 200,
) -> JSONResponse:
    """Create an error response with non-zero code.

    For business logic errors, use http_status=200 and let the client
    check the 'code' field. For request/system errors, use appropriate
    HTTP status codes (4xx/5xx).

    Args:
        code: Business error code (non-zero)
        message: Error message
        data: Optional error details
        http_status: HTTP status code (default: 200 for business errors)

    Returns:
        JSONResponse with standardized envelope

    Example:
        >>> return error_response(code=1001, message="User not found")
        # Returns: {"code": 1001, "message": "User not found"}
    """
    body: Dict[str, Any] = {
        "code": code,
        "message": message,
    }

    if data is not None:
        body["data"] = jsonable_encoder(data)

    return JSONResponse(status_code=http_status, content=body)


def envelope_response(
    *,
    data: Any = None,
    code: int = 0,
    message: str = "Success",
    http_status: int = 200,
) -> JSONResponse:
    """Generic envelope response builder.

    This is a flexible function that can create both success and error responses.
    For most cases, prefer using success_response() or error_response() for clarity.

    Args:
        data: Response data
        code: Business status code (0 = success)
        message: Response message
        http_status: HTTP status code

    Returns:
        JSONResponse with standardized envelope
    """
    if code == 0:
        return success_response(data=data, message=message, http_status=http_status)
    else:
        return error_response(code=code, message=message, data=data, http_status=http_status)


# ============================================================================
# Error Code to Integer Mapping
# ============================================================================

ERROR_CODE_MAP = {
    # Success
    "SUCCESS": 0,
    # Server errors (500-599)
    "SERVER_ERROR": 500,
    "SYSTEM_INVALID": 501,
    "INTERNAL_ERROR": 500,
    # Validation errors (999)
    "FROM_PARAMS_VALIDATOR_FAILED": 999,
    "VALIDATION_ERROR": 999,
    # Authentication errors (1000-1012)
    "AUTHENTICATE_FAILED": 1000,
    "EMAIL_WRONG": 1001,
    "PHONE_NUMBER_WRONG": 1002,
    "PHONE_NUMBER_REGISTERED": 1003,
    "EMAIL_REGISTERED": 1004,
    "SEND_CODE_FAILED": 1005,
    "CODE_EXPIRED": 1006,
    "CODE_SEND_TOO_FREQUENTLY": 1007,
    "UNSUPPORTED_CODE_TYPE": 1008,
    "USER_NOT_MATCH_PASSWORD": 1009,
    "USER_NOT_EXIST": 1010,
    "NO_PREFERENCES_PARAMS": 1011,
    "INVALID_CLIENT_TIMEZONE": 1012,
    # Transaction errors (3000-3018)
    "TRANSACTION_COMMENT_NULL": 3000,
    "INVALID_PARENT_COMMENT_ID": 3001,
    "STORE_COMMENT_FAILED": 3002,
    "DELETE_COMMENT_FAILED": 3003,
    "TRANSACTION_NOT_EXISTS": 3004,
    # Shared space errors (3100-3118)
    "SHARED_SPACE_NOT_EXISTS_OR_NO_ACCESS": 3100,
    "NO_PERMISSION_TO_INVITE_MEMBERS": 3101,
    "CANNOT_INVITE_YOURSELF": 3102,
    "INVITATION_SENT": 3103,
    "ALREADY_MEMBER_OR_HAS_BEEN_INVITED": 3104,
    "INVALID_ACTION": 3105,
    "INVITATION_NOT_EXISTS": 3106,
    "ONLY_OWNER_CAN_DO": 3107,
    "OWNER_CANNOT_BE_REMOVED": 3108,
    "MEMBER_NOT_EXIST": 3109,
    "NOT_MEMBER_IN_THIS_SPACE": 3110,
    "OWNER_CANNOT_LEAVE_DIRECTLY": 3111,
    "INVALID_INVITATION_CODE": 3112,
    "INVITATION_CODE_EXPIRED_OR_LIMITED": 3113,
    # Recurring transaction errors (3200-3201)
    "INVALID_RECURRENCE_RULE": 3200,
    "RECURRENCE_RULE_NOT_FOUND": 3201,
    # File upload errors (4001-4017)
    "NO_FILE_UPLOADED": 4001,
    "INVALID_FILE_UPLOADED": 4002,
    "FILE_TOO_LARGE": 4003,
    "INVALID_FILE_TYPE": 4004,
    "INVALID_MIME_TYPE": 4005,
    "INVALID_IMAGE_CONTENT": 4006,
    "IMAGE_TOO_WIDE": 4007,
    "IMAGE_TOO_HIGH": 4008,
    "TOO_MANY_FILES": 4009,
    "TOTAL_SIZE_TOO_LARGE": 4010,
    "FILE_READ_ERROR": 4011,
    "FILESYSTEM_ERROR": 4012,
    "UPLOAD_VERIFICATION_FAILED": 4013,
    "UPLOAD_ALL_FAILED": 4014,
    "INVALID_IMAGE_URLS": 4015,
    "FILE_NOT_FOUND": 4016,
    "IMAGE_COMPRESSION_FAILED": 4017,
    # AI/LLM errors (9000-9004)
    "AI_CONTEXT_LIMIT_EXCEEDED": 9000,
    "CONVERSATION_ID_INVALID": 9001,
    "CONVERSATION_ID_NOT_OWNER": 9002,
    "TOKENS_LIMITED": 9003,
    "NO_USER_MESSAGE": 9004,
    # Generic errors
    "NOT_FOUND": 404,
    "PERMISSION_DENIED": 403,
    "AUTH_FAILED": 401,
}


def get_error_code_int(error_code_str: str) -> int:
    """Convert string error code to integer.

    Args:
        error_code_str: String error code (e.g., "USER_NOT_EXIST")

    Returns:
        Integer error code for client compatibility
    """
    return ERROR_CODE_MAP.get(error_code_str, 500)
