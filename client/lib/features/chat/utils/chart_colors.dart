import 'package:flutter/material.dart';

/// Chart color mapping utility class
class ChartColors {
  /// Get corresponding color based on colorKey
  static Color getColorByKey(String colorKey) {
    switch (colorKey.toLowerCase()) {
      // Income/expense colors
      case 'income':
        return const Color(0xFF10B981); // Green
      case 'expense':
        return const Color(0xFFEF4444); // Red

      // Category colors
      case 'category_1':
        return const Color(0xFF3B82F6); // Blue
      case 'category_2':
        return const Color(0xFF10B981); // Green
      case 'category_3':
        return const Color(0xFFF59E0B); // Orange
      case 'category_4':
        return const Color(0xFF8B5CF6); // Purple
      case 'category_5':
        return const Color(0xFFEF4444); // Red
      case 'category_6':
        return const Color(0xFF06B6D4); // Cyan
      case 'category_7':
        return const Color(0xFFEC4899); // Pink
      case 'category_8':
        return const Color(0xFF84CC16); // Lime
      case 'category_9':
        return const Color(0xFFF97316); // Deep orange
      case 'category_10':
        return const Color(0xFF6366F1); // Indigo

      // Budget related colors
      case 'budget':
        return const Color(0xFF6B7280); // Gray
      case 'actual':
        return const Color(0xFF3B82F6); // Blue
      case 'over_budget':
        return const Color(0xFFEF4444); // Red
      case 'under_budget':
        return const Color(0xFF10B981); // Green

      // Financial health colors
      case 'excellent':
        return const Color(0xFF10B981); // Green
      case 'good':
        return const Color(0xFF84CC16); // Lime
      case 'average':
        return const Color(0xFFF59E0B); // Orange
      case 'poor':
        return const Color(0xFFEF4444); // Red

      // Default color sequence
      default:
        return _getDefaultColorByIndex(colorKey.hashCode % 10);
    }
  }

  /// Get default color based on index
  static Color _getDefaultColorByIndex(int index) {
    final colors = [
      const Color(0xFF3B82F6), // Blue
      const Color(0xFF10B981), // Green
      const Color(0xFFF59E0B), // Orange
      const Color(0xFF8B5CF6), // Purple
      const Color(0xFFEF4444), // Red
      const Color(0xFF06B6D4), // Cyan
      const Color(0xFFEC4899), // Pink
      const Color(0xFF84CC16), // Lime
      const Color(0xFFF97316), // Deep orange
      const Color(0xFF6366F1), // Indigo
    ];
    return colors[index % colors.length];
  }

  /// Get semi-transparent version of color
  static Color getColorWithOpacity(String colorKey, double opacity) {
    return getColorByKey(colorKey).withValues(alpha: opacity);
  }

  /// Get gradient color
  static LinearGradient getGradientByKey(String colorKey) {
    final baseColor = getColorByKey(colorKey);
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        baseColor.withValues(alpha: 0.8),
        baseColor.withValues(alpha: 0.3),
      ],
    );
  }
}
