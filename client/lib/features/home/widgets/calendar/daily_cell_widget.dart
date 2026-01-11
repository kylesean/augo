// features/home/widgets/calendar/daily_cell_widget.dart
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import '../../models/daily_expense_summary_model.dart';

class DailyCellWidget extends StatelessWidget {
  final DateTime day;
  final DailyExpenseSummaryModel? summary;
  final bool isSelected;
  final bool isToday;
  final bool isOutOfMonth;
  final VoidCallback? onTap;

  const DailyCellWidget({
    super.key,
    required this.day,
    this.summary,
    this.isSelected = false,
    this.isToday = false,
    this.isOutOfMonth = false,
    this.onTap,
  });

  // Helper method: Get background and text colors based on heat level and theme
  ({Color backgroundColor, Color textColor}) _getHeatColors(
    BuildContext context,
    ExpenseHeatLevel heatLevel,
  ) {
    final theme = context.theme;
    final colors = theme.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Base color from which we derive different heat levels
    // Use primary as base for highest heat level as it's typically the most prominent theme color
    final baseHotColor = colors.primary;
    final baseHotForegroundColor = colors.primaryForeground;

    // Lowest heat background (near transparent or background color)
    const baseColdBackgroundColor = Colors.transparent; // Or colors.background

    // Lowest heat text color
    final baseColdForegroundColor = colors.foreground;

    // Define 5 heat levels for background and corresponding foreground text color
    // Create increment effect by adjusting baseHotColor's opacity relative to baseColdBackgroundColor
    switch (heatLevel) {
      case ExpenseHeatLevel.none:
        return (
          backgroundColor: baseColdBackgroundColor,
          textColor: baseColdForegroundColor.withValues(
            alpha: 0.6,
          ), // Dim text when no consumption
        );

      case ExpenseHeatLevel.low:
        return (
          // Blend small amount of baseHotColor into background (or use low opacity baseHotColor directly)
          backgroundColor: Color.alphaBlend(
            baseHotColor.withValues(alpha: isDark ? 0.25 : 0.2),
            colors.background,
          ),
          // Ensure text color is readable on light background
          textColor: isDark
              ? baseHotForegroundColor.withValues(alpha: 0.8)
              : baseHotColor.withValues(alpha: 0.8),
        );
      case ExpenseHeatLevel.medium:
        return (
          backgroundColor: Color.alphaBlend(
            baseHotColor.withValues(alpha: isDark ? 0.4 : 0.35),
            colors.background,
          ),
          textColor: isDark
              ? baseHotForegroundColor.withValues(alpha: 0.9)
              : baseHotColor.withValues(alpha: 0.9),
        );
      case ExpenseHeatLevel.high:
        return (
          backgroundColor: Color.alphaBlend(
            baseHotColor.withValues(alpha: isDark ? 0.6 : 0.55),
            colors.background,
          ),
          textColor: baseHotForegroundColor,
        );
      case ExpenseHeatLevel.veryHigh:
        // For highest heat level, use baseHotColor directly
        return (
          backgroundColor: baseHotColor.withValues(
            alpha: isDark ? 0.85 : 0.8,
          ), // Ensure not fully opaque unless needed
          textColor: baseHotForegroundColor,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;
    Color cellTextColor;
    Color? cellBackgroundColor;
    FontWeight cellFontWeight = FontWeight.normal;
    Border? cellEffectiveBorder;

    final cellRadius =
        theme.style.borderRadius.topLeft.x / 1.5; // Cell border radius

    if (isOutOfMonth) {
      cellTextColor = colors.mutedForeground.withValues(alpha: 0.4);
      cellBackgroundColor =
          Colors.transparent; // Transparent background for days outside month
      cellEffectiveBorder = Border.all(color: Colors.transparent, width: 0);
    } else {
      // Priority handling for selected and today status
      if (isSelected) {
        cellBackgroundColor = colors.primary;
        cellTextColor = colors.primaryForeground;
        cellFontWeight = FontWeight.bold;
        cellEffectiveBorder = Border.all(
          color: colors.primary, // Use primary color for selected state border
          width: 2, // Thicker border
        );
      } else if (isToday) {
        cellBackgroundColor =
            colors.secondary; // Use secondary background for today
        cellTextColor = colors.secondaryForeground;
        cellFontWeight = FontWeight.bold;
        cellEffectiveBorder = Border.all(
          color: colors.border, // Border for today
          width: 1,
        );
      } else {
        // If neither selected nor today, background and text color based on consumption heat
        if (summary != null && summary!.totalExpense >= 0) {
          // totalExpense >= 0 includes zero consumption case
          final heatColors = _getHeatColors(context, summary!.heatLevel);
          cellBackgroundColor = heatColors.backgroundColor;
          cellTextColor = heatColors.textColor;
          cellFontWeight = summary!.heatLevel == ExpenseHeatLevel.none
              ? FontWeight.normal
              : FontWeight
                    .w500; // Normal for no consumption, semi-bold for consumption
          cellEffectiveBorder = Border.all(
            // Give a default thin border or transparent border
            color: summary!.heatLevel == ExpenseHeatLevel.none
                ? Colors.transparent
                : colors.border.withValues(
                    alpha: 0.2,
                  ), // Light border when there's heat
            width: summary!.heatLevel == ExpenseHeatLevel.none ? 0 : 0.5,
          );
        } else {
          // Theoretically summary shouldn't be null here (due to orElse), but just in case
          cellBackgroundColor = Colors.transparent;
          cellTextColor = colors.foreground;
          cellEffectiveBorder = Border.all(color: Colors.transparent, width: 0);
        }
      }
    }

    return AspectRatio(
      aspectRatio: 1.0,
      child: FButton.raw(
        style: FButtonStyle.ghost(),
        onPress: (!isOutOfMonth && onTap != null) ? onTap : null,
        child: Container(
          decoration: BoxDecoration(
            color: cellBackgroundColor,
            border: cellEffectiveBorder,
            borderRadius: BorderRadius.circular(cellRadius),
          ),
          child: Center(
            child: Text(
              '${day.day}',
              style: theme.typography.sm.copyWith(
                color: cellTextColor, // Apply calculated text color
                fontWeight: cellFontWeight,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
