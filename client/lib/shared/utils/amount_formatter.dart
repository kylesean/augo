// lib/shared/utils/amount_formatter.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:augo/features/home/models/transaction_model.dart';
import 'package:augo/shared/theme/amount_theme.dart';
import 'package:augo/shared/models/currency.dart';

/// Unified amount formatting service
///
/// Design principles:
/// - Sign required: Always display +/- symbols (core accessibility principle)
/// - Tabular figures: Use tabular figures for alignment
/// - Decimal alignment: Fixed 2 decimal places
///
/// Usage:
/// ```dart
/// // Format transaction amount
/// final text = AmountFormatter.formatTransaction(
///   type: TransactionType.expense,
///   amount: 123.45,
/// );
/// // Result: "-¥123.45"
///
/// // Get amount color
/// final color = AmountFormatter.getAmountColor(
///   TransactionType.income,
///   AmountTheme.chinaMarket,
/// );
/// ```
class AmountFormatter {
  // NumberFormat instance cache
  static final Map<String, NumberFormat> _formatCache = {};

  /// Get currency formatter
  static NumberFormat _getCurrencyFormat(String currency) {
    return _formatCache.putIfAbsent(
      currency,
      () =>
          NumberFormat.currency(locale: 'zh_CN', symbol: '', decimalDigits: 2),
    );
  }

  /// Format transaction amount
  ///
  /// [type] - Transaction type (expense/income/transfer)
  /// [amount] - Amount (always use absolute value)
  /// [currency] - Currency code, default CNY
  /// [showSign] - Whether to show positive/negative sign, default true
  /// [compact] - Whether to use compact format, default false
  ///
  /// Returns formatted string, e.g., "-¥123.45" or "+¥100.00"
  static String formatTransaction({
    required TransactionType type,
    required double amount,
    String currency = 'CNY',
    bool showSign = true,
    bool compact = false,
  }) {
    final symbol = getCurrencySymbol(currency);
    final absAmount = amount.abs();

    String formattedValue;
    if (compact) {
      formattedValue = formatCompact(absAmount);
    } else {
      formattedValue = _getCurrencyFormat(currency).format(absAmount);
    }

    if (!showSign) {
      return '$symbol$formattedValue';
    }

    switch (type) {
      case TransactionType.expense:
        return '-$symbol$formattedValue';
      case TransactionType.income:
        return '+$symbol$formattedValue';
      case TransactionType.transfer:
        return '$symbol$formattedValue'; // Transfer without sign
      case TransactionType.other:
        return '$symbol$formattedValue';
    }
  }

  /// Format common amount (no sign)
  ///
  /// [amount] - Amount
  /// [currencyCode] - Currency code
  static String formatCommon(double amount, {String currencyCode = 'CNY'}) {
    final symbol = getCurrencySymbol(currencyCode);
    final absAmount = amount.abs();
    final formattedValue = _getCurrencyFormat(currencyCode).format(absAmount);
    return '$symbol$formattedValue';
  }

  /// Format as compact format based on system Locale
  ///
  /// For Chinese (zh): 10k, 100M
  /// For other languages: K(1k), M(1M), B(1B)
  ///
  /// [locale] - Optional locale override, defaults to system locale
  static String formatCompact(double amount, {String? locale}) {
    // Determine if using Chinese format
    final effectiveLocale = locale ?? Intl.getCurrentLocale();
    final isChineseLocale = effectiveLocale.startsWith('zh');

    if (isChineseLocale) {
      // Chinese units: 10k, 100M
      if (amount >= 100000000) {
        return '${(amount / 100000000).toStringAsFixed(1)}亿';
      } else if (amount >= 10000) {
        return '${(amount / 10000).toStringAsFixed(1)}万';
      } else {
        return amount.toStringAsFixed(2);
      }
    } else {
      // International: K(1k), M(1M), B(1B)
      if (amount >= 1000000000) {
        return '${(amount / 1000000000).toStringAsFixed(1)}B';
      } else if (amount >= 1000000) {
        return '${(amount / 1000000).toStringAsFixed(1)}M';
      } else if (amount >= 1000) {
        return '${(amount / 1000).toStringAsFixed(1)}K';
      } else {
        return amount.toStringAsFixed(2);
      }
    }
  }

  /// Get amount color
  ///
  /// Returns corresponding color based on transaction type and theme
  static Color getAmountColor(TransactionType type, AmountTheme theme) {
    switch (type) {
      case TransactionType.expense:
        return theme.expenseColor;
      case TransactionType.income:
        return theme.incomeColor;
      case TransactionType.transfer:
        return theme.transferColor;
      case TransactionType.other:
        return theme.neutralColor;
    }
  }

  /// Get amount color from string type
  ///
  /// Convenient for handling string types returned from backend
  static Color getAmountColorFromString(String typeStr, AmountTheme theme) {
    final type = _parseTransactionType(typeStr);
    return getAmountColor(type, theme);
  }

  /// Parse transaction type string
  static TransactionType _parseTransactionType(String typeStr) {
    switch (typeStr.toUpperCase()) {
      case 'EXPENSE':
        return TransactionType.expense;
      case 'INCOME':
        return TransactionType.income;
      case 'TRANSFER':
        return TransactionType.transfer;
      default:
        return TransactionType.other;
    }
  }

  /// Get currency symbol
  ///
  /// Uses the unified Currency enum for G9 countries + TWD + HKD
  /// Falls back to currency code for unknown currencies
  static String getCurrencySymbol(String currency) {
    // Import Currency enum
    final currencyEnum = Currency.fromCode(currency);
    if (currencyEnum != null) {
      return currencyEnum.symbol;
    }

    // Fallback for other currencies
    switch (currency.toUpperCase()) {
      case 'RMB':
        return '¥';
      case 'MXN':
        return '\$';
      case 'KRW':
        return '₩';
      case 'RUB':
        return '₽';
      case 'INR':
        return '₹';
      case 'TRY':
        return '₺';
      case 'HKD':
        return 'HK\$';
      case 'TWD':
        return 'NT\$';
      case 'CAD':
        return 'C\$';
      case 'AUD':
        return 'A\$';
      default:
        return currency;
    }
  }

  /// Get amount sign
  ///
  /// Returns "+", "-" or ""
  static String getAmountSign(TransactionType type) {
    switch (type) {
      case TransactionType.expense:
        return '-';
      case TransactionType.income:
        return '+';
      case TransactionType.transfer:
      case TransactionType.other:
        return '';
    }
  }

  /// Determine if amount is negative (expense)
  static bool isNegativeAmount(TransactionType type) {
    return type == TransactionType.expense;
  }

  /// Determine if amount is positive (income)
  static bool isPositiveAmount(TransactionType type) {
    return type == TransactionType.income;
  }
}
