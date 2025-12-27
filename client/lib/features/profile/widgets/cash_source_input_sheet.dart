import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';
import 'package:decimal/decimal.dart';
import '../models/financial_account.dart';
import '../../finance/models/account_type_definition.dart';
import 'package:augo/i18n/strings.g.dart';

class FinancialAccountInputSheet extends StatefulWidget {
  final AccountTypeDefinition definition;
  final FinancialAccount? initialAccount;
  final ValueChanged<FinancialAccount> onSubmitted;

  const FinancialAccountInputSheet({
    super.key,
    required this.definition,
    this.initialAccount,
    required this.onSubmitted,
  });

  @override
  State<FinancialAccountInputSheet> createState() =>
      _FinancialAccountInputSheetState();
}

class _FinancialAccountInputSheetState
    extends State<FinancialAccountInputSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  bool _isLoading = false;
  late bool _isPreset;

  @override
  void initState() {
    super.initState();
    // Determine whether to show name input based on requiresCustomName
    // CASH type doesn't need name, but DEPOSIT, etc., do
    _isPreset = !widget.definition.requiresCustomName;

    final initial = widget.initialAccount;
    if (initial != null) {
      // Use name field as account name
      _nameController.text = initial.name;
      _balanceController.text =
          (double.tryParse(initial.initialBalance.toString()) ?? 0)
              .toStringAsFixed(2);
    }
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
    final definition = widget.definition;
    final showNameField = !_isPreset || definition.requiresCustomName;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: colors.background,
          border: Border.symmetric(
            horizontal: BorderSide(color: colors.border),
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).padding.bottom + 24,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getLocalizedTitle(definition),
                      style: theme.typography.xl2.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.foreground,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _getLocalizedSubtitle(definition),
                      style: theme.typography.sm.copyWith(
                        color: colors.mutedForeground,
                      ),
                    ),
                    if (_hasHelper(definition)) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: colors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          _getLocalizedHelper(definition),
                          style: theme.typography.xs.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colors.primary,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    Center(
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: colors.secondary,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: colors.border),
                        ),
                        child: Center(
                          child: definition.iconBuilder(colors.foreground),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    if (showNameField) ...[
                      Text(
                        'Account Name',
                        style: theme.typography.sm.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hintText:
                              'e.g., Bank of China Debit Card, Petty Cash',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter account name';
                          }
                          if (value.trim().length < 2) {
                            return 'Account name must be at least 2 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                    Text(
                      'Current Balance',
                      style: theme.typography.sm.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _balanceController,
                      decoration: InputDecoration(
                        hintText: '0.00',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          child: Text(
                            '¥',
                            style: theme.typography.sm.copyWith(
                              color: colors.mutedForeground,
                            ),
                          ),
                        ),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}'),
                        ),
                      ],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter current balance';
                        }
                        final amount = double.tryParse(value.trim());
                        if (amount == null) {
                          return 'Please enter a valid amount';
                        }
                        if (amount < 0) {
                          return 'Balance cannot be negative';
                        }
                        if (amount > 999999999.99) {
                          return 'Balance cannot exceed 999,999,999.99';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 28),
                    FButton(
                      onPress: _isLoading ? null : _handleSave,
                      child: _isLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox.square(
                                  dimension: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: colors.primaryForeground,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text('Saving...'),
                              ],
                            )
                          : Text(t.common.save),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final balance = Decimal.parse(_balanceController.text.trim());
      final definition = widget.definition;
      final shouldPersistName = definition.requiresCustomName;
      final trimmedName = _nameController.text.trim();

      // Infer FinancialNature from AccountTypeDefinition's nature
      final nature = _inferNature(definition.nature);

      // Use definition's apiType directly
      final accountType = definition.apiType;

      // Use account name: custom name priority, otherwise use definition title
      final accountName = (shouldPersistName && trimmedName.isNotEmpty)
          ? trimmedName
          : definition.title.split(' ').first; // Take part of the title

      final financialAccount = FinancialAccount(
        name: accountName,
        nature: nature,
        type: accountType,
        initialBalance: balance,
        includeInNetWorth: true,
      );

      widget.onSubmitted(financialAccount);
    } catch (e) {
      if (mounted) {
        // Show error dialog instead of SnackBar
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Save Failed'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Infer API FinancialNature from UI AccountNature
  FinancialNature _inferNature(AccountNature uiNature) {
    switch (uiNature) {
      case AccountNature.liquidAssets:
      case AccountNature.investmentAssets:
      case AccountNature.receivablesPayables:
      case AccountNature.otherAssets:
        return FinancialNature.asset;
      case AccountNature.creditAccounts:
      case AccountNature.longTermLiabilities:
        return FinancialNature.liability;
    }
  }

  /// Infer FinancialAccountType from definition.id
  FinancialAccountType? _inferAccountType(String id) {
    switch (id) {
      case 'cash':
        return FinancialAccountType.cash;
      case 'bank_account':
        return FinancialAccountType.deposit;
      case 'digital_wallet':
        return FinancialAccountType.eMoney;
      case 'credit_card':
        return FinancialAccountType.creditCard;
      case 'stocks_funds':
      case 'other_investments':
        return FinancialAccountType.investment;
      case 'receivable':
      case 'reimbursement':
        return FinancialAccountType.receivable;
      case 'payable':
        return FinancialAccountType.payable;
      case 'mortgage':
      case 'auto_loan':
      case 'consumer_student_loan':
      case 'line_of_credit':
        return FinancialAccountType.loan;
      default:
        return null;
    }
  }

  /// Gets localized title
  String _getLocalizedTitle(AccountTypeDefinition definition) {
    switch (definition.id) {
      case 'cash':
        return t.account.types.cashTitle;
      case 'deposit':
        return t.account.types.depositTitle;
      case 'e_money':
        return t.account.types.eMoneyTitle;
      case 'investment':
        return t.account.types.investmentTitle;
      case 'receivable':
        return t.account.types.receivableTitle;
      case 'credit_card':
        return t.account.types.creditCardTitle;
      case 'loan':
        return t.account.types.loanTitle;
      case 'payable':
        return t.account.types.payableTitle;
      default:
        return definition.title;
    }
  }

  /// Gets localized subtitle
  String _getLocalizedSubtitle(AccountTypeDefinition definition) {
    switch (definition.id) {
      case 'cash':
        return t.account.types.cashSubtitle;
      case 'deposit':
        return t.account.types.depositSubtitle;
      case 'e_money':
        return t.account.types.eMoneySubtitle;
      case 'investment':
        return t.account.types.investmentSubtitle;
      case 'receivable':
        return t.account.types.receivableSubtitle;
      case 'credit_card':
        return t.account.types.creditCardSubtitle;
      case 'loan':
        return t.account.types.loanSubtitle;
      case 'payable':
        return t.account.types.payableSubtitle;
      default:
        return definition.subtitle;
    }
  }

  /// Checks if there is helper text
  bool _hasHelper(AccountTypeDefinition definition) {
    return definition.id == 'receivable' || definition.id == 'payable';
  }

  /// Gets localized helper text
  String _getLocalizedHelper(AccountTypeDefinition definition) {
    switch (definition.id) {
      case 'receivable':
        return t.account.types.receivableHelper;
      case 'payable':
        return t.account.types.payableHelper;
      default:
        return '';
    }
  }
}
