import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:augo/i18n/strings.g.dart';
import 'package:augo/shared/widgets/themed_icon.dart';
import 'dart:async';

import '../../profile/models/financial_account.dart';
import '../../profile/providers/financial_account_provider.dart';
import '../models/account_type_definition.dart';

/// 账户选择返回结果
class AccountSelectionResult {
  final String accountId;
  final String accountName;

  const AccountSelectionResult({
    required this.accountId,
    required this.accountName,
  });
}

/// 账户选择底部弹窗 - 参考财务账户首页列表设计
class AccountSelectionSheet extends ConsumerStatefulWidget {
  final String title;
  final String? selectedAccountId;

  const AccountSelectionSheet({
    super.key,
    required this.title,
    this.selectedAccountId,
  });

  /// 显示弹窗
  static Future<AccountSelectionResult?> show(
    BuildContext context, {
    required String title,
    String? selectedAccountId,
  }) {
    return showModalBottomSheet<AccountSelectionResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AccountSelectionSheet(
        title: title,
        selectedAccountId: selectedAccountId,
      ),
    );
  }

  @override
  ConsumerState<AccountSelectionSheet> createState() =>
      _AccountSelectionSheetState();
}

class _AccountSelectionSheetState extends ConsumerState<AccountSelectionSheet> {
  bool get isZh => LocaleSettings.currentLocale == AppLocale.zh;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(ref.read(financialAccountProvider.notifier).loadFinancialAccounts());
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;
    final accountState = ref.watch(financialAccountProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // 拖动条
            Container(
              width: 32,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // 标题栏
            _buildHeader(theme, colors),
            const SizedBox(height: 16),
            // 账户列表
            Expanded(
              child: accountState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : accountState.error != null
                  ? Center(
                      child: Text(
                        '${t.common.loadFailed}: ${accountState.error}',
                      ),
                    )
                  : _buildAccountList(theme, colors, accountState.accounts),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(FThemeData theme, FColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Text(
              t.common.cancel,
              style: theme.typography.base.copyWith(
                color: colors.mutedForeground,
              ),
            ),
          ),
          Expanded(
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: theme.typography.base.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.foreground,
              ),
            ),
          ),
          const SizedBox(width: 48), // 平衡取消按钮
        ],
      ),
    );
  }

  Widget _buildAccountList(
    FThemeData theme,
    FColors colors,
    List<FinancialAccount> accounts,
  ) {
    // 只获取资产账户（周期交易只需要资产账户）
    final assetAccounts = accounts
        .where((a) => a.nature == FinancialNature.asset)
        .toList();

    if (assetAccounts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ThemedIcon.large(
              icon: FIcons.wallet,
              backgroundColor: colors.secondary,
            ),
            const SizedBox(height: 12),
            Text(
              isZh ? '暂无资产账户' : 'No asset accounts',
              style: theme.typography.sm.copyWith(
                color: colors.mutedForeground,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isZh
                  ? '请前往财务页面添加账户'
                  : 'Please go to the financial page to add accounts',
              style: theme.typography.xs.copyWith(
                color: colors.mutedForeground.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        _buildSectionHeader(theme, colors, isZh ? '选择账户' : 'Select Account'),
        ...assetAccounts.map(
          (account) => _buildAccountCard(theme, colors, account),
        ),
        const SizedBox(height: 24), // 底部空间
      ],
    );
  }

  Widget _buildSectionHeader(FThemeData theme, FColors colors, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: theme.typography.sm.copyWith(
          color: colors.mutedForeground,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// 账户卡片 - 参考 FinancialAccountsPage 的设计
  Widget _buildAccountCard(
    FThemeData theme,
    FColors colors,
    FinancialAccount account,
  ) {
    final definition = AccountTypeRegistry.resolveByApiType(account.type);
    final isLiabilityAccount = account.nature == FinancialNature.liability;
    final isSelected = account.id == widget.selectedAccountId;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: FCard(
        child: Material(
          type: MaterialType.transparency,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop(
                AccountSelectionResult(
                  accountId: account.id ?? '',
                  accountName: account.name,
                ),
              );
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: isSelected
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: colors.primary, width: 2),
                    )
                  : null,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Row(
                children: [
                  // 图标 - 使用统一的设计 token
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: colors.secondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: definition != null
                          ? definition.iconBuilder(colors.foreground)
                          : Icon(
                              isLiabilityAccount
                                  ? FIcons.creditCard
                                  : FIcons.wallet,
                              color: colors.foreground,
                              size: 18,
                            ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // 名称和类型
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          account.name,
                          style: theme.typography.base.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colors.foreground,
                          ),
                        ),
                        Text(
                          definition != null
                              ? _getTypeDisplayName(definition)
                              : (isLiabilityAccount
                                    ? (isZh ? '负债账户' : 'Liability Account')
                                    : (isZh ? '资产账户' : 'Asset Account')),
                          style: theme.typography.sm.copyWith(
                            color: colors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 余额
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${isLiabilityAccount ? '-' : ''}${_formatAmount(account.currentBalance ?? account.initialBalance)}',
                        style: theme.typography.base.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colors.foreground,
                          fontFeatures: [const FontFeature.tabularFigures()],
                        ),
                      ),
                      Text(
                        account.currencyCode,
                        style: theme.typography.sm.copyWith(
                          color: colors.mutedForeground,
                        ),
                      ),
                    ],
                  ),

                  // 选中标记
                  if (isSelected) ...[
                    const SizedBox(width: 8),
                    Icon(FIcons.check, color: colors.primary, size: 20),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatAmount(Decimal amount) {
    final value = double.tryParse(amount.toString()) ?? 0.0;
    final parts = value.toStringAsFixed(2).split('.');
    final intPart = parts[0];
    final decPart = parts[1];

    var formatted = '';
    var count = 0;
    for (int i = intPart.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0 && intPart[i] != '-') {
        formatted = ',$formatted';
      }
      formatted = intPart[i] + formatted;
      count++;
    }
    return '$formatted.$decPart';
  }

  String _getTypeDisplayName(AccountTypeDefinition definition) {
    switch (definition.id) {
      case 'cash':
        return isZh ? '现金钱包' : 'Cash';
      case 'deposit':
        return isZh ? '银行存款' : 'Bank Deposit';
      case 'e_money':
        return isZh ? '电子钱包' : 'E-Wallet';
      case 'investment':
        return isZh ? '投资理财' : 'Investment';
      case 'receivable':
        return isZh ? '应收款项' : 'Accounts Receivable';
      case 'credit_card':
        return isZh ? '信用卡' : 'Credit Card';
      case 'loan':
        return isZh ? '贷款账户' : 'Loan Account';
      case 'payable':
        return isZh ? '应付款项' : 'Accounts Payable';
      default:
        return definition.title;
    }
  }
}
