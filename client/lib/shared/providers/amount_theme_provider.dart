// lib/shared/providers/amount_theme_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:augo/shared/theme/amount_theme.dart';
import 'package:augo/core/services/server_config_service.dart'
    show sharedPreferencesProvider;

/// Amount theme Provider
///
/// Manages the user's selected amount color scheme, supports persistent storage.
///
/// Usage:
/// ```dart
/// // Read current theme
/// final theme = ref.watch(amountThemeProvider);
///
/// // Switch theme
/// ref.read(amountThemeProvider.notifier).setTheme('international');
/// ```

/// Amount theme state
class AmountThemeState {
  final String themeId;
  final AmountTheme theme;

  const AmountThemeState({required this.themeId, required this.theme});

  /// Default state: China market
  static const defaultState = AmountThemeState(
    themeId: 'chinaMarket',
    theme: AmountTheme.chinaMarket,
  );

  AmountThemeState copyWith({String? themeId, AmountTheme? theme}) {
    return AmountThemeState(
      themeId: themeId ?? this.themeId,
      theme: theme ?? this.theme,
    );
  }
}

/// Amount theme Notifier
class AmountThemeNotifier extends Notifier<AmountThemeState> {
  static const _storageKey = 'amount_theme_id';

  @override
  AmountThemeState build() {
    _loadFromStorage();
    return AmountThemeState.defaultState;
  }

  /// Load user preferences from storage
  void _loadFromStorage() {
    final prefs = ref.read(sharedPreferencesProvider);
    final savedThemeId = prefs.getString(_storageKey);
    if (savedThemeId != null) {
      final theme = AmountTheme.fromName(savedThemeId);
      state = AmountThemeState(themeId: savedThemeId, theme: theme);
    }
  }

  /// Set theme
  Future<void> setTheme(String themeId) async {
    final theme = AmountTheme.fromName(themeId);
    state = AmountThemeState(themeId: themeId, theme: theme);
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_storageKey, themeId);
  }

  /// Reset to default theme
  Future<void> resetToDefault() async {
    state = AmountThemeState.defaultState;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.remove(_storageKey);
  }
}

/// Amount theme Provider
final amountThemeProvider =
    NotifierProvider<AmountThemeNotifier, AmountThemeState>(
      AmountThemeNotifier.new,
    );

/// Convenient provider for accessing current theme
final currentAmountThemeProvider = Provider<AmountTheme>((ref) {
  return ref.watch(amountThemeProvider).theme;
});

/// Provider for list of all available themes
final availableAmountThemesProvider = Provider<List<AmountThemeOption>>((ref) {
  return AmountTheme.availableThemes;
});

/// Provider for the current AmountTheme UI object
final currentAmountThemeValueProvider = Provider<AmountTheme>((ref) {
  return ref.watch(amountThemeProvider).theme;
});
