// shared/services/locale_service.dart
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../../i18n/strings.g.dart';

/// Language management service
/// Responsible for persistent storage and management of language settings, integrated with slang
class LocaleService {
  static const String _localeKey = 'app_locale';

  /// Language display name mapping (use slang's t variable to get localized names)
  /// Language display name mapping
  static String getLocaleDisplayName(AppLocale locale) {
    switch (locale) {
      case AppLocale.zh:
        return t.locale.chinese;
      case AppLocale.en:
        return t.locale.english;
      case AppLocale.ja:
        return t.locale.japanese;
      case AppLocale.ko:
        return t.locale.korean;
      case AppLocale.zhHant:
        return t.locale.traditionalChinese;
    }
  }

  /// Get display name from locale code (for legacy or external use)
  static String getLocaleDisplayNameFromCode(String localeCode) {
    final locale = AppLocale.values.firstWhere(
      (l) => l.languageTag == localeCode || l.languageCode == localeCode,
      orElse: () => AppLocale.en,
    );
    return getLocaleDisplayName(locale);
  }

  /// Get currently saved language settings
  static Future<String?> getSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_localeKey);
    } catch (e) {
      return null;
    }
  }

  /// Save language settings and apply
  static Future<bool> saveLocale(AppLocale locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final success = await prefs.setString(_localeKey, locale.languageTag);

      if (success) {
        // Apply new language settings
        unawaited(LocaleSettings.setLocale(locale));
      }

      return success;
    } catch (e) {
      return false;
    }
  }

  /// Get supported language list
  static List<AppLocale> get supportedLocales => AppLocale.values;

  /// Get current language
  static AppLocale get currentLocale => LocaleSettings.currentLocale;

  /// Check if language code is supported
  static bool isSupportedLocale(String localeCode) {
    return AppLocale.values.any((l) => l.languageCode == localeCode);
  }
}
