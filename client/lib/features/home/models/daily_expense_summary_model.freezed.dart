// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_expense_summary_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DailyExpenseSummaryModel {

@JsonKey(fromJson: DateTime.parse, toJson: _dateTimeToIso8601String) DateTime get date; double get totalExpense;@JsonKey(fromJson: _heatLevelFromString, toJson: _heatLevelToString) ExpenseHeatLevel get heatLevel;
/// Create a copy of DailyExpenseSummaryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyExpenseSummaryModelCopyWith<DailyExpenseSummaryModel> get copyWith => _$DailyExpenseSummaryModelCopyWithImpl<DailyExpenseSummaryModel>(this as DailyExpenseSummaryModel, _$identity);

  /// Serializes this DailyExpenseSummaryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyExpenseSummaryModel&&(identical(other.date, date) || other.date == date)&&(identical(other.totalExpense, totalExpense) || other.totalExpense == totalExpense)&&(identical(other.heatLevel, heatLevel) || other.heatLevel == heatLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,totalExpense,heatLevel);

@override
String toString() {
  return 'DailyExpenseSummaryModel(date: $date, totalExpense: $totalExpense, heatLevel: $heatLevel)';
}


}

/// @nodoc
abstract mixin class $DailyExpenseSummaryModelCopyWith<$Res>  {
  factory $DailyExpenseSummaryModelCopyWith(DailyExpenseSummaryModel value, $Res Function(DailyExpenseSummaryModel) _then) = _$DailyExpenseSummaryModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: DateTime.parse, toJson: _dateTimeToIso8601String) DateTime date, double totalExpense,@JsonKey(fromJson: _heatLevelFromString, toJson: _heatLevelToString) ExpenseHeatLevel heatLevel
});




}
/// @nodoc
class _$DailyExpenseSummaryModelCopyWithImpl<$Res>
    implements $DailyExpenseSummaryModelCopyWith<$Res> {
  _$DailyExpenseSummaryModelCopyWithImpl(this._self, this._then);

  final DailyExpenseSummaryModel _self;
  final $Res Function(DailyExpenseSummaryModel) _then;

/// Create a copy of DailyExpenseSummaryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? totalExpense = null,Object? heatLevel = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,totalExpense: null == totalExpense ? _self.totalExpense : totalExpense // ignore: cast_nullable_to_non_nullable
as double,heatLevel: null == heatLevel ? _self.heatLevel : heatLevel // ignore: cast_nullable_to_non_nullable
as ExpenseHeatLevel,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyExpenseSummaryModel].
extension DailyExpenseSummaryModelPatterns on DailyExpenseSummaryModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyExpenseSummaryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyExpenseSummaryModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyExpenseSummaryModel value)  $default,){
final _that = this;
switch (_that) {
case _DailyExpenseSummaryModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyExpenseSummaryModel value)?  $default,){
final _that = this;
switch (_that) {
case _DailyExpenseSummaryModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: DateTime.parse, toJson: _dateTimeToIso8601String)  DateTime date,  double totalExpense, @JsonKey(fromJson: _heatLevelFromString, toJson: _heatLevelToString)  ExpenseHeatLevel heatLevel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyExpenseSummaryModel() when $default != null:
return $default(_that.date,_that.totalExpense,_that.heatLevel);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: DateTime.parse, toJson: _dateTimeToIso8601String)  DateTime date,  double totalExpense, @JsonKey(fromJson: _heatLevelFromString, toJson: _heatLevelToString)  ExpenseHeatLevel heatLevel)  $default,) {final _that = this;
switch (_that) {
case _DailyExpenseSummaryModel():
return $default(_that.date,_that.totalExpense,_that.heatLevel);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: DateTime.parse, toJson: _dateTimeToIso8601String)  DateTime date,  double totalExpense, @JsonKey(fromJson: _heatLevelFromString, toJson: _heatLevelToString)  ExpenseHeatLevel heatLevel)?  $default,) {final _that = this;
switch (_that) {
case _DailyExpenseSummaryModel() when $default != null:
return $default(_that.date,_that.totalExpense,_that.heatLevel);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _DailyExpenseSummaryModel extends DailyExpenseSummaryModel {
  const _DailyExpenseSummaryModel({@JsonKey(fromJson: DateTime.parse, toJson: _dateTimeToIso8601String) required this.date, required this.totalExpense, @JsonKey(fromJson: _heatLevelFromString, toJson: _heatLevelToString) required this.heatLevel}): super._();
  factory _DailyExpenseSummaryModel.fromJson(Map<String, dynamic> json) => _$DailyExpenseSummaryModelFromJson(json);

@override@JsonKey(fromJson: DateTime.parse, toJson: _dateTimeToIso8601String) final  DateTime date;
@override final  double totalExpense;
@override@JsonKey(fromJson: _heatLevelFromString, toJson: _heatLevelToString) final  ExpenseHeatLevel heatLevel;

/// Create a copy of DailyExpenseSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyExpenseSummaryModelCopyWith<_DailyExpenseSummaryModel> get copyWith => __$DailyExpenseSummaryModelCopyWithImpl<_DailyExpenseSummaryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyExpenseSummaryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyExpenseSummaryModel&&(identical(other.date, date) || other.date == date)&&(identical(other.totalExpense, totalExpense) || other.totalExpense == totalExpense)&&(identical(other.heatLevel, heatLevel) || other.heatLevel == heatLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,totalExpense,heatLevel);

@override
String toString() {
  return 'DailyExpenseSummaryModel(date: $date, totalExpense: $totalExpense, heatLevel: $heatLevel)';
}


}

/// @nodoc
abstract mixin class _$DailyExpenseSummaryModelCopyWith<$Res> implements $DailyExpenseSummaryModelCopyWith<$Res> {
  factory _$DailyExpenseSummaryModelCopyWith(_DailyExpenseSummaryModel value, $Res Function(_DailyExpenseSummaryModel) _then) = __$DailyExpenseSummaryModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: DateTime.parse, toJson: _dateTimeToIso8601String) DateTime date, double totalExpense,@JsonKey(fromJson: _heatLevelFromString, toJson: _heatLevelToString) ExpenseHeatLevel heatLevel
});




}
/// @nodoc
class __$DailyExpenseSummaryModelCopyWithImpl<$Res>
    implements _$DailyExpenseSummaryModelCopyWith<$Res> {
  __$DailyExpenseSummaryModelCopyWithImpl(this._self, this._then);

  final _DailyExpenseSummaryModel _self;
  final $Res Function(_DailyExpenseSummaryModel) _then;

/// Create a copy of DailyExpenseSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? totalExpense = null,Object? heatLevel = null,}) {
  return _then(_DailyExpenseSummaryModel(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,totalExpense: null == totalExpense ? _self.totalExpense : totalExpense // ignore: cast_nullable_to_non_nullable
as double,heatLevel: null == heatLevel ? _self.heatLevel : heatLevel // ignore: cast_nullable_to_non_nullable
as ExpenseHeatLevel,
  ));
}


}


