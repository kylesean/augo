import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/media_upload_exception.dart';
import 'package:augo/i18n/strings.g.dart';
import 'package:augo/shared/services/toast_service.dart';

/// Media upload error handling service
/// Provides user-friendly error handling and guidance functionality
class MediaErrorHandler {
  static final Logger _logger = Logger('MediaErrorHandler');

  /// Handle media upload exceptions and display user-friendly error messages
  ///
  /// [context] Build context
  /// [exception] Media upload exception
  /// [onRetry] Retry callback (optional)
  static Future<void> handleException(
    BuildContext context,
    MediaUploadException exception, {
    VoidCallback? onRetry,
  }) async {
    _logger.warning(
      'Handling media upload exception: ${exception.type} - ${exception.message}',
    );

    switch (exception.type) {
      case MediaUploadError.permissionDenied:
        await _handlePermissionDenied(context, exception);
        break;
      case MediaUploadError.fileSizeExceeded:
        await _handleFileSizeExceeded(context, exception);
        break;
      case MediaUploadError.unsupportedFormat:
        await _handleUnsupportedFormat(context, exception);
        break;
      case MediaUploadError.storageInsufficient:
        await _handleStorageInsufficient(context, exception);
        break;
      case MediaUploadError.networkError:
        await _handleNetworkError(context, exception, onRetry);
        break;
      case MediaUploadError.noFilesSelected:
        // Usually no need to display error, user actively cancelled selection
        break;
      case MediaUploadError.platformNotSupported:
        await _handlePlatformNotSupported(context, exception);
        break;
      case MediaUploadError.fileReadError:
        await _handleFileReadError(context, exception, onRetry);
        break;
      case MediaUploadError.fileNotFound:
        await _handleFileNotFound(context, exception, onRetry);
        break;
      case MediaUploadError.validationError:
        await _handleValidationError(context, exception);
        break;
      case MediaUploadError.thumbnailGenerationError:
        await _handleThumbnailGenerationError(context, exception);
        break;
      case MediaUploadError.unknownError:
        await _handleUnknownError(context, exception, onRetry);
        break;
    }
  }

