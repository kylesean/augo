import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:augo/i18n/strings.g.dart';

/// Transaction category definition (12 core categories + 5 income + 2 transfer)
///
/// Corresponds to the backend TransactionCategory enum.
enum TransactionCategory {
  // --- 1. Expense Type (Type: EXPENSE) - 12 items ---
  foodDining('FOOD_DINING', 'Food & Dining', FIcons.utensils),
  shoppingRetail('SHOPPING_RETAIL', 'Shopping', FIcons.shoppingBag),
  transportation('TRANSPORTATION', 'Transportation', FIcons.car),
  housingUtilities('HOUSING_UTILITIES', 'Housing & Utilities', FIcons.house),
  personalCare('PERSONAL_CARE', 'Personal Care', FIcons.scissors),
  entertainment('ENTERTAINMENT', 'Entertainment', FIcons.gamepad2),
  education('EDUCATION', 'Education', FIcons.graduationCap),
  medicalHealth('MEDICAL_HEALTH', 'Medical & Health', FIcons.activity),
  insurance('INSURANCE', 'Insurance', FIcons.shield),
  socialGifting('SOCIAL_GIFTING', 'Social & Gifting', FIcons.gift),
  financialTax('FINANCIAL_TAX', 'Financial & Tax', FIcons.percent),
  others('OTHERS', 'Others', FIcons.receipt),

  // --- 2. Income Type (Type: INCOME) - 5 items ---
  salaryWage('SALARY_WAGE', 'Salary', FIcons.briefcase),
  businessTrade('BUSINESS_TRADE', 'Business', FIcons.store),
  investmentReturns(
    'INVESTMENT_RETURNS',
    'Investment Returns',
    FIcons.trendingUp,
  ),
  giftBonus('GIFT_BONUS', 'Gift & Bonus', FIcons.gift),
  refundRebate('REFUND_REBATE', 'Refund', FIcons.undo2),

  // --- 3. Transfer Type (Type: TRANSFER) - 2 items ---
  generalTransfer('GENERAL_TRANSFER', 'Transfer', FIcons.arrowRightLeft),
  debtRepayment('DEBT_REPAYMENT', 'Debt Repayment', FIcons.creditCard),

  // --- 4. Compatibility ---
  incomeLegacy('INCOME', 'Income', FIcons.wallet);

  final String key;
  final String label;
  final IconData icon;

  const TransactionCategory(this.key, this.label, this.icon);

  /// Backward compatibility: name as alias for label
  String get name => label;

  /// Get simplified display text from translations
  String get displayText {
    switch (this) {
      case TransactionCategory.foodDining:
        return t.category.foodDining;
      case TransactionCategory.shoppingRetail:
        return t.category.shoppingRetail;
      case TransactionCategory.transportation:
        return t.category.transportation;
      case TransactionCategory.housingUtilities:
        return t.category.housingUtilities;
      case TransactionCategory.personalCare:
        return t.category.personalCare;
      case TransactionCategory.entertainment:
        return t.category.entertainment;
      case TransactionCategory.education:
        return t.category.education;
      case TransactionCategory.medicalHealth:
        return t.category.medicalHealth;
      case TransactionCategory.insurance:
        return t.category.insurance;
      case TransactionCategory.socialGifting:
        return t.category.socialGifting;
      case TransactionCategory.financialTax:
        return t.category.financialTax;
      case TransactionCategory.others:
        return t.category.others;

      case TransactionCategory.salaryWage:
        return t.category.salaryWage;
      case TransactionCategory.businessTrade:
        return t.category.businessTrade;
      case TransactionCategory.investmentReturns:
        return t.category.investmentReturns;
      case TransactionCategory.giftBonus:
        return t.category.giftBonus;
      case TransactionCategory.refundRebate:
        return t.category.refundRebate;

      case TransactionCategory.generalTransfer:
        return t.category.generalTransfer;
      case TransactionCategory.debtRepayment:
        return t.category.debtRepayment;

      case TransactionCategory.incomeLegacy:
        return t.category.incomeCategory;
    }
  }

  /// Get all categories
  static List<TransactionCategory> get allCategories => values.toList();

  /// Get only expense categories
  static List<TransactionCategory> get expenseCategories => [
    foodDining,
    shoppingRetail,
    transportation,
    housingUtilities,
    personalCare,
    entertainment,
    education,
    medicalHealth,
    insurance,
    socialGifting,
    financialTax,
    others,
  ];

  /// Get only income categories
  static List<TransactionCategory> get incomeCategories => [
    salaryWage,
    businessTrade,
    investmentReturns,
    giftBonus,
    refundRebate,
  ];

  /// Get only transfer categories
  static List<TransactionCategory> get transferCategories => [
    generalTransfer,
    debtRepayment,
  ];

  /// Get enum from key, case insensitive. Returns 'others' as fallback.
  static TransactionCategory fromKey(String? key) {
    if (key == null || key.isEmpty) return others;
    try {
      return values.firstWhere((e) => e.key == key.toUpperCase());
    } catch (_) {
      return others;
    }
  }

  /// Retrieves a dynamic color based on the current theme (Recommended).
  ///
  /// Derives variants from the theme's primary color based on the category index.
  /// This ensures visual consistency across light/dark modes and custom themes.
  ///
  /// Usage:
  /// ```dart
  /// final color = category.themedColor(context.theme);
  /// ```
  Color themedColor(FThemeData theme) {
    // Opacity gradient (sufficient to distinguish different categories)
    const opacities = [1.0, 0.85, 0.7, 0.55, 0.4, 0.25];
    final index = TransactionCategory.values.indexOf(this);
    final opacity = opacities[index % opacities.length];
    return theme.colors.primary.withValues(alpha: opacity);
  }
}
