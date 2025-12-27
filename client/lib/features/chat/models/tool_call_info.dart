// features/chat/models/tool_call_info.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tool_call_info.freezed.dart';
part 'tool_call_info.g.dart';

/// Tool execution status for visualization
enum ToolExecutionStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('running')
  running,
  @JsonValue('success')
  success,
  @JsonValue('error')
  error,
}

/// Tool call information from AI message
///
/// Supports both real-time streaming visualization (Claude Code style)
/// and historical message restoration.
@freezed
abstract class ToolCallInfo with _$ToolCallInfo {
  const factory ToolCallInfo({
    required String id,
    required String name,
    @Default({}) Map<String, dynamic> args,

    /// Execution status (pending -> running -> success/error)
    @Default(ToolExecutionStatus.pending) ToolExecutionStatus status,

    /// Execution duration in milliseconds
    @JsonKey(name: 'duration_ms') int? durationMs,

    /// Truncated result preview (max 200 chars)
    @JsonKey(name: 'result') String? resultPreview,

    /// Error message if status is error
    String? error,

    /// Timestamp when tool started
    String? timestamp,
  }) = _ToolCallInfo;

  factory ToolCallInfo.fromJson(Map<String, dynamic> json) =>
      _$ToolCallInfoFromJson(json);
}

/// UI component rendering mode
enum UIComponentMode {
  @JsonValue('live')
  live,
  @JsonValue('historical')
  historical,
}

/// UI component information for GenUI rendering
///
/// Supports both live streaming and historical restoration.
@freezed
abstract class UIComponentInfo with _$UIComponentInfo {
  const factory UIComponentInfo({
    @JsonKey(name: 'surfaceId') required String surfaceId,
    @JsonKey(name: 'componentType') required String componentType,
    @Default({}) Map<String, dynamic> data,

    /// Rendering mode: live (interactive), historical (read-only)
    @JsonKey(name: 'mode')
    @Default(UIComponentMode.historical)
    UIComponentMode mode,

    /// User's selection (for showing what user chose in historical mode)
    @JsonKey(name: 'userSelection') Map<String, dynamic>? userSelection,

    /// Tool call context
    @JsonKey(name: 'toolCallId') String? toolCallId,
    @JsonKey(name: 'toolName') String? toolName,
  }) = _UIComponentInfo;

  factory UIComponentInfo.fromJson(Map<String, dynamic> json) =>
      _$UIComponentInfoFromJson(json);
}
