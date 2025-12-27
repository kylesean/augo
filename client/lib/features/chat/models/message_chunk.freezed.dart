// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_chunk.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MessageChunk {

 String get type;// e.g., text / tool_call / image, etc.
 dynamic get content;
/// Create a copy of MessageChunk
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageChunkCopyWith<MessageChunk> get copyWith => _$MessageChunkCopyWithImpl<MessageChunk>(this as MessageChunk, _$identity);

  /// Serializes this MessageChunk to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageChunk&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.content, content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,const DeepCollectionEquality().hash(content));

@override
String toString() {
  return 'MessageChunk(type: $type, content: $content)';
}


}

/// @nodoc
abstract mixin class $MessageChunkCopyWith<$Res>  {
  factory $MessageChunkCopyWith(MessageChunk value, $Res Function(MessageChunk) _then) = _$MessageChunkCopyWithImpl;
@useResult
$Res call({
 String type, dynamic content
});




}
/// @nodoc
class _$MessageChunkCopyWithImpl<$Res>
    implements $MessageChunkCopyWith<$Res> {
  _$MessageChunkCopyWithImpl(this._self, this._then);

  final MessageChunk _self;
  final $Res Function(MessageChunk) _then;

/// Create a copy of MessageChunk
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? content = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}

}


/// Adds pattern-matching-related methods to [MessageChunk].
extension MessageChunkPatterns on MessageChunk {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MessageChunk value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MessageChunk() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MessageChunk value)  $default,){
final _that = this;
switch (_that) {
case _MessageChunk():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MessageChunk value)?  $default,){
final _that = this;
switch (_that) {
case _MessageChunk() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  dynamic content)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessageChunk() when $default != null:
return $default(_that.type,_that.content);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  dynamic content)  $default,) {final _that = this;
switch (_that) {
case _MessageChunk():
return $default(_that.type,_that.content);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  dynamic content)?  $default,) {final _that = this;
switch (_that) {
case _MessageChunk() when $default != null:
return $default(_that.type,_that.content);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MessageChunk implements MessageChunk {
  const _MessageChunk({required this.type, required this.content});
  factory _MessageChunk.fromJson(Map<String, dynamic> json) => _$MessageChunkFromJson(json);

@override final  String type;
// e.g., text / tool_call / image, etc.
@override final  dynamic content;

/// Create a copy of MessageChunk
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageChunkCopyWith<_MessageChunk> get copyWith => __$MessageChunkCopyWithImpl<_MessageChunk>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessageChunkToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessageChunk&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.content, content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,const DeepCollectionEquality().hash(content));

@override
String toString() {
  return 'MessageChunk(type: $type, content: $content)';
}


}

/// @nodoc
abstract mixin class _$MessageChunkCopyWith<$Res> implements $MessageChunkCopyWith<$Res> {
  factory _$MessageChunkCopyWith(_MessageChunk value, $Res Function(_MessageChunk) _then) = __$MessageChunkCopyWithImpl;
@override @useResult
$Res call({
 String type, dynamic content
});




}
/// @nodoc
class __$MessageChunkCopyWithImpl<$Res>
    implements _$MessageChunkCopyWith<$Res> {
  __$MessageChunkCopyWithImpl(this._self, this._then);

  final _MessageChunk _self;
  final $Res Function(_MessageChunk) _then;

/// Create a copy of MessageChunk
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? content = freezed,}) {
  return _then(_MessageChunk(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as dynamic,
  ));
}


}

// dart format on
