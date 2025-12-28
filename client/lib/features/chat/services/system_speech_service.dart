// features/chat/services/system_speech_service.dart
import 'dart:async';
import 'package:logging/logging.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'speech_recognition_service.dart';

/// System speech recognition service
///
/// Based on speech_to_text library implementation, using device's built-in speech recognition service.
/// Supports iOS, Android, and Web platforms.
class SystemSpeechService implements SpeechRecognitionService {
  static final _logger = Logger('SystemSpeechService');

  final SpeechToText _speech = SpeechToText();
  bool _isInitialized = false;
  bool _isListening = false;

  // Stream controllers for different events
  final StreamController<String> _resultController =
      StreamController<String>.broadcast();
  final StreamController<String> _statusController =
      StreamController<String>.broadcast();
  final StreamController<String> _errorController =
      StreamController<String>.broadcast();

  /// Recognition language, default Chinese
  final String localeId;

  /// Constructor
  ///
  /// [localeId] Recognition language, default is 'zh_CN' (Chinese)
  SystemSpeechService({this.localeId = 'zh_CN'});

  @override
  Stream<String> get onResult => _resultController.stream;

  @override
  Stream<String> get onStatus => _statusController.stream;

  @override
  Stream<String> get onError => _errorController.stream;

  @override
  bool get isListening => _isListening;

  @override
  bool get isInitialized => _isInitialized;

  @override
  SpeechServiceType get serviceType => SpeechServiceType.system;

  @override
  bool get isIncrementalResult => false; // System speech is replacement mode, not incremental

  @override
  Future<bool> hasPermission() async {
    // speech_to_text checks permissions during initialize
    // Return initialization status as approximate permission check
    if (_isInitialized) return true;

    try {
      // Try to initialize to check permissions
      final available = await _speech.initialize(
        onStatus: (_) {},
        onError: (_) {},
      );
      return available;
    } catch (e) {
      _logger.warning('Permission check failed: $e');
      return false;
    }
  }

  @override
  Future<bool> requestPermission() async {
    // speech_to_text automatically requests permission during initialize
    return await hasPermission();
  }

  @override
  Future<bool> ensureReady() async {
    // For system speech, just ensure initialized
    if (_isInitialized) return true;
    return await initialize();
  }

  @override
  Future<bool> initialize() async {
    if (_isInitialized) {
      _logger.info(
        'System speech service already initialized, reusing existing instance',
      );
      return true;
    }

    try {
      _logger.info('Initializing system speech recognition service...');
      _statusController.add('connecting');

      final available = await _speech.initialize(
        onStatus: _onStatus,
        onError: _onError,
        debugLogging: false,
      );

      if (available) {
        _isInitialized = true;
        _statusController.add('connected');
        _logger.info(
          'System speech recognition service initialized successfully',
        );

        // Get available language list
        final locales = await _speech.locales();
        _logger.info(
          'Available languages: ${locales.map((l) => l.localeId).join(', ')}',
        );
      } else {
        _statusController.add('disconnected');
        _logger.warning('System speech recognition service unavailable');
      }

      return available;
    } catch (e) {
      _logger.severe(
        'System speech recognition service initialization failed: $e',
      );
      _statusController.add('error');
      _errorController.add('Initialization failed: $e');
      return false;
    }
  }

  @override
  Future<void> startListening() async {
    if (!_isInitialized) {
      _logger.warning('Service not initialized, cannot start listening');
      _errorController.add('Service not initialized');
      return;
    }

    if (_isListening) {
      _logger.warning('Already listening');
      return;
    }

    try {
      _logger.info('Starting system speech recognition...');
      _isListening = true;
      _statusController.add('listening');

      await _speech.listen(
        onResult: _onResult,
        localeId: localeId,
        listenFor: const Duration(
          seconds: 30,
        ), // Maximum listening time 30 seconds
        pauseFor: const Duration(
          seconds: 3,
        ), // Automatically end after 3 seconds of pause
        listenOptions: SpeechListenOptions(
          listenMode: ListenMode.dictation,
          cancelOnError: false,
          partialResults: true,
        ),
      );

      _logger.info('System speech recognition started');
    } catch (e) {
      _logger.severe('Failed to start listening: $e');
      _isListening = false;
      _statusController.add('error');
      _errorController.add('Failed to start listening: $e');
    }
  }

  @override
  Future<void> stopListening() async {
    if (!_isListening) {
      return;
    }

    try {
      _logger.info('Stopping system speech recognition...');
      await _speech.stop();
      _isListening = false;
      _statusController.add('stopped');
      _logger.info('System speech recognition stopped');
    } catch (e) {
      _logger.severe('Failed to stop listening: $e');
      _isListening = false;
      _statusController.add('error');
      _errorController.add('Failed to stop listening: $e');
    }
  }

  /// Handle recognition results
  ///
  /// speech_to_text's partialResults returns accumulated text.
  /// Only push final results to avoid conflicts with WebSocket incremental mode processing logic.
  void _onResult(SpeechRecognitionResult result) {
    final recognizedWords = result.recognizedWords;

    if (recognizedWords.isEmpty) return;

    _logger.info(
      'Recognition result: $recognizedWords (final: ${result.finalResult})',
    );

    // Only push on final result
    if (result.finalResult) {
      _resultController.add(recognizedWords);
      _isListening = false;
      _statusController.add('stopped');
    }
  }

  /// Handle status changes
  void _onStatus(String status) {
    _logger.info('System speech status: $status');

    // Map speech_to_text status to our status
    switch (status) {
      case 'listening':
        _isListening = true;
        _statusController.add('listening');
        break;
      case 'notListening':
        _isListening = false;
        _statusController.add('stopped');
        break;
      case 'done':
        _isListening = false;
        _statusController.add('stopped');
        break;
      default:
        _statusController.add(status);
    }
  }

  /// Handle errors
  void _onError(SpeechRecognitionError error) {
    _logger.severe('System speech error: ${error.errorMsg}');
    _isListening = false;

    // Handle common errors
    // Note: no-speech is normal behavior for Android system speech recognition (user timeout),
    // should not be pushed to user as an error, just silently end listening
    if (error.errorMsg.contains('no-speech')) {
      _logger.info(
        'no-speech: User did not speak or paused, silently end listening',
      );
      _statusController.add('stopped');
      return; // Don't push error to avoid showing "no speech detected"
    }

    String userMessage;
    if (error.errorMsg.contains('audio')) {
      userMessage = 'Audio capture error, please check microphone permissions';
    } else if (error.errorMsg.contains('network')) {
      userMessage = 'Network error, please check network connection';
    } else {
      userMessage = 'Speech recognition error: ${error.errorMsg}';
    }

    _errorController.add(userMessage);
    _statusController.add('error');
  }

  @override
  Future<void> dispose() async {
    _logger.info('Releasing system speech service resources');

    if (_isListening) {
      await _speech.stop();
    }
    await _speech.cancel();

    _isListening = false;
    _isInitialized = false;

    // Close stream controllers
    if (!_resultController.isClosed) _resultController.close();
    if (!_statusController.isClosed) _statusController.close();
    if (!_errorController.isClosed) _errorController.close();
  }
}
