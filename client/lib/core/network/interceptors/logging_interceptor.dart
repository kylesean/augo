import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Provides a configured LogInterceptor instance.
/// Only enables logging in Debug mode.
Interceptor get loggingInterceptor {
  return LogInterceptor(
    request: kDebugMode, // Print request [default: true]
    requestHeader: kDebugMode, // Print request headers [default: true]
    requestBody: false, // Print request body [default: true]
    responseHeader: kDebugMode, // Print response headers [default: true]
    responseBody: false, // Print response body [default: true]
    error: kDebugMode, // Print error information [default: true]
    logPrint: (object) {
      // Custom log printing method
      if (kDebugMode) {
        debugPrint(object.toString());
      }
    },
  );
}
