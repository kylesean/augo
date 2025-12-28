// features/home/pages/transaction_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:augo/shared/models/action_item_model.dart';
import 'package:augo/shared/widgets/dialogs/action_bottom_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:forui/forui.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
import '../widgets/feed/comment_section_widget.dart';
import '../widgets/feed/comment_input_bar.dart';
import '../providers/transaction_detail_provider.dart';
import '../widgets/transaction_detail_skeleton.dart';
import 'package:augo/shared/widgets/amount_text.dart';
import 'package:augo/shared/widgets/themed_icon.dart';
import 'package:augo/shared/utils/amount_formatter.dart';
import 'package:augo/core/constants/category_constants.dart';
import 'package:augo/features/profile/providers/financial_account_provider.dart';
import 'package:augo/features/profile/models/financial_account.dart';
import 'package:augo/features/chat/genui/organisms/account_picker_card.dart';
import 'package:augo/app/theme/app_semantic_colors.dart';
import 'package:augo/core/network/network_client.dart';
import 'package:augo/shared/services/toast_service.dart';
import 'package:augo/i18n/strings.g.dart';

class TransactionDetailPage extends ConsumerWidget {
  final String transactionId;

  const TransactionDetailPage({super.key, required this.transactionId});

  /// 获取分类显示名称
  String _getCategoryDisplayName(TransactionModel transaction) {
    // 优先使用服务端返回的本地化名称
    if (transaction.categoryText != null &&
        transaction.categoryText!.isNotEmpty) {
      return transaction.categoryText!;
    }
    // 使用 TransactionCategory 获取本地化名称
    if (transaction.categoryKey != null &&
        transaction.categoryKey!.isNotEmpty) {
      return TransactionCategory.fromKey(transaction.categoryKey!).displayText;
    }
    return transaction.category;
  }

