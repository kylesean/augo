// SSE 事件处理器注册表
//
// 设计模式:
// - 策略模式 (Strategy Pattern): 每个事件类型对应一个处理器
// - 注册表模式 (Registry Pattern): 统一管理所有处理器
//
// 设计意图:
// - 消除 _handleSseEvent 中的大型 switch 语句
// - 支持通过注册新处理器扩展事件处理
// - 提高代码的可测试性和可维护性

import 'package:logging/logging.dart';
import 'package:genui/genui.dart' as genui;
import '../models/sse_event_models.dart';

final _logger = Logger('SseEventHandlerRegistry');

/// SSE 事件处理上下文
class SseEventContext {
  final void Function(String?) setSessionId;
  final String? Function() getCurrentSessionId;
  final void Function(genui.A2uiMessage) addA2uiMessage;
  final void Function(String) addTextResponse;
  final SseEventCallbacks callbacks;
  final StringBuffer textBuffer;

  const SseEventContext({
    required this.setSessionId,
    required this.getCurrentSessionId,
    required this.addA2uiMessage,
    required this.addTextResponse,
    required this.callbacks,
    required this.textBuffer,
  });
}

/// SSE 事件处理器抽象基类
abstract class SseEventHandler {
  Future<void> handle(Map<String, dynamic> data, SseEventContext context);
}

/// session_init 事件处理器
class SessionInitHandler implements SseEventHandler {
  @override
  Future<void> handle(
    Map<String, dynamic> data,
    SseEventContext context,
  ) async {
    final metadata = data['metadata'] as Map<String, dynamic>?;
    if (metadata != null) {
      final sessionId = metadata['session_id'] as String?;
      final messageId = metadata['message_id'] as String?;

      _logger.info('Session initialized - id: $sessionId, message: $messageId');

      context.setSessionId(sessionId);
      if (sessionId != null) {
        context.callbacks.onSessionInit?.call(sessionId, messageId);
      }
    }
  }
}

/// text_delta 事件处理器
class TextDeltaHandler implements SseEventHandler {
  @override
  Future<void> handle(
    Map<String, dynamic> data,
    SseEventContext context,
  ) async {
    final content = data['content'] as String?;
    if (content != null && content.isNotEmpty) {
      context.textBuffer.write(content);
      context.addTextResponse(content);
      context.callbacks.onTextChunk?.call(content);
    }
  }
}

/// title_update 事件处理器
class TitleUpdateHandler implements SseEventHandler {
  @override
  Future<void> handle(
    Map<String, dynamic> data,
    SseEventContext context,
  ) async {
    final title = data['title'] as String?;
    if (title != null && title.isNotEmpty) {
      _logger.info('Title update: $title');
      context.callbacks.onTitleUpdate?.call(title);
    }
  }
}

/// a2ui_message 事件处理器
class A2uiMessageHandler implements SseEventHandler {
  @override
  Future<void> handle(
    Map<String, dynamic> data,
    SseEventContext context,
  ) async {
    final a2uiMessageData = data['data'] as Map<String, dynamic>?;

    if (a2uiMessageData == null || a2uiMessageData.isEmpty) {
      _logger.warning('[A2UI] ERROR: No data field or empty');
      return;
    }

    try {
      final a2uiMessage = genui.A2uiMessage.fromJson(a2uiMessageData);
      context.addA2uiMessage(a2uiMessage);

      if (a2uiMessageData.containsKey('surfaceUpdate')) {
        final surfaceUpdate =
            a2uiMessageData['surfaceUpdate'] as Map<String, dynamic>?;
        if (surfaceUpdate != null) {
          final surfaceId = surfaceUpdate['surfaceId'] as String?;
          if (surfaceId != null) {
            context.callbacks.onSurfaceCreated?.call(surfaceId);
          }
        }
      }
    } catch (e) {
      _logger.severe('[A2UI] ERROR parsing message: $e');
    }
  }
}

/// tool_call_start 事件处理器
class ToolCallStartHandler implements SseEventHandler {
  @override
  Future<void> handle(
    Map<String, dynamic> data,
    SseEventContext context,
  ) async {
    final eventData = data['data'] as Map<String, dynamic>?;
    if (eventData != null) {
      final event = ToolCallStartEvent.fromJson(eventData);
      _logger.info('Tool call start - ${event.name} (${event.id})');
      context.callbacks.onToolCallStart?.call(event);
    }
  }
}

/// tool_call_end 事件处理器
class ToolCallEndHandler implements SseEventHandler {
  @override
  Future<void> handle(
    Map<String, dynamic> data,
    SseEventContext context,
  ) async {
    final eventData = data['data'] as Map<String, dynamic>?;
    if (eventData != null) {
      final event = ToolCallEndEvent.fromJson(eventData);
      _logger.info(
        'Tool call end - ${event.name} (${event.id}) '
        'status: ${event.status}, duration: ${event.durationMs}ms',
      );
      context.callbacks.onToolCallEnd?.call(event);
    }
  }
}

/// done 事件处理器
class DoneHandler implements SseEventHandler {
  @override
  Future<void> handle(
    Map<String, dynamic> data,
    SseEventContext context,
  ) async {
    _logger.info('Stream completed (done event)');
    context.textBuffer.clear();
  }
}

/// 错误事件处理器
class ErrorHandler implements SseEventHandler {
  @override
  Future<void> handle(
    Map<String, dynamic> data,
    SseEventContext context,
  ) async {
    final content = data['content'] as String?;
    if (content != null) {
      _logger.warning('Error from backend: $content');
      context.callbacks.onError?.call(content);
    }
  }
}

/// SSE 事件处理器注册表
class SseEventHandlerRegistry {
  static final Map<String, SseEventHandler> _handlers = {};
  static bool _initialized = false;

  static void initialize() {
    if (_initialized) return;

    register('session_init', SessionInitHandler());
    register('text_delta', TextDeltaHandler());
    register('title_update', TitleUpdateHandler());
    register('a2ui_message', A2uiMessageHandler());
    register('tool_call_start', ToolCallStartHandler());
    register('tool_call_end', ToolCallEndHandler());
    register('done', DoneHandler());
    register('error', ErrorHandler());

    _initialized = true;
    _logger.info(
      'SseEventHandlerRegistry initialized with ${_handlers.length} handlers',
    );
  }

  static void register(String eventType, SseEventHandler handler) {
    _handlers[eventType] = handler;
  }

  static Future<void> handle(
    String? eventType,
    Map<String, dynamic> data,
    SseEventContext context,
  ) async {
    if (eventType == null) return;

    initialize();

    final handler = _handlers[eventType];
    if (handler != null) {
      await handler.handle(data, context);
    } else {
      _logger.info('Unknown event type: $eventType');
    }
  }

  static List<String> get registeredEventTypes => _handlers.keys.toList();
}
