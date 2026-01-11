import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:intl/intl.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:augo/shared/providers/amount_theme_provider.dart';
import 'package:augo/shared/theme/amount_theme.dart';
import 'package:augo/i18n/strings.g.dart';

/// Cash Flow Analysis Card - GenUI Template
///
/// Used to display the user's cash flow analysis results in AI chat.
/// Uses a simplified and expandable design for progressive disclosure of detailed information.
///
/// Supports an optional `ai_insight` field to display an AI-generated analysis summary.
class CashFlowAnalysisCard extends StatefulWidget {
  final Map<String, dynamic> data;

  const CashFlowAnalysisCard({super.key, required this.data});

  @override
  State<CashFlowAnalysisCard> createState() => _CashFlowAnalysisCardState();
}

class _CashFlowAnalysisCardState extends State<CashFlowAnalysisCard> {
  bool _isExpanded = false;

  String _formatAmount(dynamic amount) {
    final numberFormat = NumberFormat("#,##0.00", "zh_CN");
    if (amount is String) {
      return numberFormat.format(double.tryParse(amount) ?? 0);
    }
    return numberFormat.format(amount ?? 0);
  }

  String _formatPercent(dynamic value) {
    final v = (value as num?)?.toDouble() ?? 0;
    return '${v >= 0 ? '+' : ''}${v.toStringAsFixed(1)}%';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final theme = context.theme;
        final colors = theme.colors;
        final amountTheme = ref.watch(currentAmountThemeValueProvider);

        final netCashFlow = widget.data['netCashFlow'];
        final savingsRate =
            (widget.data['savingsRate'] as num?)?.toDouble() ?? 0;
        final isPositive = savingsRate >= 0;
        final aiInsight = widget.data['aiInsight'] as String?;

        return GestureDetector(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header - always visible
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: colors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            FIcons.trendingUp,
                            size: 20,
                            color: colors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.data['title'] as String? ??
                                    t.chat.genui.cashFlowCard.title,
                                style: theme.typography.base.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colors.foreground,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Text(
                                    '¥${_formatAmount(netCashFlow)}',
                                    style: theme.typography.lg.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: isPositive
                                          ? amountTheme.incomeColor
                                          : amountTheme.expenseColor,
                                      height: 1.0,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          (isPositive
                                                  ? amountTheme.incomeColor
                                                  : amountTheme.expenseColor)
                                              .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      t.chat.genui.cashFlowCard.savingsRate(
                                        rate: savingsRate.toStringAsFixed(0),
                                      ),
                                      style: theme.typography.xs.copyWith(
                                        color: isPositive
                                            ? amountTheme.incomeColor
                                            : amountTheme.expenseColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          _isExpanded ? FIcons.chevronUp : FIcons.chevronDown,
                          size: 16,
                          color: colors.mutedForeground,
                        ),
                      ],
                    ),

                    // Expanded details
                    if (_isExpanded) ...[
                      const SizedBox(height: 16),
                      Divider(height: 1, color: colors.border),
                      const SizedBox(height: 16),

                      // Income & Expense
                      Row(
                        children: [
                          Expanded(
                            child: _buildMetricTile(
                              context,
                              amountTheme,
                              label: t.chat.genui.cashFlowCard.totalIncome,
                              value:
                                  '¥${_formatAmount(widget.data['totalIncome'])}',
                              change:
                                  (widget.data['incomeChangePercent'] as num?)
                                      ?.toDouble(),
                              valueColor: amountTheme.incomeColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildMetricTile(
                              context,
                              amountTheme,
                              label: t.chat.genui.cashFlowCard.totalExpense,
                              value:
                                  '¥${_formatAmount(widget.data['totalExpense'])}',
                              change:
                                  (widget.data['expenseChangePercent'] as num?)
                                      ?.toDouble(),
                              inverseColor: true,
                              valueColor: amountTheme.expenseColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Expense breakdown
                      Row(
                        children: [
                          Expanded(
                            child: _buildMetricTile(
                              context,
                              amountTheme,
                              label: t.chat.genui.cashFlowCard.essentialExpense,
                              value:
                                  '${(widget.data['essentialExpenseRatio'] as num?)?.toStringAsFixed(0) ?? 0}%',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildMetricTile(
                              context,
                              amountTheme,
                              label: t
                                  .chat
                                  .genui
                                  .cashFlowCard
                                  .discretionaryExpense,
                              value:
                                  '${(widget.data['discretionaryExpenseRatio'] as num?)?.toStringAsFixed(0) ?? 0}%',
                            ),
                          ),
                        ],
                      ),
                      // AI Insight section (if available)
                      if (aiInsight != null && aiInsight.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colors.muted.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: colors.border.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    FIcons.sparkles,
                                    size: 14,
                                    color: colors.primary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    t.chat.genui.cashFlowCard.aiInsight,
                                    style: theme.typography.xs.copyWith(
                                      color: colors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              GptMarkdown(
                                aiInsight,
                                style: theme.typography.sm.copyWith(
                                  color: colors.foreground.withValues(
                                    alpha: 0.9,
                                  ),
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMetricTile(
    BuildContext context,
    AmountTheme amountTheme, {
    required String label,
    required String value,
    double? change,
    bool inverseColor = false,
    Color? valueColor,
  }) {
    final theme = context.theme;
    final colors = theme.colors;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.muted.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.typography.xs.copyWith(color: colors.mutedForeground),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Flexible(
                child: Text(
                  value,
                  style: theme.typography.sm.copyWith(
                    color: valueColor ?? colors.foreground,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              if (change != null) ...[
                const SizedBox(width: 4),
                Text(
                  _formatPercent(change),
                  style: theme.typography.xs.copyWith(
                    color: (inverseColor ? change <= 0 : change >= 0)
                        ? amountTheme.incomeColor
                        : amountTheme.expenseColor,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
