import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../profile/models/financial_account.dart';
import '../models/account_type_definition.dart';

class FinancialAccountDetailArgs {
  const FinancialAccountDetailArgs({
    required this.account,
    required this.definition,
  });

  final FinancialAccount account;
  final AccountTypeDefinition definition;
}

class FinancialAccountDetailPage extends ConsumerWidget {
  const FinancialAccountDetailPage({super.key, required this.args});

  final FinancialAccountDetailArgs args;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.theme.colors;
    final theme = context.theme;

    final amount = double.tryParse(args.account.initialBalance.toString()) ?? 0;
    final formattedAmount = NumberFormat.currency(
      locale: 'zh_CN',
      symbol: '¥ ',
      decimalDigits: 2,
    ).format(amount);

    return Scaffold(
      appBar: AppBar(
        title: Text(args.definition.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '账户名称',
              style: theme.typography.sm.copyWith(
                color: colors.mutedForeground,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              // 使用 name 字段
              args.account.name,
              style: theme.typography.lg.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.foreground,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '当前余额',
              style: theme.typography.sm.copyWith(
                color: colors.mutedForeground,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              formattedAmount,
              style: theme.typography.xl.copyWith(
                fontWeight: FontWeight.w700,
                color: colors.foreground,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.secondary,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.border.withValues(alpha: 0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '账户类型',
                    style: theme.typography.sm.copyWith(
                      color: colors.mutedForeground,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    args.definition.title,
                    style: theme.typography.base.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colors.foreground,
                    ),
                  ),
                  if (args.definition.subtitle.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      args.definition.subtitle,
                      style: theme.typography.xs.copyWith(
                        color: colors.mutedForeground,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: Text(
                  '账户详情功能正在建设中',
                  style: theme.typography.sm.copyWith(
                    color: colors.mutedForeground,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
