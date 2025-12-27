import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:intl/intl.dart';
import '../models/statistics_models.dart';
import '../services/statistics_service.dart';

part 'statistics_provider.g.dart';

/// Statistics state
class StatisticsState {
  final TimeRange timeRange;
  final ChartType chartType;
  final SortType sortType;
  final List<String> selectedAccountTypes;
  final DateTime? customStartDate;
  final DateTime? customEndDate;
  final bool isLoading;
  final bool isLoadingMoreTopTransactions;
  final String? error;

  /// The date range text used for display in the UI (only has a value in custom mode).
  final String? dateRangeDisplayText;

  // Data
  final StatisticsOverview? overview;
  final TrendDataResponse? trendData;
  final CategoryBreakdownResponse? categoryBreakdown;
  final TopTransactionsResponse? topTransactions;
  final CashFlowAnalysis? cashFlow;
  final HealthScore? healthScore;

  const StatisticsState({
    this.timeRange = TimeRange.month,
    this.chartType = ChartType.expense,
    this.sortType = SortType.amount,
    this.selectedAccountTypes = const [],
    this.customStartDate,
    this.customEndDate,
    this.isLoading = false,
    this.isLoadingMoreTopTransactions = false,
    this.error,
    this.dateRangeDisplayText,
    this.overview,
    this.trendData,
    this.categoryBreakdown,
    this.topTransactions,
    this.cashFlow,
    this.healthScore,
  });

  StatisticsState copyWith({
    TimeRange? timeRange,
    ChartType? chartType,
    SortType? sortType,
    List<String>? selectedAccountTypes,
    DateTime? customStartDate,
    DateTime? customEndDate,
    bool? isLoading,
    bool? isLoadingMoreTopTransactions,
    String? error,
    String? dateRangeDisplayText,
    StatisticsOverview? overview,
    TrendDataResponse? trendData,
    CategoryBreakdownResponse? categoryBreakdown,
    TopTransactionsResponse? topTransactions,
    CashFlowAnalysis? cashFlow,
    HealthScore? healthScore,
  }) {
    return StatisticsState(
      timeRange: timeRange ?? this.timeRange,
      chartType: chartType ?? this.chartType,
      sortType: sortType ?? this.sortType,
      selectedAccountTypes: selectedAccountTypes ?? this.selectedAccountTypes,
      customStartDate: customStartDate ?? this.customStartDate,
      customEndDate: customEndDate ?? this.customEndDate,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMoreTopTransactions:
          isLoadingMoreTopTransactions ?? this.isLoadingMoreTopTransactions,
      error: error,
      dateRangeDisplayText: dateRangeDisplayText ?? this.dateRangeDisplayText,
      overview: overview ?? this.overview,
      trendData: trendData ?? this.trendData,
      categoryBreakdown: categoryBreakdown ?? this.categoryBreakdown,
      topTransactions: topTransactions ?? this.topTransactions,
      cashFlow: cashFlow ?? this.cashFlow,
      healthScore: healthScore ?? this.healthScore,
    );
  }
}

/// Statistics state notifier
@riverpod
class Statistics extends _$Statistics {
  @override
  StatisticsState build() {
    return const StatisticsState();
  }

  /// Load all statistics data
  Future<void> loadStatistics() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final service = ref.read(statisticsServiceProvider);
      // Fetch all data in parallel
      final results = await Future.wait([
        service.getOverview(
          timeRange: state.timeRange,
          startDate: state.customStartDate,
          endDate: state.customEndDate,
          accountTypes: state.selectedAccountTypes.isNotEmpty
              ? state.selectedAccountTypes
              : null,
        ),
        service.getTrendData(
          timeRange: state.timeRange,
          chartType: state.chartType,
          startDate: state.customStartDate,
          endDate: state.customEndDate,
          accountTypes: state.selectedAccountTypes.isNotEmpty
              ? state.selectedAccountTypes
              : null,
        ),
        service.getCategoryBreakdown(
          timeRange: state.timeRange,
          startDate: state.customStartDate,
          endDate: state.customEndDate,
          accountTypes: state.selectedAccountTypes.isNotEmpty
              ? state.selectedAccountTypes
              : null,
        ),
        service.getTopTransactions(
          timeRange: state.timeRange,
          sortBy: state.sortType,
          startDate: state.customStartDate,
          endDate: state.customEndDate,
          accountTypes: state.selectedAccountTypes.isNotEmpty
              ? state.selectedAccountTypes
              : null,
          page: 1,
          pageSize: 15,
        ),
        service.getCashFlow(
          timeRange: state.timeRange.name,
          startDate: state.customStartDate?.toIso8601String(),
          endDate: state.customEndDate?.toIso8601String(),
          accountTypes: state.selectedAccountTypes.isNotEmpty
              ? state.selectedAccountTypes
              : null,
        ),
        service.getHealthScore(
          timeRange: state.timeRange.name,
          startDate: state.customStartDate?.toIso8601String(),
          endDate: state.customEndDate?.toIso8601String(),
          accountTypes: state.selectedAccountTypes.isNotEmpty
              ? state.selectedAccountTypes
              : null,
        ),
      ]);

