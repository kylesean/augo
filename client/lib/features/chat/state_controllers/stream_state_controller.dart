// features/chat/state_controllers/stream_state_controller.dart
//
// Stream State Controller
// Extracted from ChatHistory to manage SSE streaming state
//
// Design Principles:
// - Centralized management of all streaming-related flags
// - Clean state transitions with validation
// - Easy to test and reason about

import 'package:logging/logging.dart';

/// Represents the current state of streaming
enum StreamPhase {
  /// No active stream
  idle,

  /// Waiting for first response chunk
  waitingForFirstChunk,

  /// Receiving and processing chunks
  streaming,

  /// Stream completed successfully
  completed,

  /// Stream ended with error
  error,

  /// User cancelled the stream
  cancelled,
}

/// Stream State Controller
///
/// Manages all streaming-related state flags in a centralized way:
/// - Stream lifecycle phases
/// - First chunk detection
/// - Message completion status
/// - User cancellation tracking
class StreamStateController {
  final _logger = Logger('StreamStateController');

  /// Current streaming phase
  StreamPhase _currentPhase = StreamPhase.idle;

  /// Current streaming message ID
  String _currentMessageId = '';

  /// Last received event type (for debugging)
  String? _lastEventType;

  // ============================================================
  // Public Getters
  // ============================================================

  /// Get current streaming phase
  StreamPhase get currentPhase => _currentPhase;

  /// Get current streaming message ID
  String get currentMessageId => _currentMessageId;

  /// Check if currently streaming
  bool get isStreaming =>
      _currentPhase == StreamPhase.waitingForFirstChunk ||
      _currentPhase == StreamPhase.streaming;

  /// Check if first chunk has been received
  bool get isFirstChunkReceived => _currentPhase == StreamPhase.streaming;

  /// Check if waiting for first chunk
  bool get isWaitingForFirstChunk =>
      _currentPhase == StreamPhase.waitingForFirstChunk;

  /// Check if stream is done (completed, error, or cancelled)
  bool get isStreamDone =>
      _currentPhase == StreamPhase.completed ||
      _currentPhase == StreamPhase.error ||
      _currentPhase == StreamPhase.cancelled;

  /// Check if user cancelled
  bool get isUserCancelled => _currentPhase == StreamPhase.cancelled;

  /// Check if message is completed
  bool get isMessageCompleted =>
      _currentPhase == StreamPhase.completed ||
      _currentPhase == StreamPhase.error ||
      _currentPhase == StreamPhase.cancelled;

  /// Get last event type
  String? get lastEventType => _lastEventType;

  // ============================================================
  // Public Methods - State Transitions
  // ============================================================

  /// Start a new streaming session
  void startStreaming(String messageId) {
    _logger.info(
      'StreamStateController: Starting streaming for message $messageId',
    );
    _currentMessageId = messageId;
    _currentPhase = StreamPhase.waitingForFirstChunk;
    _lastEventType = null;
  }

  /// Mark first chunk received
  void markFirstChunkReceived() {
    if (_currentPhase == StreamPhase.waitingForFirstChunk) {
      _logger.info('StreamStateController: First chunk received');
      _currentPhase = StreamPhase.streaming;
    }
  }

  /// Record event type
  void recordEventType(String eventType) {
    _lastEventType = eventType;
  }

  /// Mark stream as completed
  void markCompleted() {
    _logger.info('StreamStateController: Stream completed');
    _currentPhase = StreamPhase.completed;
  }

  /// Mark stream as error
  void markError() {
    _logger.info('StreamStateController: Stream error');
    _currentPhase = StreamPhase.error;
  }

  /// Mark stream as cancelled by user
  void markCancelled() {
    _logger.info('StreamStateController: Stream cancelled by user');
    _currentPhase = StreamPhase.cancelled;
  }

  /// Reset to idle state
  void reset() {
    _logger.info('StreamStateController: Reset to idle');
    _currentPhase = StreamPhase.idle;
    _currentMessageId = '';
    _lastEventType = null;
  }

  // ============================================================
  // Debug Methods
  // ============================================================

  /// Get debug info string
  String get debugInfo =>
      'StreamStateController[phase=$_currentPhase, messageId=$_currentMessageId, lastEvent=$_lastEventType]';

  @override
  String toString() => debugInfo;
}
