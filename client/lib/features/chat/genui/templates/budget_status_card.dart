import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:augo/app/theme/app_semantic_colors.dart';
import 'package:augo/i18n/strings.g.dart';

import '../../../../core/constants/category_constants.dart';
import '../atoms/budget_progress_bar.dart';
import '../atoms/empty_state_alert.dart';
import '../molecules/budget_item_card.dart';

/// 预算状态卡片模板
///
/// Layer 4 (Template) - 完整的预算概览卡片
/// 由 atoms 和 molecules 组合而成，遵循 GenUI 四层架构
///
/// 设计说明：
/// ┌─────────────────────────────────────────────────┐
/// │ 📊 预算概览                              本月   │  ← 顶部标题栏
/// ├─────────────────────────────────────────────────┤
/// │ 总预算  ████████░░░░░░  75%                     │  ← 总预算进度
/// │ 已用 ¥7,500 / 剩余 ¥2,500                       │
/// ├─────────────────────────────────────────────────┤
/// │ 餐饮  ██████████░░  90%  >                      │  ← 分类预算列表
/// │ 购物  ████████░░░░  50%  >                      │
/// └─────────────────────────────────────────────────┘
class BudgetStatusCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const BudgetStatusCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    final hasBudget = data['has_budget'] == true;

    if (!hasBudget) {
      return _buildNoBudgetCard();
    }

    // 检查是单个预算还是摘要
    if (data.containsKey('budget')) {
      return _buildSingleBudgetCard(context, theme, colors, data['budget']);
    } else {
      return _buildBudgetSummaryCard(context, theme, colors);
    }
  }

  /// 无预算提示 - 使用简洁的 FAlert 样式
  Widget _buildNoBudgetCard() {
    return EmptyStateAlert.budget();
  }

  /// 单个预算卡片
  Widget _buildSingleBudgetCard(
    BuildContext context,
    FThemeData theme,
    FColors colors,
    Map<String, dynamic> budget,
  ) {
    final budgetId = budget['id'] as String?;

    return BudgetItemCard(
      budgetId: budgetId,
      name: budget['name'] as String? ?? t.chat.genui.budgetStatusCard.budget,
      percentage: (budget['percentage'] as num?)?.toDouble() ?? 0.0,
      status: budget['status'] as String? ?? 'ON_TRACK',
      spent: (budget['spent'] as num?)?.toDouble() ?? 0.0,
      amount: (budget['amount'] as num?)?.toDouble() ?? 0.0,
      remaining: (budget['remaining'] as num?)?.toDouble() ?? 0.0,
      compact: false,
      onTap: budgetId != null
          ? () => context.pushNamed(
              'budgetDetail',
              pathParameters: {'id': budgetId},
            )
          : null,
    );
  }

  /// 预算摘要卡片
  Widget _buildBudgetSummaryCard(
    BuildContext context,
    FThemeData theme,
    FColors colors,
  ) {
    final overallSpent = (data['overall_spent'] as num?)?.toDouble() ?? 0.0;
    final overallRemaining =
        (data['overall_remaining'] as num?)?.toDouble() ?? 0.0;
    final overallPercentage =
        (data['overall_percentage'] as num?)?.toDouble() ?? 0.0;
    final budgets = data['budgets'] as List<dynamic>? ?? [];
    final alerts = data['alerts'] as List<dynamic>? ?? [];
    final totalBudget = data['total_budget'] as Map<String, dynamic>?;

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
          // 顶部标题栏
          _buildHeader(
            theme,
            colors,
            t.chat.genui.budgetStatusCard.overview,
            _getOverallStatus(alerts),
          ),

          // 主内容区
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // 总预算部分（可点击）
                _buildTotalBudgetSection(
                  context,
                  theme,
                  colors,
                  totalBudget,
                  overallPercentage,
                  overallSpent,
                  overallRemaining,
                ),

                // 分类预算列表
                if (budgets.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Divider(height: 1, color: colors.border),
                  const SizedBox(height: 12),
                  ...budgets.take(5).map((b) {
                    final budget = b as Map<String, dynamic>;
                    return _buildCategoryBudgetItem(
                      context,
                      theme,
                      colors,
                      budget,
                    );
                  }),
                ],

                // 警告信息
                if (alerts.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  ...alerts.take(2).map((a) {
                    final alert = a as Map<String, dynamic>;
                    return _buildAlertItem(theme, colors, alert);
                  }),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 总预算区域
  Widget _buildTotalBudgetSection(
    BuildContext context,
    FThemeData theme,
    FColors colors,
    Map<String, dynamic>? totalBudget,
    double percentage,
    double spent,
    double remaining,
  ) {
    final semantic = theme.semantic;
    final status = _getPercentageStatus(percentage);
    final statusColor = _getStatusColor(status, colors, semantic);
    final budgetId = totalBudget?['id'] as String?;

    return InkWell(
      onTap: budgetId != null
          ? () => context.pushNamed(
              'budgetDetail',
              pathParameters: {'id': budgetId},
            )
          : null,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            // 标题行
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      t.chat.genui.budgetStatusCard.totalBudget,
                      style: theme.typography.sm.copyWith(
                        color: colors.foreground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (budgetId != null) ...[
                      const SizedBox(width: 4),
                      Icon(
                        FIcons.chevronRight,
                        size: 14,
                        color: colors.mutedForeground,
                      ),
                    ],
                  ],
                ),
                Text(
                  '${percentage.toStringAsFixed(0)}%',
                  style: theme.typography.lg.copyWith(
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 进度条
            BudgetProgressBar(
              percentage: percentage,
              status: status,
              height: 8,
            ),
            const SizedBox(height: 8),

            // 金额信息
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t.chat.genui.budgetStatusCard.spent(
                    amount: _formatAmount(spent),
                  ),
                  style: theme.typography.xs.copyWith(
                    color: colors.mutedForeground,
                  ),
                ),
                Text(
                  t.chat.genui.budgetStatusCard.remaining(
                    amount: _formatAmount(remaining),
                  ),
                  style: theme.typography.xs.copyWith(
                    color: remaining >= 0 ? colors.primary : colors.destructive,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 分类预算项（使用分类名称）
  Widget _buildCategoryBudgetItem(
    BuildContext context,
    FThemeData theme,
    FColors colors,
    Map<String, dynamic> budget,
  ) {
    // 优先使用 category_key 获取分类显示名称
    final categoryKey = budget['category_key'] as String?;
    final name = categoryKey != null
        ? _getCategoryDisplayName(categoryKey)
        : (budget['name'] as String? ?? '');
    final percentage = (budget['percentage'] as num?)?.toDouble() ?? 0.0;
    final status = budget['status'] as String? ?? 'ON_TRACK';
    final budgetId = budget['id'] as String?;

    return BudgetItemCard(
      budgetId: budgetId,
      name: name,
      percentage: percentage,
      status: status,
      compact: true,
      onTap: budgetId != null
          ? () => context.pushNamed(
              'budgetDetail',
              pathParameters: {'id': budgetId},
            )
          : null,
    );
  }

  /// 获取分类显示名称
  String _getCategoryDisplayName(String categoryKey) {
    try {
      return TransactionCategory.fromKey(categoryKey).displayText;
    } catch (e) {
      return categoryKey;
    }
  }

  /// 顶部标题栏
  Widget _buildHeader(
    FThemeData theme,
    FColors colors,
    String title,
    String status,
  ) {
    final semantic = theme.semantic;
    final statusColor = _getStatusColor(status, colors, semantic);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1)),
      child: Row(
        children: [
          Icon(FIcons.chartPie, color: statusColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: theme.typography.base.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            _getStatusText(status),
            style: theme.typography.xs.copyWith(
              color: statusColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// 警告项
  Widget _buildAlertItem(
    FThemeData theme,
    FColors colors,
    Map<String, dynamic> alert,
  ) {
    final semantic = theme.semantic;
    final alertType = alert['alert_type'] as String? ?? 'warning';
    final message = alert['message'] as String? ?? '';
    final iconColor = alertType == 'exceeded'
        ? colors.destructive
        : semantic.warningAccent;
    final icon = alertType == 'exceeded'
        ? FIcons.circleAlert
        : FIcons.triangleAlert;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: theme.typography.xs.copyWith(color: iconColor),
            ),
          ),
        ],
      ),
    );
  }

  // ============ 工具方法 ============

  Color _getStatusColor(
    String status,
    FColors colors,
    AppSemanticColors semantic,
  ) {
    switch (status.toUpperCase()) {
      case 'EXCEEDED':
        return colors.destructive;
      case 'WARNING':
        return semantic.warningAccent;
      case 'ACHIEVED':
        return semantic.successAccent;
      default:
        return colors.primary;
    }
  }

  String _getStatusText(String status) {
    switch (status.toUpperCase()) {
      case 'EXCEEDED':
        return t.chat.genui.budgetStatusCard.exceeded;
      case 'WARNING':
        return t.chat.genui.budgetStatusCard.warning;
      case 'ACHIEVED':
        return t.chat.genui.budgetStatusCard.plentiful;
      default:
        return t.chat.genui.budgetStatusCard.normal;
    }
  }

  String _getOverallStatus(List<dynamic> alerts) {
    if (alerts.isEmpty) return 'ON_TRACK';
    for (final alert in alerts) {
      final alertType =
          (alert as Map<String, dynamic>)['alert_type'] as String?;
      if (alertType == 'exceeded') return 'EXCEEDED';
    }
    return 'WARNING';
  }

  String _getPercentageStatus(double percentage) {
    if (percentage >= 100) return 'EXCEEDED';
    if (percentage >= 80) return 'WARNING';
    return 'ON_TRACK';
  }

  String _formatAmount(double amount) {
    if (amount >= 10000) {
      return '${(amount / 10000).toStringAsFixed(1)}万';
    }
    return amount.toStringAsFixed(0);
  }
}
