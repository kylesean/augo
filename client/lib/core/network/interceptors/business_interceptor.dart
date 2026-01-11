import 'package:dio/dio.dart';
import '../exceptions/app_exception.dart';
import '../../utils/error_translator.dart';

typedef FromJsonT<T> = T Function(Object? json);

const fromJsonTKey = 'fromJsonT';

class BusinessInterceptor extends Interceptor {
  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      // Skip validation for stream responses (e.g., SSE)
      if (response.requestOptions.responseType == ResponseType.stream ||
          (response.headers
                  .value('content-type')
                  ?.contains('text/event-stream') ??
              false)) {
        return handler.next(response);
      }

      // Response must be a JSON object
      if (response.data is! Map<String, dynamic>) {
        return handler.reject(
          DioException(
            requestOptions: response.requestOptions,
            error: DataParsingException(
              "Response format error: expected JSON object, but received ${response.data.runtimeType}",
            ),
            type: DioExceptionType.badResponse,
          ),
        );
      }

      final data = response.data as Map<String, dynamic>;

      // 'code' field is mandatory
      if (!data.containsKey('code')) {
        return handler.reject(
          DioException(
            requestOptions: response.requestOptions,
            error: DataParsingException(
              "API response format error: missing 'code' field.",
            ),
            type: DioExceptionType.badResponse,
          ),
        );
      }

      final code = data['code'];
      final message = data['message'] ?? "Unknown error";
      final bool isSuccess = code == 0;
      // If code is not 0, it's a business error
      // Step 3: If it's a business error, throw directly
      if (!isSuccess) {
        final errorCode = code is int ? code : -1;
        // Localize error message
        final localizedMessage = ErrorTranslator.translate(
          errorCode,
          message as String,
        );
        return handler.reject(
          DioException(
            requestOptions: response.requestOptions,
            error: BusinessException(localizedMessage, errorCode),
            type: DioExceptionType.badResponse,
          ),
        );
      }

      // Keep complete response format {code, message, data}
      // Don't auto-extract data field to ensure consistency across all APIs (including pagination)
      // response.data remains unchanged, let the caller handle it uniformly
      handler.next(response);
      return; // Terminate execution to prevent duplicate handler.next() calls
    }
    // For non-2xx HTTP status codes, pass directly to next handler
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Optional: Add more logging or custom handling
    super.onError(err, handler);
  }
}
