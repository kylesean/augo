import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:forui/forui.dart';

import '../../profile/models/financial_account.dart';
import '../../profile/providers/financial_account_provider.dart';
import '../models/account_type_definition.dart';
import '../../../shared/models/currency.dart';
import '../widgets/currency_selection_sheet.dart';
import 'package:augo/i18n/strings.g.dart';

class FinancialAccountEditArgs {
  const FinancialAccountEditArgs({
    required this.definition,
    required this.account,
  });

  final AccountTypeDefinition definition;
  final FinancialAccount account;
}

/// 编辑账户页面 - 紧凑布局设计
class FinancialAccountEditPage extends ConsumerStatefulWidget {
  const FinancialAccountEditPage({super.key, required this.args});

  final FinancialAccountEditArgs args;

  @override
  ConsumerState<FinancialAccountEditPage> createState() =>
      _FinancialAccountEditPageState();
}

class _FinancialAccountEditPageState
    extends ConsumerState<FinancialAccountEditPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _balanceController;
  late Currency _selectedCurrency;
  bool _hidden = false;
  bool _includeInAssets = true;

  @override
  void initState() {
    super.initState();
    final account = widget.args.account;
    _nameController = TextEditingController(text: account.name);
    _balanceController = TextEditingController(
      text: _formatAmount(account.currentBalance ?? account.initialBalance),
    );
    _selectedCurrency = Currency.fromCode(account.currencyCode) ?? Currency.cny;
    _hidden = account.status == AccountStatus.inactive;
    _includeInAssets = account.includeInNetWorth;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;
    final definition = widget.args.definition;

    return Scaffold(
      backgroundColor: colors.background,
      resizeToAvoidBottomInset:
          false, // Preventing the keyboard from lifting the layout
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(FIcons.chevronLeft, color: colors.foreground),
          onPressed: () => context.pop(),
        ),
        titleSpacing: 0,
        centerTitle: true,
        title: Text(
          t.account.editTitle,
          style: theme.typography.lg.copyWith(
            fontWeight: FontWeight.w600,
            color: colors.foreground,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(FIcons.trash, color: colors.destructive),
            onPressed: _handleDelete,
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                child: _buildFormCard(theme, colors, definition),
              ),
            ),
          ],
        ),
      ),
      // Fixed save button at the bottom
      bottomNavigationBar: _buildSaveButton(theme, colors),
    );
  }

  /// Unified form card - all input items are combined into one card
  Widget _buildFormCard(
    FThemeData theme,
    FColors colors,
    AccountTypeDefinition definition,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.border.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Account name
          _buildInputRow(
            theme: theme,
            colors: colors,
            icon: definition.iconBuilder(colors.foreground),
            label: t.account.nameLabel,
            child: TextField(
              controller: _nameController,
              style: theme.typography.base.copyWith(
                color: colors.foreground,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: t.account.nameHint,
                hintStyle: theme.typography.base.copyWith(
                  color: colors.mutedForeground,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              maxLength: 16,
              buildCounter:
                  (
                    _, {
                    required currentLength,
                    required isFocused,
                    required maxLength,
                  }) => null,
            ),
          ),

          _buildDivider(colors),

          // Current balance
          _buildInputRow(
            theme: theme,
            colors: colors,
            icon: Text(
              _selectedCurrency.symbol,
              style: theme.typography.base.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.primary,
              ),
            ),
            label: t.account.amountLabel,
            child: TextField(
              controller: _balanceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
              ],
              style: theme.typography.base.copyWith(
                color: colors.foreground,
                fontWeight: FontWeight.w600,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
              decoration: InputDecoration(
                hintText: t.account.amountHint,
                hintStyle: theme.typography.base.copyWith(
                  color: colors.mutedForeground,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),

          _buildDivider(colors),

          // Currency selection
          _buildTapRow(
            theme: theme,
            colors: colors,
            icon: Icon(FIcons.globe, size: 20, color: colors.primary),
            label: t.account.currencyLabel,
            value:
                '${_selectedCurrency.code} - ${_selectedCurrency.localizedName}',
            showArrow: true,
            onTap: _openCurrencyPicker,
          ),

          _buildDivider(colors),

          // Hidden switch
          _buildSwitchRow(
            theme: theme,
            colors: colors,
            title: t.account.hiddenLabel,
            subtitle: t.account.hiddenDesc,
            value: _hidden,
            onChanged: (value) => setState(() => _hidden = value),
          ),

          _buildDivider(colors),

          // Include in net worth switch
          _buildSwitchRow(
            theme: theme,
            colors: colors,
            title: t.account.includeInNetWorthLabel,
            subtitle: t.account.includeInNetWorthDesc,
            value: _includeInAssets,
            onChanged: (value) => setState(() => _includeInAssets = value),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(FColors colors) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 56,
      color: colors.border.withValues(alpha: 0.3),
    );
  }

  /// Input row component
  Widget _buildInputRow({
    required FThemeData theme,
    required FColors colors,
    required Widget icon,
    required String label,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          SizedBox(width: 36, height: 36, child: Center(child: icon)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: theme.typography.xs.copyWith(
                    color: colors.mutedForeground,
                  ),
                ),
                const SizedBox(height: 2),
                child,
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Clickable row component
  Widget _buildTapRow({
    required FThemeData theme,
    required FColors colors,
    required Widget icon,
    required String label,
    required String value,
    bool showArrow = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            SizedBox(width: 36, height: 36, child: Center(child: icon)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: theme.typography.xs.copyWith(
                      color: colors.mutedForeground,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: theme.typography.base.copyWith(
                      color: colors.foreground,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (showArrow)
              Icon(
                FIcons.chevronRight,
                size: 16,
                color: colors.mutedForeground,
              ),
          ],
        ),
      ),
    );
  }

  /// Switch row component
  Widget _buildSwitchRow({
    required FThemeData theme,
    required FColors colors,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: isLast
          ? const BorderRadius.vertical(bottom: Radius.circular(16))
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: theme.typography.base.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colors.foreground,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: theme.typography.xs.copyWith(
                      color: colors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
            FSwitch(value: value, onChange: onChanged),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton(FThemeData theme, FColors colors) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: BoxDecoration(
        color: colors.background,
        border: Border(
          top: BorderSide(
            color: colors.border.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: 8),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: FButton(onPress: _handleSave, child: Text(t.account.save)),
        ),
      ),
    );
  }

  Future<void> _openCurrencyPicker() async {
    final result = await CurrencySelectionSheet.show(
      context,
      _selectedCurrency.code,
    );
    if (!mounted || result == null) return;
    setState(() {
      _selectedCurrency = Currency.fromCode(result) ?? Currency.cny;
    });
  }

  void _handleDelete() {
    showFDialog(
      context: context,
      builder: (context, style, animation) => FDialog(
        style: style.call,
        animation: animation,
        title: Text(t.account.deleteAccount),
        body: Text(t.account.deleteConfirm),
        actions: [
          FButton(
            onPress: () {
              Navigator.pop(context);
              _performDelete();
            },
            child: Text(t.common.delete),
          ),
          FButton(
            style: FButtonStyle.outline(),
            onPress: () => Navigator.pop(context),
            child: Text(t.common.cancel),
          ),
        ],
      ),
    );
  }

  Future<void> _performDelete() async {
    final currentAccounts = ref.read(financialAccountProvider).accounts;
    final accountToDelete = widget.args.account;

    // Use ID or name+type combination to match accounts
    final updatedList = currentAccounts.where((a) {
      if (accountToDelete.id != null && a.id != null) {
        return a.id != accountToDelete.id;
      }
      // If ID is null, use name and type combination matching
      return !(a.name == accountToDelete.name &&
          a.type == accountToDelete.type &&
          a.currencyCode == accountToDelete.currencyCode);
    }).toList();

    final success = await ref
        .read(financialAccountProvider.notifier)
        .saveFinancialAccounts(updatedList);

    // Save successfully, refresh list
    if (success && mounted) {
      await ref.read(financialAccountProvider.notifier).loadFinancialAccounts();
    }

    if (mounted) {
      context.pop();
    }
  }

  Future<void> _handleSave() async {
    final name = _nameController.text.trim();
    final balanceText = _balanceController.text.trim();

    Decimal balance;
    try {
      balance = Decimal.parse(balanceText.isEmpty ? '0' : balanceText);
    } catch (_) {
      balance = Decimal.zero;
    }

    final updatedAccount = widget.args.account.copyWith(
      name: name.isNotEmpty ? name : widget.args.account.name,
      currencyCode: _selectedCurrency.code,
      currentBalance: balance,
      includeInNetWorth: _includeInAssets,
      status: _hidden ? AccountStatus.inactive : AccountStatus.active,
    );

    final currentAccounts = ref.read(financialAccountProvider).accounts;
    final updatedList = currentAccounts.map((a) {
      if (a.id == updatedAccount.id) return updatedAccount;
      return a;
    }).toList();

    final success = await ref
        .read(financialAccountProvider.notifier)
        .saveFinancialAccounts(updatedList);

    // Save successfully, refresh list
    if (success && mounted) {
      await ref.read(financialAccountProvider.notifier).loadFinancialAccounts();
    }

    if (mounted) {
      context.pop(updatedAccount);
    }
  }

  String _formatAmount(Decimal balance) {
    final value = double.tryParse(balance.toString()) ?? 0.0;
    return value.toStringAsFixed(2);
  }
}
