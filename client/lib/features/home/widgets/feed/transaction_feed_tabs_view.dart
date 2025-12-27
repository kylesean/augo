import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:augo/i18n/strings.g.dart';
import '../../../../shared/widgets/app_filter_chip.dart';
import '../../providers/home_providers.dart';
import 'transaction_feed_view.dart';

class TransactionFeedTabsView extends ConsumerWidget {
  const TransactionFeedTabsView({super.key});

  List<({TransactionFeedType type, String label})> _getTabData() {
    return [
      (type: TransactionFeedType.all, label: t.common.all),
      (type: TransactionFeedType.expense, label: t.transaction.expense),
      (type: TransactionFeedType.income, label: t.transaction.income),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSelectedType = ref.watch(currentTransactionFeedTypeProvider);

    // Build custom Tab button bar
    Widget buildCustomTabBar() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          children: _getTabData().map((tabInfo) {
            final isSelected = tabInfo.type == currentSelectedType;

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: AppFilterChip(
                  label: tabInfo.label,
                  isSelected: isSelected,
                  onTap: () {
                    ref
                        .read(currentTransactionFeedTypeProvider.notifier)
                        .set(tabInfo.type);
                  },
                ),
              ),
            );
          }).toList(),
        ),
      );
    }

    Widget buildContentArea() {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: TransactionFeedView(
          key: ValueKey(currentSelectedType),
          intendedFeedType: currentSelectedType,
        ),
      );
    }

    return Column(
      children: [
        buildCustomTabBar(),
        Expanded(child: buildContentArea()),
      ],
    );
  }
}
