"""验证码管理服务

提供验证码生成、发送、验证和频率限制功能。
"""

import random
import time
from abc import ABC, abstractmethod

from app.core.cache import cache_manager
from app.core.config import settings
from app.core.exceptions import BusinessError, ErrorCode
from app.core.logging import logger


class CodeSenderInterface(ABC):
    """验证码发送器接口"""

    @abstractmethod
    def supports(self, code_type: str) -> bool:
        """检查是否支持指定类型的验证码发送"""
        pass

    @abstractmethod
    async def send(self, account: str, code: str) -> bool:
        """发送验证码"""
        pass


class EmailCodeSender(CodeSenderInterface):
    """邮箱验证码发送器"""

    def supports(self, code_type: str) -> bool:
        """Check if this sender supports the specified code type (email)."""
        return code_type == "email"

    async def send(self, account: str, code: str) -> bool:
        """发送邮箱验证码

        # Integration with actual email service (e.g., SendGrid, AWS SES) should be implemented here
        """
        logger.info(
            "sending_email_verification_code",
            email=account,
            code=code,
            # 生产环境不要记录验证码！
        )

        # TODO: Integration with actual email service (e.g., SendGrid, AWS SES)

        # 开发环境：直接打印验证码
        if settings.DEBUG:
            logger.debug("email_verification_code_debug", email=account, code=code, message="验证码已生成（开发环境）")

        return True


class SMSCodeSender(CodeSenderInterface):
    """短信验证码发送器"""

    def supports(self, code_type: str) -> bool:
        """Check if this sender supports the specified code type (mobile)."""
        return code_type == "mobile"

    async def send(self, account: str, code: str) -> bool:
        """发送短信验证码

        # Integration with actual SMS service (e.g., Twilio, Aliyun) should be implemented here
        """
        logger.info(
            "sending_sms_verification_code",
            mobile=account,
            # 生产环境不要记录验证码！
        )

        # 开发环境：直接打印验证码
        if settings.DEBUG:
            logger.debug("sms_verification_code_debug", mobile=account, code=code, message="验证码已生成（开发环境）")

        return True


class CodeManager:
    """验证码管理器

    负责验证码的生成、存储、验证和频率限制。
    """

    def __init__(self) -> None:
        # 配置
        self.code_length = 6
        self.expire_seconds = 300  # 5分钟
        self.rate_limit_seconds = 60  # 60秒内只能发送一次
        self.redis_code_key_prefix = "verification_code:"
        self.redis_rate_limit_key_prefix = "code_rate_limit:"

        # 注册发送器
        self.senders = [
            EmailCodeSender(),
            SMSCodeSender(),
        ]

    async def send_code(self, code_type: str, account: str) -> bool:
        """发送验证码

        Args:
            code_type: 验证码类型 (email/mobile)
            account: 接收账号

        Returns:
            是否发送成功

        Raises:
            BusinessError: 发送频率过快或不支持的类型
        """
        # 检查发送频率
        if not await self._check_rate_limit(account):
            raise BusinessError(
                message="Verification code sent too frequently, please try again later",
                error_code=ErrorCode.CODE_SEND_TOO_FREQUENTLY,
            )

        # 生成验证码
        code = self._generate_code()

        # 查找对应的发送器
        sender = self._find_sender(code_type)
        if not sender:
            raise BusinessError(
                message=f"Unsupported verification code type: {code_type}",
                error_code=ErrorCode.UNSUPPORTED_CODE_TYPE,
            )

        # 发送验证码
        try:
            success = await sender.send(account, code)

            if success:
                # 存储验证码
                await self._store_code(account, code)
                # 记录发送时间
                await self._record_send_time(account)

                logger.info(
                    "verification_code_sent",
                    type=code_type,
                    account=account,
                )

            return success

        except Exception as e:
            logger.error(
                "verification_code_send_failed",
                type=code_type,
                account=account,
                error=str(e),
            )
            raise BusinessError(
                message="Failed to send verification code",
                error_code=ErrorCode.SEND_CODE_FAILED,
            )

    async def verify_code(self, account: str, code: str) -> bool:
        """验证验证码

        Args:
            account: 账号
            code: 验证码

        Returns:
            验证是否成功
        """
        key = self._get_code_key(account)

        # 从 Redis 获取存储的验证码（不反序列化，因为存的是字符串）
        stored_code = await cache_manager.get(key, deserialize=False)

        # 如果是 bytes，转换为字符串
        if isinstance(stored_code, bytes):
            stored_code = stored_code.decode("utf-8")

        logger.debug(
            "verifying_code",
            account=account,
            key=key,
            has_stored_code=stored_code is not None,
            stored_code=stored_code if settings.DEBUG else "***",
            provided_code=code if settings.DEBUG else "***",
        )

        if not stored_code or stored_code != code:
            logger.warning(
                "verification_code_invalid",
                account=account,
                provided_code=code if settings.DEBUG else "***",
                stored_code=stored_code if settings.DEBUG else "***",
            )
            return False

        # 验证成功后立即删除验证码，防止重复使用
        await cache_manager.delete(key)

        logger.info(
            "verification_code_verified",
            account=account,
        )

        return True

    def _generate_code(self) -> str:
        """生成随机验证码"""
        min_value = 10 ** (self.code_length - 1)
        max_value = 10**self.code_length - 1
        return str(random.randint(min_value, max_value))

    def _find_sender(self, code_type: str) -> CodeSenderInterface | None:
        """根据类型查找对应的发送器"""
        for sender in self.senders:
            if sender.supports(code_type):
                return sender
        return None

    async def _store_code(self, account: str, code: str) -> None:
        """将验证码存入 Redis"""
        key = self._get_code_key(account)
        # 注意：使用 ttl 参数，不是 expire
        await cache_manager.set(key, code, ttl=self.expire_seconds, serialize=False)

    async def _check_rate_limit(self, account: str) -> bool:
        """检查发送频率限制"""
        key = self._get_rate_limit_key(account)
        last_send_time = await cache_manager.get(key)

        if not last_send_time:
            return True

        elapsed = time.time() - float(last_send_time)
        return elapsed >= self.rate_limit_seconds

    async def _record_send_time(self, account: str) -> None:
        """记录验证码发送时间"""
        key = self._get_rate_limit_key(account)
        await cache_manager.set(key, str(time.time()), ttl=self.rate_limit_seconds, serialize=False)

    def _get_code_key(self, account: str) -> str:
        """获取验证码在 Redis 中的存储键"""
        return f"{self.redis_code_key_prefix}{account}"

    def _get_rate_limit_key(self, account: str) -> str:
        """获取频率限制在 Redis 中的存储键"""
        return f"{self.redis_rate_limit_key_prefix}{account}"


# 全局单例
code_manager = CodeManager()
