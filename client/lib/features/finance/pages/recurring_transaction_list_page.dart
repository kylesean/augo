import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../models/recurring_transaction.dart';
import '../providers/recurring_transaction_provider.dart';
import '../../../core/widgets/top_toast.dart';
import '../../../shared/models/currency.dart';
import '../../profile/providers/financial_settings_provider.dart';
import 'package:augo/core/constants/category_constants.dart';
import 'package:augo/i18n/strings.g.dart';
import 'package:augo/shared/widgets/themed_icon.dart';
import '../../../shared/widgets/app_filter_chip.dart';

/// 周期交易列表页面
class RecurringTransactionListPage extends ConsumerStatefulWidget {
  const RecurringTransactionListPage({super.key});

  @override
  ConsumerState<RecurringTransactionListPage> createState() =>
      _RecurringTransactionListPageState();
}

class _RecurringTransactionListPageState
    extends ConsumerState<RecurringTransactionListPage> {
  RecurringTransactionType? _filterType;
  bool _sortAscending = true; // 按时间升序排序

  @override
  void initState() {
    super.initState();
    unawaited(
      Future<void>.microtask(() {
        unawaited(ref.read(recurringTransactionProvider.notifier).loadList());
      }),
    );
  }

  void _onFilterChanged(RecurringTransactionType? type) {
    setState(() => _filterType = type);
    unawaited(
      ref.read(recurringTransactionProvider.notifier).loadList(type: type),
    );
  }

  void _toggleSort() {
    setState(() => _sortAscending = !_sortAscending);
  }

  List<RecurringTransaction> _getSortedItems(List<RecurringTransaction> items) {
    final sorted = List<RecurringTransaction>.from(items);
    sorted.sort((a, b) {
      final aTime = a.nextExecutionAt ?? a.startDate;
      final bTime = b.nextExecutionAt ?? b.startDate;
      return _sortAscending ? aTime.compareTo(bTime) : bTime.compareTo(aTime);
    });
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;
    final state = ref.watch(recurringTransactionProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(FIcons.arrowLeft, color: colors.foreground, size: 20),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              // 如果不能 pop，返回到 finance 页面
              context.go('/finance');
            }
          },
        ),
        title: Text(
          t.forecast.recurringTransaction.title,
          style: theme.typography.lg.copyWith(
            fontWeight: FontWeight.w600,
            color: colors.foreground,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 筛选标签
          _buildFilterTabs(theme, colors),
          // 列表内容
          Expanded(child: _buildContent(theme, colors, state)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/finance/recurring-transactions/new'),
        backgroundColor: colors.primary,
        foregroundColor: colors.primaryForeground,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  Widget _buildFilterTabs(FThemeData theme, FColors colors) {
    final filters = [
      (null, t.forecast.recurringTransaction.all),
      (
        RecurringTransactionType.expense,
        t.forecast.recurringTransaction.expense,
      ),
      (RecurringTransactionType.income, t.forecast.recurringTransaction.income),
      (
        RecurringTransactionType.transfer,
        t.forecast.recurringTransaction.transfer,
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: filters.map((filter) {
          final isSelected = _filterType == filter.$1;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: AppFilterChip(
                label: filter.$2,
                isSelected: isSelected,
                onTap: () => _onFilterChanged(filter.$1),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContent(
    FThemeData theme,
    FColors colors,
    RecurringTransactionState state,
  ) {
    if (state.isLoading && state.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FIcons.circleAlert, size: 48, color: colors.mutedForeground),
            const SizedBox(height: 16),
            Text(
              t.common.loadFailed,
              style: theme.typography.base.copyWith(
                color: colors.mutedForeground,
              ),
            ),
            const SizedBox(height: 8),
            FButton(
              style: FButtonStyle.outline(),
              onPress: () => ref
                  .read(recurringTransactionProvider.notifier)
                  .loadList(type: _filterType),
              child: Text(t.common.retry),
            ),
          ],
        ),
      );
    }

    if (state.items.isEmpty) {
      return _buildEmptyState(theme, colors);
    }

    final sortedItems = _getSortedItems(state.items);

    return RefreshIndicator(
      onRefresh: () => ref
          .read(recurringTransactionProvider.notifier)
          .loadList(type: _filterType),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 列表头：显示数量 + 排序按钮
          _buildListHeader(theme, colors, sortedItems.length),
          const SizedBox(height: 12),
          // 列表项
          ...sortedItems.map(
            (item) => _buildTransactionCard(theme, colors, item),
          ),
        ],
      ),
    );
  }

  /// 列表头：左侧显示数量，右侧显示排序按钮
  Widget _buildListHeader(FThemeData theme, FColors colors, int count) {
    final typeLabel = _filterType?.label ?? t.forecast.recurringTransaction.all;
    return Row(
      children: [
        Text(
          t.forecast.recurringTransaction.periodCount(
            type: typeLabel,
            count: count.toString(),
          ),
          style: theme.typography.sm.copyWith(color: colors.mutedForeground),
        ),
        const Spacer(),
        GestureDetector(
          onTap: _toggleSort,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _sortAscending ? FIcons.arrowUp : FIcons.arrowDown,
                size: 14,
                color: colors.primary,
              ),
              const SizedBox(width: 4),
              Text(
                t.forecast.recurringTransaction.sortByTime,
                style: theme.typography.sm.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(FThemeData theme, FColors colors) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FIcons.repeat, size: 64, color: colors.mutedForeground),
            const SizedBox(height: 16),
            Text(
              t.forecast.recurringTransaction.noRecurring,
              style: theme.typography.lg.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.foreground,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              t.forecast.recurringTransaction.createHint,
              style: theme.typography.sm.copyWith(
                color: colors.mutedForeground,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FButton(
                onPress: () =>
                    context.push('/finance/recurring-transactions/new'),
                child: Text(t.forecast.recurringTransaction.create),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionCard(
    FThemeData theme,
    FColors colors,
    RecurringTransaction transaction,
  ) {
    final typeColor = _getTypeColor(colors, transaction.type);
    final typeIcon = _getTypeIcon(transaction.type);
    final amountSign = transaction.type == RecurringTransactionType.income
        ? '+'
        : transaction.type == RecurringTransactionType.expense
        ? '-'
        : '';

    // 获取下次执行日期（优先使用 nextExecutionAt，否则使用 startDate）
    final nextDate = transaction.nextExecutionAt ?? transaction.startDate;

    return Dismissible(
      key: Key('recurring_${transaction.id}'),
      direction: DismissDirection.horizontal, // 支持左右滑动
      dismissThresholds: const {
        DismissDirection.endToStart: 0.4,
        DismissDirection.startToEnd: 0.4,
      },
      confirmDismiss: (direction) async {
        unawaited(HapticFeedback.selectionClick());
        if (direction == DismissDirection.endToStart) {
          // 左滑 → 删除
          return await _showDeleteConfirmDialog(transaction);
        } else {
          // 右滑 → 切换激活状态
          await _showToggleActiveDialog(transaction);
          return false; // 不删除卡片
        }
      },
      // 左滑背景（删除）
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: transaction.isActive ? colors.mutedForeground : Colors.green,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 24),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              transaction.isActive ? FIcons.pause : FIcons.play,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              transaction.isActive
                  ? t.forecast.recurringTransaction.paused
                  : t.forecast.recurringTransaction.activated,
              style: theme.typography.sm.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      // 右滑背景（删除）
      secondaryBackground: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: colors.destructive,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(FIcons.trash2, color: Colors.white, size: 24),
      ),
      child: GestureDetector(
        onTap: () => context.push(
          '/finance/recurring-transactions/${transaction.id}/edit',
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.border),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // 左侧：类型图标
                ThemedIcon.large(icon: typeIcon),
                const SizedBox(width: 14),
                // 中间：标题 + 标签
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getDisplayName(transaction),
                        style: theme.typography.base.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colors.foreground,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          // 规则标签
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: colors.muted,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _getShortFrequencyLabel(
                                transaction.recurrenceRule,
                              ),
                              style: theme.typography.xs.copyWith(
                                color: colors.mutedForeground,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          // 动态金额标签
                          if (transaction.amountType == AmountType.estimate)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: colors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    FIcons.circleAlert,
                                    size: 12,
                                    color: colors.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    t
                                        .forecast
                                        .recurringTransaction
                                        .dynamicAmount,
                                    style: theme.typography.xs.copyWith(
                                      color: colors.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                // 右侧：金额 + 下次日期
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$amountSign${Currency.fromCode(ref.watch(financialSettingsProvider).primaryCurrency)?.symbol ?? '¥'}${transaction.amount}',
                      style: theme.typography.base.copyWith(
                        color: typeColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${t.forecast.recurringTransaction.nextTime}: ${_formatShortDate(nextDate)}',
                      style: theme.typography.sm.copyWith(
                        color: colors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 显示删除确认对话框
  Future<bool> _showDeleteConfirmDialog(
    RecurringTransaction transaction,
  ) async {
    bool confirmed = false;

    await showFDialog<void>(
      context: context,
      builder: (dialogContext, style, animation) => FDialog(
        style: style.call,
        animation: animation,
        title: Text(t.forecast.recurringTransaction.confirmDelete),
        body: Text(
          t.forecast.recurringTransaction.deleteConfirm(
            name: _getDisplayName(transaction),
          ),
        ),
        actions: [
          FButton(
            style: FButtonStyle.destructive(),
            onPress: () {
              confirmed = true;
              Navigator.pop(dialogContext);
            },
            child: Text(t.common.delete),
          ),
          FButton(
            style: FButtonStyle.outline(),
            onPress: () => Navigator.pop(dialogContext),
            child: Text(t.common.cancel),
          ),
        ],
      ),
    );

    if (confirmed) {
      unawaited(HapticFeedback.mediumImpact());
      final success = await ref
          .read(recurringTransactionProvider.notifier)
          .delete(transaction.id);

      if (mounted) {
        if (success) {
          TopToast.success(context, t.transaction.deleted);
        } else {
          TopToast.error(context, t.transaction.deleteFailed);
        }
      }
      return success;
    }
    return false;
  }

  /// 显示切换激活状态确认对话框
  Future<void> _showToggleActiveDialog(RecurringTransaction transaction) async {
    final newState = !transaction.isActive;
    bool confirmed = false;

    await showFDialog<void>(
      context: context,
      builder: (dialogContext, style, animation) => FDialog(
        style: style.call,
        animation: animation,
        title: Text(
          newState
              ? t.forecast.recurringTransaction.confirmActivate
              : t.forecast.recurringTransaction.confirmPause,
        ),
        body: Text(
          newState
              ? t.forecast.recurringTransaction.activateConfirm(
                  name: _getDisplayName(transaction),
                )
              : t.forecast.recurringTransaction.pauseConfirm(
                  name: _getDisplayName(transaction),
                ),
        ),
        actions: [
          FButton(
            style: newState ? FButtonStyle.primary() : FButtonStyle.outline(),
            onPress: () {
              confirmed = true;
              Navigator.pop(dialogContext);
            },
            child: Text(
              newState
                  ? t.forecast.recurringTransaction.activated
                  : t.forecast.recurringTransaction.paused,
            ),
          ),
          FButton(
            style: FButtonStyle.outline(),
            onPress: () => Navigator.pop(dialogContext),
            child: Text(t.common.cancel),
          ),
        ],
      ),
    );

    if (confirmed) {
      unawaited(HapticFeedback.mediumImpact());
      unawaited(
        ref
            .read(recurringTransactionProvider.notifier)
            .toggleActive(transaction.id, newState),
      );

      if (mounted) {
        TopToast.success(
          context,
          newState
              ? t.forecast.recurringTransaction.activated
              : t.forecast.recurringTransaction.paused,
        );
      }
    }
  }

  Color _getTypeColor(FColors colors, RecurringTransactionType type) {
    switch (type) {
      case RecurringTransactionType.expense:
        return colors.destructive;
      case RecurringTransactionType.income:
        return Colors.green;
      case RecurringTransactionType.transfer:
        return colors.primary;
    }
  }

  IconData _getTypeIcon(RecurringTransactionType type) {
    switch (type) {
      case RecurringTransactionType.expense:
        return FIcons.arrowUpRight;
      case RecurringTransactionType.income:
        return FIcons.arrowDownLeft;
      case RecurringTransactionType.transfer:
        return FIcons.arrowRightLeft;
    }
  }

  /// 获取简短的频率标签
  String _getShortFrequencyLabel(String rule) {
    final isZh = LocaleSettings.currentLocale == AppLocale.zh;
    if (rule.contains('FREQ=DAILY')) {
      return isZh ? '每天' : 'Daily';
    } else if (rule.contains('FREQ=WEEKLY')) {
      return isZh ? '每周' : 'Weekly';
    } else if (rule.contains('FREQ=MONTHLY')) {
      return isZh ? '每月' : 'Monthly';
    } else if (rule.contains('FREQ=YEARLY')) {
      return isZh ? '每年' : 'Yearly';
    }
    return isZh ? '周期' : 'Cycle';
  }

  /// 格式化简短日期（支持国际化）
  /// 使用 switch 表达式，便于未来添加更多语言支持
  String _formatShortDate(DateTime date) {
    final locale = LocaleSettings.currentLocale;
    // 根据语言返回对应的 DateFormat locale 和格式
    final (dateFormatLocale, pattern) = switch (locale) {
      AppLocale.zh => ('zh_CN', 'M 月 d 日'),
      AppLocale.en => ('en', 'MMM d'),
      AppLocale.ja => ('ja', 'M月d日'),
      AppLocale.ko => ('ko', 'M월 d일'),
      AppLocale.zhHant => ('zh_TW', 'M 月 d 日'),
    };
    return DateFormat(pattern, dateFormatLocale).format(date);
  }

  /// 生成交易的显示名称
  /// 如果有描述使用描述，否则使用分类的本地化名称
  String _getDisplayName(RecurringTransaction transaction) {
    if (transaction.description != null &&
        transaction.description!.isNotEmpty) {
      return transaction.description!;
    }

    // 使用分类的本地化显示名称（已包含国际化）
    if (transaction.categoryKey != null) {
      final category = TransactionCategory.fromKey(transaction.categoryKey!);
      return category.displayText;
    }

    // 默认名称：根据类型返回
    return switch (transaction.type) {
      RecurringTransactionType.expense => t.transaction.expense,
      RecurringTransactionType.income => t.transaction.income,
      RecurringTransactionType.transfer => t.transaction.transfer,
    };
  }
}
