/// GenUI shared formatting utilities
///
/// Provides consistent formatting functions for amounts, times, and other
/// display values used across all GenUI components.
library;

import 'package:augo/shared/models/currency.dart';

/// Formats a numeric amount with currency symbol
///
/// [amount] - The numeric value to format
/// [currency] - Currency code (CNY, USD, EUR, etc.)
/// [showSign] - Whether to show + for positive values
/// [compact] - Whether to use compact notation (1.2M, 3.5K)
String formatAmount(
  dynamic amount, {
  String currency = 'CNY',
  bool showSign = false,
  bool compact = false,
}) {
  if (amount == null) return '${getCurrencySymbol(currency)}0.00';

  final num value = amount is num
      ? amount
      : num.tryParse(amount.toString()) ?? 0;
  final symbol = getCurrencySymbol(currency);
  final sign = showSign && value > 0 ? '+' : '';

  if (compact && value.abs() >= 1000000) {
    return '$sign$symbol${(value / 1000000).toStringAsFixed(1)}M';
  } else if (compact && value.abs() >= 1000) {
    return '$sign$symbol${(value / 1000).toStringAsFixed(1)}K';
  }

  return '$sign$symbol${value.toStringAsFixed(2)}';
}

/// Gets currency symbol for a currency code
String getCurrencySymbol(String currency) {
  final currencyEnum = Currency.fromCode(currency);
  if (currencyEnum != null) {
    return currencyEnum.symbol;
  }

  switch (currency.toUpperCase()) {
    case 'CNY':
    case 'RMB':
      return '¥';
    case 'USD':
      return '\$';
    case 'EUR':
      return '€';
    case 'GBP':
      return '£';
    case 'JPY':
      return '¥';
    case 'RUB':
      return '₽';
    case 'INR':
      return '₹';
    case 'TRY':
      return '₺';
    default:
      return currency;
  }
}

/// Formats ISO time string to HH:mm format
String formatTimeOnly(String isoTime) {
  try {
    final dateTime = DateTime.parse(isoTime);
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  } catch (e) {
    return isoTime;
  }
}

/// Formats ISO time string to relative time (e.g., "3 minutes ago")
String formatRelativeTime(String isoTime) {
  try {
    final dateTime = DateTime.parse(isoTime);
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    }
  } catch (e) {
    return isoTime;
  }
}

/// Formats date to YYYY-MM-DD format
String formatDate(String isoTime) {
  try {
    final dateTime = DateTime.parse(isoTime);
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  } catch (e) {
    return isoTime;
  }
}