  /// Handle permission denied error
  static Future<void> _handlePermissionDenied(
    BuildContext context,
    MediaUploadException exception,
  ) async {
    // Log detailed permission denial information
    _logger.warning(
      'Permission denied: ${exception.message}',
      exception.originalError,
    );

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.security,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(t.error.permissionRequired),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(exception.message),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.settings,
                          size: 16,
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Settings steps:',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      t.error.permissionInstructions,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(t.common.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _logger.info('User chose to open app settings');
                _openAppSettings();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.settings, size: 16),
                  const SizedBox(width: 4),
                  Text(t.error.openSettings),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  /// Handle file size exceeded error
  static Future<void> _handleFileSizeExceeded(
    BuildContext context,
    MediaUploadException exception,
  ) async {
    // Log detailed file size exceeded information
    _logger.warning(
      'File size exceeded: ${exception.message}',
      exception.originalError,
    );

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.file_present,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: 8),
              Text(t.error.fileTooLarge),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning,
                      size: 16,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        exception.message,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          size: 16,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Suggestions:',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      t.error.fileSizeHint,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(t.common.ok),
            ),
          ],
        );
      },
    );
  }

  /// Handle unsupported file format error
  static Future<void> _handleUnsupportedFormat(
    BuildContext context,
    MediaUploadException exception,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(t.media.unsupportedFormat),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(exception.message),
              const SizedBox(height: 16),
              Text(
                t.error.supportedFormatsHint,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(t.common.ok),
            ),
          ],
        );
      },
    );
  }

  /// Handle insufficient storage space error
  static Future<void> _handleStorageInsufficient(
    BuildContext context,
    MediaUploadException exception,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(t.media.storageInsufficient),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(exception.message),
              const SizedBox(height: 16),
              Text(
                t.error.storageCleanupHint,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(t.common.ok),
            ),
          ],
        );
      },
    );
  }

  /// Handle network error
  static Future<void> _handleNetworkError(
    BuildContext context,
    MediaUploadException exception,
    VoidCallback? onRetry,
  ) async {
    // Log detailed network error information
    _logger.warning(
      'Network error details: ${exception.message}',
      exception.originalError,
    );

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.wifi_off, color: Theme.of(context).colorScheme.error),
              const SizedBox(width: 8),
              Text(t.media.networkError),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(exception.message),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        t.error.networkErrorHint,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(t.common.cancel),
            ),
            if (onRetry != null)
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _logger.info('User chose to retry network operation');
                  onRetry();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.refresh, size: 16),
                    const SizedBox(width: 4),
                    Text(t.common.retry),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  /// Handle platform not supported error
  static Future<void> _handlePlatformNotSupported(
    BuildContext context,
    MediaUploadException exception,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(t.error.platformNotSupported),
          content: Text(exception.message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(t.common.ok),
            ),
          ],
        );
      },
    );
  }

  /// Handle file read error
  static Future<void> _handleFileReadError(
    BuildContext context,
    MediaUploadException exception,
    VoidCallback? onRetry,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(t.error.fileReadError),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(exception.message),
              const SizedBox(height: 16),
              Text(
                t.error.fileReadErrorHint,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(t.common.cancel),
            ),
            if (onRetry != null)
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onRetry();
                },
                child: Text(t.common.retry),
              ),
          ],
        );
      },
    );
  }

  /// Handle file not found error
  static Future<void> _handleFileNotFound(
    BuildContext context,
    MediaUploadException exception,
    VoidCallback? onRetry,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.file_present,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: 8),
              const Text('File not found'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning,
                      size: 16,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        exception.message,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Please confirm the file exists or select another file.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(t.common.cancel),
            ),
            if (onRetry != null)
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onRetry();
                },
                child: const Text('Select again'),
              ),
          ],
        );
      },
    );
  }

  /// Handle validation error
  static Future<void> _handleValidationError(
    BuildContext context,
    MediaUploadException exception,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(t.error.validationError),
          content: Text(exception.message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(t.common.ok),
            ),
          ],
        );
      },
    );
  }

  /// Handle thumbnail generation failure error
  static Future<void> _handleThumbnailGenerationError(
    BuildContext context,
    MediaUploadException exception,
  ) async {
    // Log detailed thumbnail generation failure information
    _logger.warning(
      'Thumbnail generation failed: ${exception.message}',
      exception.originalError,
    );

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.image_not_supported,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              const Text('Thumbnail generation failed'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info,
                      size: 16,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Failed to generate thumbnail for image, but file has been successfully selected. You can still continue using this file.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                exception.message,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// Handle unknown error
  static Future<void> _handleUnknownError(
    BuildContext context,
    MediaUploadException exception,
    VoidCallback? onRetry,
  ) async {
    // Log detailed error information for debugging, including stack trace
    final errorDetails = {
      'message': exception.message,
      'originalError': exception.originalError?.toString(),
      'errorType': exception.originalError?.runtimeType.toString(),
      'timestamp': DateTime.now().toIso8601String(),
    };

    _logger.severe(
      'Unknown error details: $errorDetails',
      exception.originalError,
    );

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: 8),
              Text(t.error.unknownError),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.bug_report,
                      size: 16,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        exception.message,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.support_agent,
                          size: 16,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Help:',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      t.error.unknownErrorHint,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(t.common.cancel),
            ),
            if (onRetry != null)
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _logger.info('User chose to retry unknown error operation');
                  onRetry();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.refresh, size: 16),
                    const SizedBox(width: 4),
                    Text(t.common.retry),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  /// Open app settings page
  static Future<void> _openAppSettings() async {
    _logger.info('Attempting to open app settings page');

    try {
      // Try to open app settings page
      await SystemChannels.platform.invokeMethod(
        'SystemNavigator.openAppSettings',
      );
      _logger.info('Successfully opened app settings page');
    } catch (e) {
      _logger.warning('Primary method to open app settings page failed: $e');

      // If unable to open settings page, try other methods
      try {
        final uri = Uri.parse('app-settings:');
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
          _logger.info('Successfully opened settings page via backup method');
        } else {
          _logger.warning(
            'Backup method unavailable, cannot open settings page',
          );
        }
      } catch (e2) {
        _logger.severe('All methods to open settings page failed: $e2');

        // Log device and platform information for debugging
        _logger.info(
          'Device info: ${Platform.operatingSystem} ${Platform.operatingSystemVersion}',
        );
      }
    }
  }

  /// Display simple error notification (for scenarios that don't require dialog)
  ///
  /// [context] Build context
  /// [message] Error message
  /// [action] Optional action button
  static void showErrorSnackBar(
    BuildContext context,
    String message, {
    SnackBarAction? action,
  }) {
    ToastService.showDestructive(description: Text(message));
  }

  /// Display retry error notification
  ///
  /// [context] Build context
  /// [message] Error message
  /// [onRetry] Retry callback
  static void showRetrySnackBar(
    BuildContext context,
    String message,
    VoidCallback onRetry,
  ) {
    showErrorSnackBar(
      context,
      message,
      action: SnackBarAction(
        label: t.common.retry,
        onPressed: onRetry,
        textColor: Colors.white,
      ),
    );
  }

  /// Automatically retry network operation (with exponential backoff)
  ///
  /// [operation] Operation to retry
  /// [maxRetries] Maximum retry attempts
  /// [initialDelay] Initial delay time (milliseconds)
  /// [onRetryAttempt] Retry attempt callback (optional)
  static Future<T> retryNetworkOperation<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
    int initialDelay = 1000,
    void Function(int attempt, Duration delay)? onRetryAttempt,
  }) async {
    int attempt = 0;
    Duration delay = Duration(milliseconds: initialDelay);

    while (attempt < maxRetries) {
      try {
        _logger.info(
          'Executing network operation, attempt: ${attempt + 1}/$maxRetries',
        );
        return await operation();
      } catch (e) {
        attempt++;

        if (attempt >= maxRetries) {
          _logger.severe(
            'Network operation failed, reached maximum retry attempts: $maxRetries',
          );
          rethrow;
        }

        _logger.warning(
          'Network operation failed, will retry after ${delay.inMilliseconds}ms: $e',
        );

        if (onRetryAttempt != null) {
          onRetryAttempt(attempt, delay);
        }

        await Future.delayed(delay);

        // Exponential backoff: double delay for next attempt
        delay = Duration(milliseconds: delay.inMilliseconds * 2);
      }
    }

    throw StateError('Should not reach here');
  }

  /// Log error statistics (for analysis and improvement)
  ///
  /// [exception] Media upload exception
  /// [context] Additional context information
  static void logErrorStatistics(
    MediaUploadException exception, {
    Map<String, dynamic>? context,
  }) {
    final errorStats = {
      'errorType': exception.type.toString(),
      'message': exception.message,
      'timestamp': DateTime.now().toIso8601String(),
      'originalErrorType': exception.originalError?.runtimeType.toString(),
      if (context != null) ...context,
    };

    _logger.info('Error statistics: $errorStats');
  }
}
