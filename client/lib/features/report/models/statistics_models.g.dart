// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StatisticsOverview _$StatisticsOverviewFromJson(Map<String, dynamic> json) =>
    _StatisticsOverview(
      totalBalance: json['totalBalance'] as String,
      totalIncome: json['totalIncome'] as String,
      totalExpense: json['totalExpense'] as String,
      incomeChangePercent: (json['incomeChangePercent'] as num).toDouble(),
      expenseChangePercent: (json['expenseChangePercent'] as num).toDouble(),
      netChangePercent: (json['netChangePercent'] as num).toDouble(),
      balanceNote: json['balanceNote'] as String? ?? "",
      periodStart: DateTime.parse(json['periodStart'] as String),
      periodEnd: DateTime.parse(json['periodEnd'] as String),
    );

Map<String, dynamic> _$StatisticsOverviewToJson(_StatisticsOverview instance) =>
    <String, dynamic>{
      'totalBalance': instance.totalBalance,
      'totalIncome': instance.totalIncome,
      'totalExpense': instance.totalExpense,
      'incomeChangePercent': instance.incomeChangePercent,
      'expenseChangePercent': instance.expenseChangePercent,
      'netChangePercent': instance.netChangePercent,
      'balanceNote': instance.balanceNote,
      'periodStart': instance.periodStart.toIso8601String(),
      'periodEnd': instance.periodEnd.toIso8601String(),
    };

_TrendDataPoint _$TrendDataPointFromJson(Map<String, dynamic> json) =>
    _TrendDataPoint(
      date: json['date'] as String,
      amount: json['amount'] as String,
      label: json['label'] as String,
    );

Map<String, dynamic> _$TrendDataPointToJson(_TrendDataPoint instance) =>
    <String, dynamic>{
      'date': instance.date,
      'amount': instance.amount,
      'label': instance.label,
    };

