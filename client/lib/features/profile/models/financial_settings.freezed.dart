// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'financial_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FinancialSettingsRequest {

@JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonNullable) Decimal? get safetyThreshold;@JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonNullable) Decimal? get dailyBurnRate; String? get burnRateMode; String? get primaryCurrency; int? get monthStartDay;
/// Create a copy of FinancialSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinancialSettingsRequestCopyWith<FinancialSettingsRequest> get copyWith => _$FinancialSettingsRequestCopyWithImpl<FinancialSettingsRequest>(this as FinancialSettingsRequest, _$identity);

  /// Serializes this FinancialSettingsRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinancialSettingsRequest&&(identical(other.safetyThreshold, safetyThreshold) || other.safetyThreshold == safetyThreshold)&&(identical(other.dailyBurnRate, dailyBurnRate) || other.dailyBurnRate == dailyBurnRate)&&(identical(other.burnRateMode, burnRateMode) || other.burnRateMode == burnRateMode)&&(identical(other.primaryCurrency, primaryCurrency) || other.primaryCurrency == primaryCurrency)&&(identical(other.monthStartDay, monthStartDay) || other.monthStartDay == monthStartDay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,safetyThreshold,dailyBurnRate,burnRateMode,primaryCurrency,monthStartDay);

@override
String toString() {
  return 'FinancialSettingsRequest(safetyThreshold: $safetyThreshold, dailyBurnRate: $dailyBurnRate, burnRateMode: $burnRateMode, primaryCurrency: $primaryCurrency, monthStartDay: $monthStartDay)';
}


}

/// @nodoc
abstract mixin class $FinancialSettingsRequestCopyWith<$Res>  {
  factory $FinancialSettingsRequestCopyWith(FinancialSettingsRequest value, $Res Function(FinancialSettingsRequest) _then) = _$FinancialSettingsRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonNullable) Decimal? safetyThreshold,@JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonNullable) Decimal? dailyBurnRate, String? burnRateMode, String? primaryCurrency, int? monthStartDay
});




}
/// @nodoc
class _$FinancialSettingsRequestCopyWithImpl<$Res>
    implements $FinancialSettingsRequestCopyWith<$Res> {
  _$FinancialSettingsRequestCopyWithImpl(this._self, this._then);

  final FinancialSettingsRequest _self;
  final $Res Function(FinancialSettingsRequest) _then;

/// Create a copy of FinancialSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? safetyThreshold = freezed,Object? dailyBurnRate = freezed,Object? burnRateMode = freezed,Object? primaryCurrency = freezed,Object? monthStartDay = freezed,}) {
  return _then(_self.copyWith(
safetyThreshold: freezed == safetyThreshold ? _self.safetyThreshold : safetyThreshold // ignore: cast_nullable_to_non_nullable
as Decimal?,dailyBurnRate: freezed == dailyBurnRate ? _self.dailyBurnRate : dailyBurnRate // ignore: cast_nullable_to_non_nullable
as Decimal?,burnRateMode: freezed == burnRateMode ? _self.burnRateMode : burnRateMode // ignore: cast_nullable_to_non_nullable
as String?,primaryCurrency: freezed == primaryCurrency ? _self.primaryCurrency : primaryCurrency // ignore: cast_nullable_to_non_nullable
as String?,monthStartDay: freezed == monthStartDay ? _self.monthStartDay : monthStartDay // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [FinancialSettingsRequest].
extension FinancialSettingsRequestPatterns on FinancialSettingsRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinancialSettingsRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinancialSettingsRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinancialSettingsRequest value)  $default,){
final _that = this;
switch (_that) {
case _FinancialSettingsRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinancialSettingsRequest value)?  $default,){
final _that = this;
switch (_that) {
case _FinancialSettingsRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonNullable)  Decimal? safetyThreshold, @JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonNullable)  Decimal? dailyBurnRate,  String? burnRateMode,  String? primaryCurrency,  int? monthStartDay)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinancialSettingsRequest() when $default != null:
return $default(_that.safetyThreshold,_that.dailyBurnRate,_that.burnRateMode,_that.primaryCurrency,_that.monthStartDay);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonNullable)  Decimal? safetyThreshold, @JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonNullable)  Decimal? dailyBurnRate,  String? burnRateMode,  String? primaryCurrency,  int? monthStartDay)  $default,) {final _that = this;
switch (_that) {
case _FinancialSettingsRequest():
return $default(_that.safetyThreshold,_that.dailyBurnRate,_that.burnRateMode,_that.primaryCurrency,_that.monthStartDay);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonNullable)  Decimal? safetyThreshold, @JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonNullable)  Decimal? dailyBurnRate,  String? burnRateMode,  String? primaryCurrency,  int? monthStartDay)?  $default,) {final _that = this;
switch (_that) {
case _FinancialSettingsRequest() when $default != null:
return $default(_that.safetyThreshold,_that.dailyBurnRate,_that.burnRateMode,_that.primaryCurrency,_that.monthStartDay);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FinancialSettingsRequest implements FinancialSettingsRequest {
  const _FinancialSettingsRequest({@JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonNullable) this.safetyThreshold, @JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonNullable) this.dailyBurnRate, this.burnRateMode, this.primaryCurrency, this.monthStartDay});
  factory _FinancialSettingsRequest.fromJson(Map<String, dynamic> json) => _$FinancialSettingsRequestFromJson(json);

@override@JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonNullable) final  Decimal? safetyThreshold;
@override@JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonNullable) final  Decimal? dailyBurnRate;
@override final  String? burnRateMode;
@override final  String? primaryCurrency;
@override final  int? monthStartDay;

