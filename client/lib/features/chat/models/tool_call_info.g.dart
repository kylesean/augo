// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tool_call_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ToolCallInfo _$ToolCallInfoFromJson(Map<String, dynamic> json) =>
    _ToolCallInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      args: json['args'] as Map<String, dynamic>? ?? const {},
      status:
          $enumDecodeNullable(_$ToolExecutionStatusEnumMap, json['status']) ??
          ToolExecutionStatus.pending,
      durationMs: (json['duration_ms'] as num?)?.toInt(),
      resultPreview: json['result'] as String?,
      error: json['error'] as String?,
      timestamp: json['timestamp'] as String?,
    );

Map<String, dynamic> _$ToolCallInfoToJson(_ToolCallInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'args': instance.args,
      'status': _$ToolExecutionStatusEnumMap[instance.status]!,
      'duration_ms': instance.durationMs,
      'result': instance.resultPreview,
      'error': instance.error,
      'timestamp': instance.timestamp,
    };

const _$ToolExecutionStatusEnumMap = {
  ToolExecutionStatus.pending: 'pending',
  ToolExecutionStatus.running: 'running',
  ToolExecutionStatus.success: 'success',
  ToolExecutionStatus.error: 'error',
};

_UIComponentInfo _$UIComponentInfoFromJson(Map<String, dynamic> json) =>
    _UIComponentInfo(
      surfaceId: json['surfaceId'] as String,
      componentType: json['componentType'] as String,
      data: json['data'] as Map<String, dynamic>? ?? const {},
      mode:
          $enumDecodeNullable(_$UIComponentModeEnumMap, json['mode']) ??
          UIComponentMode.historical,
      userSelection: json['userSelection'] as Map<String, dynamic>?,
      toolCallId: json['toolCallId'] as String?,
      toolName: json['toolName'] as String?,
    );

Map<String, dynamic> _$UIComponentInfoToJson(_UIComponentInfo instance) =>
    <String, dynamic>{
      'surfaceId': instance.surfaceId,
      'componentType': instance.componentType,
      'data': instance.data,
      'mode': _$UIComponentModeEnumMap[instance.mode]!,
      'userSelection': instance.userSelection,
      'toolCallId': instance.toolCallId,
      'toolName': instance.toolName,
    };

const _$UIComponentModeEnumMap = {
  UIComponentMode.live: 'live',
  UIComponentMode.historical: 'historical',
};
