"""ComponentDetector - 统一的 GenUI 组件类型检测器

职责：
- 从工具执行结果中检测 GenUI 组件类型
- 应用业务级别的组件覆盖规则
- 消除代码中三处重复的检测逻辑

设计模式：
- 静态工具类 + 策略钩子
"""

from typing import Any, cast


class ComponentDetector:
    """数据驱动的 GenUI 组件检测器

    统一组件检测逻辑：
    1. EventGenerator.process_updates_chunk (direct_execute)
    2. EventGenerator.process_updates_chunk (tools)
    3. SimpleLangChainAgent.get_detailed_history

    检测优先级：
    1. componentType - 专用字段（推荐）
    2. _genui_component - 兼容字段
    3. type - 启发式检测（仅当满足命名规则时）
    """

    # 业务级组件覆盖规则
    _BUSINESS_OVERRIDES = {
        # (tool_name, condition_key) -> target_component
        ("create_transaction", "transfer_info"): "TransferReceipt",
        ("execute_transfer", "transfer_info"): "TransferReceipt",
    }

    @staticmethod
    def detect(tool_result: Any) -> str | None:
        """从工具结果中检测组件类型

        Args:
            tool_result: 工具执行返回的结果（通常是 dict）

        Returns:
            组件类型名称，如 "TransactionReceipt"；无法检测时返回 None
        """
        if not isinstance(tool_result, dict):
            return None

        # 优先级 1：专用字段
        component_type = tool_result.get("componentType")
        if component_type:
            return cast(str, component_type)

        # 优先级 2：兼容字段
        component_type = tool_result.get("_genui_component")
        if component_type:
            return cast(str, component_type)

        # 优先级 3：启发式检测 type 字段
        type_value = tool_result.get("type")
        if ComponentDetector._is_valid_component_name(type_value):
            return type_value

        return None

    @staticmethod
    def detect_with_overrides(
        tool_result: Any,
        tool_name: str | None,
    ) -> str | None:
        """检测组件类型并应用业务覆盖规则

        Args:
            tool_result: 工具执行返回的结果
            tool_name: 工具名称

        Returns:
            最终的组件类型名称
        """
        base_component = ComponentDetector.detect(tool_result)

        if not base_component:
            return None

        # 应用业务覆盖规则
        if isinstance(tool_result, dict):
            for (target_tool, condition_key), override_component in ComponentDetector._BUSINESS_OVERRIDES.items():
                if tool_name == target_tool and tool_result.get(condition_key):
                    return override_component

        return base_component

    @staticmethod
    def is_successful_result(tool_result: Any) -> bool:
        """检查工具结果是否成功

        失败的工具调用不应渲染 UI 组件

        Args:
            tool_result: 工具执行返回的结果

        Returns:
            True 如果成功或未指定状态
        """
        if not isinstance(tool_result, dict):
            return True
        return bool(tool_result.get("success", True))

    @staticmethod
    def _is_valid_component_name(value: Any) -> bool:
        """启发式检查是否是有效的组件名称

        规则：
        - 必须是字符串
        - 长度 > 3（避免 "id", "ok" 等短字符串）
        - 不全是大写（避免 "SUCCESS", "TRANSFER" 等状态枚举）
        - 首字母大写（CamelCase 约定）

        Args:
            value: 待检查的值

        Returns:
            True 如果符合组件命名规则
        """
        if not isinstance(value, str):
            return False
        if len(value) <= 3:
            return False
        if value.isupper():
            return False
        if not value[0].isupper():
            return False
        return True
