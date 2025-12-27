import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:forui/forui.dart';

import '../models/account_type_definition.dart';
import 'account_add_page.dart';
import 'package:augo/i18n/strings.g.dart';

class AccountTypePickerPage extends ConsumerWidget {
  const AccountTypePickerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.theme;
    final colors = theme.colors;
    final grouped = _groupByPickerCategory();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(FIcons.chevronLeft, color: colors.foreground),
          onPressed: () => context.pop(),
        ),
        titleSpacing: 0,

        centerTitle: true,
        title: Text(
          t.account.selectTypeTitle,
          style: theme.typography.lg.copyWith(
            fontWeight: FontWeight.w600,
            color: colors.foreground,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          for (final entry in grouped.entries) ...[
            // Section header
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 12),
              child: Text(
                entry.key.displayName,
                style: theme.typography.sm.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colors.mutedForeground,
                ),
              ),
            ),
            // Grid of account types
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.3, // 增加比例，缩小卡片高度
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: entry.value.length,
              itemBuilder: (context, index) {
                final definition = entry.value[index];
                return _AccountTypeCard(
                  definition: definition,
                  onTap: () => _handleSelect(context, definition),
                );
              },
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  /// Group types into Assets vs Liabilities for picker display
  static Map<PickerCategory, List<AccountTypeDefinition>>
  _groupByPickerCategory() {
    final assets = <AccountTypeDefinition>[];
    final liabilities = <AccountTypeDefinition>[];

    for (final definition in AccountTypeRegistry.definitions) {
      if (definition.nature == AccountNature.creditAccounts ||
          definition.nature == AccountNature.longTermLiabilities ||
          definition.id == 'payable') {
        liabilities.add(definition);
      } else {
        assets.add(definition);
      }
    }

    return {
      PickerCategory.assets: assets,
      PickerCategory.liabilities: liabilities,
    };
  }

  Future<void> _handleSelect(
    BuildContext context,
    AccountTypeDefinition definition,
  ) async {
    final result = await context.pushNamed(
      'financialAccountAdd',
      extra: FinancialAccountAddArgs(definition: definition),
    );
    if (!context.mounted) return;
    if (result != null) {
      context.pop(result);
    }
  }
}

/// Category for type picker grouping
enum PickerCategory { assets, liabilities }

extension PickerCategoryX on PickerCategory {
  String get displayName {
    switch (this) {
      case PickerCategory.assets:
        return t.account.assetsCategory;
      case PickerCategory.liabilities:
        return t.account.liabilitiesCategory;
    }
  }
}

/// Account type card widget matching reference design
class _AccountTypeCard extends StatelessWidget {
  const _AccountTypeCard({required this.definition, required this.onTap});

  final AccountTypeDefinition definition;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;
    final (title, subtitle) = _getLocalizedText(definition);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.border, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 图标容器 - 使用统一的设计 token
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colors.secondary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(child: definition.iconBuilder(colors.foreground)),
            ),
            const SizedBox(height: 8),
            // 标题 - 使用 Flexible 防止溢出
            Text(
              title,
              style: theme.typography.base.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.foreground,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            // 描述 - 使用 Expanded 填充剩余空间
            Expanded(
              child: Text(
                subtitle,
                style: theme.typography.xs.copyWith(
                  color: colors.mutedForeground,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 获取本地化的标题和描述
  (String title, String subtitle) _getLocalizedText(
    AccountTypeDefinition definition,
  ) {
    switch (definition.id) {
      case 'cash':
        return (t.account.types.cashTitle, t.account.types.cashSubtitle);
      case 'deposit':
        return (t.account.types.depositTitle, t.account.types.depositSubtitle);
      case 'e_money':
        return (t.account.types.eMoneyTitle, t.account.types.eMoneySubtitle);
      case 'investment':
        return (
          t.account.types.investmentTitle,
          t.account.types.investmentSubtitle,
        );
      case 'receivable':
        return (
          t.account.types.receivableTitle,
          t.account.types.receivableSubtitle,
        );
      case 'credit_card':
        return (
          t.account.types.creditCardTitle,
          t.account.types.creditCardSubtitle,
        );
      case 'loan':
        return (t.account.types.loanTitle, t.account.types.loanSubtitle);
      case 'payable':
        return (t.account.types.payableTitle, t.account.types.payableSubtitle);
      default:
        return (definition.title, definition.subtitle);
    }
  }
}
