import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// Button style variants
enum ActionButtonStyle { primary, secondary, outline, ghost, destructive }

class ActionButton extends StatelessWidget {
  /// Button label text
  final String label;

  /// Optional leading icon
  final IconData? icon;

  /// Optional trailing icon
  final IconData? trailingIcon;

  /// Badge count (shows notification badge if > 0)
  final int? badgeCount;

  /// Button style variant
  final ActionButtonStyle style;

  /// Callback when button is pressed
  final VoidCallback? onPressed;

  /// Whether button takes full width
  final bool fullWidth;

  /// Loading state
  final bool loading;

  const ActionButton({
    super.key,
    required this.label,
    this.icon,
    this.trailingIcon,
    this.badgeCount,
    this.style = ActionButtonStyle.primary,
    this.onPressed,
    this.fullWidth = false,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return FButton(
      style: _getButtonStyle(context),
      onPress: loading ? null : onPressed,
      child: loading
          ? const SizedBox.square(
              dimension: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18),
                  const SizedBox(width: 8),
                ],
                Text(label),
                if (trailingIcon != null) ...[
                  const SizedBox(width: 8),
                  Icon(trailingIcon, size: 18),
                ],
              ],
            ),
    );
  }

  FBaseButtonStyle Function(FButtonStyle) _getButtonStyle(
    BuildContext context,
  ) {
    switch (style) {
      case ActionButtonStyle.primary:
        return FButtonStyle.primary();
      case ActionButtonStyle.secondary:
        return FButtonStyle.secondary();
      case ActionButtonStyle.outline:
        return FButtonStyle.outline();
      case ActionButtonStyle.ghost:
        return FButtonStyle.ghost();
      case ActionButtonStyle.destructive:
        return FButtonStyle.destructive();
    }
  }
}

/// An icon-only action button
class IconActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final double size;
  final String? tooltip;

  const IconActionButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
    this.size = 36,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    Widget button = FButton.icon(
      style: FButtonStyle.ghost(),
      onPress: onPressed,
      child: Icon(icon, color: color, size: size * 0.55),
    );

    if (tooltip != null) {
      button = Tooltip(message: tooltip!, child: button);
    }

    return button;
  }
}
