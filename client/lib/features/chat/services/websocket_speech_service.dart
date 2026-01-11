// features/chat/services/websocket_speech_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:logging/logging.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:permission_handler/permission_handler.dart';
import '../config/speech_config.dart';
import 'audio_recorder_service.dart';
import 'speech_recognition_service.dart';
import 'sound_feedback_service.dart';

class WebSocketSpeechService implements SpeechRecognitionService {
  static final _logger = Logger('WebSocketSpeechService');

  final String host;
  final int port;
  final String path;

  WebSocketChannel? _channel;
  bool _isConnected = false;
  bool _isListening = false;
  bool _isManualStop = false; // User manual stop protection flag

  // Audio recording service
  final AudioRecorderService _audioRecorder = AudioRecorderService();
  StreamSubscription<Uint8List>? _audioSubscription;

  // Stream controllers for different events
  final StreamController<String> _resultController =
      StreamController<String>.broadcast();
  final StreamController<String> _statusController =
      StreamController<String>.broadcast();
  final StreamController<String> _errorController =
      StreamController<String>.broadcast();

  // Public streams
  @override
  Stream<String> get onResult => _resultController.stream;
  @override
  Stream<String> get onStatus => _statusController.stream;
  @override
  Stream<String> get onError => _errorController.stream;

  @override
  bool get isInitialized => _isConnected;

  @override
  SpeechServiceType get serviceType => SpeechServiceType.websocket;

  @override
  bool get isIncrementalResult => true; // WebSocket is incremental mode

  WebSocketSpeechService({String? host, int? port, String? path})
    : host = host ?? SpeechConfig.host,
      port = port ?? SpeechConfig.port,
      path = path ?? SpeechConfig.path;

  /// Check microphone permission
  @override
  Future<bool> hasPermission() async {
    try {
      return await _audioRecorder.hasPermission();
    } catch (e) {
      _logger.severe('Failed to check microphone permission: $e');
      return false;
    }
  }

  /// Request microphone permission
  @override
  Future<bool> requestPermission() async {
    try {
      final status = await Permission.microphone.request();
      return status == PermissionStatus.granted;
    } catch (e) {
      _logger.severe('Failed to request microphone permission: $e');
      return false;
    }
  }

  /// Initialize WebSocket connection
  @override
  Future<bool> initialize() async {
    // If already connected, return success directly (simplified logic, avoid ping test issues)
    if (_isConnected && _channel != null) {
      _logger.info('WebSocket already connected, reusing existing connection');
      return true;
    }

    // Clean up previous connection
    await _cleanup();

    try {
      _logger.info('Connecting to WebSocket server: ws://$host:$port$path');
      _statusController.add('connecting');

      final uri = Uri.parse('ws://$host:$port$path');
      _channel = IOWebSocketChannel.connect(uri);

      // Listen to connection status, add timeout mechanism (10 seconds)
      await _channel!.ready.timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('WebSocket connection timeout (10 seconds)');
        },
      );
      _isConnected = true;
      _statusController.add('connected');
      _logger.info('WebSocket connected successfully');

      // Listen to messages
      _channel!.stream.listen(
        _onMessage,
        onError: _onError,
        onDone: _onDisconnected,
      );

