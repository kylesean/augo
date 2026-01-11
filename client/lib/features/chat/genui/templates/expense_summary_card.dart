import 'dart:async';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/category_constants.dart';
import '../organisms/organisms.dart';
import 'package:augo/shared/widgets/amount_text.dart';
import 'package:augo/features/home/models/transaction_model.dart';
import 'package:augo/i18n/strings.g.dart';
import 'package:augo/app/theme/app_semantic_colors.dart';

/// 智能账单概览卡片 (Layer 4: Template)
///
/// 展示总支出、类别分布占比以及 Top 3 交易。
/// 使用 GenUI 四层架构：
/// - atoms: IconBadge, AmountDisplay
/// - molecules: StatCard, TransactionItem
/// - organisms: GenUIBottomSheet, TransactionListView
class ExpenseSummaryCard extends ConsumerWidget {
  final Map<String, dynamic> data;

  const ExpenseSummaryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.theme;
    final colors = theme.colors;

    final summary = data['summary'] as Map<String, dynamic>? ?? {};
    final totalExpense = (summary['total_expense'] as num?)?.toDouble() ?? 0.0;
    final distribution = (summary['distribution'] as List<dynamic>?) ?? [];
    final topItems = (summary['top_items'] as List<dynamic>?) ?? [];
    final totalCount = (summary['count'] as num?)?.toInt() ?? 0;

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
          // 1. 顶部总额区
          _buildTotalSection(context, theme, colors, totalExpense),

          // 2. 类别分布进度条
          if (distribution.isNotEmpty)
            _buildDistributionSection(context, theme, colors, distribution),

          // 3. Top 3 交易列表
          if (topItems.isNotEmpty)
            _buildTopItemsSection(context, theme, colors, topItems),

          // 4. 底部全部按钮
          _buildViewAllButton(context, theme, colors, totalCount),
        ],
      ),
    );
  }

  Widget _buildTotalSection(
    BuildContext context,
    FThemeData theme,
    FColors colors,
    double amount,
  ) {
    final t = Translations.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.chat.genui.expenseSummary.totalExpense,
            style: theme.typography.sm.copyWith(color: colors.mutedForeground),
          ),
          const SizedBox(height: 4),
          // 使用统一的 AmountText.large 组件
          AmountText.large(
            amount: amount,
            type: TransactionType.expense,
            semantic: AmountSemantic.status,
            showSign: false,
            dimDecimals: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDistributionSection(
    BuildContext context,
    FThemeData theme,
    FColors colors,
    List<dynamic> distribution,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          // 组合进度条
          Container(
            height: 12,
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: colors.muted.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: distribution.asMap().entries.map((mapEntry) {
                final index = mapEntry.key;
                final item = mapEntry.value;
                final percentage =
                    (item['percentage'] as num?)?.toDouble() ?? 0.0;

                return Flexible(
                  flex: (percentage * 1000).toInt(),
                  child: Container(color: theme.chartColorAt(index)),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          // 类别图例 (取前 4 个)
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: distribution.take(4).toList().asMap().entries.map((
              mapEntry,
            ) {
              final index = mapEntry.key;
              final item = mapEntry.value;
              final categoryKey = item['category'] as String?;
              final percentage =
                  (item['percentage'] as num?)?.toDouble() ?? 0.0;
              final category = TransactionCategory.fromKey(categoryKey);
              final chartColor = theme.chartColorAt(index);

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: chartColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${category.displayText} ${(percentage * 100).toStringAsFixed(0)}%',
                    style: theme.typography.xs.copyWith(
                      color: colors.mutedForeground,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTopItemsSection(
    BuildContext context,
    FThemeData theme,
    FColors colors,
    List<dynamic> topItems,
  ) {
    final t = Translations.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              t.chat.genui.expenseSummary.mainExpenses,
              style: theme.typography.xs.copyWith(
                color: colors.mutedForeground,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          ...topItems.asMap().entries.map((mapEntry) {
            final index = mapEntry.key;
            final item = mapEntry.value;
            final categoryKey = item['category'] as String?;
            final category = TransactionCategory.fromKey(categoryKey);
            final amount = (item['amount'] as num?)?.toDouble() ?? 0.0;
            final tags = (item['tags'] as List?)?.join(' · ') ?? '';
            final chartColor = theme.chartColorAt(index);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: ListTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: chartColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(category.icon, size: 16, color: chartColor),
                ),
                title: Text(
                  tags.isNotEmpty ? tags : category.displayText,
                  style: theme.typography.sm.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: AmountText(
                  amount: amount,
                  type: TransactionType.expense,
                  style: theme.typography.sm.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildViewAllButton(
    BuildContext context,
    FThemeData theme,
    FColors colors,
    int totalCount,
  ) {
    final t = Translations.of(context);
    return InkWell(
      onTap: () => _showAllTransactions(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: colors.muted.withValues(alpha: 0.2),
          border: Border(
            top: Border.all(color: colors.border.withValues(alpha: 0.3)).top,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              t.chat.genui.expenseSummary.viewAll(count: totalCount),
              style: theme.typography.sm.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Icon(FIcons.chevronRight, size: 14, color: colors.primary),
          ],
        ),
      ),
    );
  }

  void _showAllTransactions(BuildContext context) {
    final t = Translations.of(context);
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => GenUIBottomSheet(
          title: t.chat.genui.expenseSummary.details,
          child: TransactionListView(data: data),
        ),
      ),
    );
  }
}
