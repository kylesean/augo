import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/server_config_service.dart';

/// API Configuration Constants
///
/// Supports dynamic server configuration and compile-time environment variables:
///
/// Priority:
/// 1. Dynamically configured server URL (via ServerConfigService)
/// 2. Compile-time environment variables (--dart-define=API_BASE_URL=xxx)
class ApiConstants {
  final Ref _ref;

  ApiConstants(this._ref);

  static const String _envBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  static const String _envSseBaseUrl = String.fromEnvironment(
    'SSE_BASE_URL',
    defaultValue: '',
  );

  /// Check if server is configured
  bool get isConfigured {
    if (_envBaseUrl.isNotEmpty) return true;
    final configService = _ref.read(serverConfigServiceProvider);
    return configService.isConfigured;
  }

  /// API Base URL
  ///
  /// Priority: Dynamic Config > Compile-time Env
  /// Returns empty string if not configured (allows app startup to show config page)
  String get baseUrl {
    // 1. Dynamic configuration
    final configService = _ref.read(serverConfigServiceProvider);
    final dynamicUrl = configService.baseUrl;
    if (dynamicUrl != null && dynamicUrl.isNotEmpty) {
      return dynamicUrl;
    }

    // 2. Compile-time environment variables
    if (_envBaseUrl.isNotEmpty) {
      return _envBaseUrl;
    }

    // Return empty placeholder to allow app startup
    // The router will redirect to server-setup page
    return '';
  }

  /// Ensure server is configured before making network requests
  /// Throws StateError if not configured
  void ensureConfigured() {
    if (!isConfigured) {
      throw StateError(
        'Server not configured. Please set server URL in settings.',
      );
    }
  }

  /// SSE Base URL (for AI chat streaming)
  String get sseBaseUrl {
    // 1. Dynamic configuration
    final configService = _ref.read(serverConfigServiceProvider);
    final dynamicSseUrl = configService.sseBaseUrl;
    if (dynamicSseUrl != null && dynamicSseUrl.isNotEmpty) {
      return dynamicSseUrl;
    }

    // 2. Compile-time environment variables
    if (_envSseBaseUrl.isNotEmpty) {
      return _envSseBaseUrl;
    }

    // 3. Derived from baseUrl
    return '$baseUrl/chatbot/chat';
  }

  // SSE Endpoint Paths
  static const String aiChatSseEndpoint = '/stream';
  static const String aiChatResumeEndpoint = '/resume';

  // Timeout Configuration
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // HTTP Header Keys
  static const String contentTypeHeader = 'Content-Type';
  static const String authorizationHeader = 'Authorization';
  static const String acceptHeader = 'Accept';
  static const String acceptLanguageHeader = 'Accept-Language';
  static const String applicationJson = 'application/json';
}

/// Provider for ApiConstants instance
final apiConstantsProvider = Provider<ApiConstants>((ref) {
  return ApiConstants(ref);
});

/// Provider for checking if server is configured
final isServerReadyProvider = Provider<bool>((ref) {
  return ref.watch(apiConstantsProvider).isConfigured;
});
