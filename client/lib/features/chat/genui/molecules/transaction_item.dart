import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:augo/features/profile/providers/financial_settings_provider.dart';
import '../atoms/atoms.dart';
import '../utils/formatters.dart';
import '../utils/theme_helpers.dart' as helpers;

/// A compact transaction item for lists
///
/// This is a Layer 2 (Molecule) component composed of [IconBadge],
/// [AmountDisplay], and [StatusChip]. Used for displaying transactions
/// in lists or summaries.

class TransactionItem extends ConsumerWidget {
  /// Transaction data map
  final Map<String, dynamic> data;

  /// Callback when item is tapped
  final VoidCallback? onTap;

  /// Whether to show the category chip
  final bool showCategory;

  /// Whether to show the time
  final bool showTime;

  const TransactionItem({
    super.key,
    required this.data,
    this.onTap,
    this.showCategory = true,
    this.showTime = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.theme;
    final colors = theme.colors;
    final financialSettings = ref.watch(financialSettingsProvider);

    // Extract data
    final description =
        data['description'] as String? ??
        data['raw_input'] as String? ??
        data['title'] as String? ??
        '';
    final amount = data['amount'];
    final category =
        data['category'] as String? ?? data['category_key'] as String?;
    final timestamp =
        data['timestamp'] as String? ?? data['transaction_at'] as String?;
    final currency =
        data['currency'] as String? ?? financialSettings.primaryCurrency;

    // Determine if expense or income
    final typeValue = data['type'];
    final bool isExpense;
    if (typeValue is bool) {
      isExpense = !typeValue;
    } else if (typeValue is String) {
      isExpense = typeValue.toUpperCase() != 'INCOME';
    } else {
      isExpense = true;
    }

    // Use theme helpers for category style
    final categoryStyle = helpers.getCategoryStyle(category);
    final amountNum = amount is num
        ? amount
        : num.tryParse(amount?.toString() ?? '0') ?? 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            // Category icon
            IconBadge(icon: categoryStyle.icon, size: 40),
            const SizedBox(width: 12),

            // Description and time
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    description,
                    style: theme.typography.base.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colors.foreground,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (showTime && timestamp != null)
                    Text(
                      formatRelativeTime(timestamp),
                      style: theme.typography.xs.copyWith(
                        color: colors.mutedForeground,
                      ),
                    ),
                ],
              ),
            ),

            // Amount
            AmountDisplay(
              amount: amountNum,
              currency: currency,
              showSign: true,
              style: theme.typography.base.copyWith(
                fontWeight: FontWeight.w600,
                color: isExpense ? colors.destructive : colors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
