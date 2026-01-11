import 'dart:async';
import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:flutter/foundation.dart';
import 'package:genui/genui.dart' as genui;
import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../genui/genui_event_registry.dart';
import '../models/sse_event_models.dart';

export '../models/sse_event_models.dart'
    show ToolCallStartEvent, ToolCallEndEvent, ToolInfo;

final _logger = Logger('CustomContentGenerator');

// ============================================================
// Callback type definitions - GenUI architecture unified
// ============================================================

/// Session initialization callback - called when new session is created
typedef OnSessionInit = void Function(String sessionId, String? messageId);

/// Text chunk callback - called each time a text segment is received
typedef OnTextChunk = void Function(String text);

/// Stream completion callback - called when SSE stream normally ends
typedef OnStreamComplete = void Function();

/// Title update callback - called when session title is received
typedef OnTitleUpdate = void Function(String title);

/// Error callback - called when an error occurs
typedef OnErrorCallback = void Function(String error);

/// Message ID update callback - called when backend message ID is received
typedef OnMessageIdUpdate = void Function(String localId, String serverId);

/// Surface creation callback - called when SurfaceUpdate creates a new surface
/// Used for unified surface lifecycle management, triggering GenUI's onSurfaceAdded
typedef OnSurfaceCreated = void Function(String surfaceId);

typedef OnTransactionCreated =
    void Function(double amount, String transactionType, String currency);

/// Tool call start callback - called when tool execution starts (Claude Code style)
typedef OnToolCallStart = void Function(ToolCallStartEvent event);

/// Tool call end callback - called when tool execution completes (Claude Code style)
typedef OnToolCallEnd = void Function(ToolCallEndEvent event);

/// Custom ContentGenerator implementation, connecting to our SSE backend API
///
/// Implements three core streams of ContentGenerator interface:
/// - a2uiMessageStream: AI operation instruction stream (for creating/updating/deleting UI)
/// - textResponseStream: Text response stream
/// - errorStream: Error handling stream
class CustomContentGenerator implements genui.ContentGenerator {
  final SecureStorageService _storageService;

  // Three core stream controllers
  final _a2uiMessageController =
      StreamController<genui.A2uiMessage>.broadcast();
  final _textResponseController = StreamController<String>.broadcast();
  final _errorResponseController =
      StreamController<genui.ContentGeneratorError>.broadcast();

  // Note: uiRenderStream removed, unified through onSurfaceCreated callback

  // ============================================================
  // Callback fields - GenUI architecture unified
  // ============================================================
  OnSessionInit? onSessionInit;
  OnTextChunk? onTextChunk;
  OnStreamComplete? onStreamComplete;
  OnTitleUpdate? onTitleUpdate;
  OnErrorCallback? onError;
  OnMessageIdUpdate? onMessageIdUpdate;
  OnSurfaceCreated? onSurfaceCreated;
  OnToolCallStart? onToolCallStart;
  OnToolCallEnd? onToolCallEnd;
  OnTransactionCreated? onTransactionCreated;

  /// User message send callback - notifies upper layer to update UI when GenUI internally sends request
  void Function(String content)? onUserMessageSent;

  // Processing state
  final ValueNotifier<bool> _isProcessing = ValueNotifier(false);

  // Store current session ID (user authentication uses SecureStorageService's token)
  String? _currentSessionId;

  // Used to accumulate text content
  final _textBuffer = StringBuffer();

  // Used to buffer A2UI messages for transactional rendering
  // These messages will only be sent to UI when stream ends normally
  final _a2uiBuffer = <genui.A2uiMessage>[];

  // =========================================================================
  // SSE stream cancellation mechanism
  // =========================================================================
  // Used to manage HTTP requests, calling close() can immediately interrupt all ongoing requests
  Dio? _dio;
  CancelToken? _cancelToken;
  // Cancellation flag - set to true when user clicks stop button
  bool _isCancelled = false;

  // =========================================================================
  // Tool state tracking - for smart cancellation handling
  // =========================================================================
  // Currently executing tool information
  ToolInfo? _currentToolInfo;
  ToolInfo? get currentToolInfo => _currentToolInfo;

