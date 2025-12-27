import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// A standardized card component that adheres to the Forui design system.
///
/// Wraps content in a consistent container with theme-aware background,
/// border radius, and optional interactivity.
class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Border? border;
  final double? borderRadius;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.backgroundColor,
    this.border,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    // Default to card/surface color from theme, or background if card specific not avail
    // In Forui, `card` color usually exists or we use `surface`.
    // Checking theme.colors structure - falling back to background for now as specific card token needs verification
    // but typically it's just background for flat designs or a slightly elevated color.
    final effectiveColor = backgroundColor ?? theme.colors.background;

    final cardContent = Container(
      decoration: BoxDecoration(
        color: effectiveColor,
        borderRadius: borderRadius != null
            ? BorderRadius.circular(borderRadius!)
            : theme.style.borderRadius,
        border: border,
        // Typically Forui cards might have a subtle border instead of shadow,
        // or be flat. Let's keep it simple and flat by default unless border is passed.
      ),
      padding: padding ?? const EdgeInsets.all(16),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: cardContent,
      );
    }

    return cardContent;
  }
}
