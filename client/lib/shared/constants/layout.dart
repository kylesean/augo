/// Application layout constants
///
/// Defines common spacing, sizes, and other layout-related constants.
/// These values do not change with the theme, so ThemeExtension is not used.
///
/// Naming convention follows Tailwind CSS spacing scale:
/// - 4dp as the base unit
/// - Numeric suffix represents a multiple of 4dp
class AppLayout {
  AppLayout._();

  // ============================================================
  // Spacing
  // ============================================================

  /// 4dp - Minimal spacing, for compact elements
  static const double spacing1 = 4.0;

  /// 6dp - Small spacing
  static const double spacing1_5 = 6.0;

  /// 8dp - Regular small spacing
  static const double spacing2 = 8.0;

  /// 12dp - Medium spacing
  static const double spacing3 = 12.0;

  /// 16dp - Regular spacing
  static const double spacing4 = 16.0;

  /// 20dp - Large spacing
  static const double spacing5 = 20.0;

  /// 24dp - Extra large spacing
  static const double spacing6 = 24.0;

  /// 32dp - Double extra large spacing
  static const double spacing8 = 32.0;

  // ============================================================
  // Icon Sizes
  // ============================================================

  /// 10dp - Extra small icon
  static const double iconXs = 10.0;

  /// 14dp - Small icon
  static const double iconSm = 14.0;

  /// 18dp - Medium icon
  static const double iconMd = 18.0;

  /// 22dp - Large icon
  static const double iconLg = 22.0;

  /// 28dp - Extra large icon
  static const double iconXl = 28.0;

  // ============================================================
  // Component Heights
  // ============================================================

  /// 32dp - Compact button height
  static const double buttonHeightCompact = 32.0;

  /// 40dp - Regular button height
  static const double buttonHeightNormal = 40.0;

  /// 48dp - Large button height
  static const double buttonHeightLarge = 48.0;

  /// 44dp - Account/Space badge size
  static const double badgeSize = 44.0;

  // ============================================================
  // Card & Container
  // ============================================================

  /// Carousel item height
  static const double carouselItemHeight = 200.0;

  /// List maximum height
  static const double listMaxHeight = 350.0;
}
