import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// App Semantic Colors Extension - Integrated with Forui Theme System
///
/// Defines app-specific semantic colors such as shared space highlights, success, and warning states.
/// Perfectly integrates with the Forui theme system via the ThemeExtension mechanism,
/// supporting dark mode transitions and theme-switching animations.
///
/// Usage:
/// ```dart
/// final semantic = context.theme.semantic;
/// color: semantic.sharedSpaceAccent
/// ```
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  /// Accent color for shared spaces
  final Color sharedSpaceAccent;

  /// Background color for shared spaces
  final Color sharedSpaceBackground;

  /// Success state accent color
  final Color successAccent;

  /// Success state background color
  final Color successBackground;

  /// Warning state accent color
  final Color warningAccent;

  /// Warning state background color
  final Color warningBackground;

  const AppSemanticColors({
    required this.sharedSpaceAccent,
    required this.sharedSpaceBackground,
    required this.successAccent,
    required this.successBackground,
    required this.warningAccent,
    required this.warningBackground,
  });

  /// Light theme definitions
  static const light = AppSemanticColors(
    sharedSpaceAccent: Color(0xFF9333EA), // purple-600
    sharedSpaceBackground: Color(0xFFF3E8FF), // purple-50
    successAccent: Color(0xFF16A34A), // green-600
    successBackground: Color(0xFFF0FDF4), // green-50
    warningAccent: Color(0xFFD97706), // amber-600
    warningBackground: Color(0xFFFFFBEB), // amber-50
  );

  /// Dark theme definitions
  static const dark = AppSemanticColors(
    sharedSpaceAccent: Color(0xFFA855F7), // purple-500
    sharedSpaceBackground: Color(0xFF3B0764), // purple-950
    successAccent: Color(0xFF22C55E), // green-500
    successBackground: Color(0xFF14532D), // green-900
    warningAccent: Color(0xFFFBBF24), // amber-400
    warningBackground: Color(0xFF78350F), // amber-900
  );

  @override
  AppSemanticColors copyWith({
    Color? sharedSpaceAccent,
    Color? sharedSpaceBackground,
    Color? successAccent,
    Color? successBackground,
    Color? warningAccent,
    Color? warningBackground,
  }) => AppSemanticColors(
    sharedSpaceAccent: sharedSpaceAccent ?? this.sharedSpaceAccent,
    sharedSpaceBackground: sharedSpaceBackground ?? this.sharedSpaceBackground,
    successAccent: successAccent ?? this.successAccent,
    successBackground: successBackground ?? this.successBackground,
    warningAccent: warningAccent ?? this.warningAccent,
    warningBackground: warningBackground ?? this.warningBackground,
  );

  @override
  AppSemanticColors lerp(AppSemanticColors? other, double t) {
    if (other == null) return this;
    return AppSemanticColors(
      sharedSpaceAccent: Color.lerp(
        sharedSpaceAccent,
        other.sharedSpaceAccent,
        t,
      )!,
      sharedSpaceBackground: Color.lerp(
        sharedSpaceBackground,
        other.sharedSpaceBackground,
        t,
      )!,
      successAccent: Color.lerp(successAccent, other.successAccent, t)!,
      successBackground: Color.lerp(
        successBackground,
        other.successBackground,
        t,
      )!,
      warningAccent: Color.lerp(warningAccent, other.warningAccent, t)!,
      warningBackground: Color.lerp(
        warningBackground,
        other.warningBackground,
        t,
      )!,
    );
  }
}

/// FThemeData extension for convenient access to semantic colors and chart palettes
extension AppSemanticColorsX on FThemeData {
  /// Access application-specific semantic colors.
  ///
  /// Note: Ensure AppSemanticColors is registered in the FThemeData extensions.
  AppSemanticColors get semantic => extension<AppSemanticColors>();

  // ========== Chart Palette (Dynamic - Based on Primary) ==========
  // Design Principle: Derived entirely from the theme's primary color, no hardcoding.
  // Follows Forui/Shadcn philosophy: Colors are derived from the theme rather than pre-defined.

  /// List of opacities for generating chart color gradients (from solid to pale)
  static const List<double> _chartOpacities = [1.0, 0.8, 0.6, 0.4, 0.25];

  /// Retrieves a chart color at a specific index, based on primary color variants.
  ///
  /// Colors are derived from the theme's primary color using opacity to differentiate data series.
  /// If the index exceeds the range, it cycles through the opacity gradient.
  ///
  /// Usage:
  /// ```dart
  /// color: context.theme.chartColorAt(index)
  /// ```
  Color chartColorAt(int index) {
    final opacity = _chartOpacities[index % _chartOpacities.length];
    return colors.primary.withValues(alpha: opacity);
  }

  /// Retrieves the full dynamic chart color palette based on current primary color.
  List<Color> get chartColors => _chartOpacities
      .map((opacity) => colors.primary.withValues(alpha: opacity))
      .toList();
}
