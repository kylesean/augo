import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:augo/core/constants/category_constants.dart';
import 'package:augo/i18n/strings.g.dart';
import '../models/recurring_transaction.dart';

/// 分类选择返回结果
class CategorySelectionResult {
  final TransactionCategory category;
  final String categoryKey;
  final String categoryName;

  const CategorySelectionResult({
    required this.category,
    required this.categoryKey,
    required this.categoryName,
  });
}

/// 分类选择底部弹窗 - 使用 FPicker 滚轮选择器
///
/// 支持根据交易类型过滤分类列表
class CategorySelectionSheet extends StatefulWidget {
  final TransactionCategory? selectedCategory;
  final RecurringTransactionType? transactionType;

  const CategorySelectionSheet({
    super.key,
    this.selectedCategory,
    this.transactionType,
  });

  /// 显示弹窗
  static Future<CategorySelectionResult?> show(
    BuildContext context, {
    TransactionCategory? selectedCategory,
    RecurringTransactionType? transactionType,
  }) {
    return showModalBottomSheet<CategorySelectionResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CategorySelectionSheet(
        selectedCategory: selectedCategory,
        transactionType: transactionType,
      ),
    );
  }

  @override
  State<CategorySelectionSheet> createState() => _CategorySelectionSheetState();
}

class _CategorySelectionSheetState extends State<CategorySelectionSheet> {
  late FPickerController _controller;
  late List<TransactionCategory> _categories;

  @override
  void initState() {
    super.initState();
    // 根据交易类型过滤分类
    _categories = _getCategoriesForType(widget.transactionType);

    // 找到当前选中分类的索引
    final initialIndex = widget.selectedCategory != null
        ? _categories.indexOf(widget.selectedCategory!)
        : 0;

    _controller = FPickerController(
      initialIndexes: [initialIndex >= 0 ? initialIndex : 0],
    );
  }

  /// 根据交易类型获取对应的分类列表
  List<TransactionCategory> _getCategoriesForType(
    RecurringTransactionType? type,
  ) {
    switch (type) {
      case RecurringTransactionType.expense:
        return TransactionCategory.expenseCategories;
      case RecurringTransactionType.income:
        return TransactionCategory.incomeCategories;
      case RecurringTransactionType.transfer:
        return TransactionCategory.transferCategories;
      case null:
        // 默认显示支出分类
        return TransactionCategory.expenseCategories;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    return Container(
      height: 360,
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // 拖动条
            Container(
              width: 32,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // 标题栏
            _buildHeader(theme, colors),
            const SizedBox(height: 16),
            // FPicker 分类选择器
            Expanded(child: _buildCategoryPicker(theme, colors)),
            // 底部按钮
            _buildBottomButtons(theme, colors),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(FThemeData theme, FColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const SizedBox(width: 48), // 平衡右侧空间
          Expanded(
            child: Text(
              t.transaction.category,
              textAlign: TextAlign.center,
              style: theme.typography.base.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.foreground,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildCategoryPicker(FThemeData theme, FColors colors) {
    return FPicker(
      controller: _controller,
      children: [
        FPickerWheel(
          loop: true, // 开启循环（禁用会导致 Web 平台 bug）
          children: _categories.map((category) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    category.icon,
                    size: 20,
                    color: category.themedColor(theme),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    category.displayText,
                    style: theme.typography.base.copyWith(
                      color: colors.foreground,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBottomButtons(FThemeData theme, FColors colors) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: FButton(
              style: FButtonStyle.outline(),
              onPress: () => Navigator.pop(context),
              child: Text(t.common.cancel),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FButton(
              onPress: () {
                final rawIndex = _controller.value[0];
                // 循环模式下索引可能为负数或超大值，使用取模运算
                // Dart 的 % 对负数有问题，需要特殊处理
                int selectedIndex = rawIndex % _categories.length;
                if (selectedIndex < 0) {
                  selectedIndex += _categories.length;
                }
                final selectedCategory = _categories[selectedIndex];
                Navigator.of(context).pop(
                  CategorySelectionResult(
                    category: selectedCategory,
                    categoryKey: selectedCategory.key,
                    categoryName: selectedCategory.displayText,
                  ),
                );
              },
              child: Text(t.common.ok),
            ),
          ),
        ],
      ),
    );
  }
}
