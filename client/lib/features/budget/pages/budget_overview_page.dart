import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

import '../../../core/constants/category_constants.dart';
import '../../../shared/models/currency.dart';
import '../../profile/providers/financial_settings_provider.dart';
import '../models/budget_models.dart';
import '../providers/budget_provider.dart';
import 'package:augo/i18n/strings.g.dart';
import '../../../shared/widgets/app_filter_chip.dart';

class BudgetOverviewPage extends ConsumerStatefulWidget {
  const BudgetOverviewPage({super.key});

  @override
  ConsumerState<BudgetOverviewPage> createState() => _BudgetOverviewPageState();
}

class _BudgetOverviewPageState extends ConsumerState<BudgetOverviewPage> {
  @override
  void initState() {
    super.initState();
    // page init load budget data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(ref.read(budgetSummaryProvider.notifier).load());
    });
  }

  /// Get currency symbol from global settings
  String get _currencySymbol =>
      Currency.fromCode(
        ref.watch(financialSettingsProvider).primaryCurrency,
      )?.symbol ??
      '¥';

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;
    final state = ref.watch(budgetSummaryProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          t.budget.title,
          style: theme.typography.lg.copyWith(
            fontWeight: FontWeight.w600,
            color: colors.foreground,
          ),
        ),
        centerTitle: true,
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(FIcons.arrowLeft, color: colors.foreground),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: state.isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.foreground,
                    ),
                  )
                : Icon(FIcons.refreshCw, color: colors.foreground, size: 20),
            onPressed: state.isLoading
                ? null
                : () => ref.read(budgetSummaryProvider.notifier).refresh(),
          ),
        ],
      ),
      body: _buildBody(theme, colors, state),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed('budgetNew'),
        backgroundColor: colors.primary,
        foregroundColor: colors.primaryForeground,
        shape: const CircleBorder(),
        child: const Icon(FIcons.plus, size: 28),
      ),
    );
  }

  Widget _buildBody(
    FThemeData theme,
    FColors colors,
    BudgetSummaryState state,
  ) {
    // loading state
    if (state.isLoading && state.summary == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // error state
    if (state.error != null && state.summary == null) {
      return _buildErrorState(theme, colors, state.error!);
    }

    // empty state
    if (!state.hasBudgets) {
      return _buildEmptyState(theme, colors);
    }

    // normal content
    return RefreshIndicator(
      onRefresh: () => ref.read(budgetSummaryProvider.notifier).refresh(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // filter tabs
          _buildFilterTabs(theme, colors),
          const SizedBox(height: 16),

          // total budget card
          if (state.summary!.totalBudgetDetail != null) ...[
            GestureDetector(
              onTap: () => context.pushNamed(
                'budgetDetail',
                pathParameters: {
                  'id': state.summary!.totalBudgetDetail!.budget.id,
                },
              ),
              child: _buildTotalBudgetCard(
                theme,
                colors,
                state.summary!.totalBudgetDetail!,
              ),
            ),
            const SizedBox(height: 16),
          ],

          // summary card (if there is no total budget, show category budget summary)
          if (state.summary!.totalBudgetDetail == null &&
              state.summary!.budgets.isNotEmpty) ...[
            _buildSummaryCard(theme, colors, state.summary!),
            const SizedBox(height: 16),
          ],

          // category budget list
          if (state.summary!.categoryBudgets.isNotEmpty) ...[
            _buildSectionHeader(theme, colors, t.budget.categoryBudget),
            const SizedBox(height: 8),
            ...state.summary!.categoryBudgets.map(
              (b) => GestureDetector(
                onTap: () => context.pushNamed(
                  'budgetDetail',
                  pathParameters: {'id': b.budget.id},
                ),
                child: _buildBudgetCard(theme, colors, b),
              ),
            ),
          ],

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  /// filter tabs
  Widget _buildFilterTabs(FThemeData theme, FColors colors) {
    final currentFilter = ref.watch(budgetFilterStateProvider);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: BudgetFilter.values.map((filter) {
          final isSelected = currentFilter == filter;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: AppFilterChip(
                label: filter.label,
                isSelected: isSelected,
                onTap: () {
                  ref
                      .read(budgetFilterStateProvider.notifier)
                      .setFilter(filter);
                  unawaited(ref.read(budgetSummaryProvider.notifier).refresh());
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// error state
  Widget _buildErrorState(FThemeData theme, FColors colors, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FIcons.triangleAlert, size: 48, color: colors.destructive),
            const SizedBox(height: 16),
            Text(
              t.budget.loadFailed,
              style: theme.typography.lg.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.foreground,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: theme.typography.sm.copyWith(
                color: colors.mutedForeground,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 120,
              child: FButton(
                onPress: () =>
                    ref.read(budgetSummaryProvider.notifier).refresh(),
                child: Text(t.common.retry),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// empty state
  Widget _buildEmptyState(FThemeData theme, FColors colors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FIcons.wallet,
            size: 64,
            color: colors.mutedForeground.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            t.budget.noBudget,
            style: theme.typography.lg.copyWith(color: colors.mutedForeground),
          ),
          const SizedBox(height: 8),
          Text(
            t.budget.createHint,
            style: theme.typography.sm.copyWith(
              color: colors.mutedForeground.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  /// total budget card
  Widget _buildTotalBudgetCard(
    FThemeData theme,
    FColors colors,
    BudgetWithUsage budgetWithUsage,
  ) {
    final budget = budgetWithUsage.budget;
    final usagePercent = budgetWithUsage.usagePercentage;
    final isExceeded = usagePercent > 100;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isExceeded
              ? [colors.destructive, colors.destructive.withValues(alpha: 0.8)]
              : [colors.primary, colors.primary.withValues(alpha: 0.8)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isExceeded ? colors.destructive : colors.primary)
                .withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // title row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                budget.displayName,
                style: theme.typography.lg.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.primaryForeground,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.primaryForeground.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  budget.periodType.label,
                  style: theme.typography.xs.copyWith(
                    color: colors.primaryForeground,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // amount display
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.budget.used,
                      style: theme.typography.sm.copyWith(
                        color: colors.primaryForeground.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$_currencySymbol${_formatAmount(budgetWithUsage.spentAmount)}',
                      style: theme.typography.xl2.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colors.primaryForeground,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    t.budget.remaining,
                    style: theme.typography.sm.copyWith(
                      color: colors.primaryForeground.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$_currencySymbol${_formatAmount(budgetWithUsage.remainingAmount)}',
                    style: theme.typography.lg.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colors.primaryForeground,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (usagePercent / 100).clamp(0.0, 1.0),
              backgroundColor: colors.primaryForeground.withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation<Color>(
                colors.primaryForeground,
              ),
              minHeight: 8,
            ),
          ),

          const SizedBox(height: 8),

          // percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                t.budget.usedPercent(percent: usagePercent.toStringAsFixed(1)),
                style: theme.typography.sm.copyWith(
                  color: colors.primaryForeground.withValues(alpha: 0.8),
                ),
              ),
              Text(
                t.budget.budgetAmount(
                  amount: '$_currencySymbol${_formatAmount(budget.amount)}',
                ),
                style: theme.typography.sm.copyWith(
                  color: colors.primaryForeground.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// summary card
  Widget _buildSummaryCard(
    FThemeData theme,
    FColors colors,
    BudgetSummary summary,
  ) {
    final usagePercent = summary.overallUsagePercentage;
    final isExceeded = usagePercent > 100;

    return FCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t.budget.monthlySummary,
                  style: theme.typography.base.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.foreground,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isExceeded
                        ? colors.destructive.withValues(alpha: 0.1)
                        : colors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${usagePercent.toStringAsFixed(0)}%',
                    style: theme.typography.sm.copyWith(
                      color: isExceeded ? colors.destructive : colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    theme,
                    colors,
                    t.budget.totalBudget,
                    '$_currencySymbol${_formatAmount(summary.totalBudget)}',
                    colors.foreground,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    theme,
                    colors,
                    t.budget.used,
                    '$_currencySymbol${_formatAmount(summary.totalSpent)}',
                    isExceeded ? colors.destructive : colors.primary,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    theme,
                    colors,
                    t.budget.remaining,
                    '$_currencySymbol${_formatAmount(summary.totalRemaining)}',
                    summary.totalRemaining < Decimal.zero
                        ? colors.destructive
                        : colors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    FThemeData theme,
    FColors colors,
    String label,
    String value,
    Color valueColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.typography.xs.copyWith(color: colors.mutedForeground),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.typography.base.copyWith(
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  /// section header
  Widget _buildSectionHeader(FThemeData theme, FColors colors, String title) {
    return Text(
      title,
      style: theme.typography.sm.copyWith(
        fontWeight: FontWeight.w500,
        color: colors.mutedForeground,
      ),
    );
  }

  /// budget card
  Widget _buildBudgetCard(
    FThemeData theme,
    FColors colors,
    BudgetWithUsage budgetWithUsage,
  ) {
    final budget = budgetWithUsage.budget;
    final usagePercent = budgetWithUsage.usagePercentage;
    final isExceeded = usagePercent > 100;
    final isWarning = usagePercent > 70 && !isExceeded;
    final isPaused = budget.status == BudgetStatus.paused;

    Color statusColor;
    if (isPaused) {
      statusColor = colors.mutedForeground; // pause state use gray
    } else if (isExceeded) {
      statusColor = colors.destructive;
    } else if (isWarning) {
      statusColor = Colors.orange;
    } else {
      statusColor = colors.primary;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: FCard(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // title row
              Row(
                children: [
                  // category icon
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getCategoryIcon(budget.categoryKey),
                      size: 18,
                      color: statusColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                budget.displayName,
                                style: theme.typography.base.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isPaused
                                      ? colors.mutedForeground
                                      : colors.foreground,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isPaused) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: colors.muted,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  t.budget.paused,
                                  style: theme.typography.xs.copyWith(
                                    color: colors.mutedForeground,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        Text(
                          _getCategoryDisplayName(budget.categoryKey),
                          style: theme.typography.xs.copyWith(
                            color: colors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // amount and status
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$_currencySymbol${_formatAmount(budgetWithUsage.spentAmount)}',
                        style: theme.typography.base.copyWith(
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                      Text(
                        '$_currencySymbol${_formatAmount(budget.amount)}',
                        style: theme.typography.xs.copyWith(
                          color: colors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: (usagePercent / 100).clamp(0.0, 1.0),
                  backgroundColor: colors.border,
                  valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                  minHeight: 6,
                ),
              ),

              const SizedBox(height: 8),

              // bottom info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.budget.usedPercent(
                      percent: usagePercent.toStringAsFixed(0),
                    ),
                    style: theme.typography.xs.copyWith(
                      color: colors.mutedForeground,
                    ),
                  ),
                  Text(
                    budgetWithUsage.remainingAmount >= Decimal.zero
                        ? t.budget.remainingAmount(
                            amount:
                                '$_currencySymbol${_formatAmount(budgetWithUsage.remainingAmount)}',
                          )
                        : t.budget.overspentAmount(
                            amount:
                                '$_currencySymbol${_formatAmount(budgetWithUsage.remainingAmount.abs())}',
                          ),
                    style: theme.typography.xs.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// format amount
  String _formatAmount(Decimal amount) {
    final value = double.tryParse(amount.toString()) ?? 0.0;
    final absValue = value.abs();

    if (absValue >= 10000) {
      return '${(absValue / 10000).toStringAsFixed(1)}${t.budget.tenThousandSuffix}';
    }

    final parts = absValue.toStringAsFixed(2).split('.');
    final intPart = parts[0];
    final decPart = parts[1];

    var formatted = '';
    var count = 0;
    for (int i = intPart.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) {
        formatted = ',$formatted';
      }
      formatted = intPart[i] + formatted;
      count++;
    }

    // if decimal part is 00, omit it
    if (decPart == '00') {
      return value < 0 ? '-$formatted' : formatted;
    }
    return value < 0 ? '-$formatted.$decPart' : '$formatted.$decPart';
  }

  /// get category icon
  IconData _getCategoryIcon(String? categoryKey) {
    if (categoryKey == null) return FIcons.wallet;

    switch (categoryKey) {
      case 'FOOD_DINING':
        return FIcons.coffee;
      case 'TRANSPORT':
        return FIcons.navigation;
      case 'SHOPPING':
        return FIcons.shoppingBag;
      case 'ENTERTAINMENT':
        return FIcons.film;
      case 'HOME_UTILITIES':
        return FIcons.housePlus;
      case 'HEALTHCARE':
        return FIcons.heart;
      case 'EDUCATION':
        return FIcons.book;
      case 'PERSONAL':
        return FIcons.user;
      case 'TRAVEL':
        return FIcons.mapPin;
      case 'GIFTS_CHARITY':
        return FIcons.gift;
      case 'FINANCIAL':
        return FIcons.dollarSign;
      case 'OTHER':
        return FIcons.ellipsis;
      default:
        return FIcons.wallet;
    }
  }

  /// get category display name
  String _getCategoryDisplayName(String? categoryKey) {
    if (categoryKey == null) return t.budget.totalBudget;
    return TransactionCategory.fromKey(categoryKey).displayText;
  }
}
