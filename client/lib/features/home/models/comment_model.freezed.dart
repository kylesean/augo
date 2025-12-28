// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CommentModel {

 String get id; String get transactionId;// Ensure API returns or can set
 String get userId;// ID of the user who posted the comment
 String get userName;// Username of the user who posted the comment
 String get userAvatarUrl;// Avatar URL of the user who posted the comment
 String? get parentCommentId;// Parent comment ID, used for replies
 String get commentText;// Reply text content
 String? get repliedToUserId;// ID of the user being replied to (optional, recommended)
 String? get repliedToUserName;// Name of the user being replied to (optional, recommended)
 DateTime get createdAt;@JsonKey(fromJson: _dateTimeNullableParse, toJson: _dateTimeNullableToIso8601String) DateTime? get updatedAt; List<CommentModel> get replies;// Current field only for backend returned data, UI no longer renders recursively
// Or backend returns nested structure directly, but mind the hierarchy depth
 int get likeCount;// Optional: comment like count
 bool get likedByCurrentUser;
/// Create a copy of CommentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommentModelCopyWith<CommentModel> get copyWith => _$CommentModelCopyWithImpl<CommentModel>(this as CommentModel, _$identity);

  /// Serializes this CommentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.userAvatarUrl, userAvatarUrl) || other.userAvatarUrl == userAvatarUrl)&&(identical(other.parentCommentId, parentCommentId) || other.parentCommentId == parentCommentId)&&(identical(other.commentText, commentText) || other.commentText == commentText)&&(identical(other.repliedToUserId, repliedToUserId) || other.repliedToUserId == repliedToUserId)&&(identical(other.repliedToUserName, repliedToUserName) || other.repliedToUserName == repliedToUserName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.replies, replies)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.likedByCurrentUser, likedByCurrentUser) || other.likedByCurrentUser == likedByCurrentUser));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,transactionId,userId,userName,userAvatarUrl,parentCommentId,commentText,repliedToUserId,repliedToUserName,createdAt,updatedAt,const DeepCollectionEquality().hash(replies),likeCount,likedByCurrentUser);

@override
String toString() {
  return 'CommentModel(id: $id, transactionId: $transactionId, userId: $userId, userName: $userName, userAvatarUrl: $userAvatarUrl, parentCommentId: $parentCommentId, commentText: $commentText, repliedToUserId: $repliedToUserId, repliedToUserName: $repliedToUserName, createdAt: $createdAt, updatedAt: $updatedAt, replies: $replies, likeCount: $likeCount, likedByCurrentUser: $likedByCurrentUser)';
}


}

