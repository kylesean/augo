import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'app_theme_palette.dart';
import 'app_font_config.dart';
import 'app_semantic_colors.dart';

/// Forui theme configuration helpers with global typography adjustments.
class ForuiThemeConfig {
  /// Resolve an [FThemeData] for the given palette and brightness.
  static FThemeData resolve({
    required AppThemePalette palette,
    required Brightness brightness,
  }) {
    final baseTheme = palette.resolveBaseTheme(brightness);
    final typography = _createGlobalTypography(
      baseTypography: baseTheme.typography,
    );

    return FThemeData(
      colors: baseTheme.colors,
      typography: typography,
      style: baseTheme.style,
      extensions: [
        brightness == Brightness.dark
            ? AppSemanticColors.dark
            : AppSemanticColors.light,
      ],
    );
  }

  static FTypography _createGlobalTypography({
    required FTypography baseTypography,
  }) {
    final fontFamily = AppFontConfig.primaryFontFamily;
    final fallbacks = AppFontConfig.getGlobalFontFallbacks();

    return baseTypography.copyWith(
      xs: baseTypography.xs.copyWith(
        fontFamily: fontFamily,
        fontFamilyFallback: fallbacks,
      ),
      sm: baseTypography.sm.copyWith(
        fontFamily: fontFamily,
        fontFamilyFallback: fallbacks,
      ),
      base: baseTypography.base.copyWith(
        fontFamily: fontFamily,
        fontFamilyFallback: fallbacks,
      ),
      lg: baseTypography.lg.copyWith(
        fontFamily: fontFamily,
        fontFamilyFallback: fallbacks,
      ),
      xl: baseTypography.xl.copyWith(
        fontFamily: fontFamily,
        fontFamilyFallback: fallbacks,
      ),
      xl2: baseTypography.xl2.copyWith(
        fontFamily: fontFamily,
        fontFamilyFallback: fallbacks,
      ),
      xl3: baseTypography.xl3.copyWith(
        fontFamily: fontFamily,
        fontFamilyFallback: fallbacks,
      ),
      xl4: baseTypography.xl4.copyWith(
        fontFamily: fontFamily,
        fontFamilyFallback: fallbacks,
      ),
      xl5: baseTypography.xl5.copyWith(
        fontFamily: fontFamily,
        fontFamilyFallback: fallbacks,
      ),
      xl6: baseTypography.xl6.copyWith(
        fontFamily: fontFamily,
        fontFamilyFallback: fallbacks,
      ),
      xl7: baseTypography.xl7.copyWith(
        fontFamily: fontFamily,
        fontFamilyFallback: fallbacks,
      ),
      xl8: baseTypography.xl8.copyWith(
        fontFamily: fontFamily,
        fontFamilyFallback: fallbacks,
      ),
    );
  }
}
