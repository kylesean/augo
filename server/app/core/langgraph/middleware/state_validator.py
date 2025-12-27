"""State Validator

防御性状态校验器，在图执行前校验客户端提交的状态突变。
实现 "Trust, but Verify" 原则。
"""

from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional

from app.core.logging import logger
from app.schemas.client_state import ClientStateMutation


@dataclass
class ValidationResult:
    """校验结果"""

    valid: bool
    errors: List[str] = field(default_factory=list)

    def __bool__(self) -> bool:
        """Return True if the validation is successful, False otherwise."""
        return self.valid


class StateValidator:
    """状态校验器

    校验客户端提交的 ClientStateMutation 是否合法。
    校验失败时返回 ValidationResult，让调用方决定降级策略。
    """

    def validate(self, client_state: Optional[ClientStateMutation]) -> ValidationResult:
        """校验客户端状态突变"""
        if client_state is None:
            return ValidationResult(valid=True)

        errors = []

        # direct_execute 模式校验
        if client_state.ui_mode == "direct_execute":
            if not client_state.tool_name:
                errors.append("ui_mode=direct_execute requires tool_name")
            if not client_state.tool_params:
                errors.append("ui_mode=direct_execute requires tool_params")
            else:
                # 校验工具参数
                params_result = self._validate_tool_params(client_state.tool_name, client_state.tool_params)
                errors.extend(params_result.errors)

        if errors:
            logger.warning(
                "client_state_validation_failed",
                errors=errors,
                ui_mode=client_state.ui_mode,
                tool_name=client_state.tool_name,
            )
            return ValidationResult(valid=False, errors=errors)

        logger.debug(
            "client_state_validation_passed",
            ui_mode=client_state.ui_mode,
            tool_name=client_state.tool_name,
        )
        return ValidationResult(valid=True)

    def _validate_tool_params(self, tool_name: Optional[str], params: Dict[str, Any]) -> ValidationResult:
        """根据工具名校验参数

        可扩展：针对不同工具实施不同的校验规则。
        """
        errors = []

        if tool_name == "execute_transfer":
            # 转账必需字段校验
            if not params.get("source_account_id"):
                errors.append("Missing source_account_id")
            if not params.get("target_account_id"):
                errors.append("Missing target_account_id")
            if params.get("source_account_id") == params.get("target_account_id"):
                errors.append("source_account_id cannot equal target_account_id")
            amount = params.get("amount")
            if not amount or (isinstance(amount, (int, float)) and amount <= 0):
                errors.append("Amount must be greater than 0")

        # 其他工具的校验规则可在此扩展

        return ValidationResult(valid=len(errors) == 0, errors=errors)


# 全局单例
state_validator = StateValidator()
