import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:animate_do/animate_do.dart';
import '../../../shared/widgets/app_filter_chip.dart';
import '../../../i18n/strings.g.dart';
import '../models/statistics_models.dart';
import '../providers/statistics_provider.dart';
import '../widgets/statistics_widgets.dart';
import '../widgets/filter_sheet.dart';
import '../widgets/date_range_picker_sheet.dart';
import '../../../app/router/app_routes.dart';

class ReportPage extends ConsumerStatefulWidget {
  const ReportPage({super.key});

  @override
  ConsumerState<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends ConsumerState<ReportPage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    // Load statistics on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(statisticsProvider.notifier).loadStatistics();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(statisticsProvider.notifier).loadMoreTopTransactions();
    }
  }

  void _showFilterSheet() {
    final state = ref.read(statisticsProvider);
    FilterSheet.show(
      context,
      selectedAccountTypes: state.selectedAccountTypes,
      onApply: (accountTypes) {
        ref.read(statisticsProvider.notifier).setAccountTypes(accountTypes);
      },
    );
  }

  void _showDateRangePicker() {
    final state = ref.read(statisticsProvider);
    DateRangePickerSheet.show(
      context,
      initialStart: state.customStartDate,
      initialEnd: state.customEndDate,
      onConfirm: (startDate, endDate) {
        ref
            .read(statisticsProvider.notifier)
            .setTimeRange(
              TimeRange.custom,
              startDate: startDate,
              endDate: endDate,
            );
      },
    );
  }

  void _onTimeRangeSelected(TimeRange timeRange) {
    if (timeRange == TimeRange.custom) {
      _showDateRangePicker();
    } else {
      ref.read(statisticsProvider.notifier).setTimeRange(timeRange);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;
    final state = ref.watch(statisticsProvider);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context, theme),
            // Time range tabs (full width)
            _buildTimeRangeTabs(context, theme, state),
            // Content
            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : state.error != null
                  ? _buildErrorState(context, theme, state.error!)
                  : _buildContent(context, theme, state),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, FThemeData theme) {
    final colors = theme.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // 左侧占位，与右侧按钮平衡
          const SizedBox(width: 40),
          // 居中标题
          Expanded(
            child: Text(
              t.statistics.title,
              style: theme.typography.lg.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ),
          // Filter button
          FButton.icon(
            style: FButtonStyle.ghost(),
            onPress: _showFilterSheet,
            child: Icon(FIcons.settings, color: colors.foreground),
          ),
        ],
      ),
    );
  }

  /// 全宽时间范围 Tab 按钮栏（类似首页设计）
  Widget _buildTimeRangeTabs(
    BuildContext context,
    FThemeData theme,
    StatisticsState state,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: TimeRange.values.map((timeRange) {
          final isSelected = state.timeRange == timeRange;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: AppFilterChip(
                label: timeRange.label,
                isSelected: isSelected,
                onTap: () {
                  if (isSelected && timeRange != TimeRange.custom) return;
                  _onTimeRangeSelected(timeRange);
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    FThemeData theme,
    String error,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              FIcons.triangleAlert,
              size: 48,
              color: theme.colors.mutedForeground,
            ),
            const SizedBox(height: 16),
            Text(
              t.common.loadFailed,
              style: theme.typography.lg.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: theme.typography.sm.copyWith(
                color: theme.colors.mutedForeground,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 40,
              child: FButton(
                onPress: () {
                  ref.read(statisticsProvider.notifier).loadStatistics();
                },
                child: Text(t.common.retry),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    FThemeData theme,
    StatisticsState state,
  ) {
    final colors = theme.colors;

    // Check if there is actual data to display
    final hasNoData =
        state.overview == null ||
        (state.overview!.totalIncome == "0.00" &&
            state.overview!.totalExpense == "0.00" &&
            (state.categoryBreakdown?.items.isEmpty ?? true));

    return RefreshIndicator(
      onRefresh: () => ref.read(statisticsProvider.notifier).loadStatistics(),
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // 日期范围显示（仅自定义模式）
            if (state.timeRange == TimeRange.custom &&
                state.dateRangeDisplayText != null) ...[
              FadeInDown(
                duration: const Duration(milliseconds: 400),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(FIcons.calendar, size: 14, color: colors.primary),
                      const SizedBox(width: 6),
                      Text(
                        state.dateRangeDisplayText!,
                        style: theme.typography.sm.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            if (hasNoData) ...[
              FadeInUp(
                duration: const Duration(milliseconds: 600),
                child: PremiumEmptyState(
                  onAddTransaction: () {
                    context.goNamed('ai');
                  },
                ),
              ),
            ] else ...[
              // Overview card
              if (state.overview != null) ...[
                FadeInUp(
                  duration: const Duration(milliseconds: 500),
                  delay: const Duration(milliseconds: 200),
                  child: OverviewCard(overview: state.overview!),
                ),
                const SizedBox(height: 24),
              ],

              // Trend chart
              if (state.trendData != null) ...[
                FadeInUp(
                  duration: const Duration(milliseconds: 500),
                  delay: const Duration(milliseconds: 300),
                  child: TrendChart(
                    trendData: state.trendData!,
                    chartType: state.chartType,
                    onChartTypeChanged: (chartType) {
                      ref
                          .read(statisticsProvider.notifier)
                          .setChartType(chartType);
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Category Analysis (unified multi-view section)
              if (state.categoryBreakdown != null &&
                  state.categoryBreakdown!.items.isNotEmpty) ...[
                FadeInUp(
                  duration: const Duration(milliseconds: 500),
                  delay: const Duration(milliseconds: 400),
                  child: CategoryAnalysisSection(
                    breakdown: state.categoryBreakdown!,
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Top transactions
              if (state.topTransactions != null &&
                  state.topTransactions!.items.isNotEmpty) ...[
                FadeInUp(
                  duration: const Duration(milliseconds: 500),
                  delay: const Duration(milliseconds: 600),
                  child: _buildTopTransactionsSection(context, theme, state),
                ),
                const SizedBox(height: 24),
              ],
            ],

            // Bottom padding
            SizedBox(height: MediaQuery.of(context).padding.bottom + 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTopTransactionsSection(
    BuildContext context,
    FThemeData theme,
    StatisticsState state,
  ) {
    final colors = theme.colors;
    final transactions = state.topTransactions?.items ?? [];
    final hasMore = state.topTransactions?.hasMore ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              t.statistics.ranking,
              style: theme.typography.lg.copyWith(fontWeight: FontWeight.w600),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppFilterChip(
                  icon: FIcons.arrowDownWideNarrow,
                  isSelected: state.sortType == SortType.amount,
                  onTap: () => ref
                      .read(statisticsProvider.notifier)
                      .setSortType(SortType.amount),
                ),
                const SizedBox(width: 4),
                AppFilterChip(
                  icon: FIcons.calendarRange,
                  isSelected: state.sortType == SortType.date,
                  onTap: () => ref
                      .read(statisticsProvider.notifier)
                      .setSortType(SortType.date),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Transaction list using ListView.builder for performance and simple pagination
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount:
              transactions.length +
              (hasMore || state.isLoadingMoreTopTransactions ? 1 : 0),
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            if (index < transactions.length) {
              return TopTransactionCard(
                transaction: transactions[index],
                onTap: () {
                  context.pushNamed(
                    AppRouteNames.transactionDetail,
                    pathParameters: {'transactionId': transactions[index].id},
                  );
                },
              );
            } else {
              if (state.isLoadingMoreTopTransactions) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colors.primary,
                      ),
                    ),
                  ),
                );
              } else if (hasMore) {
                return const SizedBox(height: 40);
              } else {
                return const SizedBox();
              }
            }
          },
        ),
        if (!hasMore && transactions.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                t.statistics.noMoreData,
                style: theme.typography.xs.copyWith(
                  color: colors.mutedForeground,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
