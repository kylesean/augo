// lib/shared/widgets/amount_text.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:intl/intl.dart';
import 'package:augo/features/home/models/transaction_model.dart';
import 'package:augo/shared/theme/amount_theme.dart';
import 'package:augo/shared/utils/amount_formatter.dart';
import 'package:augo/features/profile/providers/financial_settings_provider.dart';
import 'package:augo/shared/providers/amount_theme_provider.dart';

/// Amount display semantic type
enum AmountSemantic {
  /// Transaction flows (inflow/outflow) -> Uses colors based on theme
  transaction,

  /// Market trends, gains/losses, forecasts -> Uses colors based on theme
  trend,

  /// Account balances, asset values, total summaries -> Neutral color
  status,
}

/// Unified amount display component
///
/// Features:
/// - Automatically applies theme colors
/// - Built-in +/- symbols
/// - Supports tabular figures
/// - Optional dimmed decimals
///
/// Usage:
/// ```dart
/// AmountText(
///   amount: 123.45,
///   type: TransactionType.expense,
/// )
/// // Display: -¥123.45 (dark gray)
///
/// AmountText.large(
///   amount: 1000.00,
///   type: TransactionType.income,
///   dimDecimals: true,
/// )
/// // Display: +¥1,000.00 (income color, dimmed decimals)
/// ```
class AmountText extends ConsumerWidget {
  /// Amount value (always use positive/absolute value)
  final double amount;

  /// Transaction type
  final TransactionType type;

  /// Semantic type (Transaction, Trend, or Status)
  final AmountSemantic semantic;

  /// Currency code, priority: prop > global settings
  final String? currency;

  /// Custom text style
  final TextStyle? style;

  /// Whether to show positive/negative sign, default true
  final bool showSign;

  /// Whether to use compact format (e.g., 1.2k), default false
  final bool compact;

  /// Whether to dim decimal places, default false
  final bool dimDecimals;

  /// Whether to use tabular figures, default true
  final bool useTabularFigures;

  /// Whether to shrink the currency symbol, default false
  final bool shrinkCurrency;

  const AmountText({
    super.key,
    required this.amount,
    required this.type,
    this.semantic = AmountSemantic.transaction,
    this.currency,
    this.style,
    this.showSign = true,
    this.compact = false,
    this.dimDecimals = false,
    this.useTabularFigures = true,
    this.shrinkCurrency = false,
  });

  /// Large amount display (for detail pages, receipts, etc.)
  factory AmountText.large({
    Key? key,
    required double amount,
    required TransactionType type,
    AmountSemantic semantic = AmountSemantic.transaction,
    String? currency,
    bool showSign = true,
    bool dimDecimals = false,
    bool shrinkCurrency = false,
  }) {
    return AmountText(
      key: key,
      amount: amount,
      type: type,
      semantic: semantic,
      currency: currency,
      showSign: showSign,
      dimDecimals: dimDecimals,
      shrinkCurrency: shrinkCurrency,
      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    );
  }

  /// Small amount display (for list items)
  factory AmountText.small({
    Key? key,
    required double amount,
    required TransactionType type,
    AmountSemantic semantic = AmountSemantic.transaction,
    String? currency,
    bool showSign = true,
  }) {
    return AmountText(
      key: key,
      amount: amount,
      type: type,
      semantic: semantic,
      currency: currency,
      showSign: showSign,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    );
  }

  /// Compact amount display (for statistic cards)
  factory AmountText.compact({
    Key? key,
    required double amount,
    required TransactionType type,
    AmountSemantic semantic = AmountSemantic.transaction,
    String? currency,
    bool showSign = false,
    TextStyle? style,
  }) {
    return AmountText(
      key: key,
      amount: amount,
      type: type,
      semantic: semantic,
      currency: currency,
      showSign: showSign,
      compact: true,
      style: style,
    );
  }

