class SpeechConfig {
  /// Default WebSocket host from compile-time environment
  /// Returns empty string if not configured (allows user to configure in settings)
  static String get host {
    const envHost = String.fromEnvironment('SPEECH_WS_HOST', defaultValue: '');
    return envHost;
  }

  /// Check if Speech WebSocket is configured via compile-time environment
  static bool get isConfiguredFromEnv => host.isNotEmpty;

  static int get port {
    const envPort = int.fromEnvironment('SPEECH_WS_PORT', defaultValue: 8080);
    return envPort;
  }

  static String get path => '/ws';

  /// Full WebSocket URL (only valid if host is configured)
  /// Returns empty string if host is not configured
  static String get fullUrl {
    if (host.isEmpty) return '';
    return 'ws://$host:$port$path';
  }
}
