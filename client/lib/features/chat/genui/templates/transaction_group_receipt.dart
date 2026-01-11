import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:genui/genui.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

import '../../../profile/models/financial_account.dart';
import '../../../profile/providers/financial_account_provider.dart';
import '../organisms/account_picker_card.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_semantic_colors.dart';
import '../../../../core/network/network_client.dart';
import '../../../../core/constants/category_constants.dart';
import 'package:augo/shared/widgets/amount_text.dart';
import 'package:augo/shared/widgets/themed_icon.dart';
import 'package:augo/features/home/models/transaction_model.dart';
import 'package:augo/i18n/strings.g.dart';

/// 批量交易收据组件
///
/// 支持轮播 (Carousel) 和 列表 (List) 两种模式切换
/// 每笔交易独立关联账户（取消批量关联，改为逐笔操作）
class TransactionGroupReceipt extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;
  final void Function(UiEvent)? dispatchEvent;

  const TransactionGroupReceipt({
    super.key,
    required this.data,
    this.dispatchEvent,
  });

  @override
  ConsumerState<TransactionGroupReceipt> createState() =>
      _TransactionGroupReceiptState();
}

class _TransactionGroupReceiptState
    extends ConsumerState<TransactionGroupReceipt> {
  static final _log = Logger('TransactionGroupReceipt');

  bool _isListView = false;
  int _currentIndex = 0;
  late final PageController _pageController;

  /// 每笔交易的账户关联状态
  final Map<String, String?> _accountAssociations = {};

  /// 每笔交易的共享空间关联状态
  final Map<String, List<String>> _spaceAssociations = {};

  /// 正在更新账户的交易 ID 集合
  final Set<String> _updatingTransactions = {};

  /// 正在更新共享空间的交易 ID 集合
  final Set<String> _updatingSpaceTransactions = {};

  /// 缓存的共享空间列表
  List<Map<String, dynamic>>? _cachedSpaces;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _initializeAccountAssociations();
    // 异步刷新最新的账户关联状态
    unawaited(_refreshAccountAssociations());
  }

  void _initializeAccountAssociations() {
    final transactions = (widget.data['transactions'] as List? ?? []);
    for (final tx in transactions) {
      final txMap = tx as Map<String, dynamic>;
      final id = txMap['id']?.toString();
      if (id != null) {
        // 优先使用 source_account_id（支出），否则使用 target_account_id（收入）
        final accountId =
            txMap['source_account_id']?.toString() ??
            txMap['target_account_id']?.toString();
        _accountAssociations[id] = accountId;

        // 初始化共享空间关联
        final spaceId = txMap['space_id']?.toString();
        if (spaceId != null) {
          _spaceAssociations[id] = [spaceId];
        } else {
          _spaceAssociations[id] = [];
        }
      }
    }
  }

  /// 从服务器刷新最新的账户关联状态（并行请求优化）
  Future<void> _refreshAccountAssociations() async {
    final transactions = (widget.data['transactions'] as List? ?? []);
    if (transactions.isEmpty) return;

    final transactionIds = transactions
        .map((tx) => (tx as Map)['id']?.toString())
        .where((id) => id != null)
        .cast<String>()
        .toList();

    if (transactionIds.isEmpty) return;

    try {
      final networkClient = ref.read(networkClientProvider);

      // 并行请求所有交易详情
      final results = await Future.wait(
        transactionIds.map((txId) async {
          try {
            return await networkClient.requestMap(
              '/transactions/$txId',
              method: HttpMethod.get,
            );
          } catch (e) {
            _log.warning('Failed to fetch transaction $txId', e);
            return <String, dynamic>{};
          }
        }),
      );

      // 处理所有结果
      if (mounted) {
        setState(() {
          for (int i = 0; i < transactionIds.length; i++) {
            final txId = transactionIds[i];
            final result = results[i];

            if (result['code'] == 0 && result['data'] != null) {
              final data = result['data'] as Map<String, dynamic>;
              // 根据交易类型获取正确的账户 ID
              final type = data['type']?.toString().toUpperCase() ?? 'EXPENSE';
              String? accountId;
              if (type == 'INCOME') {
                accountId = data['targetAccountId']?.toString();
              } else {
                accountId = data['sourceAccountId']?.toString();
              }

              _accountAssociations[txId] = accountId;

              // 同步共享空间关联
              final spaces = data['spaces'] as List<dynamic>?;
              if (spaces != null) {
                _spaceAssociations[txId] = spaces
                    .whereType<Map<String, dynamic>>()
                    .map((s) => s['id']?.toString())
                    .whereType<String>()
                    .toList();
              }
            }
          }
        });
      }
    } finally {
      // Refresh UI after loading
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ==================== 积木分子 (Molecules) ====================

  /// 积木 1: 交易信息分子 (图标 + 信息 + 金额)
  /// 仿照首页 flow 卡片布局
  Widget _moleculeTransactionInfo(
    FThemeData theme,
    FColors colors,
    TransactionCategory category,
    List<String> tags,
    double amount,
    bool isExpense, {
    double iconSize = 44,
    String? currency,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left: Category Icon - Using ThemedIcon for consistency
        iconSize >= 44
            ? ThemedIcon.large(icon: category.icon)
            : ThemedIcon(icon: category.icon),
        const SizedBox(width: 12),

        // Middle: Category Name & Tags
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Category Name
              Text(
                category.displayText,
                style: theme.typography.base.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              // Tags or Type Description
              tags.isNotEmpty
                  ? _atomTagsRow(theme, colors, tags)
                  : Text(
                      isExpense ? t.transaction.expense : t.transaction.income,
                      style: theme.typography.sm.copyWith(
                        color: colors.mutedForeground,
                        height: 1.2,
                      ),
                    ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        // Right: Amount
        _moleculeAmount(
          theme,
          amount,
          isExpense,
          currency: currency,
          style: theme.typography.xl.copyWith(
            fontWeight: FontWeight.bold,
            height: 1.2,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  /// 原子组件: 标签行
  Widget _atomTagsRow(FThemeData theme, FColors colors, List<String> tags) {
    // 只显示前2个
    final visibleTags = tags.take(2);
    return Row(
      children: visibleTags.map((tag) {
        return Padding(
          padding: const EdgeInsets.only(right: 6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: colors.muted.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: colors.border.withValues(alpha: 0.5)),
            ),
            child: Text(
              tag,
              style: theme.typography.xs.copyWith(
                color: colors.mutedForeground,
              ),
              maxLines: 1,
            ),
          ),
        );
      }).toList(),
    );
  }

  /// 积木 2: 金额分子
  Widget _moleculeAmount(
    FThemeData theme,
    double amount,
    bool isExpense, {
    TextStyle? style,
    String? currency,
  }) {
    return AmountText(
      amount: amount,
      type: isExpense ? TransactionType.expense : TransactionType.income,
      currency: currency,
      style:
          style ??
          theme.typography.sm.copyWith(
            fontWeight: FontWeight.w700,
          ), // 提升默认权重和大小
    );
  }

  /// 积木 3: 操作分子 (账户 + 空间按钮组)
  Widget _moleculeActions(
    FThemeData theme,
    FColors colors,
    Map<String, dynamic> tx,
  ) {
    final txId = tx['id']?.toString();
    final currentAccountId = _accountAssociations[txId];
    final account = ref
        .watch(financialAccountProvider)
        .accounts
        .where((a) => a.id == currentAccountId)
        .firstOrNull;
    final associatedIds = _spaceAssociations[txId] ?? [];

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _showAccountPicker(tx),
            child: _atomActionPill(
              theme,
              colors,
              icon: account != null ? FIcons.wallet : FIcons.link,
              label:
                  account?.name ??
                  t.chat.genui.transactionGroupReceipt.accountAssociation,
              activeColor: colors.primary,
              isActive: account != null,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: () => _showSpacePicker(tx),
            child: _atomActionPill(
              theme,
              colors,
              icon: associatedIds.isNotEmpty ? FIcons.users : FIcons.plus,
              label: associatedIds.isNotEmpty
                  ? t.chat.genui.transactionGroupReceipt.spaceCount(
                      count: associatedIds.length,
                    )
                  : t.chat.genui.transactionGroupReceipt.sharedSpace,
              activeColor: context.theme.semantic.sharedSpaceAccent,
              isActive: associatedIds.isNotEmpty,
            ),
          ),
        ),
      ],
    );
  }

  /// 原子组件: 操作胶囊样式
  Widget _atomActionPill(
    FThemeData theme,
    FColors colors, {
    required IconData icon,
    required String label,
    required Color activeColor,
    required bool isActive,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: isActive
            ? activeColor.withValues(alpha: 0.08)
            : colors.muted.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 12,
            color: isActive ? activeColor : colors.mutedForeground,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: theme.typography.xs.copyWith(
                color: isActive ? activeColor : colors.mutedForeground,
                fontWeight: isActive ? FontWeight.w600 : null,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;
    final transactions = (widget.data['transactions'] as List? ?? []);

    double totalAmount = 0;
    for (final tx in transactions) {
      final amountValue =
          double.tryParse((tx as Map)['amount']?.toString() ?? '0') ?? 0;
      totalAmount += amountValue.abs();
    }

    if (transactions.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: colors.border.withValues(alpha: 0.5)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 头部
          _buildHeader(theme, colors, transactions.length, totalAmount),

          // 内容
          AnimatedCrossFade(
            firstChild: _buildCarouselView(theme, colors, transactions),
            secondChild: _buildListView(theme, colors, transactions),
            crossFadeState: _isListView
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    FThemeData theme,
    FColors colors,
    int count,
    double totalAmount,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ), // 恢复紧凑布局
      decoration: BoxDecoration(color: colors.primary.withValues(alpha: 0.05)),
      child: Row(
        children: [
          Icon(FIcons.layers, size: 18, color: colors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${t.chat.genui.transactionGroupReceipt.title} ${t.chat.genui.transactionGroupReceipt.count(count: count)}',
                  style: theme.typography.base.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.primary,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${t.chat.genui.transactionGroupReceipt.total} ',
                      style: theme.typography.xs.copyWith(
                        color: colors.mutedForeground,
                      ),
                    ),
                    AmountText(
                      amount: totalAmount,
                      type: TransactionType.expense,
                      semantic: AmountSemantic.status,
                      showSign: false,
                      style: theme.typography.xs.copyWith(
                        color: colors.mutedForeground,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 切换按钮
          _buildToggle(theme, colors),
        ],
      ),
    );
  }

  Widget _buildToggle(FThemeData theme, FColors colors) {
    return Container(
      height: 32,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: colors.muted.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildToggleButton(
            icon: FIcons.layoutPanelLeft,
            isSelected: !_isListView,
            onTap: () => setState(() => _isListView = false),
            colors: colors,
          ),
          _buildToggleButton(
            icon: FIcons.list,
            isSelected: _isListView,
            onTap: () => setState(() => _isListView = true),
            colors: colors,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required FColors colors,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? colors.background : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          size: 16,
          color: isSelected ? colors.primary : colors.mutedForeground,
        ),
      ),
    );
  }

  Widget _buildCarouselView(
    FThemeData theme,
    FColors colors,
    List<dynamic> transactions,
  ) {
    return Column(
      children: [
        SizedBox(
          height: 196, // 增加高度以防止内容溢出
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemCount: transactions.length,
            itemBuilder: (context, index) => _buildCarouselItem(
              theme,
              colors,
              transactions[index] as Map<String, dynamic>,
            ),
          ),
        ),
        if (transactions.length > 1)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                transactions.length,
                (index) => Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index
                        ? colors.primary
                        : colors.muted,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCarouselItem(
    FThemeData theme,
    FColors colors,
    Map<String, dynamic> tx,
  ) {
    final category = TransactionCategory.fromKey(tx['category_key'] as String?);
    final tags = (tx['tags'] as List?)?.map((e) => e.toString()).toList() ?? [];

    // 优先使用原始币种和金额（针对汇率转换场景）
    // 后端返回 camelCase: originalAmount, originalCurrency
    final originalAmount = tx['originalAmount'] != null
        ? double.tryParse(tx['originalAmount'].toString())
        : null;
    final originalCurrency = tx['originalCurrency'] as String?;

    final amount =
        originalAmount ??
        double.tryParse(tx['amount']?.toString() ?? '0') ??
        0.0;
    final isExpense = tx['type']?.toString().toUpperCase() != 'INCOME';
    final currency = originalCurrency ?? tx['currency'] as String?;

    final transactionId = tx['id']?.toString();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _navigateToTransactionDetail(transactionId),
      child: Container(
        // 高度自适应，不再强制固定太大，避免空隙
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _moleculeTransactionInfo(
              theme,
              colors,
              category,
              tags,
              amount,
              isExpense,
              currency: currency,
            ),
            const SizedBox(height: 20),
            _moleculeActions(theme, colors, tx),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(
    FThemeData theme,
    FColors colors,
    List<dynamic> transactions,
  ) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 400),
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: transactions.length,
        separatorBuilder: (context, index) =>
            Divider(height: 1, color: colors.border.withValues(alpha: 0.1)),
        itemBuilder: (context, index) => _buildListItem(
          theme,
          colors,
          transactions[index] as Map<String, dynamic>,
        ),
      ),
    );
  }

  Widget _buildListItem(
    FThemeData theme,
    FColors colors,
    Map<String, dynamic> tx,
  ) {
    final category = TransactionCategory.fromKey(tx['category_key'] as String?);
    final tags = (tx['tags'] as List?)?.map((e) => e.toString()).toList() ?? [];

    // 优先使用原始币种和金额（针对汇率转换场景）
    // 后端返回 camelCase: originalAmount, originalCurrency
    final originalAmount = tx['originalAmount'] != null
        ? double.tryParse(tx['originalAmount'].toString())
        : null;
    final originalCurrency = tx['originalCurrency'] as String?;

    final amount =
        originalAmount ??
        double.tryParse(tx['amount']?.toString() ?? '0') ??
        0.0;
    final isExpense = tx['type']?.toString().toUpperCase() != 'INCOME';
    final currency = originalCurrency ?? tx['currency'] as String?;

    final transactionId = tx['id']?.toString();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _navigateToTransactionDetail(transactionId),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _moleculeTransactionInfo(
              theme,
              colors,
              category,
              tags,
              amount,
              isExpense,
              iconSize: 40,
              currency: currency,
            ),
            const SizedBox(height: 12),
            _moleculeActions(theme, colors, tx),
          ],
        ),
      ),
    );
  }

  /// 跳转到交易详情页面
  void _navigateToTransactionDetail(String? transactionId) {
    if (transactionId == null || transactionId.isEmpty) {
      _log.warning('Transaction ID is null or empty, cannot navigate');
      return;
    }
    unawaited(HapticFeedback.lightImpact());
    unawaited(
      context.pushNamed(
        AppRouteNames.transactionDetail,
        pathParameters: {'transactionId': transactionId},
      ),
    );
  }

  Future<void> _showAccountPicker(Map<String, dynamic> tx) async {
    final txId = tx['id']?.toString();
    if (txId == null) return;

    final theme = context.theme;
    final colors = theme.colors;

    // 获取交易币种
    final txCurrency =
        (tx['originalCurrency'] as String?) ??
        (tx['currency'] as String?) ??
        'USD';

    // 获取交易金额
    final txAmount = tx['originalAmount'] != null
        ? double.tryParse(tx['originalAmount'].toString())
        : double.tryParse(tx['amount']?.toString() ?? '0');

    var accountState = ref.read(financialAccountProvider);
    if (accountState.accounts.isEmpty && !accountState.isLoading) {
      await ref.read(financialAccountProvider.notifier).loadFinancialAccounts();
      accountState = ref.read(financialAccountProvider);
    }

    final printableAccounts = accountState.accounts
        .where(
          (a) =>
              a.status == AccountStatus.active &&
              a.nature == FinancialNature.asset,
        )
        .map(
          (a) => <String, dynamic>{
            'id': a.id,
            'name': a.name,
            'type': a.type?.name ?? 'unknown',
            'balance': a.currentBalance,
            'currencyCode': a.currencyCode, // 添加币种信息
          },
        )
        .toList();

    // 如果没有可用账户，显示提示
    if (printableAccounts.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.chat.genui.transactionCard.noAccount),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final currentAccountId = _accountAssociations[txId];

    if (!mounted) return;

    unawaited(
      showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => Container(
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(20),
          child: AccountPickerCard(
            accounts: printableAccounts,
            selectedId: currentAccountId,
            title: t.chat.genui.transactionCard.selectAccount,
            transactionCurrency: txCurrency, // 传入交易币种
            onSelect: (id) {
              Navigator.pop(context, id);
            },
            onConfirm: () {},
          ),
        ),
      ).then((selectedId) async {
        if (selectedId != null) {
          // 获取选中的账户
          final selectedAccount = accountState.accounts
              .where((a) => a.id == selectedId)
              .firstOrNull;

          if (selectedAccount != null) {
            final accountCurrency = selectedAccount.currencyCode.toUpperCase();
            final transactionCurrency = txCurrency.toUpperCase();

            // 币种不一致，显示确认弹窗
            if (accountCurrency != transactionCurrency) {
              final confirmed = await _showCurrencyMismatchConfirmDialog(
                txAmount ?? 0,
                transactionCurrency,
                accountCurrency,
                selectedAccount.name,
              );

              if (confirmed != true) return;
            }
          }

          await _updateTransactionAccount(txId, selectedId);
        }
      }),
    );
  }

  /// 显示币种不匹配确认弹窗
  Future<bool?> _showCurrencyMismatchConfirmDialog(
    double amount,
    String fromCurrency,
    String toCurrency,
    String accountName,
  ) async {
    final theme = context.theme;
    final colors = theme.colors;
    bool confirmed = false;

    await showFDialog<void>(
      context: context,
      builder: (dialogContext, style, animation) => FDialog(
        style: style.call,
        animation: animation,
        title: Row(
          children: [
            Icon(
              FIcons.triangleAlert,
              color: theme.semantic.warningAccent,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(t.chat.genui.transactionGroupReceipt.currencyMismatchTitle),
          ],
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.chat.genui.transactionGroupReceipt.currencyMismatchDesc,
              style: theme.typography.sm.copyWith(
                color: colors.mutedForeground,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.muted.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                    theme,
                    colors,
                    t.chat.genui.transactionGroupReceipt.transactionAmount,
                    '${amount.toStringAsFixed(2)} $fromCurrency',
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    theme,
                    colors,
                    t.chat.genui.transactionGroupReceipt.accountCurrency,
                    toCurrency,
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    theme,
                    colors,
                    t.chat.genui.transactionGroupReceipt.targetAccount,
                    accountName,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              t.chat.genui.transactionGroupReceipt.currencyMismatchNote,
              style: theme.typography.xs.copyWith(
                color: theme.semantic.warningAccent,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          FButton(
            onPress: () {
              confirmed = true;
              Navigator.pop(dialogContext);
            },
            child: Text(t.chat.genui.transactionGroupReceipt.confirmAssociate),
          ),
          FButton(
            style: FButtonStyle.outline(),
            onPress: () => Navigator.pop(dialogContext),
            child: Text(t.common.cancel),
          ),
        ],
      ),
    );

    return confirmed;
  }

  Widget _buildInfoRow(
    FThemeData theme,
    FColors colors,
    String label,
    String value,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.typography.sm.copyWith(color: colors.mutedForeground),
        ),
        Text(
          value,
          style: theme.typography.sm.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Future<void> _updateTransactionAccount(
    String transactionId,
    String accountId,
  ) async {
    setState(() => _updatingTransactions.add(transactionId));

    try {
      final networkClient = ref.read(networkClientProvider);
      final result = await networkClient.requestMap(
        '/transactions/$transactionId/account',
        method: HttpMethod.patch,
        data: {'account_id': accountId},
      );

      if (result['code'] == 0) {
        setState(() {
          _accountAssociations[transactionId] = accountId;
          _updatingTransactions.remove(transactionId);
        });

        final accountState = ref.read(financialAccountProvider);
        final acc = accountState.accounts
            .where((a) => a.id == accountId)
            .firstOrNull;

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              t.chat.genui.transactionCard.associatedTo(name: acc?.name ?? ''),
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: context.theme.colors.primary,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );

        unawaited(
          ref.read(financialAccountProvider.notifier).loadFinancialAccounts(),
        );
      } else {
        throw Exception(result['message'] ?? 'Update failed');
      }
    } catch (e) {
      setState(() => _updatingTransactions.remove(transactionId));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            t.chat.genui.transactionCard.updateFailed(error: e.toString()),
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: context.theme.colors.destructive,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _showSpacePicker(Map<String, dynamic> tx) async {
    final txId = tx['id']?.toString();
    if (txId == null) return;

    final theme = context.theme;
    final colors = theme.colors;

    if (_cachedSpaces == null) {
      try {
        final networkClient = ref.read(networkClientProvider);
        final result = await networkClient.requestMap(
          '/shared-spaces',
          method: HttpMethod.get,
        );

        if (result['code'] == 0 && result['data'] != null) {
          final data = result['data'] as Map<String, dynamic>;
          _cachedSpaces = (data['spaces'] as List? ?? [])
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList();
        } else {
          _cachedSpaces = [];
        }
      } catch (e) {
        _log.warning('Failed to load spaces', e);
        _cachedSpaces = [];
      }
    }

    if (_cachedSpaces!.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.chat.genui.transactionCard.noSpace),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    final associatedIds = _spaceAssociations[txId] ?? [];

    if (!mounted) return;

    unawaited(
      showModalBottomSheet<dynamic>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => Container(
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.chat.genui.transactionGroupReceipt.selectSpace,
                style: theme.typography.lg.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ..._cachedSpaces!.map((space) {
                final spaceId = space['id'];
                final isSelected = associatedIds.contains(spaceId?.toString());
                final name = space['name'] as String? ?? 'unnamed';

                return GestureDetector(
                  onTap: () => Navigator.pop(context, spaceId),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? context.theme.semantic.sharedSpaceBackground
                          : colors.muted.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? context.theme.semantic.sharedSpaceAccent
                                  .withValues(alpha: 0.5)
                            : colors.border.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          FIcons.users,
                          size: 18,
                          color: isSelected
                              ? context.theme.semantic.sharedSpaceAccent
                              : colors.mutedForeground,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            name,
                            style: theme.typography.sm.copyWith(
                              fontWeight: isSelected ? FontWeight.bold : null,
                              color: isSelected
                                  ? context.theme.semantic.sharedSpaceAccent
                                  : null,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check,
                            color: context.theme.semantic.sharedSpaceAccent,
                            size: 18,
                          ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ).then((selectedId) async {
        if (selectedId != null) {
          await _updateTransactionSpace(txId, selectedId);
        }
      }),
    );
  }

  Future<void> _updateTransactionSpace(
    String transactionId,
    dynamic spaceId,
  ) async {
    setState(() => _updatingSpaceTransactions.add(transactionId));

    try {
      final networkClient = ref.read(networkClientProvider);
      final result = await networkClient.requestMap(
        '/shared-spaces/$spaceId/transactions',
        method: HttpMethod.post,
        data: {'transaction_id': transactionId},
      );

      if (result['code'] == 0) {
        final newSpaceId = spaceId.toString();
        setState(() {
          final list = _spaceAssociations[transactionId] ?? [];
          if (!list.contains(newSpaceId)) {
            list.add(newSpaceId);
          }
          _spaceAssociations[transactionId] = list;
          _updatingSpaceTransactions.remove(transactionId);
        });

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              t.chat.genui.transactionGroupReceipt.spaceAssociateSuccess,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: context.theme.colors.primary,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        throw Exception(result['message'] ?? 'Association failed');
      }
    } catch (e) {
      setState(() => _updatingSpaceTransactions.remove(transactionId));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            t.chat.genui.transactionGroupReceipt.spaceAssociateFailed(
              error: e.toString(),
            ),
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: context.theme.colors.destructive,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