/// Create a copy of FinancialSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinancialSettingsRequestCopyWith<_FinancialSettingsRequest> get copyWith => __$FinancialSettingsRequestCopyWithImpl<_FinancialSettingsRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FinancialSettingsRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinancialSettingsRequest&&(identical(other.safetyThreshold, safetyThreshold) || other.safetyThreshold == safetyThreshold)&&(identical(other.dailyBurnRate, dailyBurnRate) || other.dailyBurnRate == dailyBurnRate)&&(identical(other.burnRateMode, burnRateMode) || other.burnRateMode == burnRateMode)&&(identical(other.primaryCurrency, primaryCurrency) || other.primaryCurrency == primaryCurrency)&&(identical(other.monthStartDay, monthStartDay) || other.monthStartDay == monthStartDay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,safetyThreshold,dailyBurnRate,burnRateMode,primaryCurrency,monthStartDay);

@override
String toString() {
  return 'FinancialSettingsRequest(safetyThreshold: $safetyThreshold, dailyBurnRate: $dailyBurnRate, burnRateMode: $burnRateMode, primaryCurrency: $primaryCurrency, monthStartDay: $monthStartDay)';
}


}

/// @nodoc
abstract mixin class _$FinancialSettingsRequestCopyWith<$Res> implements $FinancialSettingsRequestCopyWith<$Res> {
  factory _$FinancialSettingsRequestCopyWith(_FinancialSettingsRequest value, $Res Function(_FinancialSettingsRequest) _then) = __$FinancialSettingsRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonNullable) Decimal? safetyThreshold,@JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonNullable) Decimal? dailyBurnRate, String? burnRateMode, String? primaryCurrency, int? monthStartDay
});




}
/// @nodoc
class __$FinancialSettingsRequestCopyWithImpl<$Res>
    implements _$FinancialSettingsRequestCopyWith<$Res> {
  __$FinancialSettingsRequestCopyWithImpl(this._self, this._then);

  final _FinancialSettingsRequest _self;
  final $Res Function(_FinancialSettingsRequest) _then;

/// Create a copy of FinancialSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? safetyThreshold = freezed,Object? dailyBurnRate = freezed,Object? burnRateMode = freezed,Object? primaryCurrency = freezed,Object? monthStartDay = freezed,}) {
  return _then(_FinancialSettingsRequest(
safetyThreshold: freezed == safetyThreshold ? _self.safetyThreshold : safetyThreshold // ignore: cast_nullable_to_non_nullable
as Decimal?,dailyBurnRate: freezed == dailyBurnRate ? _self.dailyBurnRate : dailyBurnRate // ignore: cast_nullable_to_non_nullable
as Decimal?,burnRateMode: freezed == burnRateMode ? _self.burnRateMode : burnRateMode // ignore: cast_nullable_to_non_nullable
as String?,primaryCurrency: freezed == primaryCurrency ? _self.primaryCurrency : primaryCurrency // ignore: cast_nullable_to_non_nullable
as String?,monthStartDay: freezed == monthStartDay ? _self.monthStartDay : monthStartDay // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$FinancialSettingsResponse {

@JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson) Decimal get safetyThreshold;@JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson) Decimal get dailyBurnRate; String get burnRateMode; String get primaryCurrency; int get monthStartDay; String? get updatedAt;
/// Create a copy of FinancialSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinancialSettingsResponseCopyWith<FinancialSettingsResponse> get copyWith => _$FinancialSettingsResponseCopyWithImpl<FinancialSettingsResponse>(this as FinancialSettingsResponse, _$identity);

  /// Serializes this FinancialSettingsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinancialSettingsResponse&&(identical(other.safetyThreshold, safetyThreshold) || other.safetyThreshold == safetyThreshold)&&(identical(other.dailyBurnRate, dailyBurnRate) || other.dailyBurnRate == dailyBurnRate)&&(identical(other.burnRateMode, burnRateMode) || other.burnRateMode == burnRateMode)&&(identical(other.primaryCurrency, primaryCurrency) || other.primaryCurrency == primaryCurrency)&&(identical(other.monthStartDay, monthStartDay) || other.monthStartDay == monthStartDay)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,safetyThreshold,dailyBurnRate,burnRateMode,primaryCurrency,monthStartDay,updatedAt);

@override
String toString() {
  return 'FinancialSettingsResponse(safetyThreshold: $safetyThreshold, dailyBurnRate: $dailyBurnRate, burnRateMode: $burnRateMode, primaryCurrency: $primaryCurrency, monthStartDay: $monthStartDay, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $FinancialSettingsResponseCopyWith<$Res>  {
  factory $FinancialSettingsResponseCopyWith(FinancialSettingsResponse value, $Res Function(FinancialSettingsResponse) _then) = _$FinancialSettingsResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson) Decimal safetyThreshold,@JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson) Decimal dailyBurnRate, String burnRateMode, String primaryCurrency, int monthStartDay, String? updatedAt
});




}
/// @nodoc
class _$FinancialSettingsResponseCopyWithImpl<$Res>
    implements $FinancialSettingsResponseCopyWith<$Res> {
  _$FinancialSettingsResponseCopyWithImpl(this._self, this._then);

  final FinancialSettingsResponse _self;
  final $Res Function(FinancialSettingsResponse) _then;

/// Create a copy of FinancialSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? safetyThreshold = null,Object? dailyBurnRate = null,Object? burnRateMode = null,Object? primaryCurrency = null,Object? monthStartDay = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
safetyThreshold: null == safetyThreshold ? _self.safetyThreshold : safetyThreshold // ignore: cast_nullable_to_non_nullable
as Decimal,dailyBurnRate: null == dailyBurnRate ? _self.dailyBurnRate : dailyBurnRate // ignore: cast_nullable_to_non_nullable
as Decimal,burnRateMode: null == burnRateMode ? _self.burnRateMode : burnRateMode // ignore: cast_nullable_to_non_nullable
as String,primaryCurrency: null == primaryCurrency ? _self.primaryCurrency : primaryCurrency // ignore: cast_nullable_to_non_nullable
as String,monthStartDay: null == monthStartDay ? _self.monthStartDay : monthStartDay // ignore: cast_nullable_to_non_nullable
as int,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FinancialSettingsResponse].
extension FinancialSettingsResponsePatterns on FinancialSettingsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinancialSettingsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinancialSettingsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinancialSettingsResponse value)  $default,){
final _that = this;
switch (_that) {
case _FinancialSettingsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinancialSettingsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _FinancialSettingsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson)  Decimal safetyThreshold, @JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson)  Decimal dailyBurnRate,  String burnRateMode,  String primaryCurrency,  int monthStartDay,  String? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinancialSettingsResponse() when $default != null:
return $default(_that.safetyThreshold,_that.dailyBurnRate,_that.burnRateMode,_that.primaryCurrency,_that.monthStartDay,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson)  Decimal safetyThreshold, @JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson)  Decimal dailyBurnRate,  String burnRateMode,  String primaryCurrency,  int monthStartDay,  String? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _FinancialSettingsResponse():
return $default(_that.safetyThreshold,_that.dailyBurnRate,_that.burnRateMode,_that.primaryCurrency,_that.monthStartDay,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson)  Decimal safetyThreshold, @JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson)  Decimal dailyBurnRate,  String burnRateMode,  String primaryCurrency,  int monthStartDay,  String? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _FinancialSettingsResponse() when $default != null:
return $default(_that.safetyThreshold,_that.dailyBurnRate,_that.burnRateMode,_that.primaryCurrency,_that.monthStartDay,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FinancialSettingsResponse implements FinancialSettingsResponse {
  const _FinancialSettingsResponse({@JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson) required this.safetyThreshold, @JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson) required this.dailyBurnRate, required this.burnRateMode, required this.primaryCurrency, required this.monthStartDay, this.updatedAt});
  factory _FinancialSettingsResponse.fromJson(Map<String, dynamic> json) => _$FinancialSettingsResponseFromJson(json);

