# GenUI 响应式特性设计决策

> 创建时间: 2026-01-23
> 状态: 已批准

## 一、背景

GenUI SDK 提供了 DataContext 响应式绑定和 DataModelUpdate 增量更新等高级特性。
本文档明确这些特性的正确使用场景，避免过度工程化。

## 二、核心原则

### DataContext 响应式绑定的真正价值

| 价值 | 描述 |
|------|------|
| 后端主动推送 | 后端可以向已渲染的组件推送数据更新 |
| 增量更新 | 只更新变化的字段，避免全量重绘 |
| 多步交互 | 在同一个 Surface 内完成多步操作 |

### 不应该使用响应式的场景

| 反模式 | 原因 |
|--------|------|
| 一次性收据 | 操作完成即结束，不需要后续更新 |
| 通过对话修改组件数据 | 浪费 AI Token，用户体验差 |
| 所有组件都用响应式 | 增加复杂度，无实际收益 |

## 三、场景分类

### ✅ 需要 DataContext 响应式绑定

| 预算模拟器 | `BudgetSimulatorCard` (未来) | 用户调整参数 → 后端计算 → 推送结果 |
| 购买评估 | `AffordabilityCard` (未来) | 输入金额 → 后端评估 → 推送结论 |
| 实时协作 | 共享空间编辑 (未来) | 多用户编辑 → 后端同步 → 推送更新 |

### ❌ 保持简单静态展示

| 场景 | 组件 | 原因 |
|------|------|------|
| 记账收据 | `TransactionCard` | 一次性确认，用户即走 |
| 批量记账结果 | `TransactionGroupReceipt` | 展示结果，不会修改 |
| 转账完成收据 | `TransferReceipt` | 展示完成状态 |
| 转账向导 | `TransferWizard` | 静态数据展示 + 一次性确认 |
| 预算状态查询 | `BudgetStatusCard` | 静态信息展示 |
| 消费分析图表 | `BudgetAnalysisCard` | 历史数据，不会变化 |
| 现金流预测图 | `CashFlowForecastChart` | 计算完成后展示 |

## 四、ReactiveTransferWizard 设计

### 组件职责

ReactiveTransferWizard 是一个多步转账向导，支持：
1. 金额输入（可编辑）
2. 源账户选择
3. 目标账户选择
4. 确认转账

### 响应式字段

| DataPath | 类型 | 来源 | 描述 |
|----------|------|------|------|
| `/amount` | double | 初始数据 | 转账金额 |
| `/currency` | string | 初始数据 | 货币代码 |
| `/preselectedSourceId` | string | 初始数据 | 预选源账户 |
| `/preselectedTargetId` | string | 初始数据 | 预选目标账户 |
| `/source_balance` | double | 后端推送 | 源账户余额 |
| `/balance_warning` | string | 后端推送 | 余额警告信息 |
| `/converted_amount` | double | 后端推送 | 汇率换算金额 |
| `/amount_error` | string | 后端推送 | 金额错误信息 |

### 事件交互

| dispatchEvent | 触发时机 | 后端响应 |
|---------------|----------|----------|
| `account_selected` | 用户选择账户 | 校验余额，推送 balance_warning |
| `amount_changed` | 用户修改金额 | 校验是否超出余额 |
| `transfer_confirmed` | 用户确认转账 | 调用 execute_transfer |

### 后端推送流程

```
用户选择源账户
    ↓
dispatchEvent({ name: 'account_selected', source_id: 'xxx' })
    ↓
后端接收事件，查询账户余额
    ↓
后端发送 DataModelUpdate:
  - path: /source_balance, value: 10230.50
  - path: /balance_warning, value: "转账后余额较低" (如果需要)
    ↓
前端 ValueNotifier 自动更新
    ↓
UI 显示余额和警告
```

## 五、删除的不必要功能

| 功能 | 原因 |
|------|------|
| `ReactiveTransactionCard` | 记账是一次性操作，不需要响应式 |
| `update_transaction` Tool | 修改交易应重新记录，不应用 AI 处理 |
| Transaction 的 `_intent: update` | 不存在需要增量更新交易的场景 |

## 六、未来扩展

### BudgetSimulatorCard（预算模拟器）

```
用户调整预算滑块
    ↓
dispatchEvent({ name: 'budget_changed', amount: 1500 })
    ↓
后端计算历史数据，预测超支概率
    ↓
DataModelUpdate:
  - path: /overspend_probability, value: 72
  - path: /daily_allowance, value: 50
  - path: /recommendation, value: "建议设为1800"
```

### AffordabilityCard（购买评估器）

```
用户输入购买金额
    ↓
dispatchEvent({ name: 'amount_entered', amount: 10000 })
    ↓
后端计算现金流影响
    ↓
DataModelUpdate:
  - path: /post_purchase_balance, value: 7730
  - path: /assessment, value: "可购买但较紧张"
  - path: /warning, value: "购买后月末余额较低"
```

## 七、实现检查清单

### 基础设施

- [x] SurfaceTracker 跟踪活跃 Surface
- [x] DataModelUpdate 协议支持
- [ ] dispatchEvent 到后端的路由
- [ ] 后端事件处理器注册机制
- [ ] 寻找更有意义的流式更新场景 (如 BudgetSimulator)
