// features/home/widgets/calendar/daily_transaction_modal.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:augo/features/home/models/transaction_model.dart';
import 'package:augo/features/home/providers/home_providers.dart';
import 'package:augo/i18n/strings.g.dart';

class DailyTransactionModal extends ConsumerWidget {
  final DateTime selectedDate;

  const DailyTransactionModal({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final transactionsAsyncValue = ref.watch(
      transactionsForSelectedDateProvider(selectedDate),
    );

    return DraggableScrollableSheet(
      initialChildSize: 0.5, // Initial height is half of the screen
      minChildSize: 0.3,
      maxChildSize: 0.8,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Text(() {
                final locale = LocaleSettings.currentLocale;
                final (dateFormatLocale, pattern) = switch (locale) {
                  AppLocale.zh => ('zh_CN', 'yyyy年M月d日'),
                  AppLocale.en => ('en', 'yyyy/MM/dd'),
                  AppLocale.ja => ('ja', 'yyyy年M月d日'),
                  AppLocale.ko => ('ko', 'yyyy년 M월 d일'),
                  AppLocale.zhHant => ('zh_TW', 'yyyy年M月d日'),
                };
                return '${DateFormat(pattern, dateFormatLocale).format(selectedDate)} ${t.common.history}';
              }(), style: theme.textTheme.titleLarge),
              const SizedBox(height: 16.0),
              Expanded(
                child: transactionsAsyncValue.when(
                  data: (transactions) {
                    if (transactions.isEmpty) {
                      return Center(
                        child: Text(t.calendar.noTransactionsTitle),
                      );
                    }
                    return ListView.separated(
                      controller: scrollController,
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = transactions[index];
                        return ListTile(
                          leading: CircleAvatar(
                            child: Image.asset(
                              transaction.iconUrl,
                              errorBuilder: (c, e, s) =>
                                  const Icon(Icons.help_outline),
                            ),
                          ),
                          title: Text(transaction.category),
                          subtitle: Text(
                            transaction.description ??
                                t.transaction.noDescription,
                          ),
                          trailing: Text(
                            '${transaction.type == TransactionType.expense ? '-' : '+'}${transaction.amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: transaction.type == TransactionType.expense
                                  ? Colors.redAccent
                                  : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(
                    child: Text('${t.calendar.loadTransactionFailed}: $err'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
