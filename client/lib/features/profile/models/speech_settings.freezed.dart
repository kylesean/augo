// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'speech_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SpeechSettings {

/// Speech recognition service type
 SpeechServiceType get serviceType;/// WebSocket server host (Only used for websocket type)
 String? get websocketHost;/// WebSocket server port (Only used for websocket type)
 int? get websocketPort;/// WebSocket path (Only used for websocket type)
 String? get websocketPath;/// Speech recognition language (Only valid for system type)
 String get localeId;
/// Create a copy of SpeechSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpeechSettingsCopyWith<SpeechSettings> get copyWith => _$SpeechSettingsCopyWithImpl<SpeechSettings>(this as SpeechSettings, _$identity);

  /// Serializes this SpeechSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpeechSettings&&(identical(other.serviceType, serviceType) || other.serviceType == serviceType)&&(identical(other.websocketHost, websocketHost) || other.websocketHost == websocketHost)&&(identical(other.websocketPort, websocketPort) || other.websocketPort == websocketPort)&&(identical(other.websocketPath, websocketPath) || other.websocketPath == websocketPath)&&(identical(other.localeId, localeId) || other.localeId == localeId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,serviceType,websocketHost,websocketPort,websocketPath,localeId);

@override
String toString() {
  return 'SpeechSettings(serviceType: $serviceType, websocketHost: $websocketHost, websocketPort: $websocketPort, websocketPath: $websocketPath, localeId: $localeId)';
}


}

