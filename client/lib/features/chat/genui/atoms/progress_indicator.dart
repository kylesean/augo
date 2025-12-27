import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// A progress indicator bar with themed styling
///
/// This is a Layer 1 (Atom) component for displaying
/// progress or percentage values visually.
///
/// Example:
/// ```dart
/// ProgressIndicator(
///   value: 0.75,
///   label: '75%',
///   color: colors.primary,
/// )
/// ```
class ProgressIndicatorBar extends StatelessWidget {
  /// Progress value from 0.0 to 1.0
  final double value;

  /// Optional label to display (e.g., "75%")
  final String? label;

  /// Bar color. Uses theme primary if null.
  final Color? color;

  /// Background color. Uses theme muted if null.
  final Color? backgroundColor;

  /// Height of the progress bar
  final double height;

  /// Whether to animate value changes
  final bool animated;

  const ProgressIndicatorBar({
    super.key,
    required this.value,
    this.label,
    this.color,
    this.backgroundColor,
    this.height = 8,
    this.animated = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.colors;
    final barColor = color ?? colors.primary;
    final bgColor = backgroundColor ?? colors.muted;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: context.theme.typography.xs.copyWith(
              color: colors.mutedForeground,
            ),
          ),
          const SizedBox(height: 4),
        ],
        Container(
          height: height,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(height / 2),
            child: animated
                ? AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: value.clamp(0.0, 1.0),
                      child: Container(color: barColor),
                    ),
                  )
                : FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: value.clamp(0.0, 1.0),
                    child: Container(color: barColor),
                  ),
          ),
        ),
      ],
    );
  }
}
