// features/home/models/total_expense_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'total_expense_model.freezed.dart';
part 'total_expense_model.g.dart';

/// Amount display information
@freezed
abstract class TotalExpenseDisplay with _$TotalExpenseDisplay {
  const factory TotalExpenseDisplay({
    required String value,
    @JsonKey(name: 'currencySymbol') required String currencySymbol,
    @JsonKey(name: 'fullString') required String fullString,
  }) = _TotalExpenseDisplay;

  factory TotalExpenseDisplay.fromJson(Map<String, dynamic> json) =>
      _$TotalExpenseDisplayFromJson(json);
}

/// Total expense data model
@freezed
abstract class TotalExpenseData with _$TotalExpenseData {
  const factory TotalExpenseData({
    @JsonKey(name: 'total_expense') required double totalExpense,
    @JsonKey(name: 'today_expense') required double todayExpense,
    @JsonKey(name: 'month_expense') required double monthExpense,
    @JsonKey(name: 'year_expense') required double yearExpense,
    required String currency,
    TotalExpenseDisplay? display,
  }) = _TotalExpenseData;

  factory TotalExpenseData.fromJson(Map<String, dynamic> json) =>
      _$TotalExpenseDataFromJson(json);
}
