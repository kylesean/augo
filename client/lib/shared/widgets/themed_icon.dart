import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// Themed icon sizes for consistent sizing across the app.
enum ThemedIconSize {
  /// Compact size: 28x28 with 14px icon
  compact,

  /// Standard size: 32x32 with 18px icon (default)
  standard,

  /// Large size: 44x44 with 22px icon
  large,
}

/// A themed icon with consistent styling across the app.
///
/// This component ensures all icons have a unified appearance:
/// - Rounded rectangle background (8px radius)
/// - Secondary background color from theme
/// - Foreground icon color from theme
///
/// Example:
/// ```dart
/// ThemedIcon(icon: FIcons.settings)
/// ThemedIcon(icon: FIcons.users, size: ThemedIconSize.large)
/// ```
class ThemedIcon extends StatelessWidget {
  /// The icon to display.
  final IconData icon;

  /// Size of the icon container.
  final ThemedIconSize size;

  /// Optional custom background color (overrides theme).
  final Color? backgroundColor;

  /// Optional custom icon color (overrides theme).
  final Color? iconColor;

  const ThemedIcon({
    super.key,
    required this.icon,
    this.size = ThemedIconSize.standard,
    this.backgroundColor,
    this.iconColor,
  });

  /// Creates a compact sized icon (28x28).
  const ThemedIcon.compact({
    super.key,
    required this.icon,
    this.backgroundColor,
    this.iconColor,
  }) : size = ThemedIconSize.compact;

  /// Creates a standard sized icon (32x32).
  const ThemedIcon.standard({
    super.key,
    required this.icon,
    this.backgroundColor,
    this.iconColor,
  }) : size = ThemedIconSize.standard;

  /// Creates a large sized icon (44x44).
  const ThemedIcon.large({
    super.key,
    required this.icon,
    this.backgroundColor,
    this.iconColor,
  }) : size = ThemedIconSize.large;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.colors;

    // Determine sizes based on ThemedIconSize
    final (containerSize, iconSize) = switch (size) {
      ThemedIconSize.compact => (28.0, 14.0),
      ThemedIconSize.standard => (32.0, 18.0),
      ThemedIconSize.large => (44.0, 22.0),
    };

    return Container(
      width: containerSize,
      height: containerSize,
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: iconSize, color: iconColor ?? colors.foreground),
    );
  }
}
