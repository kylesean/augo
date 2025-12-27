import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:forui/forui.dart';

class TransactionDetailSkeleton extends StatelessWidget {
  const TransactionDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    // Shimmer effect colors (refer to transaction card skeleton design)
    final Color shimmerBaseColor = Colors.grey[200]!;
    final Color shimmerHighlightColor = Colors.grey[50]!;
    final Color placeholderShapeColor = Colors.grey[200]!;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header skeleton
            _buildHeaderSkeleton(
              shimmerBaseColor,
              shimmerHighlightColor,
              placeholderShapeColor,
            ),

            Expanded(
              child: CustomScrollView(
                slivers: [
                  // Detail card
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      child: FCard(
                        child: Shimmer.fromColors(
                          baseColor: shimmerBaseColor,
                          highlightColor: shimmerHighlightColor,
                          period: const Duration(milliseconds: 1200),
                          child: _buildDetailSkeleton(placeholderShapeColor),
                        ),
                      ),
                    ),
                  ),

                  // Comment/Remark area block
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                      child: Shimmer.fromColors(
                        baseColor: shimmerBaseColor,
                        highlightColor: shimmerHighlightColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // "Comment" title placeholder
                            Container(
                              height: 18,
                              width: 60,
                              decoration: BoxDecoration(
                                color: placeholderShapeColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Simulate a simple comment
                            Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: placeholderShapeColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 12,
                                        width: 80,
                                        color: placeholderShapeColor,
                                      ),
                                      const SizedBox(height: 6),
                                      Container(
                                        height: 12,
                                        color: placeholderShapeColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom input bar placeholder
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colors.background,
                border: Border(
                  top: BorderSide(
                    color: colors.border.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
              ),
              child: Shimmer.fromColors(
                baseColor: shimmerBaseColor,
                highlightColor: shimmerHighlightColor,
                child: Container(
                  decoration: BoxDecoration(
                    color: placeholderShapeColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build page header skeleton
  Widget _buildHeaderSkeleton(
    Color baseColor,
    Color highlightColor,
    Color placeholderColor,
  ) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: placeholderColor,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Center(
                child: Container(
                  height: 20,
                  width: 120,
                  color: placeholderColor,
                ),
              ),
            ),
            const SizedBox(width: 48), // Placeholder to keep title centered
          ],
        ),
      ),
    );
  }

  // Build detail content skeleton
  Widget _buildDetailSkeleton(Color placeholderColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top: category icon, category name, time
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: placeholderColor,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 18, width: 100, color: placeholderColor),
                  const SizedBox(height: 6),
                  Container(height: 14, width: 60, color: placeholderColor),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // Amount skeleton
        Center(
          child: Container(height: 40, width: 180, color: placeholderColor),
        ),
        const SizedBox(height: 32),

        // Divider
        Container(height: 1, color: placeholderColor.withValues(alpha: 0.5)),
        const SizedBox(height: 24),

        // Detailed info rows skeleton (time, account, etc.)
        ...List.generate(
          2,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: placeholderColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(width: 12),
                Container(height: 14, width: 50, color: placeholderColor),
                const SizedBox(width: 24),
                Expanded(child: Container(height: 14, color: placeholderColor)),
              ],
            ),
          ),
        ),

        // Remark info (original record) placeholder
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: placeholderColor,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(width: 12),
              Container(height: 14, width: 50, color: placeholderColor),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 14, color: placeholderColor),
                    const SizedBox(height: 8),
                    Container(height: 14, width: 120, color: placeholderColor),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
