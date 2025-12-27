/// Common exception abstraction for App layer
abstract class AppException implements Exception {
  final String? _message;
  final String? _prefix;

  //final StackTrace? _stackTrace;

  AppException([this._message, this._prefix]);

  /// Exception message (defaults to class name)
  String get message => _message ?? runtimeType.toString();

  /// Prefix information (like exception type)
  String get prefix => _prefix ?? "";

  @override
  String toString() => "$prefix$message";
}

/// Network exception (network disconnected, certificate issues, etc.)
class NetworkException extends AppException {
  NetworkException([String? message]) : super(message, "Network Error: ");
}

/// Request timeout exception
class TimeoutException extends AppException {
  TimeoutException([String? message]) : super(message, "Timeout: ");
}

/// General exception (other unknown exceptions)
class GeneralException extends AppException {
  GeneralException([String? message]) : super(message, "System Error: ");
}

/// Data parsing exception
class DataParsingException extends AppException {
  DataParsingException([String? message])
    : super(message, "Data Parsing Error: ");
}

class CacheException extends AppException {
  CacheException([String? message]) : super(message, "Cache Error: ");
}

class BadRequestException extends AppException {
  BadRequestException([String? message]) : super(message, "Bad Request: ");
}

class UnauthorizedException extends AppException {
  UnauthorizedException([String? message]) : super(message, "Unauthorized: ");
}

class ForbiddenException extends AppException {
  ForbiddenException([String? message]) : super(message, "Forbidden: ");
}

class NotFoundException extends AppException {
  NotFoundException([String? message]) : super(message, "Not Found: ");
}

class InternalServerErrorException extends AppException {
  InternalServerErrorException([String? message])
    : super(message, "Internal Server Error: ");
}

class UnexpectedHttpException extends AppException {
  final int? statusCode;

  UnexpectedHttpException([String? message, this.statusCode])
    : super(message, "Unexpected Status Code: ");
}

/// Business exception: thrown when API returns code != 0
class BusinessException extends AppException {
  final int? code; // Business custom error code
  BusinessException([String? message, this.code])
    : super(message, ""); // No prefix, display backend message directly
}
