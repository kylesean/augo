import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:augo/features/profile/providers/financial_settings_provider.dart';
import 'package:augo/shared/widgets/amount_text.dart';
import 'package:augo/features/home/models/transaction_model.dart';
import 'package:augo/shared/utils/amount_formatter.dart';
import 'package:augo/i18n/strings.g.dart';
import 'package:augo/app/theme/app_semantic_colors.dart';

import '../../../../core/constants/category_constants.dart';

/// 预算分析卡片 (Layer 4: Template)
///
/// 展示预算深度分析结果，包含：
/// - 总支出摘要和趋势
/// - 分类占比可视化
/// - Top 支出列表
/// - AI 建议
///
/// 与 BudgetStatusCard 的区别：
/// - BudgetStatusCard: 简单查询，展示当前预算状态
/// - BudgetAnalysisCard: 深度分析，展示趋势、洞察、建议
/// - BudgetAnalysisCard: 深度分析，展示趋势、洞察、建议
class BudgetAnalysisCard extends ConsumerWidget {
  final Map<String, dynamic> data;

  const BudgetAnalysisCard({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.theme;
    final colors = theme.colors;

    final totalExpense = (data['total_expense'] as num?)?.toDouble() ?? 0.0;
    final currency =
        data['currency'] as String? ??
        ref.watch(financialSettingsProvider).primaryCurrency;
    final currencySymbol = AmountFormatter.getCurrencySymbol(currency);
    final periodDays = data['period_days'] as int? ?? 90;
    final byCategory = data['by_category'] as Map<String, dynamic>? ?? {};
    final trends = data['trends'] as Map<String, dynamic>? ?? {};
    final topSpenders = data['top_spenders'] as List<dynamic>? ?? [];
    final suggestions = data['suggestions'] as List<dynamic>? ?? [];

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: colors.border.withValues(alpha: 0.5)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 顶部标题栏（深蓝色调，区别于状态卡片）
          _buildHeader(theme, colors, periodDays),

          // 2. 总支出 + 趋势指标
          _buildTotalSection(theme, colors, totalExpense, trends, currency),

          // 3. 分类占比
          if (byCategory.isNotEmpty)
            _buildCategorySection(theme, colors, byCategory, currencySymbol),

          // 4. Top 支出
          if (topSpenders.isNotEmpty)
            _buildTopSpendersSection(theme, colors, topSpenders, currency),

          // 5. 建议（基于结构化数据）
          if (suggestions.isNotEmpty)
            _buildSuggestionsSection(theme, colors, suggestions),
        ],
      ),
    );
  }

  /// 顶部标题栏 - 使用深蓝色调区别于普通状态卡片
  Widget _buildHeader(FThemeData theme, FColors colors, int periodDays) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors.primary.withValues(alpha: 0.15),
            colors.primary.withValues(alpha: 0.05),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.insights, color: colors.primary, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              data['title'] as String? ?? t.chat.genui.budgetAnalysis.title,
              style: theme.typography.base.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              t.chat.genui.budgetAnalysis.periodDays(days: periodDays),
              style: theme.typography.xs.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 总支出区域 + 趋势指标
  Widget _buildTotalSection(
    FThemeData theme,
    FColors colors,
    double totalExpense,
    Map<String, dynamic> trends,
    String currency,
  ) {
    final mom = trends['month_over_month'] as Map<String, dynamic>?;
    final changePercent = (mom?['change_percent'] as num?)?.toDouble() ?? 0;
    final direction = mom?['direction'] as String? ?? 'flat';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 总支出金额
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.chat.genui.budgetAnalysis.totalExpense,
                  style: theme.typography.sm.copyWith(
                    color: colors.mutedForeground,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    AmountText(
                      amount: totalExpense,
                      type: TransactionType.expense,
                      semantic: AmountSemantic.trend,
                      currency: currency,
                      style: theme.typography.xl.copyWith(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 趋势指标
          if (mom != null)
            _buildTrendBadge(theme, colors, changePercent, direction),
        ],
      ),
    );
  }

  /// 趋势徽章
  Widget _buildTrendBadge(
    FThemeData theme,
    FColors colors,
    double changePercent,
    String direction,
  ) {
    final semantic = theme.semantic;
    final isUp = direction == 'up';
    final isFlat = direction == 'flat';
    // 使用语义色：上升用红色(destructive)，下降用绿色(success)
    final trendColor = isFlat
        ? colors.mutedForeground
        : (isUp ? colors.destructive : semantic.successAccent);
    final icon = isFlat
        ? FIcons.minus
        : (isUp ? FIcons.trendingUp : FIcons.trendingDown);
    final prefix = isUp ? '+' : '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: trendColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: trendColor),
          const SizedBox(width: 4),
          Text(
            t.chat.genui.budgetAnalysis.momChange(
              change: '$prefix${changePercent.toStringAsFixed(1)}',
            ),
            style: theme.typography.xs.copyWith(
              color: trendColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// 分类占比区域
  Widget _buildCategorySection(
    FThemeData theme,
    FColors colors,
    Map<String, dynamic> byCategory,
    String currencySymbol,
  ) {
    // 按占比排序
    final sortedCategories = byCategory.entries.toList()
      ..sort((a, b) {
        final aTotal = (a.value['total'] as num?)?.toDouble() ?? 0;
        final bTotal = (b.value['total'] as num?)?.toDouble() ?? 0;
        return bTotal.compareTo(aTotal);
      });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.chat.genui.budgetAnalysis.categoryDistribution,
            style: theme.typography.xs.copyWith(
              color: colors.mutedForeground,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          // 组合进度条
          Container(
            height: 10,
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: colors.muted.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: sortedCategories.take(5).toList().asMap().entries.map((
                mapEntry,
              ) {
                final index = mapEntry.key;
                final entry = mapEntry.value;
                final percentage =
                    (entry.value['percentage'] as num?)?.toDouble() ?? 0;
                return Flexible(
                  flex: (percentage * 10).toInt().clamp(1, 100),
                  child: Container(color: theme.chartColorAt(index)),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          // 分类列表（取前 4 个）
          ...sortedCategories.take(4).toList().asMap().entries.map((mapEntry) {
            final index = mapEntry.key;
            final entry = mapEntry.value;
            final catData = entry.value as Map<String, dynamic>;
            final percentage = (catData['percentage'] as num?)?.toDouble() ?? 0;
            final total = (catData['total'] as num?)?.toDouble() ?? 0;
            final category = TransactionCategory.fromKey(entry.key);
            final chartColor = theme.chartColorAt(index);

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: chartColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      category.displayText,
                      style: theme.typography.sm.copyWith(
                        color: colors.foreground,
                      ),
                    ),
                  ),
                  Text(
                    '$currencySymbol${_formatAmount(total)}',
                    style: theme.typography.sm.copyWith(
                      color: colors.mutedForeground,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 45,
                    child: Text(
                      '${percentage.toStringAsFixed(0)}%',
                      textAlign: TextAlign.right,
                      style: theme.typography.sm.copyWith(
                        color: colors.foreground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  /// Top 支出列表
  Widget _buildTopSpendersSection(
    FThemeData theme,
    FColors colors,
    List<dynamic> topSpenders,
    String currency,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(height: 1, color: colors.border.withValues(alpha: 0.5)),
          const SizedBox(height: 12),
          Text(
            t.chat.genui.budgetAnalysis.topSpenders,
            style: theme.typography.xs.copyWith(
              color: colors.mutedForeground,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ...topSpenders.take(3).toList().asMap().entries.map((mapEntry) {
            final index = mapEntry.key;
            final spender = mapEntry.value as Map<String, dynamic>;
            final amount = (spender['amount'] as num?)?.toDouble() ?? 0;
            final categoryKey = spender['category'] as String? ?? 'OTHERS';
            final description = spender['description'] as String? ?? '';
            final date = spender['date'] as String? ?? '';
            final category = TransactionCategory.fromKey(categoryKey);
            final chartColor = theme.chartColorAt(index);

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: chartColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(category.icon, size: 14, color: chartColor),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          description.isNotEmpty
                              ? description
                              : category.displayText,
                          style: theme.typography.sm.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (date.isNotEmpty)
                          Text(
                            date,
                            style: theme.typography.xs.copyWith(
                              color: colors.mutedForeground,
                            ),
                          ),
                      ],
                    ),
                  ),
                  AmountText(
                    amount: amount,
                    type: TransactionType.expense,
                    currency: currency,
                    style: theme.typography.sm.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  /// 建议区域
  Widget _buildSuggestionsSection(
    FThemeData theme,
    FColors colors,
    List<dynamic> suggestions,
  ) {
    // 使用主题 primary 色的变体，保持 warning 语义但与主题统一
    final accentColor = colors.primary;
    final bgColor = colors.primary.withValues(alpha: 0.08);
    final borderColor = colors.primary.withValues(alpha: 0.2);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(FIcons.lightbulb, size: 18, color: accentColor),
              const SizedBox(width: 8),
              Text(
                t.budgetSuggestion.financialInsights,
                style: theme.typography.sm.copyWith(
                  color: accentColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...suggestions.take(3).map((suggestion) {
            // 处理结构化 suggestion 数据
            final text = _formatSuggestion(suggestion);
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '•',
                    style: theme.typography.sm.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      text,
                      style: theme.typography.sm.copyWith(
                        color: colors.foreground,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  /// 格式化结构化建议为可读文本
  String _formatSuggestion(dynamic suggestion) {
    if (suggestion is String) return suggestion;
    if (suggestion is! Map) return suggestion.toString();

    final type = suggestion['type'] as String?;
    final categoryKey = suggestion['category_key'] as String?;
    final percentage = suggestion['percentage'];
    final count = suggestion['count'];

    // 获取本地化分类名
    final categoryName = categoryKey != null
        ? TransactionCategory.fromKey(categoryKey).displayText
        : '';

    switch (type) {
      case 'high_percentage':
        return t.budgetSuggestion.highPercentage(
          category: categoryName,
          percentage: percentage.toString(),
        );
      case 'monthly_increase':
        return t.budgetSuggestion.monthlyIncrease(
          percentage: percentage.toString(),
        );
      case 'frequent_small':
        return t.budgetSuggestion.frequentSmall(
          category: categoryName,
          count: count.toString(),
        );
      default:
        return suggestion.toString();
    }
  }

  String _formatAmount(double amount) {
    if (amount >= 10000) {
      return t.chat.genui.budgetAnalysis.amountWan(
        amount: (amount / 10000).toStringAsFixed(1),
      );
    }
    return amount.toStringAsFixed(0);
  }
}
