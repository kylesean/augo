---
name: executing-transfers
description: >
  Executes fund transfers between user's asset accounts with interactive wizard.
  Provides intelligent fuzzy matching for account selection.

  USE WHEN user wants to:
  - 转账, 账户互转, 资金划转, 余额转移
  - 把钱从X转到Y, 转点钱

  NOT FOR:
  - 分析消费 → reviewing-finances skill
  - 记录普通交易 → record_transaction tool
  - 共享账本操作 → managing-shared-ledgers skill

allowed-tools: "execute record_transactions read_file"
---

# Skill: Executing Transfers

You are the expert in fund transfers between asset accounts.
Your goal is to guide users through accurate account-to-account transfers using a visual interface.

## Core Principle

This skill answers ONE question: **"Move money from A to B"**

## Use Cases

| User Request | Action |
|--------------|--------|
| "帮我转账500" | Run prepare_transfer.py → Show TransferWizard |
| "从工商银行转到支付宝" | Run with source/target hints → Pre-select accounts |
| "我要转账" | Run without params → Show empty wizard |
| "把钱从工资卡转到投资账户" | Run with fuzzy matching → Smart account selection |

## Available Script

### prepare_transfer.py - Transfer Wizard Setup

```bash
uv run python app/skills/executing-transfers/scripts/prepare_transfer.py --amount 500 --source_hint "ICBC"
```

Prepares the transfer wizard by:
1. **Audit Environment**: Identifies all "ASSET" nature accounts
2. **Intelligent Matching**: Fuzzy matches account names based on user hints
3. **Safety First**: If multiple matches, lets user select via UI

**Parameters**:
- `--amount`: Transfer amount (float), optional
- `--source_hint`: Keyword for source account, optional
- `--target_hint`: Keyword for target account, optional

**Output**:
- Success: `{"success": true, "accounts": [...], ...}` → Show TransferWizard
- Error: `{"error_type": "NO_ACCOUNTS"}` or `{"error_type": "SINGLE_ACCOUNT"}`

**GenUI Component**: `TransferWizard`

## Workflow

### Intent Triggered (Audit First)

When you recognize a transfer intent, immediately execute `prepare_transfer.py`.

**Handle Results**:

1. **NO_ACCOUNTS** error:
   - Inform user they have no asset accounts
   - Suggest adding accounts in settings

2. **SINGLE_ACCOUNT** error:
   - Inform user they only have one account
   - Transfer requires at least two accounts

3. **SUCCESS**:
   - System automatically shows TransferWizard
   - Respond naturally: "好的，我帮你打开转账助手："

### Transfer Confirmation

When user confirms in the wizard:
- The `transfer_confirmed` event triggers backend execution
- Use `record_transaction` tool to record the transfer

## Rules

1. **No Technical Jargon**: Never mention "execute", "python", ".py", or "script"
2. **UI First**: Open wizard even if amount is missing (wizard has input fields)
3. **Asset Only**: Only transfer between ASSET accounts
4. **Safety First**: Require user confirmation before executing
5. **Localization**: Respond in user's session language
