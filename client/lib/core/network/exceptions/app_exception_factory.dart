import 'package:dio/dio.dart';
import 'app_exception.dart';
import '../../../i18n/strings.g.dart';

/// Unified conversion of DioException to custom AppException.
///
/// Maps Dio-specific errors and HTTP status codes to our domain exceptions,
/// utilizing localized strings from the i18n system where possible.
class AppExceptionFactory {
  static AppException fromDio(DioException err) {
    final responseData = err.response?.data;
    final statusCode = err.response?.statusCode ?? 0;
    final backendMessage = _extractMessage(responseData);

    // Check for business error code != 0
    if (statusCode >= 200 && statusCode < 300) {
      if (responseData is Map<String, dynamic>) {
        final code = responseData['code'];
        if (code is int && code != 0) {
          return BusinessException(
            (responseData['message'] as String?) ?? "Unknown business error",
            code,
          );
        }
      }
    }

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(t.server.error.connectionTimeout);
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        return NetworkException(t.server.error.connectionRefused);
      case DioExceptionType.badResponse:
        return _fromHttpStatus(statusCode, backendMessage);
      case DioExceptionType.cancel:
        return GeneralException(t.common.cancel);
      case DioExceptionType.badCertificate:
        return NetworkException(t.server.error.sslError);
    }
  }

  static AppException _fromHttpStatus(int statusCode, String message) {
    switch (statusCode) {
      case 400:
        return BadRequestException(message);
      case 401:
        return UnauthorizedException(message);
      case 403:
        return ForbiddenException(message);
      case 404:
        return NotFoundException(message);
      case 422:
        return BadRequestException("${t.common.error}: $message");
      case 500:
      case 502:
      case 503:
        return InternalServerErrorException(t.server.error.serverError);
      default:
        return UnexpectedHttpException(message, statusCode);
    }
  }

  static String _extractMessage(dynamic data) {
    if (data is Map<String, dynamic> && data['message'] is String) {
      return data['message'] as String;
    } else if (data is String && data.isNotEmpty) {
      return data;
    }
    return t.server.error.serverError;
  }
}
