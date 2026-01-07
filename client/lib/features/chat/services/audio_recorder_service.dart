// features/chat/services/audio_recorder_service.dart
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:record/record.dart';

class AudioRecorderService {
  static final _logger = Logger('AudioRecorderService');

  final AudioRecorder _recorder = AudioRecorder();
  Stream<Uint8List>? _audioStream;
  bool _isRecording = false;

  // Get audio data stream
  Stream<Uint8List>? get audioStream => _audioStream;

  bool get isRecording => _isRecording;

  /// Check microphone permission
  Future<bool> hasPermission() async {
    try {
      final hasPermission = await _recorder.hasPermission();
      _logger.info('Microphone permission status: $hasPermission');
      return hasPermission;
    } catch (e) {
      _logger.severe('Failed to check microphone permission: $e');
      return false;
    }
  }

  /// Start recording
  Future<bool> startRecording() async {
    if (_isRecording) {
      _logger.warning('Already recording');
      return true;
    }

    try {
      _logger.info('Starting recording process...');

      // Check permission
      _logger.info('Checking microphone permission...');
      final hasPermission = await this.hasPermission();
      _logger.info('Permission check result: $hasPermission');

      if (!hasPermission) {
        _logger.severe(
          'Microphone permission denied, please authorize in system settings',
        );
        return false;
      }

      // Configure recording parameters
      const config = RecordConfig(
        encoder: AudioEncoder.pcm16bits, // PCM 16-bit
        sampleRate:
            16000, // 16kHz sampling rate, suitable for speech recognition
        numChannels: 1, // Mono
        autoGain: true, // Auto gain
        echoCancel: true, // Echo cancellation
        noiseSuppress: true, // Noise suppression
      );

      _logger.info('Starting recording stream, config: ${config.toString()}');

      // Start recording and get audio stream
      _audioStream = await _recorder.startStream(config);
      _isRecording = true;

      _logger.info('Recording stream created successfully, starting recording');

      return true;
    } catch (e, stackTrace) {
      _logger.severe('Failed to start recording: $e\nStack trace: $stackTrace');
      _isRecording = false;
      return false;
    }
  }

  /// Stop recording
  Future<void> stopRecording() async {
    if (!_isRecording) {
      _logger.warning('Not currently recording');
      return;
    }

    try {
      await _recorder.stop();
      _stopRecordingInternal();
      _logger.info('Recording stopped');
    } catch (e) {
      _logger.severe('Failed to stop recording: $e');
      _stopRecordingInternal();
    }
  }

  /// Internal stop recording handler
  void _stopRecordingInternal() {
    _isRecording = false;
    _audioStream = null;
  }

  /// Release resources
  void dispose() {
    _logger.info('Releasing audio recorder service resources');
    if (_isRecording) {
      _recorder.stop();
    }
    _stopRecordingInternal();
    _recorder.dispose();
  }
}
