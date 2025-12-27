// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_content_part.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
MessageContentPart _$MessageContentPartFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'text':
          return TextPart.fromJson(
            json
          );
                case 'tool_call':
          return ToolCallPart.fromJson(
            json
          );
                case 'ui_component':
          return UIComponentPart.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'MessageContentPart',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$MessageContentPart {



  /// Serializes this MessageContentPart to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageContentPart);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MessageContentPart()';
}


}

/// @nodoc
class $MessageContentPartCopyWith<$Res>  {
$MessageContentPartCopyWith(MessageContentPart _, $Res Function(MessageContentPart) __);
}


/// Adds pattern-matching-related methods to [MessageContentPart].
extension MessageContentPartPatterns on MessageContentPart {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TextPart value)?  text,TResult Function( ToolCallPart value)?  toolCall,TResult Function( UIComponentPart value)?  uiComponent,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TextPart() when text != null:
return text(_that);case ToolCallPart() when toolCall != null:
return toolCall(_that);case UIComponentPart() when uiComponent != null:
return uiComponent(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TextPart value)  text,required TResult Function( ToolCallPart value)  toolCall,required TResult Function( UIComponentPart value)  uiComponent,}){
final _that = this;
switch (_that) {
case TextPart():
return text(_that);case ToolCallPart():
return toolCall(_that);case UIComponentPart():
return uiComponent(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TextPart value)?  text,TResult? Function( ToolCallPart value)?  toolCall,TResult? Function( UIComponentPart value)?  uiComponent,}){
final _that = this;
switch (_that) {
case TextPart() when text != null:
return text(_that);case ToolCallPart() when toolCall != null:
return toolCall(_that);case UIComponentPart() when uiComponent != null:
return uiComponent(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String text)?  text,TResult Function( ToolCallInfo toolCall)?  toolCall,TResult Function( UIComponentInfo component)?  uiComponent,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TextPart() when text != null:
return text(_that.text);case ToolCallPart() when toolCall != null:
return toolCall(_that.toolCall);case UIComponentPart() when uiComponent != null:
return uiComponent(_that.component);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String text)  text,required TResult Function( ToolCallInfo toolCall)  toolCall,required TResult Function( UIComponentInfo component)  uiComponent,}) {final _that = this;
switch (_that) {
case TextPart():
return text(_that.text);case ToolCallPart():
return toolCall(_that.toolCall);case UIComponentPart():
return uiComponent(_that.component);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String text)?  text,TResult? Function( ToolCallInfo toolCall)?  toolCall,TResult? Function( UIComponentInfo component)?  uiComponent,}) {final _that = this;
switch (_that) {
case TextPart() when text != null:
return text(_that.text);case ToolCallPart() when toolCall != null:
return toolCall(_that.toolCall);case UIComponentPart() when uiComponent != null:
return uiComponent(_that.component);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class TextPart implements MessageContentPart {
  const TextPart({required this.text, final  String? $type}): $type = $type ?? 'text';
  factory TextPart.fromJson(Map<String, dynamic> json) => _$TextPartFromJson(json);

 final  String text;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of MessageContentPart
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TextPartCopyWith<TextPart> get copyWith => _$TextPartCopyWithImpl<TextPart>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TextPartToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TextPart&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text);

@override
String toString() {
  return 'MessageContentPart.text(text: $text)';
}


}

/// @nodoc
abstract mixin class $TextPartCopyWith<$Res> implements $MessageContentPartCopyWith<$Res> {
  factory $TextPartCopyWith(TextPart value, $Res Function(TextPart) _then) = _$TextPartCopyWithImpl;
@useResult
$Res call({
 String text
});




}
/// @nodoc
class _$TextPartCopyWithImpl<$Res>
    implements $TextPartCopyWith<$Res> {
  _$TextPartCopyWithImpl(this._self, this._then);

  final TextPart _self;
  final $Res Function(TextPart) _then;

/// Create a copy of MessageContentPart
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? text = null,}) {
  return _then(TextPart(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class ToolCallPart implements MessageContentPart {
  const ToolCallPart({required this.toolCall, final  String? $type}): $type = $type ?? 'tool_call';
  factory ToolCallPart.fromJson(Map<String, dynamic> json) => _$ToolCallPartFromJson(json);

 final  ToolCallInfo toolCall;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of MessageContentPart
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ToolCallPartCopyWith<ToolCallPart> get copyWith => _$ToolCallPartCopyWithImpl<ToolCallPart>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ToolCallPartToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ToolCallPart&&(identical(other.toolCall, toolCall) || other.toolCall == toolCall));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,toolCall);

@override
String toString() {
  return 'MessageContentPart.toolCall(toolCall: $toolCall)';
}


}

/// @nodoc
abstract mixin class $ToolCallPartCopyWith<$Res> implements $MessageContentPartCopyWith<$Res> {
  factory $ToolCallPartCopyWith(ToolCallPart value, $Res Function(ToolCallPart) _then) = _$ToolCallPartCopyWithImpl;
@useResult
$Res call({
 ToolCallInfo toolCall
});


$ToolCallInfoCopyWith<$Res> get toolCall;

}
/// @nodoc
class _$ToolCallPartCopyWithImpl<$Res>
    implements $ToolCallPartCopyWith<$Res> {
  _$ToolCallPartCopyWithImpl(this._self, this._then);

  final ToolCallPart _self;
  final $Res Function(ToolCallPart) _then;

/// Create a copy of MessageContentPart
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? toolCall = null,}) {
  return _then(ToolCallPart(
toolCall: null == toolCall ? _self.toolCall : toolCall // ignore: cast_nullable_to_non_nullable
as ToolCallInfo,
  ));
}