/// @nodoc
abstract mixin class $SpeechSettingsCopyWith<$Res>  {
  factory $SpeechSettingsCopyWith(SpeechSettings value, $Res Function(SpeechSettings) _then) = _$SpeechSettingsCopyWithImpl;
@useResult
$Res call({
 SpeechServiceType serviceType, String? websocketHost, int? websocketPort, String? websocketPath, String localeId
});




}
/// @nodoc
class _$SpeechSettingsCopyWithImpl<$Res>
    implements $SpeechSettingsCopyWith<$Res> {
  _$SpeechSettingsCopyWithImpl(this._self, this._then);

  final SpeechSettings _self;
  final $Res Function(SpeechSettings) _then;

/// Create a copy of SpeechSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? serviceType = null,Object? websocketHost = freezed,Object? websocketPort = freezed,Object? websocketPath = freezed,Object? localeId = null,}) {
  return _then(_self.copyWith(
serviceType: null == serviceType ? _self.serviceType : serviceType // ignore: cast_nullable_to_non_nullable
as SpeechServiceType,websocketHost: freezed == websocketHost ? _self.websocketHost : websocketHost // ignore: cast_nullable_to_non_nullable
as String?,websocketPort: freezed == websocketPort ? _self.websocketPort : websocketPort // ignore: cast_nullable_to_non_nullable
as int?,websocketPath: freezed == websocketPath ? _self.websocketPath : websocketPath // ignore: cast_nullable_to_non_nullable
as String?,localeId: null == localeId ? _self.localeId : localeId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SpeechSettings].
extension SpeechSettingsPatterns on SpeechSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpeechSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpeechSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpeechSettings value)  $default,){
final _that = this;
switch (_that) {
case _SpeechSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpeechSettings value)?  $default,){
final _that = this;
switch (_that) {
case _SpeechSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SpeechServiceType serviceType,  String? websocketHost,  int? websocketPort,  String? websocketPath,  String localeId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpeechSettings() when $default != null:
return $default(_that.serviceType,_that.websocketHost,_that.websocketPort,_that.websocketPath,_that.localeId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SpeechServiceType serviceType,  String? websocketHost,  int? websocketPort,  String? websocketPath,  String localeId)  $default,) {final _that = this;
switch (_that) {
case _SpeechSettings():
return $default(_that.serviceType,_that.websocketHost,_that.websocketPort,_that.websocketPath,_that.localeId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SpeechServiceType serviceType,  String? websocketHost,  int? websocketPort,  String? websocketPath,  String localeId)?  $default,) {final _that = this;
switch (_that) {
case _SpeechSettings() when $default != null:
return $default(_that.serviceType,_that.websocketHost,_that.websocketPort,_that.websocketPath,_that.localeId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SpeechSettings implements SpeechSettings {
  const _SpeechSettings({this.serviceType = SpeechServiceType.system, this.websocketHost, this.websocketPort, this.websocketPath, this.localeId = 'zh_CN'});
  factory _SpeechSettings.fromJson(Map<String, dynamic> json) => _$SpeechSettingsFromJson(json);

/// Speech recognition service type
@override@JsonKey() final  SpeechServiceType serviceType;
/// WebSocket server host (Only used for websocket type)
@override final  String? websocketHost;
/// WebSocket server port (Only used for websocket type)
@override final  int? websocketPort;
/// WebSocket path (Only used for websocket type)
@override final  String? websocketPath;
/// Speech recognition language (Only valid for system type)
@override@JsonKey() final  String localeId;

/// Create a copy of SpeechSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpeechSettingsCopyWith<_SpeechSettings> get copyWith => __$SpeechSettingsCopyWithImpl<_SpeechSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SpeechSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpeechSettings&&(identical(other.serviceType, serviceType) || other.serviceType == serviceType)&&(identical(other.websocketHost, websocketHost) || other.websocketHost == websocketHost)&&(identical(other.websocketPort, websocketPort) || other.websocketPort == websocketPort)&&(identical(other.websocketPath, websocketPath) || other.websocketPath == websocketPath)&&(identical(other.localeId, localeId) || other.localeId == localeId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,serviceType,websocketHost,websocketPort,websocketPath,localeId);

@override
String toString() {
  return 'SpeechSettings(serviceType: $serviceType, websocketHost: $websocketHost, websocketPort: $websocketPort, websocketPath: $websocketPath, localeId: $localeId)';
}


}

/// @nodoc
abstract mixin class _$SpeechSettingsCopyWith<$Res> implements $SpeechSettingsCopyWith<$Res> {
  factory _$SpeechSettingsCopyWith(_SpeechSettings value, $Res Function(_SpeechSettings) _then) = __$SpeechSettingsCopyWithImpl;
@override @useResult
$Res call({
 SpeechServiceType serviceType, String? websocketHost, int? websocketPort, String? websocketPath, String localeId
});




}
/// @nodoc
class __$SpeechSettingsCopyWithImpl<$Res>
    implements _$SpeechSettingsCopyWith<$Res> {
  __$SpeechSettingsCopyWithImpl(this._self, this._then);

  final _SpeechSettings _self;
  final $Res Function(_SpeechSettings) _then;

/// Create a copy of SpeechSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? serviceType = null,Object? websocketHost = freezed,Object? websocketPort = freezed,Object? websocketPath = freezed,Object? localeId = null,}) {
  return _then(_SpeechSettings(
serviceType: null == serviceType ? _self.serviceType : serviceType // ignore: cast_nullable_to_non_nullable
as SpeechServiceType,websocketHost: freezed == websocketHost ? _self.websocketHost : websocketHost // ignore: cast_nullable_to_non_nullable
as String?,websocketPort: freezed == websocketPort ? _self.websocketPort : websocketPort // ignore: cast_nullable_to_non_nullable
as int?,websocketPath: freezed == websocketPath ? _self.websocketPath : websocketPath // ignore: cast_nullable_to_non_nullable
as String?,localeId: null == localeId ? _self.localeId : localeId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$SpeechSettingsState {

 bool get isLoading; bool get isSaving; SpeechSettings? get settings; String? get errorMessage;
/// Create a copy of SpeechSettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpeechSettingsStateCopyWith<SpeechSettingsState> get copyWith => _$SpeechSettingsStateCopyWithImpl<SpeechSettingsState>(this as SpeechSettingsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpeechSettingsState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.settings, settings) || other.settings == settings)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,isSaving,settings,errorMessage);

@override
String toString() {
  return 'SpeechSettingsState(isLoading: $isLoading, isSaving: $isSaving, settings: $settings, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $SpeechSettingsStateCopyWith<$Res>  {
  factory $SpeechSettingsStateCopyWith(SpeechSettingsState value, $Res Function(SpeechSettingsState) _then) = _$SpeechSettingsStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool isSaving, SpeechSettings? settings, String? errorMessage
});


$SpeechSettingsCopyWith<$Res>? get settings;

}
/// @nodoc
class _$SpeechSettingsStateCopyWithImpl<$Res>
    implements $SpeechSettingsStateCopyWith<$Res> {
  _$SpeechSettingsStateCopyWithImpl(this._self, this._then);

  final SpeechSettingsState _self;
  final $Res Function(SpeechSettingsState) _then;

/// Create a copy of SpeechSettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? isSaving = null,Object? settings = freezed,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,settings: freezed == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as SpeechSettings?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of SpeechSettingsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SpeechSettingsCopyWith<$Res>? get settings {
    if (_self.settings == null) {
    return null;
  }

  return $SpeechSettingsCopyWith<$Res>(_self.settings!, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}


/// Adds pattern-matching-related methods to [SpeechSettingsState].
extension SpeechSettingsStatePatterns on SpeechSettingsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpeechSettingsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpeechSettingsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpeechSettingsState value)  $default,){
final _that = this;
switch (_that) {
case _SpeechSettingsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpeechSettingsState value)?  $default,){
final _that = this;
switch (_that) {
case _SpeechSettingsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool isSaving,  SpeechSettings? settings,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpeechSettingsState() when $default != null:
return $default(_that.isLoading,_that.isSaving,_that.settings,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool isSaving,  SpeechSettings? settings,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _SpeechSettingsState():
return $default(_that.isLoading,_that.isSaving,_that.settings,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool isSaving,  SpeechSettings? settings,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _SpeechSettingsState() when $default != null:
return $default(_that.isLoading,_that.isSaving,_that.settings,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _SpeechSettingsState implements SpeechSettingsState {
  const _SpeechSettingsState({this.isLoading = false, this.isSaving = false, this.settings = null, this.errorMessage = null});


@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isSaving;
@override@JsonKey() final  SpeechSettings? settings;
@override@JsonKey() final  String? errorMessage;

/// Create a copy of SpeechSettingsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpeechSettingsStateCopyWith<_SpeechSettingsState> get copyWith => __$SpeechSettingsStateCopyWithImpl<_SpeechSettingsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpeechSettingsState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.settings, settings) || other.settings == settings)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,isSaving,settings,errorMessage);

@override
String toString() {
  return 'SpeechSettingsState(isLoading: $isLoading, isSaving: $isSaving, settings: $settings, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$SpeechSettingsStateCopyWith<$Res> implements $SpeechSettingsStateCopyWith<$Res> {
  factory _$SpeechSettingsStateCopyWith(_SpeechSettingsState value, $Res Function(_SpeechSettingsState) _then) = __$SpeechSettingsStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool isSaving, SpeechSettings? settings, String? errorMessage
});


@override $SpeechSettingsCopyWith<$Res>? get settings;

}
/// @nodoc
class __$SpeechSettingsStateCopyWithImpl<$Res>
    implements _$SpeechSettingsStateCopyWith<$Res> {
  __$SpeechSettingsStateCopyWithImpl(this._self, this._then);

  final _SpeechSettingsState _self;
  final $Res Function(_SpeechSettingsState) _then;

/// Create a copy of SpeechSettingsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? isSaving = null,Object? settings = freezed,Object? errorMessage = freezed,}) {
  return _then(_SpeechSettingsState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,settings: freezed == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as SpeechSettings?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of SpeechSettingsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SpeechSettingsCopyWith<$Res>? get settings {
    if (_self.settings == null) {
    return null;
  }

  return $SpeechSettingsCopyWith<$Res>(_self.settings!, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}

// dart format on