      state = state.copyWith(
        isLoading: false,
        overview: results[0] as StatisticsOverview,
        trendData: results[1] as TrendDataResponse,
        categoryBreakdown: results[2] as CategoryBreakdownResponse,
        topTransactions: results[3] as TopTransactionsResponse,
        cashFlow: results[4] as CashFlowAnalysis,
        healthScore: results[5] as HealthScore,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Change time range and reload data
  Future<void> setTimeRange(
    TimeRange timeRange, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    String? displayText;
    if (timeRange == TimeRange.custom && startDate != null && endDate != null) {
      final format = DateFormat('yyyy.MM.dd');
      displayText = '${format.format(startDate)} - ${format.format(endDate)}';
    }
    state = state.copyWith(
      timeRange: timeRange,
      customStartDate: startDate,
      customEndDate: endDate,
      dateRangeDisplayText: displayText,
    );
    await loadStatistics();
  }

  /// Change chart type and reload trend data
  Future<void> setChartType(ChartType chartType) async {
    state = state.copyWith(chartType: chartType);
    try {
      final service = ref.read(statisticsServiceProvider);
      final trendData = await service.getTrendData(
        timeRange: state.timeRange,
        chartType: chartType,
        startDate: state.customStartDate,
        endDate: state.customEndDate,
        accountTypes: state.selectedAccountTypes.isNotEmpty
            ? state.selectedAccountTypes
            : null,
      );
      state = state.copyWith(trendData: trendData);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Change sort type and reload top transactions
  Future<void> setSortType(SortType sortType) async {
    state = state.copyWith(sortType: sortType);
    try {
      final service = ref.read(statisticsServiceProvider);
      final topTransactions = await service.getTopTransactions(
        timeRange: state.timeRange,
        sortBy: sortType,
        startDate: state.customStartDate,
        endDate: state.customEndDate,
        accountTypes: state.selectedAccountTypes.isNotEmpty
            ? state.selectedAccountTypes
            : null,
        page: 1,
        pageSize: 15,
      );
      state = state.copyWith(topTransactions: topTransactions);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Set account type filters and reload data
  Future<void> setAccountTypes(List<String> accountTypes) async {
    state = state.copyWith(selectedAccountTypes: accountTypes);
    await loadStatistics();
  }

  /// 加载更多大额交易
  Future<void> loadMoreTopTransactions() async {
    if (state.isLoadingMoreTopTransactions ||
        state.topTransactions == null ||
        !state.topTransactions!.hasMore) {
      return;
    }

    state = state.copyWith(isLoadingMoreTopTransactions: true);

    try {
      final service = ref.read(statisticsServiceProvider);
      final nextPage = (state.topTransactions?.page ?? 1) + 1;

      final result = await service.getTopTransactions(
        timeRange: state.timeRange,
        sortBy: state.sortType,
        startDate: state.customStartDate,
        endDate: state.customEndDate,
        accountTypes: state.selectedAccountTypes.isNotEmpty
            ? state.selectedAccountTypes
            : null,
        page: nextPage,
        pageSize: state.topTransactions?.pageSize ?? 15,
      );

      state = state.copyWith(
        topTransactions: result.copyWith(
          items: [...state.topTransactions!.items, ...result.items],
        ),
        isLoadingMoreTopTransactions: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMoreTopTransactions: false);
      // TODO: Handle error
    }
  }
}
