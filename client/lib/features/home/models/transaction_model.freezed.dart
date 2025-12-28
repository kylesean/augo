// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SharedUserInfo {

 String get userId; String get avatarUrl;// User avatar URL
 String? get username;
/// Create a copy of SharedUserInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SharedUserInfoCopyWith<SharedUserInfo> get copyWith => _$SharedUserInfoCopyWithImpl<SharedUserInfo>(this as SharedUserInfo, _$identity);

  /// Serializes this SharedUserInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SharedUserInfo&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.username, username) || other.username == username));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,avatarUrl,username);

@override
String toString() {
  return 'SharedUserInfo(userId: $userId, avatarUrl: $avatarUrl, username: $username)';
}


}

/// @nodoc
abstract mixin class $SharedUserInfoCopyWith<$Res>  {
  factory $SharedUserInfoCopyWith(SharedUserInfo value, $Res Function(SharedUserInfo) _then) = _$SharedUserInfoCopyWithImpl;
@useResult
$Res call({
 String userId, String avatarUrl, String? username
});




}
/// @nodoc
class _$SharedUserInfoCopyWithImpl<$Res>
    implements $SharedUserInfoCopyWith<$Res> {
  _$SharedUserInfoCopyWithImpl(this._self, this._then);

  final SharedUserInfo _self;
  final $Res Function(SharedUserInfo) _then;

/// Create a copy of SharedUserInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? avatarUrl = null,Object? username = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SharedUserInfo].
extension SharedUserInfoPatterns on SharedUserInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SharedUserInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SharedUserInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SharedUserInfo value)  $default,){
final _that = this;
switch (_that) {
case _SharedUserInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SharedUserInfo value)?  $default,){
final _that = this;
switch (_that) {
case _SharedUserInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String avatarUrl,  String? username)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SharedUserInfo() when $default != null:
return $default(_that.userId,_that.avatarUrl,_that.username);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String avatarUrl,  String? username)  $default,) {final _that = this;
switch (_that) {
case _SharedUserInfo():
return $default(_that.userId,_that.avatarUrl,_that.username);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String avatarUrl,  String? username)?  $default,) {final _that = this;
switch (_that) {
case _SharedUserInfo() when $default != null:
return $default(_that.userId,_that.avatarUrl,_that.username);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SharedUserInfo implements SharedUserInfo {
  const _SharedUserInfo({required this.userId, required this.avatarUrl, this.username});
  factory _SharedUserInfo.fromJson(Map<String, dynamic> json) => _$SharedUserInfoFromJson(json);

@override final  String userId;
@override final  String avatarUrl;
// User avatar URL
@override final  String? username;

/// Create a copy of SharedUserInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SharedUserInfoCopyWith<_SharedUserInfo> get copyWith => __$SharedUserInfoCopyWithImpl<_SharedUserInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SharedUserInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SharedUserInfo&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.username, username) || other.username == username));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,avatarUrl,username);

@override
String toString() {
  return 'SharedUserInfo(userId: $userId, avatarUrl: $avatarUrl, username: $username)';
}


}

/// @nodoc
abstract mixin class _$SharedUserInfoCopyWith<$Res> implements $SharedUserInfoCopyWith<$Res> {
  factory _$SharedUserInfoCopyWith(_SharedUserInfo value, $Res Function(_SharedUserInfo) _then) = __$SharedUserInfoCopyWithImpl;
@override @useResult
$Res call({
 String userId, String avatarUrl, String? username
});




}
/// @nodoc
class __$SharedUserInfoCopyWithImpl<$Res>
    implements _$SharedUserInfoCopyWith<$Res> {
  __$SharedUserInfoCopyWithImpl(this._self, this._then);

  final _SharedUserInfo _self;
  final $Res Function(_SharedUserInfo) _then;

/// Create a copy of SharedUserInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? avatarUrl = null,Object? username = freezed,}) {
  return _then(_SharedUserInfo(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$FinancialAccountInfo {

 String get id; String get name;
/// Create a copy of FinancialAccountInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinancialAccountInfoCopyWith<FinancialAccountInfo> get copyWith => _$FinancialAccountInfoCopyWithImpl<FinancialAccountInfo>(this as FinancialAccountInfo, _$identity);

  /// Serializes this FinancialAccountInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinancialAccountInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'FinancialAccountInfo(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $FinancialAccountInfoCopyWith<$Res>  {
  factory $FinancialAccountInfoCopyWith(FinancialAccountInfo value, $Res Function(FinancialAccountInfo) _then) = _$FinancialAccountInfoCopyWithImpl;
@useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class _$FinancialAccountInfoCopyWithImpl<$Res>
    implements $FinancialAccountInfoCopyWith<$Res> {
  _$FinancialAccountInfoCopyWithImpl(this._self, this._then);

  final FinancialAccountInfo _self;
  final $Res Function(FinancialAccountInfo) _then;

/// Create a copy of FinancialAccountInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FinancialAccountInfo].
extension FinancialAccountInfoPatterns on FinancialAccountInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinancialAccountInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinancialAccountInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinancialAccountInfo value)  $default,){
final _that = this;
switch (_that) {
case _FinancialAccountInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinancialAccountInfo value)?  $default,){
final _that = this;
switch (_that) {
case _FinancialAccountInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinancialAccountInfo() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name)  $default,) {final _that = this;
switch (_that) {
case _FinancialAccountInfo():
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _FinancialAccountInfo() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FinancialAccountInfo implements FinancialAccountInfo {
  const _FinancialAccountInfo({required this.id, required this.name});
  factory _FinancialAccountInfo.fromJson(Map<String, dynamic> json) => _$FinancialAccountInfoFromJson(json);

@override final  String id;
@override final  String name;

/// Create a copy of FinancialAccountInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinancialAccountInfoCopyWith<_FinancialAccountInfo> get copyWith => __$FinancialAccountInfoCopyWithImpl<_FinancialAccountInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FinancialAccountInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinancialAccountInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'FinancialAccountInfo(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$FinancialAccountInfoCopyWith<$Res> implements $FinancialAccountInfoCopyWith<$Res> {
  factory _$FinancialAccountInfoCopyWith(_FinancialAccountInfo value, $Res Function(_FinancialAccountInfo) _then) = __$FinancialAccountInfoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class __$FinancialAccountInfoCopyWithImpl<$Res>
    implements _$FinancialAccountInfoCopyWith<$Res> {
  __$FinancialAccountInfoCopyWithImpl(this._self, this._then);

  final _FinancialAccountInfo _self;
  final $Res Function(_FinancialAccountInfo) _then;

/// Create a copy of FinancialAccountInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_FinancialAccountInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SpaceInfo {

 String get id; String get name;
/// Create a copy of SpaceInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpaceInfoCopyWith<SpaceInfo> get copyWith => _$SpaceInfoCopyWithImpl<SpaceInfo>(this as SpaceInfo, _$identity);

  /// Serializes this SpaceInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpaceInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'SpaceInfo(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $SpaceInfoCopyWith<$Res>  {
  factory $SpaceInfoCopyWith(SpaceInfo value, $Res Function(SpaceInfo) _then) = _$SpaceInfoCopyWithImpl;
@useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class _$SpaceInfoCopyWithImpl<$Res>
    implements $SpaceInfoCopyWith<$Res> {
  _$SpaceInfoCopyWithImpl(this._self, this._then);

  final SpaceInfo _self;
  final $Res Function(SpaceInfo) _then;

/// Create a copy of SpaceInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SpaceInfo].
extension SpaceInfoPatterns on SpaceInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpaceInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpaceInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpaceInfo value)  $default,){
final _that = this;
switch (_that) {
case _SpaceInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpaceInfo value)?  $default,){
final _that = this;
switch (_that) {
case _SpaceInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpaceInfo() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name)  $default,) {final _that = this;
switch (_that) {
case _SpaceInfo():
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _SpaceInfo() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SpaceInfo implements SpaceInfo {
  const _SpaceInfo({required this.id, required this.name});
  factory _SpaceInfo.fromJson(Map<String, dynamic> json) => _$SpaceInfoFromJson(json);

@override final  String id;
@override final  String name;

/// Create a copy of SpaceInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpaceInfoCopyWith<_SpaceInfo> get copyWith => __$SpaceInfoCopyWithImpl<_SpaceInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SpaceInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpaceInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'SpaceInfo(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$SpaceInfoCopyWith<$Res> implements $SpaceInfoCopyWith<$Res> {
  factory _$SpaceInfoCopyWith(_SpaceInfo value, $Res Function(_SpaceInfo) _then) = __$SpaceInfoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class __$SpaceInfoCopyWithImpl<$Res>
    implements _$SpaceInfoCopyWith<$Res> {
  __$SpaceInfoCopyWithImpl(this._self, this._then);

  final _SpaceInfo _self;
  final $Res Function(_SpaceInfo) _then;

/// Create a copy of SpaceInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_SpaceInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AmountDisplay {

 String get sign; String get value; String get currencySymbol; String get fullString;
/// Create a copy of AmountDisplay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AmountDisplayCopyWith<AmountDisplay> get copyWith => _$AmountDisplayCopyWithImpl<AmountDisplay>(this as AmountDisplay, _$identity);

  /// Serializes this AmountDisplay to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AmountDisplay&&(identical(other.sign, sign) || other.sign == sign)&&(identical(other.value, value) || other.value == value)&&(identical(other.currencySymbol, currencySymbol) || other.currencySymbol == currencySymbol)&&(identical(other.fullString, fullString) || other.fullString == fullString));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sign,value,currencySymbol,fullString);

@override
String toString() {
  return 'AmountDisplay(sign: $sign, value: $value, currencySymbol: $currencySymbol, fullString: $fullString)';
}


}

/// @nodoc
abstract mixin class $AmountDisplayCopyWith<$Res>  {
  factory $AmountDisplayCopyWith(AmountDisplay value, $Res Function(AmountDisplay) _then) = _$AmountDisplayCopyWithImpl;
@useResult
$Res call({
 String sign, String value, String currencySymbol, String fullString
});




}
/// @nodoc
class _$AmountDisplayCopyWithImpl<$Res>
    implements $AmountDisplayCopyWith<$Res> {
  _$AmountDisplayCopyWithImpl(this._self, this._then);

  final AmountDisplay _self;
  final $Res Function(AmountDisplay) _then;

/// Create a copy of AmountDisplay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sign = null,Object? value = null,Object? currencySymbol = null,Object? fullString = null,}) {
  return _then(_self.copyWith(
sign: null == sign ? _self.sign : sign // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,currencySymbol: null == currencySymbol ? _self.currencySymbol : currencySymbol // ignore: cast_nullable_to_non_nullable
as String,fullString: null == fullString ? _self.fullString : fullString // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AmountDisplay].
extension AmountDisplayPatterns on AmountDisplay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AmountDisplay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AmountDisplay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AmountDisplay value)  $default,){
final _that = this;
switch (_that) {
case _AmountDisplay():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AmountDisplay value)?  $default,){
final _that = this;
switch (_that) {
case _AmountDisplay() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sign,  String value,  String currencySymbol,  String fullString)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AmountDisplay() when $default != null:
return $default(_that.sign,_that.value,_that.currencySymbol,_that.fullString);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sign,  String value,  String currencySymbol,  String fullString)  $default,) {final _that = this;
switch (_that) {
case _AmountDisplay():
return $default(_that.sign,_that.value,_that.currencySymbol,_that.fullString);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sign,  String value,  String currencySymbol,  String fullString)?  $default,) {final _that = this;
switch (_that) {
case _AmountDisplay() when $default != null:
return $default(_that.sign,_that.value,_that.currencySymbol,_that.fullString);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AmountDisplay implements AmountDisplay {
  const _AmountDisplay({required this.sign, required this.value, required this.currencySymbol, required this.fullString});
  factory _AmountDisplay.fromJson(Map<String, dynamic> json) => _$AmountDisplayFromJson(json);

@override final  String sign;
@override final  String value;
@override final  String currencySymbol;
@override final  String fullString;

/// Create a copy of AmountDisplay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AmountDisplayCopyWith<_AmountDisplay> get copyWith => __$AmountDisplayCopyWithImpl<_AmountDisplay>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AmountDisplayToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AmountDisplay&&(identical(other.sign, sign) || other.sign == sign)&&(identical(other.value, value) || other.value == value)&&(identical(other.currencySymbol, currencySymbol) || other.currencySymbol == currencySymbol)&&(identical(other.fullString, fullString) || other.fullString == fullString));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sign,value,currencySymbol,fullString);

@override
String toString() {
  return 'AmountDisplay(sign: $sign, value: $value, currencySymbol: $currencySymbol, fullString: $fullString)';
}


}

/// @nodoc
abstract mixin class _$AmountDisplayCopyWith<$Res> implements $AmountDisplayCopyWith<$Res> {
  factory _$AmountDisplayCopyWith(_AmountDisplay value, $Res Function(_AmountDisplay) _then) = __$AmountDisplayCopyWithImpl;
@override @useResult
$Res call({
 String sign, String value, String currencySymbol, String fullString
});




}
/// @nodoc
class __$AmountDisplayCopyWithImpl<$Res>
    implements _$AmountDisplayCopyWith<$Res> {
  __$AmountDisplayCopyWithImpl(this._self, this._then);

  final _AmountDisplay _self;
  final $Res Function(_AmountDisplay) _then;

/// Create a copy of AmountDisplay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sign = null,Object? value = null,Object? currencySymbol = null,Object? fullString = null,}) {
  return _then(_AmountDisplay(
sign: null == sign ? _self.sign : sign // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,currencySymbol: null == currencySymbol ? _self.currencySymbol : currencySymbol // ignore: cast_nullable_to_non_nullable
as String,fullString: null == fullString ? _self.fullString : fullString // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$TransactionCommentModel {

 int get id; String get transactionId; String get userUuid; String? get userName; String? get userAvatarUrl; int? get parentCommentId; String get commentText; List<int> get mentionedUserIds; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of TransactionCommentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionCommentModelCopyWith<TransactionCommentModel> get copyWith => _$TransactionCommentModelCopyWithImpl<TransactionCommentModel>(this as TransactionCommentModel, _$identity);

  /// Serializes this TransactionCommentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionCommentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.userUuid, userUuid) || other.userUuid == userUuid)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.userAvatarUrl, userAvatarUrl) || other.userAvatarUrl == userAvatarUrl)&&(identical(other.parentCommentId, parentCommentId) || other.parentCommentId == parentCommentId)&&(identical(other.commentText, commentText) || other.commentText == commentText)&&const DeepCollectionEquality().equals(other.mentionedUserIds, mentionedUserIds)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,transactionId,userUuid,userName,userAvatarUrl,parentCommentId,commentText,const DeepCollectionEquality().hash(mentionedUserIds),createdAt,updatedAt);

@override
String toString() {
  return 'TransactionCommentModel(id: $id, transactionId: $transactionId, userUuid: $userUuid, userName: $userName, userAvatarUrl: $userAvatarUrl, parentCommentId: $parentCommentId, commentText: $commentText, mentionedUserIds: $mentionedUserIds, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $TransactionCommentModelCopyWith<$Res>  {
  factory $TransactionCommentModelCopyWith(TransactionCommentModel value, $Res Function(TransactionCommentModel) _then) = _$TransactionCommentModelCopyWithImpl;
@useResult
$Res call({
 int id, String transactionId, String userUuid, String? userName, String? userAvatarUrl, int? parentCommentId, String commentText, List<int> mentionedUserIds, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$TransactionCommentModelCopyWithImpl<$Res>
    implements $TransactionCommentModelCopyWith<$Res> {
  _$TransactionCommentModelCopyWithImpl(this._self, this._then);

  final TransactionCommentModel _self;
  final $Res Function(TransactionCommentModel) _then;

/// Create a copy of TransactionCommentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? transactionId = null,Object? userUuid = null,Object? userName = freezed,Object? userAvatarUrl = freezed,Object? parentCommentId = freezed,Object? commentText = null,Object? mentionedUserIds = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,transactionId: null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String,userUuid: null == userUuid ? _self.userUuid : userUuid // ignore: cast_nullable_to_non_nullable
as String,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,userAvatarUrl: freezed == userAvatarUrl ? _self.userAvatarUrl : userAvatarUrl // ignore: cast_nullable_to_non_nullable
as String?,parentCommentId: freezed == parentCommentId ? _self.parentCommentId : parentCommentId // ignore: cast_nullable_to_non_nullable
as int?,commentText: null == commentText ? _self.commentText : commentText // ignore: cast_nullable_to_non_nullable
as String,mentionedUserIds: null == mentionedUserIds ? _self.mentionedUserIds : mentionedUserIds // ignore: cast_nullable_to_non_nullable
as List<int>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionCommentModel].
extension TransactionCommentModelPatterns on TransactionCommentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionCommentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionCommentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionCommentModel value)  $default,){
final _that = this;
switch (_that) {
case _TransactionCommentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionCommentModel value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionCommentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String transactionId,  String userUuid,  String? userName,  String? userAvatarUrl,  int? parentCommentId,  String commentText,  List<int> mentionedUserIds,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionCommentModel() when $default != null:
return $default(_that.id,_that.transactionId,_that.userUuid,_that.userName,_that.userAvatarUrl,_that.parentCommentId,_that.commentText,_that.mentionedUserIds,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String transactionId,  String userUuid,  String? userName,  String? userAvatarUrl,  int? parentCommentId,  String commentText,  List<int> mentionedUserIds,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _TransactionCommentModel():
return $default(_that.id,_that.transactionId,_that.userUuid,_that.userName,_that.userAvatarUrl,_that.parentCommentId,_that.commentText,_that.mentionedUserIds,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String transactionId,  String userUuid,  String? userName,  String? userAvatarUrl,  int? parentCommentId,  String commentText,  List<int> mentionedUserIds,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _TransactionCommentModel() when $default != null:
return $default(_that.id,_that.transactionId,_that.userUuid,_that.userName,_that.userAvatarUrl,_that.parentCommentId,_that.commentText,_that.mentionedUserIds,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionCommentModel implements TransactionCommentModel {
  const _TransactionCommentModel({required this.id, required this.transactionId, required this.userUuid, this.userName, this.userAvatarUrl, this.parentCommentId, required this.commentText, final  List<int> mentionedUserIds = const [], this.createdAt, this.updatedAt}): _mentionedUserIds = mentionedUserIds;
  factory _TransactionCommentModel.fromJson(Map<String, dynamic> json) => _$TransactionCommentModelFromJson(json);

@override final  int id;
@override final  String transactionId;
@override final  String userUuid;
@override final  String? userName;
@override final  String? userAvatarUrl;
@override final  int? parentCommentId;
@override final  String commentText;
 final  List<int> _mentionedUserIds;
@override@JsonKey() List<int> get mentionedUserIds {
  if (_mentionedUserIds is EqualUnmodifiableListView) return _mentionedUserIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mentionedUserIds);
}

@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of TransactionCommentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionCommentModelCopyWith<_TransactionCommentModel> get copyWith => __$TransactionCommentModelCopyWithImpl<_TransactionCommentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionCommentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionCommentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.userUuid, userUuid) || other.userUuid == userUuid)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.userAvatarUrl, userAvatarUrl) || other.userAvatarUrl == userAvatarUrl)&&(identical(other.parentCommentId, parentCommentId) || other.parentCommentId == parentCommentId)&&(identical(other.commentText, commentText) || other.commentText == commentText)&&const DeepCollectionEquality().equals(other._mentionedUserIds, _mentionedUserIds)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,transactionId,userUuid,userName,userAvatarUrl,parentCommentId,commentText,const DeepCollectionEquality().hash(_mentionedUserIds),createdAt,updatedAt);

@override
String toString() {
  return 'TransactionCommentModel(id: $id, transactionId: $transactionId, userUuid: $userUuid, userName: $userName, userAvatarUrl: $userAvatarUrl, parentCommentId: $parentCommentId, commentText: $commentText, mentionedUserIds: $mentionedUserIds, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$TransactionCommentModelCopyWith<$Res> implements $TransactionCommentModelCopyWith<$Res> {
  factory _$TransactionCommentModelCopyWith(_TransactionCommentModel value, $Res Function(_TransactionCommentModel) _then) = __$TransactionCommentModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String transactionId, String userUuid, String? userName, String? userAvatarUrl, int? parentCommentId, String commentText, List<int> mentionedUserIds, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$TransactionCommentModelCopyWithImpl<$Res>
    implements _$TransactionCommentModelCopyWith<$Res> {
  __$TransactionCommentModelCopyWithImpl(this._self, this._then);

  final _TransactionCommentModel _self;
  final $Res Function(_TransactionCommentModel) _then;

/// Create a copy of TransactionCommentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? transactionId = null,Object? userUuid = null,Object? userName = freezed,Object? userAvatarUrl = freezed,Object? parentCommentId = freezed,Object? commentText = null,Object? mentionedUserIds = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_TransactionCommentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,transactionId: null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String,userUuid: null == userUuid ? _self.userUuid : userUuid // ignore: cast_nullable_to_non_nullable
as String,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,userAvatarUrl: freezed == userAvatarUrl ? _self.userAvatarUrl : userAvatarUrl // ignore: cast_nullable_to_non_nullable
as String?,parentCommentId: freezed == parentCommentId ? _self.parentCommentId : parentCommentId // ignore: cast_nullable_to_non_nullable
as int?,commentText: null == commentText ? _self.commentText : commentText // ignore: cast_nullable_to_non_nullable
as String,mentionedUserIds: null == mentionedUserIds ? _self._mentionedUserIds : mentionedUserIds // ignore: cast_nullable_to_non_nullable
as List<int>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$TransactionModel {

 String get id;// Unique ID
 TransactionType get type;// Transaction type (expense/income/transfer)
 String get category;// Category (e.g., Dining, Transport, Salary)
 String? get categoryKey;// Category ID
 String? get categoryText;// Server-side localized category name
 String get iconUrl;// Category icon URL (or local path)
 double get amount;// Display amount after conversion
 DateTime get timestamp;// Transaction time
// Original amount information (historical data, immutable)
 double? get amountOriginal;// Original recorded amount
 String? get originalCurrency;// Original recorded currency (e.g., USD, CNY)
 String? get exchangeRate;// Exchange rate snapshot at time of recording
// Other fields
 String? get description;// Note
 bool get isShared; List<SharedUserInfo> get sharedWith; String? get paymentMethod; String? get paymentMethodText;// Server-side localized payment method name
 String? get location; List<String> get tags; String? get rawInput; FinancialAccountInfo? get financialAccount; AmountDisplay? get display; DateTime? get createdAt; DateTime? get updatedAt; String? get photoPath; String? get geoLocation; List<TransactionCommentModel> get comments;// Comment list
// Associated account and space information
 String? get sourceAccountId;// Source account ID
 String? get targetAccountId;// Target account ID
 List<SpaceInfo> get spaces;// Associated shared spaces
 String? get sourceThreadId;
/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionModelCopyWith<TransactionModel> get copyWith => _$TransactionModelCopyWithImpl<TransactionModel>(this as TransactionModel, _$identity);

  /// Serializes this TransactionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.category, category) || other.category == category)&&(identical(other.categoryKey, categoryKey) || other.categoryKey == categoryKey)&&(identical(other.categoryText, categoryText) || other.categoryText == categoryText)&&(identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.amountOriginal, amountOriginal) || other.amountOriginal == amountOriginal)&&(identical(other.originalCurrency, originalCurrency) || other.originalCurrency == originalCurrency)&&(identical(other.exchangeRate, exchangeRate) || other.exchangeRate == exchangeRate)&&(identical(other.description, description) || other.description == description)&&(identical(other.isShared, isShared) || other.isShared == isShared)&&const DeepCollectionEquality().equals(other.sharedWith, sharedWith)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.paymentMethodText, paymentMethodText) || other.paymentMethodText == paymentMethodText)&&(identical(other.location, location) || other.location == location)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.rawInput, rawInput) || other.rawInput == rawInput)&&(identical(other.financialAccount, financialAccount) || other.financialAccount == financialAccount)&&(identical(other.display, display) || other.display == display)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.geoLocation, geoLocation) || other.geoLocation == geoLocation)&&const DeepCollectionEquality().equals(other.comments, comments)&&(identical(other.sourceAccountId, sourceAccountId) || other.sourceAccountId == sourceAccountId)&&(identical(other.targetAccountId, targetAccountId) || other.targetAccountId == targetAccountId)&&const DeepCollectionEquality().equals(other.spaces, spaces)&&(identical(other.sourceThreadId, sourceThreadId) || other.sourceThreadId == sourceThreadId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,type,category,categoryKey,categoryText,iconUrl,amount,timestamp,amountOriginal,originalCurrency,exchangeRate,description,isShared,const DeepCollectionEquality().hash(sharedWith),paymentMethod,paymentMethodText,location,const DeepCollectionEquality().hash(tags),rawInput,financialAccount,display,createdAt,updatedAt,photoPath,geoLocation,const DeepCollectionEquality().hash(comments),sourceAccountId,targetAccountId,const DeepCollectionEquality().hash(spaces),sourceThreadId]);

@override
String toString() {
  return 'TransactionModel(id: $id, type: $type, category: $category, categoryKey: $categoryKey, categoryText: $categoryText, iconUrl: $iconUrl, amount: $amount, timestamp: $timestamp, amountOriginal: $amountOriginal, originalCurrency: $originalCurrency, exchangeRate: $exchangeRate, description: $description, isShared: $isShared, sharedWith: $sharedWith, paymentMethod: $paymentMethod, paymentMethodText: $paymentMethodText, location: $location, tags: $tags, rawInput: $rawInput, financialAccount: $financialAccount, display: $display, createdAt: $createdAt, updatedAt: $updatedAt, photoPath: $photoPath, geoLocation: $geoLocation, comments: $comments, sourceAccountId: $sourceAccountId, targetAccountId: $targetAccountId, spaces: $spaces, sourceThreadId: $sourceThreadId)';
}


}

/// @nodoc
abstract mixin class $TransactionModelCopyWith<$Res>  {
  factory $TransactionModelCopyWith(TransactionModel value, $Res Function(TransactionModel) _then) = _$TransactionModelCopyWithImpl;
@useResult
$Res call({
 String id, TransactionType type, String category, String? categoryKey, String? categoryText, String iconUrl, double amount, DateTime timestamp, double? amountOriginal, String? originalCurrency, String? exchangeRate, String? description, bool isShared, List<SharedUserInfo> sharedWith, String? paymentMethod, String? paymentMethodText, String? location, List<String> tags, String? rawInput, FinancialAccountInfo? financialAccount, AmountDisplay? display, DateTime? createdAt, DateTime? updatedAt, String? photoPath, String? geoLocation, List<TransactionCommentModel> comments, String? sourceAccountId, String? targetAccountId, List<SpaceInfo> spaces, String? sourceThreadId
});


$FinancialAccountInfoCopyWith<$Res>? get financialAccount;$AmountDisplayCopyWith<$Res>? get display;

}
/// @nodoc
class _$TransactionModelCopyWithImpl<$Res>
    implements $TransactionModelCopyWith<$Res> {
  _$TransactionModelCopyWithImpl(this._self, this._then);

  final TransactionModel _self;
  final $Res Function(TransactionModel) _then;

/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? category = null,Object? categoryKey = freezed,Object? categoryText = freezed,Object? iconUrl = null,Object? amount = null,Object? timestamp = null,Object? amountOriginal = freezed,Object? originalCurrency = freezed,Object? exchangeRate = freezed,Object? description = freezed,Object? isShared = null,Object? sharedWith = null,Object? paymentMethod = freezed,Object? paymentMethodText = freezed,Object? location = freezed,Object? tags = null,Object? rawInput = freezed,Object? financialAccount = freezed,Object? display = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? photoPath = freezed,Object? geoLocation = freezed,Object? comments = null,Object? sourceAccountId = freezed,Object? targetAccountId = freezed,Object? spaces = null,Object? sourceThreadId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,categoryKey: freezed == categoryKey ? _self.categoryKey : categoryKey // ignore: cast_nullable_to_non_nullable
as String?,categoryText: freezed == categoryText ? _self.categoryText : categoryText // ignore: cast_nullable_to_non_nullable
as String?,iconUrl: null == iconUrl ? _self.iconUrl : iconUrl // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,amountOriginal: freezed == amountOriginal ? _self.amountOriginal : amountOriginal // ignore: cast_nullable_to_non_nullable
as double?,originalCurrency: freezed == originalCurrency ? _self.originalCurrency : originalCurrency // ignore: cast_nullable_to_non_nullable
as String?,exchangeRate: freezed == exchangeRate ? _self.exchangeRate : exchangeRate // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isShared: null == isShared ? _self.isShared : isShared // ignore: cast_nullable_to_non_nullable
as bool,sharedWith: null == sharedWith ? _self.sharedWith : sharedWith // ignore: cast_nullable_to_non_nullable
as List<SharedUserInfo>,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,paymentMethodText: freezed == paymentMethodText ? _self.paymentMethodText : paymentMethodText // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,rawInput: freezed == rawInput ? _self.rawInput : rawInput // ignore: cast_nullable_to_non_nullable
as String?,financialAccount: freezed == financialAccount ? _self.financialAccount : financialAccount // ignore: cast_nullable_to_non_nullable
as FinancialAccountInfo?,display: freezed == display ? _self.display : display // ignore: cast_nullable_to_non_nullable
as AmountDisplay?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,geoLocation: freezed == geoLocation ? _self.geoLocation : geoLocation // ignore: cast_nullable_to_non_nullable
as String?,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as List<TransactionCommentModel>,sourceAccountId: freezed == sourceAccountId ? _self.sourceAccountId : sourceAccountId // ignore: cast_nullable_to_non_nullable
as String?,targetAccountId: freezed == targetAccountId ? _self.targetAccountId : targetAccountId // ignore: cast_nullable_to_non_nullable
as String?,spaces: null == spaces ? _self.spaces : spaces // ignore: cast_nullable_to_non_nullable
as List<SpaceInfo>,sourceThreadId: freezed == sourceThreadId ? _self.sourceThreadId : sourceThreadId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FinancialAccountInfoCopyWith<$Res>? get financialAccount {
    if (_self.financialAccount == null) {
    return null;
  }

  return $FinancialAccountInfoCopyWith<$Res>(_self.financialAccount!, (value) {
    return _then(_self.copyWith(financialAccount: value));
  });
}/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AmountDisplayCopyWith<$Res>? get display {
    if (_self.display == null) {
    return null;
  }

  return $AmountDisplayCopyWith<$Res>(_self.display!, (value) {
    return _then(_self.copyWith(display: value));
  });
}
}


/// Adds pattern-matching-related methods to [TransactionModel].
extension TransactionModelPatterns on TransactionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionModel value)  $default,){
final _that = this;
switch (_that) {
case _TransactionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionModel value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  TransactionType type,  String category,  String? categoryKey,  String? categoryText,  String iconUrl,  double amount,  DateTime timestamp,  double? amountOriginal,  String? originalCurrency,  String? exchangeRate,  String? description,  bool isShared,  List<SharedUserInfo> sharedWith,  String? paymentMethod,  String? paymentMethodText,  String? location,  List<String> tags,  String? rawInput,  FinancialAccountInfo? financialAccount,  AmountDisplay? display,  DateTime? createdAt,  DateTime? updatedAt,  String? photoPath,  String? geoLocation,  List<TransactionCommentModel> comments,  String? sourceAccountId,  String? targetAccountId,  List<SpaceInfo> spaces,  String? sourceThreadId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
return $default(_that.id,_that.type,_that.category,_that.categoryKey,_that.categoryText,_that.iconUrl,_that.amount,_that.timestamp,_that.amountOriginal,_that.originalCurrency,_that.exchangeRate,_that.description,_that.isShared,_that.sharedWith,_that.paymentMethod,_that.paymentMethodText,_that.location,_that.tags,_that.rawInput,_that.financialAccount,_that.display,_that.createdAt,_that.updatedAt,_that.photoPath,_that.geoLocation,_that.comments,_that.sourceAccountId,_that.targetAccountId,_that.spaces,_that.sourceThreadId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  TransactionType type,  String category,  String? categoryKey,  String? categoryText,  String iconUrl,  double amount,  DateTime timestamp,  double? amountOriginal,  String? originalCurrency,  String? exchangeRate,  String? description,  bool isShared,  List<SharedUserInfo> sharedWith,  String? paymentMethod,  String? paymentMethodText,  String? location,  List<String> tags,  String? rawInput,  FinancialAccountInfo? financialAccount,  AmountDisplay? display,  DateTime? createdAt,  DateTime? updatedAt,  String? photoPath,  String? geoLocation,  List<TransactionCommentModel> comments,  String? sourceAccountId,  String? targetAccountId,  List<SpaceInfo> spaces,  String? sourceThreadId)  $default,) {final _that = this;
switch (_that) {
case _TransactionModel():
return $default(_that.id,_that.type,_that.category,_that.categoryKey,_that.categoryText,_that.iconUrl,_that.amount,_that.timestamp,_that.amountOriginal,_that.originalCurrency,_that.exchangeRate,_that.description,_that.isShared,_that.sharedWith,_that.paymentMethod,_that.paymentMethodText,_that.location,_that.tags,_that.rawInput,_that.financialAccount,_that.display,_that.createdAt,_that.updatedAt,_that.photoPath,_that.geoLocation,_that.comments,_that.sourceAccountId,_that.targetAccountId,_that.spaces,_that.sourceThreadId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  TransactionType type,  String category,  String? categoryKey,  String? categoryText,  String iconUrl,  double amount,  DateTime timestamp,  double? amountOriginal,  String? originalCurrency,  String? exchangeRate,  String? description,  bool isShared,  List<SharedUserInfo> sharedWith,  String? paymentMethod,  String? paymentMethodText,  String? location,  List<String> tags,  String? rawInput,  FinancialAccountInfo? financialAccount,  AmountDisplay? display,  DateTime? createdAt,  DateTime? updatedAt,  String? photoPath,  String? geoLocation,  List<TransactionCommentModel> comments,  String? sourceAccountId,  String? targetAccountId,  List<SpaceInfo> spaces,  String? sourceThreadId)?  $default,) {final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
return $default(_that.id,_that.type,_that.category,_that.categoryKey,_that.categoryText,_that.iconUrl,_that.amount,_that.timestamp,_that.amountOriginal,_that.originalCurrency,_that.exchangeRate,_that.description,_that.isShared,_that.sharedWith,_that.paymentMethod,_that.paymentMethodText,_that.location,_that.tags,_that.rawInput,_that.financialAccount,_that.display,_that.createdAt,_that.updatedAt,_that.photoPath,_that.geoLocation,_that.comments,_that.sourceAccountId,_that.targetAccountId,_that.spaces,_that.sourceThreadId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionModel implements TransactionModel {
  const _TransactionModel({required this.id, required this.type, required this.category, this.categoryKey, this.categoryText, required this.iconUrl, required this.amount, required this.timestamp, this.amountOriginal, this.originalCurrency, this.exchangeRate, this.description, this.isShared = false, final  List<SharedUserInfo> sharedWith = const [], this.paymentMethod, this.paymentMethodText, this.location, final  List<String> tags = const [], this.rawInput, this.financialAccount, this.display, this.createdAt, this.updatedAt, this.photoPath, this.geoLocation, final  List<TransactionCommentModel> comments = const [], this.sourceAccountId, this.targetAccountId, final  List<SpaceInfo> spaces = const [], this.sourceThreadId}): _sharedWith = sharedWith,_tags = tags,_comments = comments,_spaces = spaces;
  factory _TransactionModel.fromJson(Map<String, dynamic> json) => _$TransactionModelFromJson(json);

@override final  String id;
// Unique ID
@override final  TransactionType type;
// Transaction type (expense/income/transfer)
@override final  String category;
// Category (e.g., Dining, Transport, Salary)
@override final  String? categoryKey;
// Category ID
@override final  String? categoryText;
// Server-side localized category name
@override final  String iconUrl;
// Category icon URL (or local path)
@override final  double amount;
// Display amount after conversion
@override final  DateTime timestamp;
// Transaction time
// Original amount information (historical data, immutable)
@override final  double? amountOriginal;
// Original recorded amount
@override final  String? originalCurrency;
// Original recorded currency (e.g., USD, CNY)
@override final  String? exchangeRate;
// Exchange rate snapshot at time of recording
// Other fields
@override final  String? description;
// Note
@override@JsonKey() final  bool isShared;
 final  List<SharedUserInfo> _sharedWith;
@override@JsonKey() List<SharedUserInfo> get sharedWith {
  if (_sharedWith is EqualUnmodifiableListView) return _sharedWith;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sharedWith);
}

@override final  String? paymentMethod;
@override final  String? paymentMethodText;
// Server-side localized payment method name
@override final  String? location;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override final  String? rawInput;
@override final  FinancialAccountInfo? financialAccount;
@override final  AmountDisplay? display;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;
@override final  String? photoPath;
@override final  String? geoLocation;
 final  List<TransactionCommentModel> _comments;
@override@JsonKey() List<TransactionCommentModel> get comments {
  if (_comments is EqualUnmodifiableListView) return _comments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_comments);
}

// Comment list
// Associated account and space information
@override final  String? sourceAccountId;
// Source account ID
@override final  String? targetAccountId;
// Target account ID
 final  List<SpaceInfo> _spaces;
// Target account ID
@override@JsonKey() List<SpaceInfo> get spaces {
  if (_spaces is EqualUnmodifiableListView) return _spaces;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_spaces);
}

// Associated shared spaces
@override final  String? sourceThreadId;

/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionModelCopyWith<_TransactionModel> get copyWith => __$TransactionModelCopyWithImpl<_TransactionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.category, category) || other.category == category)&&(identical(other.categoryKey, categoryKey) || other.categoryKey == categoryKey)&&(identical(other.categoryText, categoryText) || other.categoryText == categoryText)&&(identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.amountOriginal, amountOriginal) || other.amountOriginal == amountOriginal)&&(identical(other.originalCurrency, originalCurrency) || other.originalCurrency == originalCurrency)&&(identical(other.exchangeRate, exchangeRate) || other.exchangeRate == exchangeRate)&&(identical(other.description, description) || other.description == description)&&(identical(other.isShared, isShared) || other.isShared == isShared)&&const DeepCollectionEquality().equals(other._sharedWith, _sharedWith)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.paymentMethodText, paymentMethodText) || other.paymentMethodText == paymentMethodText)&&(identical(other.location, location) || other.location == location)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.rawInput, rawInput) || other.rawInput == rawInput)&&(identical(other.financialAccount, financialAccount) || other.financialAccount == financialAccount)&&(identical(other.display, display) || other.display == display)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.geoLocation, geoLocation) || other.geoLocation == geoLocation)&&const DeepCollectionEquality().equals(other._comments, _comments)&&(identical(other.sourceAccountId, sourceAccountId) || other.sourceAccountId == sourceAccountId)&&(identical(other.targetAccountId, targetAccountId) || other.targetAccountId == targetAccountId)&&const DeepCollectionEquality().equals(other._spaces, _spaces)&&(identical(other.sourceThreadId, sourceThreadId) || other.sourceThreadId == sourceThreadId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,type,category,categoryKey,categoryText,iconUrl,amount,timestamp,amountOriginal,originalCurrency,exchangeRate,description,isShared,const DeepCollectionEquality().hash(_sharedWith),paymentMethod,paymentMethodText,location,const DeepCollectionEquality().hash(_tags),rawInput,financialAccount,display,createdAt,updatedAt,photoPath,geoLocation,const DeepCollectionEquality().hash(_comments),sourceAccountId,targetAccountId,const DeepCollectionEquality().hash(_spaces),sourceThreadId]);

@override
String toString() {
  return 'TransactionModel(id: $id, type: $type, category: $category, categoryKey: $categoryKey, categoryText: $categoryText, iconUrl: $iconUrl, amount: $amount, timestamp: $timestamp, amountOriginal: $amountOriginal, originalCurrency: $originalCurrency, exchangeRate: $exchangeRate, description: $description, isShared: $isShared, sharedWith: $sharedWith, paymentMethod: $paymentMethod, paymentMethodText: $paymentMethodText, location: $location, tags: $tags, rawInput: $rawInput, financialAccount: $financialAccount, display: $display, createdAt: $createdAt, updatedAt: $updatedAt, photoPath: $photoPath, geoLocation: $geoLocation, comments: $comments, sourceAccountId: $sourceAccountId, targetAccountId: $targetAccountId, spaces: $spaces, sourceThreadId: $sourceThreadId)';
}


}

/// @nodoc
abstract mixin class _$TransactionModelCopyWith<$Res> implements $TransactionModelCopyWith<$Res> {
  factory _$TransactionModelCopyWith(_TransactionModel value, $Res Function(_TransactionModel) _then) = __$TransactionModelCopyWithImpl;
@override @useResult
$Res call({
 String id, TransactionType type, String category, String? categoryKey, String? categoryText, String iconUrl, double amount, DateTime timestamp, double? amountOriginal, String? originalCurrency, String? exchangeRate, String? description, bool isShared, List<SharedUserInfo> sharedWith, String? paymentMethod, String? paymentMethodText, String? location, List<String> tags, String? rawInput, FinancialAccountInfo? financialAccount, AmountDisplay? display, DateTime? createdAt, DateTime? updatedAt, String? photoPath, String? geoLocation, List<TransactionCommentModel> comments, String? sourceAccountId, String? targetAccountId, List<SpaceInfo> spaces, String? sourceThreadId
});


@override $FinancialAccountInfoCopyWith<$Res>? get financialAccount;@override $AmountDisplayCopyWith<$Res>? get display;

}
/// @nodoc
class __$TransactionModelCopyWithImpl<$Res>
    implements _$TransactionModelCopyWith<$Res> {
  __$TransactionModelCopyWithImpl(this._self, this._then);

  final _TransactionModel _self;
  final $Res Function(_TransactionModel) _then;

/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? category = null,Object? categoryKey = freezed,Object? categoryText = freezed,Object? iconUrl = null,Object? amount = null,Object? timestamp = null,Object? amountOriginal = freezed,Object? originalCurrency = freezed,Object? exchangeRate = freezed,Object? description = freezed,Object? isShared = null,Object? sharedWith = null,Object? paymentMethod = freezed,Object? paymentMethodText = freezed,Object? location = freezed,Object? tags = null,Object? rawInput = freezed,Object? financialAccount = freezed,Object? display = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? photoPath = freezed,Object? geoLocation = freezed,Object? comments = null,Object? sourceAccountId = freezed,Object? targetAccountId = freezed,Object? spaces = null,Object? sourceThreadId = freezed,}) {
  return _then(_TransactionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,categoryKey: freezed == categoryKey ? _self.categoryKey : categoryKey // ignore: cast_nullable_to_non_nullable
as String?,categoryText: freezed == categoryText ? _self.categoryText : categoryText // ignore: cast_nullable_to_non_nullable
as String?,iconUrl: null == iconUrl ? _self.iconUrl : iconUrl // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,amountOriginal: freezed == amountOriginal ? _self.amountOriginal : amountOriginal // ignore: cast_nullable_to_non_nullable
as double?,originalCurrency: freezed == originalCurrency ? _self.originalCurrency : originalCurrency // ignore: cast_nullable_to_non_nullable
as String?,exchangeRate: freezed == exchangeRate ? _self.exchangeRate : exchangeRate // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isShared: null == isShared ? _self.isShared : isShared // ignore: cast_nullable_to_non_nullable
as bool,sharedWith: null == sharedWith ? _self._sharedWith : sharedWith // ignore: cast_nullable_to_non_nullable
as List<SharedUserInfo>,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,paymentMethodText: freezed == paymentMethodText ? _self.paymentMethodText : paymentMethodText // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,rawInput: freezed == rawInput ? _self.rawInput : rawInput // ignore: cast_nullable_to_non_nullable
as String?,financialAccount: freezed == financialAccount ? _self.financialAccount : financialAccount // ignore: cast_nullable_to_non_nullable
as FinancialAccountInfo?,display: freezed == display ? _self.display : display // ignore: cast_nullable_to_non_nullable
as AmountDisplay?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,geoLocation: freezed == geoLocation ? _self.geoLocation : geoLocation // ignore: cast_nullable_to_non_nullable
as String?,comments: null == comments ? _self._comments : comments // ignore: cast_nullable_to_non_nullable
as List<TransactionCommentModel>,sourceAccountId: freezed == sourceAccountId ? _self.sourceAccountId : sourceAccountId // ignore: cast_nullable_to_non_nullable
as String?,targetAccountId: freezed == targetAccountId ? _self.targetAccountId : targetAccountId // ignore: cast_nullable_to_non_nullable
as String?,spaces: null == spaces ? _self._spaces : spaces // ignore: cast_nullable_to_non_nullable
as List<SpaceInfo>,sourceThreadId: freezed == sourceThreadId ? _self.sourceThreadId : sourceThreadId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FinancialAccountInfoCopyWith<$Res>? get financialAccount {
    if (_self.financialAccount == null) {
    return null;
  }

  return $FinancialAccountInfoCopyWith<$Res>(_self.financialAccount!, (value) {
    return _then(_self.copyWith(financialAccount: value));
  });
}/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AmountDisplayCopyWith<$Res>? get display {
    if (_self.display == null) {
    return null;
  }

  return $AmountDisplayCopyWith<$Res>(_self.display!, (value) {
    return _then(_self.copyWith(display: value));
  });
}
}

// dart format on
