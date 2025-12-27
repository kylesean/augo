import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../i18n/strings.g.dart';

part 'statistics_models.freezed.dart';
part 'statistics_models.g.dart';

/// Time range options for statistics
enum TimeRange {
  @JsonValue('week')
  week,
  @JsonValue('month')
  month,
  @JsonValue('year')
  year,
  @JsonValue('custom')
  custom;

  String get label {
    switch (this) {
      case TimeRange.week:
        return t.time.thisWeek;
      case TimeRange.month:
        return t.time.thisMonth;
      case TimeRange.year:
        return t.time.thisYear;
      case TimeRange.custom:
        return t.dateRange.custom;
    }
  }
}

/// Chart type for trend chart
enum ChartType {
  @JsonValue('expense')
  expense,
  @JsonValue('income')
  income;

  String get label {
    switch (this) {
      case ChartType.expense:
        return t.transaction.expense;
      case ChartType.income:
        return t.transaction.income;
    }
  }
}

/// Sort type for top transactions
enum SortType {
  @JsonValue('amount')
  amount,
  @JsonValue('date')
  date;

  String get label {
    switch (this) {
      case SortType.amount:
        return t.statistics.sort.amount;
      case SortType.date:
        return t.statistics.sort.date;
    }
  }
}

/// Statistics overview response
@freezed
abstract class StatisticsOverview with _$StatisticsOverview {
  const factory StatisticsOverview({
    required String totalBalance,
    required String totalIncome,
    required String totalExpense,
    required double incomeChangePercent,
    required double expenseChangePercent,
    required double netChangePercent,
    @Default("") String balanceNote,
    required DateTime periodStart,
    required DateTime periodEnd,
  }) = _StatisticsOverview;

  factory StatisticsOverview.fromJson(Map<String, dynamic> json) =>
      _$StatisticsOverviewFromJson(json);
}

/// Trend data point for chart
@freezed
abstract class TrendDataPoint with _$TrendDataPoint {
  const factory TrendDataPoint({
    required String date,
    required String amount,
    required String label,
  }) = _TrendDataPoint;

  factory TrendDataPoint.fromJson(Map<String, dynamic> json) =>
      _$TrendDataPointFromJson(json);
}

/// Trend data response
@freezed
abstract class TrendDataResponse with _$TrendDataResponse {
  const factory TrendDataResponse({
    required List<TrendDataPoint> dataPoints,
    required String timeRange,
    required String transactionType,
  }) = _TrendDataResponse;

  factory TrendDataResponse.fromJson(Map<String, dynamic> json) =>
      _$TrendDataResponseFromJson(json);
}

/// Category breakdown item
@freezed
abstract class CategoryBreakdownItem with _$CategoryBreakdownItem {
  const factory CategoryBreakdownItem({
    required String categoryKey,
    required String categoryName,
    required String amount,
    required double percentage,
    required String color,
    required String icon,
  }) = _CategoryBreakdownItem;

  factory CategoryBreakdownItem.fromJson(Map<String, dynamic> json) =>
      _$CategoryBreakdownItemFromJson(json);
}

/// Category breakdown response
@freezed
abstract class CategoryBreakdownResponse with _$CategoryBreakdownResponse {
  const factory CategoryBreakdownResponse({
    required List<CategoryBreakdownItem> items,
    required String total,
  }) = _CategoryBreakdownResponse;

  factory CategoryBreakdownResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoryBreakdownResponseFromJson(json);
}

/// Top transaction item
@freezed
abstract class TopTransactionItem with _$TopTransactionItem {
  const factory TopTransactionItem({
    required String id,
    required String description,
    required String amount,
    required String categoryKey,
    required String categoryName,
    required DateTime transactionAt,
    required String icon,
  }) = _TopTransactionItem;

  factory TopTransactionItem.fromJson(Map<String, dynamic> json) =>
      _$TopTransactionItemFromJson(json);
}

/// Top transactions response
@freezed
abstract class TopTransactionsResponse with _$TopTransactionsResponse {
  const factory TopTransactionsResponse({
    required List<TopTransactionItem> items,
    required String sortBy,
    required int total,
    @Default(1) int page,
    @Default(10) int pageSize,
    @Default(false) bool hasMore,
  }) = _TopTransactionsResponse;

  factory TopTransactionsResponse.fromJson(Map<String, dynamic> json) =>
      _$TopTransactionsResponseFromJson(json);
}

/// Statistics query parameters
@freezed
abstract class StatisticsQuery with _$StatisticsQuery {
  const factory StatisticsQuery({
    @Default(TimeRange.month) TimeRange timeRange,
    @Default(ChartType.expense) ChartType chartType,
    @Default(SortType.amount) SortType sortType,
    DateTime? startDate,
    DateTime? endDate,
    @Default([]) List<String> accountTypes,
  }) = _StatisticsQuery;

  factory StatisticsQuery.fromJson(Map<String, dynamic> json) =>
      _$StatisticsQueryFromJson(json);
}

/// Cash flow analysis response
@freezed
abstract class CashFlowAnalysis with _$CashFlowAnalysis {
  const factory CashFlowAnalysis({
    required String totalIncome,
    required String totalExpense,
    required String netCashFlow,
    required double savingsRate,
    required double expenseToIncomeRatio,
    @Default(0.0) double essentialExpenseRatio,
    @Default(0.0) double discretionaryExpenseRatio,
    required double incomeChangePercent,
    required double expenseChangePercent,
    required double savingsRateChange,
    required DateTime periodStart,
    required DateTime periodEnd,
  }) = _CashFlowAnalysis;

  factory CashFlowAnalysis.fromJson(Map<String, dynamic> json) =>
      _$CashFlowAnalysisFromJson(json);
}

/// Health score dimension
@freezed
abstract class HealthScoreDimension with _$HealthScoreDimension {
  const factory HealthScoreDimension({
    required String name,
    required int score,
    required double weight,
    required String description,
    required String status,
  }) = _HealthScoreDimension;

  factory HealthScoreDimension.fromJson(Map<String, dynamic> json) =>
      _$HealthScoreDimensionFromJson(json);
}

/// Financial health score response
@freezed
abstract class HealthScore with _$HealthScore {
  const factory HealthScore({
    required int totalScore,
    required String grade,
    required List<HealthScoreDimension> dimensions,
    @Default([]) List<String> suggestions,
    required DateTime periodStart,
    required DateTime periodEnd,
  }) = _HealthScore;

  factory HealthScore.fromJson(Map<String, dynamic> json) =>
      _$HealthScoreFromJson(json);
}
