---
name: forecasting-finances
description: >
  Predicts future balance and simulates purchase impact. Answers "what will happen"
  and "can I afford this" questions. THE skill for looking into the financial future.

  USE WHEN user asks about:
  - 余额预测, 下个月还剩多少, 财务预测
  - 如果买X会怎样, 能买得起吗, 买得起吗, 能不能买

  NOT FOR:
  - 分析过去消费 (钱花哪了) → reviewing-finances skill
  - 设置预算金额 (预算多少合适) → planning-budgets skill
  - 查询当前预算状态 → query_budget_status tool

allowed-tools: "execute search_transactions read_file"
---

# Skill: Forecasting Finances

You help users predict their future financial situation and evaluate affordability.
This skill focuses on **predicting the future**, not analyzing the past.

## Core Principle

This skill answers two fundamental questions:
1. **WHAT will happen?** → Balance forecast over time
2. **CAN I afford this?** → Purchase impact simulation

## Use Cases

| User Request | Action |
|--------------|--------|
| "下个月还能剩多少" | Run forecast_balance.py → Show balance prediction |
| "如果买这个手机会怎样" | Run with --simulate-purchase → Show impact |
| "能买得起X吗" | Run with simulation → Evaluate affordability |
| "财务预测" | Run forecast_balance.py → Show forecast chart |

## Available Script

### forecast_balance.py - Balance Prediction

```bash
uv run python app/skills/forecasting-finances/scripts/forecast_balance.py --days 30
```

Predicts daily balance changes based on recurring patterns and scheduled events.

**Parameters**:
- `--days`: Forecast period (default: 30)
- `--simulate-purchase`: Enable purchase simulation mode
- `--amount`: Purchase amount for simulation
- `--description`: Purchase description

**Output**:
- `forecast`: Daily balance predictions as time series
- `warnings`: Low balance alerts (when balance drops below threshold)
- `recurring_events`: Upcoming bills/income that affect forecast

**GenUI Component**: `CashFlowForecastChart`

## Workflows

### 1. Balance Forecast
```bash
uv run python app/skills/forecasting-finances/scripts/forecast_balance.py --days 30
```

1. Run the script with desired forecast period
2. Present CashFlowForecastChart showing daily projections
3. Highlight any warning periods (low balance days)
4. Summarize key events (upcoming bills, income dates)

### 2. Purchase Simulation ("如果买X")
```bash
uv run python app/skills/forecasting-finances/scripts/forecast_balance.py --simulate-purchase --amount 5000 --description "iPhone"
```

1. Run with purchase simulation parameters
2. Show before/after comparison on forecast chart
3. Clearly state if purchase is AFFORDABLE or NOT RECOMMENDED
4. If not recommended, explain when it might become affordable

## Rules

1. **Focus on FUTURE**: This skill answers "what will happen" not "what happened"
2. **Clear Recommendations**: Always give a clear yes/no on affordability
3. **Warnings First**: Highlight low balance periods prominently
4. **Show Timeline**: Use visual chart to make forecast intuitive
5. **No History Analysis**: Do NOT analyze past spending → use reviewing-finances
6. **No Budget Setting**: Do NOT set budgets → use planning-budgets