/// @nodoc
abstract mixin class $CommentModelCopyWith<$Res>  {
  factory $CommentModelCopyWith(CommentModel value, $Res Function(CommentModel) _then) = _$CommentModelCopyWithImpl;
@useResult
$Res call({
 String id, String transactionId, String userId, String userName, String userAvatarUrl, String? parentCommentId, String commentText, String? repliedToUserId, String? repliedToUserName, DateTime createdAt,@JsonKey(fromJson: _dateTimeNullableParse, toJson: _dateTimeNullableToIso8601String) DateTime? updatedAt, List<CommentModel> replies, int likeCount, bool likedByCurrentUser
});




}
/// @nodoc
class _$CommentModelCopyWithImpl<$Res>
    implements $CommentModelCopyWith<$Res> {
  _$CommentModelCopyWithImpl(this._self, this._then);

  final CommentModel _self;
  final $Res Function(CommentModel) _then;

/// Create a copy of CommentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? transactionId = null,Object? userId = null,Object? userName = null,Object? userAvatarUrl = null,Object? parentCommentId = freezed,Object? commentText = null,Object? repliedToUserId = freezed,Object? repliedToUserName = freezed,Object? createdAt = null,Object? updatedAt = freezed,Object? replies = null,Object? likeCount = null,Object? likedByCurrentUser = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,transactionId: null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,userAvatarUrl: null == userAvatarUrl ? _self.userAvatarUrl : userAvatarUrl // ignore: cast_nullable_to_non_nullable
as String,parentCommentId: freezed == parentCommentId ? _self.parentCommentId : parentCommentId // ignore: cast_nullable_to_non_nullable
as String?,commentText: null == commentText ? _self.commentText : commentText // ignore: cast_nullable_to_non_nullable
as String,repliedToUserId: freezed == repliedToUserId ? _self.repliedToUserId : repliedToUserId // ignore: cast_nullable_to_non_nullable
as String?,repliedToUserName: freezed == repliedToUserName ? _self.repliedToUserName : repliedToUserName // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,replies: null == replies ? _self.replies : replies // ignore: cast_nullable_to_non_nullable
as List<CommentModel>,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,likedByCurrentUser: null == likedByCurrentUser ? _self.likedByCurrentUser : likedByCurrentUser // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CommentModel].
extension CommentModelPatterns on CommentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommentModel value)  $default,){
final _that = this;
switch (_that) {
case _CommentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommentModel value)?  $default,){
final _that = this;
switch (_that) {
case _CommentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String transactionId,  String userId,  String userName,  String userAvatarUrl,  String? parentCommentId,  String commentText,  String? repliedToUserId,  String? repliedToUserName,  DateTime createdAt, @JsonKey(fromJson: _dateTimeNullableParse, toJson: _dateTimeNullableToIso8601String)  DateTime? updatedAt,  List<CommentModel> replies,  int likeCount,  bool likedByCurrentUser)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommentModel() when $default != null:
return $default(_that.id,_that.transactionId,_that.userId,_that.userName,_that.userAvatarUrl,_that.parentCommentId,_that.commentText,_that.repliedToUserId,_that.repliedToUserName,_that.createdAt,_that.updatedAt,_that.replies,_that.likeCount,_that.likedByCurrentUser);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String transactionId,  String userId,  String userName,  String userAvatarUrl,  String? parentCommentId,  String commentText,  String? repliedToUserId,  String? repliedToUserName,  DateTime createdAt, @JsonKey(fromJson: _dateTimeNullableParse, toJson: _dateTimeNullableToIso8601String)  DateTime? updatedAt,  List<CommentModel> replies,  int likeCount,  bool likedByCurrentUser)  $default,) {final _that = this;
switch (_that) {
case _CommentModel():
return $default(_that.id,_that.transactionId,_that.userId,_that.userName,_that.userAvatarUrl,_that.parentCommentId,_that.commentText,_that.repliedToUserId,_that.repliedToUserName,_that.createdAt,_that.updatedAt,_that.replies,_that.likeCount,_that.likedByCurrentUser);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String transactionId,  String userId,  String userName,  String userAvatarUrl,  String? parentCommentId,  String commentText,  String? repliedToUserId,  String? repliedToUserName,  DateTime createdAt, @JsonKey(fromJson: _dateTimeNullableParse, toJson: _dateTimeNullableToIso8601String)  DateTime? updatedAt,  List<CommentModel> replies,  int likeCount,  bool likedByCurrentUser)?  $default,) {final _that = this;
switch (_that) {
case _CommentModel() when $default != null:
return $default(_that.id,_that.transactionId,_that.userId,_that.userName,_that.userAvatarUrl,_that.parentCommentId,_that.commentText,_that.repliedToUserId,_that.repliedToUserName,_that.createdAt,_that.updatedAt,_that.replies,_that.likeCount,_that.likedByCurrentUser);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _CommentModel implements CommentModel {
  const _CommentModel({required this.id, required this.transactionId, required this.userId, required this.userName, required this.userAvatarUrl, this.parentCommentId, required this.commentText, this.repliedToUserId, this.repliedToUserName, required this.createdAt, @JsonKey(fromJson: _dateTimeNullableParse, toJson: _dateTimeNullableToIso8601String) this.updatedAt, final  List<CommentModel> replies = const [], this.likeCount = 0, this.likedByCurrentUser = false}): _replies = replies;
  factory _CommentModel.fromJson(Map<String, dynamic> json) => _$CommentModelFromJson(json);

@override final  String id;
@override final  String transactionId;
// Ensure API returns or can set
@override final  String userId;
// ID of the user who posted the comment
@override final  String userName;
// Username of the user who posted the comment
@override final  String userAvatarUrl;
// Avatar URL of the user who posted the comment
@override final  String? parentCommentId;
// Parent comment ID, used for replies
@override final  String commentText;
// Reply text content
@override final  String? repliedToUserId;
// ID of the user being replied to (optional, recommended)
@override final  String? repliedToUserName;
// Name of the user being replied to (optional, recommended)
@override final  DateTime createdAt;
@override@JsonKey(fromJson: _dateTimeNullableParse, toJson: _dateTimeNullableToIso8601String) final  DateTime? updatedAt;
 final  List<CommentModel> _replies;
@override@JsonKey() List<CommentModel> get replies {
  if (_replies is EqualUnmodifiableListView) return _replies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_replies);
}

// Current field only for backend returned data, UI no longer renders recursively
// Or backend returns nested structure directly, but mind the hierarchy depth
@override@JsonKey() final  int likeCount;
// Optional: comment like count
@override@JsonKey() final  bool likedByCurrentUser;

/// Create a copy of CommentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommentModelCopyWith<_CommentModel> get copyWith => __$CommentModelCopyWithImpl<_CommentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.userAvatarUrl, userAvatarUrl) || other.userAvatarUrl == userAvatarUrl)&&(identical(other.parentCommentId, parentCommentId) || other.parentCommentId == parentCommentId)&&(identical(other.commentText, commentText) || other.commentText == commentText)&&(identical(other.repliedToUserId, repliedToUserId) || other.repliedToUserId == repliedToUserId)&&(identical(other.repliedToUserName, repliedToUserName) || other.repliedToUserName == repliedToUserName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._replies, _replies)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.likedByCurrentUser, likedByCurrentUser) || other.likedByCurrentUser == likedByCurrentUser));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,transactionId,userId,userName,userAvatarUrl,parentCommentId,commentText,repliedToUserId,repliedToUserName,createdAt,updatedAt,const DeepCollectionEquality().hash(_replies),likeCount,likedByCurrentUser);

@override
String toString() {
  return 'CommentModel(id: $id, transactionId: $transactionId, userId: $userId, userName: $userName, userAvatarUrl: $userAvatarUrl, parentCommentId: $parentCommentId, commentText: $commentText, repliedToUserId: $repliedToUserId, repliedToUserName: $repliedToUserName, createdAt: $createdAt, updatedAt: $updatedAt, replies: $replies, likeCount: $likeCount, likedByCurrentUser: $likedByCurrentUser)';
}


}

/// @nodoc
abstract mixin class _$CommentModelCopyWith<$Res> implements $CommentModelCopyWith<$Res> {
  factory _$CommentModelCopyWith(_CommentModel value, $Res Function(_CommentModel) _then) = __$CommentModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String transactionId, String userId, String userName, String userAvatarUrl, String? parentCommentId, String commentText, String? repliedToUserId, String? repliedToUserName, DateTime createdAt,@JsonKey(fromJson: _dateTimeNullableParse, toJson: _dateTimeNullableToIso8601String) DateTime? updatedAt, List<CommentModel> replies, int likeCount, bool likedByCurrentUser
});




}
/// @nodoc
class __$CommentModelCopyWithImpl<$Res>
    implements _$CommentModelCopyWith<$Res> {
  __$CommentModelCopyWithImpl(this._self, this._then);

  final _CommentModel _self;
  final $Res Function(_CommentModel) _then;

/// Create a copy of CommentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? transactionId = null,Object? userId = null,Object? userName = null,Object? userAvatarUrl = null,Object? parentCommentId = freezed,Object? commentText = null,Object? repliedToUserId = freezed,Object? repliedToUserName = freezed,Object? createdAt = null,Object? updatedAt = freezed,Object? replies = null,Object? likeCount = null,Object? likedByCurrentUser = null,}) {
  return _then(_CommentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,transactionId: null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,userAvatarUrl: null == userAvatarUrl ? _self.userAvatarUrl : userAvatarUrl // ignore: cast_nullable_to_non_nullable
as String,parentCommentId: freezed == parentCommentId ? _self.parentCommentId : parentCommentId // ignore: cast_nullable_to_non_nullable
as String?,commentText: null == commentText ? _self.commentText : commentText // ignore: cast_nullable_to_non_nullable
as String,repliedToUserId: freezed == repliedToUserId ? _self.repliedToUserId : repliedToUserId // ignore: cast_nullable_to_non_nullable
as String?,repliedToUserName: freezed == repliedToUserName ? _self.repliedToUserName : repliedToUserName // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,replies: null == replies ? _self._replies : replies // ignore: cast_nullable_to_non_nullable
as List<CommentModel>,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,likedByCurrentUser: null == likedByCurrentUser ? _self.likedByCurrentUser : likedByCurrentUser // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