@override@JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson) final  Decimal safetyThreshold;
@override@JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson) final  Decimal dailyBurnRate;
@override final  String burnRateMode;
@override final  String primaryCurrency;
@override final  int monthStartDay;
@override final  String? updatedAt;

/// Create a copy of FinancialSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinancialSettingsResponseCopyWith<_FinancialSettingsResponse> get copyWith => __$FinancialSettingsResponseCopyWithImpl<_FinancialSettingsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FinancialSettingsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinancialSettingsResponse&&(identical(other.safetyThreshold, safetyThreshold) || other.safetyThreshold == safetyThreshold)&&(identical(other.dailyBurnRate, dailyBurnRate) || other.dailyBurnRate == dailyBurnRate)&&(identical(other.burnRateMode, burnRateMode) || other.burnRateMode == burnRateMode)&&(identical(other.primaryCurrency, primaryCurrency) || other.primaryCurrency == primaryCurrency)&&(identical(other.monthStartDay, monthStartDay) || other.monthStartDay == monthStartDay)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,safetyThreshold,dailyBurnRate,burnRateMode,primaryCurrency,monthStartDay,updatedAt);

@override
String toString() {
  return 'FinancialSettingsResponse(safetyThreshold: $safetyThreshold, dailyBurnRate: $dailyBurnRate, burnRateMode: $burnRateMode, primaryCurrency: $primaryCurrency, monthStartDay: $monthStartDay, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$FinancialSettingsResponseCopyWith<$Res> implements $FinancialSettingsResponseCopyWith<$Res> {
  factory _$FinancialSettingsResponseCopyWith(_FinancialSettingsResponse value, $Res Function(_FinancialSettingsResponse) _then) = __$FinancialSettingsResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson) Decimal safetyThreshold,@JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson) Decimal dailyBurnRate, String burnRateMode, String primaryCurrency, int monthStartDay, String? updatedAt
});




}
/// @nodoc
class __$FinancialSettingsResponseCopyWithImpl<$Res>
    implements _$FinancialSettingsResponseCopyWith<$Res> {
  __$FinancialSettingsResponseCopyWithImpl(this._self, this._then);

  final _FinancialSettingsResponse _self;
  final $Res Function(_FinancialSettingsResponse) _then;

/// Create a copy of FinancialSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? safetyThreshold = null,Object? dailyBurnRate = null,Object? burnRateMode = null,Object? primaryCurrency = null,Object? monthStartDay = null,Object? updatedAt = freezed,}) {
  return _then(_FinancialSettingsResponse(
safetyThreshold: null == safetyThreshold ? _self.safetyThreshold : safetyThreshold // ignore: cast_nullable_to_non_nullable
as Decimal,dailyBurnRate: null == dailyBurnRate ? _self.dailyBurnRate : dailyBurnRate // ignore: cast_nullable_to_non_nullable
as Decimal,burnRateMode: null == burnRateMode ? _self.burnRateMode : burnRateMode // ignore: cast_nullable_to_non_nullable
as String,primaryCurrency: null == primaryCurrency ? _self.primaryCurrency : primaryCurrency // ignore: cast_nullable_to_non_nullable
as String,monthStartDay: null == monthStartDay ? _self.monthStartDay : monthStartDay // ignore: cast_nullable_to_non_nullable
as int,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$FinancialSettingsState {

@JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonNullable) Decimal? get safetyThreshold;@JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonNullable) Decimal? get dailyBurnRate; String get burnRateMode; String get primaryCurrency; int get monthStartDay; String? get lastUpdatedAt; bool get isLoading; bool get hasChanges; String? get error;
/// Create a copy of FinancialSettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinancialSettingsStateCopyWith<FinancialSettingsState> get copyWith => _$FinancialSettingsStateCopyWithImpl<FinancialSettingsState>(this as FinancialSettingsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinancialSettingsState&&(identical(other.safetyThreshold, safetyThreshold) || other.safetyThreshold == safetyThreshold)&&(identical(other.dailyBurnRate, dailyBurnRate) || other.dailyBurnRate == dailyBurnRate)&&(identical(other.burnRateMode, burnRateMode) || other.burnRateMode == burnRateMode)&&(identical(other.primaryCurrency, primaryCurrency) || other.primaryCurrency == primaryCurrency)&&(identical(other.monthStartDay, monthStartDay) || other.monthStartDay == monthStartDay)&&(identical(other.lastUpdatedAt, lastUpdatedAt) || other.lastUpdatedAt == lastUpdatedAt)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasChanges, hasChanges) || other.hasChanges == hasChanges)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,safetyThreshold,dailyBurnRate,burnRateMode,primaryCurrency,monthStartDay,lastUpdatedAt,isLoading,hasChanges,error);

@override
String toString() {
  return 'FinancialSettingsState(safetyThreshold: $safetyThreshold, dailyBurnRate: $dailyBurnRate, burnRateMode: $burnRateMode, primaryCurrency: $primaryCurrency, monthStartDay: $monthStartDay, lastUpdatedAt: $lastUpdatedAt, isLoading: $isLoading, hasChanges: $hasChanges, error: $error)';
}


}

/// @nodoc
abstract mixin class $FinancialSettingsStateCopyWith<$Res>  {
  factory $FinancialSettingsStateCopyWith(FinancialSettingsState value, $Res Function(FinancialSettingsState) _then) = _$FinancialSettingsStateCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonNullable) Decimal? safetyThreshold,@JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonNullable) Decimal? dailyBurnRate, String burnRateMode, String primaryCurrency, int monthStartDay, String? lastUpdatedAt, bool isLoading, bool hasChanges, String? error
});




}
/// @nodoc
class _$FinancialSettingsStateCopyWithImpl<$Res>
    implements $FinancialSettingsStateCopyWith<$Res> {
  _$FinancialSettingsStateCopyWithImpl(this._self, this._then);

  final FinancialSettingsState _self;
  final $Res Function(FinancialSettingsState) _then;

/// Create a copy of FinancialSettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? safetyThreshold = freezed,Object? dailyBurnRate = freezed,Object? burnRateMode = null,Object? primaryCurrency = null,Object? monthStartDay = null,Object? lastUpdatedAt = freezed,Object? isLoading = null,Object? hasChanges = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
safetyThreshold: freezed == safetyThreshold ? _self.safetyThreshold : safetyThreshold // ignore: cast_nullable_to_non_nullable
as Decimal?,dailyBurnRate: freezed == dailyBurnRate ? _self.dailyBurnRate : dailyBurnRate // ignore: cast_nullable_to_non_nullable
as Decimal?,burnRateMode: null == burnRateMode ? _self.burnRateMode : burnRateMode // ignore: cast_nullable_to_non_nullable
as String,primaryCurrency: null == primaryCurrency ? _self.primaryCurrency : primaryCurrency // ignore: cast_nullable_to_non_nullable
as String,monthStartDay: null == monthStartDay ? _self.monthStartDay : monthStartDay // ignore: cast_nullable_to_non_nullable
as int,lastUpdatedAt: freezed == lastUpdatedAt ? _self.lastUpdatedAt : lastUpdatedAt // ignore: cast_nullable_to_non_nullable
as String?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasChanges: null == hasChanges ? _self.hasChanges : hasChanges // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FinancialSettingsState].
extension FinancialSettingsStatePatterns on FinancialSettingsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinancialSettingsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinancialSettingsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinancialSettingsState value)  $default,){
final _that = this;
switch (_that) {
case _FinancialSettingsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinancialSettingsState value)?  $default,){
final _that = this;
switch (_that) {
case _FinancialSettingsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonNullable)  Decimal? safetyThreshold, @JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonNullable)  Decimal? dailyBurnRate,  String burnRateMode,  String primaryCurrency,  int monthStartDay,  String? lastUpdatedAt,  bool isLoading,  bool hasChanges,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinancialSettingsState() when $default != null:
return $default(_that.safetyThreshold,_that.dailyBurnRate,_that.burnRateMode,_that.primaryCurrency,_that.monthStartDay,_that.lastUpdatedAt,_that.isLoading,_that.hasChanges,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonNullable)  Decimal? safetyThreshold, @JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonNullable)  Decimal? dailyBurnRate,  String burnRateMode,  String primaryCurrency,  int monthStartDay,  String? lastUpdatedAt,  bool isLoading,  bool hasChanges,  String? error)  $default,) {final _that = this;
switch (_that) {
case _FinancialSettingsState():
return $default(_that.safetyThreshold,_that.dailyBurnRate,_that.burnRateMode,_that.primaryCurrency,_that.monthStartDay,_that.lastUpdatedAt,_that.isLoading,_that.hasChanges,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonNullable)  Decimal? safetyThreshold, @JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonNullable)  Decimal? dailyBurnRate,  String burnRateMode,  String primaryCurrency,  int monthStartDay,  String? lastUpdatedAt,  bool isLoading,  bool hasChanges,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _FinancialSettingsState() when $default != null:
return $default(_that.safetyThreshold,_that.dailyBurnRate,_that.burnRateMode,_that.primaryCurrency,_that.monthStartDay,_that.lastUpdatedAt,_that.isLoading,_that.hasChanges,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _FinancialSettingsState extends FinancialSettingsState {
  const _FinancialSettingsState({@JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonNullable) this.safetyThreshold, @JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonNullable) this.dailyBurnRate, this.burnRateMode = "AI_AUTO", this.primaryCurrency = "USD", this.monthStartDay = 1, this.lastUpdatedAt, this.isLoading = false, this.hasChanges = false, this.error}): super._();
  

@override@JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonNullable) final  Decimal? safetyThreshold;
@override@JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonNullable) final  Decimal? dailyBurnRate;
@override@JsonKey() final  String burnRateMode;
@override@JsonKey() final  String primaryCurrency;
@override@JsonKey() final  int monthStartDay;
@override final  String? lastUpdatedAt;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool hasChanges;
@override final  String? error;

