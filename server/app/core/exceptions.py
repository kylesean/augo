"""Custom exception classes for the application.

This module provides a comprehensive exception hierarchy for handling
various error scenarios in the application.
"""

from typing import Any, Dict, Optional


class ErrorCode:
    """Error code constants"""

    # Success
    SUCCESS = "SUCCESS"

    # Server errors (500-599)
    SERVER_ERROR = "SERVER_ERROR"
    SYSTEM_INVALID = "SYSTEM_INVALID"
    INTERNAL_ERROR = "INTERNAL_ERROR"

    # Validation errors (999)
    FROM_PARAMS_VALIDATOR_FAILED = "FROM_PARAMS_VALIDATOR_FAILED"
    VALIDATION_ERROR = "VALIDATION_ERROR"

    # Authentication errors (1000-1012)
    AUTHENTICATE_FAILED = "AUTHENTICATE_FAILED"
    EMAIL_WRONG = "EMAIL_WRONG"
    PHONE_NUMBER_WRONG = "PHONE_NUMBER_WRONG"
    PHONE_NUMBER_REGISTERED = "PHONE_NUMBER_REGISTERED"
    EMAIL_REGISTERED = "EMAIL_REGISTERED"
    SEND_CODE_FAILED = "SEND_CODE_FAILED"
    CODE_EXPIRED = "CODE_EXPIRED"
    CODE_SEND_TOO_FREQUENTLY = "CODE_SEND_TOO_FREQUENTLY"
    UNSUPPORTED_CODE_TYPE = "UNSUPPORTED_CODE_TYPE"
    USER_NOT_MATCH_PASSWORD = "USER_NOT_MATCH_PASSWORD"
    USER_NOT_EXIST = "USER_NOT_EXIST"
    NO_PREFERENCES_PARAMS = "NO_PREFERENCES_PARAMS"
    INVALID_CLIENT_TIMEZONE = "INVALID_CLIENT_TIMEZONE"

    # Transaction errors (3000-3018)
    TRANSACTION_COMMENT_NULL = "TRANSACTION_COMMENT_NULL"
    INVALID_PARENT_COMMENT_ID = "INVALID_PARENT_COMMENT_ID"
    STORE_COMMENT_FAILED = "STORE_COMMENT_FAILED"
    DELETE_COMMENT_FAILED = "DELETE_COMMENT_FAILED"
    TRANSACTION_NOT_EXISTS = "TRANSACTION_NOT_EXISTS"

    # Shared space errors
    SHARED_SPACE_NOT_EXISTS_OR_NO_ACCESS = "SHARED_SPACE_NOT_EXISTS_OR_NO_ACCESS"
    NO_PERMISSION_TO_INVITE_MEMBERS = "NO_PERMISSION_TO_INVITE_MEMBERS"
    CANNOT_INVITE_YOURSELF = "CANNOT_INVITE_YOURSELF"
    INVITATION_SENT = "INVITATION_SENT"
    ALREADY_MEMBER_OR_HAS_BEEN_INVITED = "ALREADY_MEMBER_OR_HAS_BEEN_INVITED"
    INVALID_ACTION = "INVALID_ACTION"
    INVITATION_NOT_EXISTS = "INVITATION_NOT_EXISTS"
    ONLY_OWNER_CAN_DO = "ONLY_OWNER_CAN_DO"
    OWNER_CANNOT_BE_REMOVED = "OWNER_CANNOT_BE_REMOVED"
    MEMBER_NOT_EXIST = "MEMBER_NOT_EXIST"
    NOT_MEMBER_IN_THIS_SPACE = "NOT_MEMBER_IN_THIS_SPACE"
    OWNER_CANNOT_LEAVE_DIRECTLY = "OWNER_CANNOT_LEAVE_DIRECTLY"
    INVALID_INVITATION_CODE = "INVALID_INVITATION_CODE"
    INVITATION_CODE_EXPIRED_OR_LIMITED = "INVITATION_CODE_EXPIRED_OR_LIMITED"
    TRANSACTION_ALREADY_IN_SPACE = "TRANSACTION_ALREADY_IN_SPACE"

    # Recurring transaction errors (3100-3101)
    INVALID_RECURRENCE_RULE = "INVALID_RECURRENCE_RULE"
    RECURRENCE_RULE_NOT_FOUND = "RECURRENCE_RULE_NOT_FOUND"

    # File upload errors (4001-4017)
    NO_FILE_UPLOADED = "NO_FILE_UPLOADED"
    INVALID_FILE_UPLOADED = "INVALID_FILE_UPLOADED"
    FILE_TOO_LARGE = "FILE_TOO_LARGE"
    INVALID_FILE_TYPE = "INVALID_FILE_TYPE"
    INVALID_MIME_TYPE = "INVALID_MIME_TYPE"
    INVALID_IMAGE_CONTENT = "INVALID_IMAGE_CONTENT"
    IMAGE_TOO_WIDE = "IMAGE_TOO_WIDE"
    IMAGE_TOO_HIGH = "IMAGE_TOO_HIGH"
    TOO_MANY_FILES = "TOO_MANY_FILES"
    TOTAL_SIZE_TOO_LARGE = "TOTAL_SIZE_TOO_LARGE"
    FILE_READ_ERROR = "FILE_READ_ERROR"
    FILESYSTEM_ERROR = "FILESYSTEM_ERROR"
    UPLOAD_VERIFICATION_FAILED = "UPLOAD_VERIFICATION_FAILED"
    UPLOAD_ALL_FAILED = "UPLOAD_ALL_FAILED"
    INVALID_IMAGE_URLS = "INVALID_IMAGE_URLS"
    FILE_NOT_FOUND = "FILE_NOT_FOUND"
    IMAGE_COMPRESSION_FAILED = "IMAGE_COMPRESSION_FAILED"

    # AI/LLM errors (9000-9004)
    AI_CONTEXT_LIMIT_EXCEEDED = "AI_CONTEXT_LIMIT_EXCEEDED"
    CONVERSATION_ID_INVALID = "CONVERSATION_ID_INVALID"
    CONVERSATION_ID_NOT_OWNER = "CONVERSATION_ID_NOT_OWNER"
    TOKENS_LIMITED = "TOKENS_LIMITED"
    NO_USER_MESSAGE = "NO_USER_MESSAGE"

    # Generic errors
    NOT_FOUND = "NOT_FOUND"
    PERMISSION_DENIED = "PERMISSION_DENIED"
    AUTH_FAILED = "AUTH_FAILED"


