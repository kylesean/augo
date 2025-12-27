import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// App theme mode enum
enum AppThemeMode { system, light, dark }

/// Theme mode state manager
///
/// Converts [AppThemeMode] to Flutter's [ThemeMode]
class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    return ThemeMode.system;
  }

  void setTheme(AppThemeMode mode) {
    state = switch (mode) {
      AppThemeMode.system => ThemeMode.system,
      AppThemeMode.light => ThemeMode.light,
      AppThemeMode.dark => ThemeMode.dark,
    };
  }
}
