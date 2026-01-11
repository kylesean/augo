import 'package:logging/logging.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/exceptions/app_exception.dart';
import '../../../core/network/sse_client.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../../../core/network/dio_provider.dart' show sseDioProvider;
import 'genui_sse_parser.dart';

// Export ParsedSseEvent and SseEventType for other files to use
export 'genui_sse_parser.dart' show ParsedSseEvent, SseEventType;

/// AI Service for handling chat streaming with the backend.
///
/// Uses custom SseClient implementation, supports:
/// - POST request with JSON body
/// - Smart reconnection mechanism (preserves original request body)
/// - Exponential backoff retry
class AIService {
  final _logger = Logger('AIService');
  final SecureStorageService _storageService;
  final Dio _dio;
  final String _sseBaseUrl;
  final String _baseUrl;

  // Used to track current active SSE connection
  SseClient? _currentSseClient;
  StreamController<ParsedSseEvent>? _currentController;

  AIService(
    this._storageService,
    this._dio, {
    required String sseBaseUrl,
    required String baseUrl,
  }) : _sseBaseUrl = sseBaseUrl,
       _baseUrl = baseUrl;

  /// Stream AI response for a chat message.
  ///
  /// [userMessage] - The user's message content
  /// [sessionId] - Optional session ID. If null, backend creates a new session.
  /// [attachments] - Optional list of attachment references
  ///
  /// Returns a Stream of parsed SSE events.
  Future<Stream<ParsedSseEvent>> streamAIResponse(
    String userMessage, {
    String? sessionId,
    List<Map<String, dynamic>>? attachments,
  }) async {
    // First close any existing connection
    await closeConnection();

    final controller = StreamController<ParsedSseEvent>();
    _currentController = controller;

    bool isClosed = false;

    // Always use user's access token
    _logger.info("AIService: ========== AUTHENTICATION ==========");
    final token = await _storageService.getToken();
    if (token == null || token.isEmpty) {
      _logger.info("AIService: ERROR - No auth token found!");
      controller.addError("User not logged in or token invalid.");
      unawaited(controller.close());
      return controller.stream;
    }
    _logger.info("AIService: Using access token for authentication");
    _logger.info("AIService: Session ID: ${sessionId ?? 'null (new session)'}");
    _logger.info("AIService: =====================================");

    final String sseUrl = "$_sseBaseUrl${ApiConstants.aiChatSseEndpoint}";

    final Map<String, String> headers = {
      "Accept": "text/event-stream",
      "Cache-Control": "no-cache",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    // Build request body - session_id in request body
    final Map<String, dynamic> message = {
      "role": "user",
      "content": userMessage,
    };

    // If there are attachments, add them to the message
    if (attachments != null && attachments.isNotEmpty) {
      message["attachments"] = attachments;
      _logger.info(
        "AIService: Including ${attachments.length} attachments in request",
      );
    }

    final Map<String, dynamic> requestBody = {
      "messages": [message],
      "session_id": sessionId, // null for new session, backend will create one
    };

    _logger.info("AIService: Request body: ${requestBody.toString()}");
    _logger.info("AIService: Starting SSE connection...");

    controller.onCancel = () {
      if (!isClosed) {
        isClosed = true;
        _currentSseClient?.close();
        if (!controller.isClosed) {
          controller.close();
        }
        _logger.info("AIService: Stream cancelled by listener");
      }
    };

    try {
      // Use custom SseClient
      final sseClient = SseClient(
        url: sseUrl,
        headers: headers,
        body: requestBody,
        maxRetries: 3,
        initialRetryDelay: const Duration(seconds: 1),
        dio: _dio,
      );
      _currentSseClient = sseClient;

      // Listen to SSE events
      sseClient.stream.listen(
        (SseEvent event) {
          if (isClosed || event.data == null || event.data!.isEmpty) return;

          try {
            // Use GenUiSseParser to parse events
            final parsedEvent = GenUiSseParser.parse(event.data!);

            // Handle error events
            if (parsedEvent.isError) {
              _logger.info(
                "AIService: Received error event: ${parsedEvent.errorMessage}",
              );
              if (!isClosed) {
                controller.addError(
                  parsedEvent.errorMessage ?? "Unknown SSE error",
                );
              }
              return;
            }

            // Handle different types of events
            switch (parsedEvent.type) {
              case SseEventType.text:
                _logger.info(
                  "AIService: Text event - content: ${parsedEvent.content}",
                );
                controller.add(parsedEvent);
                break;

              // A2UI protocol events
              case SseEventType.a2uiMessage:
                _logger.info("AIService: A2UI message event");
                controller.add(parsedEvent);
                break;

              case SseEventType.sessionInit:
                _logger.info("AIService: Session init event");
                controller.add(parsedEvent);
                break;

              case SseEventType.titleUpdate:
                _logger.info(
                  "AIService: Title update event - title: ${parsedEvent.title}",
                );
                controller.add(parsedEvent);
                break;

              case SseEventType.done:
                _logger.info("AIService: Done event received");
                controller.add(parsedEvent);
                if (!isClosed) {
                  isClosed = true;
                  controller.close();
                  sseClient.close();
                  _logger.info("AIService: Stream completed (done event)");
                }
                break;

              case SseEventType.unknown:
                _logger.info("AIService: Unknown event type, skipping");
                break;

              case SseEventType.error:
                // Already handled above
                break;
            }

            // Check if completed (compatible with old done field)
            if (parsedEvent.done && parsedEvent.type != SseEventType.done) {
              if (!isClosed) {
                isClosed = true;
                controller.close();
                sseClient.close();
                _logger.info("AIService: Stream completed (done: true)");
              }
            }
          } catch (e) {
            if (!isClosed) {
              _logger.info("AIService: Error processing SSE event data: $e");
              controller.addError("SSE data parsing error: ${e.toString()}");
            }
          }
        },
        onError: (error) {
          _logger.info("AIService: ===== SSE ERROR =====");
          _logger.info("AIService: Error: $error");
          _logger.info("AIService: ====================");
          if (isClosed) return;
          isClosed = true;
          controller.addError(
            NetworkException("SSE stream error: ${error.toString()}"),
          );
          if (!controller.isClosed) controller.close();
        },
        onDone: () {
          _logger.info("AIService: ===== SSE STREAM DONE =====");
          if (!isClosed) {
            isClosed = true;
            if (!controller.isClosed) {
              controller.close();
            }
            _logger.info("AIService: Stream closed normally");
          }
        },
      );

      // Start connection
      await sseClient.connect();
    } catch (e, stackTrace) {
      _logger.info("AIService: ===== EXCEPTION CREATING SSE CONNECTION =====");
      _logger.info("AIService: Exception: $e");
      _logger.info("AIService: StackTrace: $stackTrace");
      _logger.info("AIService: =============================================");
      controller.addError("Failed to create SSE connection: ${e.toString()}");
      unawaited(controller.close());
      return controller.stream;
    }

    return controller.stream;
  }

  /// Public method to manually close connection
  Future<void> closeConnection() async {
    if (_currentSseClient != null) {
      _logger.info("AIService: Closing existing SSE connection");
      _currentSseClient!.close();
      _currentSseClient = null;
    }

    if (_currentController != null && !_currentController!.isClosed) {
      _logger.info("AIService: Closing existing controller");
      unawaited(_currentController!.close());
      _currentController = null;
    }
  }

  /// Cancel the last turn and clean up checkpoint state.
  Future<bool> cancelLastTurn(String sessionId) async {
    try {
      final token = await _storageService.getToken();
      if (token == null || token.isEmpty) {
        _logger.info("AIService: cancelLastTurn - No auth token");
        return false;
      }

      final url = "$_baseUrl/chatbot/sessions/$sessionId/cancel";

      _logger.info(
        "AIService: Calling cancel endpoint for session: $sessionId",
      );

      final response = await _dio.post(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final body = response.data as Map<String, dynamic>;
        if (body['code'] == 0) {
          final data = body['data'] as Map<String, dynamic>?;
          final removedCount = data?['removed_count'] ?? 0;
          _logger.info(
            "AIService: Cancel successful, removed $removedCount messages",
          );
          return true;
        }
      }
      _logger.info("AIService: Cancel failed - ${response.statusMessage}");
      return false;
    } catch (e) {
      _logger.info("AIService: cancelLastTurn error - $e");
      return false;
    }
  }
}

// AIService Provider
final aiServiceProvider = Provider<AIService>((ref) {
  final storageService = ref.watch(secureStorageServiceProvider);
  // 使用 SSE 专用 Dio 实例（无 receiveTimeout 限制）
  final dio = ref.watch(sseDioProvider);
  final apiConstants = ref.watch(apiConstantsProvider);
  return AIService(
    storageService,
    dio,
    sseBaseUrl: apiConstants.sseBaseUrl,
    baseUrl: apiConstants.baseUrl,
  );
});
