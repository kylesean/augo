/// SSE 事件模型定义
///
/// 包含 SSE 事件相关的数据类型定义，供 CustomContentGenerator
/// 和 SseEventHandlerRegistry 共同使用。
library;

/// 工具调用开始事件
class ToolCallStartEvent {
  final String id;
  final String name;
  final Map<String, dynamic> args;
  final String? timestamp;

  const ToolCallStartEvent({
    required this.id,
    required this.name,
    required this.args,
    this.timestamp,
  });

  factory ToolCallStartEvent.fromJson(Map<String, dynamic> json) {
    return ToolCallStartEvent(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'unknown',
      args: json['args'] as Map<String, dynamic>? ?? {},
      timestamp: json['timestamp'] as String?,
    );
  }
}

/// 工具调用结束事件
class ToolCallEndEvent {
  final String id;
  final String name;
  final String status;
  final int? durationMs;
  final String? resultPreview;
  final String? error;

  const ToolCallEndEvent({
    required this.id,
    required this.name,
    required this.status,
    this.durationMs,
    this.resultPreview,
    this.error,
  });

  factory ToolCallEndEvent.fromJson(Map<String, dynamic> json) {
    return ToolCallEndEvent(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'unknown',
      status: json['status'] as String? ?? 'success',
      durationMs: json['duration_ms'] as int?,
      resultPreview: json['result'] as String?,
      error: json['error'] as String?,
    );
  }
}

/// 工具信息
class ToolInfo {
  final String name;
  final String displayName;
  final String toolType;
  final bool cancellable;
  final String? warningOnCancel;
  final String? surfaceId;

  const ToolInfo({
    required this.name,
    required this.displayName,
    required this.toolType,
    this.cancellable = true,
    this.warningOnCancel,
    this.surfaceId,
  });

  factory ToolInfo.fromJson(Map<String, dynamic> json) {
    return ToolInfo(
      name: json['name'] as String? ?? 'unknown',
      displayName: json['display_name'] as String? ?? '',
      toolType: json['tool_type'] as String? ?? 'readonly',
      cancellable: json['cancellable'] as bool? ?? true,
      warningOnCancel: json['warning_on_cancel'] as String?,
      surfaceId: json['surface_id'] as String?,
    );
  }

  bool get isWriteOperation => toolType == 'write';
  bool get isReadonly => toolType == 'readonly';
  bool get isHitl => toolType == 'hitl';
}

/// SSE 事件回调集合
class SseEventCallbacks {
  final void Function(String sessionId, String? messageId)? onSessionInit;
  final void Function(String text)? onTextChunk;
  final void Function()? onStreamComplete;
  final void Function(String title)? onTitleUpdate;
  final void Function(String error)? onError;
  final void Function(String localId, String serverId)? onMessageIdUpdate;
  final void Function(String surfaceId)? onSurfaceCreated;
  final void Function(ToolCallStartEvent event)? onToolCallStart;
  final void Function(ToolCallEndEvent event)? onToolCallEnd;
  final void Function(double amount, String type, String currency)?
  onTransactionCreated;

  const SseEventCallbacks({
    this.onSessionInit,
    this.onTextChunk,
    this.onStreamComplete,
    this.onTitleUpdate,
    this.onError,
    this.onMessageIdUpdate,
    this.onSurfaceCreated,
    this.onToolCallStart,
    this.onToolCallEnd,
    this.onTransactionCreated,
  });
}
