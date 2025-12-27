import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:augo/i18n/strings.g.dart';

/// 预算创建成功收据卡片
///
/// 展示新创建的预算信息。
/// 参考设计：
/// ┌─────────────────────────────────────────────────┐
/// │ ✓ 预算已创建                           14:30   │  ← 顶部：成功状态栏
/// ├─────────────────────────────────────────────────┤
/// │                    📊                           │
/// │               ¥10,000                           │  ← 中部：预算金额
/// │            2024年12月总预算                       │
/// ├─────────────────────────────────────────────────┤
/// │ 周期: 12月1日 - 12月31日              滚动预算   │  ← 底部：详情
/// └─────────────────────────────────────────────────┘
class BudgetReceipt extends StatelessWidget {
  final Map<String, dynamic> data;

  const BudgetReceipt({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    final success = data['success'] == true;

    if (!success) {
      return _buildErrorCard(theme, colors);
    }

    return _buildSuccessCard(theme, colors);
  }

  /// 构建成功卡片
  Widget _buildSuccessCard(FThemeData theme, FColors colors) {
    final name =
        data['name'] as String? ?? t.chat.genui.budgetReceipt.newBudget;
    final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
    final scope = data['scope'] as String? ?? 'TOTAL';
    final categoryKey = data['category_key'] as String?;
    final periodStart = data['period_start'] as String?;
    final periodEnd = data['period_end'] as String?;
    final rolloverEnabled = data['rollover_enabled'] == true;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 顶部状态栏
          _buildStatusHeader(theme, colors),

          // 中部内容
          _buildMainContent(theme, colors, name, amount, scope, categoryKey),

          // 底部详情
          _buildDetailsFooter(
            theme,
            colors,
            periodStart,
            periodEnd,
            rolloverEnabled,
          ),
        ],
      ),
    );
  }

  /// 构建顶部状态栏
  Widget _buildStatusHeader(FThemeData theme, FColors colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: colors.primary.withValues(alpha: 0.1)),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: colors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(FIcons.check, color: Colors.white, size: 14),
          ),
          const SizedBox(width: 8),
          Text(
            t.chat.genui.budgetReceipt.budgetCreated,
            style: theme.typography.base.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            _formatCurrentTime(),
            style: theme.typography.sm.copyWith(
              color: colors.primary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建中部内容
  Widget _buildMainContent(
    FThemeData theme,
    FColors colors,
    String name,
    double amount,
    String scope,
    String? categoryKey,
  ) {
    final isTotal = scope.toUpperCase() == 'TOTAL';
    final iconData = isTotal ? FIcons.wallet : FIcons.layoutGrid;
    final iconColor = colors.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        children: [
          // 图标
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: iconColor, size: 24),
          ),
          const SizedBox(height: 16),

          // 金额
          Text(
            '¥${_formatAmount(amount)}',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: colors.foreground,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),

          // 预算名称
          Text(
            name,
            style: theme.typography.sm.copyWith(color: colors.mutedForeground),
            textAlign: TextAlign.center,
          ),

          // 分类标签（如果是分类预算）
          if (categoryKey != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                categoryKey,
                style: theme.typography.xs.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 构建底部详情
  Widget _buildDetailsFooter(
    FThemeData theme,
    FColors colors,
    String? periodStart,
    String? periodEnd,
    bool rolloverEnabled,
  ) {
    final periodText = _formatPeriod(periodStart, periodEnd);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(color: colors.muted.withValues(alpha: 0.3)),
      child: Row(
        children: [
          Icon(FIcons.calendar, size: 14, color: colors.mutedForeground),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              periodText,
              style: theme.typography.sm.copyWith(
                color: colors.mutedForeground,
              ),
            ),
          ),
          if (rolloverEnabled) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(FIcons.refreshCcw, size: 12, color: colors.primary),
                  const SizedBox(width: 4),
                  Text(
                    t.chat.genui.budgetReceipt.rolloverBudget,
                    style: theme.typography.xs.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 构建错误卡片
  Widget _buildErrorCard(FThemeData theme, FColors colors) {
    final message =
        data['message'] as String? ?? t.chat.genui.budgetReceipt.createFailed;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.destructive.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.destructive.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(FIcons.circleAlert, color: colors.destructive, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: theme.typography.sm.copyWith(color: colors.destructive),
            ),
          ),
        ],
      ),
    );
  }

  /// 格式化当前时间
  String _formatCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  /// 格式化金额
  String _formatAmount(double amount) {
    if (amount >= 10000) {
      final wan = amount / 10000;
      if (wan == wan.truncate()) {
        return '${wan.truncate()}万';
      }
      return '${wan.toStringAsFixed(1)}万';
    }
    if (amount == amount.truncate()) {
      return amount.truncate().toString();
    }
    return amount.toStringAsFixed(2);
  }

  /// 格式化周期
  String _formatPeriod(String? start, String? end) {
    if (start == null || end == null) {
      return t.chat.genui.budgetReceipt.thisMonth;
    }
    try {
      final startDate = DateTime.parse(start);
      final endDate = DateTime.parse(end);
      return t.chat.genui.budgetReceipt.dateRange(
        start: startDate.month,
        startDay: startDate.day,
        end: endDate.month,
        endDay: endDate.day,
      );
    } catch (e) {
      return t.chat.genui.budgetReceipt.thisMonth;
    }
  }
}