# ============================================================================
# Exception Classes
# ============================================================================


class AppException(Exception):
    """应用基础异常类

    所有自定义异常的基类，提供统一的错误处理接口。

    Attributes:
        message: 错误消息
        status_code: HTTP 状态码
        error_code: 错误代码（用于客户端识别错误类型）
        details: 额外的错误详情（可选）
    """

    def __init__(
        self,
        message: str,
        status_code: int = 500,
        error_code: str = ErrorCode.INTERNAL_ERROR,
        details: Optional[Dict[str, Any]] = None,
    ):
        self.message = message
        self.status_code = status_code
        self.error_code = error_code
        self.details = details or {}
        super().__init__(message)

    def to_dict(self) -> Dict[str, Any]:
        """Convert exception to dictionary for JSON response."""
        result = {
            "code": self.error_code,
            "message": self.message,
        }
        if self.details:
            result["details"] = self.details
        return result


class AuthenticationError(AppException):
    """认证错误

    当用户身份验证失败时抛出，例如：
    - 无效的凭据
    - 过期的 token
    - 缺少认证信息
    """

    def __init__(
        self,
        message: str = "Authentication failed",
        error_code: str = ErrorCode.AUTH_FAILED,
        details: Optional[Dict[str, Any]] = None,
    ):
        super().__init__(message, status_code=401, error_code=error_code, details=details)


class AuthorizationError(AppException):
    """授权错误

    当用户没有权限访问资源时抛出。
    """

    def __init__(
        self,
        message: str = "Permission denied",
        error_code: str = ErrorCode.PERMISSION_DENIED,
        details: Optional[Dict[str, Any]] = None,
    ):
        super().__init__(message, status_code=403, error_code=error_code, details=details)


class ValidationError(AppException):
    """验证错误

    当请求数据验证失败时抛出。

    Attributes:
        field_errors: 字段级别的错误信息
    """

    def __init__(
        self,
        message: str,
        field_errors: Optional[Dict[str, str]] = None,
        error_code: str = ErrorCode.VALIDATION_ERROR,
    ):
        details = {"field_errors": field_errors} if field_errors else {}
        super().__init__(message, status_code=422, error_code=error_code, details=details)
        self.field_errors = field_errors or {}


class NotFoundError(AppException):
    """资源未找到错误

    当请求的资源不存在时抛出。
    """

    def __init__(
        self,
        resource: str,
        error_code: str = ErrorCode.NOT_FOUND,
        details: Optional[Dict[str, Any]] = None,
    ):
        message = f"{resource} not found"
        super().__init__(message, status_code=404, error_code=error_code, details=details)


class BusinessError(AppException):
    """业务逻辑错误

    当业务规则验证失败时抛出，例如：
    - 重复注册
    - 余额不足
    - 状态不允许的操作
    """

    def __init__(
        self,
        message: str,
        error_code: str,
        status_code: int = 400,
        details: Optional[Dict[str, Any]] = None,
    ):
        super().__init__(message, status_code=status_code, error_code=error_code, details=details)


class FileUploadError(AppException):
    """文件上传错误

    当文件上传过程中发生错误时抛出。
    """

    def __init__(
        self,
        message: str,
        error_code: str = ErrorCode.INVALID_FILE_UPLOADED,
        details: Optional[Dict[str, Any]] = None,
    ):
        super().__init__(message, status_code=400, error_code=error_code, details=details)


class AIServiceError(AppException):
    """AI 服务错误

    当 AI/LLM 服务调用失败时抛出。
    """

    def __init__(
        self,
        message: str,
        error_code: str = ErrorCode.SERVER_ERROR,
        details: Optional[Dict[str, Any]] = None,
    ):
        super().__init__(message, status_code=500, error_code=error_code, details=details)


class DatabaseError(AppException):
    """数据库错误

    当数据库操作失败时抛出。
    """

    def __init__(
        self,
        message: str,
        error_code: str = ErrorCode.SERVER_ERROR,
        details: Optional[Dict[str, Any]] = None,
    ):
        super().__init__(message, status_code=500, error_code=error_code, details=details)


# ============================================================================
# Aliases for Compatibility
# ============================================================================

BusinessException = AppException  # Backward compatibility alias
