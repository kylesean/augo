// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConversationDetail {

 String get id; String get title;@JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime get updatedAt;// Directly include message list, no longer using pagination structure
 List<ChatMessage> get messages;
/// Create a copy of ConversationDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationDetailCopyWith<ConversationDetail> get copyWith => _$ConversationDetailCopyWithImpl<ConversationDetail>(this as ConversationDetail, _$identity);

  /// Serializes this ConversationDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.messages, messages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,updatedAt,const DeepCollectionEquality().hash(messages));

@override
String toString() {
  return 'ConversationDetail(id: $id, title: $title, updatedAt: $updatedAt, messages: $messages)';
}


}

/// @nodoc
abstract mixin class $ConversationDetailCopyWith<$Res>  {
  factory $ConversationDetailCopyWith(ConversationDetail value, $Res Function(ConversationDetail) _then) = _$ConversationDetailCopyWithImpl;
@useResult
$Res call({
 String id, String title,@JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime updatedAt, List<ChatMessage> messages
});




}
/// @nodoc
class _$ConversationDetailCopyWithImpl<$Res>
    implements $ConversationDetailCopyWith<$Res> {
  _$ConversationDetailCopyWithImpl(this._self, this._then);

  final ConversationDetail _self;
  final $Res Function(ConversationDetail) _then;

/// Create a copy of ConversationDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? updatedAt = null,Object? messages = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<ChatMessage>,
  ));
}

}


/// Adds pattern-matching-related methods to [ConversationDetail].
extension ConversationDetailPatterns on ConversationDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConversationDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConversationDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConversationDetail value)  $default,){
final _that = this;
switch (_that) {
case _ConversationDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConversationDetail value)?  $default,){
final _that = this;
switch (_that) {
case _ConversationDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title, @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime updatedAt,  List<ChatMessage> messages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConversationDetail() when $default != null:
return $default(_that.id,_that.title,_that.updatedAt,_that.messages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title, @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime updatedAt,  List<ChatMessage> messages)  $default,) {final _that = this;
switch (_that) {
case _ConversationDetail():
return $default(_that.id,_that.title,_that.updatedAt,_that.messages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title, @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)  DateTime updatedAt,  List<ChatMessage> messages)?  $default,) {final _that = this;
switch (_that) {
case _ConversationDetail() when $default != null:
return $default(_that.id,_that.title,_that.updatedAt,_that.messages);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConversationDetail implements ConversationDetail {
  const _ConversationDetail({required this.id, required this.title, @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) required this.updatedAt, final  List<ChatMessage> messages = const []}): _messages = messages;
  factory _ConversationDetail.fromJson(Map<String, dynamic> json) => _$ConversationDetailFromJson(json);

@override final  String id;
@override final  String title;
@override@JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) final  DateTime updatedAt;
// Directly include message list, no longer using pagination structure
 final  List<ChatMessage> _messages;
// Directly include message list, no longer using pagination structure
@override@JsonKey() List<ChatMessage> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}


/// Create a copy of ConversationDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationDetailCopyWith<_ConversationDetail> get copyWith => __$ConversationDetailCopyWithImpl<_ConversationDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConversationDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConversationDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._messages, _messages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,updatedAt,const DeepCollectionEquality().hash(_messages));

@override
String toString() {
  return 'ConversationDetail(id: $id, title: $title, updatedAt: $updatedAt, messages: $messages)';
}


}

/// @nodoc
abstract mixin class _$ConversationDetailCopyWith<$Res> implements $ConversationDetailCopyWith<$Res> {
  factory _$ConversationDetailCopyWith(_ConversationDetail value, $Res Function(_ConversationDetail) _then) = __$ConversationDetailCopyWithImpl;
@override @useResult
$Res call({
 String id, String title,@JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) DateTime updatedAt, List<ChatMessage> messages
});




}
/// @nodoc
class __$ConversationDetailCopyWithImpl<$Res>
    implements _$ConversationDetailCopyWith<$Res> {
  __$ConversationDetailCopyWithImpl(this._self, this._then);

  final _ConversationDetail _self;
  final $Res Function(_ConversationDetail) _then;

/// Create a copy of ConversationDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? updatedAt = null,Object? messages = null,}) {
  return _then(_ConversationDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<ChatMessage>,
  ));
}


}

// dart format on
