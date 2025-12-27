// shared/models/currency.dart
import 'package:augo/i18n/strings.g.dart';

/// Supported currencies for the application
/// G9 countries + TWD + HKD
enum Currency {
  // G9 Countries & Most Common
  usd('USD', 'US Dollar', '\$', '🇺🇸'),
  cny('CNY', 'Chinese Yuan', '¥', '🇨🇳'),
  eur('EUR', 'Euro', '€', '🇪🇺'),
  gbp('GBP', 'British Pound', '£', '🇬🇧'),
  jpy('JPY', 'Japanese Yen', '¥', '🇯🇵'),
  cad('CAD', 'Canadian Dollar', 'C\$', '🇨🇦'),
  aud('AUD', 'Australian Dollar', 'A\$', '🇦🇺'),
  inr('INR', 'Indian Rupee', '₹', '🇮🇳'),
  rub('RUB', 'Russian Ruble', '₽', '🇷🇺'),

  // Additional currencies
  hkd('HKD', 'Hong Kong Dollar', 'HK\$', '🇭🇰'),
  twd('TWD', 'New Taiwan Dollar', 'NT\$', '🇹🇼');

  final String code;
  final String name;
  final String symbol;
  final String flag;

  const Currency(this.code, this.name, this.symbol, this.flag);

  /// Get currency by code
  static Currency? fromCode(String code) {
    try {
      return Currency.values.firstWhere(
        (c) => c.code.toUpperCase() == code.toUpperCase(),
      );
    } catch (_) {
      return null;
    }
  }

  /// Get display name with symbol
  String get displayName => '$localizedName ($symbol)';

  /// Get display name with flag
  String get displayNameWithFlag => '$flag $code - $localizedName';

  /// Get localized name using i18n
  String get localizedName {
    switch (this) {
      case Currency.usd:
        return t.currency.usd;
      case Currency.cny:
        return t.currency.cny;
      case Currency.eur:
        return t.currency.eur;
      case Currency.gbp:
        return t.currency.gbp;
      case Currency.jpy:
        return t.currency.jpy;
      case Currency.cad:
        return t.currency.cad;
      case Currency.aud:
        return t.currency.aud;
      case Currency.inr:
        return t.currency.inr;
      case Currency.rub:
        return t.currency.rub;
      case Currency.hkd:
        return t.currency.hkd;
      case Currency.twd:
        return t.currency.twd;
    }
  }
}
