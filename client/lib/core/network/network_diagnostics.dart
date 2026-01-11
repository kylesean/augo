import 'dart:io';
import 'package:logging/logging.dart';
import 'package:dio/dio.dart';

/// Network diagnostic utility class
/// Used to detect network connection status and server reachability
class NetworkDiagnostics {
  static final _logger = Logger('NetworkDiagnostics');

  /// Check internet connection status
  static Future<bool> checkInternetConnection() async {
    try {
      // Try to connect to reliable external server
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _logger.info('Internet connection available');
        return true;
      }
    } catch (e) {
      _logger.warning('No internet connection', e);
    }
    return false;
  }

  /// Check server reachability
  static Future<ServerStatus> checkServerStatus(String baseUrl) async {
    try {
      // Extract server address and port
      final uri = Uri.parse(baseUrl);
      final host = uri.host;
      final port = uri.port;

      _logger.info('Checking server connectivity to $host:$port');

      // Try to establish TCP connection
      final socket = await Socket.connect(
        host,
        port,
        timeout: const Duration(seconds: 5),
      );

      await socket.close();
      _logger.info('Server is reachable');

      // Further check HTTP response
      return await _checkHttpHealth(baseUrl);
    } catch (e) {
      _logger.warning('Server unreachable', e);
      return ServerStatus.unreachable;
    }
  }

  /// Check HTTP health status
  static Future<ServerStatus> _checkHttpHealth(String baseUrl) async {
    try {
      final dio = Dio();
      dio.options.connectTimeout = const Duration(seconds: 5);
      dio.options.receiveTimeout = const Duration(seconds: 10);

      // Try to access health check endpoint or base endpoint
      final response = await dio.get<dynamic>('$baseUrl/health');

      if (response.statusCode == 200) {
        _logger.info('Server HTTP health check passed');
        return ServerStatus.healthy;
      } else {
        _logger.warning('Server responded with status: ${response.statusCode}');
        return ServerStatus.unhealthy;
      }
    } catch (e) {
      _logger.warning('HTTP health check failed', e);
      // If no health check endpoint, try any endpoint
      return await _checkAnyEndpoint(baseUrl);
    }
  }

  /// Check any endpoint response
  static Future<ServerStatus> _checkAnyEndpoint(String baseUrl) async {
    try {
      final dio = Dio();
      dio.options.connectTimeout = const Duration(seconds: 5);
      dio.options.receiveTimeout = const Duration(seconds: 10);

      // Try to access a simple endpoint
      await dio.get<dynamic>(baseUrl);

      _logger.info('Server base URL accessible');
      return ServerStatus.reachable;
    } catch (e) {
      if (e is DioException) {
        // If HTTP error response received, server is reachable
        if (e.response != null) {
          _logger.warning(
            'Server reachable but returned error: ${e.response?.statusCode}',
          );
          return ServerStatus.reachable;
        }
      }
      _logger.warning('Server completely unreachable', e);
      return ServerStatus.unreachable;
    }
  }

  /// Execute full network diagnostic
  static Future<NetworkDiagnosticResult> runFullDiagnostic(
    String baseUrl,
  ) async {
    _logger.info('Starting full network diagnostic...');

    final internetAvailable = await checkInternetConnection();
    final serverStatus = await checkServerStatus(baseUrl);

    final result = NetworkDiagnosticResult(
      internetAvailable: internetAvailable,
      serverStatus: serverStatus,
      timestamp: DateTime.now(),
    );

    _logger.info(
      'Diagnostic complete - Internet: $internetAvailable, Server: $serverStatus',
    );
    return result;
  }

  /// Get network advice
  static String getNetworkAdvice(NetworkDiagnosticResult result) {
    if (!result.internetAvailable) {
      return 'Please check your network connection, ensure device is connected to internet';
    }

    switch (result.serverStatus) {
      case ServerStatus.healthy:
        return 'Network connection normal';
      case ServerStatus.reachable:
        return 'Server reachable, but may have service issues';
      case ServerStatus.unhealthy:
        return 'Server response abnormal, please try again later';
      case ServerStatus.unreachable:
        return 'Cannot connect to server, please check server status or try again later';
    }
  }
}

/// Server status enum
enum ServerStatus {
  healthy, // Server healthy
  reachable, // Server reachable but status unknown
  unhealthy, // Server reachable but unhealthy
  unreachable, // Server unreachable
}

/// Network diagnostic result
class NetworkDiagnosticResult {
  final bool internetAvailable;
  final ServerStatus serverStatus;
  final DateTime timestamp;

  NetworkDiagnosticResult({
    required this.internetAvailable,
    required this.serverStatus,
    required this.timestamp,
  });

  bool get isNetworkOk =>
      internetAvailable &&
      (serverStatus == ServerStatus.healthy ||
          serverStatus == ServerStatus.reachable);

  @override
  String toString() {
    return 'NetworkDiagnosticResult(internet: $internetAvailable, server: $serverStatus, time: $timestamp)';
  }
}
