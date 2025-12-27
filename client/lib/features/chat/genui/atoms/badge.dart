import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// Badge position for NotificationBadge
enum BadgePosition { topRight, topLeft, bottomRight, bottomLeft }

/// A small badge for counts or notifications
///
/// This is a Layer 1 (Atom) component for displaying
/// count badges, status indicators, or notifications.
///
/// Example:
/// ```dart
/// Badge(
///   count: 5,
///   color: colors.destructive,
/// )
/// ```
class Badge extends StatelessWidget {
  /// Count to display. If null, shows as dot.
  final int? count;

  /// Badge color. Uses theme destructive (red) if null.
  final Color? color;

  /// Text color. Uses white if null.
  final Color? textColor;

  /// Maximum count to display before showing "99+"
  final int maxCount;

  /// Whether to show as a dot without count
  final bool showAsDot;

  const Badge({
    super.key,
    this.count,
    this.color,
    this.textColor,
    this.maxCount = 99,
    this.showAsDot = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.colors;
    final badgeColor = color ?? colors.destructive;
    final fgColor = textColor ?? Colors.white;

    // Dot style
    if (showAsDot || count == null) {
      return Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: badgeColor, shape: BoxShape.circle),
      );
    }

    // Count style
    final displayCount = count! > maxCount ? '$maxCount+' : count.toString();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: displayCount.length > 1 ? 6 : 4,
        vertical: 2,
      ),
      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Center(
        child: Text(
          displayCount,
          style: TextStyle(
            color: fgColor,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

/// A widget wrapper that positions a badge on a child widget
class NotificationBadge extends StatelessWidget {
  /// The widget to display the badge on
  final Widget child;

  /// Count to display in badge
  final int? count;

  /// Badge color
  final Color? color;

  /// Position of the badge
  final BadgePosition position;

  /// Whether to hide badge when count is 0 or null
  final bool hideWhenZero;

  const NotificationBadge({
    super.key,
    required this.child,
    this.count,
    this.color,
    this.position = BadgePosition.topRight,
    this.hideWhenZero = true,
  });

  @override
  Widget build(BuildContext context) {
    final shouldShow = !hideWhenZero || (count != null && count! > 0);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (shouldShow)
          Positioned(
            top:
                position == BadgePosition.topRight ||
                    position == BadgePosition.topLeft
                ? -4
                : null,
            bottom:
                position == BadgePosition.bottomRight ||
                    position == BadgePosition.bottomLeft
                ? -4
                : null,
            right:
                position == BadgePosition.topRight ||
                    position == BadgePosition.bottomRight
                ? -4
                : null,
            left:
                position == BadgePosition.topLeft ||
                    position == BadgePosition.bottomLeft
                ? -4
                : null,
            child: Badge(count: count, color: color),
          ),
      ],
    );
  }
}
