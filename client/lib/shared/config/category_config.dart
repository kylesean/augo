// shared/config/category_config.dart
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:augo/i18n/strings.g.dart';

/// Category configuration management class
/// Responsible for managing the mapping relationship between category IDs, names, and icons, using slang multi-language support
class CategoryConfig {
  // Direct mapping from category ID to icon
  static const Map<String, IconData> _categoryIdToIcon = {
    '1': FIcons.shoppingBag,
    '2': FIcons.carTaxiFront,
    '3': FIcons.briefcaseMedical,
    '4': FIcons.housePlus,
    '5': FIcons.libraryBig,
    '6': FIcons.walletCards,
    '7': FIcons.gift,
    '8': FIcons.folderSync,
  };

  /// Get category name based on category ID (using slang internationalization)
  static String getCategoryName(String? categoryId) {
    if (categoryId == null) return t.category.other;
    switch (categoryId) {
      case '1':
        return t.category.dailyConsumption;
      case '2':
        return t.category.transportation;
      case '3':
        return t.category.healthcare;
      case '4':
        return t.category.housing;
      case '5':
        return t.category.education;
      case '6':
        return t.category.incomeCategory;
      case '7':
        return t.category.socialGifts;
      case '8':
        return t.category.moneyTransfer;
      default:
        return t.category.other;
    }
  }

  /// Get category icon based on category ID
  static IconData getCategoryIcon(String? categoryId) {
    if (categoryId == null) return FIcons.shoppingBag;
    return _categoryIdToIcon[categoryId] ?? FIcons.shoppingBag;
  }

  /// Get category icon based on category name (backward compatibility)
  static IconData getCategoryIconByName(String categoryName) {
    // Reverse mapping from name to ID
    const Map<String, IconData> nameToIcon = {
      'Daily Expenses': FIcons.shoppingBag,
      'Transportation': FIcons.carTaxiFront,
      'Healthcare': FIcons.briefcaseMedical,
      'Housing': FIcons.housePlus,
      'Education': FIcons.libraryBig,
      'Income': FIcons.walletCards,
      'Social Gifts': FIcons.gift,
      'Money Transfer': FIcons.folderSync,
    };
    return nameToIcon[categoryName] ?? FIcons.shoppingBag;
  }

  /// Get all categories list
  static List<CategoryItem> getAllCategories() {
    return [
      CategoryItem(
        id: '1',
        name: t.category.dailyConsumption,
        icon: _categoryIdToIcon['1']!,
      ),
      CategoryItem(
        id: '2',
        name: t.category.transportation,
        icon: _categoryIdToIcon['2']!,
      ),
      CategoryItem(
        id: '3',
        name: t.category.healthcare,
        icon: _categoryIdToIcon['3']!,
      ),
      CategoryItem(
        id: '4',
        name: t.category.housing,
        icon: _categoryIdToIcon['4']!,
      ),
      CategoryItem(
        id: '5',
        name: t.category.education,
        icon: _categoryIdToIcon['5']!,
      ),
      CategoryItem(
        id: '6',
        name: t.category.incomeCategory,
        icon: _categoryIdToIcon['6']!,
      ),
      CategoryItem(
        id: '7',
        name: t.category.socialGifts,
        icon: _categoryIdToIcon['7']!,
      ),
      CategoryItem(
        id: '8',
        name: t.category.moneyTransfer,
        icon: _categoryIdToIcon['8']!,
      ),
    ];
  }

  /// Check if category ID is valid
  static bool isValidCategoryId(String? categoryId) {
    return categoryId != null && _categoryIdToIcon.containsKey(categoryId);
  }
}

/// Category item data class
class CategoryItem {
  final String id;
  final String name;
  final IconData icon;

  const CategoryItem({
    required this.id,
    required this.name,
    required this.icon,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryItem &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'CategoryItem(id: $id, name: $name)';
}
