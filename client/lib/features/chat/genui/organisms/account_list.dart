import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:augo/i18n/strings.g.dart';
import '../molecules/molecules.dart';

/// A container widget for displaying a list of accounts
///
/// This is a Layer 3 (Organism) component that manages
/// a scrollable list of [AccountCard] widgets.
class AccountList extends StatelessWidget {
  /// List of account data maps
  final List<Map<String, dynamic>> accounts;

  /// Currently selected account ID
  final String? selectedId;

  /// Callback when an account is selected
  final void Function(String accountId, Map<String, dynamic> account)?
  onAccountSelected;

  /// Whether accounts are enabled for interaction
  final bool enabled;

  /// Title to display above the list
  final String? title;

  /// Whether to show account balance
  final bool showBalance;

  const AccountList({
    super.key,
    required this.accounts,
    this.selectedId,
    this.onAccountSelected,
    this.enabled = true,
    this.title,
    this.showBalance = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    if (accounts.isEmpty) {
      return _buildEmptyState(theme, colors);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title!,
                style: theme.typography.sm.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colors.foreground,
                ),
              ),
              Text(
                t.chat.genui.transactionGroupReceipt.count(
                  count: accounts.length.toString(),
                ),
                style: theme.typography.xs.copyWith(
                  color: colors.mutedForeground,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
        ...accounts.map((account) {
          final accountId = account['id'] as String? ?? '';
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: AccountCard(
              data: account,
              selected: selectedId == accountId,
              enabled: enabled,
              showBalance: showBalance,
              onTap: enabled && onAccountSelected != null
                  ? () => onAccountSelected!(accountId, account)
                  : null,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildEmptyState(FThemeData theme, FColors colors) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(FIcons.wallet, size: 48, color: colors.mutedForeground),
            const SizedBox(height: 16),
            Text(
              t.financial.noAccounts,
              style: theme.typography.base.copyWith(
                color: colors.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