      return true;
    } catch (e) {
      _logger.severe('WebSocket connection failed: $e');
      _errorController.add('Connection failed: $e');
      _statusController.add('disconnected');
      _isConnected = false;
      return false;
    }
  }

  @override
  Future<bool> ensureReady() async {
    // If already connected, return immediately
    if (_isConnected && _channel != null) {
      _logger.info('WebSocket already connected, ready for recognition');
      return true;
    }

    // Otherwise, try to connect/reconnect
    _logger.info('WebSocket not connected, attempting to connect...');
    return await initialize();
  }

  /// Clean up connection resources
  Future<void> _cleanup() async {
    if (_isListening) {
      await _audioRecorder.stopRecording();
      await _audioSubscription?.cancel();
      _audioSubscription = null;
      _isListening = false;
    }

    if (_channel != null) {
      try {
        await _channel!.sink.close();
      } catch (e) {
        _logger.warning('Error closing WebSocket connection: $e');
      }
      _channel = null;
    }

    _isConnected = false;
  }

  /// Start speech recognition
  @override
  Future<void> startListening() async {
    if (!_isConnected) {
      _logger.warning('WebSocket not connected, cannot start listening');
      _errorController.add('WebSocket not connected');
      return;
    }

    if (_isListening) {
      _logger.warning('Already listening');
      return;
    }

    try {
      _logger.info('Starting speech recognition process...');

      // 1. Check permissions
      final hasPermission = await this.hasPermission();
      if (!hasPermission) {
        _logger.severe('Microphone permission denied');
        _errorController.add(
          'Microphone permission denied, please authorize in system settings',
        );
        return;
      }

      // 2. Start recording
      // 音效已在 ChatInputNotifier 中播放，这里直接开始录音
      final recordingStarted = await _audioRecorder.startRecording();
      if (!recordingStarted) {
        _logger.severe('Failed to start recording');
        _errorController.add('Failed to start recording');
        return;
      }

      // 3. Listen to audio stream and send to WebSocket
      final audioStream = _audioRecorder.audioStream;
      if (audioStream != null) {
        _audioSubscription = audioStream.listen(
          (audioData) {
            _logger.info('Sending audio data: ${audioData.length} bytes');
            sendAudioData(audioData);
          },
          onError: (error) {
            // Some platforms may trigger errors when stopping recording, ignore during manual stop or non-listening state
            if (_isManualStop || !_isListening) {
              _logger.info(
                'Ignoring audio stream error during manual stop: $error',
              );
              return;
            }
            _logger.severe('Audio stream error: $error');
            _errorController.add('Recording error: $error');
          },
          onDone: () {
            _logger.info('Audio stream ended');
          },
        );
      }

      // Note: ASR server expects pure binary audio data only
      // Do not send JSON control messages as they will be misinterpreted as audio data

      _isListening = true;
      _statusController.add('listening');
      _logger.info('Speech recognition started');
    } catch (e) {
      _logger.severe('Failed to start listening: $e');
      _errorController.add('Failed to start listening: $e');
      _isListening = false;
      _statusController.add('error');

      // Clean up resources
      await _audioRecorder.stopRecording();
      await _audioSubscription?.cancel();
      _audioSubscription = null;
    }
  }

  /// Stop speech recognition
  @override
  Future<void> stopListening() async {
    if (!_isListening) {
      return;
    }

    try {
      _logger.info('Stopping speech recognition process...');

      // 1. Mark as manual stop and stop recording
      _isManualStop = true;
      await _audioRecorder.stopRecording();

      // 2. Cancel audio stream subscription
      await _audioSubscription?.cancel();
      _audioSubscription = null;

      // Note: ASR server expects pure binary audio data only
      // Do not send JSON control messages as they will be misinterpreted as audio data

      _isListening = false;
      _statusController.add('stopped');
      _logger.info('Speech recognition stopped');

      // 播放结束录音提示音（不等待，避免阻塞）
      _logger.info('Playing stop sound...');
      unawaited(SoundFeedbackService.instance.playStopSound());
    } catch (e) {
      _logger.severe('Failed to stop listening: $e');
      _errorController.add('Failed to stop listening: $e');
      _isListening = false;
      _statusController.add('error');
    }
  }

  /// Send audio data to WebSocket
  void sendAudioData(Uint8List audioData) {
    if (!_isConnected || !_isListening) {
      return;
    }

    try {
      // Send binary audio data directly
      _channel!.sink.add(audioData);
    } catch (e) {
      _logger.severe('Failed to send audio data: $e');
      _errorController.add('Failed to send audio data: $e');
    }
  }

  /// Handle received messages
  void _onMessage(dynamic message) {
    try {
      _logger.info('Received message: $message');

      // If message is plain text, use directly as recognition result
      if (message is String) {
        // Try to parse as JSON
        try {
          final jsonData = jsonDecode(message);
          if (jsonData is Map<String, dynamic>) {
            // Handle JSON format messages
            _handleJsonMessage(jsonData);
          } else {
            // Use directly as recognition result
            _resultController.add(message);
          }
        } catch (e) {
          // Not JSON format, use directly as recognition result
          _resultController.add(message);
        }
      } else {
        // Other format messages
        _resultController.add(message.toString());
      }
    } catch (e) {
      _logger.severe('Failed to process message: $e');
      _errorController.add('Failed to process message: $e');
    }
  }

  /// Handle JSON format messages
  void _handleJsonMessage(Map<String, dynamic> jsonData) {
    // Handle different types of messages based on backend protocol
    final type = jsonData['type'] ?? jsonData['action'];

    switch (type) {
      case 'result':
      case 'recognition_result':
        final text = jsonData['text'] ?? jsonData['result'] ?? '';
        if (text.isNotEmpty) {
          _resultController.add(text);
        }
        break;
      case 'status':
        final status = jsonData['status'] ?? '';
        if (status.isNotEmpty) {
          _statusController.add(status);
        }
        break;
      case 'error':
        final error =
            jsonData['error'] ?? jsonData['message'] ?? 'Unknown error';
        // Ignore errors from server during manual stop or non-listening state
        if (_isManualStop || !_isListening) {
          _logger.info(
            'Ignoring server error during manual stop or non-listening state: $error',
          );
          break;
        }
        _errorController.add(error);
        break;
      default:
        // If there is a text field, use as recognition result
        final text = jsonData['text'] ?? jsonData['result'];
        if (text != null && text.toString().isNotEmpty) {
          _resultController.add(text.toString());
        }
    }
  }

  /// Handle connection errors
  void _onError(Object error) {
    _logger.severe('WebSocket error: $error');

    // If disconnect caused by user manual stop, ignore error
    if (_isManualStop) {
      _logger.info(
        'WebSocket error caused by user manual stop, ignoring: $error',
      );
      _isManualStop = false; // Reset flag
      _statusController.add('disconnected');
      _isConnected = false;
      _isListening = false;
      return;
    }

    _errorController.add('Connection error: $error');
    _statusController.add('error');
    _isConnected = false;
    _isListening = false;
  }

  /// Handle connection disconnect
  void _onDisconnected() {
    _logger.info('WebSocket connection disconnected');

    // If disconnect caused by user manual stop, treat as normal flow, don't dispatch error
    if (_isManualStop) {
      _logger.info('Disconnect caused by user manual stop, ignoring error');
      _isManualStop = false; // Reset flag
    } else if (_isListening && !_errorController.isClosed) {
      // Only dispatch error if abnormal disconnect and currently listening
      _errorController.add('Connection unexpectedly disconnected');
    }

    // Only add status if controller is not closed (could be called after dispose)
    if (!_statusController.isClosed) {
      _statusController.add('disconnected');
    }
    _isConnected = false;
    _isListening = false;

    // Clean up audio related resources
    _audioRecorder.stopRecording().catchError((e) {
      _logger.warning('Error stopping recording: $e');
    });
    _audioSubscription?.cancel();
    _audioSubscription = null;
  }

  /// Release resources
  @override
  Future<void> dispose() async {
    _logger.info('Releasing WebSocketSpeechService resources');

    // Use unified cleanup method
    await _cleanup();

    // Release audio recording service
    _audioRecorder.dispose();

    // Close stream controllers
    if (!_resultController.isClosed) unawaited(_resultController.close());
    if (!_statusController.isClosed) unawaited(_statusController.close());
    if (!_errorController.isClosed) unawaited(_errorController.close());
  }

  /// Get connection status
  bool get isConnected => _isConnected;

  /// Get listening status
  @override
  bool get isListening => _isListening;
}
