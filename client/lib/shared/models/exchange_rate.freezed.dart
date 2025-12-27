// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exchange_rate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExchangeRateResponse {

@JsonKey(name: 'base_code') String get baseCode;@JsonKey(name: 'last_update_utc') String? get lastUpdateUtc;@JsonKey(name: 'conversion_rates') Map<String, double> get conversionRates;
/// Create a copy of ExchangeRateResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExchangeRateResponseCopyWith<ExchangeRateResponse> get copyWith => _$ExchangeRateResponseCopyWithImpl<ExchangeRateResponse>(this as ExchangeRateResponse, _$identity);

  /// Serializes this ExchangeRateResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExchangeRateResponse&&(identical(other.baseCode, baseCode) || other.baseCode == baseCode)&&(identical(other.lastUpdateUtc, lastUpdateUtc) || other.lastUpdateUtc == lastUpdateUtc)&&const DeepCollectionEquality().equals(other.conversionRates, conversionRates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,baseCode,lastUpdateUtc,const DeepCollectionEquality().hash(conversionRates));

@override
String toString() {
  return 'ExchangeRateResponse(baseCode: $baseCode, lastUpdateUtc: $lastUpdateUtc, conversionRates: $conversionRates)';
}


}

/// @nodoc
abstract mixin class $ExchangeRateResponseCopyWith<$Res>  {
  factory $ExchangeRateResponseCopyWith(ExchangeRateResponse value, $Res Function(ExchangeRateResponse) _then) = _$ExchangeRateResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'base_code') String baseCode,@JsonKey(name: 'last_update_utc') String? lastUpdateUtc,@JsonKey(name: 'conversion_rates') Map<String, double> conversionRates
});




}
/// @nodoc
class _$ExchangeRateResponseCopyWithImpl<$Res>
    implements $ExchangeRateResponseCopyWith<$Res> {
  _$ExchangeRateResponseCopyWithImpl(this._self, this._then);

  final ExchangeRateResponse _self;
  final $Res Function(ExchangeRateResponse) _then;

/// Create a copy of ExchangeRateResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? baseCode = null,Object? lastUpdateUtc = freezed,Object? conversionRates = null,}) {
  return _then(_self.copyWith(
baseCode: null == baseCode ? _self.baseCode : baseCode // ignore: cast_nullable_to_non_nullable
as String,lastUpdateUtc: freezed == lastUpdateUtc ? _self.lastUpdateUtc : lastUpdateUtc // ignore: cast_nullable_to_non_nullable
as String?,conversionRates: null == conversionRates ? _self.conversionRates : conversionRates // ignore: cast_nullable_to_non_nullable
as Map<String, double>,
  ));
}

}


/// Adds pattern-matching-related methods to [ExchangeRateResponse].
extension ExchangeRateResponsePatterns on ExchangeRateResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExchangeRateResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExchangeRateResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExchangeRateResponse value)  $default,){
final _that = this;
switch (_that) {
case _ExchangeRateResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExchangeRateResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ExchangeRateResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'base_code')  String baseCode, @JsonKey(name: 'last_update_utc')  String? lastUpdateUtc, @JsonKey(name: 'conversion_rates')  Map<String, double> conversionRates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExchangeRateResponse() when $default != null:
return $default(_that.baseCode,_that.lastUpdateUtc,_that.conversionRates);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'base_code')  String baseCode, @JsonKey(name: 'last_update_utc')  String? lastUpdateUtc, @JsonKey(name: 'conversion_rates')  Map<String, double> conversionRates)  $default,) {final _that = this;
switch (_that) {
case _ExchangeRateResponse():
return $default(_that.baseCode,_that.lastUpdateUtc,_that.conversionRates);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'base_code')  String baseCode, @JsonKey(name: 'last_update_utc')  String? lastUpdateUtc, @JsonKey(name: 'conversion_rates')  Map<String, double> conversionRates)?  $default,) {final _that = this;
switch (_that) {
case _ExchangeRateResponse() when $default != null:
return $default(_that.baseCode,_that.lastUpdateUtc,_that.conversionRates);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExchangeRateResponse implements ExchangeRateResponse {
  const _ExchangeRateResponse({@JsonKey(name: 'base_code') required this.baseCode, @JsonKey(name: 'last_update_utc') this.lastUpdateUtc, @JsonKey(name: 'conversion_rates') required final  Map<String, double> conversionRates}): _conversionRates = conversionRates;
  factory _ExchangeRateResponse.fromJson(Map<String, dynamic> json) => _$ExchangeRateResponseFromJson(json);

@override@JsonKey(name: 'base_code') final  String baseCode;
@override@JsonKey(name: 'last_update_utc') final  String? lastUpdateUtc;
 final  Map<String, double> _conversionRates;
@override@JsonKey(name: 'conversion_rates') Map<String, double> get conversionRates {
  if (_conversionRates is EqualUnmodifiableMapView) return _conversionRates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_conversionRates);
}


/// Create a copy of ExchangeRateResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExchangeRateResponseCopyWith<_ExchangeRateResponse> get copyWith => __$ExchangeRateResponseCopyWithImpl<_ExchangeRateResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExchangeRateResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExchangeRateResponse&&(identical(other.baseCode, baseCode) || other.baseCode == baseCode)&&(identical(other.lastUpdateUtc, lastUpdateUtc) || other.lastUpdateUtc == lastUpdateUtc)&&const DeepCollectionEquality().equals(other._conversionRates, _conversionRates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,baseCode,lastUpdateUtc,const DeepCollectionEquality().hash(_conversionRates));

@override
String toString() {
  return 'ExchangeRateResponse(baseCode: $baseCode, lastUpdateUtc: $lastUpdateUtc, conversionRates: $conversionRates)';
}


}

/// @nodoc
abstract mixin class _$ExchangeRateResponseCopyWith<$Res> implements $ExchangeRateResponseCopyWith<$Res> {
  factory _$ExchangeRateResponseCopyWith(_ExchangeRateResponse value, $Res Function(_ExchangeRateResponse) _then) = __$ExchangeRateResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'base_code') String baseCode,@JsonKey(name: 'last_update_utc') String? lastUpdateUtc,@JsonKey(name: 'conversion_rates') Map<String, double> conversionRates
});




}
/// @nodoc
class __$ExchangeRateResponseCopyWithImpl<$Res>
    implements _$ExchangeRateResponseCopyWith<$Res> {
  __$ExchangeRateResponseCopyWithImpl(this._self, this._then);

  final _ExchangeRateResponse _self;
  final $Res Function(_ExchangeRateResponse) _then;

/// Create a copy of ExchangeRateResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? baseCode = null,Object? lastUpdateUtc = freezed,Object? conversionRates = null,}) {
  return _then(_ExchangeRateResponse(
baseCode: null == baseCode ? _self.baseCode : baseCode // ignore: cast_nullable_to_non_nullable
as String,lastUpdateUtc: freezed == lastUpdateUtc ? _self.lastUpdateUtc : lastUpdateUtc // ignore: cast_nullable_to_non_nullable
as String?,conversionRates: null == conversionRates ? _self._conversionRates : conversionRates // ignore: cast_nullable_to_non_nullable
as Map<String, double>,
  ));
}


}

// dart format on