/// Create a copy of MessageContentPart
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ToolCallInfoCopyWith<$Res> get toolCall {
  
  return $ToolCallInfoCopyWith<$Res>(_self.toolCall, (value) {
    return _then(_self.copyWith(toolCall: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class UIComponentPart implements MessageContentPart {
  const UIComponentPart({required this.component, final  String? $type}): $type = $type ?? 'ui_component';
  factory UIComponentPart.fromJson(Map<String, dynamic> json) => _$UIComponentPartFromJson(json);

 final  UIComponentInfo component;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of MessageContentPart
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UIComponentPartCopyWith<UIComponentPart> get copyWith => _$UIComponentPartCopyWithImpl<UIComponentPart>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UIComponentPartToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UIComponentPart&&(identical(other.component, component) || other.component == component));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,component);

@override
String toString() {
  return 'MessageContentPart.uiComponent(component: $component)';
}


}

/// @nodoc
abstract mixin class $UIComponentPartCopyWith<$Res> implements $MessageContentPartCopyWith<$Res> {
  factory $UIComponentPartCopyWith(UIComponentPart value, $Res Function(UIComponentPart) _then) = _$UIComponentPartCopyWithImpl;
@useResult
$Res call({
 UIComponentInfo component
});


$UIComponentInfoCopyWith<$Res> get component;

}
/// @nodoc
class _$UIComponentPartCopyWithImpl<$Res>
    implements $UIComponentPartCopyWith<$Res> {
  _$UIComponentPartCopyWithImpl(this._self, this._then);

  final UIComponentPart _self;
  final $Res Function(UIComponentPart) _then;

/// Create a copy of MessageContentPart
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? component = null,}) {
  return _then(UIComponentPart(
component: null == component ? _self.component : component // ignore: cast_nullable_to_non_nullable
as UIComponentInfo,
  ));
}

/// Create a copy of MessageContentPart
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UIComponentInfoCopyWith<$Res> get component {
  
  return $UIComponentInfoCopyWith<$Res>(_self.component, (value) {
    return _then(_self.copyWith(component: value));
  });
}
}

// dart format on
