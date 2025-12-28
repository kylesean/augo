// lib/shared/theme/amount_theme.dart
import 'package:flutter/material.dart';

/// Amount display theme configuration
///
/// Provides three preset color schemes:
/// - [chinaMarket] - China market (Red increase, Black decrease, default)
/// - [international] - International standard (Green increase, Red decrease)
/// - [minimalist] - Minimalist (All black + symbols)
///
/// Usage:
/// ```dart
/// final theme = AmountTheme.chinaMarket;
/// final color = theme.incomeColor; // Income color
/// ```
class AmountTheme {
  /// Expense color (default dark gray/red)
  final Color expenseColor;

  /// Income color (default red/green)
  final Color incomeColor;

  /// Transfer color (neutral gray)
  final Color transferColor;

  /// Neutral color (for scenarios that don't distinguish income/expense)
  final Color neutralColor;

  const AmountTheme({
    required this.expenseColor,
    required this.incomeColor,
    required this.transferColor,
    required this.neutralColor,
  });

  /// China market color scheme (default)
  ///
  /// - Income: Red (represents auspiciousness and growth in Chinese culture)
  /// - Expense: Dark gray (neutral, reduces anxiety)
  /// - Transfer: Medium gray
  ///
  /// Reference: Ant Design financial design specifications
  static const chinaMarket = AmountTheme(
    expenseColor: Color(0xFF374151), // gray-700, dark gray
    incomeColor: Color(0xFFDC2626), // red-600, Chinese red
    transferColor: Color(0xFF6B7280), // gray-500
    neutralColor: Color(0xFF1F2937), // gray-800
  );

  /// International market color scheme
  ///
  /// - Income: Green (represents growth, profit)
  /// - Expense: Red (represents deficit, Red Ink)
  /// - Transfer: Medium gray
  ///
  /// Complies with Western accounting conventions and global standards
  static const international = AmountTheme(
    expenseColor: Color(0xFFDC2626), // red-600, deficit red
    incomeColor: Color(0xFF16A34A), // green-600, growth green
    transferColor: Color(0xFF6B7280), // gray-500
    neutralColor: Color(0xFF1F2937), // gray-800
  );

  /// Minimalist color scheme
  ///
  /// All use dark gray, only distinguish income/expense via +/- symbols
  /// Suitable for information-dense transaction lists, reduces visual fatigue
  ///
  /// Reference: Revolut, Monzo and other modern financial app design trends
  static const minimalist = AmountTheme(
    expenseColor: Color(0xFF374151), // gray-700
    incomeColor: Color(0xFF374151), // gray-700
    transferColor: Color(0xFF6B7280), // gray-500
    neutralColor: Color(0xFF1F2937), // gray-800
  );

  /// Color-blind friendly color scheme
  ///
  /// Uses blue and orange, more friendly for red-green colorblind users
  /// Blue: Expense (cool tone)
  /// Orange: Income (warm tone)
  static const colorBlindFriendly = AmountTheme(
    expenseColor: Color(0xFF2563EB), // blue-600
    incomeColor: Color(0xFFEA580C), // orange-600
    transferColor: Color(0xFF6B7280), // gray-500
    neutralColor: Color(0xFF1F2937), // gray-800
  );

  /// Get theme by name
  static AmountTheme fromName(String name) {
    switch (name) {
      case 'international':
        return international;
      case 'minimalist':
        return minimalist;
      case 'colorBlindFriendly':
        return colorBlindFriendly;
      case 'chinaMarket':
        return chinaMarket;
      default:
        return international;
    }
  }

  /// List of all available themes (for settings page)
  static const List<AmountThemeOption> availableThemes = [
    AmountThemeOption(
      id: 'international',
      name: 'International',
      description: 'Green increase, Red decrease',
      theme: international,
    ),
    AmountThemeOption(
      id: 'chinaMarket',
      name: 'China Market',
      description: 'Red increase, Black decrease',
      theme: chinaMarket,
    ),
    AmountThemeOption(
      id: 'minimalist',
      name: 'Minimalist',
      description: 'Distinguish with symbols only',
      theme: minimalist,
    ),
    AmountThemeOption(
      id: 'colorBlindFriendly',
      name: 'Color Blind Friendly',
      description: 'Blue-Orange scheme',
      theme: colorBlindFriendly,
    ),
  ];
}

/// Theme option (for settings page display)
class AmountThemeOption {
  final String id;
  final String name;
  final String description;
  final AmountTheme theme;

  const AmountThemeOption({
    required this.id,
    required this.name,
    required this.description,
    required this.theme,
  });
}
