import 'package:decimal/decimal.dart';
import '../../../core/constants/category_constants.dart';
import 'package:augo/i18n/strings.g.dart';

enum BudgetScope {
  total('TOTAL'),
  category('CATEGORY');

  const BudgetScope(this.value);
  final String value;

  static BudgetScope fromString(String value) {
    return BudgetScope.values.firstWhere(
      (e) => e.value == value.toUpperCase(),
      orElse: () => BudgetScope.total,
    );
  }
}

enum BudgetPeriodType {
  weekly('WEEKLY'),
  biweekly('BIWEEKLY'),
  monthly('MONTHLY'),
  yearly('YEARLY');

  const BudgetPeriodType(this.value);
  final String value;

  String get label => switch (this) {
    BudgetPeriodType.weekly => t.budget.periodWeekly,
    BudgetPeriodType.biweekly => t.budget.periodBiweekly,
    BudgetPeriodType.monthly => t.budget.periodMonthly,
    BudgetPeriodType.yearly => t.budget.periodYearly,
  };

  static BudgetPeriodType fromString(String value) {
    return BudgetPeriodType.values.firstWhere(
      (e) => e.value == value.toUpperCase(),
      orElse: () => BudgetPeriodType.monthly,
    );
  }
}

enum BudgetStatus {
  active('ACTIVE'),
  paused('PAUSED'),
  archived('ARCHIVED');

  const BudgetStatus(this.value);
  final String value;

  String get label => switch (this) {
    BudgetStatus.active => t.budget.statusActive,
    BudgetStatus.paused => t.budget.paused,
    BudgetStatus.archived => t.budget.statusArchived,
  };

  static BudgetStatus fromString(String value) {
    return BudgetStatus.values.firstWhere(
      (e) => e.value == value.toUpperCase(),
      orElse: () => BudgetStatus.active,
    );
  }
}

enum BudgetPeriodStatus {
  onTrack('ON_TRACK'),
  warning('WARNING'),
  exceeded('EXCEEDED'),
  achieved('ACHIEVED');

  const BudgetPeriodStatus(this.value);
  final String value;

  String get label => switch (this) {
    BudgetPeriodStatus.onTrack => t.budget.periodStatusOnTrack,
    BudgetPeriodStatus.warning => t.budget.periodStatusWarning,
    BudgetPeriodStatus.exceeded => t.budget.periodStatusExceeded,
    BudgetPeriodStatus.achieved => t.budget.periodStatusAchieved,
  };

  static BudgetPeriodStatus fromString(String value) {
    return BudgetPeriodStatus.values.firstWhere(
      (e) => e.value == value.toUpperCase(),
      orElse: () => BudgetPeriodStatus.onTrack,
    );
  }
}

class Budget {
  final String id;
  final String name;
  final BudgetScope scope;
  final String? categoryKey;
  final Decimal amount;
  final String currencyCode;
  final BudgetPeriodType periodType;
  final BudgetStatus status;
  final bool rolloverEnabled;
  final Decimal rolloverBalance;
  final DateTime createdAt;
  final DateTime updatedAt;

