import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import '../../genui_widgets.dart';
import 'package:augo/i18n/strings.g.dart';
import 'transfer_path_state.dart';

/// 转账链路可视化组件
///
/// 显示 FROM -> TO 双框布局
class TransferPathVisualization extends StatelessWidget {
  final List<dynamic> sourceAccounts;
  final List<dynamic> targetAccounts;

  const TransferPathVisualization({
    super.key,
    required this.sourceAccounts,
    required this.targetAccounts,
  });

  @override
  Widget build(BuildContext context) {
    final provider = TransferPathStateProvider.of(context);
    final state = provider.state;
    final theme = context.theme;
    final colors = theme.colors;

    return Row(
      children: [
        // Source (FROM)
        Expanded(
          child: _AccountBox(
            label: t.chat.genui.transferPath.from,
            selectedAccountId: state.selectedSourceId,
            accounts: sourceAccounts,
            isActive: state.activeSelection == 'source' && !state.isConfirmed,
            isConfirmed: state.isConfirmed || state.isReadOnly,
            onTap: state.isReadOnly
                ? null
                : () => provider.onAccountSelected('', 'activate_source'),
          ),
        ),

        // 中间箭头
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Container(
              key: ValueKey(state.isConfirmed),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: state.isConfirmed
                    ? colors.primary.withValues(alpha: 0.1)
                    : colors.muted,
                shape: BoxShape.circle,
              ),
              child: Icon(
                state.isConfirmed ? FIcons.check : FIcons.arrowRight,
                color: state.isConfirmed
                    ? colors.primary
                    : colors.mutedForeground,
                size: 14,
              ),
            ),
          ),
        ),

        // Target (TO)
        Expanded(
          child: _AccountBox(
            label: t.chat.genui.transferPath.to,
            selectedAccountId: state.selectedTargetId,
            accounts: targetAccounts,
            isActive: state.activeSelection == 'target' && !state.isConfirmed,
            isConfirmed: state.isConfirmed || state.isReadOnly,
            onTap: state.isReadOnly
                ? null
                : () => provider.onAccountSelected('', 'activate_target'),
          ),
        ),
      ],
    );
  }
}

/// 单个账户选择框
class _AccountBox extends StatelessWidget {
  final String label;
  final String? selectedAccountId;
  final List<dynamic> accounts;
  final bool isActive;
  final bool isConfirmed;
  final VoidCallback? onTap;

  const _AccountBox({
    required this.label,
    required this.selectedAccountId,
    required this.accounts,
    required this.isActive,
    required this.isConfirmed,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    // 查找已选账户
    Map<String, dynamic>? selectedAccount;
    if (selectedAccountId != null) {
      for (final acc in accounts) {
        if ((acc as Map<String, dynamic>)['id'] == selectedAccountId) {
          selectedAccount = acc;
          break;
        }
      }
    }

    final hasSelection = selectedAccount != null;

    // 计算样式
    Color borderColor;
    Color? bgColor;
    if (isConfirmed) {
      borderColor = colors.primary;
      bgColor = colors.primary.withValues(alpha: 0.05);
    } else if (isActive) {
      borderColor = colors.primary;
      bgColor = colors.primary.withValues(alpha: 0.03);
    } else if (hasSelection) {
      borderColor = colors.border;
      bgColor = colors.secondary;
    } else {
      borderColor = colors.border;
      bgColor = colors.background;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: borderColor,
            width: isActive || isConfirmed ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: theme.typography.xs.copyWith(
                color: colors.mutedForeground,
              ),
            ),
            const SizedBox(height: 6),
            if (hasSelection) ...[
              IconBadge.fromAccountType(
                accountType: selectedAccount['type'] as String?,
                colors: colors,
                size: 36,
              ),
              const SizedBox(height: 4),
              Text(
                selectedAccount['name'] as String,
                style: theme.typography.sm.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.foreground,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
              if (selectedAccount['subtitle'] != null &&
                  (selectedAccount['subtitle'] as String).isNotEmpty)
                Text(
                  selectedAccount['subtitle'] as String,
                  style: theme.typography.xs.copyWith(
                    color: colors.mutedForeground,
                  ),
                  textAlign: TextAlign.center,
                ),
            ] else ...[
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: colors.muted,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.help_outline,
                  color: colors.mutedForeground,
                  size: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                t.chat.genui.transferPath.select,
                style: theme.typography.sm.copyWith(
                  color: colors.mutedForeground,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
