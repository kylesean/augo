// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_content_part.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextPart _$TextPartFromJson(Map<String, dynamic> json) => TextPart(
  text: json['text'] as String,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$TextPartToJson(TextPart instance) => <String, dynamic>{
  'text': instance.text,
  'runtimeType': instance.$type,
};

ToolCallPart _$ToolCallPartFromJson(Map<String, dynamic> json) => ToolCallPart(
  toolCall: ToolCallInfo.fromJson(json['toolCall'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$ToolCallPartToJson(ToolCallPart instance) =>
    <String, dynamic>{
      'toolCall': instance.toolCall,
      'runtimeType': instance.$type,
    };

UIComponentPart _$UIComponentPartFromJson(Map<String, dynamic> json) =>
    UIComponentPart(
      component: UIComponentInfo.fromJson(
        json['component'] as Map<String, dynamic>,
      ),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$UIComponentPartToJson(UIComponentPart instance) =>
    <String, dynamic>{
      'component': instance.component,
      'runtimeType': instance.$type,
    };