  // URL configuration
  final String _sseBaseUrl;

  CustomContentGenerator(
    this._storageService, {
    Dio? dio,
    required String sseBaseUrl,
  }) : _dio = dio,
       _sseBaseUrl = sseBaseUrl;

  /// Get current session ID
  String? get currentSessionId => _currentSessionId;

  /// Set current session ID
  void setSessionId(String sessionId) {
    _currentSessionId = sessionId;
  }

  /// Clear session token/ID
  void clearSessionToken() {
    _currentSessionId = null;
  }

  /// Cancel currently ongoing SSE request
  ///
  /// Immediately interrupts network connection and resets state
  void cancel() {
    _logger.info(
      'CustomContentGenerator: Public cancel() called - notifying complete',
    );
    _internalCancel(notifyComplete: true);
  }

  /// Internal cancellation logic
  ///
  /// [notifyComplete] - Whether to trigger onStreamComplete callback.
  /// When called by _sendRequestInternal to clean up old requests, should be set to false
  /// to prevent incorrectly ending the lifecycle of new requests.
  void _internalCancel({required bool notifyComplete}) {
    if (_cancelToken != null && !_cancelToken!.isCancelled) {
      _logger.info('CustomContentGenerator: Internal aborting active request');
      _isCancelled = true;
      _cancelToken?.cancel('User cancelled');
      _cancelToken = null;
    }

    // Reset processing state
    _isProcessing.value = false;

    // Clear buffered UI messages to ensure transactionality: cancelled requests should not produce side effects
    _a2uiBuffer.clear();

    // Only notify stream end when explicitly requested
    if (notifyComplete) {
      _logger.info('CustomContentGenerator: Notifying stream complete');
      onStreamComplete?.call();
    }
  }

  @override
  Stream<genui.A2uiMessage> get a2uiMessageStream =>
      _a2uiMessageController.stream;

  @override
  Stream<String> get textResponseStream => _textResponseController.stream;

  @override
  Stream<genui.ContentGeneratorError> get errorStream =>
      _errorResponseController.stream;

  @override
  ValueListenable<bool> get isProcessing => _isProcessing;

  @override
  Future<void> sendRequest(
    genui.ChatMessage message, {
    genui.A2UiClientCapabilities? clientCapabilities,
    Iterable<genui.ChatMessage>? history,
  }) async {
    // 1. Preprocessing: Only process current new message
    final messages = <Map<String, dynamic>>[];

    // Only need to process current message
    final currentMessage = await _convertMessage(message);
    messages.add(currentMessage);

    // GenUI event registry processing
    Map<String, dynamic>? clientStateJson;
    String? userMessageContent;

    try {
      if (currentMessage['content'] is String) {
        userMessageContent = currentMessage['content'] as String;
      }

      if (currentMessage.containsKey('metadata')) {
        final metadata = currentMessage['metadata'] as Map<String, dynamic>;
        final eventType = metadata['event_type'] as String?;

        if (eventType != null) {
          final clientState = GenUiEventRegistry.dispatch(eventType, metadata);

          if (clientState != null && !clientState.isEmpty) {
            _logger.info('Event $eventType dispatched via registry');
            clientStateJson = clientState.toJson();
          }
        } else if (currentMessage['content'] != null) {
          userMessageContent = currentMessage['content'].toString();
        }
      }
    } catch (e) {
      _logger.info(
        'CustomContentGenerator: Error parsing message for events: $e',
      );
    }

    // 2. Optimistic UI update
    if (userMessageContent != null && userMessageContent.isNotEmpty) {
      if (clientStateJson != null) {
        onUserMessageSent?.call('[GENUI_INTERNAL]$userMessageContent');
      } else {
        onUserMessageSent?.call(userMessageContent);
      }
    }

    // 3. Execute unified request logic
    await _sendRequestInternal(
      messages: messages,
      sessionId: _currentSessionId,
      clientState: clientStateJson,
    );
  }

