#!/usr/bin/env python3
"""
GenUI 响应式架构演示测试

本脚本演示新 GenUI 架构的核心能力：
1. DataModelUpdate - 无感更新 UI（不重建整个组件）
2. Surface 复用 - 修改现有 UI 而不是创建新 UI
3. DeleteSurface - 删除不需要的 Surface

对比旧架构：
- 旧：修改金额 -> 重新发送整个 TransactionReceipt -> UI 闪烁/重建
- 新：修改金额 -> 发送 DataModelUpdate(path="/amount") -> 只更新金额部分

运行方式：
    cd server && PYTHONPATH=. uv run python scripts/demo_reactive_genui.py
"""

from __future__ import annotations

import asyncio
import json
import random
import time
from typing import Any

# Colors for terminal output
class Colors:
    HEADER = '\033[95m'
    BLUE = '\033[94m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'


def print_header(text: str) -> None:
    print(f"\n{Colors.HEADER}{Colors.BOLD}{'=' * 60}{Colors.ENDC}")
    print(f"{Colors.HEADER}{Colors.BOLD}{text}{Colors.ENDC}")
    print(f"{Colors.HEADER}{Colors.BOLD}{'=' * 60}{Colors.ENDC}\n")


def print_step(step: int, text: str) -> None:
    print(f"{Colors.BLUE}[Step {step}]{Colors.ENDC} {text}")


def print_success(text: str) -> None:
    print(f"{Colors.GREEN}  ✓ {text}{Colors.ENDC}")


def print_info(text: str) -> None:
    print(f"{Colors.YELLOW}  → {text}{Colors.ENDC}")


def print_json(label: str, data: dict[str, Any]) -> None:
    print(f"{Colors.YELLOW}  {label}:{Colors.ENDC}")
    print(f"    {json.dumps(data, ensure_ascii=False, indent=2).replace(chr(10), chr(10) + '    ')}")


# ============================================================
# Demo 1: DataModelUpdate - 响应式金额更新
# ============================================================

def demo_data_model_update() -> None:
    """演示 DataModelUpdate 消息如何实现无感更新"""
    print_header("Demo 1: DataModelUpdate - 响应式金额更新")
    
    print("场景：用户说'帮我记一笔 100 元的午餐费'")
    print("      -> 系统创建交易，显示 TransactionReceipt")
    print("      -> 用户说'改成 200 元'")
    print()
    
    # 模拟初始 Surface 创建
    print_step(1, "后端创建 TransactionReceipt (旧方式也是这样)")
    
    initial_surface = {
        "surfaceUpdate": {
            "surfaceId": "surface_tx_001",
            "uiDefinition": {
                "rootComponentId": "root_001",
                "components": {
                    "root_001": {
                        "TransactionReceipt": {
                            "transaction_id": 12345,
                            "amount": 100.0,
                            "currency": "CNY",
                            "category_key": "food_dining",
                            "type": "EXPENSE",
                        }
                    }
                }
            }
        }
    }
    print_json("发送 SurfaceUpdate", initial_surface)
    print_success("前端渲染 ReactiveTransactionCard，订阅 /amount 路径")
    print()
    
    # 旧方式 vs 新方式
    print_step(2, "用户说'改成 200 元' - 对比旧/新两种处理方式")
    print()
    
    print(f"  {Colors.RED}【旧方式】重新发送整个组件:{Colors.ENDC}")
    old_way = {
        "surfaceUpdate": {
            "surfaceId": "surface_tx_002",  # 新 Surface ID!
            "uiDefinition": {
                "rootComponentId": "root_002",
                "components": {
                    "root_002": {
                        "TransactionReceipt": {
                            "transaction_id": 12345,
                            "amount": 200.0,  # 只改了这个
                            "currency": "CNY",
                            "category_key": "food_dining",
                            "type": "EXPENSE",
                        }
                    }
                }
            }
        }
    }
    print_json("旧方式发送 SurfaceUpdate", old_way)
    print(f"  {Colors.RED}  ✗ 问题：整个组件重建，UI 闪烁{Colors.ENDC}")
    print(f"  {Colors.RED}  ✗ 问题：旧 Surface 和新 Surface 可能同时存在{Colors.ENDC}")
    print()
    
    print(f"  {Colors.GREEN}【新方式】只发送 DataModelUpdate:{Colors.ENDC}")
    new_way = {
        "dataModelUpdate": {
            "surfaceId": "surface_tx_001",  # 复用原 Surface
            "path": "/amount",
            "value": 200.0
        }
    }
    print_json("新方式发送 DataModelUpdate", new_way)
    print_success("只有金额区域重建，其他部分不变")
    print_success("无闪烁，用户感知不到重建过程")
    print()
    
    print_step(3, "前端处理流程")
    print_info("CustomContentGenerator._handleDataModelUpdate() 接收消息")
    print_info("GenUI DataModel.update('/amount', 200.0) 被调用")
    print_info("订阅了 /amount 的 ValueNotifier 被更新")
    print_info("ValueListenableBuilder 只重建 AmountText Widget")
    print_success("整个过程只有金额文字变化，其他 Widget 状态保持不变")


