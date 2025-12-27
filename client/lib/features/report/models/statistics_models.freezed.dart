// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'statistics_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StatisticsOverview {

 String get totalBalance; String get totalIncome; String get totalExpense; double get incomeChangePercent; double get expenseChangePercent; double get netChangePercent; String get balanceNote; DateTime get periodStart; DateTime get periodEnd;
/// Create a copy of StatisticsOverview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatisticsOverviewCopyWith<StatisticsOverview> get copyWith => _$StatisticsOverviewCopyWithImpl<StatisticsOverview>(this as StatisticsOverview, _$identity);

  /// Serializes this StatisticsOverview to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatisticsOverview&&(identical(other.totalBalance, totalBalance) || other.totalBalance == totalBalance)&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpense, totalExpense) || other.totalExpense == totalExpense)&&(identical(other.incomeChangePercent, incomeChangePercent) || other.incomeChangePercent == incomeChangePercent)&&(identical(other.expenseChangePercent, expenseChangePercent) || other.expenseChangePercent == expenseChangePercent)&&(identical(other.netChangePercent, netChangePercent) || other.netChangePercent == netChangePercent)&&(identical(other.balanceNote, balanceNote) || other.balanceNote == balanceNote)&&(identical(other.periodStart, periodStart) || other.periodStart == periodStart)&&(identical(other.periodEnd, periodEnd) || other.periodEnd == periodEnd));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalBalance,totalIncome,totalExpense,incomeChangePercent,expenseChangePercent,netChangePercent,balanceNote,periodStart,periodEnd);

@override
String toString() {
  return 'StatisticsOverview(totalBalance: $totalBalance, totalIncome: $totalIncome, totalExpense: $totalExpense, incomeChangePercent: $incomeChangePercent, expenseChangePercent: $expenseChangePercent, netChangePercent: $netChangePercent, balanceNote: $balanceNote, periodStart: $periodStart, periodEnd: $periodEnd)';
}


}