  /// Unified entry: Send message to backend, supports attachments and session ID
  Future<void> sendRequestWithAttachments(
    String message, {
    String? sessionId,
    List<Map<String, dynamic>>? attachments,
    Map<String, dynamic>? stateUpdates,
  }) async {
    // Build simple message body
    final messagePayload = <String, dynamic>{
      'role': 'user',
      'content': message,
    };

    if (attachments != null && attachments.isNotEmpty) {
      messagePayload['attachments'] = attachments;
    }

    // Update current Session ID (if provided)
    if (sessionId != null) {
      _currentSessionId = sessionId;
    }

    // Execute unified request logic
    await _sendRequestInternal(
      messages: [messagePayload],
      sessionId: _currentSessionId,
      clientState: stateUpdates,
    );
  }

  /// Core internal request method: Unified handling of Session, ClientState and SSE stream
  Future<void> _sendRequestInternal({
    required List<Map<String, dynamic>> messages,
    String? sessionId,
    Map<String, dynamic>? clientState,
  }) async {
    // 0. Ensure any ongoing request is cancelled
    _internalCancel(notifyComplete: false);

    // Reset cancellation flag and tool info
    _isCancelled = false;
    _currentToolInfo = null;
    _isProcessing.value = true;
    _textBuffer.clear();
    _a2uiBuffer.clear();

    try {
      // 1. Get user authentication token
      final token = await _storageService.getToken();
      _logger.info('CustomContentGenerator: Using session_id: $sessionId');

      if (token == null || token.isEmpty) {
        const error = 'Authentication token is missing';
        _logger.info('CustomContentGenerator: $error');
        onError?.call(error);
        _errorResponseController.add(
          genui.ContentGeneratorError(error, StackTrace.current),
        );
        return;
      }

      // 2. Build request
      final uri = Uri.parse('$_sseBaseUrl${ApiConstants.aiChatSseEndpoint}');

      _dio ??= Dio(
        BaseOptions(
          connectTimeout: ApiConstants.connectTimeout,
          receiveTimeout: const Duration(hours: 1),
          sendTimeout: const Duration(hours: 1),
        ),
      );
      _cancelToken = CancelToken();

      // Build request Body
      final body = <String, dynamic>{'messages': messages};

      if (sessionId != null) {
        body['session_id'] = sessionId;
        _logger.info(
          'CustomContentGenerator: Attaching session_id: $sessionId',
        );
      }

      if (clientState != null && clientState.isNotEmpty) {
        body['client_state'] = clientState;
        _logger.info(
          'CustomContentGenerator: Injected client_state for atomic mode',
        );
      }

      _logger.info('CustomContentGenerator: Sending request to $uri');

      // 3. Send request
      final response = await _dio!.post<ResponseBody>(
        uri.toString(),
        data: body,
        options: Options(
          headers: {
            'Accept': 'text/event-stream',
            'Cache-Control': 'no-cache',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          responseType: ResponseType.stream,
          validateStatus: (status) => true,
          // 强制使用极长超时限制：SSE 流可能持续很长时间（例如 AI 执行脚本）
          receiveTimeout: const Duration(hours: 1),
          sendTimeout: const Duration(hours: 1),
        ),
        cancelToken: _cancelToken,
      );

      if (response.statusCode != 200) {
        final error = 'HTTP error: ${response.statusCode}';
        _logger.info('CustomContentGenerator: $error');
        onError?.call(error);
        _errorResponseController.add(
          genui.ContentGeneratorError(error, StackTrace.current),
        );
        return;
      }

      // 4. Process SSE stream response
      await for (final line
          in response.data!.stream
              .cast<List<int>>()
              .transform(utf8.decoder)
              .transform(const LineSplitter())) {
        if (_isCancelled) {
          _logger.info(
            'CustomContentGenerator: Stream processing cancelled by user',
          );
          break;
        }

        if (line.isEmpty || !line.startsWith('data: ')) continue;

        try {
          final jsonStr = line.substring(6).trim();
          if (jsonStr.isEmpty) continue;

          final data = jsonDecode(jsonStr) as Map<String, dynamic>;
          final eventType = data['type'] as String?;

          await _handleSseEvent(eventType, data);
        } catch (e) {
          _logger.warning(
            'CustomContentGenerator: Error parsing SSE event: $e',
          );
        }
      }

      // Stream processing ended normally
      if (!_isCancelled) {
        _logger.info('CustomContentGenerator: Stream succeeded');
        onStreamComplete?.call();
      }
    } catch (e, stackTrace) {
      if (_isCancelled || (e is DioException && CancelToken.isCancel(e))) {
        _logger.info('CustomContentGenerator: Request cancelled by user');
        return;
      }

      _logger.severe(
        'CustomContentGenerator: Error in _sendRequestInternal',
        e,
        stackTrace,
      );
      onError?.call(e.toString());
      _errorResponseController.add(genui.ContentGeneratorError(e, stackTrace));
    } finally {
      _isProcessing.value = false;
    }
  }

  /// Handle SSE events
  Future<void> _handleSseEvent(
    String? eventType,
    Map<String, dynamic> data,
  ) async {
    switch (eventType) {
      case 'session_init':
        final metadata = data['metadata'] as Map<String, dynamic>?;
        if (metadata != null) {
          _currentSessionId = metadata['session_id'] as String?;
          final messageId = metadata['message_id'] as String?;
          _logger.info(
            'CustomContentGenerator: Session initialized - id: $_currentSessionId, message: $messageId',
          );

          if (_currentSessionId != null) {
            onSessionInit?.call(_currentSessionId!, messageId);
          }
        }
        break;

      case 'text_delta':
        final content = data['content'] as String?;
        if (content != null && content.isNotEmpty) {
          _textBuffer.write(content);
          _textResponseController.add(content);
          onTextChunk?.call(content);
          // IMPORTANT: Yield to event loop to allow UI to update during streaming.
          // Without this, rapid SSE events are processed synchronously in a single frame,
          // causing Flutter to batch all state updates and only render at stream end.
          await Future<void>.delayed(Duration.zero);
        }
        break;

      case 'title_update':
        final title = data['title'] as String?;
        if (title != null && title.isNotEmpty) {
          _logger.info('CustomContentGenerator: Title update: $title');
          onTitleUpdate?.call(title);
        }
        break;

      case 'a2ui_message':
        await _handleA2uiMessage(data);
        break;

      case 'tool_call_start':
        final eventData = data['data'] as Map<String, dynamic>?;
        if (eventData != null) {
          final event = ToolCallStartEvent.fromJson(eventData);
          _logger.info(
            'CustomContentGenerator: Tool call start - ${event.name} (${event.id})',
          );
          onToolCallStart?.call(event);
          await Future<void>.delayed(Duration.zero);
        }
        break;

      case 'tool_call_end':
        final eventData = data['data'] as Map<String, dynamic>?;
        if (eventData != null) {
          final event = ToolCallEndEvent.fromJson(eventData);
          _logger.info(
            'CustomContentGenerator: Tool call end - ${event.name} (${event.id}) '
            'status: ${event.status}, duration: ${event.durationMs}ms',
          );
          onToolCallEnd?.call(event);
          await Future<void>.delayed(Duration.zero);
        }
        break;

      case 'done':
        _logger.info('CustomContentGenerator: Stream completed (done event)');
        _textBuffer.clear();
        break;

      default:
        _logger.info('CustomContentGenerator: Unknown event type: $eventType');
    }
  }

  Future<void> _handleA2uiMessage(Map<String, dynamic> data) async {
    try {
      final a2uiMessageData = data['data'] as Map<String, dynamic>?;

      if (a2uiMessageData == null || a2uiMessageData.isEmpty) {
        _logger.warning('[A2UI] ERROR: No data field or empty');
        return;
      }

      final a2uiMessage = genui.A2uiMessage.fromJson(a2uiMessageData);

      // 立即发送到 controller，不再缓冲到流结束
      // 这样 GenUI 组件会立即渲染，不会等待流式文本完成
      _a2uiMessageController.add(a2uiMessage);
      _logger.info(
        '[A2UI] ✓ Message sent immediately: ${a2uiMessage.runtimeType}',
      );

      // 处理 surface 相关回调
      if (a2uiMessage is genui.SurfaceUpdate) {
        final surfaceId = a2uiMessage.surfaceId;
        onSurfaceCreated?.call(surfaceId);
        _checkAndNotifyTransaction(a2uiMessage);
      }
    } catch (e, stackTrace) {
      _logger.severe('[A2UI] ERROR parsing message', e, stackTrace);
      _errorResponseController.add(genui.ContentGeneratorError(e, stackTrace));
    }
  }

  /// Detect transaction success within SurfaceUpdate and notify
  void _checkAndNotifyTransaction(genui.SurfaceUpdate msg) {
    try {
      for (final component in msg.components) {
        for (final entry in component.componentProperties.entries) {
          final componentType = entry.key;
          final props = entry.value as Map<String, dynamic>;

          if (componentType == 'transaction_success' ||
              componentType == 'TransactionSuccess') {
            final amount = (props['amount'] as num?)?.toDouble() ?? 0.0;
            final type = props['transaction_type'] as String? ?? 'expense';
            final currency = props['currency'] as String? ?? 'CNY';

            _logger.info(
              'CustomContentGenerator: Detected transaction success: $amount $currency ($type)',
            );

            onTransactionCreated?.call(amount, type, currency);
          } else if (componentType == 'TransactionGroupReceipt') {
            final summary = props['summary'] as Map<String, dynamic>?;
            if (summary != null) {
              final expenseTotal =
                  (summary['expense_total'] as num?)?.toDouble() ?? 0.0;
              final incomeTotal =
                  (summary['income_total'] as num?)?.toDouble() ?? 0.0;

              if (expenseTotal > 0) {
                onTransactionCreated?.call(expenseTotal, 'expense', 'CNY');
              }
              if (incomeTotal > 0) {
                onTransactionCreated?.call(incomeTotal, 'income', 'CNY');
              }

              _logger.info(
                'CustomContentGenerator: Detected TransactionGroupReceipt: expense=$expenseTotal, income=$incomeTotal',
              );
            }
          }
        }
      }
    } catch (e) {
      _logger.warning(
        'CustomContentGenerator: Error checking transaction auto-update: $e',
      );
    }
  }

  /// Convert ChatMessage to backend API format
  Future<Map<String, dynamic>> _convertMessage(
    genui.ChatMessage message, {
    List<Map<String, dynamic>>? attachments,
  }) async {
    _logger.info(
      'CustomContentGenerator: _convertMessage received message type: ${message.runtimeType}',
    );

    if (message is genui.UserMessage) {
      String messageContent = '';
      for (final part in message.parts) {
        if (part is genui.TextPart) {
          messageContent += part.text;
        }
      }

      _logger.info(
        'CustomContentGenerator: UserMessage content length: ${messageContent.length}',
      );

      if (messageContent.startsWith('{')) {
        try {
          final json = jsonDecode(messageContent) as Map<String, dynamic>;
          if (json.containsKey('userAction')) {
            _logger.info('CustomContentGenerator: Detected UserActionEvent');
            return await _handleUserActionEvent(json, messageContent);
          }
        } catch (e) {
          _logger.info('CustomContentGenerator: JSON parse failed: $e');
        }
      }

      final result = <String, dynamic>{
        'role': 'user',
        'content': messageContent,
      };
      if (attachments != null && attachments.isNotEmpty) {
        result['attachments'] = attachments;
      }
      return result;
    } else if (message is genui.AiTextMessage) {
      return {'role': 'assistant', 'content': message.text};
    } else if (message.runtimeType.toString() == 'UserUiInteractionMessage') {
      String messageContent = '';
      try {
        messageContent = (message as dynamic).text as String;
      } catch (_) {
        try {
          messageContent = (message as dynamic).content as String;
        } catch (e) {
          _logger.warning(
            'CustomContentGenerator: Error accessing properties on UserUiInteractionMessage: $e',
          );
          messageContent = message.toString();
        }
      }

      if (messageContent.startsWith('{')) {
        try {
          final json = jsonDecode(messageContent) as Map<String, dynamic>;
          if (json.containsKey('userAction')) {
            _logger.info(
              'CustomContentGenerator: Detected UserActionEvent from UserUiInteractionMessage',
            );
            return await _handleUserActionEvent(json, messageContent);
          }
        } catch (_) {}
      }
      return {'role': 'user', 'content': messageContent};
    }

    final typeName = message.runtimeType.toString();
    if (typeName.contains('Ai') || typeName.contains('AI')) {
      _logger.info(
        'CustomContentGenerator: Skipping AI message type: $typeName',
      );
      return {'role': 'assistant', 'content': '', '_skip': true};
    }

    String messageContent = '';
    try {
      if ((message as dynamic).text != null) {
        messageContent = (message as dynamic).text as String;
      } else if ((message as dynamic).content != null) {
        messageContent = (message as dynamic).content as String;
      }
    } catch (e) {
      _logger.warning(
        'CustomContentGenerator: Cannot extract text from unknown message type: $typeName',
      );
      return {'role': 'user', 'content': '', '_skip': true};
    }

    if (messageContent.isEmpty) {
      _logger.info(
        'CustomContentGenerator: Empty content from unknown message type: $typeName, skipping',
      );
      return {'role': 'user', 'content': '', '_skip': true};
    }

    _logger.info(
      'CustomContentGenerator: Extracted text from unknown type: $typeName',
    );
    return {'role': 'user', 'content': messageContent};
  }

  /// Handle UserActionEvent and convert to human-readable message
  Future<Map<String, dynamic>> _handleUserActionEvent(
    Map<String, dynamic> rawEventData,
    String rawContent,
  ) async {
    final Map<String, dynamic> eventData =
        rawEventData.containsKey('userAction')
        ? (rawEventData['userAction'] as Map<String, dynamic>)
        : rawEventData;

    final eventName = eventData['name'] as String?;
    final context = eventData['context'] as Map<String, dynamic>?;

    _logger.info('CustomContentGenerator: Handling event: $eventName');
    _logger.info('CustomContentGenerator: Event context: $context');

    if (eventName == 'transfer_path_confirmed') {
      return {
        'role': 'user',
        'content': '按照我的选择执行', // 用户友好的消息，无论后续验证是否通过
        'metadata': {'event_type': 'transfer_path_confirmed', ...context ?? {}},
      };
    }

    if (eventName == 'send_chat_message') {
      final message = context?['message'] as String? ?? '';
      return {'role': 'user', 'content': message};
    }

    if (eventName == 'account_selected' && context != null) {
      final selectedAccountId = context['selected_account_id'] as String?;
      final selectionType = context['selection_type'] as String?;
      final amount = context['amount'];

      final humanReadable =
          'I selected account ID: $selectedAccountId '
          '(${selectionType == "source" ? "source" : "destination"} account).'
          'Please continue to complete the transfer${amount != null ? " with amount $amount" : ""}.';

      _logger.info(
        'CustomContentGenerator: Converted account_selected event to: $humanReadable',
      );

      return {
        'role': 'user',
        'content': humanReadable,
        'metadata': {
          'event_type': 'account_selected',
          'selected_account_id': selectedAccountId,
          'selection_type': selectionType,
          ...context,
        },
      };
    } else if (eventName == 'account_selection_cancelled') {
      _logger.info('CustomContentGenerator: Account selection cancelled');
      return {
        'role': 'user',
        'content':
            'I cancelled account selection, please do not execute this transfer.',
      };
    }

    if (eventName == 'transaction_confirmed') {
      return {
        'role': 'user',
        'content': 'confirm',
        'metadata': {'event_type': 'transaction_confirmed', ...context ?? {}},
      };
    }

    return {'role': 'user', 'content': rawContent};
  }

  @override
  void dispose() {
    unawaited(_a2uiMessageController.close());
    unawaited(_textResponseController.close());
    unawaited(_errorResponseController.close());
    _cancelToken?.cancel('Disposed');
  }
}
