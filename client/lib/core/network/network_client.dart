import 'package:logging/logging.dart';
import 'package:dio/dio.dart';
import 'dio_provider.dart';
import 'exceptions/app_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'interceptors/business_interceptor.dart';

// Define HTTP method enum for type safety
enum HttpMethod { get, post, put, delete, patch }

class NetworkClient {
  final Dio _dio;
  final _logger = Logger('NetworkClient');

  NetworkClient(this._dio);

  Dio get dio => _dio;

  /// Generic network request method
  /// - [path]: API relative path
  /// - [method]: HTTP method (GET, POST, etc.)
  /// - [queryParameters]: URL query parameters
  /// - [data]: Request body (for POST, PUT, PATCH)
  /// - [fromJsonT]: Callback to convert response data to generic type T
  /// - [options]: Optional Dio Options to override defaults or pass extra info
  /// - [enableRetry]: Enable retry mechanism, default true
  /// - [maxRetries]: Maximum retry attempts, default 3
  Future<T> request<T>(
    String path, {
    required HttpMethod method,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    FromJsonT<T>? fromJsonT, // T Function(Object? json)
    Options? options,
    CancelToken? cancelToken,
    bool enableRetry = true,
    int maxRetries = 3,
  }) async {
    return await _executeWithRetry<T>(
      () async {
        // Prepare Options
        final requestOptions = (options ?? Options()).copyWith(
          method: method
              .toString()
              .split('.')
              .last, // Convert enum to "GET", "POST" strings
        );

        // Execute request
        final Response<dynamic> response = await _dio.request(
          path,
          data: data,
          queryParameters: queryParameters,
          cancelToken: cancelToken,
          options: requestOptions,
        );

        return response;
      },
      fromJsonT: fromJsonT,
      enableRetry: enableRetry,
      maxRetries: maxRetries,
      path: path,
    );
  }

  /// Request executor with retry mechanism
  Future<T> _executeWithRetry<T>(
    Future<Response<dynamic>> Function() requestFunction, {
    FromJsonT<T>? fromJsonT,
    required bool enableRetry,
    required int maxRetries,
    required String path,
  }) async {
    int attempts = 0;
    DioException? lastException;

    while (attempts <= maxRetries) {
      try {
        final response = await requestFunction();

        // Perform final type conversion here
        // BusinessInterceptor maintains complete response format {code, message, data}
        // response.data is complete object containing code, message, data
        if (fromJsonT != null) {
          try {
            return fromJsonT(response.data);
          } catch (e) {
            _logger.severe("fromJsonT parsing failed", e);
            // Throw specific data parsing exception
            throw DataParsingException(
              "Client data parsing failed: ${e.toString()}",
            );
          }
        } else {
          // If no parser provided, assume caller expects raw data
          // and perform safe type check
          if (response.data is T) {
            return response.data as T;
          } else {
            // Type mismatch is also a parsing error
            throw DataParsingException(
              "Response data type mismatch. Received: ${response.data.runtimeType}, Expected: $T",
            );
          }
        }
      } on DioException catch (e) {
        lastException = e;
        attempts++;

        // Check if should retry
        if (!enableRetry || attempts > maxRetries || !_shouldRetry(e)) {
          break;
        }

        _logger.warning(
          "Request failed, preparing retry ($attempts/$maxRetries): ${e.message}",
        );

        // Wait before retry (exponential backoff)
        await Future<void>.delayed(Duration(milliseconds: 500 * attempts));
        continue;
      } catch (e) {
        if (e is AppException) rethrow;
        _logger.severe("Caught unknown error", e);
        throw Exception("Unexpected client error: ${e.toString()}");
      }
    }

    // If all retries failed, handle final exception
    if (lastException != null) {
      // Run network diagnostics before final failure
      await _handleFinalFailure(lastException, path);

      // ErrorInterceptor should have filled e.error with AppException subclass
      if (lastException.error is AppException) {
        throw lastException.error as AppException;
      }
      _logger.severe(
        "All retries failed, final error: ${lastException.type}, ${lastException.message}",
      );
      throw NetworkException(
        "Network request failed, retried $maxRetries times: ${lastException.message ?? 'Unknown network error'}",
      );
    }

    throw NetworkException("Request execution exception, unknown error");
  }

  /// Determine if request should be retried
  bool _shouldRetry(DioException e) {
    // Only retry for specific error types
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.connectionError:
        return true;
      case DioExceptionType.badResponse:
        // Can retry for 5xx server errors
        final statusCode = e.response?.statusCode;
        return statusCode != null && statusCode >= 500;
      default:
        return false;
    }
  }

  /// Handle final failure, log error details
  Future<void> _handleFinalFailure(DioException e, String path) async {
    try {
      _logger.info("Final failure for path: $path");
      _logger.info("Error type: ${e.type}, Message: ${e.message}");
      // Note: Network diagnostics removed - requires dynamic baseUrl
    } catch (diagnosticError) {
      _logger.warning("Error logging failure details", diagnosticError);
    }
  }

  Future<Map<String, dynamic>> requestMap(
    String path, {
    required HttpMethod method,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
    bool enableRetry = true,
    int maxRetries = 3,
  }) {
    return request<Map<String, dynamic>>(
      path,
      method: method,
      data: data,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      options: options,
      enableRetry: enableRetry,
      maxRetries: maxRetries,
      fromJsonT: (json) => json as Map<String, dynamic>,
    );
  }
}

// Riverpod Provider for NetworkClient
final networkClientProvider = Provider<NetworkClient>((ref) {
  final dio = ref.watch(dioProvider);
  return NetworkClient(dio);
});
