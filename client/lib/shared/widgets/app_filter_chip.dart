import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';

class AppFilterChip extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const AppFilterChip({
    super.key,
    this.label,
    this.icon,
    required this.isSelected,
    required this.onTap,
  }) : assert(label != null || icon != null, 'Label or icon must be provided');

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    // Height 40 is a "Golden Standard" for interactive chips and buttons.
    // Making it substantial ensures it looks "refined" and obvious on all pages.
    const double height = 40;
    const double borderRadius = 10;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      constraints: const BoxConstraints(minHeight: height, maxHeight: height),
      decoration: BoxDecoration(
        color: isSelected ? colors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: isSelected ? colors.primary : colors.border,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 18,
                    color: isSelected
                        ? colors.primaryForeground
                        : colors.mutedForeground,
                  ),
                  if (label != null) const SizedBox(width: 8),
                ],
                if (label != null)
                  Flexible(
                    child: Text(
                      label!,
                      style: theme.typography.sm.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        fontSize: 14,
                        color: isSelected
                            ? colors.primaryForeground
                            : colors.mutedForeground,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
