import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import '../molecules/molecules.dart';

/// 账户选择 Sheet（弹窗）
///
/// 可复用的账户选择弹窗，点击账户直接选中并关闭
class AccountSelectSheet extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> accounts;
  final String? selectedId;

  const AccountSelectSheet({
    super.key,
    required this.title,
    required this.accounts,
    this.selectedId,
  });

  /// 显示账户选择 Sheet
  static Future<String?> show({
    required BuildContext context,
    required String title,
    required List<Map<String, dynamic>> accounts,
    String? selectedId,
  }) async {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (ctx) => AccountSelectSheet(
        title: title,
        accounts: accounts,
        selectedId: selectedId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 顶部拖拽指示线
          Container(
            width: 32,
            height: 4,
            margin: const EdgeInsets.only(top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: colors.muted,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // 头部
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.typography.lg.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colors.foreground,
                    ),
                  ),
                ),
                FFancyButton.icon(
                  onPress: () => Navigator.pop(context),
                  child: Icon(
                    FIcons.x,
                    size: 20,
                    color: colors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),

          // 账户列表
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: accounts.map((account) {
                  final id = account['id'] as String;
                  final isSelected = id == selectedId;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AccountCard(
                      data: account,
                      selected: isSelected,
                      onTap: () => Navigator.pop(context, id),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 由于 FButton 可能没有 icon 构造函数方便直接用在 header，使用基础样式
class FFancyButton extends StatelessWidget {
  final VoidCallback onPress;
  final Widget child;

  const FFancyButton.icon({
    super.key,
    required this.onPress,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        padding: const EdgeInsets.all(8),
        color: Colors.transparent,
        child: child,
      ),
    );
  }
}
