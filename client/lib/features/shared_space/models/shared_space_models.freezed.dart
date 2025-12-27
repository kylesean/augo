// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shared_space_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SharedSpaceMember {

 String get userId; String get username; String? get avatarUrl; MemberRole get role; DateTime? get createdAt; String? get email; InviteStatus get status; String get contributionAmount;
/// Create a copy of SharedSpaceMember
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SharedSpaceMemberCopyWith<SharedSpaceMember> get copyWith => _$SharedSpaceMemberCopyWithImpl<SharedSpaceMember>(this as SharedSpaceMember, _$identity);

  /// Serializes this SharedSpaceMember to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SharedSpaceMember&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.role, role) || other.role == role)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.email, email) || other.email == email)&&(identical(other.status, status) || other.status == status)&&(identical(other.contributionAmount, contributionAmount) || other.contributionAmount == contributionAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,username,avatarUrl,role,createdAt,email,status,contributionAmount);

@override
String toString() {
  return 'SharedSpaceMember(userId: $userId, username: $username, avatarUrl: $avatarUrl, role: $role, createdAt: $createdAt, email: $email, status: $status, contributionAmount: $contributionAmount)';
}


}

/// @nodoc
abstract mixin class $SharedSpaceMemberCopyWith<$Res>  {
  factory $SharedSpaceMemberCopyWith(SharedSpaceMember value, $Res Function(SharedSpaceMember) _then) = _$SharedSpaceMemberCopyWithImpl;
@useResult
$Res call({
 String userId, String username, String? avatarUrl, MemberRole role, DateTime? createdAt, String? email, InviteStatus status, String contributionAmount
});




}
/// @nodoc
class _$SharedSpaceMemberCopyWithImpl<$Res>
    implements $SharedSpaceMemberCopyWith<$Res> {
  _$SharedSpaceMemberCopyWithImpl(this._self, this._then);

  final SharedSpaceMember _self;
  final $Res Function(SharedSpaceMember) _then;

/// Create a copy of SharedSpaceMember
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? username = null,Object? avatarUrl = freezed,Object? role = null,Object? createdAt = freezed,Object? email = freezed,Object? status = null,Object? contributionAmount = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as MemberRole,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as InviteStatus,contributionAmount: null == contributionAmount ? _self.contributionAmount : contributionAmount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SharedSpaceMember].
extension SharedSpaceMemberPatterns on SharedSpaceMember {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SharedSpaceMember value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SharedSpaceMember() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SharedSpaceMember value)  $default,){
final _that = this;
switch (_that) {
case _SharedSpaceMember():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SharedSpaceMember value)?  $default,){
final _that = this;
switch (_that) {
case _SharedSpaceMember() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String username,  String? avatarUrl,  MemberRole role,  DateTime? createdAt,  String? email,  InviteStatus status,  String contributionAmount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SharedSpaceMember() when $default != null:
return $default(_that.userId,_that.username,_that.avatarUrl,_that.role,_that.createdAt,_that.email,_that.status,_that.contributionAmount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String username,  String? avatarUrl,  MemberRole role,  DateTime? createdAt,  String? email,  InviteStatus status,  String contributionAmount)  $default,) {final _that = this;
switch (_that) {
case _SharedSpaceMember():
return $default(_that.userId,_that.username,_that.avatarUrl,_that.role,_that.createdAt,_that.email,_that.status,_that.contributionAmount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String username,  String? avatarUrl,  MemberRole role,  DateTime? createdAt,  String? email,  InviteStatus status,  String contributionAmount)?  $default,) {final _that = this;
switch (_that) {
case _SharedSpaceMember() when $default != null:
return $default(_that.userId,_that.username,_that.avatarUrl,_that.role,_that.createdAt,_that.email,_that.status,_that.contributionAmount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SharedSpaceMember implements SharedSpaceMember {
  const _SharedSpaceMember({required this.userId, required this.username, this.avatarUrl, this.role = MemberRole.member, this.createdAt, this.email, this.status = InviteStatus.accepted, this.contributionAmount = '0.00'});
  factory _SharedSpaceMember.fromJson(Map<String, dynamic> json) => _$SharedSpaceMemberFromJson(json);

@override final  String userId;
@override final  String username;
@override final  String? avatarUrl;
@override@JsonKey() final  MemberRole role;
@override final  DateTime? createdAt;
@override final  String? email;
@override@JsonKey() final  InviteStatus status;
@override@JsonKey() final  String contributionAmount;

/// Create a copy of SharedSpaceMember
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SharedSpaceMemberCopyWith<_SharedSpaceMember> get copyWith => __$SharedSpaceMemberCopyWithImpl<_SharedSpaceMember>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SharedSpaceMemberToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SharedSpaceMember&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.role, role) || other.role == role)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.email, email) || other.email == email)&&(identical(other.status, status) || other.status == status)&&(identical(other.contributionAmount, contributionAmount) || other.contributionAmount == contributionAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,username,avatarUrl,role,createdAt,email,status,contributionAmount);

@override
String toString() {
  return 'SharedSpaceMember(userId: $userId, username: $username, avatarUrl: $avatarUrl, role: $role, createdAt: $createdAt, email: $email, status: $status, contributionAmount: $contributionAmount)';
}


}

/// @nodoc
abstract mixin class _$SharedSpaceMemberCopyWith<$Res> implements $SharedSpaceMemberCopyWith<$Res> {
  factory _$SharedSpaceMemberCopyWith(_SharedSpaceMember value, $Res Function(_SharedSpaceMember) _then) = __$SharedSpaceMemberCopyWithImpl;
@override @useResult
$Res call({
 String userId, String username, String? avatarUrl, MemberRole role, DateTime? createdAt, String? email, InviteStatus status, String contributionAmount
});




}
/// @nodoc
class __$SharedSpaceMemberCopyWithImpl<$Res>
    implements _$SharedSpaceMemberCopyWith<$Res> {
  __$SharedSpaceMemberCopyWithImpl(this._self, this._then);

  final _SharedSpaceMember _self;
  final $Res Function(_SharedSpaceMember) _then;

/// Create a copy of SharedSpaceMember
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? username = null,Object? avatarUrl = freezed,Object? role = null,Object? createdAt = freezed,Object? email = freezed,Object? status = null,Object? contributionAmount = null,}) {
  return _then(_SharedSpaceMember(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as MemberRole,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as InviteStatus,contributionAmount: null == contributionAmount ? _self.contributionAmount : contributionAmount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SpaceCreator {

 String get id; String get username; String? get avatarUrl;
/// Create a copy of SpaceCreator
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpaceCreatorCopyWith<SpaceCreator> get copyWith => _$SpaceCreatorCopyWithImpl<SpaceCreator>(this as SpaceCreator, _$identity);

  /// Serializes this SpaceCreator to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpaceCreator&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,avatarUrl);

@override
String toString() {
  return 'SpaceCreator(id: $id, username: $username, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class $SpaceCreatorCopyWith<$Res>  {
  factory $SpaceCreatorCopyWith(SpaceCreator value, $Res Function(SpaceCreator) _then) = _$SpaceCreatorCopyWithImpl;
@useResult
$Res call({
 String id, String username, String? avatarUrl
});




}
/// @nodoc
class _$SpaceCreatorCopyWithImpl<$Res>
    implements $SpaceCreatorCopyWith<$Res> {
  _$SpaceCreatorCopyWithImpl(this._self, this._then);

  final SpaceCreator _self;
  final $Res Function(SpaceCreator) _then;

/// Create a copy of SpaceCreator
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? avatarUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SpaceCreator].
extension SpaceCreatorPatterns on SpaceCreator {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpaceCreator value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpaceCreator() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpaceCreator value)  $default,){
final _that = this;
switch (_that) {
case _SpaceCreator():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpaceCreator value)?  $default,){
final _that = this;
switch (_that) {
case _SpaceCreator() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String username,  String? avatarUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpaceCreator() when $default != null:
return $default(_that.id,_that.username,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String username,  String? avatarUrl)  $default,) {final _that = this;
switch (_that) {
case _SpaceCreator():
return $default(_that.id,_that.username,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String username,  String? avatarUrl)?  $default,) {final _that = this;
switch (_that) {
case _SpaceCreator() when $default != null:
return $default(_that.id,_that.username,_that.avatarUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SpaceCreator implements SpaceCreator {
  const _SpaceCreator({required this.id, required this.username, this.avatarUrl});
  factory _SpaceCreator.fromJson(Map<String, dynamic> json) => _$SpaceCreatorFromJson(json);

@override final  String id;
@override final  String username;
@override final  String? avatarUrl;

/// Create a copy of SpaceCreator
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpaceCreatorCopyWith<_SpaceCreator> get copyWith => __$SpaceCreatorCopyWithImpl<_SpaceCreator>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SpaceCreatorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpaceCreator&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,avatarUrl);

@override
String toString() {
  return 'SpaceCreator(id: $id, username: $username, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class _$SpaceCreatorCopyWith<$Res> implements $SpaceCreatorCopyWith<$Res> {
  factory _$SpaceCreatorCopyWith(_SpaceCreator value, $Res Function(_SpaceCreator) _then) = __$SpaceCreatorCopyWithImpl;
@override @useResult
$Res call({
 String id, String username, String? avatarUrl
});




}
/// @nodoc
class __$SpaceCreatorCopyWithImpl<$Res>
    implements _$SpaceCreatorCopyWith<$Res> {
  __$SpaceCreatorCopyWithImpl(this._self, this._then);

  final _SpaceCreator _self;
  final $Res Function(_SpaceCreator) _then;

/// Create a copy of SpaceCreator
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? avatarUrl = freezed,}) {
  return _then(_SpaceCreator(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$SharedSpace {

 String get id; String get name; String? get description; SpaceCreator get creator; DateTime? get createdAt; DateTime? get updatedAt; List<SharedSpaceMember>? get members; int get transactionCount; String? get currentInviteCode; DateTime? get inviteCodeExpiresAt; String get totalExpense;
/// Create a copy of SharedSpace
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SharedSpaceCopyWith<SharedSpace> get copyWith => _$SharedSpaceCopyWithImpl<SharedSpace>(this as SharedSpace, _$identity);

  /// Serializes this SharedSpace to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SharedSpace&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.creator, creator) || other.creator == creator)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.members, members)&&(identical(other.transactionCount, transactionCount) || other.transactionCount == transactionCount)&&(identical(other.currentInviteCode, currentInviteCode) || other.currentInviteCode == currentInviteCode)&&(identical(other.inviteCodeExpiresAt, inviteCodeExpiresAt) || other.inviteCodeExpiresAt == inviteCodeExpiresAt)&&(identical(other.totalExpense, totalExpense) || other.totalExpense == totalExpense));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,creator,createdAt,updatedAt,const DeepCollectionEquality().hash(members),transactionCount,currentInviteCode,inviteCodeExpiresAt,totalExpense);

@override
String toString() {
  return 'SharedSpace(id: $id, name: $name, description: $description, creator: $creator, createdAt: $createdAt, updatedAt: $updatedAt, members: $members, transactionCount: $transactionCount, currentInviteCode: $currentInviteCode, inviteCodeExpiresAt: $inviteCodeExpiresAt, totalExpense: $totalExpense)';
}


}

/// @nodoc
abstract mixin class $SharedSpaceCopyWith<$Res>  {
  factory $SharedSpaceCopyWith(SharedSpace value, $Res Function(SharedSpace) _then) = _$SharedSpaceCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description, SpaceCreator creator, DateTime? createdAt, DateTime? updatedAt, List<SharedSpaceMember>? members, int transactionCount, String? currentInviteCode, DateTime? inviteCodeExpiresAt, String totalExpense
});


$SpaceCreatorCopyWith<$Res> get creator;

}
/// @nodoc
class _$SharedSpaceCopyWithImpl<$Res>
    implements $SharedSpaceCopyWith<$Res> {
  _$SharedSpaceCopyWithImpl(this._self, this._then);

  final SharedSpace _self;
  final $Res Function(SharedSpace) _then;

/// Create a copy of SharedSpace
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? creator = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? members = freezed,Object? transactionCount = null,Object? currentInviteCode = freezed,Object? inviteCodeExpiresAt = freezed,Object? totalExpense = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,creator: null == creator ? _self.creator : creator // ignore: cast_nullable_to_non_nullable
as SpaceCreator,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,members: freezed == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<SharedSpaceMember>?,transactionCount: null == transactionCount ? _self.transactionCount : transactionCount // ignore: cast_nullable_to_non_nullable
as int,currentInviteCode: freezed == currentInviteCode ? _self.currentInviteCode : currentInviteCode // ignore: cast_nullable_to_non_nullable
as String?,inviteCodeExpiresAt: freezed == inviteCodeExpiresAt ? _self.inviteCodeExpiresAt : inviteCodeExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,totalExpense: null == totalExpense ? _self.totalExpense : totalExpense // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of SharedSpace
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SpaceCreatorCopyWith<$Res> get creator {
  
  return $SpaceCreatorCopyWith<$Res>(_self.creator, (value) {
    return _then(_self.copyWith(creator: value));
  });
}
}


/// Adds pattern-matching-related methods to [SharedSpace].
extension SharedSpacePatterns on SharedSpace {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SharedSpace value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SharedSpace() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SharedSpace value)  $default,){
final _that = this;
switch (_that) {
case _SharedSpace():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SharedSpace value)?  $default,){
final _that = this;
switch (_that) {
case _SharedSpace() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  SpaceCreator creator,  DateTime? createdAt,  DateTime? updatedAt,  List<SharedSpaceMember>? members,  int transactionCount,  String? currentInviteCode,  DateTime? inviteCodeExpiresAt,  String totalExpense)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SharedSpace() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.creator,_that.createdAt,_that.updatedAt,_that.members,_that.transactionCount,_that.currentInviteCode,_that.inviteCodeExpiresAt,_that.totalExpense);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  SpaceCreator creator,  DateTime? createdAt,  DateTime? updatedAt,  List<SharedSpaceMember>? members,  int transactionCount,  String? currentInviteCode,  DateTime? inviteCodeExpiresAt,  String totalExpense)  $default,) {final _that = this;
switch (_that) {
case _SharedSpace():
return $default(_that.id,_that.name,_that.description,_that.creator,_that.createdAt,_that.updatedAt,_that.members,_that.transactionCount,_that.currentInviteCode,_that.inviteCodeExpiresAt,_that.totalExpense);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? description,  SpaceCreator creator,  DateTime? createdAt,  DateTime? updatedAt,  List<SharedSpaceMember>? members,  int transactionCount,  String? currentInviteCode,  DateTime? inviteCodeExpiresAt,  String totalExpense)?  $default,) {final _that = this;
switch (_that) {
case _SharedSpace() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.creator,_that.createdAt,_that.updatedAt,_that.members,_that.transactionCount,_that.currentInviteCode,_that.inviteCodeExpiresAt,_that.totalExpense);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SharedSpace implements SharedSpace {
  const _SharedSpace({required this.id, required this.name, this.description, required this.creator, this.createdAt, this.updatedAt, final  List<SharedSpaceMember>? members, this.transactionCount = 0, this.currentInviteCode, this.inviteCodeExpiresAt, this.totalExpense = '0.00'}): _members = members;
  factory _SharedSpace.fromJson(Map<String, dynamic> json) => _$SharedSpaceFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? description;
@override final  SpaceCreator creator;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;
 final  List<SharedSpaceMember>? _members;
@override List<SharedSpaceMember>? get members {
  final value = _members;
  if (value == null) return null;
  if (_members is EqualUnmodifiableListView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey() final  int transactionCount;
@override final  String? currentInviteCode;
@override final  DateTime? inviteCodeExpiresAt;
@override@JsonKey() final  String totalExpense;

/// Create a copy of SharedSpace
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SharedSpaceCopyWith<_SharedSpace> get copyWith => __$SharedSpaceCopyWithImpl<_SharedSpace>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SharedSpaceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SharedSpace&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.creator, creator) || other.creator == creator)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._members, _members)&&(identical(other.transactionCount, transactionCount) || other.transactionCount == transactionCount)&&(identical(other.currentInviteCode, currentInviteCode) || other.currentInviteCode == currentInviteCode)&&(identical(other.inviteCodeExpiresAt, inviteCodeExpiresAt) || other.inviteCodeExpiresAt == inviteCodeExpiresAt)&&(identical(other.totalExpense, totalExpense) || other.totalExpense == totalExpense));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,creator,createdAt,updatedAt,const DeepCollectionEquality().hash(_members),transactionCount,currentInviteCode,inviteCodeExpiresAt,totalExpense);

@override
String toString() {
  return 'SharedSpace(id: $id, name: $name, description: $description, creator: $creator, createdAt: $createdAt, updatedAt: $updatedAt, members: $members, transactionCount: $transactionCount, currentInviteCode: $currentInviteCode, inviteCodeExpiresAt: $inviteCodeExpiresAt, totalExpense: $totalExpense)';
}


}

/// @nodoc
abstract mixin class _$SharedSpaceCopyWith<$Res> implements $SharedSpaceCopyWith<$Res> {
  factory _$SharedSpaceCopyWith(_SharedSpace value, $Res Function(_SharedSpace) _then) = __$SharedSpaceCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description, SpaceCreator creator, DateTime? createdAt, DateTime? updatedAt, List<SharedSpaceMember>? members, int transactionCount, String? currentInviteCode, DateTime? inviteCodeExpiresAt, String totalExpense
});


@override $SpaceCreatorCopyWith<$Res> get creator;

}
/// @nodoc
class __$SharedSpaceCopyWithImpl<$Res>
    implements _$SharedSpaceCopyWith<$Res> {
  __$SharedSpaceCopyWithImpl(this._self, this._then);

  final _SharedSpace _self;
  final $Res Function(_SharedSpace) _then;

/// Create a copy of SharedSpace
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? creator = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? members = freezed,Object? transactionCount = null,Object? currentInviteCode = freezed,Object? inviteCodeExpiresAt = freezed,Object? totalExpense = null,}) {
  return _then(_SharedSpace(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,creator: null == creator ? _self.creator : creator // ignore: cast_nullable_to_non_nullable
as SpaceCreator,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,members: freezed == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as List<SharedSpaceMember>?,transactionCount: null == transactionCount ? _self.transactionCount : transactionCount // ignore: cast_nullable_to_non_nullable
as int,currentInviteCode: freezed == currentInviteCode ? _self.currentInviteCode : currentInviteCode // ignore: cast_nullable_to_non_nullable
as String?,inviteCodeExpiresAt: freezed == inviteCodeExpiresAt ? _self.inviteCodeExpiresAt : inviteCodeExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,totalExpense: null == totalExpense ? _self.totalExpense : totalExpense // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of SharedSpace
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SpaceCreatorCopyWith<$Res> get creator {
  
  return $SpaceCreatorCopyWith<$Res>(_self.creator, (value) {
    return _then(_self.copyWith(creator: value));
  });
}
}


/// @nodoc
mixin _$InviteCode {

 String get code; String get spaceId; String get spaceName; DateTime? get expiresAt;
/// Create a copy of InviteCode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InviteCodeCopyWith<InviteCode> get copyWith => _$InviteCodeCopyWithImpl<InviteCode>(this as InviteCode, _$identity);

  /// Serializes this InviteCode to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InviteCode&&(identical(other.code, code) || other.code == code)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.spaceName, spaceName) || other.spaceName == spaceName)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,spaceId,spaceName,expiresAt);

@override
String toString() {
  return 'InviteCode(code: $code, spaceId: $spaceId, spaceName: $spaceName, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $InviteCodeCopyWith<$Res>  {
  factory $InviteCodeCopyWith(InviteCode value, $Res Function(InviteCode) _then) = _$InviteCodeCopyWithImpl;
@useResult
$Res call({
 String code, String spaceId, String spaceName, DateTime? expiresAt
});




}
/// @nodoc
class _$InviteCodeCopyWithImpl<$Res>
    implements $InviteCodeCopyWith<$Res> {
  _$InviteCodeCopyWithImpl(this._self, this._then);

  final InviteCode _self;
  final $Res Function(InviteCode) _then;

/// Create a copy of InviteCode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? spaceId = null,Object? spaceName = null,Object? expiresAt = freezed,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,spaceName: null == spaceName ? _self.spaceName : spaceName // ignore: cast_nullable_to_non_nullable
as String,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [InviteCode].
extension InviteCodePatterns on InviteCode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InviteCode value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InviteCode() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InviteCode value)  $default,){
final _that = this;
switch (_that) {
case _InviteCode():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InviteCode value)?  $default,){
final _that = this;
switch (_that) {
case _InviteCode() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String spaceId,  String spaceName,  DateTime? expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InviteCode() when $default != null:
return $default(_that.code,_that.spaceId,_that.spaceName,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String spaceId,  String spaceName,  DateTime? expiresAt)  $default,) {final _that = this;
switch (_that) {
case _InviteCode():
return $default(_that.code,_that.spaceId,_that.spaceName,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String spaceId,  String spaceName,  DateTime? expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _InviteCode() when $default != null:
return $default(_that.code,_that.spaceId,_that.spaceName,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InviteCode implements InviteCode {
  const _InviteCode({required this.code, required this.spaceId, required this.spaceName, this.expiresAt});
  factory _InviteCode.fromJson(Map<String, dynamic> json) => _$InviteCodeFromJson(json);

@override final  String code;
@override final  String spaceId;
@override final  String spaceName;
@override final  DateTime? expiresAt;

/// Create a copy of InviteCode
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InviteCodeCopyWith<_InviteCode> get copyWith => __$InviteCodeCopyWithImpl<_InviteCode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InviteCodeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InviteCode&&(identical(other.code, code) || other.code == code)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.spaceName, spaceName) || other.spaceName == spaceName)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,spaceId,spaceName,expiresAt);

@override
String toString() {
  return 'InviteCode(code: $code, spaceId: $spaceId, spaceName: $spaceName, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$InviteCodeCopyWith<$Res> implements $InviteCodeCopyWith<$Res> {
  factory _$InviteCodeCopyWith(_InviteCode value, $Res Function(_InviteCode) _then) = __$InviteCodeCopyWithImpl;
@override @useResult
$Res call({
 String code, String spaceId, String spaceName, DateTime? expiresAt
});




}
/// @nodoc
class __$InviteCodeCopyWithImpl<$Res>
    implements _$InviteCodeCopyWith<$Res> {
  __$InviteCodeCopyWithImpl(this._self, this._then);

  final _InviteCode _self;
  final $Res Function(_InviteCode) _then;

/// Create a copy of InviteCode
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? spaceId = null,Object? spaceName = null,Object? expiresAt = freezed,}) {
  return _then(_InviteCode(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,spaceName: null == spaceName ? _self.spaceName : spaceName // ignore: cast_nullable_to_non_nullable
as String,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$SettlementItem {

 String get fromUserId; String get fromUsername; String get toUserId; String get toUsername;@JsonKey(fromJson: Decimal.parse, toJson: _decimalToString) Decimal get amount;
/// Create a copy of SettlementItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettlementItemCopyWith<SettlementItem> get copyWith => _$SettlementItemCopyWithImpl<SettlementItem>(this as SettlementItem, _$identity);

  /// Serializes this SettlementItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettlementItem&&(identical(other.fromUserId, fromUserId) || other.fromUserId == fromUserId)&&(identical(other.fromUsername, fromUsername) || other.fromUsername == fromUsername)&&(identical(other.toUserId, toUserId) || other.toUserId == toUserId)&&(identical(other.toUsername, toUsername) || other.toUsername == toUsername)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fromUserId,fromUsername,toUserId,toUsername,amount);

@override
String toString() {
  return 'SettlementItem(fromUserId: $fromUserId, fromUsername: $fromUsername, toUserId: $toUserId, toUsername: $toUsername, amount: $amount)';
}


}

/// @nodoc
abstract mixin class $SettlementItemCopyWith<$Res>  {
  factory $SettlementItemCopyWith(SettlementItem value, $Res Function(SettlementItem) _then) = _$SettlementItemCopyWithImpl;
@useResult
$Res call({
 String fromUserId, String fromUsername, String toUserId, String toUsername,@JsonKey(fromJson: Decimal.parse, toJson: _decimalToString) Decimal amount
});




}
/// @nodoc
class _$SettlementItemCopyWithImpl<$Res>
    implements $SettlementItemCopyWith<$Res> {
  _$SettlementItemCopyWithImpl(this._self, this._then);

  final SettlementItem _self;
  final $Res Function(SettlementItem) _then;

/// Create a copy of SettlementItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fromUserId = null,Object? fromUsername = null,Object? toUserId = null,Object? toUsername = null,Object? amount = null,}) {
  return _then(_self.copyWith(
fromUserId: null == fromUserId ? _self.fromUserId : fromUserId // ignore: cast_nullable_to_non_nullable
as String,fromUsername: null == fromUsername ? _self.fromUsername : fromUsername // ignore: cast_nullable_to_non_nullable
as String,toUserId: null == toUserId ? _self.toUserId : toUserId // ignore: cast_nullable_to_non_nullable
as String,toUsername: null == toUsername ? _self.toUsername : toUsername // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Decimal,
  ));
}

}


/// Adds pattern-matching-related methods to [SettlementItem].
extension SettlementItemPatterns on SettlementItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettlementItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettlementItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettlementItem value)  $default,){
final _that = this;
switch (_that) {
case _SettlementItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettlementItem value)?  $default,){
final _that = this;
switch (_that) {
case _SettlementItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fromUserId,  String fromUsername,  String toUserId,  String toUsername, @JsonKey(fromJson: Decimal.parse, toJson: _decimalToString)  Decimal amount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettlementItem() when $default != null:
return $default(_that.fromUserId,_that.fromUsername,_that.toUserId,_that.toUsername,_that.amount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fromUserId,  String fromUsername,  String toUserId,  String toUsername, @JsonKey(fromJson: Decimal.parse, toJson: _decimalToString)  Decimal amount)  $default,) {final _that = this;
switch (_that) {
case _SettlementItem():
return $default(_that.fromUserId,_that.fromUsername,_that.toUserId,_that.toUsername,_that.amount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fromUserId,  String fromUsername,  String toUserId,  String toUsername, @JsonKey(fromJson: Decimal.parse, toJson: _decimalToString)  Decimal amount)?  $default,) {final _that = this;
switch (_that) {
case _SettlementItem() when $default != null:
return $default(_that.fromUserId,_that.fromUsername,_that.toUserId,_that.toUsername,_that.amount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SettlementItem implements SettlementItem {
  const _SettlementItem({required this.fromUserId, required this.fromUsername, required this.toUserId, required this.toUsername, @JsonKey(fromJson: Decimal.parse, toJson: _decimalToString) required this.amount});
  factory _SettlementItem.fromJson(Map<String, dynamic> json) => _$SettlementItemFromJson(json);

@override final  String fromUserId;
@override final  String fromUsername;
@override final  String toUserId;
@override final  String toUsername;
@override@JsonKey(fromJson: Decimal.parse, toJson: _decimalToString) final  Decimal amount;

/// Create a copy of SettlementItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettlementItemCopyWith<_SettlementItem> get copyWith => __$SettlementItemCopyWithImpl<_SettlementItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SettlementItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettlementItem&&(identical(other.fromUserId, fromUserId) || other.fromUserId == fromUserId)&&(identical(other.fromUsername, fromUsername) || other.fromUsername == fromUsername)&&(identical(other.toUserId, toUserId) || other.toUserId == toUserId)&&(identical(other.toUsername, toUsername) || other.toUsername == toUsername)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fromUserId,fromUsername,toUserId,toUsername,amount);

@override
String toString() {
  return 'SettlementItem(fromUserId: $fromUserId, fromUsername: $fromUsername, toUserId: $toUserId, toUsername: $toUsername, amount: $amount)';
}


}

/// @nodoc
abstract mixin class _$SettlementItemCopyWith<$Res> implements $SettlementItemCopyWith<$Res> {
  factory _$SettlementItemCopyWith(_SettlementItem value, $Res Function(_SettlementItem) _then) = __$SettlementItemCopyWithImpl;
@override @useResult
$Res call({
 String fromUserId, String fromUsername, String toUserId, String toUsername,@JsonKey(fromJson: Decimal.parse, toJson: _decimalToString) Decimal amount
});




}
/// @nodoc
class __$SettlementItemCopyWithImpl<$Res>
    implements _$SettlementItemCopyWith<$Res> {
  __$SettlementItemCopyWithImpl(this._self, this._then);

  final _SettlementItem _self;
  final $Res Function(_SettlementItem) _then;

/// Create a copy of SettlementItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fromUserId = null,Object? fromUsername = null,Object? toUserId = null,Object? toUsername = null,Object? amount = null,}) {
  return _then(_SettlementItem(
fromUserId: null == fromUserId ? _self.fromUserId : fromUserId // ignore: cast_nullable_to_non_nullable
as String,fromUsername: null == fromUsername ? _self.fromUsername : fromUsername // ignore: cast_nullable_to_non_nullable
as String,toUserId: null == toUserId ? _self.toUserId : toUserId // ignore: cast_nullable_to_non_nullable
as String,toUsername: null == toUsername ? _self.toUsername : toUsername // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Decimal,
  ));
}


}


/// @nodoc
mixin _$Settlement {

 String get spaceId; List<SettlementItem> get items;@JsonKey(fromJson: Decimal.parse, toJson: _decimalToString) Decimal get totalAmount; DateTime get calculatedAt; bool get isSettled;
/// Create a copy of Settlement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettlementCopyWith<Settlement> get copyWith => _$SettlementCopyWithImpl<Settlement>(this as Settlement, _$identity);

  /// Serializes this Settlement to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Settlement&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.calculatedAt, calculatedAt) || other.calculatedAt == calculatedAt)&&(identical(other.isSettled, isSettled) || other.isSettled == isSettled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,spaceId,const DeepCollectionEquality().hash(items),totalAmount,calculatedAt,isSettled);

@override
String toString() {
  return 'Settlement(spaceId: $spaceId, items: $items, totalAmount: $totalAmount, calculatedAt: $calculatedAt, isSettled: $isSettled)';
}


}

/// @nodoc
abstract mixin class $SettlementCopyWith<$Res>  {
  factory $SettlementCopyWith(Settlement value, $Res Function(Settlement) _then) = _$SettlementCopyWithImpl;
@useResult
$Res call({
 String spaceId, List<SettlementItem> items,@JsonKey(fromJson: Decimal.parse, toJson: _decimalToString) Decimal totalAmount, DateTime calculatedAt, bool isSettled
});




}
/// @nodoc
class _$SettlementCopyWithImpl<$Res>
    implements $SettlementCopyWith<$Res> {
  _$SettlementCopyWithImpl(this._self, this._then);

  final Settlement _self;
  final $Res Function(Settlement) _then;

/// Create a copy of Settlement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? spaceId = null,Object? items = null,Object? totalAmount = null,Object? calculatedAt = null,Object? isSettled = null,}) {
  return _then(_self.copyWith(
spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<SettlementItem>,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as Decimal,calculatedAt: null == calculatedAt ? _self.calculatedAt : calculatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isSettled: null == isSettled ? _self.isSettled : isSettled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Settlement].
extension SettlementPatterns on Settlement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Settlement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Settlement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Settlement value)  $default,){
final _that = this;
switch (_that) {
case _Settlement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Settlement value)?  $default,){
final _that = this;
switch (_that) {
case _Settlement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String spaceId,  List<SettlementItem> items, @JsonKey(fromJson: Decimal.parse, toJson: _decimalToString)  Decimal totalAmount,  DateTime calculatedAt,  bool isSettled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Settlement() when $default != null:
return $default(_that.spaceId,_that.items,_that.totalAmount,_that.calculatedAt,_that.isSettled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String spaceId,  List<SettlementItem> items, @JsonKey(fromJson: Decimal.parse, toJson: _decimalToString)  Decimal totalAmount,  DateTime calculatedAt,  bool isSettled)  $default,) {final _that = this;
switch (_that) {
case _Settlement():
return $default(_that.spaceId,_that.items,_that.totalAmount,_that.calculatedAt,_that.isSettled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String spaceId,  List<SettlementItem> items, @JsonKey(fromJson: Decimal.parse, toJson: _decimalToString)  Decimal totalAmount,  DateTime calculatedAt,  bool isSettled)?  $default,) {final _that = this;
switch (_that) {
case _Settlement() when $default != null:
return $default(_that.spaceId,_that.items,_that.totalAmount,_that.calculatedAt,_that.isSettled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Settlement implements Settlement {
  const _Settlement({required this.spaceId, required final  List<SettlementItem> items, @JsonKey(fromJson: Decimal.parse, toJson: _decimalToString) required this.totalAmount, required this.calculatedAt, this.isSettled = false}): _items = items;
  factory _Settlement.fromJson(Map<String, dynamic> json) => _$SettlementFromJson(json);

@override final  String spaceId;
 final  List<SettlementItem> _items;
@override List<SettlementItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey(fromJson: Decimal.parse, toJson: _decimalToString) final  Decimal totalAmount;
@override final  DateTime calculatedAt;
@override@JsonKey() final  bool isSettled;

/// Create a copy of Settlement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettlementCopyWith<_Settlement> get copyWith => __$SettlementCopyWithImpl<_Settlement>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SettlementToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Settlement&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.calculatedAt, calculatedAt) || other.calculatedAt == calculatedAt)&&(identical(other.isSettled, isSettled) || other.isSettled == isSettled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,spaceId,const DeepCollectionEquality().hash(_items),totalAmount,calculatedAt,isSettled);

@override
String toString() {
  return 'Settlement(spaceId: $spaceId, items: $items, totalAmount: $totalAmount, calculatedAt: $calculatedAt, isSettled: $isSettled)';
}


}

/// @nodoc
abstract mixin class _$SettlementCopyWith<$Res> implements $SettlementCopyWith<$Res> {
  factory _$SettlementCopyWith(_Settlement value, $Res Function(_Settlement) _then) = __$SettlementCopyWithImpl;
@override @useResult
$Res call({
 String spaceId, List<SettlementItem> items,@JsonKey(fromJson: Decimal.parse, toJson: _decimalToString) Decimal totalAmount, DateTime calculatedAt, bool isSettled
});




}
/// @nodoc
class __$SettlementCopyWithImpl<$Res>
    implements _$SettlementCopyWith<$Res> {
  __$SettlementCopyWithImpl(this._self, this._then);

  final _Settlement _self;
  final $Res Function(_Settlement) _then;

/// Create a copy of Settlement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? spaceId = null,Object? items = null,Object? totalAmount = null,Object? calculatedAt = null,Object? isSettled = null,}) {
  return _then(_Settlement(
spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<SettlementItem>,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as Decimal,calculatedAt: null == calculatedAt ? _self.calculatedAt : calculatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isSettled: null == isSettled ? _self.isSettled : isSettled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$NotificationModel {

 String get id; String get userId; NotificationType get type; String get title; String get message; Map<String, dynamic>? get data; bool get isRead; DateTime? get createdAt; DateTime? get readAt;
/// Create a copy of NotificationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationModelCopyWith<NotificationModel> get copyWith => _$NotificationModelCopyWithImpl<NotificationModel>(this as NotificationModel, _$identity);

  /// Serializes this NotificationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.readAt, readAt) || other.readAt == readAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,type,title,message,const DeepCollectionEquality().hash(data),isRead,createdAt,readAt);

@override
String toString() {
  return 'NotificationModel(id: $id, userId: $userId, type: $type, title: $title, message: $message, data: $data, isRead: $isRead, createdAt: $createdAt, readAt: $readAt)';
}


}

/// @nodoc
abstract mixin class $NotificationModelCopyWith<$Res>  {
  factory $NotificationModelCopyWith(NotificationModel value, $Res Function(NotificationModel) _then) = _$NotificationModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, NotificationType type, String title, String message, Map<String, dynamic>? data, bool isRead, DateTime? createdAt, DateTime? readAt
});




}
/// @nodoc
class _$NotificationModelCopyWithImpl<$Res>
    implements $NotificationModelCopyWith<$Res> {
  _$NotificationModelCopyWithImpl(this._self, this._then);

  final NotificationModel _self;
  final $Res Function(NotificationModel) _then;

/// Create a copy of NotificationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? type = null,Object? title = null,Object? message = null,Object? data = freezed,Object? isRead = null,Object? createdAt = freezed,Object? readAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as NotificationType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,readAt: freezed == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationModel].
extension NotificationModelPatterns on NotificationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationModel value)  $default,){
final _that = this;
switch (_that) {
case _NotificationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationModel value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  NotificationType type,  String title,  String message,  Map<String, dynamic>? data,  bool isRead,  DateTime? createdAt,  DateTime? readAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationModel() when $default != null:
return $default(_that.id,_that.userId,_that.type,_that.title,_that.message,_that.data,_that.isRead,_that.createdAt,_that.readAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  NotificationType type,  String title,  String message,  Map<String, dynamic>? data,  bool isRead,  DateTime? createdAt,  DateTime? readAt)  $default,) {final _that = this;
switch (_that) {
case _NotificationModel():
return $default(_that.id,_that.userId,_that.type,_that.title,_that.message,_that.data,_that.isRead,_that.createdAt,_that.readAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  NotificationType type,  String title,  String message,  Map<String, dynamic>? data,  bool isRead,  DateTime? createdAt,  DateTime? readAt)?  $default,) {final _that = this;
switch (_that) {
case _NotificationModel() when $default != null:
return $default(_that.id,_that.userId,_that.type,_that.title,_that.message,_that.data,_that.isRead,_that.createdAt,_that.readAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationModel implements NotificationModel {
  const _NotificationModel({required this.id, required this.userId, required this.type, required this.title, required this.message, final  Map<String, dynamic>? data, this.isRead = false, this.createdAt, this.readAt}): _data = data;
  factory _NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);

@override final  String id;
@override final  String userId;
@override final  NotificationType type;
@override final  String title;
@override final  String message;
 final  Map<String, dynamic>? _data;
@override Map<String, dynamic>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey() final  bool isRead;
@override final  DateTime? createdAt;
@override final  DateTime? readAt;

/// Create a copy of NotificationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationModelCopyWith<_NotificationModel> get copyWith => __$NotificationModelCopyWithImpl<_NotificationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.readAt, readAt) || other.readAt == readAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,type,title,message,const DeepCollectionEquality().hash(_data),isRead,createdAt,readAt);

@override
String toString() {
  return 'NotificationModel(id: $id, userId: $userId, type: $type, title: $title, message: $message, data: $data, isRead: $isRead, createdAt: $createdAt, readAt: $readAt)';
}


}

/// @nodoc
abstract mixin class _$NotificationModelCopyWith<$Res> implements $NotificationModelCopyWith<$Res> {
  factory _$NotificationModelCopyWith(_NotificationModel value, $Res Function(_NotificationModel) _then) = __$NotificationModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, NotificationType type, String title, String message, Map<String, dynamic>? data, bool isRead, DateTime? createdAt, DateTime? readAt
});




}
/// @nodoc
class __$NotificationModelCopyWithImpl<$Res>
    implements _$NotificationModelCopyWith<$Res> {
  __$NotificationModelCopyWithImpl(this._self, this._then);

  final _NotificationModel _self;
  final $Res Function(_NotificationModel) _then;

/// Create a copy of NotificationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? type = null,Object? title = null,Object? message = null,Object? data = freezed,Object? isRead = null,Object? createdAt = freezed,Object? readAt = freezed,}) {
  return _then(_NotificationModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as NotificationType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,readAt: freezed == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$SpaceTransaction {

 String get id; String get type;// EXPENSE, INCOME, TRANSFER
 String get amount; String get currency; String? get description; String? get categoryKey;@JsonKey(name: 'transactionAt') DateTime? get transactionAt;@JsonKey(name: 'addedByUsername') String? get addedByUsername;@JsonKey(name: 'addedAt') DateTime? get addedAt;// 统一的金额显示格式（后端计算）
 Map<String, dynamic>? get display;
/// Create a copy of SpaceTransaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpaceTransactionCopyWith<SpaceTransaction> get copyWith => _$SpaceTransactionCopyWithImpl<SpaceTransaction>(this as SpaceTransaction, _$identity);

  /// Serializes this SpaceTransaction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpaceTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.description, description) || other.description == description)&&(identical(other.categoryKey, categoryKey) || other.categoryKey == categoryKey)&&(identical(other.transactionAt, transactionAt) || other.transactionAt == transactionAt)&&(identical(other.addedByUsername, addedByUsername) || other.addedByUsername == addedByUsername)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt)&&const DeepCollectionEquality().equals(other.display, display));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,amount,currency,description,categoryKey,transactionAt,addedByUsername,addedAt,const DeepCollectionEquality().hash(display));

@override
String toString() {
  return 'SpaceTransaction(id: $id, type: $type, amount: $amount, currency: $currency, description: $description, categoryKey: $categoryKey, transactionAt: $transactionAt, addedByUsername: $addedByUsername, addedAt: $addedAt, display: $display)';
}


}

/// @nodoc
abstract mixin class $SpaceTransactionCopyWith<$Res>  {
  factory $SpaceTransactionCopyWith(SpaceTransaction value, $Res Function(SpaceTransaction) _then) = _$SpaceTransactionCopyWithImpl;
@useResult
$Res call({
 String id, String type, String amount, String currency, String? description, String? categoryKey,@JsonKey(name: 'transactionAt') DateTime? transactionAt,@JsonKey(name: 'addedByUsername') String? addedByUsername,@JsonKey(name: 'addedAt') DateTime? addedAt, Map<String, dynamic>? display
});




}
/// @nodoc
class _$SpaceTransactionCopyWithImpl<$Res>
    implements $SpaceTransactionCopyWith<$Res> {
  _$SpaceTransactionCopyWithImpl(this._self, this._then);

  final SpaceTransaction _self;
  final $Res Function(SpaceTransaction) _then;

/// Create a copy of SpaceTransaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? amount = null,Object? currency = null,Object? description = freezed,Object? categoryKey = freezed,Object? transactionAt = freezed,Object? addedByUsername = freezed,Object? addedAt = freezed,Object? display = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,categoryKey: freezed == categoryKey ? _self.categoryKey : categoryKey // ignore: cast_nullable_to_non_nullable
as String?,transactionAt: freezed == transactionAt ? _self.transactionAt : transactionAt // ignore: cast_nullable_to_non_nullable
as DateTime?,addedByUsername: freezed == addedByUsername ? _self.addedByUsername : addedByUsername // ignore: cast_nullable_to_non_nullable
as String?,addedAt: freezed == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,display: freezed == display ? _self.display : display // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [SpaceTransaction].
extension SpaceTransactionPatterns on SpaceTransaction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpaceTransaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpaceTransaction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpaceTransaction value)  $default,){
final _that = this;
switch (_that) {
case _SpaceTransaction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpaceTransaction value)?  $default,){
final _that = this;
switch (_that) {
case _SpaceTransaction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String type,  String amount,  String currency,  String? description,  String? categoryKey, @JsonKey(name: 'transactionAt')  DateTime? transactionAt, @JsonKey(name: 'addedByUsername')  String? addedByUsername, @JsonKey(name: 'addedAt')  DateTime? addedAt,  Map<String, dynamic>? display)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpaceTransaction() when $default != null:
return $default(_that.id,_that.type,_that.amount,_that.currency,_that.description,_that.categoryKey,_that.transactionAt,_that.addedByUsername,_that.addedAt,_that.display);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String type,  String amount,  String currency,  String? description,  String? categoryKey, @JsonKey(name: 'transactionAt')  DateTime? transactionAt, @JsonKey(name: 'addedByUsername')  String? addedByUsername, @JsonKey(name: 'addedAt')  DateTime? addedAt,  Map<String, dynamic>? display)  $default,) {final _that = this;
switch (_that) {
case _SpaceTransaction():
return $default(_that.id,_that.type,_that.amount,_that.currency,_that.description,_that.categoryKey,_that.transactionAt,_that.addedByUsername,_that.addedAt,_that.display);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String type,  String amount,  String currency,  String? description,  String? categoryKey, @JsonKey(name: 'transactionAt')  DateTime? transactionAt, @JsonKey(name: 'addedByUsername')  String? addedByUsername, @JsonKey(name: 'addedAt')  DateTime? addedAt,  Map<String, dynamic>? display)?  $default,) {final _that = this;
switch (_that) {
case _SpaceTransaction() when $default != null:
return $default(_that.id,_that.type,_that.amount,_that.currency,_that.description,_that.categoryKey,_that.transactionAt,_that.addedByUsername,_that.addedAt,_that.display);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SpaceTransaction implements SpaceTransaction {
  const _SpaceTransaction({required this.id, required this.type, required this.amount, this.currency = 'CNY', this.description, this.categoryKey, @JsonKey(name: 'transactionAt') this.transactionAt, @JsonKey(name: 'addedByUsername') this.addedByUsername, @JsonKey(name: 'addedAt') this.addedAt, final  Map<String, dynamic>? display}): _display = display;
  factory _SpaceTransaction.fromJson(Map<String, dynamic> json) => _$SpaceTransactionFromJson(json);

@override final  String id;
@override final  String type;
// EXPENSE, INCOME, TRANSFER
@override final  String amount;
@override@JsonKey() final  String currency;
@override final  String? description;
@override final  String? categoryKey;
@override@JsonKey(name: 'transactionAt') final  DateTime? transactionAt;
@override@JsonKey(name: 'addedByUsername') final  String? addedByUsername;
@override@JsonKey(name: 'addedAt') final  DateTime? addedAt;
// 统一的金额显示格式（后端计算）
 final  Map<String, dynamic>? _display;
// 统一的金额显示格式（后端计算）
@override Map<String, dynamic>? get display {
  final value = _display;
  if (value == null) return null;
  if (_display is EqualUnmodifiableMapView) return _display;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of SpaceTransaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpaceTransactionCopyWith<_SpaceTransaction> get copyWith => __$SpaceTransactionCopyWithImpl<_SpaceTransaction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SpaceTransactionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpaceTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.description, description) || other.description == description)&&(identical(other.categoryKey, categoryKey) || other.categoryKey == categoryKey)&&(identical(other.transactionAt, transactionAt) || other.transactionAt == transactionAt)&&(identical(other.addedByUsername, addedByUsername) || other.addedByUsername == addedByUsername)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt)&&const DeepCollectionEquality().equals(other._display, _display));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,amount,currency,description,categoryKey,transactionAt,addedByUsername,addedAt,const DeepCollectionEquality().hash(_display));

@override
String toString() {
  return 'SpaceTransaction(id: $id, type: $type, amount: $amount, currency: $currency, description: $description, categoryKey: $categoryKey, transactionAt: $transactionAt, addedByUsername: $addedByUsername, addedAt: $addedAt, display: $display)';
}


}

/// @nodoc
abstract mixin class _$SpaceTransactionCopyWith<$Res> implements $SpaceTransactionCopyWith<$Res> {
  factory _$SpaceTransactionCopyWith(_SpaceTransaction value, $Res Function(_SpaceTransaction) _then) = __$SpaceTransactionCopyWithImpl;
@override @useResult
$Res call({
 String id, String type, String amount, String currency, String? description, String? categoryKey,@JsonKey(name: 'transactionAt') DateTime? transactionAt,@JsonKey(name: 'addedByUsername') String? addedByUsername,@JsonKey(name: 'addedAt') DateTime? addedAt, Map<String, dynamic>? display
});




}
/// @nodoc
class __$SpaceTransactionCopyWithImpl<$Res>
    implements _$SpaceTransactionCopyWith<$Res> {
  __$SpaceTransactionCopyWithImpl(this._self, this._then);

  final _SpaceTransaction _self;
  final $Res Function(_SpaceTransaction) _then;

/// Create a copy of SpaceTransaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? amount = null,Object? currency = null,Object? description = freezed,Object? categoryKey = freezed,Object? transactionAt = freezed,Object? addedByUsername = freezed,Object? addedAt = freezed,Object? display = freezed,}) {
  return _then(_SpaceTransaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,categoryKey: freezed == categoryKey ? _self.categoryKey : categoryKey // ignore: cast_nullable_to_non_nullable
as String?,transactionAt: freezed == transactionAt ? _self.transactionAt : transactionAt // ignore: cast_nullable_to_non_nullable
as DateTime?,addedByUsername: freezed == addedByUsername ? _self.addedByUsername : addedByUsername // ignore: cast_nullable_to_non_nullable
as String?,addedAt: freezed == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,display: freezed == display ? _self._display : display // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}


/// @nodoc
mixin _$SpaceTransactionListResponse {

 List<SpaceTransaction> get transactions; int get total; int get page; int get limit;
/// Create a copy of SpaceTransactionListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpaceTransactionListResponseCopyWith<SpaceTransactionListResponse> get copyWith => _$SpaceTransactionListResponseCopyWithImpl<SpaceTransactionListResponse>(this as SpaceTransactionListResponse, _$identity);

  /// Serializes this SpaceTransactionListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpaceTransactionListResponse&&const DeepCollectionEquality().equals(other.transactions, transactions)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(transactions),total,page,limit);

@override
String toString() {
  return 'SpaceTransactionListResponse(transactions: $transactions, total: $total, page: $page, limit: $limit)';
}


}

/// @nodoc
abstract mixin class $SpaceTransactionListResponseCopyWith<$Res>  {
  factory $SpaceTransactionListResponseCopyWith(SpaceTransactionListResponse value, $Res Function(SpaceTransactionListResponse) _then) = _$SpaceTransactionListResponseCopyWithImpl;
@useResult
$Res call({
 List<SpaceTransaction> transactions, int total, int page, int limit
});




}
/// @nodoc
class _$SpaceTransactionListResponseCopyWithImpl<$Res>
    implements $SpaceTransactionListResponseCopyWith<$Res> {
  _$SpaceTransactionListResponseCopyWithImpl(this._self, this._then);

  final SpaceTransactionListResponse _self;
  final $Res Function(SpaceTransactionListResponse) _then;

/// Create a copy of SpaceTransactionListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? transactions = null,Object? total = null,Object? page = null,Object? limit = null,}) {
  return _then(_self.copyWith(
transactions: null == transactions ? _self.transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<SpaceTransaction>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SpaceTransactionListResponse].
extension SpaceTransactionListResponsePatterns on SpaceTransactionListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpaceTransactionListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpaceTransactionListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpaceTransactionListResponse value)  $default,){
final _that = this;
switch (_that) {
case _SpaceTransactionListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpaceTransactionListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _SpaceTransactionListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SpaceTransaction> transactions,  int total,  int page,  int limit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpaceTransactionListResponse() when $default != null:
return $default(_that.transactions,_that.total,_that.page,_that.limit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SpaceTransaction> transactions,  int total,  int page,  int limit)  $default,) {final _that = this;
switch (_that) {
case _SpaceTransactionListResponse():
return $default(_that.transactions,_that.total,_that.page,_that.limit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SpaceTransaction> transactions,  int total,  int page,  int limit)?  $default,) {final _that = this;
switch (_that) {
case _SpaceTransactionListResponse() when $default != null:
return $default(_that.transactions,_that.total,_that.page,_that.limit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SpaceTransactionListResponse implements SpaceTransactionListResponse {
  const _SpaceTransactionListResponse({required final  List<SpaceTransaction> transactions, required this.total, required this.page, required this.limit}): _transactions = transactions;
  factory _SpaceTransactionListResponse.fromJson(Map<String, dynamic> json) => _$SpaceTransactionListResponseFromJson(json);

 final  List<SpaceTransaction> _transactions;
@override List<SpaceTransaction> get transactions {
  if (_transactions is EqualUnmodifiableListView) return _transactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transactions);
}

@override final  int total;
@override final  int page;
@override final  int limit;

/// Create a copy of SpaceTransactionListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpaceTransactionListResponseCopyWith<_SpaceTransactionListResponse> get copyWith => __$SpaceTransactionListResponseCopyWithImpl<_SpaceTransactionListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SpaceTransactionListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpaceTransactionListResponse&&const DeepCollectionEquality().equals(other._transactions, _transactions)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_transactions),total,page,limit);

@override
String toString() {
  return 'SpaceTransactionListResponse(transactions: $transactions, total: $total, page: $page, limit: $limit)';
}


}

/// @nodoc
abstract mixin class _$SpaceTransactionListResponseCopyWith<$Res> implements $SpaceTransactionListResponseCopyWith<$Res> {
  factory _$SpaceTransactionListResponseCopyWith(_SpaceTransactionListResponse value, $Res Function(_SpaceTransactionListResponse) _then) = __$SpaceTransactionListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<SpaceTransaction> transactions, int total, int page, int limit
});




}
/// @nodoc
class __$SpaceTransactionListResponseCopyWithImpl<$Res>
    implements _$SpaceTransactionListResponseCopyWith<$Res> {
  __$SpaceTransactionListResponseCopyWithImpl(this._self, this._then);

  final _SpaceTransactionListResponse _self;
  final $Res Function(_SpaceTransactionListResponse) _then;

/// Create a copy of SpaceTransactionListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? transactions = null,Object? total = null,Object? page = null,Object? limit = null,}) {
  return _then(_SpaceTransactionListResponse(
transactions: null == transactions ? _self._transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<SpaceTransaction>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$SharedSpaceListResponse {

 List<SharedSpace> get spaces; int get total; int get page; int get limit;
/// Create a copy of SharedSpaceListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SharedSpaceListResponseCopyWith<SharedSpaceListResponse> get copyWith => _$SharedSpaceListResponseCopyWithImpl<SharedSpaceListResponse>(this as SharedSpaceListResponse, _$identity);

  /// Serializes this SharedSpaceListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SharedSpaceListResponse&&const DeepCollectionEquality().equals(other.spaces, spaces)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(spaces),total,page,limit);

@override
String toString() {
  return 'SharedSpaceListResponse(spaces: $spaces, total: $total, page: $page, limit: $limit)';
}


}

/// @nodoc
abstract mixin class $SharedSpaceListResponseCopyWith<$Res>  {
  factory $SharedSpaceListResponseCopyWith(SharedSpaceListResponse value, $Res Function(SharedSpaceListResponse) _then) = _$SharedSpaceListResponseCopyWithImpl;
@useResult
$Res call({
 List<SharedSpace> spaces, int total, int page, int limit
});




}
/// @nodoc
class _$SharedSpaceListResponseCopyWithImpl<$Res>
    implements $SharedSpaceListResponseCopyWith<$Res> {
  _$SharedSpaceListResponseCopyWithImpl(this._self, this._then);

  final SharedSpaceListResponse _self;
  final $Res Function(SharedSpaceListResponse) _then;

/// Create a copy of SharedSpaceListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? spaces = null,Object? total = null,Object? page = null,Object? limit = null,}) {
  return _then(_self.copyWith(
spaces: null == spaces ? _self.spaces : spaces // ignore: cast_nullable_to_non_nullable
as List<SharedSpace>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SharedSpaceListResponse].
extension SharedSpaceListResponsePatterns on SharedSpaceListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SharedSpaceListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SharedSpaceListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SharedSpaceListResponse value)  $default,){
final _that = this;
switch (_that) {
case _SharedSpaceListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SharedSpaceListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _SharedSpaceListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SharedSpace> spaces,  int total,  int page,  int limit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SharedSpaceListResponse() when $default != null:
return $default(_that.spaces,_that.total,_that.page,_that.limit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SharedSpace> spaces,  int total,  int page,  int limit)  $default,) {final _that = this;
switch (_that) {
case _SharedSpaceListResponse():
return $default(_that.spaces,_that.total,_that.page,_that.limit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SharedSpace> spaces,  int total,  int page,  int limit)?  $default,) {final _that = this;
switch (_that) {
case _SharedSpaceListResponse() when $default != null:
return $default(_that.spaces,_that.total,_that.page,_that.limit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SharedSpaceListResponse implements SharedSpaceListResponse {
  const _SharedSpaceListResponse({required final  List<SharedSpace> spaces, required this.total, required this.page, required this.limit}): _spaces = spaces;
  factory _SharedSpaceListResponse.fromJson(Map<String, dynamic> json) => _$SharedSpaceListResponseFromJson(json);

 final  List<SharedSpace> _spaces;
@override List<SharedSpace> get spaces {
  if (_spaces is EqualUnmodifiableListView) return _spaces;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_spaces);
}

@override final  int total;
@override final  int page;
@override final  int limit;

/// Create a copy of SharedSpaceListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SharedSpaceListResponseCopyWith<_SharedSpaceListResponse> get copyWith => __$SharedSpaceListResponseCopyWithImpl<_SharedSpaceListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SharedSpaceListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SharedSpaceListResponse&&const DeepCollectionEquality().equals(other._spaces, _spaces)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_spaces),total,page,limit);

@override
String toString() {
  return 'SharedSpaceListResponse(spaces: $spaces, total: $total, page: $page, limit: $limit)';
}


}

/// @nodoc
abstract mixin class _$SharedSpaceListResponseCopyWith<$Res> implements $SharedSpaceListResponseCopyWith<$Res> {
  factory _$SharedSpaceListResponseCopyWith(_SharedSpaceListResponse value, $Res Function(_SharedSpaceListResponse) _then) = __$SharedSpaceListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<SharedSpace> spaces, int total, int page, int limit
});




}
/// @nodoc
class __$SharedSpaceListResponseCopyWithImpl<$Res>
    implements _$SharedSpaceListResponseCopyWith<$Res> {
  __$SharedSpaceListResponseCopyWithImpl(this._self, this._then);

  final _SharedSpaceListResponse _self;
  final $Res Function(_SharedSpaceListResponse) _then;

/// Create a copy of SharedSpaceListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? spaces = null,Object? total = null,Object? page = null,Object? limit = null,}) {
  return _then(_SharedSpaceListResponse(
spaces: null == spaces ? _self._spaces : spaces // ignore: cast_nullable_to_non_nullable
as List<SharedSpace>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$NotificationListResponse {

 List<NotificationModel> get notifications; int get total; int get unreadCount; int get page; int get limit;
/// Create a copy of NotificationListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationListResponseCopyWith<NotificationListResponse> get copyWith => _$NotificationListResponseCopyWithImpl<NotificationListResponse>(this as NotificationListResponse, _$identity);

  /// Serializes this NotificationListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationListResponse&&const DeepCollectionEquality().equals(other.notifications, notifications)&&(identical(other.total, total) || other.total == total)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(notifications),total,unreadCount,page,limit);

@override
String toString() {
  return 'NotificationListResponse(notifications: $notifications, total: $total, unreadCount: $unreadCount, page: $page, limit: $limit)';
}


}

/// @nodoc
abstract mixin class $NotificationListResponseCopyWith<$Res>  {
  factory $NotificationListResponseCopyWith(NotificationListResponse value, $Res Function(NotificationListResponse) _then) = _$NotificationListResponseCopyWithImpl;
@useResult
$Res call({
 List<NotificationModel> notifications, int total, int unreadCount, int page, int limit
});




}
/// @nodoc
class _$NotificationListResponseCopyWithImpl<$Res>
    implements $NotificationListResponseCopyWith<$Res> {
  _$NotificationListResponseCopyWithImpl(this._self, this._then);

  final NotificationListResponse _self;
  final $Res Function(NotificationListResponse) _then;

/// Create a copy of NotificationListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? notifications = null,Object? total = null,Object? unreadCount = null,Object? page = null,Object? limit = null,}) {
  return _then(_self.copyWith(
notifications: null == notifications ? _self.notifications : notifications // ignore: cast_nullable_to_non_nullable
as List<NotificationModel>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationListResponse].
extension NotificationListResponsePatterns on NotificationListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationListResponse value)  $default,){
final _that = this;
switch (_that) {
case _NotificationListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<NotificationModel> notifications,  int total,  int unreadCount,  int page,  int limit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationListResponse() when $default != null:
return $default(_that.notifications,_that.total,_that.unreadCount,_that.page,_that.limit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<NotificationModel> notifications,  int total,  int unreadCount,  int page,  int limit)  $default,) {final _that = this;
switch (_that) {
case _NotificationListResponse():
return $default(_that.notifications,_that.total,_that.unreadCount,_that.page,_that.limit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<NotificationModel> notifications,  int total,  int unreadCount,  int page,  int limit)?  $default,) {final _that = this;
switch (_that) {
case _NotificationListResponse() when $default != null:
return $default(_that.notifications,_that.total,_that.unreadCount,_that.page,_that.limit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationListResponse implements NotificationListResponse {
  const _NotificationListResponse({required final  List<NotificationModel> notifications, required this.total, required this.unreadCount, required this.page, required this.limit}): _notifications = notifications;
  factory _NotificationListResponse.fromJson(Map<String, dynamic> json) => _$NotificationListResponseFromJson(json);

 final  List<NotificationModel> _notifications;
@override List<NotificationModel> get notifications {
  if (_notifications is EqualUnmodifiableListView) return _notifications;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_notifications);
}

@override final  int total;
@override final  int unreadCount;
@override final  int page;
@override final  int limit;

/// Create a copy of NotificationListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationListResponseCopyWith<_NotificationListResponse> get copyWith => __$NotificationListResponseCopyWithImpl<_NotificationListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationListResponse&&const DeepCollectionEquality().equals(other._notifications, _notifications)&&(identical(other.total, total) || other.total == total)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_notifications),total,unreadCount,page,limit);

@override
String toString() {
  return 'NotificationListResponse(notifications: $notifications, total: $total, unreadCount: $unreadCount, page: $page, limit: $limit)';
}


}

/// @nodoc
abstract mixin class _$NotificationListResponseCopyWith<$Res> implements $NotificationListResponseCopyWith<$Res> {
  factory _$NotificationListResponseCopyWith(_NotificationListResponse value, $Res Function(_NotificationListResponse) _then) = __$NotificationListResponseCopyWithImpl;
@override @useResult
$Res call({
 List<NotificationModel> notifications, int total, int unreadCount, int page, int limit
});




}
/// @nodoc
class __$NotificationListResponseCopyWithImpl<$Res>
    implements _$NotificationListResponseCopyWith<$Res> {
  __$NotificationListResponseCopyWithImpl(this._self, this._then);

  final _NotificationListResponse _self;
  final $Res Function(_NotificationListResponse) _then;

/// Create a copy of NotificationListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? notifications = null,Object? total = null,Object? unreadCount = null,Object? page = null,Object? limit = null,}) {
  return _then(_NotificationListResponse(
notifications: null == notifications ? _self._notifications : notifications // ignore: cast_nullable_to_non_nullable
as List<NotificationModel>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
