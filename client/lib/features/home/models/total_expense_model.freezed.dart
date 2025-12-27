// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'total_expense_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TotalExpenseDisplay {

 String get value;@JsonKey(name: 'currencySymbol') String get currencySymbol;@JsonKey(name: 'fullString') String get fullString;
/// Create a copy of TotalExpenseDisplay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TotalExpenseDisplayCopyWith<TotalExpenseDisplay> get copyWith => _$TotalExpenseDisplayCopyWithImpl<TotalExpenseDisplay>(this as TotalExpenseDisplay, _$identity);

  /// Serializes this TotalExpenseDisplay to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TotalExpenseDisplay&&(identical(other.value, value) || other.value == value)&&(identical(other.currencySymbol, currencySymbol) || other.currencySymbol == currencySymbol)&&(identical(other.fullString, fullString) || other.fullString == fullString));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value,currencySymbol,fullString);

@override
String toString() {
  return 'TotalExpenseDisplay(value: $value, currencySymbol: $currencySymbol, fullString: $fullString)';
}


}

/// @nodoc
abstract mixin class $TotalExpenseDisplayCopyWith<$Res>  {
  factory $TotalExpenseDisplayCopyWith(TotalExpenseDisplay value, $Res Function(TotalExpenseDisplay) _then) = _$TotalExpenseDisplayCopyWithImpl;
@useResult
$Res call({
 String value,@JsonKey(name: 'currencySymbol') String currencySymbol,@JsonKey(name: 'fullString') String fullString
});




}
/// @nodoc
class _$TotalExpenseDisplayCopyWithImpl<$Res>
    implements $TotalExpenseDisplayCopyWith<$Res> {
  _$TotalExpenseDisplayCopyWithImpl(this._self, this._then);

  final TotalExpenseDisplay _self;
  final $Res Function(TotalExpenseDisplay) _then;

/// Create a copy of TotalExpenseDisplay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = null,Object? currencySymbol = null,Object? fullString = null,}) {
  return _then(_self.copyWith(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,currencySymbol: null == currencySymbol ? _self.currencySymbol : currencySymbol // ignore: cast_nullable_to_non_nullable
as String,fullString: null == fullString ? _self.fullString : fullString // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TotalExpenseDisplay].
extension TotalExpenseDisplayPatterns on TotalExpenseDisplay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TotalExpenseDisplay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TotalExpenseDisplay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TotalExpenseDisplay value)  $default,){
final _that = this;
switch (_that) {
case _TotalExpenseDisplay():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TotalExpenseDisplay value)?  $default,){
final _that = this;
switch (_that) {
case _TotalExpenseDisplay() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String value, @JsonKey(name: 'currencySymbol')  String currencySymbol, @JsonKey(name: 'fullString')  String fullString)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TotalExpenseDisplay() when $default != null:
return $default(_that.value,_that.currencySymbol,_that.fullString);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String value, @JsonKey(name: 'currencySymbol')  String currencySymbol, @JsonKey(name: 'fullString')  String fullString)  $default,) {final _that = this;
switch (_that) {
case _TotalExpenseDisplay():
return $default(_that.value,_that.currencySymbol,_that.fullString);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String value, @JsonKey(name: 'currencySymbol')  String currencySymbol, @JsonKey(name: 'fullString')  String fullString)?  $default,) {final _that = this;
switch (_that) {
case _TotalExpenseDisplay() when $default != null:
return $default(_that.value,_that.currencySymbol,_that.fullString);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TotalExpenseDisplay implements TotalExpenseDisplay {
  const _TotalExpenseDisplay({required this.value, @JsonKey(name: 'currencySymbol') required this.currencySymbol, @JsonKey(name: 'fullString') required this.fullString});
  factory _TotalExpenseDisplay.fromJson(Map<String, dynamic> json) => _$TotalExpenseDisplayFromJson(json);

@override final  String value;
@override@JsonKey(name: 'currencySymbol') final  String currencySymbol;
@override@JsonKey(name: 'fullString') final  String fullString;

/// Create a copy of TotalExpenseDisplay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TotalExpenseDisplayCopyWith<_TotalExpenseDisplay> get copyWith => __$TotalExpenseDisplayCopyWithImpl<_TotalExpenseDisplay>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TotalExpenseDisplayToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TotalExpenseDisplay&&(identical(other.value, value) || other.value == value)&&(identical(other.currencySymbol, currencySymbol) || other.currencySymbol == currencySymbol)&&(identical(other.fullString, fullString) || other.fullString == fullString));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value,currencySymbol,fullString);

@override
String toString() {
  return 'TotalExpenseDisplay(value: $value, currencySymbol: $currencySymbol, fullString: $fullString)';
}


}

/// @nodoc
abstract mixin class _$TotalExpenseDisplayCopyWith<$Res> implements $TotalExpenseDisplayCopyWith<$Res> {
  factory _$TotalExpenseDisplayCopyWith(_TotalExpenseDisplay value, $Res Function(_TotalExpenseDisplay) _then) = __$TotalExpenseDisplayCopyWithImpl;
@override @useResult
$Res call({
 String value,@JsonKey(name: 'currencySymbol') String currencySymbol,@JsonKey(name: 'fullString') String fullString
});




}
/// @nodoc
class __$TotalExpenseDisplayCopyWithImpl<$Res>
    implements _$TotalExpenseDisplayCopyWith<$Res> {
  __$TotalExpenseDisplayCopyWithImpl(this._self, this._then);

  final _TotalExpenseDisplay _self;
  final $Res Function(_TotalExpenseDisplay) _then;

/// Create a copy of TotalExpenseDisplay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = null,Object? currencySymbol = null,Object? fullString = null,}) {
  return _then(_TotalExpenseDisplay(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,currencySymbol: null == currencySymbol ? _self.currencySymbol : currencySymbol // ignore: cast_nullable_to_non_nullable
as String,fullString: null == fullString ? _self.fullString : fullString // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$TotalExpenseData {

@JsonKey(name: 'total_expense') double get totalExpense;@JsonKey(name: 'today_expense') double get todayExpense;@JsonKey(name: 'month_expense') double get monthExpense;@JsonKey(name: 'year_expense') double get yearExpense; String get currency; TotalExpenseDisplay? get display;
/// Create a copy of TotalExpenseData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TotalExpenseDataCopyWith<TotalExpenseData> get copyWith => _$TotalExpenseDataCopyWithImpl<TotalExpenseData>(this as TotalExpenseData, _$identity);

  /// Serializes this TotalExpenseData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TotalExpenseData&&(identical(other.totalExpense, totalExpense) || other.totalExpense == totalExpense)&&(identical(other.todayExpense, todayExpense) || other.todayExpense == todayExpense)&&(identical(other.monthExpense, monthExpense) || other.monthExpense == monthExpense)&&(identical(other.yearExpense, yearExpense) || other.yearExpense == yearExpense)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.display, display) || other.display == display));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalExpense,todayExpense,monthExpense,yearExpense,currency,display);

@override
String toString() {
  return 'TotalExpenseData(totalExpense: $totalExpense, todayExpense: $todayExpense, monthExpense: $monthExpense, yearExpense: $yearExpense, currency: $currency, display: $display)';
}


}

/// @nodoc
abstract mixin class $TotalExpenseDataCopyWith<$Res>  {
  factory $TotalExpenseDataCopyWith(TotalExpenseData value, $Res Function(TotalExpenseData) _then) = _$TotalExpenseDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'total_expense') double totalExpense,@JsonKey(name: 'today_expense') double todayExpense,@JsonKey(name: 'month_expense') double monthExpense,@JsonKey(name: 'year_expense') double yearExpense, String currency, TotalExpenseDisplay? display
});


$TotalExpenseDisplayCopyWith<$Res>? get display;

}
/// @nodoc
class _$TotalExpenseDataCopyWithImpl<$Res>
    implements $TotalExpenseDataCopyWith<$Res> {
  _$TotalExpenseDataCopyWithImpl(this._self, this._then);

  final TotalExpenseData _self;
  final $Res Function(TotalExpenseData) _then;

/// Create a copy of TotalExpenseData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalExpense = null,Object? todayExpense = null,Object? monthExpense = null,Object? yearExpense = null,Object? currency = null,Object? display = freezed,}) {
  return _then(_self.copyWith(
totalExpense: null == totalExpense ? _self.totalExpense : totalExpense // ignore: cast_nullable_to_non_nullable
as double,todayExpense: null == todayExpense ? _self.todayExpense : todayExpense // ignore: cast_nullable_to_non_nullable
as double,monthExpense: null == monthExpense ? _self.monthExpense : monthExpense // ignore: cast_nullable_to_non_nullable
as double,yearExpense: null == yearExpense ? _self.yearExpense : yearExpense // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,display: freezed == display ? _self.display : display // ignore: cast_nullable_to_non_nullable
as TotalExpenseDisplay?,
  ));
}
/// Create a copy of TotalExpenseData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TotalExpenseDisplayCopyWith<$Res>? get display {
    if (_self.display == null) {
    return null;
  }

  return $TotalExpenseDisplayCopyWith<$Res>(_self.display!, (value) {
    return _then(_self.copyWith(display: value));
  });
}
}


