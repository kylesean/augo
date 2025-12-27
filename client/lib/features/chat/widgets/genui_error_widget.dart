import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import '../../../../i18n/strings.g.dart';

/// Error and loading state widgets for GenUI components
///
/// This widget provides consistent error and loading UI for GenUI surfaces
/// that fail to render or are still loading.
///
/// Requirements: 4.3, 8.1
class GenUiErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback? onRetry;

  const GenUiErrorWidget({super.key, required this.errorMessage, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colors.destructive.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colors.destructive.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                FIcons.triangleAlert,
                color: theme.colors.destructive,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  t.error.genui.loadingFailed,
                  style: theme.typography.base.copyWith(
                    color: theme.colors.destructive,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage,
            style: theme.typography.sm.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            FButton(
              style: FButtonStyle.outline(),
              onPress: onRetry,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(FIcons.refreshCw, size: 14, color: theme.colors.primary),
                  const SizedBox(width: 6),
                  Text(t.common.retry),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Loading state widget for GenUI components
///
/// Displays a loading indicator while GenUI surfaces are being initialized
/// or updated.
///
/// Requirements: 4.3
class GenUiLoadingWidget extends StatelessWidget {
  final String? message;

  const GenUiLoadingWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colors.muted.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(theme.colors.primary),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            message ?? t.chat.loadingComponent,
            style: theme.typography.sm.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact error placeholder for inline errors
///
/// A minimal error indicator that can be used inline with other content
/// without taking up too much space.
///
/// Requirements: 8.1
class GenUiCompactErrorWidget extends StatelessWidget {
  final String errorMessage;

  const GenUiCompactErrorWidget({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: theme.colors.destructive.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(FIcons.circleAlert, color: theme.colors.destructive, size: 14),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              errorMessage,
              style: theme.typography.sm.copyWith(
                color: theme.colors.destructive,
                fontSize: 12,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Schema validation error widget
///
/// Specialized error widget for schema validation failures, providing
/// more context about what went wrong with the schema.
///
/// Requirements: 8.2
class GenUiSchemaErrorWidget extends StatelessWidget {
  final String schemaError;
  final bool showDetails;

  const GenUiSchemaErrorWidget({
    super.key,
    required this.schemaError,
    this.showDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colors.destructive.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colors.destructive.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                FIcons.fileWarning,
                color: theme.colors.destructive,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  t.error.genui.schemaFailed,
                  style: theme.typography.base.copyWith(
                    color: theme.colors.destructive,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            t.error.genui.schemaDescription,
            style: theme.typography.sm.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          if (showDetails) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: theme.colors.muted.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                schemaError,
                style: theme.typography.sm.copyWith(
                  color: theme.colors.mutedForeground,
                  fontFamily: 'monospace',
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Network error widget with retry functionality
///
/// Displays network-related errors with exponential backoff retry logic.
///
/// Requirements: 8.4
class GenUiNetworkErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback? onRetry;
  final int retryCount;
  final int maxRetries;

  const GenUiNetworkErrorWidget({
    super.key,
    required this.errorMessage,
    this.onRetry,
    this.retryCount = 0,
    this.maxRetries = 3,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final canRetry = retryCount < maxRetries && onRetry != null;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colors.destructive.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colors.destructive.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(FIcons.wifiOff, color: theme.colors.destructive, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  t.error.genui.networkError,
                  style: theme.typography.base.copyWith(
                    color: theme.colors.destructive,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage,
            style: theme.typography.sm.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          if (retryCount > 0) ...[
            const SizedBox(height: 4),
            Text(
              t.error.genui.retryStatus(
                retryCount: retryCount,
                maxRetries: maxRetries,
              ),
              style: theme.typography.sm.copyWith(
                color: theme.colors.mutedForeground,
                fontSize: 11,
              ),
            ),
          ],
          if (canRetry) ...[
            const SizedBox(height: 12),
            FButton(
              style: FButtonStyle.outline(),
              onPress: onRetry,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(FIcons.refreshCw, size: 14, color: theme.colors.primary),
                  const SizedBox(width: 6),
                  Text(t.common.retry),
                ],
              ),
            ),
          ] else if (retryCount >= maxRetries) ...[
            const SizedBox(height: 8),
            Text(
              t.error.genui.maxRetriesReached,
              style: theme.typography.sm.copyWith(
                color: theme.colors.destructive,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
