import 'dart:async';
import 'package:flutter/material.dart';
import 'package:augo/features/home/models/transaction_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:augo/features/home/providers/home_providers.dart';
import 'package:augo/features/home/widgets/feed/transaction_card.dart';
import 'package:shimmer/shimmer.dart';
import 'package:forui/forui.dart';
import 'package:augo/i18n/strings.g.dart';

class TransactionFeedView extends ConsumerStatefulWidget {
  final TransactionFeedType intendedFeedType;

  const TransactionFeedView({super.key, required this.intendedFeedType});

  @override
  ConsumerState<TransactionFeedView> createState() =>
      _TransactionFeedViewState();
}

class _TransactionFeedViewState extends ConsumerState<TransactionFeedView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Only allow loading more if the current view's type matches the globally selected one
    if (widget.intendedFeedType ==
        ref.read(currentTransactionFeedTypeProvider)) {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        final notifier = ref.read(transactionFeedProvider.notifier);
        final TransactionFeedState feedState = ref.read(
          transactionFeedProvider,
        );
        if (!feedState.isLoadingMore && !feedState.hasReachedMax) {
          unawaited(notifier.fetchMoreTransactions());
        }
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // Build skeleton for a single transaction card
  Widget _buildTransactionCardSkeleton(BuildContext context) {
    final Color shimmerBaseColor = Colors.grey[200]!; // Base color for shimmer
    final Color shimmerHighlightColor =
        Colors.grey[50]!; // Highlight color for shimmer
    final Color placeholderShapeColor =
        Colors.grey[200]!; // Shape colors for layout

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      color: Colors.white,
      child: Shimmer.fromColors(
        baseColor: shimmerBaseColor,
        highlightColor: shimmerHighlightColor,
        period: const Duration(milliseconds: 1200),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 40,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: placeholderShapeColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          height: 15,
                          color: placeholderShapeColor,
                          margin: const EdgeInsets.only(right: 16),
                        ),
                      ),
                      Container(
                        height: 12,
                        width: 50,
                        color: placeholderShapeColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 18,
                    width: 120,
                    color: placeholderShapeColor,
                    margin: const EdgeInsets.symmetric(vertical: 1),
                  ),
                  const SizedBox(height: 10),
                  Container(height: 14, color: placeholderShapeColor),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    final TransactionFeedType globalCurrentFeedType = ref.watch(
      currentTransactionFeedTypeProvider,
    );
    final TransactionFeedState feedState = ref.watch(transactionFeedProvider);
    final List<TransactionModel> transactions = feedState.transactions;

    final shouldShowSkeletonDueToTypeMismatch =
        widget.intendedFeedType != globalCurrentFeedType;

    if (shouldShowSkeletonDueToTypeMismatch ||
        (feedState.isLoadingMore &&
            transactions.isEmpty &&
            !feedState.hasReachedMax)) {
      return ListView.separated(
        itemCount: 5, // Show a few skeleton items
        itemBuilder: (context, index) => _buildTransactionCardSkeleton(context),
        separatorBuilder: (context, index) =>
            const FDivider(axis: Axis.horizontal),
      );
    }

    if (feedState.errorMessage != null &&
        widget.intendedFeedType == globalCurrentFeedType) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${t.home.loadFailed}: ${feedState.errorMessage}',
              style: theme.typography.base.copyWith(color: colors.destructive),
            ),
            const SizedBox(height: 16),
            FButton(
              onPress: () async => await ref
                  .read(transactionFeedProvider.notifier)
                  .refreshFeed(),
              child: Text(t.common.retry),
            ),
          ],
        ),
      );
    }

    if (transactions.isEmpty &&
        !feedState.isLoadingMore &&
        widget.intendedFeedType == globalCurrentFeedType) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              t.home.noTransactions,
              style: theme.typography.base.copyWith(
                color: colors.mutedForeground,
              ),
            ),
            const SizedBox(height: 16),
            FButton(
              mainAxisSize: MainAxisSize.min,
              onPress: () async => await ref
                  .read(transactionFeedProvider.notifier)
                  .refreshFeed(),
              child: Text(t.home.tryRefresh),
            ),
          ],
        ),
      );
    }

    if (widget.intendedFeedType != globalCurrentFeedType) {
      return const SizedBox.shrink();
    }

    return RefreshIndicator(
      color: colors.primary,
      backgroundColor: colors.background,
      onRefresh: () async {
        if (widget.intendedFeedType ==
            ref.read(currentTransactionFeedTypeProvider)) {
          await ref.read(transactionFeedProvider.notifier).refreshFeed();
        }
      },
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 6),
        controller: _scrollController,
        itemCount:
            transactions.length +
            ((feedState.isLoadingMore && transactions.isNotEmpty) ||
                    (feedState.hasReachedMax && transactions.isNotEmpty)
                ? 1
                : 0),
        itemBuilder: (context, index) {
          if (index < transactions.length) {
            final transaction = transactions[index];
            return TransactionCard(transaction: transaction);
          } else if (index == transactions.length &&
              feedState.isLoadingMore &&
              transactions.isNotEmpty) {
            return _buildTransactionCardSkeleton(context);
          } else if (index == transactions.length &&
              feedState.hasReachedMax &&
              transactions.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  t.home.noMoreData,
                  style: theme.typography.sm.copyWith(
                    color: colors.mutedForeground,
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
        separatorBuilder: (context, index) => Divider(
          height: 0.5,
          thickness: 0.5,
          color: colors.border.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}
