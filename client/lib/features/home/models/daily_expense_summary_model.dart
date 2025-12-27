// features/home/models/daily_expense_summary_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_expense_summary_model.freezed.dart';
part 'daily_expense_summary_model.g.dart';

enum ExpenseHeatLevel { none, low, medium, high, veryHigh }

// Helper function: Convert string to ExpenseHeatLevel enum
ExpenseHeatLevel _heatLevelFromString(String? levelStr) {
  switch (levelStr?.toLowerCase()) {
    case 'low':
      return ExpenseHeatLevel.low;
    case 'medium':
      return ExpenseHeatLevel.medium;
    case 'high':
      return ExpenseHeatLevel.high;
    case 'veryHigh':
      return ExpenseHeatLevel
          .veryHigh; // Backend might return veryHigh or very_high
    case 'none':
    default:
      return ExpenseHeatLevel.none;
  }
}

// Helper function: Convert ExpenseHeatLevel enum to string
String _heatLevelToString(ExpenseHeatLevel level) =>
    level.toString().split('.').last;

// Date toJson helper function
String _dateTimeToIso8601String(DateTime dt) {
  return dt.toIso8601String().substring(0, 10); // YYYY-MM-DD
}

@freezed
abstract class DailyExpenseSummaryModel with _$DailyExpenseSummaryModel {
  const DailyExpenseSummaryModel._();

  @JsonSerializable(
    explicitToJson: true,
  ) // Ensure toJson methods are also correctly generated
  const factory DailyExpenseSummaryModel({
    @JsonKey(
      fromJson: DateTime.parse,
      toJson: _dateTimeToIso8601String,
    ) // Handle date serialization
    required DateTime date,
    required double totalExpense,
    @JsonKey(
      fromJson: _heatLevelFromString,
      toJson: _heatLevelToString,
    ) // Handle enum serialization
    required ExpenseHeatLevel heatLevel,
  }) = _DailyExpenseSummaryModel;

  factory DailyExpenseSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$DailyExpenseSummaryModelFromJson(json);
}

// Calendar data model for a whole month
@freezed
abstract class CalendarMonthData with _$CalendarMonthData {
  const factory CalendarMonthData({
    required int year,
    required int month,
    required double totalExpenseForMonth,
    required List<DailyExpenseSummaryModel> dailySummaries,
    List<String>? trendColors, // 可选
  }) = _CalendarMonthData;

  factory CalendarMonthData.fromJson(Map<String, dynamic> json) =>
      _$CalendarMonthDataFromJson(json);
}
