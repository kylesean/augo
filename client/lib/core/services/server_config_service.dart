import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

final _logger = Logger('ServerConfigService');

/// Storage key for server URL
const String _serverUrlKey = 'server_url';

/// Service for managing server configuration
///
/// Handles:
/// - Persisting server URL to SharedPreferences
/// - Validating URL format
/// - Health checking the server
/// - Providing dynamic base URLs for network layer
class ServerConfigService {
  final SharedPreferences _prefs;

  ServerConfigService(this._prefs);

  /// Get the currently configured server URL
  String? get serverUrl => _prefs.getString(_serverUrlKey);

  /// Check if a server is configured
  bool get isConfigured => serverUrl != null && serverUrl!.isNotEmpty;

  /// Get the API base URL (with /api/v1 suffix)
  String? get baseUrl {
    final url = serverUrl;
    if (url == null || url.isEmpty) return null;

    // Remove trailing slash if present
    final cleanUrl = url.endsWith('/') ? url.substring(0, url.length - 1) : url;
    return '$cleanUrl/api/v1';
  }

  /// Get the SSE base URL for streaming endpoints
  String? get sseBaseUrl {
    final base = baseUrl;
    if (base == null) return null;
    return '$base/chatbot/chat';
  }

  /// Save server URL to persistent storage
  Future<void> saveServerUrl(String url) async {
    // Normalize URL
    String normalizedUrl = url.trim();

    // Add protocol if missing
    if (!normalizedUrl.startsWith('http://') &&
        !normalizedUrl.startsWith('https://')) {
      normalizedUrl = 'http://$normalizedUrl';
    }

    // Remove trailing slash
    if (normalizedUrl.endsWith('/')) {
      normalizedUrl = normalizedUrl.substring(0, normalizedUrl.length - 1);
    }

    await _prefs.setString(_serverUrlKey, normalizedUrl);
    _logger.info('Server URL saved: $normalizedUrl');
  }

  /// Clear saved server URL
  Future<void> clearServerUrl() async {
    await _prefs.remove(_serverUrlKey);
    _logger.info('Server URL cleared');
  }

  /// Validate URL format
  /// Returns null if valid, error message if invalid
  String? validateUrl(String url) {
    if (url.trim().isEmpty) {
      return 'URL cannot be empty';
    }

    String testUrl = url.trim();
    if (!testUrl.startsWith('http://') && !testUrl.startsWith('https://')) {
      testUrl = 'http://$testUrl';
    }

    try {
      final uri = Uri.parse(testUrl);
      if (!uri.hasScheme || !uri.hasAuthority) {
        return 'Invalid URL format';
      }
      if (uri.host.isEmpty) {
        return 'Host cannot be empty';
      }
    } catch (e) {
      return 'Invalid URL format';
    }

    return null; // Valid
  }

  /// Check server health and return server info
  /// Returns a [ServerHealthResult] with connection status and server info
  Future<ServerHealthResult> checkHealth(String url) async {
    // Normalize URL for health check
    String normalizedUrl = url.trim();
    if (!normalizedUrl.startsWith('http://') &&
        !normalizedUrl.startsWith('https://')) {
      normalizedUrl = 'http://$normalizedUrl';
    }
    if (normalizedUrl.endsWith('/')) {
      normalizedUrl = normalizedUrl.substring(0, normalizedUrl.length - 1);
    }

    final healthUrl = '$normalizedUrl/api/v1/health';
    _logger.info('Checking health at: $healthUrl');

    final dio = Dio()
      ..options.connectTimeout = const Duration(seconds: 10)
      ..options.receiveTimeout = const Duration(seconds: 10);

    try {
      final response = await dio.get(healthUrl);

      if (response.statusCode == 200) {
        final data = response.data;
        String? version;
        String? environment;

        if (data is Map) {
          version = data['version']?.toString();
          environment = data['environment']?.toString();
        }

        _logger.info(
          'Health check successful: version=$version, env=$environment',
        );
        return ServerHealthResult(
          isHealthy: true,
          version: version,
          environment: environment,
        );
      } else {
        _logger.warning(
          'Health check failed with status: ${response.statusCode}',
        );
        return ServerHealthResult(
          isHealthy: false,
          errorMessage: 'Server returned status ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      String errorMessage;
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          errorMessage = 'Connection timed out';
          break;
        case DioExceptionType.connectionError:
          errorMessage = 'Could not connect to server';
          break;
        case DioExceptionType.badCertificate:
          errorMessage = 'SSL certificate error';
          break;
        default:
          errorMessage = e.message ?? 'Connection failed';
      }
      _logger.warning('Health check error: $errorMessage');
      return ServerHealthResult(isHealthy: false, errorMessage: errorMessage);
    } catch (e) {
      _logger.severe('Unexpected health check error: $e');
      return ServerHealthResult(
        isHealthy: false,
        errorMessage: 'Unexpected error: $e',
      );
    } finally {
      dio.close();
    }
  }
}

/// Result of a server health check
class ServerHealthResult {
  final bool isHealthy;
  final String? version;
  final String? environment;
  final String? errorMessage;

  const ServerHealthResult({
    required this.isHealthy,
    this.version,
    this.environment,
    this.errorMessage,
  });

  @override
  String toString() {
    if (isHealthy) {
      return 'ServerHealthResult(healthy, version: $version, env: $environment)';
    }
    return 'ServerHealthResult(unhealthy, error: $errorMessage)';
  }
}

/// Provider for SharedPreferences (should be overridden in main.dart)
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden');
});

/// Provider for ServerConfigService
final serverConfigServiceProvider = Provider<ServerConfigService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ServerConfigService(prefs);
});

/// Provider for checking if server is configured
final isServerConfiguredProvider = Provider<bool>((ref) {
  return ref.watch(serverConfigServiceProvider).isConfigured;
});

/// Provider for current server URL
final serverUrlProvider = Provider<String?>((ref) {
  return ref.watch(serverConfigServiceProvider).serverUrl;
});

/// Provider for API base URL
final apiBaseUrlProvider = Provider<String?>((ref) {
  return ref.watch(serverConfigServiceProvider).baseUrl;
});
