// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'server_config_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ServerConfigState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerConfigState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ServerConfigState()';
}


}

/// @nodoc
class $ServerConfigStateCopyWith<$Res>  {
$ServerConfigStateCopyWith(ServerConfigState _, $Res Function(ServerConfigState) __);
}


/// Adds pattern-matching-related methods to [ServerConfigState].
extension ServerConfigStatePatterns on ServerConfigState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _NotConfigured value)?  notConfigured,TResult Function( _Checking value)?  checking,TResult Function( _Configured value)?  configured,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _NotConfigured() when notConfigured != null:
return notConfigured(_that);case _Checking() when checking != null:
return checking(_that);case _Configured() when configured != null:
return configured(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _NotConfigured value)  notConfigured,required TResult Function( _Checking value)  checking,required TResult Function( _Configured value)  configured,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _NotConfigured():
return notConfigured(_that);case _Checking():
return checking(_that);case _Configured():
return configured(_that);case _Error():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _NotConfigured value)?  notConfigured,TResult? Function( _Checking value)?  checking,TResult? Function( _Configured value)?  configured,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _NotConfigured() when notConfigured != null:
return notConfigured(_that);case _Checking() when checking != null:
return checking(_that);case _Configured() when configured != null:
return configured(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function()?  notConfigured,TResult Function()?  checking,TResult Function( String serverUrl,  String? version,  String? environment)?  configured,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _NotConfigured() when notConfigured != null:
return notConfigured();case _Checking() when checking != null:
return checking();case _Configured() when configured != null:
return configured(_that.serverUrl,_that.version,_that.environment);case _Error() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function()  notConfigured,required TResult Function()  checking,required TResult Function( String serverUrl,  String? version,  String? environment)  configured,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _NotConfigured():
return notConfigured();case _Checking():
return checking();case _Configured():
return configured(_that.serverUrl,_that.version,_that.environment);case _Error():
return error(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function()?  notConfigured,TResult? Function()?  checking,TResult? Function( String serverUrl,  String? version,  String? environment)?  configured,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _NotConfigured() when notConfigured != null:
return notConfigured();case _Checking() when checking != null:
return checking();case _Configured() when configured != null:
return configured(_that.serverUrl,_that.version,_that.environment);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements ServerConfigState {
  const _Initial();







@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ServerConfigState.initial()';
}


}




/// @nodoc


class _Loading implements ServerConfigState {
  const _Loading();







@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ServerConfigState.loading()';
}


}




/// @nodoc


class _NotConfigured implements ServerConfigState {
  const _NotConfigured();







@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotConfigured);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ServerConfigState.notConfigured()';
}


}




/// @nodoc


class _Checking implements ServerConfigState {
  const _Checking();







@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Checking);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ServerConfigState.checking()';
}


}




/// @nodoc


class _Configured implements ServerConfigState {
  const _Configured({required this.serverUrl, this.version, this.environment});


 final  String serverUrl;
 final  String? version;
 final  String? environment;

/// Create a copy of ServerConfigState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConfiguredCopyWith<_Configured> get copyWith => __$ConfiguredCopyWithImpl<_Configured>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Configured&&(identical(other.serverUrl, serverUrl) || other.serverUrl == serverUrl)&&(identical(other.version, version) || other.version == version)&&(identical(other.environment, environment) || other.environment == environment));
}


@override
int get hashCode => Object.hash(runtimeType,serverUrl,version,environment);

@override
String toString() {
  return 'ServerConfigState.configured(serverUrl: $serverUrl, version: $version, environment: $environment)';
}


}

/// @nodoc
abstract mixin class _$ConfiguredCopyWith<$Res> implements $ServerConfigStateCopyWith<$Res> {
  factory _$ConfiguredCopyWith(_Configured value, $Res Function(_Configured) _then) = __$ConfiguredCopyWithImpl;
@useResult
$Res call({
 String serverUrl, String? version, String? environment
});




}
/// @nodoc
class __$ConfiguredCopyWithImpl<$Res>
    implements _$ConfiguredCopyWith<$Res> {
  __$ConfiguredCopyWithImpl(this._self, this._then);

  final _Configured _self;
  final $Res Function(_Configured) _then;

/// Create a copy of ServerConfigState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? serverUrl = null,Object? version = freezed,Object? environment = freezed,}) {
  return _then(_Configured(
serverUrl: null == serverUrl ? _self.serverUrl : serverUrl // ignore: cast_nullable_to_non_nullable
as String,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,environment: freezed == environment ? _self.environment : environment // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _Error implements ServerConfigState {
  const _Error(this.message);


 final  String message;

/// Create a copy of ServerConfigState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ServerConfigState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $ServerConfigStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of ServerConfigState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
