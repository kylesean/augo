// shared/services/toast_service.dart
import 'package:flutter/material.dart';
import '../../app/router/app_router.dart';
import '../../core/widgets/top_toast.dart';

class ToastService {
  ToastService._(); // Private constructor

  static BuildContext? get _context => navigatorKey.currentContext;

  /// Get overlay state from navigator key
  static OverlayState? get _overlay => navigatorKey.currentState?.overlay;

  /// Show a standard Toast (using TopToast for top-center positioning)
  static void show({
    required Widget description,
    Widget? title,
    Duration? duration,
  }) {
    final context = _context;
    if (context == null) return;

    final String message =
        _extractText(description) ?? _extractText(title) ?? "Success";
    TopToast.info(context, message, overlay: _overlay);
  }

  /// Show a success Toast
  static void success({
    required Widget description,
    Widget? title,
    Duration? duration,
  }) {
    final context = _context;
    if (context == null) return;

    final String message =
        _extractText(description) ?? _extractText(title) ?? "Success";
    TopToast.success(context, message, overlay: _overlay);
  }

  /// Show a destructive (error) Toast
  static void showDestructive({
    required Widget description,
    Widget? title,
    Duration? duration,
  }) {
    final context = _context;
    if (context == null) return;

    final String message =
        _extractText(description) ?? _extractText(title) ?? "Error";
    TopToast.error(context, message, overlay: _overlay);
  }

  /// Show a warning Toast
  static void showWarning({
    required Widget description,
    Widget? title,
    Duration? duration,
  }) {
    final context = _context;
    if (context == null) return;

    final String message =
        _extractText(description) ?? _extractText(title) ?? "Warning";
    TopToast.warning(context, message, overlay: _overlay);
  }

  static String? _extractText(Widget? widget) {
    if (widget == null) return null;
    if (widget is Text) return widget.data;
    if (widget is RichText) {
      return widget.text.toPlainText();
    }
    // Handle cases where Text might have a child or be wrapped
    if (widget is Center) return _extractText(widget.child);
    if (widget is Padding) return _extractText(widget.child);
    if (widget is Column) {
      return widget.children.map(_extractText).whereType<String>().join(" ");
    }
    if (widget is Row) {
      return widget.children.map(_extractText).whereType<String>().join(" ");
    }
    return null;
  }
}