  /// Create from backend display object (recommended for API responses)
  static Widget fromDisplay({
    Key? key,
    required Map<String, dynamic> display,
    required TransactionType type,
    TextStyle? style,
    bool useTabularFigures = true,
    bool compact = false,
  }) {
    return _AmountTextFromDisplay(
      key: key,
      display: display,
      type: type,
      style: style,
      useTabularFigures: useTabularFigures,
      compact: compact,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foruiTheme = context.theme;
    // Inject global amount theme reactively
    final amountTheme = ref.watch(currentAmountThemeValueProvider);

    // Resolve currency
    final effectiveCurrency =
        currency ?? ref.watch(financialSettingsProvider).primaryCurrency;

    final sign = showSign ? AmountFormatter.getAmountSign(type) : '';
    final symbol = AmountFormatter.getCurrencySymbol(effectiveCurrency);
    final absAmount = amount.abs();
    final formattedValue = compact
        ? AmountFormatter.formatCompact(absAmount)
        : NumberFormat.currency(
            locale: 'zh_CN',
            symbol: '',
            decimalDigits: 2,
          ).format(absAmount);

    // Resolve color based on semantic
    Color color;
    if (semantic == AmountSemantic.status) {
      // For status, prioritize style.color, then fall back to theme foreground
      color = style?.color ?? foruiTheme.colors.foreground;
    } else {
      // For transaction/trend, prioritize style.color, then fall back to amount theme
      color = style?.color ?? AmountFormatter.getAmountColor(type, amountTheme);
    }

    // Build effective style
    final baseStyle = style ?? foruiTheme.typography.base;
    var effectiveStyle = baseStyle.copyWith(color: color);

    // Add tabular figures feature
    if (useTabularFigures) {
      effectiveStyle = effectiveStyle.copyWith(
        fontFeatures: [
          ...?effectiveStyle.fontFeatures,
          const FontFeature.tabularFigures(),
        ],
      );
    }

    // Build RichText parts
    return Text.rich(
      TextSpan(
        style: effectiveStyle,
        children: [
          if (sign.isNotEmpty) TextSpan(text: sign),
          TextSpan(
            text: symbol,
            style: shrinkCurrency
                ? effectiveStyle.copyWith(
                    fontSize: (effectiveStyle.fontSize ?? 14) * 0.65,
                    color: effectiveStyle.color?.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w400,
                  )
                : null,
          ),
          if (dimDecimals && !compact)
            ..._buildDimDecimalsSpans(formattedValue, effectiveStyle)
          else
            TextSpan(text: formattedValue),
        ],
      ),
    );
  }

  /// Build TextSpans with dimmed decimals
  List<TextSpan> _buildDimDecimalsSpans(String text, TextStyle style) {
    // Separate integer and decimal parts
    final dotIndex = text.lastIndexOf('.');
    if (dotIndex == -1) {
      return [TextSpan(text: text, style: style)];
    }

    final integerPart = text.substring(0, dotIndex);
    final decimalPart = text.substring(dotIndex);

    return [
      TextSpan(text: integerPart, style: style),
      TextSpan(
        text: decimalPart,
        style: style.copyWith(
          color: style.color?.withValues(alpha: 0.5),
          fontSize: (style.fontSize ?? 14) * 0.85,
        ),
      ),
    ];
  }

  /// Build text with dimmed decimals
  @Deprecated('Use _buildDimDecimalsSpans instead')
  Widget _buildWithDimDecimals(String text, TextStyle style) {
    return Container();
  }
}

/// Amount change indicator
class AmountChangeIndicator extends StatelessWidget {
  final double changePercent;
  final AmountTheme?
  theme; // Optional, defaults to global via UI if not provided
  final TextStyle? style;
  final bool inverseColor;

  const AmountChangeIndicator({
    super.key,
    required this.changePercent,
    this.theme,
    this.style,
    this.inverseColor = false,
  });

  @override
  Widget build(BuildContext context) {
    final foruiTheme = context.theme;
    final isPositive = changePercent >= 0;

    // Fallback logic for StatelessWidget if theme not passed
    // NOTE: Prefer passing theme from a ConsumerWidget
    final activeTheme = theme ?? AmountTheme.chinaMarket;

    Color color;
    if (inverseColor) {
      color = isPositive ? activeTheme.expenseColor : activeTheme.incomeColor;
    } else {
      color = isPositive ? activeTheme.incomeColor : activeTheme.expenseColor;
    }

    final sign = isPositive ? '+' : '';
    final text = '$sign${changePercent.toStringAsFixed(1)}%';

    final effectiveStyle = (style ?? foruiTheme.typography.sm).copyWith(
      color: color,
    );

    return Text(text, style: effectiveStyle);
  }
}

/// Private widget for rendering from backend display object
class _AmountTextFromDisplay extends ConsumerWidget {
  final Map<String, dynamic> display;
  final TransactionType type;
  final TextStyle? style;
  final bool useTabularFigures;
  final bool compact;

  const _AmountTextFromDisplay({
    super.key,
    required this.display,
    required this.type,
    this.style,
    this.useTabularFigures = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foruiTheme = context.theme;
    final amountTheme = ref.watch(currentAmountThemeValueProvider);
    final color = AmountFormatter.getAmountColor(type, amountTheme);

    // Resolve default currency symbol from global settings if missing
    final primaryCurrency = ref
        .watch(financialSettingsProvider)
        .primaryCurrency;
    final defaultSymbol = AmountFormatter.getCurrencySymbol(primaryCurrency);

    String text;
    if (compact) {
      final sign = display['sign'] as String? ?? '';
      final currencySymbol =
          display['currencySymbol'] as String? ?? defaultSymbol;
      final value = double.tryParse(display['value'] as String? ?? '0') ?? 0;
      final compactValue = AmountFormatter.formatCompact(value);
      text = sign.isEmpty
          ? '$currencySymbol$compactValue'
          : '$sign $currencySymbol$compactValue';
    } else {
      text = display['fullString'] as String? ?? '';
    }

    var effectiveStyle = (style ?? foruiTheme.typography.base).copyWith(
      color: color,
    );

    if (useTabularFigures) {
      effectiveStyle = effectiveStyle.copyWith(
        fontFeatures: [
          ...?effectiveStyle.fontFeatures,
          const FontFeature.tabularFigures(),
        ],
      );
    }

    return Text(text, style: effectiveStyle);
  }
}