/// Create a copy of FinancialSettingsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinancialSettingsStateCopyWith<_FinancialSettingsState> get copyWith => __$FinancialSettingsStateCopyWithImpl<_FinancialSettingsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinancialSettingsState&&(identical(other.safetyThreshold, safetyThreshold) || other.safetyThreshold == safetyThreshold)&&(identical(other.dailyBurnRate, dailyBurnRate) || other.dailyBurnRate == dailyBurnRate)&&(identical(other.burnRateMode, burnRateMode) || other.burnRateMode == burnRateMode)&&(identical(other.primaryCurrency, primaryCurrency) || other.primaryCurrency == primaryCurrency)&&(identical(other.monthStartDay, monthStartDay) || other.monthStartDay == monthStartDay)&&(identical(other.lastUpdatedAt, lastUpdatedAt) || other.lastUpdatedAt == lastUpdatedAt)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasChanges, hasChanges) || other.hasChanges == hasChanges)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,safetyThreshold,dailyBurnRate,burnRateMode,primaryCurrency,monthStartDay,lastUpdatedAt,isLoading,hasChanges,error);

@override
String toString() {
  return 'FinancialSettingsState(safetyThreshold: $safetyThreshold, dailyBurnRate: $dailyBurnRate, burnRateMode: $burnRateMode, primaryCurrency: $primaryCurrency, monthStartDay: $monthStartDay, lastUpdatedAt: $lastUpdatedAt, isLoading: $isLoading, hasChanges: $hasChanges, error: $error)';
}


}

