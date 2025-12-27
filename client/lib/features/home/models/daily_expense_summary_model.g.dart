// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_expense_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DailyExpenseSummaryModel _$DailyExpenseSummaryModelFromJson(
  Map<String, dynamic> json,
) => _DailyExpenseSummaryModel(
  date: DateTime.parse(json['date'] as String),
  totalExpense: (json['totalExpense'] as num).toDouble(),
  heatLevel: _heatLevelFromString(json['heatLevel'] as String?),
);

Map<String, dynamic> _$DailyExpenseSummaryModelToJson(
  _DailyExpenseSummaryModel instance,
) => <String, dynamic>{
  'date': _dateTimeToIso8601String(instance.date),
  'totalExpense': instance.totalExpense,
  'heatLevel': _heatLevelToString(instance.heatLevel),
};

_CalendarMonthData _$CalendarMonthDataFromJson(Map<String, dynamic> json) =>
    _CalendarMonthData(
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      totalExpenseForMonth: (json['totalExpenseForMonth'] as num).toDouble(),
      dailySummaries: (json['dailySummaries'] as List<dynamic>)
          .map(
            (e) => DailyExpenseSummaryModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      trendColors: (json['trendColors'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$CalendarMonthDataToJson(_CalendarMonthData instance) =>
    <String, dynamic>{
      'year': instance.year,
      'month': instance.month,
      'totalExpenseForMonth': instance.totalExpenseForMonth,
      'dailySummaries': instance.dailySummaries,
      'trendColors': instance.trendColors,
    };