/// Adds pattern-matching-related methods to [TotalExpenseData].
extension TotalExpenseDataPatterns on TotalExpenseData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TotalExpenseData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TotalExpenseData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TotalExpenseData value)  $default,){
final _that = this;
switch (_that) {
case _TotalExpenseData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TotalExpenseData value)?  $default,){
final _that = this;
switch (_that) {
case _TotalExpenseData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_expense')  double totalExpense, @JsonKey(name: 'today_expense')  double todayExpense, @JsonKey(name: 'month_expense')  double monthExpense, @JsonKey(name: 'year_expense')  double yearExpense,  String currency,  TotalExpenseDisplay? display)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TotalExpenseData() when $default != null:
return $default(_that.totalExpense,_that.todayExpense,_that.monthExpense,_that.yearExpense,_that.currency,_that.display);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'total_expense')  double totalExpense, @JsonKey(name: 'today_expense')  double todayExpense, @JsonKey(name: 'month_expense')  double monthExpense, @JsonKey(name: 'year_expense')  double yearExpense,  String currency,  TotalExpenseDisplay? display)  $default,) {final _that = this;
switch (_that) {
case _TotalExpenseData():
return $default(_that.totalExpense,_that.todayExpense,_that.monthExpense,_that.yearExpense,_that.currency,_that.display);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'total_expense')  double totalExpense, @JsonKey(name: 'today_expense')  double todayExpense, @JsonKey(name: 'month_expense')  double monthExpense, @JsonKey(name: 'year_expense')  double yearExpense,  String currency,  TotalExpenseDisplay? display)?  $default,) {final _that = this;
switch (_that) {
case _TotalExpenseData() when $default != null:
return $default(_that.totalExpense,_that.todayExpense,_that.monthExpense,_that.yearExpense,_that.currency,_that.display);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TotalExpenseData implements TotalExpenseData {
  const _TotalExpenseData({@JsonKey(name: 'total_expense') required this.totalExpense, @JsonKey(name: 'today_expense') required this.todayExpense, @JsonKey(name: 'month_expense') required this.monthExpense, @JsonKey(name: 'year_expense') required this.yearExpense, required this.currency, this.display});
  factory _TotalExpenseData.fromJson(Map<String, dynamic> json) => _$TotalExpenseDataFromJson(json);

@override@JsonKey(name: 'total_expense') final  double totalExpense;
@override@JsonKey(name: 'today_expense') final  double todayExpense;
@override@JsonKey(name: 'month_expense') final  double monthExpense;
@override@JsonKey(name: 'year_expense') final  double yearExpense;
@override final  String currency;
@override final  TotalExpenseDisplay? display;

/// Create a copy of TotalExpenseData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TotalExpenseDataCopyWith<_TotalExpenseData> get copyWith => __$TotalExpenseDataCopyWithImpl<_TotalExpenseData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TotalExpenseDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TotalExpenseData&&(identical(other.totalExpense, totalExpense) || other.totalExpense == totalExpense)&&(identical(other.todayExpense, todayExpense) || other.todayExpense == todayExpense)&&(identical(other.monthExpense, monthExpense) || other.monthExpense == monthExpense)&&(identical(other.yearExpense, yearExpense) || other.yearExpense == yearExpense)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.display, display) || other.display == display));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalExpense,todayExpense,monthExpense,yearExpense,currency,display);

@override
String toString() {
  return 'TotalExpenseData(totalExpense: $totalExpense, todayExpense: $todayExpense, monthExpense: $monthExpense, yearExpense: $yearExpense, currency: $currency, display: $display)';
}


}

/// @nodoc
abstract mixin class _$TotalExpenseDataCopyWith<$Res> implements $TotalExpenseDataCopyWith<$Res> {
  factory _$TotalExpenseDataCopyWith(_TotalExpenseData value, $Res Function(_TotalExpenseData) _then) = __$TotalExpenseDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'total_expense') double totalExpense,@JsonKey(name: 'today_expense') double todayExpense,@JsonKey(name: 'month_expense') double monthExpense,@JsonKey(name: 'year_expense') double yearExpense, String currency, TotalExpenseDisplay? display
});


