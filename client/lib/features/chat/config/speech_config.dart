class SpeechConfig {
  /// Default WebSocket host
  /// Must be configured via environment variable
  static String get host {
    const envHost = String.fromEnvironment('SPEECH_WS_HOST', defaultValue: '');
    if (envHost.isEmpty) {
      throw StateError(
        'Speech WebSocket host not configured. Use --dart-define=SPEECH_WS_HOST=xxx',
      );
    }
    return envHost;
  }

  static int get port {
    const envPort = int.fromEnvironment('SPEECH_WS_PORT', defaultValue: 8080);
    return envPort;
  }

  static String get path => '/ws';

  static String get fullUrl => 'ws://$host:$port$path';
}
