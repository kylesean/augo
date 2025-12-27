// features/chat/state_controllers/streaming_controller.dart
//
// Streaming Controller
// Extracted from ChatHistory to manage SSE streaming lifecycle
//
// Design Principles:
// - Encapsulates all streaming-related logic
// - Uses callbacks to communicate with host (ChatHistory)
// - Manages timers, cancellation, and stream state
//

import 'dart:async';
import 'package:logging/logging.dart';

import '../models/chat_message.dart' show StreamingStatus;
import '../services/genui_service.dart';
import 'stream_state_controller.dart';

final _logger = Logger('StreamingController');

/// Callbacks for streaming events
typedef OnStreamingStartCallback = void Function();
typedef OnTextReceivedCallback = void Function(String text);
typedef OnStreamCompleteCallback = void Function(String? finalTextOverride);
typedef OnStreamErrorCallback = void Function(dynamic error);
typedef OnStreamCancelledCallback = void Function(bool hasContent);
typedef OnInitialDelayExceededCallback = void Function();
typedef UpdateMessageStateCallback =
    void Function({
      required String id,
      String? content,
      bool? isTyping,
      StreamingStatus? streamingStatus,
    });
typedef GetCurrentMessageContentCallback = String Function(String messageId);

/// Streaming Controller Configuration
class StreamingConfig {
  /// Initial delay before showing "AI is thinking..." (ms)
  final int initialDelayMs;

  /// Cancel wait timeout (seconds)
  final int cancelTimeoutSeconds;

  const StreamingConfig({
    this.initialDelayMs = 700,
    this.cancelTimeoutSeconds = 2,
  });

  static const defaultConfig = StreamingConfig();
}

/// Streaming Controller
///
/// Manages SSE streaming lifecycle, including:
/// - Stream startup and monitoring
/// - Timer management (initial delay)
/// - Cancellation handling
/// - Error and completion handling
class StreamingController {
  /// Configuration
  final StreamingConfig config;

  /// GenUI service reference (injected)
  GenUiService? _genUiService;

  /// Stream state controller reference (injected)
  final StreamStateController streamState;

  /// Current streaming message ID
  String _currentMessageId = '';

  /// Timer for initial response delay
  Timer? _initialResponseDelayTimer;

  /// Stream subscription
  StreamSubscription<dynamic>? _streamSubscription;

  /// Pending cancel completer (for tracking cancel operation)
  Completer<void>? _pendingCancelCompleter;

  /// Internal flags (kept for backward compatibility during migration)
  bool _streamIsDone = false;
  bool _isFirstChunkReceived = false;
  bool _isMessageCompleted = false;
  bool _isUserCancelled = false;

  // ============================================================
  // Callbacks
  // ============================================================

  /// Called when streaming should update message state
  final UpdateMessageStateCallback onUpdateMessageState;

  /// Called to get current message content
  final GetCurrentMessageContentCallback getCurrentMessageContent;

  /// Called when initial delay is exceeded (show "thinking...")
  final OnInitialDelayExceededCallback onInitialDelayExceeded;

  /// Called when stream completes successfully
  final OnStreamCompleteCallback onStreamComplete;

  /// Called when stream encounters error
  final OnStreamErrorCallback onStreamError;

  /// Called when user cancels stream
  final OnStreamCancelledCallback onStreamCancelled;

  StreamingController({
    this.config = StreamingConfig.defaultConfig,
    required this.streamState,
    required this.onUpdateMessageState,
    required this.getCurrentMessageContent,
    required this.onInitialDelayExceeded,
    required this.onStreamComplete,
    required this.onStreamError,
    required this.onStreamCancelled,
  });

  // ============================================================
  // Public Getters
  // ============================================================

  /// Get current streaming message ID
  String get currentMessageId => _currentMessageId;

  /// Check if stream is done
  bool get isStreamDone => _streamIsDone;

  /// Check if first chunk received
  bool get isFirstChunkReceived => _isFirstChunkReceived;

  /// Check if message completed
  bool get isMessageCompleted => _isMessageCompleted;

  /// Check if user cancelled
  bool get isUserCancelled => _isUserCancelled;

  /// Check if there's a pending cancel operation
  bool get hasPendingCancel =>
      _pendingCancelCompleter != null && !_pendingCancelCompleter!.isCompleted;

  // ============================================================
  // Public Methods - Initialization
  // ============================================================

  /// Set GenUI service reference
  void setGenUiService(GenUiService? service) {
    _genUiService = service;
  }

  // ============================================================
  // Public Methods - Stream Lifecycle
  // ============================================================

  /// Reset state for a new streaming session
  void resetForNewMessage(String messageId) {
    _currentMessageId = messageId;
    _streamIsDone = false;
    _isFirstChunkReceived = false;
    _isMessageCompleted = false;
    _isUserCancelled = false;

    // Sync with StreamStateController
    streamState.startStreaming(messageId);

    _logger.info('StreamingController: Reset for message $messageId');
  }

