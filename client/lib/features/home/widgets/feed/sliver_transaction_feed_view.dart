import 'package:flutter/material.dart';
import 'package:augo/features/home/models/transaction_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:augo/features/home/providers/home_providers.dart';
import 'package:augo/features/home/widgets/feed/transaction_card.dart';
import 'package:shimmer/shimmer.dart';
import 'package:forui/forui.dart';
import 'package:augo/i18n/strings.g.dart';

class SliverTransactionFeedView extends ConsumerWidget {
  final TransactionFeedType intendedFeedType;

  const SliverTransactionFeedView({super.key, required this.intendedFeedType});

  // Build skeleton for a single transaction card
  Widget _buildTransactionCardSkeleton(BuildContext context) {
    // theme variable was unused, removed
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    // Increase contrast to avoid overlapping with background color
    final Color shimmerBaseColor = isDark
        ? const Color(0xFF2A2A2A)
        : Colors.grey[300]!;
    final Color shimmerHighlightColor = isDark
        ? const Color(0xFF424242)
        : Colors.grey[100]!;
    final Color placeholderShapeColor = isDark
        ? const Color(0xFF2A2A2A)
        : Colors.grey[300]!;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ), // Match padding of real card
      color: Colors
          .transparent, // Transparent background, background color controlled by external container
      child: Shimmer.fromColors(
        baseColor: shimmerBaseColor,
        highlightColor: shimmerHighlightColor,
        period: const Duration(milliseconds: 1200),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.center, // Match real card centering
          children: [
            // Left: category icon
            Container(
              width: 44, // Match real card width 44
              height: 44,
              decoration: BoxDecoration(
                color: placeholderShapeColor,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 16), // Match real card spacing 16
            // Right content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // First row: title and time
                  Row(
                    children: [
                      Container(
                        height: 16,
                        width: 100,
                        color: placeholderShapeColor,
                      ),
                      const Spacer(), // Key: push right elements to the edge, match Expanded layout of real card
                      Container(
                        height: 12,
                        width: 40,
                        color: placeholderShapeColor,
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 12, // Simulate more icon
                        width: 12,
                        decoration: BoxDecoration(
                          color: placeholderShapeColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Second row: labels and amount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 24,
                        width: 60,
                        decoration: BoxDecoration(
                          color: placeholderShapeColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      Container(
                        height: 24,
                        width: 80,
                        color: placeholderShapeColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.theme;
    final colors = theme.colors;

    final TransactionFeedType globalCurrentFeedType = ref.watch(
      currentTransactionFeedTypeProvider,
    );
    final TransactionFeedState feedState = ref.watch(transactionFeedProvider);
    final List<TransactionModel> transactions = feedState.transactions;

    final shouldShowSkeletonDueToTypeMismatch =
        intendedFeedType != globalCurrentFeedType;

    // Skeleton state
    if (shouldShowSkeletonDueToTypeMismatch ||
        (feedState.isLoadingMore &&
            transactions.isEmpty &&
            !feedState.hasReachedMax)) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index.isOdd) {
              return const FDivider(axis: Axis.horizontal);
            }
            return _buildTransactionCardSkeleton(context);
          },
          childCount: 5 * 2 - 1, // 5 items + 4 dividers
        ),
      );
    }

    // Error state
    if (feedState.errorMessage != null &&
        intendedFeedType == globalCurrentFeedType) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Failed to load: ${feedState.errorMessage}',
                style: theme.typography.sm.copyWith(
                  color: colors.mutedForeground,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FButton(
                style: FButtonStyle.outline(),
                onPress: () =>
                    ref.read(transactionFeedProvider.notifier).refreshFeed(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // Empty state
    if (transactions.isEmpty &&
        !feedState.isLoadingMore &&
        intendedFeedType == globalCurrentFeedType) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
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
                onPress: () =>
                    ref.read(transactionFeedProvider.notifier).refreshFeed(),
                child: Text(t.home.tryRefresh),
              ),
            ],
          ),
        ),
      );
    }

    if (intendedFeedType != globalCurrentFeedType) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    // Normal list
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          // Handle divider logic
          // Actual item index = index ~/ 2
          // Divider index = odd numbers

          final int itemIndex = index ~/ 2;

          // Load more / no more at the end of the list
          if (itemIndex >= transactions.length) {
            // Extra items at the bottom of the list (Loading skeleton or no more text)
            // At this point index must be even, because the divider logic handled middle parts
            if (feedState.isLoadingMore && transactions.isNotEmpty) {
              return _buildTransactionCardSkeleton(context);
            } else if (feedState.hasReachedMax && transactions.isNotEmpty) {
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
          }

          if (index.isOdd) {
            return Divider(
              height: 0.5,
              thickness: 0.5,
              color: colors.border.withValues(alpha: 0.7),
            );
          }

          final transaction = transactions[itemIndex];
          return TransactionCard(transaction: transaction);
        },
        // Calculate childCount
        // N items have N-1 dividers -> 2*N - 1
        // Plus footer (Loading/NoMore, as 1 extra item) -> (N+1) items -> 2*(N+1) - 1 ?
        // Simplifying logic:
        // childCount = (transactions.length * 2) - 1; // Base count
        // If has footer (loading or no more):
        //   childCount += 2; // +1 divider +1 footer item
        // Edge case: if list is empty, childCount is 0 (already handled by empty state)
        childCount: _calculateChildCount(transactions.length, feedState),
      ),
    );
  }

  int _calculateChildCount(int transactionCount, TransactionFeedState state) {
    if (transactionCount == 0) return 0;
    int count = transactionCount * 2 - 1;
    if ((state.isLoadingMore && transactionCount > 0) ||
        (state.hasReachedMax && transactionCount > 0)) {
      count += 2; // +1 Divider +1 Footer
    }
    return count;
  }
}
