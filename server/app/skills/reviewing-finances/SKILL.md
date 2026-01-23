---
name: reviewing-finances
description: >
  Analyzes past financial data: spending breakdown by category, income vs expense
  balance, and financial health scoring. THE skill for understanding where money went
  and current financial status.

  USE WHEN user asks about:
  - 钱都花到哪了, 消费分析, 消费习惯, 各类消费, 本月消费
  - 收支情况, 收支分析, 存了多少钱, 财务健康, 收支平衡, 财务评分

  NOT FOR:
  - 预测未来余额 (下个月还剩多少) → forecasting-finances skill
  - 设置预算金额 (预算多少合适) → planning-budgets skill
  - 查询预算剩余状态 → query_budget_status tool

allowed-tools: "execute search_transactions read_file"
---

# Skill: Reviewing Finances

You help users understand WHERE their money went and HOW HEALTHY their finances are.
This skill focuses on **analyzing the past and present**, not predicting the future.

## Core Principle

This skill answers two fundamental questions:
1. **WHERE did money go?** → Spending breakdown by category
2. **HOW is my financial health?** → Income vs expense balance + health score

## Use Cases

| User Request | Action |
|--------------|--------|
| "钱都花哪了" / "消费分析" | Run analyze_spending.py → Show category breakdown |
| "收支情况" / "存了多少" | Run analyze_cashflow.py → Show income/expense balance |
| "财务健康吗" / "财务评分" | Run analyze_cashflow.py → Show health score with dimensions |
| "本月消费习惯" | Run analyze_spending.py → Analyze patterns and trends |

## Available Scripts

### analyze_spending.py - Spending Breakdown

```bash
uv run python app/skills/reviewing-finances/scripts/analyze_spending.py
```

Analyzes spending patterns and provides category breakdown.

**Optional Parameters** (via stdin JSON):
- `days`: Analysis period, default 90 days
- `category`: Focus on specific category (e.g., "FOOD_DINING")

**Output**:
- `by_category`: Spending by category with percentages
- `top_spenders`: Highest individual expenses
- `trends`: Month-over-month changes

**GenUI Component**: `SpendingBreakdownCard`

### analyze_cashflow.py - Income/Expense + Health Score

```bash
uv run python app/skills/reviewing-finances/scripts/analyze_cashflow.py --days 90
```

Analyzes income vs expense balance and calculates financial health.

**Parameters**:
- `--days`: Analysis period (default: 90)

**Output**:
- `netCashFlow`: Income minus expenses
- `savingsRate`: Percentage of income saved
- `healthScore`: Overall financial health (0-100)
- `healthDimensions`: Breakdown by dimensions (emergency fund, debt ratio, etc.)

**GenUI Component**: `CashFlowCard`

## Workflow

### Spending Analysis Flow
1. Run `analyze_spending.py` directly
2. Present the category breakdown via GenUI
3. Highlight top spending categories and unusual patterns
4. Localize category keys (FOOD_DINING → 餐饮美食)

### Financial Health Flow
1. Run `analyze_cashflow.py` with appropriate period
2. Present CashFlowCard GenUI component
3. Interpret the health score (excellent/good/fair/poor)
4. Explain what each dimension means to the user

## Rules

1. **Focus on PAST & PRESENT**: This skill answers "what happened" not "what will happen"
2. **Category Localization**: Always translate category keys to user's language
3. **Silent Execution**: Never mention scripts, Python, or technical details
4. **No Predictions**: Do NOT forecast future → use forecasting-finances skill
5. **No Budget Setting**: Do NOT recommend budget amounts → use planning-budgets skill
6. **Combine When Appropriate**: If user asks both "消费分析" and "财务健康", run both scripts
