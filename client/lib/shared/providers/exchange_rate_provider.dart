import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/exchange_rate.dart';
import '../services/exchange_rate_service.dart';

part 'exchange_rate_provider.g.dart';

// Note: Exchange rates are cached on the backend for 24 hours (free API limitation).
// No client-side periodic refresh is needed as the backend handles caching.

@Riverpod(keepAlive: true)
class ExchangeRate extends _$ExchangeRate {
  @override
  Future<ExchangeRateResponse> build() async {
    final service = ref.watch(exchangeRateServiceProvider);
    return service.getExchangeRates();
  }

  /// Convert amount from one currency to another
  /// Returns null if conversion is not possible (e.g. rate missing)
  Decimal? convert(Decimal amount, String fromCurrency, String toCurrency) {
    if (fromCurrency == toCurrency) return amount;

    final rates = state.value?.conversionRates;
    final base = state.value?.baseCode;

    if (rates == null || base == null) return null;

    // Normalize currencies
    final from = fromCurrency.toUpperCase();
    final to = toCurrency.toUpperCase();
    final baseCurrency = base.toUpperCase();

    // Get rate: Base -> Currency
    // If rate map contains "CNY": 7.2 (where Base is USD), then 1 USD = 7.2 CNY.
    // So Value(CNY) = Value(USD) * 7.2

    double? fromRate;
    double? toRate;

    if (from == baseCurrency) {
      fromRate = 1.0;
    } else {
      fromRate = rates[from];
    }

    if (to == baseCurrency) {
      toRate = 1.0;
    } else {
      toRate = rates[to];
    }

    if (fromRate == null || toRate == null) return null;

    // Convert From -> Base
    // Amount(Base) = Amount(From) / Rate(Base->From)
    final amountInBase = (amount.toDouble() / fromRate);

    // Convert Base -> To
    // Amount(To) = Amount(Base) * Rate(Base->To)
    final amountInTarget = amountInBase * toRate;

    return Decimal.parse(amountInTarget.toStringAsFixed(2));
  }
}
