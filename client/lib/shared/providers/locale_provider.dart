// shared/providers/locale_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../i18n/strings.g.dart';
import '../services/locale_service.dart';

/// Language state management - Use slang's AppLocale
class LocaleNotifier extends Notifier<AppLocale> {
  @override
  AppLocale build() {
    // Return current slang locale
    return LocaleSettings.currentLocale;
  }

  /// Change language
  Future<bool> changeLocale(AppLocale newLocale) async {
    if (newLocale == state) {
      return false; // Same language, no need to change
    }

    final success = await LocaleService.saveLocale(newLocale);
    if (success) {
      state = newLocale;
      return true;
    }

    return false;
  }

  /// Get current language display name
  String get currentLocaleDisplayName {
    return LocaleService.getLocaleDisplayName(state);
  }

  /// Get supported language list
  /// Get supported language list (Ordered: English, Simplified Chinese, Traditional Chinese, Japanese, Korean)
  List<AppLocale> get supportedLocales => [
    AppLocale.en,
    AppLocale.zh,
    AppLocale.zhHant,
    AppLocale.ja,
    AppLocale.ko,
  ];

  /// Get language display name
  String getLocaleDisplayName(AppLocale locale) {
    return LocaleService.getLocaleDisplayName(locale);
  }
}

/// Language state provider
final localeProvider = NotifierProvider<LocaleNotifier, AppLocale>(
  LocaleNotifier.new,
);
