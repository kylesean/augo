import 'dart:async';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// Toast type
enum ToastType { success, error, warning, info }

/// Top Toast utility class
class TopToast {
  static OverlayEntry? _currentEntry;

  /// Display top Toast
  static void show(
    BuildContext context, {
    required String message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
    OverlayState? overlayState,
  }) {
    // Remove previous toast
    _currentEntry?.remove();
    _currentEntry = null;

    final overlay = overlayState ?? Overlay.maybeOf(context);
    // If no overlay is found (e.g. context is from NavigatorKey), return to avoid crash
    if (overlay == null) {
      debugPrint('TopToast: No overlay found for context: $context');
      return;
    }

    final theme = context.theme;
    final colors = theme.colors;

    // Select color and icon based on type
    final (backgroundColor, iconData, iconColor) = switch (type) {
      ToastType.success => (Colors.green.shade800, FIcons.check, Colors.green),
      ToastType.error => (colors.destructive, FIcons.x, colors.destructive),
      ToastType.warning => (
        Colors.orange.shade800,
        FIcons.circleAlert,
        Colors.orange,
      ),
      ToastType.info => (colors.primary, FIcons.info, colors.primary),
    };

    _currentEntry = OverlayEntry(
      builder: (context) => _TopToastWidget(
        message: message,
        backgroundColor: backgroundColor,
        iconData: iconData,
        iconColor: iconColor,
        theme: theme,
        onDismiss: () {
          _currentEntry?.remove();
          _currentEntry = null;
        },
        duration: duration,
      ),
    );

    try {
      overlay.insert(_currentEntry!);
    } catch (e) {
      debugPrint('TopToast: Failed to insert overlay: $e');
    }
  }

  /// Display success message
  static void success(
    BuildContext context,
    String message, {
    OverlayState? overlay,
  }) {
    show(
      context,
      message: message,
      type: ToastType.success,
      overlayState: overlay,
    );
  }

  /// Display error message
  static void error(
    BuildContext context,
    String message, {
    OverlayState? overlay,
  }) {
    show(
      context,
      message: message,
      type: ToastType.error,
      overlayState: overlay,
    );
  }

  /// Display warning message
  static void warning(
    BuildContext context,
    String message, {
    OverlayState? overlay,
  }) {
    show(
      context,
      message: message,
      type: ToastType.warning,
      overlayState: overlay,
    );
  }

  /// Display info message
  static void info(
    BuildContext context,
    String message, {
    OverlayState? overlay,
  }) {
    show(
      context,
      message: message,
      type: ToastType.info,
      overlayState: overlay,
    );
  }
}

class _TopToastWidget extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final IconData iconData;
  final Color iconColor;
  final FThemeData theme;
  final VoidCallback onDismiss;
  final Duration duration;

  const _TopToastWidget({
    required this.message,
    required this.backgroundColor,
    required this.iconData,
    required this.iconColor,
    required this.theme,
    required this.onDismiss,
    required this.duration,
  });

  @override
  State<_TopToastWidget> createState() => _TopToastWidgetState();
}

class _TopToastWidgetState extends State<_TopToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    unawaited(_controller.forward());

    // Auto dismiss
    unawaited(
      Future<void>.delayed(widget.duration).then((_) {
        if (mounted) {
          unawaited(_dismiss());
        }
      }),
    );
  }

  Future<void> _dismiss() async {
    await _controller.reverse();
    widget.onDismiss();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.theme.colors;
    final topPadding = MediaQuery.of(context).padding.top;

    return Positioned(
      top: topPadding + 12,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: _dismiss,
              onVerticalDragEnd: (details) {
                if (details.velocity.pixelsPerSecond.dy < 0) {
                  unawaited(_dismiss());
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: colors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: widget.iconColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        widget.iconData,
                        size: 18,
                        color: widget.iconColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.message,
                        style: widget.theme.typography.sm.copyWith(
                          color: colors.foreground,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Icon(FIcons.x, size: 16, color: colors.mutedForeground),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