  Budget({
    required this.id,
    required this.name,
    required this.scope,
    this.categoryKey,
    required this.amount,
    required this.currencyCode,
    required this.periodType,
    required this.status,
    required this.rolloverEnabled,
    required this.rolloverBalance,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Budget.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(String? dateStr) {
      if (dateStr == null || dateStr.isEmpty) {
        return DateTime.now();
      }
      return DateTime.parse(dateStr);
    }

    return Budget(
      id: json['id'] as String,
      name: json['name'] as String,
      scope: BudgetScope.fromString(json['scope'] as String),
      categoryKey: json['category_key'] as String?,
      amount: Decimal.parse(json['amount'].toString()),
      currencyCode: json['currency_code'] as String? ?? 'CNY',
      periodType: BudgetPeriodType.fromString(json['period_type'] as String),
      status: BudgetStatus.fromString(json['status'] as String),
      rolloverEnabled: json['rollover_enabled'] as bool? ?? true,
      rolloverBalance: Decimal.parse(
        (json['rollover_balance'] ?? '0').toString(),
      ),
      createdAt: parseDate(json['created_at'] as String?),
      updatedAt: parseDate(json['updated_at'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'scope': scope.value,
      'category_key': categoryKey,
      'amount': amount.toString(),
      'currency_code': currencyCode,
      'period_type': periodType.value,
      'status': status.value,
      'rollover_enabled': rolloverEnabled,
      'rollover_balance': rolloverBalance.toString(),
    };
  }

  bool get isTotalBudget => scope == BudgetScope.total;

  bool get isCategoryBudget => scope == BudgetScope.category;

  String get displayName {
    if (categoryKey != null) {
      final category = TransactionCategory.fromKey(categoryKey);
      if (name.contains(categoryKey!)) {
        return name.replaceAll(categoryKey!, category.displayText);
      }
    }

    final category = TransactionCategory.fromKey(name);
    if (category.key == name.toUpperCase()) {
      return category.displayText;
    }
    return name;
  }
}

class BudgetPeriodDetail {
  final String id;
  final String budgetId;
  final DateTime periodStart;
  final DateTime periodEnd;
  final Decimal spentAmount;
  final Decimal adjustedTarget;
  final BudgetPeriodStatus status;
  final double usagePercentage;

  BudgetPeriodDetail({
    required this.id,
    required this.budgetId,
    required this.periodStart,
    required this.periodEnd,
    required this.spentAmount,
    required this.adjustedTarget,
    required this.status,
    required this.usagePercentage,
  });

  factory BudgetPeriodDetail.fromJson(Map<String, dynamic> json) {
    return BudgetPeriodDetail(
      id: json['id'] as String,
      budgetId: json['budget_id'] as String,
      periodStart: DateTime.parse(json['period_start'] as String),
      periodEnd: DateTime.parse(json['period_end'] as String),
      spentAmount: Decimal.parse(json['spent_amount'].toString()),
      adjustedTarget: Decimal.parse(json['adjusted_target'].toString()),
      status: BudgetPeriodStatus.fromString(json['status'] as String),
      usagePercentage: (json['usage_percentage'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Decimal get remainingAmount => adjustedTarget - spentAmount;

  bool get isExceeded => status == BudgetPeriodStatus.exceeded;
}

class BudgetWithUsage {
  final Budget budget;
  final BudgetPeriodDetail? currentPeriod;
  final Decimal spentAmount;
  final Decimal remainingAmount;
  final double usagePercentage;
  final BudgetPeriodStatus periodStatus;

  BudgetWithUsage({
    required this.budget,
    this.currentPeriod,
    required this.spentAmount,
    required this.remainingAmount,
    required this.usagePercentage,
    required this.periodStatus,
  });

  factory BudgetWithUsage.fromJson(Map<String, dynamic> json) {
    return BudgetWithUsage(
      budget: Budget.fromJson(json['budget'] as Map<String, dynamic>),
      currentPeriod: json['current_period'] != null
          ? BudgetPeriodDetail.fromJson(
              json['current_period'] as Map<String, dynamic>,
            )
          : null,
      spentAmount: Decimal.parse(json['spent_amount'].toString()),
      remainingAmount: Decimal.parse(json['remaining_amount'].toString()),
      usagePercentage: (json['usage_percentage'] as num?)?.toDouble() ?? 0.0,
      periodStatus: BudgetPeriodStatus.fromString(
        json['period_status'] as String? ?? 'ON_TRACK',
      ),
    );
  }

  /// Creates a BudgetWithUsage from a flat backend BudgetResponse.
  factory BudgetWithUsage.fromBudgetResponse(Map<String, dynamic> json) {
    return BudgetWithUsage(
      budget: Budget.fromJson(json), // BudgetResponse 直接解析为 Budget
      currentPeriod: null, // BudgetResponse 不包含独立的 period 对象
      spentAmount: Decimal.parse((json['spent_amount'] ?? 0).toString()),
      remainingAmount: Decimal.parse(
        (json['remaining_amount'] ?? 0).toString(),
      ),
      usagePercentage: (json['usage_percentage'] as num?)?.toDouble() ?? 0.0,
      periodStatus: BudgetPeriodStatus.fromString(
        json['period_status'] as String? ?? 'ON_TRACK',
      ),
    );
  }
}

/// Budget summary data.
class BudgetSummary {
  final Decimal totalBudget;
  final Decimal totalSpent;
  final Decimal totalRemaining;
  final double overallUsagePercentage;
  final List<BudgetWithUsage> budgets;
  final BudgetWithUsage? totalBudgetDetail;

  BudgetSummary({
    required this.totalBudget,
    required this.totalSpent,
    required this.totalRemaining,
    required this.overallUsagePercentage,
    required this.budgets,
    this.totalBudgetDetail,
  });

  factory BudgetSummary.fromJson(Map<String, dynamic> json) {
    // backend response fields:
    // - total_budget: BudgetResponse (spent_amount, remaining_amount, usage_percentage, period_status)
    // - category_budgets: List[BudgetResponse]
    // - overall_spent, overall_remaining, overall_percentage

    BudgetWithUsage? totalBudgetDetail;
    if (json['total_budget'] != null) {
      totalBudgetDetail = BudgetWithUsage.fromBudgetResponse(
        json['total_budget'] as Map<String, dynamic>,
      );
    }

    // parse category budgets
    final categoryBudgets = <BudgetWithUsage>[];
    if (json['category_budgets'] != null) {
      for (final item in (json['category_budgets'] as List<dynamic>)) {
        categoryBudgets.add(
          BudgetWithUsage.fromBudgetResponse(item as Map<String, dynamic>),
        );
      }
    }

    // calculate total amount
    final overallSpent = json['overall_spent'] as num? ?? 0.0;
    final overallRemaining = json['overall_remaining'] as num? ?? 0.0;
    final totalAmount = overallSpent + overallRemaining;

    return BudgetSummary(
      totalBudget: Decimal.parse(totalAmount.toString()),
      totalSpent: Decimal.parse(overallSpent.toString()),
      totalRemaining: Decimal.parse(overallRemaining.toString()),
      overallUsagePercentage:
          (json['overall_percentage'] as num?)?.toDouble() ?? 0.0,
      budgets: categoryBudgets,
      totalBudgetDetail: totalBudgetDetail,
    );
  }

  bool get hasBudgets => budgets.isNotEmpty || totalBudgetDetail != null;

  List<BudgetWithUsage> get categoryBudgets =>
      budgets.where((b) => b.budget.isCategoryBudget).toList();
}

// ============================================================================
// Request Models
// ============================================================================

class BudgetCreateRequest {
  final BudgetScope scope;
  final String? categoryKey;
  final Decimal amount;
  final BudgetPeriodType periodType;
  final int periodAnchorDay;
  final bool rolloverEnabled;
  final String currencyCode;
  final String? name;

  const BudgetCreateRequest({
    required this.scope,
    this.categoryKey,
    required this.amount,
    this.periodType = BudgetPeriodType.monthly,
    this.periodAnchorDay = 1,
    this.rolloverEnabled = true,
    this.currencyCode = 'CNY',
    this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'scope': scope.value,
      if (categoryKey != null) 'category_key': categoryKey,
      'amount': amount.toString(),
      'period_type': periodType.value,
      'period_anchor_day': periodAnchorDay,
      'rollover_enabled': rolloverEnabled,
      'currency_code': currencyCode,
      if (name != null) 'name': name,
    };
  }
}

class BudgetUpdateRequest {
  final String? name;
  final Decimal? amount;
  final bool? rolloverEnabled;
  final BudgetStatus? status;
  final int? periodAnchorDay;

  const BudgetUpdateRequest({
    this.name,
    this.amount,
    this.rolloverEnabled,
    this.status,
    this.periodAnchorDay,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (name != null) json['name'] = name;
    if (amount != null) json['amount'] = amount.toString();
    if (rolloverEnabled != null) json['rollover_enabled'] = rolloverEnabled;
    if (status != null) json['status'] = status!.value;
    if (periodAnchorDay != null) json['period_anchor_day'] = periodAnchorDay;
    return json;
  }
}