  /// 获取金额显示文本
  String _getAmountDisplayText(TransactionModel transaction) {
    // 优先使用API返回的display字段
    if (transaction.display != null) {
      return transaction.display!.fullString;
    }

    // 回退：使用 AmountFormatter 确保符号一致
    return AmountFormatter.formatTransaction(
      type: transaction.type,
      amount: transaction.amount,
      currency: transaction.paymentMethod ?? 'CNY',
      showSign: true,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(transactionDetailProvider(transactionId));
    final theme = context.theme;
    final colors = theme.colors;

    // 显示骨架屏
    if (detailState.isLoading && detailState.transaction == null) {
      return const TransactionDetailSkeleton();
    }

    // 显示错误状态
    if (detailState.errorMessage != null && detailState.transaction == null) {
      return Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          child: Column(
            children: [
              _buildPageHeader(context, theme, colors, null),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FIcons.ellipsis,
                        size: 48,
                        color: colors.destructive,
                      ),
                      const SizedBox(height: 16),
                      Text(t.home.loadFailed, style: theme.typography.xl2),
                      const SizedBox(height: 8),
                      Text(
                        detailState.errorMessage!,
                        style: theme.typography.sm.copyWith(
                          color: colors.mutedForeground,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      FButton(
                        onPress: () {
                          ref
                              .read(
                                transactionDetailProvider(
                                  transactionId,
                                ).notifier,
                              )
                              .reload();
                        },
                        child: Text(t.common.retry),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final transaction = detailState.transaction;
    if (transaction == null) {
      return const TransactionDetailSkeleton();
    }

    timeago.setLocaleMessages('zh_CN', timeago.ZhCnMessages());

    // 页面头部
    final pageHeader = _buildPageHeader(context, theme, colors, transaction);

    return Scaffold(
      // 仍然可以使用 Scaffold 作为根，以便 CommentInputBar 能正确固定在底部
      resizeToAvoidBottomInset: false,
      backgroundColor: colors.background, // 页面背景色来自主题
      body: SafeArea(
        // 3. 使用 SafeArea
        child: Column(
          children: [
            pageHeader,
            Expanded(
              child: CustomScrollView(
                // 保留 CustomScrollView 以便内容过多时滚动
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      // 4. 使用 ShadCard 包裹主要详情区域
                      child: FCard.raw(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // --- 顶部：类别图标、类别名称、时间、更多操作按钮 ---
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: ThemedIcon.large(
                                      icon: TransactionCategory.fromKey(
                                        transaction.categoryKey,
                                      ).icon,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _getCategoryDisplayName(transaction),
                                          style: theme.typography.lg.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          timeago.format(
                                            transaction.timestamp,
                                            locale: 'zh_CN',
                                          ),
                                          style: theme.typography.sm.copyWith(
                                            color: colors.mutedForeground,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  FButton.icon(
                                    // 6. 更多操作按钮
                                    style: FButtonStyle.ghost(),
                                    onPress: () => _showTransactionActions(
                                      context,
                                      ref,
                                      transaction,
                                    ),
                                    child: Icon(
                                      FIcons.ellipsis,
                                      color: colors.mutedForeground,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              // 金额
                              Center(
                                child: AmountText.large(
                                  amount: transaction.amount,
                                  type: transaction.type,
                                  currency: transaction.paymentMethod ?? 'CNY',
                                ),
                              ),
                              const SizedBox(height: 16),

                              // 关联账户和空间操作区
                              _buildAccountSpaceActions(
                                context,
                                ref,
                                theme,
                                colors,
                                transaction,
                              ),

                              const SizedBox(height: 16),
                              FDivider(axis: Axis.horizontal),
                              const SizedBox(height: 12),
                              // 详细信息行 - 记账原文（用户原始输入）
                              _buildDetailRow(
                                context,
                                icon: FIcons.messageSquareText,
                                label: t.transaction.rawInput,
                                valueWidget: GestureDetector(
                                  onTap: transaction.sourceThreadId != null
                                      ? () {
                                          HapticFeedback.lightImpact();
                                          context.go(
                                            '/ai/${transaction.sourceThreadId}',
                                          );
                                        }
                                      : null,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          transaction.rawInput ??
                                              t.transaction.noRawInput,
                                          style: theme.typography.sm.copyWith(
                                            color: colors.foreground,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (transaction.sourceThreadId !=
                                          null) ...[
                                        const SizedBox(width: 4),
                                        Icon(
                                          FIcons.externalLink,
                                          size: 14,
                                          color: colors.primary,
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),

                              _buildDetailRow(
                                context,
                                icon: FIcons.calendarClock, // 替换图标
                                label: t.transaction.time,
                                valueWidget: Text(
                                  DateFormat(
                                    'yyyy年M月d日 HH:mm:ss',
                                    'zh_CN',
                                  ).format(transaction.timestamp),
                                  style: theme.typography.sm.copyWith(
                                    color: colors.foreground, // 值颜色
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              if (transaction.location != null &&
                                  transaction.location!.isNotEmpty)
                                _buildDetailRow(
                                  context,
                                  icon: FIcons.mapPin, // 替换图标
                                  label: t.transaction.location,
                                  valueWidget: Text(
                                    transaction.location!,
                                    style: theme.typography.sm.copyWith(
                                      color: colors.foreground, // 值颜色
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),

                              if (transaction.tags.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                _buildDetailRow(
                                  context,
                                  icon: FIcons.tags, // 替换图标
                                  label: t.transaction.tags,
                                  valueWidget: Wrap(
                                    spacing: 8.0,
                                    runSpacing: 6.0,
                                    children: transaction.tags
                                        .map(
                                          (tag) => FBadge(
                                            // 9. 使用 FBadge
                                            style: FBadgeStyle.secondary(),
                                            child: Text(
                                              tag,
                                              style: theme.typography.sm
                                                  .copyWith(fontSize: 11),
                                            ),
                                            // FBadge 默认有合适的 padding 和圆角
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ],

                              // if (transaction.isAiBuild == true)
                              //   Padding(
                              //     padding: const EdgeInsets.only(top: 20.0),
                              //     child: Row(
                              //       mainAxisAlignment: MainAxisAlignment.end,
                              //       children: [
                              //         Icon(FIcons.sparkles, size: 16, color: colorScheme.primary), // 使用主题色
                              //         const SizedBox(width: 4),
                              //         Text(
                              //           '由 AI 智能记录',
                              //           style: theme.textTheme.small.copyWith(
                              //             color: colorScheme.primary,
                              //             fontStyle: FontStyle.italic,
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // --- 评论区 ---
                  SliverToBoxAdapter(
                    child: CommentSectionWidget(transactionId: transaction.id),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 100), // 底部留白，防止被输入框遮挡
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // 评论输入栏
      bottomNavigationBar: CommentInputBar(transactionId: transaction.id),
    );
  }

  // 构建页面头部
  Widget _buildPageHeader(
    BuildContext context,
    FThemeData theme,
    FColors colors,
    TransactionModel? transaction,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          FButton.icon(
            style: FButtonStyle.ghost(),
            onPress: () => GoRouter.of(context).pop(),
            child: Icon(FIcons.arrowLeft, size: 20, color: colors.foreground),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              t.transaction.transactionDetail,
              style: theme.typography.xl2.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center, // 标题居中
            ),
          ),
          // 右侧占位，保持标题居中，或者可以放其他操作按钮
          SizedBox(width: 40),
        ],
      ),
    );
  }

  // 详细信息行 - 优化多语言支持，使用灵活宽度
  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Widget valueWidget,
  }) {
    final theme = context.theme;
    final colors = theme.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 图标和标签使用固定宽度的 Row，确保对齐
          SizedBox(
            width: 90, // 增加宽度以适应英文标签
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: colors.mutedForeground),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: theme.typography.sm.copyWith(
                      color: colors.mutedForeground,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: valueWidget),
        ],
      ),
    );
  }

  /// 构建关联账户和空间操作区
  Widget _buildAccountSpaceActions(
    BuildContext context,
    WidgetRef ref,
    FThemeData theme,
    FColors colors,
    TransactionModel transaction,
  ) {
    // 获取关联账户信息
    final isExpense = transaction.type == TransactionType.expense;
    final accountId = isExpense
        ? transaction.sourceAccountId
        : transaction.targetAccountId;

    // 从 Provider 获取账户信息
    final accountState = ref.watch(financialAccountProvider);
    final linkedAccount = accountId != null
        ? accountState.accounts.where((a) => a.id == accountId).firstOrNull
        : null;

    // 获取关联空间信息
    final spaces = transaction.spaces;
    final hasSpaces = spaces.isNotEmpty;

    return Row(
      children: [
        // 关联账户按钮
        Expanded(
          child: _buildActionPill(
            context: context,
            theme: theme,
            colors: colors,
            icon: linkedAccount != null ? FIcons.wallet : FIcons.link,
            label: linkedAccount?.name ?? t.transaction.linkedAccount,
            isActive: linkedAccount != null,
            activeColor: colors.primary,
            onTap: () => _showAccountPicker(context, ref, transaction),
          ),
        ),
        const SizedBox(width: 8),
        // 关联空间按钮
        Expanded(
          child: _buildActionPill(
            context: context,
            theme: theme,
            colors: colors,
            icon: hasSpaces ? FIcons.users : FIcons.plus,
            label: hasSpaces
                ? t.transaction.nSpaces(count: spaces.length.toString())
                : t.transaction.linkedSpace,
            isActive: hasSpaces,
            activeColor: theme.semantic.sharedSpaceAccent,
            onTap: () => _showSpacePicker(context, ref, transaction),
          ),
        ),
      ],
    );
  }

  /// 胶囊按钮样式
  Widget _buildActionPill({
    required BuildContext context,
    required FThemeData theme,
    required FColors colors,
    required IconData icon,
    required String label,
    required bool isActive,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: isActive
              ? activeColor.withValues(alpha: 0.1)
              : colors.muted.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 14,
              color: isActive ? activeColor : colors.mutedForeground,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: theme.typography.sm.copyWith(
                  color: isActive ? activeColor : colors.mutedForeground,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 显示账户选择弹窗
  Future<void> _showAccountPicker(
    BuildContext context,
    WidgetRef ref,
    TransactionModel transaction,
  ) async {
    final theme = context.theme;
    final colors = theme.colors;

    // 加载账户列表
    var accountState = ref.read(financialAccountProvider);
    if (accountState.accounts.isEmpty && !accountState.isLoading) {
      await ref.read(financialAccountProvider.notifier).loadFinancialAccounts();
      if (!context.mounted) return;
      accountState = ref.read(financialAccountProvider);
    }

    // 筛选可用账户
    final accounts = accountState.accounts
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
            'currencyCode': a.currencyCode,
          },
        )
        .toList();

    if (accounts.isEmpty) {
      if (!context.mounted) return;
      ToastService.show(
        description: Text(t.chat.genui.transactionCard.noAccount),
      );
      return;
    }

    // 获取当前账户ID
    final isExpense = transaction.type == TransactionType.expense;
    final currentAccountId = isExpense
        ? transaction.sourceAccountId
        : transaction.targetAccountId;

    if (!context.mounted) return;

    final selectedId = await showModalBottomSheet<String>(
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
          accounts: accounts,
          selectedId: currentAccountId,
          title: t.transaction.selectLinkedAccount,
          transactionCurrency: transaction.paymentMethod ?? 'CNY',
          onSelect: (id) => Navigator.pop(context, id),
          onConfirm: () {},
        ),
      ),
    );

    if (selectedId != null && context.mounted) {
      await _updateTransactionAccount(context, ref, transaction.id, selectedId);
    }
  }

  /// 更新交易关联账户
  Future<void> _updateTransactionAccount(
    BuildContext context,
    WidgetRef ref,
    String transactionId,
    String accountId,
  ) async {
    try {
      final networkClient = ref.read(networkClientProvider);
      final result = await networkClient.requestMap(
        '/transactions/$transactionId/account',
        method: HttpMethod.patch,
        data: {'account_id': accountId},
      );

      if (result['code'] == 0 && context.mounted) {
        // 重新加载交易详情
        ref.read(transactionDetailProvider(transactionId).notifier).reload();
        // 刷新账户列表以更新余额
        ref.read(financialAccountProvider.notifier).loadFinancialAccounts();
        ToastService.success(description: Text(t.transaction.linkSuccess));
      }
    } catch (e) {
      if (context.mounted) {
        ToastService.showDestructive(
          description: Text(t.transaction.linkFailed),
        );
      }
    }
  }

  /// 显示空间选择弹窗
  Future<void> _showSpacePicker(
    BuildContext context,
    WidgetRef ref,
    TransactionModel transaction,
  ) async {
    final theme = context.theme;
    final colors = theme.colors;

    try {
      // 加载空间列表
      final networkClient = ref.read(networkClientProvider);
      final result = await networkClient.requestMap(
        '/shared-spaces',
        method: HttpMethod.get,
      );

      if (!context.mounted) return;

      final spaces = (result['data']?['spaces'] as List? ?? [])
          .map((s) => s as Map<String, dynamic>)
          .toList();

      if (spaces.isEmpty) {
        ToastService.show(description: Text(t.transaction.noSpacesAvailable));
        return;
      }

      // 获取当前关联的空间IDs
      final currentSpaceIds = transaction.spaces.map((s) => s.id).toSet();

      final selectedSpaceId = await showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => Container(
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(20),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.transaction.selectLinkedSpace,
                style: theme.typography.lg.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: spaces.length,
                  itemBuilder: (context, index) {
                    final space = spaces[index];
                    final spaceId = space['id']?.toString();
                    final isSelected = currentSpaceIds.contains(spaceId);
                    return ListTile(
                      leading: Icon(
                        FIcons.users,
                        color: isSelected
                            ? colors.primary
                            : colors.mutedForeground,
                      ),
                      title: Text(space['name'] ?? ''),
                      trailing: isSelected
                          ? Icon(FIcons.check, color: colors.primary)
                          : null,
                      onTap: () => Navigator.pop(context, spaceId),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );

      if (selectedSpaceId != null && context.mounted) {
        await _linkTransactionToSpace(
          context,
          ref,
          transaction.id,
          selectedSpaceId,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ToastService.showDestructive(
          description: Text(t.transaction.linkFailed),
        );
      }
    }
  }

  /// 关联交易到空间
  Future<void> _linkTransactionToSpace(
    BuildContext context,
    WidgetRef ref,
    String transactionId,
    String spaceId,
  ) async {
    try {
      final networkClient = ref.read(networkClientProvider);
      await networkClient.requestMap(
        '/shared-spaces/$spaceId/transactions',
        method: HttpMethod.post,
        data: {'transaction_id': transactionId},
      );

      if (context.mounted) {
        // 重新加载交易详情
        ref.read(transactionDetailProvider(transactionId).notifier).reload();
        ToastService.success(description: Text(t.transaction.linkSuccess));
      }
    } catch (e) {
      if (context.mounted) {
        ToastService.showDestructive(
          description: Text(t.transaction.linkFailed),
        );
      }
    }
  }

  void _showTransactionActions(
    BuildContext context,
    WidgetRef ref,
    TransactionModel transaction,
  ) {
    final List<ActionItem> primaryActions = [];
    final List<ActionItem> destructiveActions = [];

    primaryActions.add(
      ActionItem(
        title: t.transaction.favorite,
        icon: FIcons.bookmark,
        onTap: () {
          // TODO: 实现收藏功能
        },
      ),
    );

    destructiveActions.add(
      ActionItem(
        title: t.common.delete,
        icon: FIcons.trash2,
        onTap: () {
          // 获取 rootContext 用于后续对话框（此时 BottomSheet 已被 ActionBottomSheet 自动关闭）
          final rootContext = GoRouter.of(
            context,
          ).routerDelegate.navigatorKey.currentContext;
          if (rootContext == null) return;

          // 延迟显示对话框，等待 BottomSheet 动画完成
          Future.delayed(const Duration(milliseconds: 100), () {
            if (!rootContext.mounted) return;
            showFDialog(
              context: rootContext,
              builder: (dialogContext, style, animation) => FDialog(
                style: style.call,
                animation: animation,
                title: Text(t.transaction.confirmDelete),
                body: Text(t.transaction.deleteTransactionConfirm),
                actions: [
                  FButton(
                    style: FButtonStyle.outline(),
                    onPress: () => Navigator.of(dialogContext).pop(),
                    child: Text(t.common.cancel),
                  ),
                  FButton(
                    onPress: () async {
                      Navigator.of(dialogContext).pop();
                      // 执行删除操作
                      try {
                        final networkClient = ref.read(networkClientProvider);
                        final result = await networkClient.requestMap(
                          '/transactions/${transaction.id}',
                          method: HttpMethod.delete,
                        );

                        if (result['code'] == 0) {
                          ToastService.success(
                            description: Text(t.transaction.deleted),
                          );
                          // 返回上一页
                          if (rootContext.mounted) {
                            GoRouter.of(rootContext).pop();
                          }
                        }
                      } catch (e) {
                        ToastService.showDestructive(
                          description: Text(t.transaction.deleteFailed),
                        );
                      }
                    },
                    child: Text(t.common.delete),
                  ),
                ],
              ),
            );
          });
        },
      ),
    );
    if (primaryActions.isEmpty && destructiveActions.isEmpty) {
      ToastService.show(description: Text(t.transaction.noActions));
      return;
    }

    showModalBottomSheet(
      context: GoRouter.of(context)
          .routerDelegate
          .navigatorKey
          .currentContext!, // 获取GoRouter的根Navigator的context
      // 或者，如果你的 MaterialApp 有一个全局的 navigatorKey:
      // context: rootNavigatorKey.currentContext!,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) {
        // sheetContext 现在是根Navigator下的context
        return ActionBottomSheet(
          actions: primaryActions,
          destructiveActions: destructiveActions.isNotEmpty
              ? destructiveActions
              : null,
        );
      },
    );
  }
}
