import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:augo/i18n/strings.g.dart';
import '../molecules/molecules.dart';

class AccountPickerCard extends StatelessWidget {
  final List<Map<String, dynamic>> accounts;
  final String? selectedId;
  final ValueChanged<String>? onSelect;
  final String? title;
  final String? subtitle;
  final String? confirmText;
  final VoidCallback? onConfirm;
  final bool enabled;
  final String? transactionCurrency;

  const AccountPickerCard({
    super.key,
    required this.accounts,
    this.selectedId,
    this.onSelect,
    this.title,
    this.subtitle,
    this.confirmText,
    this.onConfirm,
    this.enabled = true,
    this.transactionCurrency,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    final displayTitle = title ?? t.chat.transferWizard.selectAccount;
    final displayConfirm = confirmText ?? t.common.confirm;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          displayTitle,
          style: theme.typography.base.copyWith(
            fontWeight: FontWeight.w600,
            color: colors.foreground,
          ),
        ),

        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            subtitle!,
            style: theme.typography.xs.copyWith(color: colors.primary),
          ),
        ],

        const SizedBox(height: 12),
        ...accounts.map((account) {
          final id = account['id'] as String? ?? '';
          final isSelected = id == selectedId;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: AccountCard(
              data: account,
              selected: isSelected,
              enabled: enabled,
              onTap: enabled ? () => onSelect?.call(id) : null,
            ),
          );
        }),

        const SizedBox(height: 16),
        _buildConfirmButton(theme, colors, displayConfirm),
      ],
    );
  }

  Widget _buildConfirmButton(
    FThemeData theme,
    FColors colors,
    String displayConfirm,
  ) {
    final canConfirm = enabled && selectedId != null;
    final isConfirmedState = !enabled && selectedId != null;

    if (isConfirmedState) {
      return FCard(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(FIcons.check, size: 16, color: colors.primary),
              const SizedBox(width: 8),
              Text(
                displayConfirm,
                style: theme.typography.sm.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.primary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return FButton(
      onPress: canConfirm ? onConfirm : null,
      child: Text(displayConfirm),
    );
  }
}