# ============================================================
# Demo 2: Surface 复用 - _intent: "update"
# ============================================================

def demo_surface_reuse() -> None:
    """演示 Surface 复用机制"""
    print_header("Demo 2: Surface 复用 - _intent: 'update'")
    
    print("场景：用户修改交易的某个属性")
    print("      后端 Tool 返回 _intent='update' 标记")
    print("      系统自动复用现有 Surface 而不是创建新 Surface")
    print()
    
    print_step(1, "后端 Tool 返回带 _intent 标记的数据")
    
    tool_result = {
        "success": True,
        "transaction_id": 12345,
        "amount": 300.0,
        "message": "已将金额修改为 300 元",
        "_intent": "update",  # 关键标记！
    }
    print_json("Tool 返回值", tool_result)
    print_info("_intent='update' 告诉前端：复用现有 Surface，不要创建新的")
    print()
    
    print_step(2, "EventGenerator 处理逻辑 (event_generator.py)")
    print_info("检测到 _intent='update'")
    print_info("调用 SurfaceTracker.find_reusable_surface() 查找现有 Surface")
    print_info("找到 surface_tx_001，发送 DataModelUpdate 而不是 SurfaceUpdate")
    print()
    
    print_step(3, "对比效果")
    print(f"  {Colors.RED}无 _intent 标记:{Colors.ENDC}")
    print(f"    → 创建新 Surface: surface_tx_003")
    print(f"    → 聊天界面出现两个 TransactionReceipt")
    print()
    print(f"  {Colors.GREEN}有 _intent='update':{Colors.ENDC}")
    print(f"    → 复用 surface_tx_001")
    print(f"    → 原 TransactionReceipt 金额无感变化")
    print_success("用户体验：'改成 300' -> 金额直接变成 300，无新卡片出现")


# ============================================================
# Demo 3: DeleteSurface - 删除不需要的 Surface
# ============================================================

def demo_delete_surface() -> None:
    """演示 DeleteSurface 功能"""
    print_header("Demo 3: DeleteSurface - 删除不需要的 Surface")
    
    print("场景：用户取消了某个操作，或者交易被删除")
    print("      后端需要从 UI 中移除对应的组件")
    print()
    
    print_step(1, "用户说'删除这笔交易'")
    print_info("后端执行删除操作，成功")
    print()
    
    print_step(2, "后端发送 DeleteSurface 消息")
    
    delete_msg = {
        "deleteSurface": {
            "surfaceId": "surface_tx_001"
        }
    }
    print_json("发送 DeleteSurface", delete_msg)
    print()
    
    print_step(3, "前端处理")
    print_info("CustomContentGenerator._handleDeleteSurface() 接收消息")
    print_info("GenUiLifecycleManager.handleDeleteSurface() 更新状态")
    print_info("Surface 从 UI 中移除")
    print_success("TransactionReceipt 卡片从聊天界面消失")
    print()
    
    print_step(4, "GenUiLifecycleManager 状态跟踪")
    print_info("surfaceRegistry[surface_tx_001].status = SurfaceStatus.removed")
    print_info("totalSurfacesDeleted++")
    print_success("清晰的生命周期管理")


# ============================================================
# Demo 4: 多字段同时更新
# ============================================================

