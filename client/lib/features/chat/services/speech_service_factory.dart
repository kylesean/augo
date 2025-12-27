// features/chat/services/speech_service_factory.dart
import 'speech_recognition_service.dart';
import 'system_speech_service.dart';
import 'websocket_speech_service.dart';

/// Speech recognition service factory
///
/// Creates corresponding speech recognition service instances based on configuration type.
class SpeechServiceFactory {
  /// Create speech recognition service instance
  ///
  /// [type] Service type
  /// [websocketHost] WebSocket server address (only required for websocket type)
  /// [websocketPort] WebSocket server port (only required for websocket type)
  /// [websocketPath] WebSocket path (only required for websocket type)
  /// [localeId] Language recognition ID (only valid for system type)
  static SpeechRecognitionService create(
    SpeechServiceType type, {
    String? websocketHost,
    int? websocketPort,
    String? websocketPath,
    String localeId = 'zh_CN',
  }) {
    switch (type) {
      case SpeechServiceType.system:
        return SystemSpeechService(localeId: localeId);
      case SpeechServiceType.websocket:
        return WebSocketSpeechService(
          host: websocketHost,
          port: websocketPort,
          path: websocketPath,
        );
    }
  }
}