  /// Start initial response delay timer
  ///
  /// If first chunk is not received within the delay, triggers callback
  /// to show "AI is thinking..." indicator
  void startInitialDelayTimer() {
    _initialResponseDelayTimer?.cancel();
    _initialResponseDelayTimer = Timer(
      Duration(milliseconds: config.initialDelayMs),
      () {
        if (!_isFirstChunkReceived) {
          _logger.info(
            'StreamingController: Initial delay exceeded, showing thinking indicator',
          );
          onInitialDelayExceeded();
        }
      },
    );
  }

  /// Handle incoming text chunk
  ///
  /// Returns true if this was the first chunk
  bool handleTextChunk(String text) {
    if (text.isEmpty) return false;

    _initialResponseDelayTimer?.cancel();

    final isFirst = !_isFirstChunkReceived;
    if (isFirst) {
      _isFirstChunkReceived = true;
      streamState.markFirstChunkReceived();
      _logger.info('StreamingController: First chunk received');
    }

    return isFirst;
  }

  /// Mark first chunk as received (for UI components)
  void markFirstChunkReceived() {
    if (!_isFirstChunkReceived) {
      _isFirstChunkReceived = true;
      streamState.markFirstChunkReceived();
    }
  }

  /// Manually mark message as completed
  void markMessageCompleted() {
    _isMessageCompleted = true;
  }

  /// Mark stream as ended (without triggering callbacks)
  void markStreamEnded({bool isError = false}) {
    _initialResponseDelayTimer?.cancel();
    _streamIsDone = true;
    _isMessageCompleted = true;
    if (isError) {
      streamState.markError();
    } else {
      streamState.markCompleted();
    }
    _cleanupAfterStream();
  }

  /// Handle stream completion
  void handleStreamComplete(String? finalTextOverride) {
    _initialResponseDelayTimer?.cancel();
    _streamIsDone = true;
    _isMessageCompleted = true;
    streamState.markCompleted();

    _cleanupAfterStream();
    onStreamComplete(finalTextOverride);
  }

  /// Handle stream error
  void handleStreamError(dynamic error) {
    _initialResponseDelayTimer?.cancel();
    _streamIsDone = true;
    _isMessageCompleted = true;
    streamState.markError();

    _cleanupAfterStream();
    onStreamError(error);
  }

  /// Cancel pending stream (called from UI)
  ///
  /// Returns a Future that completes when cancel operation is done
  Future<void> cancelPendingOperation({
    required Future<bool> Function(String sessionId) cancelLastTurn,
    String? sessionId,
  }) async {
    _logger.info('StreamingController: cancelPendingOperation called');

    // Set cancel flags BEFORE calling cancel()
    // cancel() may synchronously trigger onStreamComplete callback
    _isUserCancelled = true;
    _isMessageCompleted = true;
    _streamIsDone = true;
    streamState.markCancelled();

    // Cancel the GenUI conversation
    if (_genUiService != null && _genUiService!.isInitialized) {
      _genUiService!.conversation.cancel();
    }

    // Cancel timers and subscriptions
    await cancelStreamAndTimers();

    // Reset first chunk flag for next message
    _isFirstChunkReceived = false;

    // Determine if message has content
    final hasContent = getCurrentMessageContent(
      _currentMessageId,
    ).trim().isNotEmpty;

    // Notify about cancellation
    onStreamCancelled(hasContent);

    // Clean checkpoint if session exists
    if (sessionId != null) {
      _logger.info(
        'StreamingController: Calling cancelLastTurn to clean checkpoint',
      );

      _pendingCancelCompleter = Completer<void>();
      final completer = _pendingCancelCompleter!;

      cancelLastTurn(sessionId)
          .then((success) {
            if (success) {
              _logger.info(
                'StreamingController: Checkpoint cleaned successfully',
              );
            } else {
              _logger.info('StreamingController: Checkpoint cleanup failed');
            }
          })
          .catchError((e) {
            _logger.warning('StreamingController: Cancel error: $e');
          })
          .whenComplete(() {
            if (!completer.isCompleted) {
              completer.complete();
            }
            _pendingCancelCompleter = null;
          });
    }

    _logger.info('StreamingController: Pending operation cancelled');
  }

  /// Wait for pending cancel operation to complete
  Future<void> waitForPendingCancel() async {
    if (_pendingCancelCompleter != null &&
        !_pendingCancelCompleter!.isCompleted) {
      _logger.info(
        'StreamingController: Waiting for pending cancel to complete...',
      );
      await _pendingCancelCompleter!.future.timeout(
        Duration(seconds: config.cancelTimeoutSeconds),
        onTimeout: () {
          _logger.info(
            'StreamingController: Cancel wait timeout, proceeding anyway',
          );
        },
      );
      _logger.info('StreamingController: Pending cancel completed');
    }
  }

  /// Cancel stream subscription and timers
  Future<void> cancelStreamAndTimers() async {
    _streamSubscription?.cancel();
    _initialResponseDelayTimer?.cancel();
  }

  /// Dispose controller
  void dispose() {
    cancelStreamAndTimers();
    _pendingCancelCompleter = null;
  }

  // ============================================================
  // Private Methods
  // ============================================================

  /// Cleanup after stream ends
  void _cleanupAfterStream() {
    // Timers already cancelled in individual handlers
    // _currentMessageId will be overwritten on next request
  }
}