/// @nodoc
mixin _$CalendarMonthData {

 int get year; int get month; double get totalExpenseForMonth; List<DailyExpenseSummaryModel> get dailySummaries; List<String>? get trendColors;
/// Create a copy of CalendarMonthData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalendarMonthDataCopyWith<CalendarMonthData> get copyWith => _$CalendarMonthDataCopyWithImpl<CalendarMonthData>(this as CalendarMonthData, _$identity);

  /// Serializes this CalendarMonthData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalendarMonthData&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.totalExpenseForMonth, totalExpenseForMonth) || other.totalExpenseForMonth == totalExpenseForMonth)&&const DeepCollectionEquality().equals(other.dailySummaries, dailySummaries)&&const DeepCollectionEquality().equals(other.trendColors, trendColors));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,year,month,totalExpenseForMonth,const DeepCollectionEquality().hash(dailySummaries),const DeepCollectionEquality().hash(trendColors));

@override
String toString() {
  return 'CalendarMonthData(year: $year, month: $month, totalExpenseForMonth: $totalExpenseForMonth, dailySummaries: $dailySummaries, trendColors: $trendColors)';
}


}

/// @nodoc
abstract mixin class $CalendarMonthDataCopyWith<$Res>  {
  factory $CalendarMonthDataCopyWith(CalendarMonthData value, $Res Function(CalendarMonthData) _then) = _$CalendarMonthDataCopyWithImpl;
@useResult
$Res call({
 int year, int month, double totalExpenseForMonth, List<DailyExpenseSummaryModel> dailySummaries, List<String>? trendColors
});




}
/// @nodoc
class _$CalendarMonthDataCopyWithImpl<$Res>
    implements $CalendarMonthDataCopyWith<$Res> {
  _$CalendarMonthDataCopyWithImpl(this._self, this._then);

  final CalendarMonthData _self;
  final $Res Function(CalendarMonthData) _then;

/// Create a copy of CalendarMonthData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? year = null,Object? month = null,Object? totalExpenseForMonth = null,Object? dailySummaries = null,Object? trendColors = freezed,}) {
  return _then(_self.copyWith(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,totalExpenseForMonth: null == totalExpenseForMonth ? _self.totalExpenseForMonth : totalExpenseForMonth // ignore: cast_nullable_to_non_nullable
as double,dailySummaries: null == dailySummaries ? _self.dailySummaries : dailySummaries // ignore: cast_nullable_to_non_nullable
as List<DailyExpenseSummaryModel>,trendColors: freezed == trendColors ? _self.trendColors : trendColors // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [CalendarMonthData].
extension CalendarMonthDataPatterns on CalendarMonthData {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CalendarMonthData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CalendarMonthData() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CalendarMonthData value)  $default,){
final _that = this;
switch (_that) {
case _CalendarMonthData():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CalendarMonthData value)?  $default,){
final _that = this;
switch (_that) {
case _CalendarMonthData() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int year,  int month,  double totalExpenseForMonth,  List<DailyExpenseSummaryModel> dailySummaries,  List<String>? trendColors)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CalendarMonthData() when $default != null:
return $default(_that.year,_that.month,_that.totalExpenseForMonth,_that.dailySummaries,_that.trendColors);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int year,  int month,  double totalExpenseForMonth,  List<DailyExpenseSummaryModel> dailySummaries,  List<String>? trendColors)  $default,) {final _that = this;
switch (_that) {
case _CalendarMonthData():
return $default(_that.year,_that.month,_that.totalExpenseForMonth,_that.dailySummaries,_that.trendColors);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int year,  int month,  double totalExpenseForMonth,  List<DailyExpenseSummaryModel> dailySummaries,  List<String>? trendColors)?  $default,) {final _that = this;
switch (_that) {
case _CalendarMonthData() when $default != null:
return $default(_that.year,_that.month,_that.totalExpenseForMonth,_that.dailySummaries,_that.trendColors);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CalendarMonthData implements CalendarMonthData {
  const _CalendarMonthData({required this.year, required this.month, required this.totalExpenseForMonth, required final  List<DailyExpenseSummaryModel> dailySummaries, final  List<String>? trendColors}): _dailySummaries = dailySummaries,_trendColors = trendColors;
  factory _CalendarMonthData.fromJson(Map<String, dynamic> json) => _$CalendarMonthDataFromJson(json);

@override final  int year;
@override final  int month;
@override final  double totalExpenseForMonth;
 final  List<DailyExpenseSummaryModel> _dailySummaries;
@override List<DailyExpenseSummaryModel> get dailySummaries {
  if (_dailySummaries is EqualUnmodifiableListView) return _dailySummaries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dailySummaries);
}

 final  List<String>? _trendColors;
@override List<String>? get trendColors {
  final value = _trendColors;
  if (value == null) return null;
  if (_trendColors is EqualUnmodifiableListView) return _trendColors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of CalendarMonthData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalendarMonthDataCopyWith<_CalendarMonthData> get copyWith => __$CalendarMonthDataCopyWithImpl<_CalendarMonthData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CalendarMonthDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CalendarMonthData&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.totalExpenseForMonth, totalExpenseForMonth) || other.totalExpenseForMonth == totalExpenseForMonth)&&const DeepCollectionEquality().equals(other._dailySummaries, _dailySummaries)&&const DeepCollectionEquality().equals(other._trendColors, _trendColors));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,year,month,totalExpenseForMonth,const DeepCollectionEquality().hash(_dailySummaries),const DeepCollectionEquality().hash(_trendColors));

