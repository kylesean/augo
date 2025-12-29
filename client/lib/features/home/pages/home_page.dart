// features/home/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/calendar/monthly_calendar_view.dart';
import '../widgets/feed/sliver_transaction_feed_view.dart';
import '../providers/home_providers.dart';
import 'package:forui/forui.dart';
import '../../shared_space/widgets/notification_icon.dart';
import 'package:augo/i18n/strings.g.dart';
import 'package:augo/shared/utils/amount_formatter.dart';
import '../models/total_expense_model.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.theme;

    // 添加滚动监听以触发加载更多
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.axis == Axis.vertical &&
            scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent - 200) {
          final notifier = ref.read(transactionFeedProvider.notifier);
          final feedState = ref.read(transactionFeedProvider);
          if (!feedState.isLoadingMore && !feedState.hasReachedMax) {
            notifier.fetchMoreTransactions();
          }
        }
        return false;
      },
      child: Scaffold(
        // 将 Scaffold 背景设为白色(background)，彻底解决底部 overscroll 露黑线的问题
        backgroundColor: theme.colors.background,
        body: Stack(
          children: [
            // 底层：顶部黑色背景，覆盖 iOS 下拉 overscroll 区域
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * 0.5,
              child: Container(color: theme.colors.primary),
            ),
            // 主内容层
            RefreshIndicator(
              color: theme.colors.primary,
              // 下拉刷新指示器的背景色，保持白色
              backgroundColor: theme.colors.background,
              onRefresh: () async {
                await ref.read(transactionFeedProvider.notifier).refreshFeed();
              },
              child: CustomScrollView(
                slivers: [
                  // Header - SliverAppBar (黑色)
                  SliverAppBar(
                    expandedHeight: 250.0,
                    floating: false,
                    pinned: false,
                    backgroundColor: theme.colors.primary,
                    flexibleSpace: const _WelcomeHeader(),
                    actions: const [NotificationIcon(), SizedBox(width: 16)],
                  ),
                  // 主要内容区域
                  SliverToBoxAdapter(
                    child: Container(
                      // 关键：外层容器设为黑色 (primary)，以无缝衔接 Header
                      color: theme.colors.primary,
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.colors.background, // 内部内容设为白色
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                              theme.style.borderRadius.topLeft.x + 4,
                            ),
                            topRight: Radius.circular(
                              theme.style.borderRadius.topRight.x + 4,
                            ),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 日历组件
                            Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 4),
                              child: const MonthlyCalendarView(),
                            ),
                            // Tab 按钮栏
                            const _FixedTabBar(),
                            // 移除底部的 padding，因为现在列表紧接在后面
                          ],
                        ),
                      ),
                    ),
                  ),
                  // 交易列表 - 使用 Sliver 版本
                  // 包装在 SliverMainAxisGroup 中以确保背景色一致（如果需要）
                  // 或者直接放置。我们需要为列表设置背景色，这可以通过
                  // SliverToBoxAdapter 绘制一个背景，或者在 SliverTransactionFeedView 中处理。
                  // 由于 SliverList 没有 backgroundColor 属性，通常的做法是
                  // 让整个 CustomScrollView 背景一致，或者使用 DecoratedSliver (Flutter 3.13+)

                  // 为了确保列表背景是白色（theme.colors.background），
                  // 我们可以在这之前放一个 DecoratedSliver，包裹 FeedView。
                  // 但 DecoratedSliver 需要特定 Flutter 版本。
                  // 简单的做法是：Scaffold 已经在 Header 下方设置了背景色（通过主要内容区域的 Container）。
                  // 但对于 Infinite List，我们需要确保延伸到底部。
                  // 我们使用一个 Consumer 来根据当前 Tab 类型构建 SliverTransactionFeedView
                  Consumer(
                    builder: (context, ref, child) {
                      final currentSelectedType = ref.watch(
                        currentTransactionFeedTypeProvider,
                      );
                      // 使用 DecoratedSliver 确保列表区域背景为白色
                      return DecoratedSliver(
                        decoration: BoxDecoration(
                          color: theme.colors.background,
                        ),
                        sliver: SliverPadding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).padding.bottom + 16,
                          ),
                          sliver: SliverTransactionFeedView(
                            key: ValueKey(currentSelectedType),
                            intendedFeedType: currentSelectedType,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ], // Stack children
        ), // Stack
      ),
    );
  }
}

// 固定的Tab按钮栏组件
class _FixedTabBar extends ConsumerWidget {
  const _FixedTabBar();

