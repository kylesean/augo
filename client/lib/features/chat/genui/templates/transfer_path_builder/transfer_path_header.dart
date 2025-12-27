import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:augo/i18n/strings.g.dart';

/// 转账链路头部组件
///
/// 显示标题和金额徽章
class TransferPathHeader extends StatelessWidget {
  final num amount;
  final String currency;
  final bool isHistorical;

  const TransferPathHeader({
    super.key,
    required this.amount,
    required this.currency,
    this.isHistorical = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 左侧：图标 + 标题
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                FIcons.arrowLeftRight,
                size: 14,
                color: colors.primary,
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.chat.genui.transferPath.title,
                  style: theme.typography.sm.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.foreground,
                  ),
                ),
                if (isHistorical)
                  Text(
                    t.chat.genui.transferPath.history,
                    style: theme.typography.xs.copyWith(
                      color: colors.mutedForeground,
                    ),
                  ),
              ],
            ),
          ],
        ),

        // 右侧：金额徽章
        _buildAmountBadge(theme, colors),
      ],
    );
  }

  Widget _buildAmountBadge(FThemeData theme, FColors colors) {
    if (amount > 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colors.primary, colors.primary.withValues(alpha: 0.85)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '$currency${_formatAmount(amount)}',
          style: theme.typography.sm.copyWith(
            fontWeight: FontWeight.w600,
            color: colors.primaryForeground,
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: colors.muted,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          t.chat.genui.transferPath.amountUnconfirmed,
          style: theme.typography.xs.copyWith(color: colors.mutedForeground),
        ),
      );
    }
  }

  String _formatAmount(num amount) {
    return amount.toStringAsFixed(2);
  }
}
