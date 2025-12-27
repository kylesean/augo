// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConversationInfo {

 String get id; String get title; DateTime get createdAt; DateTime get updatedAt; String? get token;
/// Create a copy of ConversationInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationInfoCopyWith<ConversationInfo> get copyWith => _$ConversationInfoCopyWithImpl<ConversationInfo>(this as ConversationInfo, _$identity);

  /// Serializes this ConversationInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.token, token) || other.token == token));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,createdAt,updatedAt,token);

@override
String toString() {
  return 'ConversationInfo(id: $id, title: $title, createdAt: $createdAt, updatedAt: $updatedAt, token: $token)';
}


}

/// @nodoc
abstract mixin class $ConversationInfoCopyWith<$Res>  {
  factory $ConversationInfoCopyWith(ConversationInfo value, $Res Function(ConversationInfo) _then) = _$ConversationInfoCopyWithImpl;
@useResult
$Res call({
 String id, String title, DateTime createdAt, DateTime updatedAt, String? token
});




}
/// @nodoc
class _$ConversationInfoCopyWithImpl<$Res>
    implements $ConversationInfoCopyWith<$Res> {
  _$ConversationInfoCopyWithImpl(this._self, this._then);

  final ConversationInfo _self;
  final $Res Function(ConversationInfo) _then;

/// Create a copy of ConversationInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? createdAt = null,Object? updatedAt = null,Object? token = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ConversationInfo].
extension ConversationInfoPatterns on ConversationInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConversationInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConversationInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConversationInfo value)  $default,){
final _that = this;
switch (_that) {
case _ConversationInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConversationInfo value)?  $default,){
final _that = this;
switch (_that) {
case _ConversationInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  DateTime createdAt,  DateTime updatedAt,  String? token)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConversationInfo() when $default != null:
return $default(_that.id,_that.title,_that.createdAt,_that.updatedAt,_that.token);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  DateTime createdAt,  DateTime updatedAt,  String? token)  $default,) {final _that = this;
switch (_that) {
case _ConversationInfo():
return $default(_that.id,_that.title,_that.createdAt,_that.updatedAt,_that.token);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  DateTime createdAt,  DateTime updatedAt,  String? token)?  $default,) {final _that = this;
switch (_that) {
case _ConversationInfo() when $default != null:
return $default(_that.id,_that.title,_that.createdAt,_that.updatedAt,_that.token);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _ConversationInfo implements ConversationInfo {
  const _ConversationInfo({required this.id, required this.title, required this.createdAt, required this.updatedAt, this.token});
  factory _ConversationInfo.fromJson(Map<String, dynamic> json) => _$ConversationInfoFromJson(json);

@override final  String id;
@override final  String title;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String? token;

/// Create a copy of ConversationInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationInfoCopyWith<_ConversationInfo> get copyWith => __$ConversationInfoCopyWithImpl<_ConversationInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConversationInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConversationInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.token, token) || other.token == token));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,createdAt,updatedAt,token);

@override
String toString() {
  return 'ConversationInfo(id: $id, title: $title, createdAt: $createdAt, updatedAt: $updatedAt, token: $token)';
}


}

/// @nodoc
abstract mixin class _$ConversationInfoCopyWith<$Res> implements $ConversationInfoCopyWith<$Res> {
  factory _$ConversationInfoCopyWith(_ConversationInfo value, $Res Function(_ConversationInfo) _then) = __$ConversationInfoCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, DateTime createdAt, DateTime updatedAt, String? token
});




}
/// @nodoc
class __$ConversationInfoCopyWithImpl<$Res>
    implements _$ConversationInfoCopyWith<$Res> {
  __$ConversationInfoCopyWithImpl(this._self, this._then);

  final _ConversationInfo _self;
  final $Res Function(_ConversationInfo) _then;

/// Create a copy of ConversationInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? createdAt = null,Object? updatedAt = null,Object? token = freezed,}) {
  return _then(_ConversationInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