def demo_multi_field_update() -> None:
    """演示多字段同时更新"""
    print_header("Demo 4: 多字段同时更新")
    
    print("场景：用户说'改成 500 元的交通费'")
    print("      需要同时更新 amount 和 category_key")
    print()
    
    print_step(1, "后端发送多个 DataModelUpdate")
    
    updates = [
        {"dataModelUpdate": {"surfaceId": "surface_tx_001", "path": "/amount", "value": 500.0}},
        {"dataModelUpdate": {"surfaceId": "surface_tx_001", "path": "/category_key", "value": "transport"}},
    ]
    
    for i, update in enumerate(updates, 1):
        print_json(f"消息 {i}", update)
    print()
    
    print_step(2, "前端响应")
    print_info("金额 ValueNotifier 更新 -> AmountText 重建")
    print_info("分类 ValueNotifier 更新 -> 分类图标和文字重建")
    print_success("两个 ValueListenableBuilder 独立重建，其他部分不变")
    print_success("细粒度更新，性能最优")


# ============================================================
# Demo 5: GenUiLifecycleManager 增强功能
# ============================================================

def demo_lifecycle_manager() -> None:
    """演示 GenUiLifecycleManager 的增强功能"""
    print_header("Demo 5: GenUiLifecycleManager 增强功能")
    
    print("新增功能概览：")
    print()
    
    features = [
        ("Surface 状态跟踪", [
            "loading: Surface 创建中",
            "rendered: Widget 渲染完成",
            "updated: 收到 DataModelUpdate",
            "error: 发生错误",
            "removed: 已删除",
        ]),
        ("Session 清理", [
            "clearSession(): 会话结束时清理所有 Surface",
            "自动释放资源，防止内存泄漏",
        ]),
        ("指标跟踪", [
            "totalSurfacesCreated: 创建的 Surface 总数",
            "totalReactiveUpdates: 响应式更新次数",
            "totalSurfacesDeleted: 删除的 Surface 数量",
            "activeSurfaceCount: 当前活跃 Surface 数",
        ]),
        ("查询 API", [
            "getSurfaceInfo(surfaceId): 获取单个 Surface 信息",
            "getSurfacesForMessage(messageId): 获取消息关联的所有 Surface",
        ]),
    ]
    
    for i, (feature, details) in enumerate(features, 1):
        print(f"{Colors.BLUE}{i}. {feature}{Colors.ENDC}")
        for detail in details:
            print(f"   • {detail}")
        print()
    
    print_step(6, "使用示例")
    print("""
    // 检查 Surface 状态
    final info = lifecycleManager.getSurfaceInfo('surface_tx_001');
    if (info?.status == SurfaceStatus.updated) {
      // Surface 刚刚收到了响应式更新
    }
    
    // 获取会话指标
    print('创建: \${lifecycleManager.totalSurfacesCreated}');
    print('更新: \${lifecycleManager.totalReactiveUpdates}');
    print('删除: \${lifecycleManager.totalSurfacesDeleted}');
    
    // 会话结束时清理
    lifecycleManager.clearSession();
    """)


# ============================================================
# Main
# ============================================================

def main() -> None:
    print(f"\n{Colors.BOLD}GenUI 响应式架构演示{Colors.ENDC}")
    print("本演示展示新架构相比旧架构的核心改进\n")
    
    demos = [
        demo_data_model_update,
        demo_surface_reuse,
        demo_delete_surface,
        demo_multi_field_update,
        demo_lifecycle_manager,
    ]
    
    for demo in demos:
        demo()
        print()
        time.sleep(0.5)  # 让输出更易读
    
    print_header("总结：新架构的核心优势")
    
    improvements = [
        ("细粒度更新", "只更新变化的字段，不重建整个组件"),
        ("无感更新", "用户感知不到 UI 重建过程"),
        ("Surface 复用", "修改操作复用现有 Surface"),
        ("生命周期管理", "清晰的状态跟踪和资源清理"),
        ("性能优化", "减少不必要的 Widget 重建"),
        ("代码清晰", "响应式组件使用 ValueListenableBuilder 模式"),
    ]
    
    for name, desc in improvements:
        print(f"  {Colors.GREEN}✓ {name}{Colors.ENDC}: {desc}")
    
    print()
    print(f"{Colors.BOLD}下一步：运行端到端测试{Colors.ENDC}")
    print("  1. 启动后端: cd server && uv run uvicorn app.main:app --reload")
    print("  2. 启动前端: cd client && flutter run")
    print("  3. 对话测试: '帮我记一笔 100 元的午餐费'")
    print("  4. 修改测试: '改成 200 元'")
    print("  5. 观察 UI 是否无感更新")
    print()


if __name__ == "__main__":
    main()
