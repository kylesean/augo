// features/home/widgets/feed/transaction_card.dart
import 'package:flutter/material.dart';
import 'package:augo/shared/widgets/cards/app_card.dart';
import 'package:augo/shared/widgets/themed_icon.dart';
import 'package:augo/core/utils/app_haptics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:forui/forui.dart';
import 'package:augo/i18n/strings.g.dart';

import 'package:augo/features/home/models/transaction_model.dart';
import 'package:augo/features/home/providers/home_providers.dart';
import 'package:augo/shared/config/category_config.dart';
import 'package:augo/core/widgets/top_toast.dart';
import 'package:augo/core/constants/category_constants.dart';

import 'package:augo/shared/utils/amount_formatter.dart';
import 'package:augo/shared/providers/amount_theme_provider.dart';

/// TransactionCard
class TransactionCard extends ConsumerWidget {
  final TransactionModel transaction;

  const TransactionCard({super.key, required this.transaction});

  String _getCategoryDisplayName(TransactionModel transaction) {
    if (transaction.categoryText != null &&
        transaction.categoryText!.isNotEmpty) {
      return transaction.categoryText!;
    }

    if (transaction.categoryKey != null &&
        transaction.categoryKey!.isNotEmpty) {
      try {
        return TransactionCategory.fromKey(
          transaction.categoryKey!,
        ).displayText;
      } catch (_) {
        return CategoryConfig.getCategoryName(transaction.categoryKey!);
      }
    }
    return transaction.category;
  }

  String _getAmountDisplayText(TransactionModel transaction) {
    if (transaction.display != null) {
      return transaction.display!.fullString;
    }

    return AmountFormatter.formatTransaction(
      type: transaction.type,
      amount: transaction.amount,
      currency: transaction.paymentMethod ?? 'CNY',
      showSign: true,
    );
  }

  String _getTimeDisplay(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return t.time.justNow;
    } else if (difference.inMinutes < 60) {
      return t.time.minutesAgo(count: difference.inMinutes);
    } else if (difference.inHours < 24) {
      return t.time.hoursAgo(count: difference.inHours);
    } else if (difference.inDays < 7) {
      return t.time.daysAgo(count: difference.inDays);
    } else {
      return t.time.weeksAgo(count: (difference.inDays / 7).floor());
    }
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    return await showAdaptiveDialog<bool>(
          context: context,
          builder: (context) => FDialog(
            direction: Axis.horizontal,
            title: Text(t.transaction.confirmDelete),
            body: Text(t.transaction.deleteTransactionConfirm),
            actions: [
              FButton(
                style: FButtonStyle.outline(),
                onPress: () => Navigator.of(context).pop(false),
                child: Text(t.common.cancel),
              ),
              FButton(
                style: FButtonStyle.destructive(),
                onPress: () => Navigator.of(context).pop(true),
                child: Text(t.common.delete),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<bool> _performDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await _showDeleteConfirmation(context);
    if (!confirmed) return false;

    AppHaptics.medium();

    final notifier = ref.read(transactionFeedProvider.notifier);
    final success = await notifier.deleteTransaction(transaction.id);

    if (success && context.mounted) {
      AppHaptics.success();
      TopToast.success(context, t.transaction.deleted);
    } else if (!success && context.mounted) {
      AppHaptics.error();
      TopToast.error(context, t.transaction.deleteFailed);
    }

    return success;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.theme;
    final colors = theme.colors;
    final amountTheme = ref.watch(currentAmountThemeProvider);

    return Dismissible(
      key: Key('transaction_${transaction.id}'),
      direction: DismissDirection.endToStart,
      dismissThresholds: const {DismissDirection.endToStart: 0.4},
      confirmDismiss: (direction) async {
        await AppHaptics.selection();
        if (context.mounted) {
          return await _performDelete(context, ref);
        }
        return false;
      },
      background: Container(
        color: colors.background,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: colors.destructive,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: colors.destructive.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            FIcons.trash2,
            color: colors.destructiveForeground,
            size: 22,
          ),
        ),
      ),
      child: AppCard(
        onTap: () {
          context.pushNamed(
            'transactionDetail',
            pathParameters: {'transactionId': transaction.id},
          );
        },
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        backgroundColor: colors.background,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- Left: Category Icon (ThemedIcon) ---
            ThemedIcon.large(
              icon: transaction.categoryKey != null
                  ? CategoryConfig.getCategoryIcon(transaction.categoryKey)
                  : CategoryConfig.getCategoryIconByName(transaction.category),
            ),
            const SizedBox(width: 14),

            // --- Right: Content ---
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row 1: Category Name + Amount
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Expanded(
                        child: Text(
                          _getCategoryDisplayName(transaction),
                          style: theme.typography.base.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _getAmountDisplayText(transaction),
                        style: theme.typography.lg.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AmountFormatter.getAmountColor(
                            transaction.type,
                            amountTheme,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Row 2: Tags/PaymentMethod + Time
                  Row(
                    children: [
                      // Tags or Payment Method
                      Expanded(
                        child: transaction.tags.isNotEmpty
                            ? _buildTagsRow(theme, colors, transaction.tags)
                            : Text(
                                transaction.paymentMethod ??
                                    t.transaction.expense,
                                style: theme.typography.sm.copyWith(
                                  color: colors.mutedForeground,
                                ),
                              ),
                      ),
                      // Time display
                      Text(
                        _getTimeDisplay(transaction.timestamp),
                        style: theme.typography.xs.copyWith(
                          color: colors.mutedForeground,
                        ),
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

  /// 构建标签行
  Widget _buildTagsRow(FThemeData theme, FColors colors, List<String> tags) {
    final maxVisible = 2;
    final visibleTags = tags.take(maxVisible).toList();
    final extraCount = tags.length - maxVisible;

    return Row(
      children: [
        ...visibleTags.map(
          (tag) => Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: colors.secondary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                tag,
                style: theme.typography.xs.copyWith(
                  color: colors.foreground,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        if (extraCount > 0)
          Text(
            '+$extraCount',
            style: theme.typography.xs.copyWith(color: colors.mutedForeground),
          ),
      ],
    );
  }
}
