import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../widgets/genui_error_widget.dart';

/// Error recovery strategy for GenUI rendering failures
///
/// This class provides fallback mechanisms and retry logic for various
/// error scenarios that can occur during GenUI widget rendering.
class ErrorRecoveryStrategy {
  final _logger = Logger('ErrorRecoveryStrategy');

  /// Maximum number of retry attempts for network operations
  static const int defaultMaxRetries = 3;

  /// Initial delay for exponential backoff
  static const Duration defaultInitialDelay = Duration(seconds: 1);

  /// Schema validation failed - fall back to text-only rendering
  Widget buildFallbackForInvalidSchema(
    BuildContext context,
    ChatMessage message, {
    String? schemaError,
    bool showDetails = false,
  }) {
    _logger.warning(
      'Schema validation failed for message ${message.id}',
      schemaError,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (schemaError != null && schemaError.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: GenUiSchemaErrorWidget(
              schemaError: schemaError,
              showDetails: showDetails,
            ),
          ),
        if (message.content.isNotEmpty)
          Text(message.content, style: Theme.of(context).textTheme.bodyMedium)
        else
          Text(
            'Message content is empty',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
      ],
    );
  }

  /// Widget rendering failed - display error placeholder
  Widget buildErrorPlaceholder(
    BuildContext context,
    String errorMessage, {
    VoidCallback? onRetry,
    StackTrace? stackTrace,
  }) {
    _logger.severe('Widget rendering failed', errorMessage, stackTrace);

    return GenUiErrorWidget(errorMessage: errorMessage, onRetry: onRetry);
  }

  /// Builder exception caught - render compact error
  Widget buildCompactErrorPlaceholder(
    BuildContext context,
    String errorMessage, {
    StackTrace? stackTrace,
  }) {
    _logger.severe('Builder exception caught', errorMessage, stackTrace);

    return GenUiCompactErrorWidget(errorMessage: errorMessage);
  }

  /// Network error with retry logic using exponential backoff
  Future<T> retryWithBackoff<T>({
    required Future<T> Function() operation,
    int maxAttempts = defaultMaxRetries,
    Duration initialDelay = defaultInitialDelay,
    void Function(int attempt, Duration nextDelay)? onRetry,
  }) async {
    int attempt = 0;
    Duration delay = initialDelay;
    Object? lastError;
    StackTrace? lastStackTrace;

    while (attempt < maxAttempts) {
      try {
        _logger.info(
          'Attempting operation (attempt ${attempt + 1}/$maxAttempts)',
        );
        return await operation();
      } catch (e, stackTrace) {
        lastError = e;
        lastStackTrace = stackTrace;
        attempt++;

        _logger.warning(
          'Operation failed (attempt $attempt/$maxAttempts)',
          e,
          stackTrace,
        );

        if (attempt >= maxAttempts) {
          _logger.severe('All retry attempts exhausted', lastError);
          rethrow;
        }

        if (onRetry != null) {
          onRetry(attempt, delay);
        }

        _logger.info('Retrying after ${delay.inSeconds}s delay');
        await Future.delayed(delay);
        delay *= 2;
      }
    }

    Error.throwWithStackTrace(
      Exception('All retry attempts failed: $lastError'),
      lastStackTrace ?? StackTrace.current,
    );
  }

  /// Network error widget with retry functionality
  Widget buildNetworkErrorWidget(
    BuildContext context,
    String errorMessage, {
    VoidCallback? onRetry,
    int retryCount = 0,
    int maxRetries = defaultMaxRetries,
  }) {
    _logger.warning(
      'Network error (retry $retryCount/$maxRetries)',
      errorMessage,
    );

    return GenUiNetworkErrorWidget(
      errorMessage: errorMessage,
      onRetry: onRetry,
      retryCount: retryCount,
      maxRetries: maxRetries,
    );
  }

  /// Last known good state or error message
  Widget buildFinalErrorState(
    BuildContext context,
    String errorMessage, {
    Widget? lastKnownGoodState,
  }) {
    _logger.warning('Displaying final error state', errorMessage);

    if (lastKnownGoodState != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const GenUiCompactErrorWidget(
            errorMessage:
                'Unable to load latest content, showing last successful state',
          ),
          const SizedBox(height: 8),
          lastKnownGoodState,
        ],
      );
    }

    return GenUiErrorWidget(errorMessage: errorMessage, onRetry: null);
  }

  /// Safe widget builder wrapper
  Widget safeWidgetBuilder(
    BuildContext context, {
    required Widget Function() builder,
    String errorContext = 'Widget',
  }) {
    try {
      return builder();
    } catch (e, stackTrace) {
      _logger.severe('$errorContext builder threw exception', e, stackTrace);

      return buildErrorPlaceholder(
        context,
        'Rendering failed: ${e.toString()}',
        stackTrace: stackTrace,
      );
    }
  }

  /// Validate and render with fallback
  Widget validateAndRender(
    BuildContext context, {
    required bool Function() validator,
    required Widget Function() renderer,
    required ChatMessage fallbackMessage,
    String? validationError,
  }) {
    try {
      if (validator()) {
        return safeWidgetBuilder(
          context,
          builder: renderer,
          errorContext: 'Schema renderer',
        );
      } else {
        return buildFallbackForInvalidSchema(
          context,
          fallbackMessage,
          schemaError: validationError ?? 'Schema validation failed',
        );
      }
    } catch (e, stackTrace) {
      _logger.severe('Validation or rendering failed', e, stackTrace);

      return buildFallbackForInvalidSchema(
        context,
        fallbackMessage,
        schemaError: e.toString(),
      );
    }
  }

  /// Log error with details
  void logError({
    required String message,
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? schema,
    Map<String, dynamic>? additionalContext,
  }) {
    final logMessage = StringBuffer(message);

    if (schema != null) {
      logMessage.write('\nSchema: $schema');
    }

    if (additionalContext != null) {
      logMessage.write('\nContext: $additionalContext');
    }

    _logger.severe(logMessage.toString(), error, stackTrace);
  }
}
