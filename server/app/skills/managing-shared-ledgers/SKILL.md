---
name: managing-shared-ledgers
description: >
  Manages family or team shared ledgers for collaborative financial tracking.
  Shows shared spending summaries, member statistics, and space management.

  USE WHEN user asks about:
  - 共享账本, 家庭账单, 团队支出, 我们的消费
  - 家人本月花了多少, 团队预算, AA制

  NOT FOR:
  - 个人消费分析 → reviewing-finances skill
  - 个人转账 (非共享) → executing-transfers skill
  - 个人预算设置 → planning-budgets skill

allowed-tools: "execute search_transactions read_file"
---

# Skill: Managing Shared Ledgers

You manage collaborative financial data for families and teams.
This skill handles all "WE" instead of "I" financial questions.

## Core Principle

This skill answers: **"How are WE doing financially?"**

## Use Cases

| User Request | Action |
|--------------|--------|
| "我有哪些共享账本" | Run list_spaces.py → Show available spaces |
| "家庭本月花了多少" | Run query_space_summary.py → Show spending stats |
| "团队支出情况" | Run query_space_summary.py → Show breakdown |
| "我们一起花了多少" | Identify space → Show summary |

## Available Scripts

### list_spaces.py - Get Available Spaces

```bash
uv run python app/skills/managing-shared-ledgers/scripts/list_spaces.py
```

Returns all shared spaces the user has access to.

**Output**:
- `spaces`: List of shared spaces with names and user roles
- `role`: User's role in each space (owner/member)

### query_space_summary.py - Space Summary

```bash
uv run python app/skills/managing-shared-ledgers/scripts/query_space_summary.py
```

For a specific space:
```bash
echo '{"space_id": "uuid-string"}' | uv run python app/skills/managing-shared-ledgers/scripts/query_space_summary.py
```

**Output**:
- Monthly spending totals
- Breakdown by member
- Category distribution

**GenUI Component**: `SharedSpaceSummaryCard`

## Workflows

### 1. Discovery - List Available Spaces

**Triggers**: "我有哪些共享账本", "显示共享账户"

1. Run `list_spaces.py`
2. Present available spaces with role indicators
3. Offer to show summary for any space

### 2. Summary Query

**Triggers**: "家庭消费", "团队支出"

1. If user mentions specific space name → use that space
2. If only one space exists → use that space
3. If multiple spaces and unclear → ask which one
4. Run `query_space_summary.py` with space_id
5. Summarize the spending data

## Rules

1. **Shared Context Only**: Only handle "we/us" not "I/me" questions
2. **Space Identification**: Always identify which space user means
3. **Role Awareness**: User may be owner or member with different permissions
4. **For Transfers**: Guide user to executing-transfers skill
5. **For Recording**: Use normal `record_transaction` tool with space context
6. **Localization**: Respond in user's session language
