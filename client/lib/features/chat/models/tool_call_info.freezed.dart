// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tool_call_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ToolCallInfo {

 String get id; String get name; Map<String, dynamic> get args;/// Execution status (pending -> running -> success/error)
 ToolExecutionStatus get status;/// Execution duration in milliseconds
@JsonKey(name: 'duration_ms') int? get durationMs;/// Truncated result preview (max 200 chars)
@JsonKey(name: 'result') String? get resultPreview;/// Error message if status is error
 String? get error;/// Timestamp when tool started
 String? get timestamp;
/// Create a copy of ToolCallInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ToolCallInfoCopyWith<ToolCallInfo> get copyWith => _$ToolCallInfoCopyWithImpl<ToolCallInfo>(this as ToolCallInfo, _$identity);

  /// Serializes this ToolCallInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ToolCallInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.args, args)&&(identical(other.status, status) || other.status == status)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.resultPreview, resultPreview) || other.resultPreview == resultPreview)&&(identical(other.error, error) || other.error == error)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(args),status,durationMs,resultPreview,error,timestamp);

@override
String toString() {
  return 'ToolCallInfo(id: $id, name: $name, args: $args, status: $status, durationMs: $durationMs, resultPreview: $resultPreview, error: $error, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $ToolCallInfoCopyWith<$Res>  {
  factory $ToolCallInfoCopyWith(ToolCallInfo value, $Res Function(ToolCallInfo) _then) = _$ToolCallInfoCopyWithImpl;
@useResult
$Res call({
 String id, String name, Map<String, dynamic> args, ToolExecutionStatus status,@JsonKey(name: 'duration_ms') int? durationMs,@JsonKey(name: 'result') String? resultPreview, String? error, String? timestamp
});




}
/// @nodoc
class _$ToolCallInfoCopyWithImpl<$Res>
    implements $ToolCallInfoCopyWith<$Res> {
  _$ToolCallInfoCopyWithImpl(this._self, this._then);

  final ToolCallInfo _self;
  final $Res Function(ToolCallInfo) _then;

/// Create a copy of ToolCallInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? args = null,Object? status = null,Object? durationMs = freezed,Object? resultPreview = freezed,Object? error = freezed,Object? timestamp = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,args: null == args ? _self.args : args // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ToolExecutionStatus,durationMs: freezed == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int?,resultPreview: freezed == resultPreview ? _self.resultPreview : resultPreview // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ToolCallInfo].
extension ToolCallInfoPatterns on ToolCallInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ToolCallInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ToolCallInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ToolCallInfo value)  $default,){
final _that = this;
switch (_that) {
case _ToolCallInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ToolCallInfo value)?  $default,){
final _that = this;
switch (_that) {
case _ToolCallInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  Map<String, dynamic> args,  ToolExecutionStatus status, @JsonKey(name: 'duration_ms')  int? durationMs, @JsonKey(name: 'result')  String? resultPreview,  String? error,  String? timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ToolCallInfo() when $default != null:
return $default(_that.id,_that.name,_that.args,_that.status,_that.durationMs,_that.resultPreview,_that.error,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  Map<String, dynamic> args,  ToolExecutionStatus status, @JsonKey(name: 'duration_ms')  int? durationMs, @JsonKey(name: 'result')  String? resultPreview,  String? error,  String? timestamp)  $default,) {final _that = this;
switch (_that) {
case _ToolCallInfo():
return $default(_that.id,_that.name,_that.args,_that.status,_that.durationMs,_that.resultPreview,_that.error,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  Map<String, dynamic> args,  ToolExecutionStatus status, @JsonKey(name: 'duration_ms')  int? durationMs, @JsonKey(name: 'result')  String? resultPreview,  String? error,  String? timestamp)?  $default,) {final _that = this;
switch (_that) {
case _ToolCallInfo() when $default != null:
return $default(_that.id,_that.name,_that.args,_that.status,_that.durationMs,_that.resultPreview,_that.error,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ToolCallInfo implements ToolCallInfo {
  const _ToolCallInfo({required this.id, required this.name, final  Map<String, dynamic> args = const {}, this.status = ToolExecutionStatus.pending, @JsonKey(name: 'duration_ms') this.durationMs, @JsonKey(name: 'result') this.resultPreview, this.error, this.timestamp}): _args = args;
  factory _ToolCallInfo.fromJson(Map<String, dynamic> json) => _$ToolCallInfoFromJson(json);

@override final  String id;
@override final  String name;
 final  Map<String, dynamic> _args;
@override@JsonKey() Map<String, dynamic> get args {
  if (_args is EqualUnmodifiableMapView) return _args;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_args);
}

/// Execution status (pending -> running -> success/error)
@override@JsonKey() final  ToolExecutionStatus status;
/// Execution duration in milliseconds
@override@JsonKey(name: 'duration_ms') final  int? durationMs;
/// Truncated result preview (max 200 chars)
@override@JsonKey(name: 'result') final  String? resultPreview;
/// Error message if status is error
@override final  String? error;
/// Timestamp when tool started
@override final  String? timestamp;

/// Create a copy of ToolCallInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ToolCallInfoCopyWith<_ToolCallInfo> get copyWith => __$ToolCallInfoCopyWithImpl<_ToolCallInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ToolCallInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ToolCallInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._args, _args)&&(identical(other.status, status) || other.status == status)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.resultPreview, resultPreview) || other.resultPreview == resultPreview)&&(identical(other.error, error) || other.error == error)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_args),status,durationMs,resultPreview,error,timestamp);

@override
String toString() {
  return 'ToolCallInfo(id: $id, name: $name, args: $args, status: $status, durationMs: $durationMs, resultPreview: $resultPreview, error: $error, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$ToolCallInfoCopyWith<$Res> implements $ToolCallInfoCopyWith<$Res> {
  factory _$ToolCallInfoCopyWith(_ToolCallInfo value, $Res Function(_ToolCallInfo) _then) = __$ToolCallInfoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, Map<String, dynamic> args, ToolExecutionStatus status,@JsonKey(name: 'duration_ms') int? durationMs,@JsonKey(name: 'result') String? resultPreview, String? error, String? timestamp
});




}
/// @nodoc
class __$ToolCallInfoCopyWithImpl<$Res>
    implements _$ToolCallInfoCopyWith<$Res> {
  __$ToolCallInfoCopyWithImpl(this._self, this._then);

  final _ToolCallInfo _self;
  final $Res Function(_ToolCallInfo) _then;

/// Create a copy of ToolCallInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? args = null,Object? status = null,Object? durationMs = freezed,Object? resultPreview = freezed,Object? error = freezed,Object? timestamp = freezed,}) {
  return _then(_ToolCallInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,args: null == args ? _self._args : args // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ToolExecutionStatus,durationMs: freezed == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int?,resultPreview: freezed == resultPreview ? _self.resultPreview : resultPreview // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$UIComponentInfo {

@JsonKey(name: 'surfaceId') String get surfaceId;@JsonKey(name: 'componentType') String get componentType; Map<String, dynamic> get data;/// Rendering mode: live (interactive), historical (read-only)
@JsonKey(name: 'mode') UIComponentMode get mode;/// User's selection (for showing what user chose in historical mode)
@JsonKey(name: 'userSelection') Map<String, dynamic>? get userSelection;/// Tool call context
@JsonKey(name: 'toolCallId') String? get toolCallId;@JsonKey(name: 'toolName') String? get toolName;
/// Create a copy of UIComponentInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UIComponentInfoCopyWith<UIComponentInfo> get copyWith => _$UIComponentInfoCopyWithImpl<UIComponentInfo>(this as UIComponentInfo, _$identity);

  /// Serializes this UIComponentInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UIComponentInfo&&(identical(other.surfaceId, surfaceId) || other.surfaceId == surfaceId)&&(identical(other.componentType, componentType) || other.componentType == componentType)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.mode, mode) || other.mode == mode)&&const DeepCollectionEquality().equals(other.userSelection, userSelection)&&(identical(other.toolCallId, toolCallId) || other.toolCallId == toolCallId)&&(identical(other.toolName, toolName) || other.toolName == toolName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,surfaceId,componentType,const DeepCollectionEquality().hash(data),mode,const DeepCollectionEquality().hash(userSelection),toolCallId,toolName);

@override
String toString() {
  return 'UIComponentInfo(surfaceId: $surfaceId, componentType: $componentType, data: $data, mode: $mode, userSelection: $userSelection, toolCallId: $toolCallId, toolName: $toolName)';
}


}

/// @nodoc
abstract mixin class $UIComponentInfoCopyWith<$Res>  {
  factory $UIComponentInfoCopyWith(UIComponentInfo value, $Res Function(UIComponentInfo) _then) = _$UIComponentInfoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'surfaceId') String surfaceId,@JsonKey(name: 'componentType') String componentType, Map<String, dynamic> data,@JsonKey(name: 'mode') UIComponentMode mode,@JsonKey(name: 'userSelection') Map<String, dynamic>? userSelection,@JsonKey(name: 'toolCallId') String? toolCallId,@JsonKey(name: 'toolName') String? toolName
});




}
/// @nodoc
class _$UIComponentInfoCopyWithImpl<$Res>
    implements $UIComponentInfoCopyWith<$Res> {
  _$UIComponentInfoCopyWithImpl(this._self, this._then);

  final UIComponentInfo _self;
  final $Res Function(UIComponentInfo) _then;

/// Create a copy of UIComponentInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? surfaceId = null,Object? componentType = null,Object? data = null,Object? mode = null,Object? userSelection = freezed,Object? toolCallId = freezed,Object? toolName = freezed,}) {
  return _then(_self.copyWith(
surfaceId: null == surfaceId ? _self.surfaceId : surfaceId // ignore: cast_nullable_to_non_nullable
as String,componentType: null == componentType ? _self.componentType : componentType // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as UIComponentMode,userSelection: freezed == userSelection ? _self.userSelection : userSelection // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,toolCallId: freezed == toolCallId ? _self.toolCallId : toolCallId // ignore: cast_nullable_to_non_nullable
as String?,toolName: freezed == toolName ? _self.toolName : toolName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UIComponentInfo].
extension UIComponentInfoPatterns on UIComponentInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UIComponentInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UIComponentInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UIComponentInfo value)  $default,){
final _that = this;
switch (_that) {
case _UIComponentInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UIComponentInfo value)?  $default,){
final _that = this;
switch (_that) {
case _UIComponentInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'surfaceId')  String surfaceId, @JsonKey(name: 'componentType')  String componentType,  Map<String, dynamic> data, @JsonKey(name: 'mode')  UIComponentMode mode, @JsonKey(name: 'userSelection')  Map<String, dynamic>? userSelection, @JsonKey(name: 'toolCallId')  String? toolCallId, @JsonKey(name: 'toolName')  String? toolName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UIComponentInfo() when $default != null:
return $default(_that.surfaceId,_that.componentType,_that.data,_that.mode,_that.userSelection,_that.toolCallId,_that.toolName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'surfaceId')  String surfaceId, @JsonKey(name: 'componentType')  String componentType,  Map<String, dynamic> data, @JsonKey(name: 'mode')  UIComponentMode mode, @JsonKey(name: 'userSelection')  Map<String, dynamic>? userSelection, @JsonKey(name: 'toolCallId')  String? toolCallId, @JsonKey(name: 'toolName')  String? toolName)  $default,) {final _that = this;
switch (_that) {
case _UIComponentInfo():
return $default(_that.surfaceId,_that.componentType,_that.data,_that.mode,_that.userSelection,_that.toolCallId,_that.toolName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'surfaceId')  String surfaceId, @JsonKey(name: 'componentType')  String componentType,  Map<String, dynamic> data, @JsonKey(name: 'mode')  UIComponentMode mode, @JsonKey(name: 'userSelection')  Map<String, dynamic>? userSelection, @JsonKey(name: 'toolCallId')  String? toolCallId, @JsonKey(name: 'toolName')  String? toolName)?  $default,) {final _that = this;
switch (_that) {
case _UIComponentInfo() when $default != null:
return $default(_that.surfaceId,_that.componentType,_that.data,_that.mode,_that.userSelection,_that.toolCallId,_that.toolName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UIComponentInfo implements UIComponentInfo {
  const _UIComponentInfo({@JsonKey(name: 'surfaceId') required this.surfaceId, @JsonKey(name: 'componentType') required this.componentType, final  Map<String, dynamic> data = const {}, @JsonKey(name: 'mode') this.mode = UIComponentMode.historical, @JsonKey(name: 'userSelection') final  Map<String, dynamic>? userSelection, @JsonKey(name: 'toolCallId') this.toolCallId, @JsonKey(name: 'toolName') this.toolName}): _data = data,_userSelection = userSelection;
  factory _UIComponentInfo.fromJson(Map<String, dynamic> json) => _$UIComponentInfoFromJson(json);

@override@JsonKey(name: 'surfaceId') final  String surfaceId;
@override@JsonKey(name: 'componentType') final  String componentType;
 final  Map<String, dynamic> _data;
@override@JsonKey() Map<String, dynamic> get data {
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_data);
}

/// Rendering mode: live (interactive), historical (read-only)
@override@JsonKey(name: 'mode') final  UIComponentMode mode;
/// User's selection (for showing what user chose in historical mode)
 final  Map<String, dynamic>? _userSelection;
/// User's selection (for showing what user chose in historical mode)
@override@JsonKey(name: 'userSelection') Map<String, dynamic>? get userSelection {
  final value = _userSelection;
  if (value == null) return null;
  if (_userSelection is EqualUnmodifiableMapView) return _userSelection;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

/// Tool call context
@override@JsonKey(name: 'toolCallId') final  String? toolCallId;
@override@JsonKey(name: 'toolName') final  String? toolName;

/// Create a copy of UIComponentInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UIComponentInfoCopyWith<_UIComponentInfo> get copyWith => __$UIComponentInfoCopyWithImpl<_UIComponentInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UIComponentInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UIComponentInfo&&(identical(other.surfaceId, surfaceId) || other.surfaceId == surfaceId)&&(identical(other.componentType, componentType) || other.componentType == componentType)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.mode, mode) || other.mode == mode)&&const DeepCollectionEquality().equals(other._userSelection, _userSelection)&&(identical(other.toolCallId, toolCallId) || other.toolCallId == toolCallId)&&(identical(other.toolName, toolName) || other.toolName == toolName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,surfaceId,componentType,const DeepCollectionEquality().hash(_data),mode,const DeepCollectionEquality().hash(_userSelection),toolCallId,toolName);

@override
String toString() {
  return 'UIComponentInfo(surfaceId: $surfaceId, componentType: $componentType, data: $data, mode: $mode, userSelection: $userSelection, toolCallId: $toolCallId, toolName: $toolName)';
}


}

/// @nodoc
abstract mixin class _$UIComponentInfoCopyWith<$Res> implements $UIComponentInfoCopyWith<$Res> {
  factory _$UIComponentInfoCopyWith(_UIComponentInfo value, $Res Function(_UIComponentInfo) _then) = __$UIComponentInfoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'surfaceId') String surfaceId,@JsonKey(name: 'componentType') String componentType, Map<String, dynamic> data,@JsonKey(name: 'mode') UIComponentMode mode,@JsonKey(name: 'userSelection') Map<String, dynamic>? userSelection,@JsonKey(name: 'toolCallId') String? toolCallId,@JsonKey(name: 'toolName') String? toolName
});




}
/// @nodoc
class __$UIComponentInfoCopyWithImpl<$Res>
    implements _$UIComponentInfoCopyWith<$Res> {
  __$UIComponentInfoCopyWithImpl(this._self, this._then);

  final _UIComponentInfo _self;
  final $Res Function(_UIComponentInfo) _then;

/// Create a copy of UIComponentInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? surfaceId = null,Object? componentType = null,Object? data = null,Object? mode = null,Object? userSelection = freezed,Object? toolCallId = freezed,Object? toolName = freezed,}) {
  return _then(_UIComponentInfo(
surfaceId: null == surfaceId ? _self.surfaceId : surfaceId // ignore: cast_nullable_to_non_nullable
as String,componentType: null == componentType ? _self.componentType : componentType // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as UIComponentMode,userSelection: freezed == userSelection ? _self._userSelection : userSelection // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,toolCallId: freezed == toolCallId ? _self.toolCallId : toolCallId // ignore: cast_nullable_to_non_nullable
as String?,toolName: freezed == toolName ? _self.toolName : toolName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
