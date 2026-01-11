// core/network/interceptors/auth_interceptor.dart
import 'package:logging/logging.dart';

import 'package:dio/dio.dart';
import '../../constants/api_constants.dart';
import 'package:augo/core/storage/secure_storage_service.dart';

/// Authentication Interceptor
///
/// Automatically adds Bearer Token to requests that require authentication
class AuthInterceptor extends Interceptor {
  final SecureStorageService storageService;
  final _logger = Logger('AuthInterceptor');

  /// Public paths that do not require authentication
  static const _publicPaths = [
    '/auth/login',
    '/auth/register',
    '/auth/send-code',
  ];

  AuthInterceptor(this.storageService);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Public paths do not require authentication
    if (_publicPaths.contains(options.path)) {
      return handler.next(options);
    }

    // Get token from secure storage
    final String? authToken = await storageService.getToken();

    if (authToken != null && authToken.isNotEmpty) {
      options.headers[ApiConstants.authorizationHeader] = 'Bearer $authToken';
      _logger.fine('Token added to headers for path: ${options.path}');
    } else {
      _logger.fine('No auth token found for path: ${options.path}');
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      _logger.warning(
        'Received 401 Unauthorized error for ${err.requestOptions.path}',
      );

      // TODO: Implement token refresh logic here
    }
    super.onError(err, handler);
  }
}
