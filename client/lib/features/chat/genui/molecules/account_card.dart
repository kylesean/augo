import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:augo/features/profile/providers/financial_settings_provider.dart';
import '../atoms/atoms.dart';

class AccountCard extends ConsumerWidget {
  /// Account data map containing id, name, balance, type, currency, subtitle
  final Map<String, dynamic> data;

  /// Whether this card is currently selected
  final bool selected;

  /// Whether the card is enabled for interaction
  final bool enabled;

  /// Callback when card is tapped
  final VoidCallback? onTap;

  /// Whether to show the balance amount
  final bool showBalance;

  /// Whether to show selection indicator (checkmark)
  final bool showSelectionIndicator;

  const AccountCard({
    super.key,
    required this.data,
    this.selected = false,
    this.enabled = true,
    this.onTap,
    this.showBalance = true,
    this.showSelectionIndicator = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.theme;
    final colors = theme.colors;
    final financialSettings = ref.watch(financialSettingsProvider);
    final primaryCurrency = financialSettings.primaryCurrency;

    // Extract data
    final name = data['name'] as String? ?? '';
    final balance =
        data['currentBalance'] ?? data['current_balance'] ?? data['balance'];
    final type = data['type'] as String?;
    final currency = data['currency'] as String? ?? primaryCurrency;
    final subtitle = data['subtitle'] as String?;

    // Style based on state
    final bgColor = selected
        ? colors.primary.withValues(alpha: 0.1)
        : colors.secondary;
    final borderColor = selected ? colors.primary : Colors.transparent;
    final borderWidth = selected ? 2.0 : 0.0;

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: borderWidth),
        ),
        child: Row(
          children: [
            // Account type icon
            IconBadge.fromAccountType(
              accountType: type,
              colors: colors,
              size: 44,
            ),
            const SizedBox(width: 12),

            // Name and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: theme.typography.base.copyWith(
                      fontWeight: FontWeight.w600,
                      color: selected ? colors.primary : colors.foreground,
                    ),
                  ),
                  if (subtitle != null && subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: theme.typography.xs.copyWith(
                        color: colors.mutedForeground,
                      ),
                    ),
                ],
              ),
            ),

            // Balance
            if (showBalance && balance != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AmountDisplay(
                    amount: balance is num
                        ? balance
                        : num.tryParse(balance.toString()) ?? 0,
                    currency: currency,
                    style: theme.typography.sm.copyWith(
                      fontWeight: FontWeight.w600,
                      color: selected ? colors.primary : colors.foreground,
                    ),
                  ),
                  if (currency != primaryCurrency)
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        currency,
                        style: theme.typography.xs.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colors.primary,
                        ),
                      ),
                    ),
                ],
              ),

            // Selection indicator
            if (showSelectionIndicator && selected) ...[
              const SizedBox(width: 8),
              Icon(FIcons.check, color: colors.primary, size: 22),
            ],
          ],
        ),
      ),
    );
  }
}

/// A compact account display for inline use
class CompactAccountCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool selected;
  final VoidCallback? onTap;

  const CompactAccountCard({
    super.key,
    required this.data,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    final name = data['name'] as String? ?? '';
    final type = data['type'] as String?;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: selected
              ? colors.primary.withValues(alpha: 0.1)
              : colors.secondary,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? colors.primary : colors.border,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconBadge.fromAccountType(
              accountType: type,
              colors: colors,
              size: 36,
            ),
            const SizedBox(height: 4),
            Text(
              name,
              style: theme.typography.xs.copyWith(
                fontWeight: FontWeight.w600,
                color: selected ? colors.primary : colors.foreground,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