_TrendDataResponse _$TrendDataResponseFromJson(Map<String, dynamic> json) =>
    _TrendDataResponse(
      dataPoints: (json['dataPoints'] as List<dynamic>)
          .map((e) => TrendDataPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      timeRange: json['timeRange'] as String,
      transactionType: json['transactionType'] as String,
    );

Map<String, dynamic> _$TrendDataResponseToJson(_TrendDataResponse instance) =>
    <String, dynamic>{
      'dataPoints': instance.dataPoints,
      'timeRange': instance.timeRange,
      'transactionType': instance.transactionType,
    };

_CategoryBreakdownItem _$CategoryBreakdownItemFromJson(
  Map<String, dynamic> json,
) => _CategoryBreakdownItem(
  categoryKey: json['categoryKey'] as String,
  categoryName: json['categoryName'] as String,
  amount: json['amount'] as String,
  percentage: (json['percentage'] as num).toDouble(),
  color: json['color'] as String,
  icon: json['icon'] as String,
);

Map<String, dynamic> _$CategoryBreakdownItemToJson(
  _CategoryBreakdownItem instance,
) => <String, dynamic>{
  'categoryKey': instance.categoryKey,
  'categoryName': instance.categoryName,
  'amount': instance.amount,
  'percentage': instance.percentage,
  'color': instance.color,
  'icon': instance.icon,
};

_CategoryBreakdownResponse _$CategoryBreakdownResponseFromJson(
  Map<String, dynamic> json,
) => _CategoryBreakdownResponse(
  items: (json['items'] as List<dynamic>)
      .map((e) => CategoryBreakdownItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: json['total'] as String,
);

Map<String, dynamic> _$CategoryBreakdownResponseToJson(
  _CategoryBreakdownResponse instance,
) => <String, dynamic>{'items': instance.items, 'total': instance.total};

_TopTransactionItem _$TopTransactionItemFromJson(Map<String, dynamic> json) =>
    _TopTransactionItem(
      id: json['id'] as String,
      description: json['description'] as String,
      amount: json['amount'] as String,
      categoryKey: json['categoryKey'] as String,
      categoryName: json['categoryName'] as String,
      transactionAt: DateTime.parse(json['transactionAt'] as String),
      icon: json['icon'] as String,
    );

Map<String, dynamic> _$TopTransactionItemToJson(_TopTransactionItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'amount': instance.amount,
      'categoryKey': instance.categoryKey,
      'categoryName': instance.categoryName,
      'transactionAt': instance.transactionAt.toIso8601String(),
      'icon': instance.icon,
    };

_TopTransactionsResponse _$TopTransactionsResponseFromJson(
  Map<String, dynamic> json,
) => _TopTransactionsResponse(
  items: (json['items'] as List<dynamic>)
      .map((e) => TopTransactionItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  sortBy: json['sortBy'] as String,
  total: (json['total'] as num).toInt(),
  page: (json['page'] as num?)?.toInt() ?? 1,
  pageSize: (json['pageSize'] as num?)?.toInt() ?? 10,
  hasMore: json['hasMore'] as bool? ?? false,
);

Map<String, dynamic> _$TopTransactionsResponseToJson(
  _TopTransactionsResponse instance,
) => <String, dynamic>{
  'items': instance.items,
  'sortBy': instance.sortBy,
  'total': instance.total,
  'page': instance.page,
  'pageSize': instance.pageSize,
  'hasMore': instance.hasMore,
};

_StatisticsQuery _$StatisticsQueryFromJson(Map<String, dynamic> json) =>
    _StatisticsQuery(
      timeRange:
          $enumDecodeNullable(_$TimeRangeEnumMap, json['timeRange']) ??
          TimeRange.month,
      chartType:
          $enumDecodeNullable(_$ChartTypeEnumMap, json['chartType']) ??
          ChartType.expense,
      sortType:
          $enumDecodeNullable(_$SortTypeEnumMap, json['sortType']) ??
          SortType.amount,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      accountTypes:
          (json['accountTypes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$StatisticsQueryToJson(_StatisticsQuery instance) =>
    <String, dynamic>{
      'timeRange': _$TimeRangeEnumMap[instance.timeRange]!,
      'chartType': _$ChartTypeEnumMap[instance.chartType]!,
      'sortType': _$SortTypeEnumMap[instance.sortType]!,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'accountTypes': instance.accountTypes,
    };

const _$TimeRangeEnumMap = {
  TimeRange.week: 'week',
  TimeRange.month: 'month',
  TimeRange.year: 'year',
  TimeRange.custom: 'custom',
};

const _$ChartTypeEnumMap = {
  ChartType.expense: 'expense',
  ChartType.income: 'income',
};

const _$SortTypeEnumMap = {SortType.amount: 'amount', SortType.date: 'date'};

_CashFlowAnalysis _$CashFlowAnalysisFromJson(Map<String, dynamic> json) =>
    _CashFlowAnalysis(
      totalIncome: json['totalIncome'] as String,
      totalExpense: json['totalExpense'] as String,
      netCashFlow: json['netCashFlow'] as String,
      savingsRate: (json['savingsRate'] as num).toDouble(),
      expenseToIncomeRatio: (json['expenseToIncomeRatio'] as num).toDouble(),
      essentialExpenseRatio:
          (json['essentialExpenseRatio'] as num?)?.toDouble() ?? 0.0,
      discretionaryExpenseRatio:
          (json['discretionaryExpenseRatio'] as num?)?.toDouble() ?? 0.0,
      incomeChangePercent: (json['incomeChangePercent'] as num).toDouble(),
      expenseChangePercent: (json['expenseChangePercent'] as num).toDouble(),
      savingsRateChange: (json['savingsRateChange'] as num).toDouble(),
      periodStart: DateTime.parse(json['periodStart'] as String),
      periodEnd: DateTime.parse(json['periodEnd'] as String),
    );

Map<String, dynamic> _$CashFlowAnalysisToJson(_CashFlowAnalysis instance) =>
    <String, dynamic>{
      'totalIncome': instance.totalIncome,
      'totalExpense': instance.totalExpense,
      'netCashFlow': instance.netCashFlow,
      'savingsRate': instance.savingsRate,
      'expenseToIncomeRatio': instance.expenseToIncomeRatio,
      'essentialExpenseRatio': instance.essentialExpenseRatio,
      'discretionaryExpenseRatio': instance.discretionaryExpenseRatio,
      'incomeChangePercent': instance.incomeChangePercent,
      'expenseChangePercent': instance.expenseChangePercent,
      'savingsRateChange': instance.savingsRateChange,
      'periodStart': instance.periodStart.toIso8601String(),
      'periodEnd': instance.periodEnd.toIso8601String(),
    };

_HealthScoreDimension _$HealthScoreDimensionFromJson(
  Map<String, dynamic> json,
) => _HealthScoreDimension(
  name: json['name'] as String,
  score: (json['score'] as num).toInt(),
  weight: (json['weight'] as num).toDouble(),
  description: json['description'] as String,
  status: json['status'] as String,
);

Map<String, dynamic> _$HealthScoreDimensionToJson(
  _HealthScoreDimension instance,
) => <String, dynamic>{
  'name': instance.name,
  'score': instance.score,
  'weight': instance.weight,
  'description': instance.description,
  'status': instance.status,
};

_HealthScore _$HealthScoreFromJson(Map<String, dynamic> json) => _HealthScore(
  totalScore: (json['totalScore'] as num).toInt(),
  grade: json['grade'] as String,
  dimensions: (json['dimensions'] as List<dynamic>)
      .map((e) => HealthScoreDimension.fromJson(e as Map<String, dynamic>))
      .toList(),
  suggestions:
      (json['suggestions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  periodStart: DateTime.parse(json['periodStart'] as String),
  periodEnd: DateTime.parse(json['periodEnd'] as String),
);

Map<String, dynamic> _$HealthScoreToJson(_HealthScore instance) =>
    <String, dynamic>{
      'totalScore': instance.totalScore,
      'grade': instance.grade,
      'dimensions': instance.dimensions,
      'suggestions': instance.suggestions,
      'periodStart': instance.periodStart.toIso8601String(),
      'periodEnd': instance.periodEnd.toIso8601String(),
    };
