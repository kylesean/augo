"""Utilities for LangGraph tools."""
from __future__ import annotations

from datetime import date, datetime
from typing import Any

from pydantic import BaseModel


def map_to_genui(data: Any) -> Any:
    """递归转换数据为 GenUI 兼容格式。

    1. Pydantic 模型自动转为字典 (mode='json')，保持原始命名风格（应该是 camelCase）。
    2. 日期对象转为 ISO 字符串。
    """
    # 处理 Pydantic 模型
    if isinstance(data, BaseModel):
        # 保持原始 key (camelCase)
        return data.model_dump(mode="json")

    # 递归处理字典
    if isinstance(data, dict):
        new_dict = {}
        for k, v in data.items():
            # 不再进行 camel_to_snake 转换，保持原样
            new_dict[k] = map_to_genui(v)
        return new_dict

    # 递归处理列表
    elif isinstance(data, list):
        return [map_to_genui(i) for i in data]

    # 处理日期
    elif isinstance(data, (datetime, date)):
        return data.isoformat()

    # 基本类型直接返回
    return data


def genui_response(data: Any, type: str, success: bool = True, message: str | None = None) -> dict[str, Any]:
    """生成统一的扁平化 GenUI 响应字典。

    保持后端原始的 camelCase 命名风格，与 RESTful API 保持一致。
    """
    result = {
        "success": success,
        "type": type,
    }

    if message:
        result["message"] = message

    if success and data is not None:
        formatted_data = map_to_genui(data)
        if isinstance(formatted_data, dict):
            # 扁平化合并到根部
            result.update(formatted_data)
        else:
            result["data"] = formatted_data

    return result