@override $TotalExpenseDisplayCopyWith<$Res>? get display;

}
/// @nodoc
class __$TotalExpenseDataCopyWithImpl<$Res>
    implements _$TotalExpenseDataCopyWith<$Res> {
  __$TotalExpenseDataCopyWithImpl(this._self, this._then);

  final _TotalExpenseData _self;
  final $Res Function(_TotalExpenseData) _then;

/// Create a copy of TotalExpenseData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalExpense = null,Object? todayExpense = null,Object? monthExpense = null,Object? yearExpense = null,Object? currency = null,Object? display = freezed,}) {
  return _then(_TotalExpenseData(
totalExpense: null == totalExpense ? _self.totalExpense : totalExpense // ignore: cast_nullable_to_non_nullable
as double,todayExpense: null == todayExpense ? _self.todayExpense : todayExpense // ignore: cast_nullable_to_non_nullable
as double,monthExpense: null == monthExpense ? _self.monthExpense : monthExpense // ignore: cast_nullable_to_non_nullable
as double,yearExpense: null == yearExpense ? _self.yearExpense : yearExpense // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,display: freezed == display ? _self.display : display // ignore: cast_nullable_to_non_nullable
as TotalExpenseDisplay?,
  ));
}

/// Create a copy of TotalExpenseData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TotalExpenseDisplayCopyWith<$Res>? get display {
    if (_self.display == null) {
    return null;
  }

  return $TotalExpenseDisplayCopyWith<$Res>(_self.display!, (value) {
    return _then(_self.copyWith(display: value));
  });
}
}

// dart format on
