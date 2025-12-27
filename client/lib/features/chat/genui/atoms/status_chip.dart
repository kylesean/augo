import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import '../../../../core/constants/category_constants.dart';

/// Size variants for StatusChip
enum ChipSize { small, medium, large }

/// A status/category tag chip with optional icon
///
/// This is a Layer 1 (Atom) component for displaying
/// status labels, categories, or tags with consistent styling.
///
/// Example:
/// ```dart
/// StatusChip(
///   label: '餐饮美食',
///   color: Colors.orange,
///   icon: Icons.restaurant,
/// )
/// ```
class StatusChip extends StatelessWidget {
  /// The label text to display
  final String label;

  /// Chip color for background and text. Uses theme primary if null.
  final Color? color;

  /// Optional leading icon
  final IconData? icon;

  /// Size variant of the chip
  final ChipSize size;

  /// Whether to use filled style (solid background) or subtle (transparent)
  final bool filled;

  const StatusChip({
    super.key,
    required this.label,
    this.color,
    this.icon,
    this.size = ChipSize.medium,
    this.filled = false,
  });

  /// Creates a StatusChip from category key using shared TransactionCategory enum
  /// Note: color is not passed, will use theme primary in build()
  factory StatusChip.fromCategory({
    Key? key,
    required String? categoryKey,
    ChipSize size = ChipSize.medium,
    bool filled = false,
  }) {
    final category = TransactionCategory.fromKey(categoryKey);
    return StatusChip(
      key: key,
      label: category.label,
      // color deliberately omitted - will use theme.colors.primary in build()
      icon: category.icon,
      size: size,
      filled: filled,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;
    final chipColor = color ?? colors.primary;

    // Size-based styling
    final (padding, fontSize, iconSize) = switch (size) {
      ChipSize.small => (
        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        11.0,
        12.0,
      ),
      ChipSize.medium => (
        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        13.0,
        14.0,
      ),
      ChipSize.large => (
        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        15.0,
        16.0,
      ),
    };

    final bgColor = filled ? chipColor : chipColor.withValues(alpha: 0.15);
    final fgColor = filled ? Colors.white : chipColor;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: iconSize, color: fgColor),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              color: fgColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