/// @nodoc
abstract mixin class _$FinancialSettingsStateCopyWith<$Res> implements $FinancialSettingsStateCopyWith<$Res> {
  factory _$FinancialSettingsStateCopyWith(_FinancialSettingsState value, $Res Function(_FinancialSettingsState) _then) = __$FinancialSettingsStateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonNullable) Decimal? safetyThreshold,@JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonNullable) Decimal? dailyBurnRate, String burnRateMode, String primaryCurrency, int monthStartDay, String? lastUpdatedAt, bool isLoading, bool hasChanges, String? error
});




}
/// @nodoc
class __$FinancialSettingsStateCopyWithImpl<$Res>
    implements _$FinancialSettingsStateCopyWith<$Res> {
  __$FinancialSettingsStateCopyWithImpl(this._self, this._then);

  final _FinancialSettingsState _self;
  final $Res Function(_FinancialSettingsState) _then;

/// Create a copy of FinancialSettingsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? safetyThreshold = freezed,Object? dailyBurnRate = freezed,Object? burnRateMode = null,Object? primaryCurrency = null,Object? monthStartDay = null,Object? lastUpdatedAt = freezed,Object? isLoading = null,Object? hasChanges = null,Object? error = freezed,}) {
  return _then(_FinancialSettingsState(
safetyThreshold: freezed == safetyThreshold ? _self.safetyThreshold : safetyThreshold // ignore: cast_nullable_to_non_nullable
as Decimal?,dailyBurnRate: freezed == dailyBurnRate ? _self.dailyBurnRate : dailyBurnRate // ignore: cast_nullable_to_non_nullable
as Decimal?,burnRateMode: null == burnRateMode ? _self.burnRateMode : burnRateMode // ignore: cast_nullable_to_non_nullable
as String,primaryCurrency: null == primaryCurrency ? _self.primaryCurrency : primaryCurrency // ignore: cast_nullable_to_non_nullable
as String,monthStartDay: null == monthStartDay ? _self.monthStartDay : monthStartDay // ignore: cast_nullable_to_non_nullable
as int,lastUpdatedAt: freezed == lastUpdatedAt ? _self.lastUpdatedAt : lastUpdatedAt // ignore: cast_nullable_to_non_nullable
as String?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasChanges: null == hasChanges ? _self.hasChanges : hasChanges // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
