import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:forui/forui.dart';
import 'dart:async';

import '../../profile/models/financial_account.dart';
import '../../profile/providers/financial_account_provider.dart';
import '../models/account_type_definition.dart';
import '../../../shared/models/currency.dart';
import '../../../shared/widgets/themed_icon.dart';
import 'account_edit_page.dart';
import '../providers/financial_summary_provider.dart';
import '../widgets/currency_selection_sheet.dart';

/// 账户管理页面 - 严格参照设计稿
class AccountSourcesPage extends ConsumerStatefulWidget {
  const AccountSourcesPage({super.key});

  @override
  ConsumerState<AccountSourcesPage> createState() => _AccountSourcesPageState();
}

class _AccountSourcesPageState extends ConsumerState<AccountSourcesPage> {
  bool _hideAmounts = false;
  String _viewCurrency = 'CNY';

  @override
  void initState() {
    super.initState();
    // 页面初始化时调用 API 加载账户列表
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(
        ref.read(financialAccountProvider.notifier).loadFinancialAccounts(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;
    final state = ref.watch(financialAccountProvider);
    final accounts = state.accounts;

    // Calculate totals based on nature field from API
    // Use the reactive summary provider
    final summary = ref.watch(financialSummaryProvider(_viewCurrency));
    final totalNetWorth = summary.totalNetWorth;
    final totalAssets = summary.totalAssets;
    final totalLiabilities = summary.totalLiabilities;

    // Group accounts by nature field
    final assetAccounts = accounts
        .where((a) => a.nature == FinancialNature.asset)
        .toList();

    final liabilityAccounts = accounts
        .where((a) => a.nature == FinancialNature.liability)
        .toList();

    return FScaffold(
      header: FHeader(
        title: Text(
          '账户管理',
          style: theme.typography.xl.copyWith(fontWeight: FontWeight.w600),
        ),
        suffixes: [
          FHeaderAction(icon: const Icon(FIcons.plus), onPress: _addAccount),
        ],
      ),
      child: _buildBody(
        theme,
        colors,
        state,
        accounts,
        assetAccounts,
        liabilityAccounts,
        totalNetWorth,
        totalAssets,
        totalLiabilities,
      ),
    );
  }

  /// 构建页面主体内容
  Widget _buildBody(
    FThemeData theme,
    FColors colors,
    FinancialAccountState state,
    List<FinancialAccount> accounts,
    List<FinancialAccount> assetAccounts,
    List<FinancialAccount> liabilityAccounts,
    Decimal totalNetWorth,
    Decimal totalAssets,
    Decimal totalLiabilities,
  ) {
    // 加载状态
    if (state.isLoading && accounts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // 错误状态
    if (state.error != null && accounts.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(FIcons.circleAlert, size: 48, color: colors.mutedForeground),
              const SizedBox(height: 16),
              Text(
                state.error!,
                textAlign: TextAlign.center,
                style: theme.typography.sm.copyWith(
                  color: colors.mutedForeground,
                ),
              ),
              const SizedBox(height: 24),
              FButton(
                style: FButtonStyle.outline(),
                onPress: () {
                  unawaited(
                    ref
                        .read(financialAccountProvider.notifier)
                        .loadFinancialAccounts(),
                  );
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // 正常内容
    return LayoutBuilder(
      builder: (context, constraints) {
        // 如果可用高度太小，只显示列表
        final showCard = constraints.maxHeight > 300;

        return Column(
          children: [
            // Black gold card at top (只在有足够空间时显示)
            if (showCard)
              _buildNetWorthCard(
                theme,
                colors,
                totalNetWorth,
                totalAssets,
                totalLiabilities,
              ),

            // Account list
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await ref
                      .read(financialAccountProvider.notifier)
                      .loadFinancialAccounts();
                },
                child: accounts.isEmpty
                    ? _buildEmptyState(theme, colors)
                    : ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          if (assetAccounts.isNotEmpty) ...[
                            _buildSectionHeader(theme, colors, '资产账户'),
                            ...assetAccounts.map(
                              (account) =>
                                  _buildAccountCard(theme, colors, account),
                            ),
                          ],
                          if (liabilityAccounts.isNotEmpty) ...[
                            _buildSectionHeader(theme, colors, '负债账户'),
                            ...liabilityAccounts.map(
                              (account) =>
                                  _buildAccountCard(theme, colors, account),
                            ),
                          ],
                          const SizedBox(height: 40), // Bottom spacing
                        ],
                      ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// 构建空状态界面
  Widget _buildEmptyState(FThemeData theme, FColors colors) {
    return ListView(
      children: [
        const SizedBox(height: 100),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FIcons.wallet,
                size: 64,
                color: colors.mutedForeground.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                '暂无账户',
                style: theme.typography.lg.copyWith(
                  color: colors.mutedForeground,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '点击下方按钮添加您的第一个账户',
                style: theme.typography.sm.copyWith(
                  color: colors.mutedForeground.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNetWorthCard(
    FThemeData theme,
    FColors colors,
    Decimal netWorth,
    Decimal assets,
    Decimal liabilities,
  ) {
    final currency = Currency.fromCode(_viewCurrency) ?? Currency.cny;
    final currencySymbol = currency.symbol;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.primary, // Use theme primary color
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TOTAL NET WORTH',
                style: theme.typography.xs.copyWith(
                  color: colors.primaryForeground.withValues(alpha: 0.6),
                  letterSpacing: 1.2,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // TODO: Open settings
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colors.primaryForeground.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    FIcons.settings,
                    size: 18,
                    color: colors.primaryForeground.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Net worth amount
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _hideAmounts
                    ? '$currencySymbol ****'
                    : '$currencySymbol ${_formatAmount(netWorth)}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  fontFeatures: [FontFeature.tabularFigures()],
                ).copyWith(color: colors.primaryForeground),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => setState(() => _hideAmounts = !_hideAmounts),
                child: Icon(
                  _hideAmounts ? FIcons.eyeOff : FIcons.eye,
                  size: 20,
                  color: colors.primaryForeground.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Assets and liabilities row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ASSETS',
                      style: theme.typography.xs.copyWith(
                        color: colors.primaryForeground.withValues(alpha: 0.5),
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _hideAmounts ? '****' : '+${_formatAmount(assets)}',
                      style: theme.typography.base.copyWith(
                        color: const Color(0xFF4CAF50), // Keep semantic green
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LIABILITIES',
                      style: theme.typography.xs.copyWith(
                        color: colors.primaryForeground.withValues(alpha: 0.5),
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _hideAmounts ? '****' : '-${_formatAmount(liabilities)}',
                      style: theme.typography.base.copyWith(
                        color: colors
                            .destructive, // Use destructive for liability (red)
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              // Currency switcher
              GestureDetector(
                onTap: _showCurrencyPicker,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primaryForeground.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: colors.primaryForeground.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${Currency.fromCode(_viewCurrency)?.localizedName ?? _viewCurrency} $currencySymbol',
                        style: theme.typography.sm.copyWith(
                          color: colors.primaryForeground,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        FIcons.repeat,
                        size: 14,
                        color: colors.primaryForeground,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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

  Widget _buildAccountCard(
    FThemeData theme,
    FColors colors,
    FinancialAccount account,
  ) {
    final definition = AccountTypeRegistry.resolveByApiType(account.type);

    // 使用 nature 字段判断是否为负债
    final isLiabilityAccount = account.nature == FinancialNature.liability;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: FCard(
        child: Material(
          type: MaterialType.transparency,
          borderRadius: BorderRadius.circular(10), // Match FCard radius
          child: InkWell(
            onTap: () => _editAccount(account, definition),
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  ThemedIcon.large(
                    icon: isLiabilityAccount
                        ? FIcons.creditCard
                        : FIcons.wallet,
                  ),
                  const SizedBox(width: 16),
                  // Name and type
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
                        const SizedBox(height: 2),
                        Text(
                          definition != null
                              ? _getTypeDisplayName(definition)
                              : (isLiabilityAccount ? '负债账户' : '资产账户'),
                          style: theme.typography.sm.copyWith(
                            color: colors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Amount
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _hideAmounts
                            ? '****'
                            : '${isLiabilityAccount ? '-' : ''}${_formatAmount(account.initialBalance)}',
                        style: theme.typography.base.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colors.foreground,
                          fontFeatures: [const FontFeature.tabularFigures()],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        account.currencyCode,
                        style: theme.typography.xs.copyWith(
                          color: colors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    FIcons.chevronRight,
                    size: 16,
                    color: colors.mutedForeground.withValues(alpha: 0.5),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showCurrencyPicker() async {
    final result = await CurrencySelectionSheet.show(context, _viewCurrency);
    if (result != null && mounted) {
      setState(() {
        _viewCurrency = result;
      });
    }
  }

  String _formatAmount(Decimal amount) {
    final value = double.tryParse(amount.toString()) ?? 0.0;
    // Format with thousand separators
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
        return '现金钱包';
      case 'deposit':
        return '银行存款';
      case 'e_money':
        return '电子钱包';
      case 'investment':
        return '投资理财';
      case 'receivable':
        return '应收款项';
      case 'credit_card':
        return '信用卡';
      case 'loan':
        return '贷款账户';
      case 'payable':
        return '应付款项';
      default:
        return definition.title;
    }
  }

  Future<void> _addAccount() async {
    final typeResult = await context.pushNamed('financialAccountTypePicker');
    if (!mounted || typeResult == null) return;

    if (typeResult is FinancialAccount) {
      // Add the new account to the provider
      final currentAccounts = ref.read(financialAccountProvider).accounts;
      final updatedList = [...currentAccounts, typeResult];
      final success = await ref
          .read(financialAccountProvider.notifier)
          .saveFinancialAccounts(updatedList);

      // 保存成功后刷新账户列表
      if (success && mounted) {
        await ref
            .read(financialAccountProvider.notifier)
            .loadFinancialAccounts();
      }
    }
  }

  Future<void> _editAccount(
    FinancialAccount account,
    AccountTypeDefinition? definition,
  ) async {
    // 如果没有找到对应的定义，根据 account.type 尝试获取默认定义
    final accountDefinition =
        definition ??
        AccountTypeRegistry.resolveByApiType(account.type) ??
        AccountTypeRegistry.getDefaultDefinition(account.nature);

    await context.pushNamed(
      'financialAccountEdit',
      extra: FinancialAccountEditArgs(
        definition: accountDefinition,
        account: account,
      ),
    );
    // Refresh is handled by the edit page's provider interaction
  }
}
