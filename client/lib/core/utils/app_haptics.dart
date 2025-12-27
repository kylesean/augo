import 'package:flutter/services.dart';

/// Centralized haptic feedback utility for consistency across the app.
class AppHaptics {
  const AppHaptics._();

  /// Feedback for a standard selection (e.g., tab change, toggle).
  static Future<void> selection() async {
    await HapticFeedback.selectionClick();
  }

  /// Light impact for minor interactions (e.g., dragging).
  static Future<void> light() async {
    await HapticFeedback.lightImpact();
  }

  /// Medium impact for standard actions (e.g., button press).
  static Future<void> medium() async {
    await HapticFeedback.mediumImpact();
  }

  /// Heavy impact for destructive or significant actions (e.g., delete).
  static Future<void> heavy() async {
    await HapticFeedback.heavyImpact();
  }

  /// Feedback for a successful action.
  static Future<void> success() async {
    await HapticFeedback.lightImpact(); // Double tap or specific pattern could be added if needed
  }

  /// Feedback for an error or warning.
  static Future<void> error() async {
    await HapticFeedback.heavyImpact();
  }
}
