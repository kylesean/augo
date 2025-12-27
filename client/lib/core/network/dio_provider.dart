import 'package:logging/logging.dart';

import 'package:dio/dio.dart';
import 'package:augo/core/network/interceptors/business_interceptor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/api_constants.dart';
import './interceptors/auth_interceptor.dart';
import './interceptors/logging_interceptor.dart';
import './interceptors/error_interceptor.dart';
import './interceptors/locale_interceptor.dart';
import '../storage/secure_storage_service.dart';

/// Riverpod Provider for Dio instance
final _logger = Logger('DioProvider');

/// SSE Dio Provider
///
/// Used for SSE streaming connections (AI chat, script execution, etc.), disabling timeout limits.
/// Streaming connections may last for a long time (e.g., waiting for AI to execute scripts), should not be subject to timeout limits.
final sseDioProvider = Provider<Dio>((ref) {
  final apiConstants = ref.watch(apiConstantsProvider);
  final dio = Dio();

  // SSE connection configuration: only set connectTimeout, do not set receiveTimeout
  dio.options.baseUrl = apiConstants.baseUrl;
  dio.options.connectTimeout = ApiConstants.connectTimeout;
  // do not set receiveTimeout - SSE stream may last for a long time
  // receiveTimeout: Duration.zero means no limit
  dio.options.receiveTimeout = const Duration(hours: 1);
  dio.options.sendTimeout = const Duration(hours: 1);
  dio.options.headers = {
    ApiConstants.contentTypeHeader: ApiConstants.applicationJson,
    ApiConstants.acceptHeader: 'text/event-stream',
  };

  // SSE connection only needs basic interceptors
  final storageService = ref.watch(secureStorageServiceProvider);
  dio.interceptors.add(loggingInterceptor);
  dio.interceptors.add(LocaleInterceptor(ref));
  dio.interceptors.add(AuthInterceptor(storageService));
  // Note: SSE does not need ErrorInterceptor and BusinessInterceptor, because the streaming response handling is different

  _logger.info(
    "SSE Dio instance created with baseUrl: ${apiConstants.baseUrl}",
  );
  return dio;
});

final dioProvider = Provider<Dio>((ref) {
  final apiConstants = ref.watch(apiConstantsProvider);
  final dio = Dio();

  // Basic configuration
  dio.options.baseUrl = apiConstants.baseUrl;
  dio.options.connectTimeout = ApiConstants.connectTimeout;
  dio.options.receiveTimeout = ApiConstants.receiveTimeout;
  // dio.options.sendTimeout = ApiConstants.sendTimeout;
  dio.options.headers = {
    ApiConstants.contentTypeHeader: ApiConstants.applicationJson,
    ApiConstants.acceptHeader: ApiConstants.applicationJson,
  };
  // --- Inject dependencies and add interceptors ---
  // 1. Get SecureStorageService instance
  final storageService = ref.watch(secureStorageServiceProvider);
  // 2. Add interceptors in execution order
  dio.interceptors.add(loggingInterceptor); // Logging interceptor
  dio.interceptors.add(LocaleInterceptor(ref)); // Locale interceptor
  dio.interceptors.add(AuthInterceptor(storageService)); // Auth interceptor
  dio.interceptors.add(ErrorInterceptor()); // Error handling interceptor
  dio.interceptors.add(BusinessInterceptor()); // Business logic interceptor
  _logger.info("Dio instance created with baseUrl: ${apiConstants.baseUrl}");
  return dio;
});