  // 定义 Tab 的数据结构 - 需要在 build 时动态生成以支持国际化
  List<({TransactionFeedType type, String label})> _getTabData() {
    return [
      (type: TransactionFeedType.all, label: t.common.all),
      (type: TransactionFeedType.expense, label: t.transaction.expense),
      (type: TransactionFeedType.income, label: t.transaction.income),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.theme;
    final colors = theme.colors;
    final currentSelectedType = ref.watch(currentTransactionFeedTypeProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: _getTabData().map((tabInfo) {
          final isSelected = tabInfo.type == currentSelectedType;

          if (isSelected) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: FButton(
                  mainAxisSize: MainAxisSize.min,
                  onPress: () {}, // 空函数，保持按钮启用状态
                  child: Text(
                    tabInfo.label,
                    style: theme.typography.sm.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colors.primaryForeground,
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: FButton(
                  style: FButtonStyle.outline(),
                  mainAxisSize: MainAxisSize.min,
                  onPress: () {
                    ref
                        .read(currentTransactionFeedTypeProvider.notifier)
                        .set(tabInfo.type);
                  },
                  child: Text(
                    tabInfo.label,
                    style: theme.typography.sm.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colors.mutedForeground,
                    ),
                  ),
                ),
              ),
            );
          }
        }).toList(),
      ),
    );
  }
}

// 恢复的头部组件，显示总消费金额和年度进度
class _WelcomeHeader extends ConsumerStatefulWidget {
  const _WelcomeHeader();

  @override
  ConsumerState<_WelcomeHeader> createState() => _WelcomeHeaderState();
}

class _WelcomeHeaderState extends ConsumerState<_WelcomeHeader> {
  bool _isAmountVisible = true;

  // 计算年度时间进度
  double _getYearProgress() {
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final endOfYear = DateTime(now.year + 1, 1, 1);
    final totalDays = endOfYear.difference(startOfYear).inDays;
    final passedDays = now.difference(startOfYear).inDays;
    return passedDays / totalDays;
  }

  String _formatAmount(TotalExpenseData data) {
    // 优先使用后端返回的格式化好的字符串
    if (data.display != null) {
      return data.display!.fullString;
    }

    // Fallback 到本地格式化
    return AmountFormatter.formatCommon(
      data.totalExpense,
      currencyCode: data.currency,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;
    final now = DateTime.now();
    final totalExpenseAsync = ref.watch(totalExpenseProvider);

    final yearProgress = _getYearProgress();
    final progressPercentage = (yearProgress * 100).toInt();

    return FlexibleSpaceBar(
      background: Container(
        decoration: BoxDecoration(color: colors.primary),
        child: ClipRect(
          child: Stack(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 总消费金额标签和眼睛图标
                        Row(
                          children: [
                            Text(
                              t.home.totalExpense,
                              style: theme.typography.sm.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colors.primaryForeground.withValues(
                                  alpha: 0.9,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            FButton.icon(
                              style: FButtonStyle.ghost(),
                              onPress: () {
                                setState(() {
                                  _isAmountVisible = !_isAmountVisible;
                                });
                              },
                              child: Icon(
                                _isAmountVisible ? FIcons.eye : FIcons.eyeOff,
                                color: colors.primaryForeground.withValues(
                                  alpha: 0.8,
                                ),
                                size: 16,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),
                        // 总消费金额
                        totalExpenseAsync.when(
                          data: (data) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _isAmountVisible
                                    ? _formatAmount(data)
                                    : t.home.amountHidden,
                                style: theme.typography.xl2.copyWith(
                                  color: colors.primaryForeground,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  _QuickStatItem(
                                    label: t.home.todayExpense,
                                    amount: data.todayExpense,
                                    currency: data.currency,
                                    isVisible: _isAmountVisible,
                                  ),
                                  const SizedBox(width: 24),
                                  _QuickStatItem(
                                    label: t.home.monthExpense,
                                    amount: data.monthExpense,
                                    currency: data.currency,
                                    isVisible: _isAmountVisible,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          loading: () => Text(
                            t.common.loading,
                            style: theme.typography.xl2.copyWith(
                              color: colors.primaryForeground.withValues(
                                alpha: 0.6,
                              ),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          error: (error, _) => Text(
                            _isAmountVisible ? '¥0.00' : t.home.amountHidden,
                            style: theme.typography.xl2.copyWith(
                              color: colors.primaryForeground,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                        // 年度时间进度条 - 简化版本
                        Row(
                          children: [
                            Text(
                              t.home.yearProgress(year: now.year),
                              style: theme.typography.xs.copyWith(
                                color: colors.primaryForeground.withValues(
                                  alpha: 0.8,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                height: 3,
                                decoration: BoxDecoration(
                                  color: colors.primaryForeground.withValues(
                                    alpha: 0.2,
                                  ),
                                  borderRadius: BorderRadius.circular(1.5),
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: FractionallySizedBox(
                                    widthFactor: yearProgress,
                                    child: Container(
                                      height: 3,
                                      decoration: BoxDecoration(
                                        color: colors.primaryForeground,
                                        borderRadius: BorderRadius.circular(
                                          1.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$progressPercentage%',
                              style: theme.typography.xs.copyWith(
                                color: colors.primaryForeground.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickStatItem extends StatelessWidget {
  final String label;
  final double amount;
  final String currency;
  final bool isVisible;

  const _QuickStatItem({
    required this.label,
    required this.amount,
    required this.currency,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    final displayString = AmountFormatter.formatCommon(
      amount,
      currencyCode: currency,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.typography.xs.copyWith(
            color: colors.primaryForeground.withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          isVisible ? displayString : '••••',
          style: theme.typography.base.copyWith(
            color: colors.primaryForeground,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
