// features/chat/services/speech_recognition_service.dart
import 'dart:async';

/// Speech recognition service type
enum SpeechServiceType {
  /// System speech recognition (using device's built-in speech recognition service)
  system,

  /// WebSocket ASR service (self-built speech recognition service)
  websocket,
}

/// Speech recognition service abstract interface
///
/// Defines a unified API for speech recognition services, supporting different speech recognition backend implementations.
/// Uses the strategy pattern to allow switching between different speech recognition services at runtime.
abstract class SpeechRecognitionService {
  /// Recognition result stream
  ///
  /// When the speech recognition engine returns a new recognition result, it will be pushed through this stream.
  Stream<String> get onResult;

  /// Status change stream
  ///
  /// Status includes: 'connecting', 'connected', 'listening', 'stopped', 'disconnected', 'error'
  Stream<String> get onStatus;

  /// Error message stream
  ///
  /// When an error occurs, the error description will be pushed through this stream.
  Stream<String> get onError;

  /// Whether currently listening
  bool get isListening;

  /// Whether initialized
  bool get isInitialized;

  /// Service type
  SpeechServiceType get serviceType;

  /// Whether result is incremental mode
  ///
  /// - true: Incremental mode (WebSocket), each push contains new recognition content, needs to be appended to existing text
  /// - false: Replacement mode (system speech), each push contains complete cumulative result, needs to be directly replaced
  ///
  /// This identifier helps the UI layer correctly handle results from different services.
  bool get isIncrementalResult;

  /// Initialize service
  ///
  /// Returns whether initialization was successful. For system speech, this initializes the speech recognition engine;
  /// For WebSocket service, this establishes the connection.
  Future<bool> initialize();

  /// Check microphone permission
  Future<bool> hasPermission();

  /// Request microphone permission
  Future<bool> requestPermission();

  /// Start speech recognition
  ///
  /// Start listening to microphone input and perform speech recognition.
  /// Recognition results will be pushed through the [onResult] stream.
  Future<void> startListening();

  /// Stop speech recognition
  ///
  /// Stop listening to microphone input.
  Future<void> stopListening();

  /// Release resources
  ///
  /// Release all service-related resources, including closing connections, stopping recording, etc.
  Future<void> dispose();
}
