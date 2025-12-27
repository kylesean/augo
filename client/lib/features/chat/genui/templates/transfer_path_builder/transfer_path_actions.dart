import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:augo/i18n/strings.g.dart';
import 'transfer_path_state.dart';

/// 转账链路操作按钮组件
///
/// 显示确认、重选等操作按钮
class TransferPathActions extends StatelessWidget {
  final List<dynamic> sourceAccounts;
  final List<dynamic> targetAccounts;

  const TransferPathActions({
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

    // 获取账户名称
    final sourceName = _getAccountName(state.selectedSourceId, sourceAccounts);
    final targetName = _getAccountName(state.selectedTargetId, targetAccounts);

    // 历史模式：显示已确认状态
    if (state.isHistorical) {
      return _buildHistoricalState(theme, colors, sourceName, targetName);
    }

    // 已确认状态
    if (state.isConfirmed) {
      if (state.isSubmitted) {
        return _buildSubmittedState(theme, colors);
      }
      return _buildConfirmButton(
        theme,
        colors,
        provider,
        sourceName,
        targetName,
      );
    }

    // 未选择完成
    if (state.selectedSourceId == null) {
      return _buildDisabledButton(
        theme,
        t.chat.genui.transferPath.pleaseSelectSource,
      );
    }

    if (state.selectedTargetId == null) {
      return _buildDisabledButton(
        theme,
        t.chat.genui.transferPath.pleaseSelectTarget,
      );
    }

    // 可以确认
    return _buildFirstConfirmButton(theme, provider);
  }

  Widget _buildHistoricalState(
    FThemeData theme,
    FColors colors,
    String? sourceName,
    String? targetName,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FIcons.check, color: colors.primary, size: 14),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              t.chat.genui.transferPath.confirmedWithArrow(
                source: sourceName ?? "?",
                target: targetName ?? "?",
              ),
              style: theme.typography.xs.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmittedState(FThemeData theme, FColors colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FIcons.check, color: colors.primary, size: 14),
          const SizedBox(width: 6),
          Text(
            t.chat.genui.transferPath.confirmed,
            style: theme.typography.sm.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(
    FThemeData theme,
    FColors colors,
    TransferPathStateProvider provider,
    String? sourceName,
    String? targetName,
  ) {
    return SizedBox(
      width: double.infinity,
      child: FButton(
        onPress: provider.state.isReadOnly ? null : provider.onFinalConfirm,
        child: Text(
          t.chat.genui.transferPath.confirmAction(
            source: sourceName ?? '?',
            target: targetName ?? '?',
          ),
        ),
      ),
    );
  }

  Widget _buildDisabledButton(FThemeData theme, String text) {
    return SizedBox(
      width: double.infinity,
      child: FButton(
        style: FButtonStyle.outline(),
        onPress: null,
        child: Text(text),
      ),
    );
  }

  Widget _buildFirstConfirmButton(
    FThemeData theme,
    TransferPathStateProvider provider,
  ) {
    return SizedBox(
      width: double.infinity,
      child: FButton(
        onPress: provider.state.isReadOnly ? null : provider.onFirstConfirm,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(t.chat.genui.transferPath.confirmLinks),
            const SizedBox(width: 8),
            const Icon(FIcons.arrowRight, size: 16),
          ],
        ),
      ),
    );
  }

  String? _getAccountName(String? accountId, List<dynamic> accounts) {
    if (accountId == null) return null;
    for (final acc in accounts) {
      if ((acc as Map<String, dynamic>)['id'] == accountId) {
        return acc['name'] as String?;
      }
    }
    return null;
  }
}

/// 完成状态指示器（锁定后、提交前）
class TransferPathCompletionIndicator extends StatelessWidget {
  const TransferPathCompletionIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = TransferPathStateProvider.of(context);
    final state = provider.state;
    final theme = context.theme;
    final colors = theme.colors;

    if (!state.isConfirmed || state.isReadOnly) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(FIcons.check, color: colors.primary, size: 14),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.chat.genui.transferPath.linkLocked,
                  style: theme.typography.xs.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.foreground,
                  ),
                ),
                Text(
                  t.chat.genui.transferPath.clickToConfirm,
                  style: theme.typography.xs.copyWith(
                    color: colors.mutedForeground,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          // 重选按钮
          if (!state.isSubmitted)
            GestureDetector(
              onTap: () {
                provider.onStateChange(state.copyWith(isConfirmed: false));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.muted,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  t.chat.genui.transferPath.reselect,
                  style: theme.typography.xs.copyWith(
                    color: colors.mutedForeground,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
