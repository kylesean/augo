import 'package:flutter/material.dart';

class AccountTheme {
  // Core Colors
  static const Color black = Color(0xFF1A1A1A);
  static const Color cardBackground = Color(0xFF1E1E1E);
  static const Color gold = Color(0xFFFFD700);
  static const Color amber = Color(0xFFFFC107);
  static const Color textWhite = Colors.white;
  static const Color textGrey = Color(0xFF888888);
  static const Color deepBlack = Color(0xFF0A0A0A);

  // Premium Gold Palette
  static const Color goldLight = Color(0xFFFFE066);
  static const Color goldMuted = Color(0xFFD4AF37);
  static const Color goldDark = Color(0xFFB8860B);

  // Status Colors
  static const Color assetGreen = Color(0xFF4CAF50);
  static const Color liabilityRed = Color(0xFFE53935);

  // Gradients
  static const LinearGradient blackGoldGradient = LinearGradient(
    colors: [Color(0xFF2E2E2E), Color(0xFF1A1A1A), Color(0xFF0D0D0D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient goldShimmerGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFFFC107), Color(0xFFFFD700)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldTextGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFFFC107)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Border gradient for premium edge effect
  static const LinearGradient goldBorderGradient = LinearGradient(
    colors: [Color(0x33FFD700), Color(0x00FFD700), Color(0x33FFD700)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Text Styles
  static const TextStyle amountTextStyle = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textWhite,
    letterSpacing: 1.2,
  );

  static const TextStyle amountLargeStyle = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 40,
    fontWeight: FontWeight.w800,
    color: textWhite,
    letterSpacing: 1.5,
  );

  static const TextStyle labelTextStyle = TextStyle(
    fontSize: 14,
    color: Color(0xFF888888),
    fontWeight: FontWeight.w500,
  );

  static const TextStyle goldLabelStyle = TextStyle(
    fontSize: 12,
    color: goldMuted,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.5,
  );

  static const TextStyle accountNameStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Color(0xFF1A1A1A),
  );

  static const TextStyle accountBalanceStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Color(0xFF1A1A1A),
  );

  // Box Shadows
  static List<BoxShadow> premiumShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.4),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
    BoxShadow(
      color: gold.withValues(alpha: 0.1),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  // Currency Switcher Button Style
  static BoxDecoration currencySwitcherDecoration = BoxDecoration(
    color: Colors.white.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
  );

  // Settings Button Decoration
  static BoxDecoration settingsButtonDecoration = BoxDecoration(
    color: Colors.white.withValues(alpha: 0.1),
    shape: BoxShape.circle,
    border: Border.all(color: gold.withValues(alpha: 0.2)),
  );

  // Card Decoration with Premium Border
  static BoxDecoration get premiumCardDecoration => BoxDecoration(
    gradient: blackGoldGradient,
    borderRadius: BorderRadius.circular(24),
    boxShadow: premiumShadow,
    border: Border.all(color: gold.withValues(alpha: 0.15), width: 1),
  );

  // Account List Card Decoration
  static BoxDecoration accountCardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.04),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );
}
