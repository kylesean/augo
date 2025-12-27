// features/chat/services/genui_lifecycle_manager.dart

import 'dart:async';
import 'package:logging/logging.dart';

import 'package:dio/dio.dart';
import 'package:genui/genui.dart' as genui;
import '../../../core/storage/secure_storage_service.dart';
import '../genui/app_catalog.dart';
import '../models/chat_message.dart';
import '../models/genui_surface_info.dart';
import '../models/tool_call_info.dart';
import '../repositories/message_repository.dart';
import '../services/genui_logger.dart';
import '../services/genui_service.dart';
import '../services/custom_content_generator.dart';

final _logger = Logger('GenUiLifecycleManager');

/// Manages the lifecycle of the GenUI service and handles surface events.
class GenUiLifecycleManager {
  final SecureStorageService _secureStorageService;
  final MessageRepository _messageRepository;

  // Callbacks to interact with standard ChatNotifier state
  final String Function() _getCurrentStreamingMessageId;
  final Function(double amount, String type, String currency)
  _onTransactionCreated;
  final Function(String sessionId, String? messageId) _onSessionInit;
  final Function(String text) _onTextResponse;
  final Function() _onStreamComplete;
  final Function() _markFirstChunkReceived;
  final Function(String title) _onTitleUpdate;
  final Function(ToolCallInfo)? _onToolCallStart;
  final Function(ToolCallInfo)? _onToolCallEnd;

  GenUiService? _genUiService;

  // Legacy tracking of surface info (to be refactored later, kept for compatibility)
  final Map<String, List<GenUiSurfaceInfo>> _messageSurfaces = {};

  GenUiLifecycleManager({
    required SecureStorageService secureStorageService,
    required MessageRepository messageRepository,
    required String Function() getCurrentStreamingMessageId,
    required Function(double, String, String) onTransactionCreated,
    required Function(String, String?) onSessionInit,
    required Function(String) onTextResponse,
    required Function() onStreamComplete,
    required Function() markFirstChunkReceived,
    required Function(String) onTitleUpdate,
    Function(ToolCallInfo)? onToolCallStart,
    Function(ToolCallInfo)? onToolCallEnd,
  }) : _secureStorageService = secureStorageService,
       _messageRepository = messageRepository,
       _getCurrentStreamingMessageId = getCurrentStreamingMessageId,
       _onTransactionCreated = onTransactionCreated,
       _onSessionInit = onSessionInit,
       _onTextResponse = onTextResponse,
       _onStreamComplete = onStreamComplete,
       _markFirstChunkReceived = markFirstChunkReceived,
       _onTitleUpdate = onTitleUpdate,
       _onToolCallStart = onToolCallStart,
       _onToolCallEnd = onToolCallEnd;

  bool get isInitialized => _genUiService?.isInitialized ?? false;
  GenUiService? get service => _genUiService;

  /// Initialize GenUI service
  Future<void> initialize({Dio? dio, required String sseBaseUrl}) async {
    try {
      _genUiService = GenUiService();
      await _genUiService!.initialize(
        catalog: AppCatalog.build(),
        storageService: _secureStorageService,
        sseBaseUrl: sseBaseUrl,
        onSurfaceAdded: _handleSurfaceAdded,
        onSurfaceRemoved: _handleSurfaceRemoved,
        onTextResponse: _onTextResponse,
        onSessionInit: _onSessionInit,
        onStreamComplete: _onStreamComplete,
        onTitleUpdate: _onTitleUpdate,
        onError: (msg, err) => _handleGenUiError(msg),
        onSurfaceIdAdded: _handleSurfaceIdAdded,
        onTransactionCreated: (data) => _onTransactionCreated(
          (data['amount'] as num?)?.toDouble() ?? 0.0,
          data['transactionType'] as String? ?? 'expense',
          data['currency'] as String? ?? 'CNY',
        ),
        dio: dio,
      );

      // Wire up tool call event callbacks
      final CustomContentGenerator contentGenerator =
          _genUiService!.conversation.contentGenerator;
      contentGenerator.onToolCallStart = (event) {
        _logger.info('GenUiLifecycleManager: Tool call start - ${event.name}');
        final toolCallInfo = ToolCallInfo(
          id: event.id,
          name: event.name,
          args: event.args,
          status: ToolExecutionStatus.running,
          timestamp: event.timestamp,
        );
        _onToolCallStart?.call(toolCallInfo);
      };

      contentGenerator.onToolCallEnd = (event) {
        _logger.info(
          'GenUiLifecycleManager: Tool call end - ${event.name}, ${event.status}',
        );
        final status = event.status == 'error'
            ? ToolExecutionStatus.error
            : ToolExecutionStatus.success;
        final toolCallInfo = ToolCallInfo(
          id: event.id,
          name: event.name,
          status: status,
          durationMs: event.durationMs,
          resultPreview: event.resultPreview,
          error: event.error,
        );
        _onToolCallEnd?.call(toolCallInfo);
      };

      _logger.info('GenUiLifecycleManager: Service initialized successfully');
      GenUiLogger.logInitialization(success: true);

      // Hook up user message updates
      _genUiService!.conversation.onUserMessageSent = (content) {
        // This needs to be handled by ChatInteractionManager later.
      };
    } catch (e, stackTrace) {
      _logger.severe(
        'GenUiLifecycleManager: Initialization failed',
        e,
        stackTrace,
      );
      GenUiLogger.logInitialization(success: false, errorMessage: e.toString());
    }
  }

