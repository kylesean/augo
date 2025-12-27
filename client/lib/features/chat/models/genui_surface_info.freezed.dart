// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'genui_surface_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GenUiSurfaceInfo {

 String get surfaceId; String get messageId; DateTime? get createdAt; DateTime? get updatedAt; SurfaceStatus get status;
/// Create a copy of GenUiSurfaceInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenUiSurfaceInfoCopyWith<GenUiSurfaceInfo> get copyWith => _$GenUiSurfaceInfoCopyWithImpl<GenUiSurfaceInfo>(this as GenUiSurfaceInfo, _$identity);

  /// Serializes this GenUiSurfaceInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenUiSurfaceInfo&&(identical(other.surfaceId, surfaceId) || other.surfaceId == surfaceId)&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,surfaceId,messageId,createdAt,updatedAt,status);

@override
String toString() {
  return 'GenUiSurfaceInfo(surfaceId: $surfaceId, messageId: $messageId, createdAt: $createdAt, updatedAt: $updatedAt, status: $status)';
}


}

/// @nodoc
abstract mixin class $GenUiSurfaceInfoCopyWith<$Res>  {
  factory $GenUiSurfaceInfoCopyWith(GenUiSurfaceInfo value, $Res Function(GenUiSurfaceInfo) _then) = _$GenUiSurfaceInfoCopyWithImpl;
@useResult
$Res call({
 String surfaceId, String messageId, DateTime? createdAt, DateTime? updatedAt, SurfaceStatus status
});




}
/// @nodoc
class _$GenUiSurfaceInfoCopyWithImpl<$Res>
    implements $GenUiSurfaceInfoCopyWith<$Res> {
  _$GenUiSurfaceInfoCopyWithImpl(this._self, this._then);

  final GenUiSurfaceInfo _self;
  final $Res Function(GenUiSurfaceInfo) _then;

/// Create a copy of GenUiSurfaceInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? surfaceId = null,Object? messageId = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? status = null,}) {
  return _then(_self.copyWith(
surfaceId: null == surfaceId ? _self.surfaceId : surfaceId // ignore: cast_nullable_to_non_nullable
as String,messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SurfaceStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [GenUiSurfaceInfo].
extension GenUiSurfaceInfoPatterns on GenUiSurfaceInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GenUiSurfaceInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GenUiSurfaceInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GenUiSurfaceInfo value)  $default,){
final _that = this;
switch (_that) {
case _GenUiSurfaceInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GenUiSurfaceInfo value)?  $default,){
final _that = this;
switch (_that) {
case _GenUiSurfaceInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String surfaceId,  String messageId,  DateTime? createdAt,  DateTime? updatedAt,  SurfaceStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GenUiSurfaceInfo() when $default != null:
return $default(_that.surfaceId,_that.messageId,_that.createdAt,_that.updatedAt,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String surfaceId,  String messageId,  DateTime? createdAt,  DateTime? updatedAt,  SurfaceStatus status)  $default,) {final _that = this;
switch (_that) {
case _GenUiSurfaceInfo():
return $default(_that.surfaceId,_that.messageId,_that.createdAt,_that.updatedAt,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String surfaceId,  String messageId,  DateTime? createdAt,  DateTime? updatedAt,  SurfaceStatus status)?  $default,) {final _that = this;
switch (_that) {
case _GenUiSurfaceInfo() when $default != null:
return $default(_that.surfaceId,_that.messageId,_that.createdAt,_that.updatedAt,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GenUiSurfaceInfo implements GenUiSurfaceInfo {
  const _GenUiSurfaceInfo({required this.surfaceId, required this.messageId, this.createdAt, this.updatedAt, this.status = SurfaceStatus.loading});
  factory _GenUiSurfaceInfo.fromJson(Map<String, dynamic> json) => _$GenUiSurfaceInfoFromJson(json);

@override final  String surfaceId;
@override final  String messageId;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;
@override@JsonKey() final  SurfaceStatus status;

/// Create a copy of GenUiSurfaceInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GenUiSurfaceInfoCopyWith<_GenUiSurfaceInfo> get copyWith => __$GenUiSurfaceInfoCopyWithImpl<_GenUiSurfaceInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GenUiSurfaceInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GenUiSurfaceInfo&&(identical(other.surfaceId, surfaceId) || other.surfaceId == surfaceId)&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,surfaceId,messageId,createdAt,updatedAt,status);

@override
String toString() {
  return 'GenUiSurfaceInfo(surfaceId: $surfaceId, messageId: $messageId, createdAt: $createdAt, updatedAt: $updatedAt, status: $status)';
}


}

/// @nodoc
abstract mixin class _$GenUiSurfaceInfoCopyWith<$Res> implements $GenUiSurfaceInfoCopyWith<$Res> {
  factory _$GenUiSurfaceInfoCopyWith(_GenUiSurfaceInfo value, $Res Function(_GenUiSurfaceInfo) _then) = __$GenUiSurfaceInfoCopyWithImpl;
@override @useResult
$Res call({
 String surfaceId, String messageId, DateTime? createdAt, DateTime? updatedAt, SurfaceStatus status
});




}
/// @nodoc
class __$GenUiSurfaceInfoCopyWithImpl<$Res>
    implements _$GenUiSurfaceInfoCopyWith<$Res> {
  __$GenUiSurfaceInfoCopyWithImpl(this._self, this._then);

  final _GenUiSurfaceInfo _self;
  final $Res Function(_GenUiSurfaceInfo) _then;

/// Create a copy of GenUiSurfaceInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? surfaceId = null,Object? messageId = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? status = null,}) {
  return _then(_GenUiSurfaceInfo(
surfaceId: null == surfaceId ? _self.surfaceId : surfaceId // ignore: cast_nullable_to_non_nullable
as String,messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SurfaceStatus,
  ));
}


}

// dart format on
