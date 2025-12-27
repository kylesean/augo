// features/shared_space/pages/shared_space_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:forui/forui.dart';
import '../providers/shared_space_provider.dart';
import '../services/shared_space_service.dart';
import '../widgets/space_dashboard_card.dart';
import '../models/shared_space_models.dart';
import '../../../shared/services/toast_service.dart';
import '../../../shared/widgets/amount_text.dart';
import '../../../shared/utils/amount_formatter.dart';
import '../../../shared/providers/amount_theme_provider.dart';
import '../../../features/home/models/transaction_model.dart';
import '../../../core/constants/category_constants.dart';
import '../../../shared/config/category_config.dart';
import '../../../i18n/strings.g.dart';
import 'package:shimmer/shimmer.dart';

class SharedSpaceDetailPage extends ConsumerStatefulWidget {
  final String spaceId;

  const SharedSpaceDetailPage({super.key, required this.spaceId});

  @override
  ConsumerState<SharedSpaceDetailPage> createState() =>
      _SharedSpaceDetailPageState();
}

class _SharedSpaceDetailPageState extends ConsumerState<SharedSpaceDetailPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Initial load data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(spaceDetailProvider(widget.spaceId));
      ref.invalidate(spaceSettlementProvider(widget.spaceId));
      ref.invalidate(spaceTransactionsProvider(widget.spaceId));
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colors;

    final spaceAsync = ref.watch(spaceDetailProvider(widget.spaceId));
    final settlementAsync = ref.watch(spaceSettlementProvider(widget.spaceId));
    final transactionsAsync = ref.watch(
      spaceTransactionsProvider(widget.spaceId),
    );

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: spaceAsync.when(
        loading: () => _buildLoadingState(context),
        error: (error, stack) => _buildErrorState(context, error.toString()),
        data: (space) =>
            _buildContent(context, space, settlementAsync, transactionsAsync),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    return Scaffold(
      appBar: AppBar(
        title: Text('共享空间', style: theme.typography.xl),
        backgroundColor: colors.background,
        foregroundColor: colors.foreground,
        elevation: 0,
        centerTitle: true,
      ),
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    final theme = context.theme;
    final colors = theme.colors;

    return Scaffold(
      appBar: AppBar(
        title: Text('共享空间', style: theme.typography.xl),
        backgroundColor: colors.background,
        foregroundColor: colors.foreground,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(FIcons.circleAlert, size: 48, color: colors.mutedForeground),
              const SizedBox(height: 16),
              Text(
                'Failed to load',
                style: theme.typography.lg.copyWith(
                  color: colors.foreground,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error,
                style: theme.typography.sm.copyWith(
                  color: colors.mutedForeground,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FButton(
                style: FButtonStyle.outline(),
                onPress: () {
                  ref.invalidate(spaceDetailProvider(widget.spaceId));
                  ref.invalidate(spaceSettlementProvider(widget.spaceId));
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    SharedSpace space,
    AsyncValue<Settlement> settlementAsync,
    AsyncValue<SpaceTransactionListResponse> transactionsAsync,
  ) {
    final theme = context.theme;
    final colors = theme.colors;

    return CustomScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        // App Bar
        SliverAppBar(
          expandedHeight: 120,
          collapsedHeight: 64,
          pinned: true,
          stretch: true,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.only(left: 56, bottom: 16),
            title: Text(
              space.name,
              style: theme.typography.xl.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.foreground,
              ),
            ),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colors.primary.withValues(alpha: 0.05),
                    colors.background,
                  ],
                ),
              ),
            ),
          ),
          backgroundColor: colors.background,
          foregroundColor: colors.foreground,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(FIcons.chevronLeft),
            onPressed: () => context.pop(),
          ),
          actions: [
            // Invite member button
            FButton.icon(
              style: FButtonStyle.ghost(),
              onPress: () => _showInviteSheet(space),
              child: Icon(FIcons.userPlus, size: 20),
            ),
            FButton.icon(
              style: FButtonStyle.ghost(),
              onPress: () => _navigateToSettings(space),
              child: Icon(FIcons.settings, size: 20),
            ),
            const SizedBox(width: 8),
          ],
        ),

        // Content
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Financial Dashboard Title
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 12),
                child: Row(
                  children: [
                    Icon(
                      FIcons.layoutDashboard,
                      size: 16,
                      color: colors.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Dashboard',
                      style: theme.typography.sm.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.primary,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),

              // Financial Information Card
              settlementAsync.when(
                loading: () => _buildSettlementLoading(context),
                error: (error, stack) => _buildSettlementError(context),
                data: (settlement) =>
                    SpaceDashboardCard(space: space, settlement: settlement),
              ),

              const SizedBox(height: 32),

              // Transactions Title
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 16),
                child: Row(
                  children: [
                    Icon(FIcons.receipt, size: 16, color: colors.foreground),
                    const SizedBox(width: 8),
                    Text(
                      'Transactions',
                      style: theme.typography.sm.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.foreground,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colors.muted.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${space.transactionCount} records',
                        style: theme.typography.xs.copyWith(
                          color: colors.mutedForeground,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Transaction List
              transactionsAsync.when(
                loading: () => _buildTransactionListLoading(context),
                error: (error, stack) => _buildTransactionListError(context),
                data: (response) =>
                    _buildTransactionList(context, response.transactions),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildSettlementLoading(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color shimmerBaseColor = isDark
        ? const Color(0xFF2A2A2A)
        : Colors.grey[200]!;
    final Color shimmerHighlightColor = isDark
        ? const Color(0xFF424242)
        : Colors.grey[50]!;
    final Color placeholderShapeColor = isDark
        ? const Color(0xFF2A2A2A)
        : Colors.grey[200]!;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.border.withValues(alpha: 0.5)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Shimmer.fromColors(
        baseColor: shimmerBaseColor,
        highlightColor: shimmerHighlightColor,
        period: const Duration(milliseconds: 1200),
        child: Column(
          children: [
            // Top panel skeleton
            Container(
              height: 160,
              width: double.infinity,
              color: placeholderShapeColor,
            ),
            // Bottom content skeleton
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    width: 100,
                    color: placeholderShapeColor,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 8,
                    width: double.infinity,
                    color: placeholderShapeColor,
                  ),
                  const SizedBox(height: 24),
                  ...List.generate(
                    2,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: placeholderShapeColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 14,
                                  width: 80,
                                  color: placeholderShapeColor,
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  height: 12,
                                  width: 40,
                                  color: placeholderShapeColor,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 24,
                            width: 60,
                            color: placeholderShapeColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettlementError(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.destructive.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.destructive.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Icon(FIcons.circleAlert, size: 24, color: colors.mutedForeground),
          const SizedBox(height: 12),
          Text(
            'Dashboard unavailable',
            style: theme.typography.sm.copyWith(color: colors.mutedForeground),
          ),
          const SizedBox(height: 16),
          FButton(
            style: FButtonStyle.outline(),
            onPress: () =>
                ref.invalidate(spaceSettlementProvider(widget.spaceId)),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionListLoading(BuildContext context) {
    return Column(
      children: List.generate(
        3,
        (index) => _buildTransactionCardSkeleton(context),
      ),
    );
  }

  Widget _buildTransactionCardSkeleton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color shimmerBaseColor = isDark
        ? const Color(0xFF2A2A2A)
        : Colors.grey[200]!;
    final Color shimmerHighlightColor = isDark
        ? const Color(0xFF424242)
        : Colors.grey[50]!;
    final Color placeholderShapeColor = isDark
        ? const Color(0xFF2A2A2A)
        : Colors.grey[200]!;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.theme.colors.border.withValues(alpha: 0.3),
        ),
      ),
      child: Shimmer.fromColors(
        baseColor: shimmerBaseColor,
        highlightColor: shimmerHighlightColor,
        period: const Duration(milliseconds: 1200),
        child: Row(
          children: [
            // Icon skeleton
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: placeholderShapeColor,
              ),
            ),
            const SizedBox(width: 12),
            // Content skeleton
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    width: 120,
                    color: placeholderShapeColor,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 12,
                    width: 80,
                    color: placeholderShapeColor,
                  ),
                ],
              ),
            ),
            // Amount skeleton
            Container(height: 20, width: 60, color: placeholderShapeColor),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionListError(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.destructive.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.destructive.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Icon(FIcons.circleAlert, size: 24, color: colors.mutedForeground),
          const SizedBox(height: 12),
          Text(
            'Failed to load transactions',
            style: theme.typography.sm.copyWith(color: colors.mutedForeground),
          ),
          const SizedBox(height: 16),
          FButton(
            style: FButtonStyle.outline(),
            onPress: () =>
                ref.invalidate(spaceTransactionsProvider(widget.spaceId)),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(
    BuildContext context,
    List<SpaceTransaction> transactions,
  ) {
    final theme = context.theme;
    final colors = theme.colors;

    // Empty state
    if (transactions.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 48),
        decoration: BoxDecoration(
          color: colors.muted.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.border.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(
              FIcons.receipt,
              size: 40,
              color: colors.mutedForeground.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No transactions yet',
              style: theme.typography.base.copyWith(
                color: colors.mutedForeground,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Add your first transaction to start collaborating',
              style: theme.typography.sm.copyWith(
                color: colors.mutedForeground.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      );
    }

    // Transaction list
    return Column(
      children: transactions
          .map((tx) => _buildTransactionItem(context, tx))
          .toList(),
    );
  }

  Widget _buildTransactionItem(BuildContext context, SpaceTransaction tx) {
    final theme = context.theme;
    final colors = theme.colors;

    // Parse transaction type
    final isExpense = tx.type.toUpperCase() == 'EXPENSE';
    final isIncome = tx.type.toUpperCase() == 'INCOME';
    final transactionType = isExpense
        ? TransactionType.expense
        : (isIncome ? TransactionType.income : TransactionType.transfer);
    final amountTheme = ref.watch(currentAmountThemeValueProvider);
    final amountColor = AmountFormatter.getAmountColor(
      transactionType,
      amountTheme,
    );

    // Format time
    String timeDisplay = '';
    if (tx.transactionAt != null) {
      final now = DateTime.now();
      final diff = now.difference(tx.transactionAt!);
      if (diff.inMinutes < 60) {
        timeDisplay = '${diff.inMinutes}m ago';
      } else if (diff.inHours < 24) {
        timeDisplay = '${diff.inHours}h ago';
      } else if (diff.inDays < 7) {
        timeDisplay = '${diff.inDays}d ago';
      } else {
        timeDisplay = '${tx.transactionAt!.month}/${tx.transactionAt!.day}';
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: amountColor.withValues(alpha: 0.1),
            ),
            child: Icon(
              tx.categoryKey != null
                  ? CategoryConfig.getCategoryIcon(tx.categoryKey)
                  : (isExpense ? FIcons.trendingDown : FIcons.trendingUp),
              size: 18,
              color: amountColor,
            ),
          ),
          const SizedBox(width: 12),
          // Description and added by
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.description != null && tx.description!.isNotEmpty
                      ? tx.description!
                      : (tx.categoryKey != null
                            ? TransactionCategory.fromKey(
                                tx.categoryKey,
                              ).displayText
                            : t.category.other),
                  style: theme.typography.base.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${tx.addedByUsername ?? "Unknown"} · $timeDisplay',
                  style: theme.typography.xs.copyWith(
                    color: colors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
          // Amount - using unified AmountText component
          tx.display != null
              ? AmountText.fromDisplay(
                  display: tx.display!,
                  type: transactionType,
                  style: theme.typography.base.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                )
              : AmountText(
                  amount: double.tryParse(tx.amount) ?? 0.0,
                  type: transactionType,
                  currency: tx.currency,
                  style: theme.typography.base.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ],
      ),
    );
  }

  /// Show invite member BottomSheet
  void _showInviteSheet(SharedSpace space) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _InviteCodeSheet(space: space),
    );
  }

  void _navigateToSettings(SharedSpace space) {
    context.push(
      '/profile/shared-space/${widget.spaceId}/settings',
      extra: space,
    );
  }
}

/// Invite Code BottomSheet
class _InviteCodeSheet extends ConsumerStatefulWidget {
  final SharedSpace space;

  const _InviteCodeSheet({required this.space});

  @override
  ConsumerState<_InviteCodeSheet> createState() => _InviteCodeSheetState();
}

class _InviteCodeSheetState extends ConsumerState<_InviteCodeSheet> {
  InviteCode? _inviteCode;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _generateInviteCode();
  }

  Future<void> _generateInviteCode() async {
    try {
      final service = ref.read(sharedSpaceServiceProvider);
      final inviteCode = await service.generateInviteCode(widget.space.id);
      if (mounted) {
        setState(() {
          _inviteCode = inviteCode;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('[_InviteCodeSheet] Error: $e');
      if (mounted) {
        setState(() {
          _error = 'Failed to generate invite code';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colors.muted,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          // Title
          Text(
            'Invite Members',
            style: theme.typography.xl.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Share the invite code with friends to collaborate',
            style: theme.typography.sm.copyWith(color: colors.mutedForeground),
          ),
          const SizedBox(height: 24),
          // Content
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            )
          else if (_error != null)
            Column(
              children: [
                Icon(
                  FIcons.circleAlert,
                  size: 48,
                  color: colors.mutedForeground,
                ),
                const SizedBox(height: 12),
                Text(
                  'Failed to generate invite code',
                  style: theme.typography.sm.copyWith(
                    color: colors.mutedForeground,
                  ),
                ),
                const SizedBox(height: 16),
                FButton(
                  style: FButtonStyle.outline(),
                  onPress: () {
                    setState(() {
                      _isLoading = true;
                      _error = null;
                    });
                    _generateInviteCode();
                  },
                  child: const Text('Retry'),
                ),
              ],
            )
          else if (_inviteCode != null)
            Column(
              children: [
                // Invite code display
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colors.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Invite Code',
                        style: theme.typography.sm.copyWith(
                          color: colors.mutedForeground,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _inviteCode!.code,
                        style: theme.typography.xl3.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                          color: colors.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Valid for 24 hours',
                        style: theme.typography.xs.copyWith(
                          color: colors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Copy button
                FButton(
                  style: FButtonStyle.primary(),
                  onPress: () {
                    Clipboard.setData(ClipboardData(text: _inviteCode!.code));
                    ToastService.show(
                      description: Text(
                        'Invite code copied: ${_inviteCode!.code}',
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(FIcons.copy, size: 16),
                      const SizedBox(width: 8),
                      const Text('Copy Invite Code'),
                    ],
                  ),
                ),
              ],
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