  void setOnUserMessageSent(Function(String) callback) {
    if (_genUiService != null) {
      _genUiService!.conversation.onUserMessageSent = callback;
    }
  }

  void dispose() {
    _genUiService?.dispose();
    _messageSurfaces.clear();
  }

  // ============================================================
  // Event Handlers
  // ============================================================

  void _handleSurfaceAdded(genui.SurfaceAdded event) {
    _logger.info('GenUiLifecycleManager: Surface added - ${event.surfaceId}');

    if (event.surfaceId.startsWith('history_')) {
      return;
    }

    GenUiLogger.logSurfaceLifecycle(
      event: 'added',
      surfaceId: event.surfaceId,
      messageId: _getCurrentStreamingMessageId(),
    );

    String messageId = _findTargetMessageIdForSurface(event.surfaceId);
    if (messageId.isEmpty) return;

    final surfaceInfo = GenUiSurfaceInfo(
      surfaceId: event.surfaceId,
      messageId: messageId,
      createdAt: DateTime.now(),
      status: SurfaceStatus.loading,
    );

    _messageSurfaces.putIfAbsent(messageId, () => []).add(surfaceInfo);
    _messageRepository.addSurfaceIdToMessage(messageId, event.surfaceId);
  }

  void _handleSurfaceIdAdded(String surfaceId) {
    _logger.info('GenUiLifecycleManager: Surface ID added - $surfaceId');

    GenUiLogger.logSurfaceLifecycle(
      event: 'added',
      surfaceId: surfaceId,
      messageId: _getCurrentStreamingMessageId(),
    );

    String messageId = _findTargetMessageIdForSurface(surfaceId);
    if (messageId.isEmpty) return;

    // Mark content received (silent mode support)
    _markFirstChunkReceived();
    _logger.info(
      'GenUiLifecycleManager: Silent mode - UI component received, marking as first chunk',
    );

    _messageRepository.addSurfaceIdToMessage(messageId, surfaceId);
  }

  void _handleSurfaceRemoved(genui.SurfaceRemoved event) {
    _logger.info('GenUiLifecycleManager: Surface removed - ${event.surfaceId}');
    _messageRepository.removeSurfaceIdFromMessage(event.surfaceId);
  }

  void _handleGenUiError(String error) {
    // Log and update message state
    _logger.warning('GenUiLifecycleManager: GenUI error: $error');

    // Converter logic
    String userFriendlyMessage;
    if (error.contains('No generations') || error.contains('empty stream')) {
      userFriendlyMessage = '抱歉，服务暂时繁忙，请稍后再试';
    } else if (error.contains('timeout') || error.contains('Timeout')) {
      userFriendlyMessage = '请求超时了，请检查网络后重试';
    } else if (error.contains('network') || error.contains('connection')) {
      userFriendlyMessage = '网络连接出现问题，请检查后重试';
    } else if (error.contains('Authentication') || error.contains('token')) {
      userFriendlyMessage = '登录状态已过期，请重新登录';
    } else {
      userFriendlyMessage = '出了点小问题，请稍后再试 🙏';
    }

    final currentId = _getCurrentStreamingMessageId();
    if (currentId.isNotEmpty) {
      _messageRepository.updateAiMessageState(
        id: currentId,
        content: userFriendlyMessage,
        isTyping: false,
        streamingStatus: StreamingStatus.error,
      );
    }
  }

  String _findTargetMessageIdForSurface(String surfaceId) {
    String messageId = _getCurrentStreamingMessageId();
    if (messageId.isNotEmpty) {
      return messageId;
    }

    // Fallback: find last AI message
    final messages = _messageRepository.getCurrentMessages();
    for (int i = messages.length - 1; i >= 0; i--) {
      if (messages[i].sender != MessageSender.ai) {
        continue;
      }
      if (messages[i].sender != MessageSender.user) {
        return messages[i].id;
      }
    }
    return '';
  }

  // Public method for UI Render Event (from SSE)
  void handleUiRenderEvent(
    String componentName,
    Map<String, dynamic> componentData,
    String uuidV4,
  ) {
    if (_genUiService == null || !_genUiService!.isInitialized) {
      _logger.info('GenUiLifecycleManager: Service not initialized');
      return;
    }

    final surfaceId = 'surface_$uuidV4';

    final rootComponentId = 'root_$uuidV4'; // Hacky distinct ID

    final component = genui.Component(
      id: rootComponentId,
      componentProperties: {componentName: componentData},
    );

    final definition = genui.UiDefinition(
      surfaceId: surfaceId,
      rootComponentId: rootComponentId,
      components: {rootComponentId: component},
    );

    final manager = _genUiService!.manager;
    final notifier = manager.getSurfaceNotifier(surfaceId);
    notifier.value = definition;

    final messageId = _getCurrentStreamingMessageId();
    if (messageId.isNotEmpty) {
      _messageRepository.addSurfaceIdToMessage(messageId, surfaceId);
    }
  }
}
