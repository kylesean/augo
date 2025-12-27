import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

final _logger = Logger('GenUiErrorBoundary');

/// GenUI 组件错误边界
///
/// 捕获子组件的构建错误，提供优雅降级
///
/// Example:
/// ```dart
/// GenUiErrorBoundary(
///   componentName: 'TransferPathBuilder',
///   child: TransferPathBuilder(...),
/// )
/// ```
class GenUiErrorBoundary extends StatefulWidget {
  final Widget child;
  final String componentName;
  final Map<String, dynamic>? data;

  /// 自定义错误回调
  final void Function(Object error, StackTrace? stackTrace)? onError;

  const GenUiErrorBoundary({
    super.key,
    required this.child,
    required this.componentName,
    this.data,
    this.onError,
  });

  @override
  State<GenUiErrorBoundary> createState() => _GenUiErrorBoundaryState();
}

class _GenUiErrorBoundaryState extends State<GenUiErrorBoundary> {
  Object? _error;
  StackTrace? _stackTrace;

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return _FallbackWidget(
        componentName: widget.componentName,
        error: _error.toString(),
      );
    }

    // 使用 ErrorWidget.builder 来捕获渲染错误
    return Builder(
      builder: (context) {
        try {
          return widget.child;
        } catch (e, stack) {
          _handleError(e, stack);
          return _FallbackWidget(
            componentName: widget.componentName,
            error: e.toString(),
          );
        }
      },
    );
  }

  void _handleError(Object error, StackTrace? stackTrace) {
    _logger.info(
      'GenUiErrorBoundary: Error in ${widget.componentName}',
      error,
      stackTrace,
    );

    widget.onError?.call(error, stackTrace);

    // 延迟 setState 避免在 build 中调用
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _error = error;
          _stackTrace = stackTrace;
        });
      }
    });
  }
}

/// 降级 UI 组件
class _FallbackWidget extends StatelessWidget {
  final String componentName;
  final String error;

  const _FallbackWidget({required this.componentName, required this.error});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.destructive.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.destructive.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colors.destructive.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.error_outline,
                  color: colors.destructive,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '组件加载失败',
                      style: theme.typography.sm.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.destructive,
                      ),
                    ),
                    Text(
                      componentName,
                      style: theme.typography.xs.copyWith(
                        color: colors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.muted,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              error,
              style: theme.typography.xs.copyWith(
                color: colors.mutedForeground,
                fontFamily: 'monospace',
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// 公开的降级组件（供外部使用）
class GenUiFallbackWidget extends StatelessWidget {
  final String componentName;
  final String error;

  const GenUiFallbackWidget({
    super.key,
    required this.componentName,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return _FallbackWidget(componentName: componentName, error: error);
  }
}