@override
String toString() {
  return 'CalendarMonthData(year: $year, month: $month, totalExpenseForMonth: $totalExpenseForMonth, dailySummaries: $dailySummaries, trendColors: $trendColors)';
}


}

/// @nodoc
abstract mixin class _$CalendarMonthDataCopyWith<$Res> implements $CalendarMonthDataCopyWith<$Res> {
  factory _$CalendarMonthDataCopyWith(_CalendarMonthData value, $Res Function(_CalendarMonthData) _then) = __$CalendarMonthDataCopyWithImpl;
@override @useResult
$Res call({
 int year, int month, double totalExpenseForMonth, List<DailyExpenseSummaryModel> dailySummaries, List<String>? trendColors
});




}
/// @nodoc
class __$CalendarMonthDataCopyWithImpl<$Res>
    implements _$CalendarMonthDataCopyWith<$Res> {
  __$CalendarMonthDataCopyWithImpl(this._self, this._then);

  final _CalendarMonthData _self;
  final $Res Function(_CalendarMonthData) _then;

/// Create a copy of CalendarMonthData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? year = null,Object? month = null,Object? totalExpenseForMonth = null,Object? dailySummaries = null,Object? trendColors = freezed,}) {
  return _then(_CalendarMonthData(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,totalExpenseForMonth: null == totalExpenseForMonth ? _self.totalExpenseForMonth : totalExpenseForMonth // ignore: cast_nullable_to_non_nullable
as double,dailySummaries: null == dailySummaries ? _self._dailySummaries : dailySummaries // ignore: cast_nullable_to_non_nullable
as List<DailyExpenseSummaryModel>,trendColors: freezed == trendColors ? _self._trendColors : trendColors // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

// dart format on