/// @nodoc
abstract mixin class $StatisticsOverviewCopyWith<$Res>  {
  factory $StatisticsOverviewCopyWith(StatisticsOverview value, $Res Function(StatisticsOverview) _then) = _$StatisticsOverviewCopyWithImpl;
@useResult
$Res call({
 String totalBalance, String totalIncome, String totalExpense, double incomeChangePercent, double expenseChangePercent, double netChangePercent, String balanceNote, DateTime periodStart, DateTime periodEnd
});




}
/// @nodoc
class _$StatisticsOverviewCopyWithImpl<$Res>
    implements $StatisticsOverviewCopyWith<$Res> {
  _$StatisticsOverviewCopyWithImpl(this._self, this._then);

  final StatisticsOverview _self;
  final $Res Function(StatisticsOverview) _then;

/// Create a copy of StatisticsOverview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalBalance = null,Object? totalIncome = null,Object? totalExpense = null,Object? incomeChangePercent = null,Object? expenseChangePercent = null,Object? netChangePercent = null,Object? balanceNote = null,Object? periodStart = null,Object? periodEnd = null,}) {
  return _then(_self.copyWith(
totalBalance: null == totalBalance ? _self.totalBalance : totalBalance // ignore: cast_nullable_to_non_nullable
as String,totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as String,totalExpense: null == totalExpense ? _self.totalExpense : totalExpense // ignore: cast_nullable_to_non_nullable
as String,incomeChangePercent: null == incomeChangePercent ? _self.incomeChangePercent : incomeChangePercent // ignore: cast_nullable_to_non_nullable
as double,expenseChangePercent: null == expenseChangePercent ? _self.expenseChangePercent : expenseChangePercent // ignore: cast_nullable_to_non_nullable
as double,netChangePercent: null == netChangePercent ? _self.netChangePercent : netChangePercent // ignore: cast_nullable_to_non_nullable
as double,balanceNote: null == balanceNote ? _self.balanceNote : balanceNote // ignore: cast_nullable_to_non_nullable
as String,periodStart: null == periodStart ? _self.periodStart : periodStart // ignore: cast_nullable_to_non_nullable
as DateTime,periodEnd: null == periodEnd ? _self.periodEnd : periodEnd // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [StatisticsOverview].
extension StatisticsOverviewPatterns on StatisticsOverview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StatisticsOverview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StatisticsOverview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StatisticsOverview value)  $default,){
final _that = this;
switch (_that) {
case _StatisticsOverview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StatisticsOverview value)?  $default,){
final _that = this;
switch (_that) {
case _StatisticsOverview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String totalBalance,  String totalIncome,  String totalExpense,  double incomeChangePercent,  double expenseChangePercent,  double netChangePercent,  String balanceNote,  DateTime periodStart,  DateTime periodEnd)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StatisticsOverview() when $default != null:
return $default(_that.totalBalance,_that.totalIncome,_that.totalExpense,_that.incomeChangePercent,_that.expenseChangePercent,_that.netChangePercent,_that.balanceNote,_that.periodStart,_that.periodEnd);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String totalBalance,  String totalIncome,  String totalExpense,  double incomeChangePercent,  double expenseChangePercent,  double netChangePercent,  String balanceNote,  DateTime periodStart,  DateTime periodEnd)  $default,) {final _that = this;
switch (_that) {
case _StatisticsOverview():
return $default(_that.totalBalance,_that.totalIncome,_that.totalExpense,_that.incomeChangePercent,_that.expenseChangePercent,_that.netChangePercent,_that.balanceNote,_that.periodStart,_that.periodEnd);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String totalBalance,  String totalIncome,  String totalExpense,  double incomeChangePercent,  double expenseChangePercent,  double netChangePercent,  String balanceNote,  DateTime periodStart,  DateTime periodEnd)?  $default,) {final _that = this;
switch (_that) {
case _StatisticsOverview() when $default != null:
return $default(_that.totalBalance,_that.totalIncome,_that.totalExpense,_that.incomeChangePercent,_that.expenseChangePercent,_that.netChangePercent,_that.balanceNote,_that.periodStart,_that.periodEnd);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StatisticsOverview implements StatisticsOverview {
  const _StatisticsOverview({required this.totalBalance, required this.totalIncome, required this.totalExpense, required this.incomeChangePercent, required this.expenseChangePercent, required this.netChangePercent, this.balanceNote = "", required this.periodStart, required this.periodEnd});
  factory _StatisticsOverview.fromJson(Map<String, dynamic> json) => _$StatisticsOverviewFromJson(json);

@override final  String totalBalance;
@override final  String totalIncome;
@override final  String totalExpense;
@override final  double incomeChangePercent;
@override final  double expenseChangePercent;
@override final  double netChangePercent;
@override@JsonKey() final  String balanceNote;
@override final  DateTime periodStart;
@override final  DateTime periodEnd;

/// Create a copy of StatisticsOverview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StatisticsOverviewCopyWith<_StatisticsOverview> get copyWith => __$StatisticsOverviewCopyWithImpl<_StatisticsOverview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StatisticsOverviewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StatisticsOverview&&(identical(other.totalBalance, totalBalance) || other.totalBalance == totalBalance)&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpense, totalExpense) || other.totalExpense == totalExpense)&&(identical(other.incomeChangePercent, incomeChangePercent) || other.incomeChangePercent == incomeChangePercent)&&(identical(other.expenseChangePercent, expenseChangePercent) || other.expenseChangePercent == expenseChangePercent)&&(identical(other.netChangePercent, netChangePercent) || other.netChangePercent == netChangePercent)&&(identical(other.balanceNote, balanceNote) || other.balanceNote == balanceNote)&&(identical(other.periodStart, periodStart) || other.periodStart == periodStart)&&(identical(other.periodEnd, periodEnd) || other.periodEnd == periodEnd));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalBalance,totalIncome,totalExpense,incomeChangePercent,expenseChangePercent,netChangePercent,balanceNote,periodStart,periodEnd);

@override
String toString() {
  return 'StatisticsOverview(totalBalance: $totalBalance, totalIncome: $totalIncome, totalExpense: $totalExpense, incomeChangePercent: $incomeChangePercent, expenseChangePercent: $expenseChangePercent, netChangePercent: $netChangePercent, balanceNote: $balanceNote, periodStart: $periodStart, periodEnd: $periodEnd)';
}


}

/// @nodoc
abstract mixin class _$StatisticsOverviewCopyWith<$Res> implements $StatisticsOverviewCopyWith<$Res> {
  factory _$StatisticsOverviewCopyWith(_StatisticsOverview value, $Res Function(_StatisticsOverview) _then) = __$StatisticsOverviewCopyWithImpl;
@override @useResult
$Res call({
 String totalBalance, String totalIncome, String totalExpense, double incomeChangePercent, double expenseChangePercent, double netChangePercent, String balanceNote, DateTime periodStart, DateTime periodEnd
});




}
/// @nodoc
class __$StatisticsOverviewCopyWithImpl<$Res>
    implements _$StatisticsOverviewCopyWith<$Res> {
  __$StatisticsOverviewCopyWithImpl(this._self, this._then);

  final _StatisticsOverview _self;
  final $Res Function(_StatisticsOverview) _then;

/// Create a copy of StatisticsOverview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalBalance = null,Object? totalIncome = null,Object? totalExpense = null,Object? incomeChangePercent = null,Object? expenseChangePercent = null,Object? netChangePercent = null,Object? balanceNote = null,Object? periodStart = null,Object? periodEnd = null,}) {
  return _then(_StatisticsOverview(
totalBalance: null == totalBalance ? _self.totalBalance : totalBalance // ignore: cast_nullable_to_non_nullable
as String,totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as String,totalExpense: null == totalExpense ? _self.totalExpense : totalExpense // ignore: cast_nullable_to_non_nullable
as String,incomeChangePercent: null == incomeChangePercent ? _self.incomeChangePercent : incomeChangePercent // ignore: cast_nullable_to_non_nullable
as double,expenseChangePercent: null == expenseChangePercent ? _self.expenseChangePercent : expenseChangePercent // ignore: cast_nullable_to_non_nullable
as double,netChangePercent: null == netChangePercent ? _self.netChangePercent : netChangePercent // ignore: cast_nullable_to_non_nullable
as double,balanceNote: null == balanceNote ? _self.balanceNote : balanceNote // ignore: cast_nullable_to_non_nullable
as String,periodStart: null == periodStart ? _self.periodStart : periodStart // ignore: cast_nullable_to_non_nullable
as DateTime,periodEnd: null == periodEnd ? _self.periodEnd : periodEnd // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$TrendDataPoint {

 String get date; String get amount; String get label;
/// Create a copy of TrendDataPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrendDataPointCopyWith<TrendDataPoint> get copyWith => _$TrendDataPointCopyWithImpl<TrendDataPoint>(this as TrendDataPoint, _$identity);

  /// Serializes this TrendDataPoint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrendDataPoint&&(identical(other.date, date) || other.date == date)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.label, label) || other.label == label));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,amount,label);

@override
String toString() {
  return 'TrendDataPoint(date: $date, amount: $amount, label: $label)';
}


}

/// @nodoc
abstract mixin class $TrendDataPointCopyWith<$Res>  {
  factory $TrendDataPointCopyWith(TrendDataPoint value, $Res Function(TrendDataPoint) _then) = _$TrendDataPointCopyWithImpl;
@useResult
$Res call({
 String date, String amount, String label
});




}
/// @nodoc
class _$TrendDataPointCopyWithImpl<$Res>
    implements $TrendDataPointCopyWith<$Res> {
  _$TrendDataPointCopyWithImpl(this._self, this._then);

  final TrendDataPoint _self;
  final $Res Function(TrendDataPoint) _then;

/// Create a copy of TrendDataPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? amount = null,Object? label = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TrendDataPoint].
extension TrendDataPointPatterns on TrendDataPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrendDataPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrendDataPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrendDataPoint value)  $default,){
final _that = this;
switch (_that) {
case _TrendDataPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrendDataPoint value)?  $default,){
final _that = this;
switch (_that) {
case _TrendDataPoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  String amount,  String label)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrendDataPoint() when $default != null:
return $default(_that.date,_that.amount,_that.label);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  String amount,  String label)  $default,) {final _that = this;
switch (_that) {
case _TrendDataPoint():
return $default(_that.date,_that.amount,_that.label);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  String amount,  String label)?  $default,) {final _that = this;
switch (_that) {
case _TrendDataPoint() when $default != null:
return $default(_that.date,_that.amount,_that.label);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TrendDataPoint implements TrendDataPoint {
  const _TrendDataPoint({required this.date, required this.amount, required this.label});
  factory _TrendDataPoint.fromJson(Map<String, dynamic> json) => _$TrendDataPointFromJson(json);

@override final  String date;
@override final  String amount;
@override final  String label;

/// Create a copy of TrendDataPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrendDataPointCopyWith<_TrendDataPoint> get copyWith => __$TrendDataPointCopyWithImpl<_TrendDataPoint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrendDataPointToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrendDataPoint&&(identical(other.date, date) || other.date == date)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.label, label) || other.label == label));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,amount,label);

@override
String toString() {
  return 'TrendDataPoint(date: $date, amount: $amount, label: $label)';
}


}

/// @nodoc
abstract mixin class _$TrendDataPointCopyWith<$Res> implements $TrendDataPointCopyWith<$Res> {
  factory _$TrendDataPointCopyWith(_TrendDataPoint value, $Res Function(_TrendDataPoint) _then) = __$TrendDataPointCopyWithImpl;
@override @useResult
$Res call({
 String date, String amount, String label
});




}
/// @nodoc
class __$TrendDataPointCopyWithImpl<$Res>
    implements _$TrendDataPointCopyWith<$Res> {
  __$TrendDataPointCopyWithImpl(this._self, this._then);

  final _TrendDataPoint _self;
  final $Res Function(_TrendDataPoint) _then;

/// Create a copy of TrendDataPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? amount = null,Object? label = null,}) {
  return _then(_TrendDataPoint(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$TrendDataResponse {

 List<TrendDataPoint> get dataPoints; String get timeRange; String get transactionType;
/// Create a copy of TrendDataResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrendDataResponseCopyWith<TrendDataResponse> get copyWith => _$TrendDataResponseCopyWithImpl<TrendDataResponse>(this as TrendDataResponse, _$identity);

  /// Serializes this TrendDataResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrendDataResponse&&const DeepCollectionEquality().equals(other.dataPoints, dataPoints)&&(identical(other.timeRange, timeRange) || other.timeRange == timeRange)&&(identical(other.transactionType, transactionType) || other.transactionType == transactionType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(dataPoints),timeRange,transactionType);

@override
String toString() {
  return 'TrendDataResponse(dataPoints: $dataPoints, timeRange: $timeRange, transactionType: $transactionType)';
}


}

/// @nodoc
abstract mixin class $TrendDataResponseCopyWith<$Res>  {
  factory $TrendDataResponseCopyWith(TrendDataResponse value, $Res Function(TrendDataResponse) _then) = _$TrendDataResponseCopyWithImpl;
@useResult
$Res call({
 List<TrendDataPoint> dataPoints, String timeRange, String transactionType
});




}
/// @nodoc
class _$TrendDataResponseCopyWithImpl<$Res>
    implements $TrendDataResponseCopyWith<$Res> {
  _$TrendDataResponseCopyWithImpl(this._self, this._then);

  final TrendDataResponse _self;
  final $Res Function(TrendDataResponse) _then;

/// Create a copy of TrendDataResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dataPoints = null,Object? timeRange = null,Object? transactionType = null,}) {
  return _then(_self.copyWith(
dataPoints: null == dataPoints ? _self.dataPoints : dataPoints // ignore: cast_nullable_to_non_nullable
as List<TrendDataPoint>,timeRange: null == timeRange ? _self.timeRange : timeRange // ignore: cast_nullable_to_non_nullable
as String,transactionType: null == transactionType ? _self.transactionType : transactionType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TrendDataResponse].
extension TrendDataResponsePatterns on TrendDataResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrendDataResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrendDataResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrendDataResponse value)  $default,){
final _that = this;
switch (_that) {
case _TrendDataResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrendDataResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TrendDataResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TrendDataPoint> dataPoints,  String timeRange,  String transactionType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrendDataResponse() when $default != null:
return $default(_that.dataPoints,_that.timeRange,_that.transactionType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TrendDataPoint> dataPoints,  String timeRange,  String transactionType)  $default,) {final _that = this;
switch (_that) {
case _TrendDataResponse():
return $default(_that.dataPoints,_that.timeRange,_that.transactionType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TrendDataPoint> dataPoints,  String timeRange,  String transactionType)?  $default,) {final _that = this;
switch (_that) {
case _TrendDataResponse() when $default != null:
return $default(_that.dataPoints,_that.timeRange,_that.transactionType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TrendDataResponse implements TrendDataResponse {
  const _TrendDataResponse({required final  List<TrendDataPoint> dataPoints, required this.timeRange, required this.transactionType}): _dataPoints = dataPoints;
  factory _TrendDataResponse.fromJson(Map<String, dynamic> json) => _$TrendDataResponseFromJson(json);

 final  List<TrendDataPoint> _dataPoints;
@override List<TrendDataPoint> get dataPoints {
  if (_dataPoints is EqualUnmodifiableListView) return _dataPoints;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dataPoints);
}

@override final  String timeRange;
@override final  String transactionType;

/// Create a copy of TrendDataResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrendDataResponseCopyWith<_TrendDataResponse> get copyWith => __$TrendDataResponseCopyWithImpl<_TrendDataResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrendDataResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrendDataResponse&&const DeepCollectionEquality().equals(other._dataPoints, _dataPoints)&&(identical(other.timeRange, timeRange) || other.timeRange == timeRange)&&(identical(other.transactionType, transactionType) || other.transactionType == transactionType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_dataPoints),timeRange,transactionType);

@override
String toString() {
  return 'TrendDataResponse(dataPoints: $dataPoints, timeRange: $timeRange, transactionType: $transactionType)';
}


}

/// @nodoc
abstract mixin class _$TrendDataResponseCopyWith<$Res> implements $TrendDataResponseCopyWith<$Res> {
  factory _$TrendDataResponseCopyWith(_TrendDataResponse value, $Res Function(_TrendDataResponse) _then) = __$TrendDataResponseCopyWithImpl;
@override @useResult
$Res call({
 List<TrendDataPoint> dataPoints, String timeRange, String transactionType
});




}
/// @nodoc
class __$TrendDataResponseCopyWithImpl<$Res>
    implements _$TrendDataResponseCopyWith<$Res> {
  __$TrendDataResponseCopyWithImpl(this._self, this._then);

  final _TrendDataResponse _self;
  final $Res Function(_TrendDataResponse) _then;

/// Create a copy of TrendDataResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dataPoints = null,Object? timeRange = null,Object? transactionType = null,}) {
  return _then(_TrendDataResponse(
dataPoints: null == dataPoints ? _self._dataPoints : dataPoints // ignore: cast_nullable_to_non_nullable
as List<TrendDataPoint>,timeRange: null == timeRange ? _self.timeRange : timeRange // ignore: cast_nullable_to_non_nullable
as String,transactionType: null == transactionType ? _self.transactionType : transactionType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CategoryBreakdownItem {

 String get categoryKey; String get categoryName; String get amount; double get percentage; String get color; String get icon;
/// Create a copy of CategoryBreakdownItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryBreakdownItemCopyWith<CategoryBreakdownItem> get copyWith => _$CategoryBreakdownItemCopyWithImpl<CategoryBreakdownItem>(this as CategoryBreakdownItem, _$identity);

  /// Serializes this CategoryBreakdownItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryBreakdownItem&&(identical(other.categoryKey, categoryKey) || other.categoryKey == categoryKey)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.percentage, percentage) || other.percentage == percentage)&&(identical(other.color, color) || other.color == color)&&(identical(other.icon, icon) || other.icon == icon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryKey,categoryName,amount,percentage,color,icon);

@override
String toString() {
  return 'CategoryBreakdownItem(categoryKey: $categoryKey, categoryName: $categoryName, amount: $amount, percentage: $percentage, color: $color, icon: $icon)';
}


}

/// @nodoc
abstract mixin class $CategoryBreakdownItemCopyWith<$Res>  {
  factory $CategoryBreakdownItemCopyWith(CategoryBreakdownItem value, $Res Function(CategoryBreakdownItem) _then) = _$CategoryBreakdownItemCopyWithImpl;
@useResult
$Res call({
 String categoryKey, String categoryName, String amount, double percentage, String color, String icon
});




}
/// @nodoc
class _$CategoryBreakdownItemCopyWithImpl<$Res>
    implements $CategoryBreakdownItemCopyWith<$Res> {
  _$CategoryBreakdownItemCopyWithImpl(this._self, this._then);

  final CategoryBreakdownItem _self;
  final $Res Function(CategoryBreakdownItem) _then;

/// Create a copy of CategoryBreakdownItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryKey = null,Object? categoryName = null,Object? amount = null,Object? percentage = null,Object? color = null,Object? icon = null,}) {
  return _then(_self.copyWith(
categoryKey: null == categoryKey ? _self.categoryKey : categoryKey // ignore: cast_nullable_to_non_nullable
as String,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryBreakdownItem].
extension CategoryBreakdownItemPatterns on CategoryBreakdownItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryBreakdownItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryBreakdownItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryBreakdownItem value)  $default,){
final _that = this;
switch (_that) {
case _CategoryBreakdownItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryBreakdownItem value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryBreakdownItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String categoryKey,  String categoryName,  String amount,  double percentage,  String color,  String icon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryBreakdownItem() when $default != null:
return $default(_that.categoryKey,_that.categoryName,_that.amount,_that.percentage,_that.color,_that.icon);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String categoryKey,  String categoryName,  String amount,  double percentage,  String color,  String icon)  $default,) {final _that = this;
switch (_that) {
case _CategoryBreakdownItem():
return $default(_that.categoryKey,_that.categoryName,_that.amount,_that.percentage,_that.color,_that.icon);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String categoryKey,  String categoryName,  String amount,  double percentage,  String color,  String icon)?  $default,) {final _that = this;
switch (_that) {
case _CategoryBreakdownItem() when $default != null:
return $default(_that.categoryKey,_that.categoryName,_that.amount,_that.percentage,_that.color,_that.icon);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategoryBreakdownItem implements CategoryBreakdownItem {
  const _CategoryBreakdownItem({required this.categoryKey, required this.categoryName, required this.amount, required this.percentage, required this.color, required this.icon});
  factory _CategoryBreakdownItem.fromJson(Map<String, dynamic> json) => _$CategoryBreakdownItemFromJson(json);

@override final  String categoryKey;
@override final  String categoryName;
@override final  String amount;
@override final  double percentage;
@override final  String color;
@override final  String icon;

/// Create a copy of CategoryBreakdownItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryBreakdownItemCopyWith<_CategoryBreakdownItem> get copyWith => __$CategoryBreakdownItemCopyWithImpl<_CategoryBreakdownItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryBreakdownItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryBreakdownItem&&(identical(other.categoryKey, categoryKey) || other.categoryKey == categoryKey)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.percentage, percentage) || other.percentage == percentage)&&(identical(other.color, color) || other.color == color)&&(identical(other.icon, icon) || other.icon == icon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryKey,categoryName,amount,percentage,color,icon);

@override
String toString() {
  return 'CategoryBreakdownItem(categoryKey: $categoryKey, categoryName: $categoryName, amount: $amount, percentage: $percentage, color: $color, icon: $icon)';
}


}

/// @nodoc
abstract mixin class _$CategoryBreakdownItemCopyWith<$Res> implements $CategoryBreakdownItemCopyWith<$Res> {
  factory _$CategoryBreakdownItemCopyWith(_CategoryBreakdownItem value, $Res Function(_CategoryBreakdownItem) _then) = __$CategoryBreakdownItemCopyWithImpl;
@override @useResult
$Res call({
 String categoryKey, String categoryName, String amount, double percentage, String color, String icon
});




}
/// @nodoc
class __$CategoryBreakdownItemCopyWithImpl<$Res>
    implements _$CategoryBreakdownItemCopyWith<$Res> {
  __$CategoryBreakdownItemCopyWithImpl(this._self, this._then);

  final _CategoryBreakdownItem _self;
  final $Res Function(_CategoryBreakdownItem) _then;

/// Create a copy of CategoryBreakdownItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryKey = null,Object? categoryName = null,Object? amount = null,Object? percentage = null,Object? color = null,Object? icon = null,}) {
  return _then(_CategoryBreakdownItem(
categoryKey: null == categoryKey ? _self.categoryKey : categoryKey // ignore: cast_nullable_to_non_nullable
as String,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CategoryBreakdownResponse {

 List<CategoryBreakdownItem> get items; String get total;
/// Create a copy of CategoryBreakdownResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryBreakdownResponseCopyWith<CategoryBreakdownResponse> get copyWith => _$CategoryBreakdownResponseCopyWithImpl<CategoryBreakdownResponse>(this as CategoryBreakdownResponse, _$identity);

  /// Serializes this CategoryBreakdownResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryBreakdownResponse&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),total);

@override
String toString() {
  return 'CategoryBreakdownResponse(items: $items, total: $total)';
}


}

/// @nodoc
abstract mixin class $CategoryBreakdownResponseCopyWith<$Res>  {
  factory $CategoryBreakdownResponseCopyWith(CategoryBreakdownResponse value, $Res Function(CategoryBreakdownResponse) _then) = _$CategoryBreakdownResponseCopyWithImpl;
@useResult
$Res call({
 List<CategoryBreakdownItem> items, String total
});




}
/// @nodoc
class _$CategoryBreakdownResponseCopyWithImpl<$Res>
    implements $CategoryBreakdownResponseCopyWith<$Res> {
  _$CategoryBreakdownResponseCopyWithImpl(this._self, this._then);

  final CategoryBreakdownResponse _self;
  final $Res Function(CategoryBreakdownResponse) _then;

/// Create a copy of CategoryBreakdownResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? total = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<CategoryBreakdownItem>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryBreakdownResponse].
extension CategoryBreakdownResponsePatterns on CategoryBreakdownResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryBreakdownResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryBreakdownResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryBreakdownResponse value)  $default,){
final _that = this;
switch (_that) {
case _CategoryBreakdownResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryBreakdownResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryBreakdownResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CategoryBreakdownItem> items,  String total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryBreakdownResponse() when $default != null:
return $default(_that.items,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CategoryBreakdownItem> items,  String total)  $default,) {final _that = this;
switch (_that) {
case _CategoryBreakdownResponse():
return $default(_that.items,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CategoryBreakdownItem> items,  String total)?  $default,) {final _that = this;
switch (_that) {
case _CategoryBreakdownResponse() when $default != null:
return $default(_that.items,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategoryBreakdownResponse implements CategoryBreakdownResponse {
  const _CategoryBreakdownResponse({required final  List<CategoryBreakdownItem> items, required this.total}): _items = items;
  factory _CategoryBreakdownResponse.fromJson(Map<String, dynamic> json) => _$CategoryBreakdownResponseFromJson(json);

 final  List<CategoryBreakdownItem> _items;
@override List<CategoryBreakdownItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  String total;

/// Create a copy of CategoryBreakdownResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryBreakdownResponseCopyWith<_CategoryBreakdownResponse> get copyWith => __$CategoryBreakdownResponseCopyWithImpl<_CategoryBreakdownResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryBreakdownResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryBreakdownResponse&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),total);

@override
String toString() {
  return 'CategoryBreakdownResponse(items: $items, total: $total)';
}


}

/// @nodoc
abstract mixin class _$CategoryBreakdownResponseCopyWith<$Res> implements $CategoryBreakdownResponseCopyWith<$Res> {
  factory _$CategoryBreakdownResponseCopyWith(_CategoryBreakdownResponse value, $Res Function(_CategoryBreakdownResponse) _then) = __$CategoryBreakdownResponseCopyWithImpl;
@override @useResult
$Res call({
 List<CategoryBreakdownItem> items, String total
});




}
/// @nodoc
class __$CategoryBreakdownResponseCopyWithImpl<$Res>
    implements _$CategoryBreakdownResponseCopyWith<$Res> {
  __$CategoryBreakdownResponseCopyWithImpl(this._self, this._then);

  final _CategoryBreakdownResponse _self;
  final $Res Function(_CategoryBreakdownResponse) _then;

/// Create a copy of CategoryBreakdownResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? total = null,}) {
  return _then(_CategoryBreakdownResponse(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<CategoryBreakdownItem>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$TopTransactionItem {

 String get id; String get description; String get amount; String get categoryKey; String get categoryName; DateTime get transactionAt; String get icon;
/// Create a copy of TopTransactionItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TopTransactionItemCopyWith<TopTransactionItem> get copyWith => _$TopTransactionItemCopyWithImpl<TopTransactionItem>(this as TopTransactionItem, _$identity);

  /// Serializes this TopTransactionItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TopTransactionItem&&(identical(other.id, id) || other.id == id)&&(identical(other.description, description) || other.description == description)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.categoryKey, categoryKey) || other.categoryKey == categoryKey)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.transactionAt, transactionAt) || other.transactionAt == transactionAt)&&(identical(other.icon, icon) || other.icon == icon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,description,amount,categoryKey,categoryName,transactionAt,icon);

@override
String toString() {
  return 'TopTransactionItem(id: $id, description: $description, amount: $amount, categoryKey: $categoryKey, categoryName: $categoryName, transactionAt: $transactionAt, icon: $icon)';
}


}

/// @nodoc
abstract mixin class $TopTransactionItemCopyWith<$Res>  {
  factory $TopTransactionItemCopyWith(TopTransactionItem value, $Res Function(TopTransactionItem) _then) = _$TopTransactionItemCopyWithImpl;
@useResult
$Res call({
 String id, String description, String amount, String categoryKey, String categoryName, DateTime transactionAt, String icon
});




}
/// @nodoc
class _$TopTransactionItemCopyWithImpl<$Res>
    implements $TopTransactionItemCopyWith<$Res> {
  _$TopTransactionItemCopyWithImpl(this._self, this._then);

  final TopTransactionItem _self;
  final $Res Function(TopTransactionItem) _then;

/// Create a copy of TopTransactionItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? description = null,Object? amount = null,Object? categoryKey = null,Object? categoryName = null,Object? transactionAt = null,Object? icon = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,categoryKey: null == categoryKey ? _self.categoryKey : categoryKey // ignore: cast_nullable_to_non_nullable
as String,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,transactionAt: null == transactionAt ? _self.transactionAt : transactionAt // ignore: cast_nullable_to_non_nullable
as DateTime,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TopTransactionItem].
extension TopTransactionItemPatterns on TopTransactionItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TopTransactionItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TopTransactionItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TopTransactionItem value)  $default,){
final _that = this;
switch (_that) {
case _TopTransactionItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TopTransactionItem value)?  $default,){
final _that = this;
switch (_that) {
case _TopTransactionItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String description,  String amount,  String categoryKey,  String categoryName,  DateTime transactionAt,  String icon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TopTransactionItem() when $default != null:
return $default(_that.id,_that.description,_that.amount,_that.categoryKey,_that.categoryName,_that.transactionAt,_that.icon);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String description,  String amount,  String categoryKey,  String categoryName,  DateTime transactionAt,  String icon)  $default,) {final _that = this;
switch (_that) {
case _TopTransactionItem():
return $default(_that.id,_that.description,_that.amount,_that.categoryKey,_that.categoryName,_that.transactionAt,_that.icon);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String description,  String amount,  String categoryKey,  String categoryName,  DateTime transactionAt,  String icon)?  $default,) {final _that = this;
switch (_that) {
case _TopTransactionItem() when $default != null:
return $default(_that.id,_that.description,_that.amount,_that.categoryKey,_that.categoryName,_that.transactionAt,_that.icon);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TopTransactionItem implements TopTransactionItem {
  const _TopTransactionItem({required this.id, required this.description, required this.amount, required this.categoryKey, required this.categoryName, required this.transactionAt, required this.icon});
  factory _TopTransactionItem.fromJson(Map<String, dynamic> json) => _$TopTransactionItemFromJson(json);

@override final  String id;
@override final  String description;
@override final  String amount;
@override final  String categoryKey;
@override final  String categoryName;
@override final  DateTime transactionAt;
@override final  String icon;

/// Create a copy of TopTransactionItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TopTransactionItemCopyWith<_TopTransactionItem> get copyWith => __$TopTransactionItemCopyWithImpl<_TopTransactionItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TopTransactionItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TopTransactionItem&&(identical(other.id, id) || other.id == id)&&(identical(other.description, description) || other.description == description)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.categoryKey, categoryKey) || other.categoryKey == categoryKey)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.transactionAt, transactionAt) || other.transactionAt == transactionAt)&&(identical(other.icon, icon) || other.icon == icon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,description,amount,categoryKey,categoryName,transactionAt,icon);

@override
String toString() {
  return 'TopTransactionItem(id: $id, description: $description, amount: $amount, categoryKey: $categoryKey, categoryName: $categoryName, transactionAt: $transactionAt, icon: $icon)';
}


}

/// @nodoc
abstract mixin class _$TopTransactionItemCopyWith<$Res> implements $TopTransactionItemCopyWith<$Res> {
  factory _$TopTransactionItemCopyWith(_TopTransactionItem value, $Res Function(_TopTransactionItem) _then) = __$TopTransactionItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String description, String amount, String categoryKey, String categoryName, DateTime transactionAt, String icon
});




}
/// @nodoc
class __$TopTransactionItemCopyWithImpl<$Res>
    implements _$TopTransactionItemCopyWith<$Res> {
  __$TopTransactionItemCopyWithImpl(this._self, this._then);

  final _TopTransactionItem _self;
  final $Res Function(_TopTransactionItem) _then;

/// Create a copy of TopTransactionItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? description = null,Object? amount = null,Object? categoryKey = null,Object? categoryName = null,Object? transactionAt = null,Object? icon = null,}) {
  return _then(_TopTransactionItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,categoryKey: null == categoryKey ? _self.categoryKey : categoryKey // ignore: cast_nullable_to_non_nullable
as String,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,transactionAt: null == transactionAt ? _self.transactionAt : transactionAt // ignore: cast_nullable_to_non_nullable
as DateTime,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$TopTransactionsResponse {

 List<TopTransactionItem> get items; String get sortBy; int get total; int get page; int get pageSize; bool get hasMore;
/// Create a copy of TopTransactionsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TopTransactionsResponseCopyWith<TopTransactionsResponse> get copyWith => _$TopTransactionsResponseCopyWithImpl<TopTransactionsResponse>(this as TopTransactionsResponse, _$identity);

  /// Serializes this TopTransactionsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TopTransactionsResponse&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.sortBy, sortBy) || other.sortBy == sortBy)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),sortBy,total,page,pageSize,hasMore);

@override
String toString() {
  return 'TopTransactionsResponse(items: $items, sortBy: $sortBy, total: $total, page: $page, pageSize: $pageSize, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class $TopTransactionsResponseCopyWith<$Res>  {
  factory $TopTransactionsResponseCopyWith(TopTransactionsResponse value, $Res Function(TopTransactionsResponse) _then) = _$TopTransactionsResponseCopyWithImpl;
@useResult
$Res call({
 List<TopTransactionItem> items, String sortBy, int total, int page, int pageSize, bool hasMore
});




}
/// @nodoc
class _$TopTransactionsResponseCopyWithImpl<$Res>
    implements $TopTransactionsResponseCopyWith<$Res> {
  _$TopTransactionsResponseCopyWithImpl(this._self, this._then);

  final TopTransactionsResponse _self;
  final $Res Function(TopTransactionsResponse) _then;

/// Create a copy of TopTransactionsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? sortBy = null,Object? total = null,Object? page = null,Object? pageSize = null,Object? hasMore = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<TopTransactionItem>,sortBy: null == sortBy ? _self.sortBy : sortBy // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TopTransactionsResponse].
extension TopTransactionsResponsePatterns on TopTransactionsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TopTransactionsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TopTransactionsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TopTransactionsResponse value)  $default,){
final _that = this;
switch (_that) {
case _TopTransactionsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TopTransactionsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TopTransactionsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TopTransactionItem> items,  String sortBy,  int total,  int page,  int pageSize,  bool hasMore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TopTransactionsResponse() when $default != null:
return $default(_that.items,_that.sortBy,_that.total,_that.page,_that.pageSize,_that.hasMore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TopTransactionItem> items,  String sortBy,  int total,  int page,  int pageSize,  bool hasMore)  $default,) {final _that = this;
switch (_that) {
case _TopTransactionsResponse():
return $default(_that.items,_that.sortBy,_that.total,_that.page,_that.pageSize,_that.hasMore);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TopTransactionItem> items,  String sortBy,  int total,  int page,  int pageSize,  bool hasMore)?  $default,) {final _that = this;
switch (_that) {
case _TopTransactionsResponse() when $default != null:
return $default(_that.items,_that.sortBy,_that.total,_that.page,_that.pageSize,_that.hasMore);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TopTransactionsResponse implements TopTransactionsResponse {
  const _TopTransactionsResponse({required final  List<TopTransactionItem> items, required this.sortBy, required this.total, this.page = 1, this.pageSize = 10, this.hasMore = false}): _items = items;
  factory _TopTransactionsResponse.fromJson(Map<String, dynamic> json) => _$TopTransactionsResponseFromJson(json);

 final  List<TopTransactionItem> _items;
@override List<TopTransactionItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  String sortBy;
@override final  int total;
@override@JsonKey() final  int page;
@override@JsonKey() final  int pageSize;
@override@JsonKey() final  bool hasMore;

/// Create a copy of TopTransactionsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TopTransactionsResponseCopyWith<_TopTransactionsResponse> get copyWith => __$TopTransactionsResponseCopyWithImpl<_TopTransactionsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TopTransactionsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TopTransactionsResponse&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.sortBy, sortBy) || other.sortBy == sortBy)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),sortBy,total,page,pageSize,hasMore);

@override
String toString() {
  return 'TopTransactionsResponse(items: $items, sortBy: $sortBy, total: $total, page: $page, pageSize: $pageSize, hasMore: $hasMore)';
}


}

/// @nodoc
abstract mixin class _$TopTransactionsResponseCopyWith<$Res> implements $TopTransactionsResponseCopyWith<$Res> {
  factory _$TopTransactionsResponseCopyWith(_TopTransactionsResponse value, $Res Function(_TopTransactionsResponse) _then) = __$TopTransactionsResponseCopyWithImpl;
@override @useResult
$Res call({
 List<TopTransactionItem> items, String sortBy, int total, int page, int pageSize, bool hasMore
});




}
/// @nodoc
class __$TopTransactionsResponseCopyWithImpl<$Res>
    implements _$TopTransactionsResponseCopyWith<$Res> {
  __$TopTransactionsResponseCopyWithImpl(this._self, this._then);

  final _TopTransactionsResponse _self;
  final $Res Function(_TopTransactionsResponse) _then;

/// Create a copy of TopTransactionsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? sortBy = null,Object? total = null,Object? page = null,Object? pageSize = null,Object? hasMore = null,}) {
  return _then(_TopTransactionsResponse(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<TopTransactionItem>,sortBy: null == sortBy ? _self.sortBy : sortBy // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$StatisticsQuery {

 TimeRange get timeRange; ChartType get chartType; SortType get sortType; DateTime? get startDate; DateTime? get endDate; List<String> get accountTypes;
/// Create a copy of StatisticsQuery
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatisticsQueryCopyWith<StatisticsQuery> get copyWith => _$StatisticsQueryCopyWithImpl<StatisticsQuery>(this as StatisticsQuery, _$identity);

  /// Serializes this StatisticsQuery to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatisticsQuery&&(identical(other.timeRange, timeRange) || other.timeRange == timeRange)&&(identical(other.chartType, chartType) || other.chartType == chartType)&&(identical(other.sortType, sortType) || other.sortType == sortType)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&const DeepCollectionEquality().equals(other.accountTypes, accountTypes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,timeRange,chartType,sortType,startDate,endDate,const DeepCollectionEquality().hash(accountTypes));

@override
String toString() {
  return 'StatisticsQuery(timeRange: $timeRange, chartType: $chartType, sortType: $sortType, startDate: $startDate, endDate: $endDate, accountTypes: $accountTypes)';
}


}

/// @nodoc
abstract mixin class $StatisticsQueryCopyWith<$Res>  {
  factory $StatisticsQueryCopyWith(StatisticsQuery value, $Res Function(StatisticsQuery) _then) = _$StatisticsQueryCopyWithImpl;
@useResult
$Res call({
 TimeRange timeRange, ChartType chartType, SortType sortType, DateTime? startDate, DateTime? endDate, List<String> accountTypes
});




}
/// @nodoc
class _$StatisticsQueryCopyWithImpl<$Res>
    implements $StatisticsQueryCopyWith<$Res> {
  _$StatisticsQueryCopyWithImpl(this._self, this._then);

  final StatisticsQuery _self;
  final $Res Function(StatisticsQuery) _then;

/// Create a copy of StatisticsQuery
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? timeRange = null,Object? chartType = null,Object? sortType = null,Object? startDate = freezed,Object? endDate = freezed,Object? accountTypes = null,}) {
  return _then(_self.copyWith(
timeRange: null == timeRange ? _self.timeRange : timeRange // ignore: cast_nullable_to_non_nullable
as TimeRange,chartType: null == chartType ? _self.chartType : chartType // ignore: cast_nullable_to_non_nullable
as ChartType,sortType: null == sortType ? _self.sortType : sortType // ignore: cast_nullable_to_non_nullable
as SortType,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,accountTypes: null == accountTypes ? _self.accountTypes : accountTypes // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [StatisticsQuery].
extension StatisticsQueryPatterns on StatisticsQuery {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StatisticsQuery value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StatisticsQuery() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StatisticsQuery value)  $default,){
final _that = this;
switch (_that) {
case _StatisticsQuery():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StatisticsQuery value)?  $default,){
final _that = this;
switch (_that) {
case _StatisticsQuery() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TimeRange timeRange,  ChartType chartType,  SortType sortType,  DateTime? startDate,  DateTime? endDate,  List<String> accountTypes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StatisticsQuery() when $default != null:
return $default(_that.timeRange,_that.chartType,_that.sortType,_that.startDate,_that.endDate,_that.accountTypes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TimeRange timeRange,  ChartType chartType,  SortType sortType,  DateTime? startDate,  DateTime? endDate,  List<String> accountTypes)  $default,) {final _that = this;
switch (_that) {
case _StatisticsQuery():
return $default(_that.timeRange,_that.chartType,_that.sortType,_that.startDate,_that.endDate,_that.accountTypes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TimeRange timeRange,  ChartType chartType,  SortType sortType,  DateTime? startDate,  DateTime? endDate,  List<String> accountTypes)?  $default,) {final _that = this;
switch (_that) {
case _StatisticsQuery() when $default != null:
return $default(_that.timeRange,_that.chartType,_that.sortType,_that.startDate,_that.endDate,_that.accountTypes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StatisticsQuery implements StatisticsQuery {
  const _StatisticsQuery({this.timeRange = TimeRange.month, this.chartType = ChartType.expense, this.sortType = SortType.amount, this.startDate, this.endDate, final  List<String> accountTypes = const []}): _accountTypes = accountTypes;
  factory _StatisticsQuery.fromJson(Map<String, dynamic> json) => _$StatisticsQueryFromJson(json);

@override@JsonKey() final  TimeRange timeRange;
@override@JsonKey() final  ChartType chartType;
@override@JsonKey() final  SortType sortType;
@override final  DateTime? startDate;
@override final  DateTime? endDate;
 final  List<String> _accountTypes;
@override@JsonKey() List<String> get accountTypes {
  if (_accountTypes is EqualUnmodifiableListView) return _accountTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_accountTypes);
}


/// Create a copy of StatisticsQuery
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StatisticsQueryCopyWith<_StatisticsQuery> get copyWith => __$StatisticsQueryCopyWithImpl<_StatisticsQuery>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StatisticsQueryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StatisticsQuery&&(identical(other.timeRange, timeRange) || other.timeRange == timeRange)&&(identical(other.chartType, chartType) || other.chartType == chartType)&&(identical(other.sortType, sortType) || other.sortType == sortType)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&const DeepCollectionEquality().equals(other._accountTypes, _accountTypes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,timeRange,chartType,sortType,startDate,endDate,const DeepCollectionEquality().hash(_accountTypes));

@override
String toString() {
  return 'StatisticsQuery(timeRange: $timeRange, chartType: $chartType, sortType: $sortType, startDate: $startDate, endDate: $endDate, accountTypes: $accountTypes)';
}


}

/// @nodoc
abstract mixin class _$StatisticsQueryCopyWith<$Res> implements $StatisticsQueryCopyWith<$Res> {
  factory _$StatisticsQueryCopyWith(_StatisticsQuery value, $Res Function(_StatisticsQuery) _then) = __$StatisticsQueryCopyWithImpl;
@override @useResult
$Res call({
 TimeRange timeRange, ChartType chartType, SortType sortType, DateTime? startDate, DateTime? endDate, List<String> accountTypes
});




}
/// @nodoc
class __$StatisticsQueryCopyWithImpl<$Res>
    implements _$StatisticsQueryCopyWith<$Res> {
  __$StatisticsQueryCopyWithImpl(this._self, this._then);

  final _StatisticsQuery _self;
  final $Res Function(_StatisticsQuery) _then;

/// Create a copy of StatisticsQuery
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? timeRange = null,Object? chartType = null,Object? sortType = null,Object? startDate = freezed,Object? endDate = freezed,Object? accountTypes = null,}) {
  return _then(_StatisticsQuery(
timeRange: null == timeRange ? _self.timeRange : timeRange // ignore: cast_nullable_to_non_nullable
as TimeRange,chartType: null == chartType ? _self.chartType : chartType // ignore: cast_nullable_to_non_nullable
as ChartType,sortType: null == sortType ? _self.sortType : sortType // ignore: cast_nullable_to_non_nullable
as SortType,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,accountTypes: null == accountTypes ? _self._accountTypes : accountTypes // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$CashFlowAnalysis {

 String get totalIncome; String get totalExpense; String get netCashFlow; double get savingsRate; double get expenseToIncomeRatio; double get essentialExpenseRatio; double get discretionaryExpenseRatio; double get incomeChangePercent; double get expenseChangePercent; double get savingsRateChange; DateTime get periodStart; DateTime get periodEnd;
/// Create a copy of CashFlowAnalysis
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CashFlowAnalysisCopyWith<CashFlowAnalysis> get copyWith => _$CashFlowAnalysisCopyWithImpl<CashFlowAnalysis>(this as CashFlowAnalysis, _$identity);

  /// Serializes this CashFlowAnalysis to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CashFlowAnalysis&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpense, totalExpense) || other.totalExpense == totalExpense)&&(identical(other.netCashFlow, netCashFlow) || other.netCashFlow == netCashFlow)&&(identical(other.savingsRate, savingsRate) || other.savingsRate == savingsRate)&&(identical(other.expenseToIncomeRatio, expenseToIncomeRatio) || other.expenseToIncomeRatio == expenseToIncomeRatio)&&(identical(other.essentialExpenseRatio, essentialExpenseRatio) || other.essentialExpenseRatio == essentialExpenseRatio)&&(identical(other.discretionaryExpenseRatio, discretionaryExpenseRatio) || other.discretionaryExpenseRatio == discretionaryExpenseRatio)&&(identical(other.incomeChangePercent, incomeChangePercent) || other.incomeChangePercent == incomeChangePercent)&&(identical(other.expenseChangePercent, expenseChangePercent) || other.expenseChangePercent == expenseChangePercent)&&(identical(other.savingsRateChange, savingsRateChange) || other.savingsRateChange == savingsRateChange)&&(identical(other.periodStart, periodStart) || other.periodStart == periodStart)&&(identical(other.periodEnd, periodEnd) || other.periodEnd == periodEnd));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalIncome,totalExpense,netCashFlow,savingsRate,expenseToIncomeRatio,essentialExpenseRatio,discretionaryExpenseRatio,incomeChangePercent,expenseChangePercent,savingsRateChange,periodStart,periodEnd);

@override
String toString() {
  return 'CashFlowAnalysis(totalIncome: $totalIncome, totalExpense: $totalExpense, netCashFlow: $netCashFlow, savingsRate: $savingsRate, expenseToIncomeRatio: $expenseToIncomeRatio, essentialExpenseRatio: $essentialExpenseRatio, discretionaryExpenseRatio: $discretionaryExpenseRatio, incomeChangePercent: $incomeChangePercent, expenseChangePercent: $expenseChangePercent, savingsRateChange: $savingsRateChange, periodStart: $periodStart, periodEnd: $periodEnd)';
}


}

/// @nodoc
abstract mixin class $CashFlowAnalysisCopyWith<$Res>  {
  factory $CashFlowAnalysisCopyWith(CashFlowAnalysis value, $Res Function(CashFlowAnalysis) _then) = _$CashFlowAnalysisCopyWithImpl;
@useResult
$Res call({
 String totalIncome, String totalExpense, String netCashFlow, double savingsRate, double expenseToIncomeRatio, double essentialExpenseRatio, double discretionaryExpenseRatio, double incomeChangePercent, double expenseChangePercent, double savingsRateChange, DateTime periodStart, DateTime periodEnd
});




}
/// @nodoc
class _$CashFlowAnalysisCopyWithImpl<$Res>
    implements $CashFlowAnalysisCopyWith<$Res> {
  _$CashFlowAnalysisCopyWithImpl(this._self, this._then);

  final CashFlowAnalysis _self;
  final $Res Function(CashFlowAnalysis) _then;

/// Create a copy of CashFlowAnalysis
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalIncome = null,Object? totalExpense = null,Object? netCashFlow = null,Object? savingsRate = null,Object? expenseToIncomeRatio = null,Object? essentialExpenseRatio = null,Object? discretionaryExpenseRatio = null,Object? incomeChangePercent = null,Object? expenseChangePercent = null,Object? savingsRateChange = null,Object? periodStart = null,Object? periodEnd = null,}) {
  return _then(_self.copyWith(
totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as String,totalExpense: null == totalExpense ? _self.totalExpense : totalExpense // ignore: cast_nullable_to_non_nullable
as String,netCashFlow: null == netCashFlow ? _self.netCashFlow : netCashFlow // ignore: cast_nullable_to_non_nullable
as String,savingsRate: null == savingsRate ? _self.savingsRate : savingsRate // ignore: cast_nullable_to_non_nullable
as double,expenseToIncomeRatio: null == expenseToIncomeRatio ? _self.expenseToIncomeRatio : expenseToIncomeRatio // ignore: cast_nullable_to_non_nullable
as double,essentialExpenseRatio: null == essentialExpenseRatio ? _self.essentialExpenseRatio : essentialExpenseRatio // ignore: cast_nullable_to_non_nullable
as double,discretionaryExpenseRatio: null == discretionaryExpenseRatio ? _self.discretionaryExpenseRatio : discretionaryExpenseRatio // ignore: cast_nullable_to_non_nullable
as double,incomeChangePercent: null == incomeChangePercent ? _self.incomeChangePercent : incomeChangePercent // ignore: cast_nullable_to_non_nullable
as double,expenseChangePercent: null == expenseChangePercent ? _self.expenseChangePercent : expenseChangePercent // ignore: cast_nullable_to_non_nullable
as double,savingsRateChange: null == savingsRateChange ? _self.savingsRateChange : savingsRateChange // ignore: cast_nullable_to_non_nullable
as double,periodStart: null == periodStart ? _self.periodStart : periodStart // ignore: cast_nullable_to_non_nullable
as DateTime,periodEnd: null == periodEnd ? _self.periodEnd : periodEnd // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CashFlowAnalysis].
extension CashFlowAnalysisPatterns on CashFlowAnalysis {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CashFlowAnalysis value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CashFlowAnalysis() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CashFlowAnalysis value)  $default,){
final _that = this;
switch (_that) {
case _CashFlowAnalysis():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CashFlowAnalysis value)?  $default,){
final _that = this;
switch (_that) {
case _CashFlowAnalysis() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String totalIncome,  String totalExpense,  String netCashFlow,  double savingsRate,  double expenseToIncomeRatio,  double essentialExpenseRatio,  double discretionaryExpenseRatio,  double incomeChangePercent,  double expenseChangePercent,  double savingsRateChange,  DateTime periodStart,  DateTime periodEnd)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CashFlowAnalysis() when $default != null:
return $default(_that.totalIncome,_that.totalExpense,_that.netCashFlow,_that.savingsRate,_that.expenseToIncomeRatio,_that.essentialExpenseRatio,_that.discretionaryExpenseRatio,_that.incomeChangePercent,_that.expenseChangePercent,_that.savingsRateChange,_that.periodStart,_that.periodEnd);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String totalIncome,  String totalExpense,  String netCashFlow,  double savingsRate,  double expenseToIncomeRatio,  double essentialExpenseRatio,  double discretionaryExpenseRatio,  double incomeChangePercent,  double expenseChangePercent,  double savingsRateChange,  DateTime periodStart,  DateTime periodEnd)  $default,) {final _that = this;
switch (_that) {
case _CashFlowAnalysis():
return $default(_that.totalIncome,_that.totalExpense,_that.netCashFlow,_that.savingsRate,_that.expenseToIncomeRatio,_that.essentialExpenseRatio,_that.discretionaryExpenseRatio,_that.incomeChangePercent,_that.expenseChangePercent,_that.savingsRateChange,_that.periodStart,_that.periodEnd);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String totalIncome,  String totalExpense,  String netCashFlow,  double savingsRate,  double expenseToIncomeRatio,  double essentialExpenseRatio,  double discretionaryExpenseRatio,  double incomeChangePercent,  double expenseChangePercent,  double savingsRateChange,  DateTime periodStart,  DateTime periodEnd)?  $default,) {final _that = this;
switch (_that) {
case _CashFlowAnalysis() when $default != null:
return $default(_that.totalIncome,_that.totalExpense,_that.netCashFlow,_that.savingsRate,_that.expenseToIncomeRatio,_that.essentialExpenseRatio,_that.discretionaryExpenseRatio,_that.incomeChangePercent,_that.expenseChangePercent,_that.savingsRateChange,_that.periodStart,_that.periodEnd);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CashFlowAnalysis implements CashFlowAnalysis {
  const _CashFlowAnalysis({required this.totalIncome, required this.totalExpense, required this.netCashFlow, required this.savingsRate, required this.expenseToIncomeRatio, this.essentialExpenseRatio = 0.0, this.discretionaryExpenseRatio = 0.0, required this.incomeChangePercent, required this.expenseChangePercent, required this.savingsRateChange, required this.periodStart, required this.periodEnd});
  factory _CashFlowAnalysis.fromJson(Map<String, dynamic> json) => _$CashFlowAnalysisFromJson(json);

@override final  String totalIncome;
@override final  String totalExpense;
@override final  String netCashFlow;
@override final  double savingsRate;
@override final  double expenseToIncomeRatio;
@override@JsonKey() final  double essentialExpenseRatio;
@override@JsonKey() final  double discretionaryExpenseRatio;
@override final  double incomeChangePercent;
@override final  double expenseChangePercent;
@override final  double savingsRateChange;
@override final  DateTime periodStart;
@override final  DateTime periodEnd;

/// Create a copy of CashFlowAnalysis
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CashFlowAnalysisCopyWith<_CashFlowAnalysis> get copyWith => __$CashFlowAnalysisCopyWithImpl<_CashFlowAnalysis>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CashFlowAnalysisToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CashFlowAnalysis&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpense, totalExpense) || other.totalExpense == totalExpense)&&(identical(other.netCashFlow, netCashFlow) || other.netCashFlow == netCashFlow)&&(identical(other.savingsRate, savingsRate) || other.savingsRate == savingsRate)&&(identical(other.expenseToIncomeRatio, expenseToIncomeRatio) || other.expenseToIncomeRatio == expenseToIncomeRatio)&&(identical(other.essentialExpenseRatio, essentialExpenseRatio) || other.essentialExpenseRatio == essentialExpenseRatio)&&(identical(other.discretionaryExpenseRatio, discretionaryExpenseRatio) || other.discretionaryExpenseRatio == discretionaryExpenseRatio)&&(identical(other.incomeChangePercent, incomeChangePercent) || other.incomeChangePercent == incomeChangePercent)&&(identical(other.expenseChangePercent, expenseChangePercent) || other.expenseChangePercent == expenseChangePercent)&&(identical(other.savingsRateChange, savingsRateChange) || other.savingsRateChange == savingsRateChange)&&(identical(other.periodStart, periodStart) || other.periodStart == periodStart)&&(identical(other.periodEnd, periodEnd) || other.periodEnd == periodEnd));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalIncome,totalExpense,netCashFlow,savingsRate,expenseToIncomeRatio,essentialExpenseRatio,discretionaryExpenseRatio,incomeChangePercent,expenseChangePercent,savingsRateChange,periodStart,periodEnd);

@override
String toString() {
  return 'CashFlowAnalysis(totalIncome: $totalIncome, totalExpense: $totalExpense, netCashFlow: $netCashFlow, savingsRate: $savingsRate, expenseToIncomeRatio: $expenseToIncomeRatio, essentialExpenseRatio: $essentialExpenseRatio, discretionaryExpenseRatio: $discretionaryExpenseRatio, incomeChangePercent: $incomeChangePercent, expenseChangePercent: $expenseChangePercent, savingsRateChange: $savingsRateChange, periodStart: $periodStart, periodEnd: $periodEnd)';
}


}

/// @nodoc
abstract mixin class _$CashFlowAnalysisCopyWith<$Res> implements $CashFlowAnalysisCopyWith<$Res> {
  factory _$CashFlowAnalysisCopyWith(_CashFlowAnalysis value, $Res Function(_CashFlowAnalysis) _then) = __$CashFlowAnalysisCopyWithImpl;
@override @useResult
$Res call({
 String totalIncome, String totalExpense, String netCashFlow, double savingsRate, double expenseToIncomeRatio, double essentialExpenseRatio, double discretionaryExpenseRatio, double incomeChangePercent, double expenseChangePercent, double savingsRateChange, DateTime periodStart, DateTime periodEnd
});




}
/// @nodoc
class __$CashFlowAnalysisCopyWithImpl<$Res>
    implements _$CashFlowAnalysisCopyWith<$Res> {
  __$CashFlowAnalysisCopyWithImpl(this._self, this._then);

  final _CashFlowAnalysis _self;
  final $Res Function(_CashFlowAnalysis) _then;

/// Create a copy of CashFlowAnalysis
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalIncome = null,Object? totalExpense = null,Object? netCashFlow = null,Object? savingsRate = null,Object? expenseToIncomeRatio = null,Object? essentialExpenseRatio = null,Object? discretionaryExpenseRatio = null,Object? incomeChangePercent = null,Object? expenseChangePercent = null,Object? savingsRateChange = null,Object? periodStart = null,Object? periodEnd = null,}) {
  return _then(_CashFlowAnalysis(
totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as String,totalExpense: null == totalExpense ? _self.totalExpense : totalExpense // ignore: cast_nullable_to_non_nullable
as String,netCashFlow: null == netCashFlow ? _self.netCashFlow : netCashFlow // ignore: cast_nullable_to_non_nullable
as String,savingsRate: null == savingsRate ? _self.savingsRate : savingsRate // ignore: cast_nullable_to_non_nullable
as double,expenseToIncomeRatio: null == expenseToIncomeRatio ? _self.expenseToIncomeRatio : expenseToIncomeRatio // ignore: cast_nullable_to_non_nullable
as double,essentialExpenseRatio: null == essentialExpenseRatio ? _self.essentialExpenseRatio : essentialExpenseRatio // ignore: cast_nullable_to_non_nullable
as double,discretionaryExpenseRatio: null == discretionaryExpenseRatio ? _self.discretionaryExpenseRatio : discretionaryExpenseRatio // ignore: cast_nullable_to_non_nullable
as double,incomeChangePercent: null == incomeChangePercent ? _self.incomeChangePercent : incomeChangePercent // ignore: cast_nullable_to_non_nullable
as double,expenseChangePercent: null == expenseChangePercent ? _self.expenseChangePercent : expenseChangePercent // ignore: cast_nullable_to_non_nullable
as double,savingsRateChange: null == savingsRateChange ? _self.savingsRateChange : savingsRateChange // ignore: cast_nullable_to_non_nullable
as double,periodStart: null == periodStart ? _self.periodStart : periodStart // ignore: cast_nullable_to_non_nullable
as DateTime,periodEnd: null == periodEnd ? _self.periodEnd : periodEnd // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$HealthScoreDimension {

 String get name; int get score; double get weight; String get description; String get status;
/// Create a copy of HealthScoreDimension
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthScoreDimensionCopyWith<HealthScoreDimension> get copyWith => _$HealthScoreDimensionCopyWithImpl<HealthScoreDimension>(this as HealthScoreDimension, _$identity);

  /// Serializes this HealthScoreDimension to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthScoreDimension&&(identical(other.name, name) || other.name == name)&&(identical(other.score, score) || other.score == score)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,score,weight,description,status);

@override
String toString() {
  return 'HealthScoreDimension(name: $name, score: $score, weight: $weight, description: $description, status: $status)';
}


}

/// @nodoc
abstract mixin class $HealthScoreDimensionCopyWith<$Res>  {
  factory $HealthScoreDimensionCopyWith(HealthScoreDimension value, $Res Function(HealthScoreDimension) _then) = _$HealthScoreDimensionCopyWithImpl;
@useResult
$Res call({
 String name, int score, double weight, String description, String status
});




}
/// @nodoc
class _$HealthScoreDimensionCopyWithImpl<$Res>
    implements $HealthScoreDimensionCopyWith<$Res> {
  _$HealthScoreDimensionCopyWithImpl(this._self, this._then);

  final HealthScoreDimension _self;
  final $Res Function(HealthScoreDimension) _then;

/// Create a copy of HealthScoreDimension
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? score = null,Object? weight = null,Object? description = null,Object? status = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HealthScoreDimension].
extension HealthScoreDimensionPatterns on HealthScoreDimension {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HealthScoreDimension value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HealthScoreDimension() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HealthScoreDimension value)  $default,){
final _that = this;
switch (_that) {
case _HealthScoreDimension():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HealthScoreDimension value)?  $default,){
final _that = this;
switch (_that) {
case _HealthScoreDimension() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  int score,  double weight,  String description,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HealthScoreDimension() when $default != null:
return $default(_that.name,_that.score,_that.weight,_that.description,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  int score,  double weight,  String description,  String status)  $default,) {final _that = this;
switch (_that) {
case _HealthScoreDimension():
return $default(_that.name,_that.score,_that.weight,_that.description,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  int score,  double weight,  String description,  String status)?  $default,) {final _that = this;
switch (_that) {
case _HealthScoreDimension() when $default != null:
return $default(_that.name,_that.score,_that.weight,_that.description,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HealthScoreDimension implements HealthScoreDimension {
  const _HealthScoreDimension({required this.name, required this.score, required this.weight, required this.description, required this.status});
  factory _HealthScoreDimension.fromJson(Map<String, dynamic> json) => _$HealthScoreDimensionFromJson(json);

@override final  String name;
@override final  int score;
@override final  double weight;
@override final  String description;
@override final  String status;

/// Create a copy of HealthScoreDimension
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HealthScoreDimensionCopyWith<_HealthScoreDimension> get copyWith => __$HealthScoreDimensionCopyWithImpl<_HealthScoreDimension>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HealthScoreDimensionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HealthScoreDimension&&(identical(other.name, name) || other.name == name)&&(identical(other.score, score) || other.score == score)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,score,weight,description,status);

@override
String toString() {
  return 'HealthScoreDimension(name: $name, score: $score, weight: $weight, description: $description, status: $status)';
}


}

/// @nodoc
abstract mixin class _$HealthScoreDimensionCopyWith<$Res> implements $HealthScoreDimensionCopyWith<$Res> {
  factory _$HealthScoreDimensionCopyWith(_HealthScoreDimension value, $Res Function(_HealthScoreDimension) _then) = __$HealthScoreDimensionCopyWithImpl;
@override @useResult
$Res call({
 String name, int score, double weight, String description, String status
});




}
/// @nodoc
class __$HealthScoreDimensionCopyWithImpl<$Res>
    implements _$HealthScoreDimensionCopyWith<$Res> {
  __$HealthScoreDimensionCopyWithImpl(this._self, this._then);

  final _HealthScoreDimension _self;
  final $Res Function(_HealthScoreDimension) _then;

/// Create a copy of HealthScoreDimension
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? score = null,Object? weight = null,Object? description = null,Object? status = null,}) {
  return _then(_HealthScoreDimension(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$HealthScore {

 int get totalScore; String get grade; List<HealthScoreDimension> get dimensions; List<String> get suggestions; DateTime get periodStart; DateTime get periodEnd;
/// Create a copy of HealthScore
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthScoreCopyWith<HealthScore> get copyWith => _$HealthScoreCopyWithImpl<HealthScore>(this as HealthScore, _$identity);

  /// Serializes this HealthScore to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthScore&&(identical(other.totalScore, totalScore) || other.totalScore == totalScore)&&(identical(other.grade, grade) || other.grade == grade)&&const DeepCollectionEquality().equals(other.dimensions, dimensions)&&const DeepCollectionEquality().equals(other.suggestions, suggestions)&&(identical(other.periodStart, periodStart) || other.periodStart == periodStart)&&(identical(other.periodEnd, periodEnd) || other.periodEnd == periodEnd));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalScore,grade,const DeepCollectionEquality().hash(dimensions),const DeepCollectionEquality().hash(suggestions),periodStart,periodEnd);

@override
String toString() {
  return 'HealthScore(totalScore: $totalScore, grade: $grade, dimensions: $dimensions, suggestions: $suggestions, periodStart: $periodStart, periodEnd: $periodEnd)';
}


}

/// @nodoc
abstract mixin class $HealthScoreCopyWith<$Res>  {
  factory $HealthScoreCopyWith(HealthScore value, $Res Function(HealthScore) _then) = _$HealthScoreCopyWithImpl;
@useResult
$Res call({
 int totalScore, String grade, List<HealthScoreDimension> dimensions, List<String> suggestions, DateTime periodStart, DateTime periodEnd
});




}
/// @nodoc
class _$HealthScoreCopyWithImpl<$Res>
    implements $HealthScoreCopyWith<$Res> {
  _$HealthScoreCopyWithImpl(this._self, this._then);

  final HealthScore _self;
  final $Res Function(HealthScore) _then;

/// Create a copy of HealthScore
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalScore = null,Object? grade = null,Object? dimensions = null,Object? suggestions = null,Object? periodStart = null,Object? periodEnd = null,}) {
  return _then(_self.copyWith(
totalScore: null == totalScore ? _self.totalScore : totalScore // ignore: cast_nullable_to_non_nullable
as int,grade: null == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as String,dimensions: null == dimensions ? _self.dimensions : dimensions // ignore: cast_nullable_to_non_nullable
as List<HealthScoreDimension>,suggestions: null == suggestions ? _self.suggestions : suggestions // ignore: cast_nullable_to_non_nullable
as List<String>,periodStart: null == periodStart ? _self.periodStart : periodStart // ignore: cast_nullable_to_non_nullable
as DateTime,periodEnd: null == periodEnd ? _self.periodEnd : periodEnd // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [HealthScore].
extension HealthScorePatterns on HealthScore {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HealthScore value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HealthScore() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HealthScore value)  $default,){
final _that = this;
switch (_that) {
case _HealthScore():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HealthScore value)?  $default,){
final _that = this;
switch (_that) {
case _HealthScore() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalScore,  String grade,  List<HealthScoreDimension> dimensions,  List<String> suggestions,  DateTime periodStart,  DateTime periodEnd)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HealthScore() when $default != null:
return $default(_that.totalScore,_that.grade,_that.dimensions,_that.suggestions,_that.periodStart,_that.periodEnd);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalScore,  String grade,  List<HealthScoreDimension> dimensions,  List<String> suggestions,  DateTime periodStart,  DateTime periodEnd)  $default,) {final _that = this;
switch (_that) {
case _HealthScore():
return $default(_that.totalScore,_that.grade,_that.dimensions,_that.suggestions,_that.periodStart,_that.periodEnd);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalScore,  String grade,  List<HealthScoreDimension> dimensions,  List<String> suggestions,  DateTime periodStart,  DateTime periodEnd)?  $default,) {final _that = this;
switch (_that) {
case _HealthScore() when $default != null:
return $default(_that.totalScore,_that.grade,_that.dimensions,_that.suggestions,_that.periodStart,_that.periodEnd);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HealthScore implements HealthScore {
  const _HealthScore({required this.totalScore, required this.grade, required final  List<HealthScoreDimension> dimensions, final  List<String> suggestions = const [], required this.periodStart, required this.periodEnd}): _dimensions = dimensions,_suggestions = suggestions;
  factory _HealthScore.fromJson(Map<String, dynamic> json) => _$HealthScoreFromJson(json);

@override final  int totalScore;
@override final  String grade;
 final  List<HealthScoreDimension> _dimensions;
@override List<HealthScoreDimension> get dimensions {
  if (_dimensions is EqualUnmodifiableListView) return _dimensions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dimensions);
}

 final  List<String> _suggestions;
@override@JsonKey() List<String> get suggestions {
  if (_suggestions is EqualUnmodifiableListView) return _suggestions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_suggestions);
}

@override final  DateTime periodStart;
@override final  DateTime periodEnd;

/// Create a copy of HealthScore
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HealthScoreCopyWith<_HealthScore> get copyWith => __$HealthScoreCopyWithImpl<_HealthScore>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HealthScoreToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HealthScore&&(identical(other.totalScore, totalScore) || other.totalScore == totalScore)&&(identical(other.grade, grade) || other.grade == grade)&&const DeepCollectionEquality().equals(other._dimensions, _dimensions)&&const DeepCollectionEquality().equals(other._suggestions, _suggestions)&&(identical(other.periodStart, periodStart) || other.periodStart == periodStart)&&(identical(other.periodEnd, periodEnd) || other.periodEnd == periodEnd));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalScore,grade,const DeepCollectionEquality().hash(_dimensions),const DeepCollectionEquality().hash(_suggestions),periodStart,periodEnd);

@override
String toString() {
  return 'HealthScore(totalScore: $totalScore, grade: $grade, dimensions: $dimensions, suggestions: $suggestions, periodStart: $periodStart, periodEnd: $periodEnd)';
}


}

/// @nodoc
abstract mixin class _$HealthScoreCopyWith<$Res> implements $HealthScoreCopyWith<$Res> {
  factory _$HealthScoreCopyWith(_HealthScore value, $Res Function(_HealthScore) _then) = __$HealthScoreCopyWithImpl;
@override @useResult
$Res call({
 int totalScore, String grade, List<HealthScoreDimension> dimensions, List<String> suggestions, DateTime periodStart, DateTime periodEnd
});




}
/// @nodoc
class __$HealthScoreCopyWithImpl<$Res>
    implements _$HealthScoreCopyWith<$Res> {
  __$HealthScoreCopyWithImpl(this._self, this._then);

  final _HealthScore _self;
  final $Res Function(_HealthScore) _then;

/// Create a copy of HealthScore
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalScore = null,Object? grade = null,Object? dimensions = null,Object? suggestions = null,Object? periodStart = null,Object? periodEnd = null,}) {
  return _then(_HealthScore(
totalScore: null == totalScore ? _self.totalScore : totalScore // ignore: cast_nullable_to_non_nullable
as int,grade: null == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as String,dimensions: null == dimensions ? _self._dimensions : dimensions // ignore: cast_nullable_to_non_nullable
as List<HealthScoreDimension>,suggestions: null == suggestions ? _self._suggestions : suggestions // ignore: cast_nullable_to_non_nullable
as List<String>,periodStart: null == periodStart ? _self.periodStart : periodStart // ignore: cast_nullable_to_non_nullable
as DateTime,periodEnd: null == periodEnd ? _self.periodEnd : periodEnd // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
