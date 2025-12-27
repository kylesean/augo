import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:augo/app/theme/app_semantic_colors.dart';

/// Budget progress bar atom
///
/// Layer 1 (Atom) - Show budget usage progress
/// Support status colors (normal/warning/exceeded/achieved) and percentage display
class BudgetProgressBar extends StatelessWidget {
  /// Usage percentage (0-100+)
  final double percentage;

  /// Budget status: ON_TRACK, WARNING, EXCEEDED, ACHIEVED
  final String status;

  /// Progress bar height
  final double height;

  /// Whether to show percentage label
  final bool showLabel;

  const BudgetProgressBar({
    super.key,
    required this.percentage,
    this.status = 'ON_TRACK',
    this.height = 6,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;
    final semantic = theme.semantic;
    final barColor = _getStatusColor(status, colors, semantic);
    final progress = (percentage / 100).clamp(0.0, 1.0);

    return Row(
      children: [
        Expanded(
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: colors.muted,
              borderRadius: BorderRadius.circular(height / 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(height / 2),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.circular(height / 2),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (showLabel) ...[
          const SizedBox(width: 8),
          SizedBox(
            width: 40,
            child: Text(
              '${percentage.toStringAsFixed(0)}%',
              style: context.theme.typography.xs.copyWith(
                color: barColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ],
    );
  }

  Color _getStatusColor(
    String status,
    FColors colors,
    AppSemanticColors semantic,
  ) {
    switch (status.toUpperCase()) {
      case 'EXCEEDED':
        return colors.destructive;
      case 'WARNING':
        return semantic.warningAccent;
      case 'ACHIEVED':
        return semantic.successAccent;
      default:
        return colors.primary;
    }
  }
}
