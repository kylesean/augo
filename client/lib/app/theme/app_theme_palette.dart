import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:augo/i18n/strings.g.dart';

/// All supported Forui color palettes for the application theme.
enum AppThemePalette {
  zinc,
  slate,
  red,
  rose,
  orange,
  green,
  blue,
  yellow,
  violet,
}

extension AppThemePaletteX on AppThemePalette {
  /// Machine-friendly identifier.
  String get key => name;

  /// Localized-friendly display label.
  String get label {
    // Dynamic mapping via slang generated t object
    return switch (this) {
      AppThemePalette.zinc => t.appearance.palettes.zinc,
      AppThemePalette.slate => t.appearance.palettes.slate,
      AppThemePalette.red => t.appearance.palettes.red,
      AppThemePalette.rose => t.appearance.palettes.rose,
      AppThemePalette.orange => t.appearance.palettes.orange,
      AppThemePalette.green => t.appearance.palettes.green,
      AppThemePalette.blue => t.appearance.palettes.blue,
      AppThemePalette.yellow => t.appearance.palettes.yellow,
      AppThemePalette.violet => t.appearance.palettes.violet,
    };
  }

  /// Base Forui theme for the requested brightness.
  FThemeData resolveBaseTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    switch (this) {
      case AppThemePalette.zinc:
        return isDark ? FThemes.zinc.dark : FThemes.zinc.light;
      case AppThemePalette.slate:
        return isDark ? FThemes.slate.dark : FThemes.slate.light;
      case AppThemePalette.red:
        return isDark ? FThemes.red.dark : FThemes.red.light;
      case AppThemePalette.rose:
        return isDark ? FThemes.rose.dark : FThemes.rose.light;
      case AppThemePalette.orange:
        return isDark ? FThemes.orange.dark : FThemes.orange.light;
      case AppThemePalette.green:
        return isDark ? FThemes.green.dark : FThemes.green.light;
      case AppThemePalette.blue:
        return isDark ? FThemes.blue.dark : FThemes.blue.light;
      case AppThemePalette.yellow:
        return isDark ? FThemes.yellow.dark : FThemes.yellow.light;
      case AppThemePalette.violet:
        return isDark ? FThemes.violet.dark : FThemes.violet.light;
    }
  }

  /// Representative primary color for preview chips.
  Color get swatchColor => resolveBaseTheme(Brightness.light).colors.primary;
}
