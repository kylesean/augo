import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App-wide typography configuration designed for global users and open-source compliance.
///
/// This class provides a centralized way to manage fonts, integrating [GoogleFonts]
/// for high-quality Latin typography and robust system fallbacks for CJK and other scripts.
class AppFontConfig {
  /// The primary font family for Latin characters.
  /// Using 'Inter' as it's a modern, open-source standard for UI design.
  static final String primaryFontFamily = GoogleFonts.inter().fontFamily!;

  /// A comprehensive list of system font fallbacks to ensure correct rendering
  /// across iOS, Android, macOS, Windows, and Linux.
  static List<String> getGlobalFontFallbacks() {
    return [
      'Inter', // Latin (via Google Fonts)
      '.AppleSystemUIFont', // iOS/macOS San Francisco
      'PingFang SC', // iOS/macOS Simplified Chinese
      'Hiragino Sans GB', // macOS Chinese
      'Noto Sans CJK SC', // Android/Linux Chinese
      'Microsoft YaHei', // Windows Chinese
      'Heiti SC', // Older iOS Chinese
      'sans-serif', // General fallback
    ];
  }

  /// Create a [TextStyle] that follows global typography best practices.
  static TextStyle createGlobalTextStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    ).copyWith(fontFamilyFallback: getGlobalFontFallbacks());
  }

  /// Resolve a [TextTheme] that applies global typography to all Material text styles.
  static TextTheme createGlobalTextTheme(TextTheme baseTheme) {
    return baseTheme.copyWith(
      displayLarge: _applyGlobalStyle(baseTheme.displayLarge),
      displayMedium: _applyGlobalStyle(baseTheme.displayMedium),
      displaySmall: _applyGlobalStyle(baseTheme.displaySmall),
      headlineLarge: _applyGlobalStyle(baseTheme.headlineLarge),
      headlineMedium: _applyGlobalStyle(baseTheme.headlineMedium),
      headlineSmall: _applyGlobalStyle(baseTheme.headlineSmall),
      titleLarge: _applyGlobalStyle(baseTheme.titleLarge),
      titleMedium: _applyGlobalStyle(baseTheme.titleMedium),
      titleSmall: _applyGlobalStyle(baseTheme.titleSmall),
      bodyLarge: _applyGlobalStyle(baseTheme.bodyLarge),
      bodyMedium: _applyGlobalStyle(baseTheme.bodyMedium),
      bodySmall: _applyGlobalStyle(baseTheme.bodySmall),
      labelLarge: _applyGlobalStyle(baseTheme.labelLarge),
      labelMedium: _applyGlobalStyle(baseTheme.labelMedium),
      labelSmall: _applyGlobalStyle(baseTheme.labelSmall),
    );
  }

  static TextStyle? _applyGlobalStyle(TextStyle? baseStyle) {
    if (baseStyle == null) return null;
    return baseStyle.copyWith(
      fontFamily: primaryFontFamily,
      fontFamilyFallback: getGlobalFontFallbacks(),
    );
  }
}
