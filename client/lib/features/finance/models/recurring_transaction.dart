import 'package:decimal/decimal.dart';

/// 周期交易类型
enum RecurringTransactionType {
  expense('EXPENSE', '支出'),
  income('INCOME', '收入'),
  transfer('TRANSFER', '转账');

  const RecurringTransactionType(this.value, this.label);
  final String value;
  final String label;

  static RecurringTransactionType fromValue(String value) {
    return RecurringTransactionType.values.firstWhere(
      (type) => type.value == value.toUpperCase(),
      orElse: () => RecurringTransactionType.expense,
    );
  }
}

/// 金额类型
enum AmountType {
  fixed('FIXED', '固定金额'),
  estimate('ESTIMATE', '动态预估');

  const AmountType(this.value, this.label);
  final String value;
  final String label;

  static AmountType fromValue(String value) {
    return AmountType.values.firstWhere(
      (type) => type.value == value.toUpperCase(),
      orElse: () => AmountType.fixed,
    );
  }
}

/// 周期交易模型
class RecurringTransaction {
  final String id;
  final String userUuid;
  final RecurringTransactionType type;
  final String? sourceAccountId;
  final String? targetAccountId;
  final AmountType amountType;
  final bool requiresConfirmation;
  final Decimal amount;
  final String currency;
  final String? categoryKey;
  final List<String>? tags;
  final String recurrenceRule;
  final String timezone;
  final DateTime startDate;
  final DateTime? endDate;
  final List<String>? exceptionDates;
  final DateTime? lastGeneratedAt;
  final DateTime? nextExecutionAt;
  final String? description;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RecurringTransaction({
    required this.id,
    required this.userUuid,
    required this.type,
    this.sourceAccountId,
    this.targetAccountId,
    required this.amountType,
    required this.requiresConfirmation,
    required this.amount,
    required this.currency,
    this.categoryKey,
    this.tags,
    required this.recurrenceRule,
    required this.timezone,
    required this.startDate,
    this.endDate,
    this.exceptionDates,
    this.lastGeneratedAt,
    this.nextExecutionAt,
    this.description,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RecurringTransaction.fromJson(Map<String, dynamic> json) {
    return RecurringTransaction(
      id: json['id'] as String,
      userUuid: json['user_uuid'] as String,
      type: RecurringTransactionType.fromValue(json['type'] as String),
      sourceAccountId: json['source_account_id'] as String?,
      targetAccountId: json['target_account_id'] as String?,
      amountType: AmountType.fromValue(json['amount_type'] as String),
      requiresConfirmation: json['requires_confirmation'] as bool,
      amount: Decimal.parse(json['amount'] as String),
      currency: json['currency'] as String,
      categoryKey: json['category_key'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>(),
      recurrenceRule: json['recurrence_rule'] as String,
      timezone: json['timezone'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'] as String)
          : null,
      exceptionDates: (json['exception_dates'] as List<dynamic>?)
          ?.cast<String>(),
      lastGeneratedAt: json['last_generated_at'] != null
          ? DateTime.parse(json['last_generated_at'] as String)
          : null,
      nextExecutionAt: json['next_execution_at'] != null
          ? DateTime.parse(json['next_execution_at'] as String)
          : null,
      description: json['description'] as String?,
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_uuid': userUuid,
      'type': type.value,
      'source_account_id': sourceAccountId,
      'target_account_id': targetAccountId,
      'amount_type': amountType.value,
      'requires_confirmation': requiresConfirmation,
      'amount': amount.toString(),
      'currency': currency,
      'category_key': categoryKey,
      'tags': tags,
      'recurrence_rule': recurrenceRule,
      'timezone': timezone,
      'start_date': startDate.toIso8601String().split('T').first,
      'end_date': endDate?.toIso8601String().split('T').first,
      'exception_dates': exceptionDates,
      'description': description,
      'is_active': isActive,
    };
  }

  /// 创建副本并修改指定字段（用于乐观更新）
  RecurringTransaction copyWith({
    String? id,
    String? userUuid,
    RecurringTransactionType? type,
    String? sourceAccountId,
    String? targetAccountId,
    AmountType? amountType,
    bool? requiresConfirmation,
    Decimal? amount,
    String? currency,
    String? categoryKey,
    List<String>? tags,
    String? recurrenceRule,
    String? timezone,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? exceptionDates,
    DateTime? lastGeneratedAt,
    DateTime? nextExecutionAt,
    String? description,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RecurringTransaction(
      id: id ?? this.id,
      userUuid: userUuid ?? this.userUuid,
      type: type ?? this.type,
      sourceAccountId: sourceAccountId ?? this.sourceAccountId,
      targetAccountId: targetAccountId ?? this.targetAccountId,
      amountType: amountType ?? this.amountType,
      requiresConfirmation: requiresConfirmation ?? this.requiresConfirmation,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      categoryKey: categoryKey ?? this.categoryKey,
      tags: tags ?? this.tags,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      timezone: timezone ?? this.timezone,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      exceptionDates: exceptionDates ?? this.exceptionDates,
      lastGeneratedAt: lastGeneratedAt ?? this.lastGeneratedAt,
      nextExecutionAt: nextExecutionAt ?? this.nextExecutionAt,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// 创建周期交易请求
class RecurringTransactionCreateRequest {
  final RecurringTransactionType type;
  final Decimal amount;
  final String recurrenceRule;
  final DateTime startDate;
  final String? sourceAccountId;
  final String? targetAccountId;
  final AmountType amountType;
  final bool requiresConfirmation;
  final String currency;
  final String? categoryKey;
  final List<String>? tags;
  final String timezone;
  final DateTime? endDate;
  final String? description;
  final bool isActive;

  const RecurringTransactionCreateRequest({
    required this.type,
    required this.amount,
    required this.recurrenceRule,
    required this.startDate,
    this.sourceAccountId,
    this.targetAccountId,
    this.amountType = AmountType.fixed,
    this.requiresConfirmation = false,
    this.currency = 'CNY',
    this.categoryKey,
    this.tags,
    this.timezone = 'Asia/Shanghai',
    this.endDate,
    this.description,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      'amount': amount.toString(),
      'recurrence_rule': recurrenceRule,
      'start_date': startDate.toIso8601String().split('T').first,
      'source_account_id': sourceAccountId,
      'target_account_id': targetAccountId,
      'amount_type': amountType.value,
      'requires_confirmation': requiresConfirmation,
      'currency': currency,
      'category_key': categoryKey,
      'tags': tags,
      'timezone': timezone,
      'end_date': endDate?.toIso8601String().split('T').first,
      'description': description,
      'is_active': isActive,
    };
  }
}

/// 更新周期交易请求
class RecurringTransactionUpdateRequest {
  final RecurringTransactionType? type;
  final Decimal? amount;
  final String? recurrenceRule;
  final DateTime? startDate;
  final String? sourceAccountId;
  final String? targetAccountId;
  final AmountType? amountType;
  final bool? requiresConfirmation;
  final String? currency;
  final String? categoryKey;
  final List<String>? tags;
  final String? timezone;
  final DateTime? endDate;
  final String? description;
  final bool? isActive;

  const RecurringTransactionUpdateRequest({
    this.type,
    this.amount,
    this.recurrenceRule,
    this.startDate,
    this.sourceAccountId,
    this.targetAccountId,
    this.amountType,
    this.requiresConfirmation,
    this.currency,
    this.categoryKey,
    this.tags,
    this.timezone,
    this.endDate,
    this.description,
    this.isActive,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (type != null) json['type'] = type!.value;
    if (amount != null) json['amount'] = amount.toString();
    if (recurrenceRule != null) json['recurrence_rule'] = recurrenceRule;
    if (startDate != null) {
      json['start_date'] = startDate!.toIso8601String().split('T').first;
    }
    if (sourceAccountId != null) json['source_account_id'] = sourceAccountId;
    if (targetAccountId != null) json['target_account_id'] = targetAccountId;
    if (amountType != null) json['amount_type'] = amountType!.value;
    if (requiresConfirmation != null) {
      json['requires_confirmation'] = requiresConfirmation;
    }
    if (currency != null) json['currency'] = currency;
    if (categoryKey != null) json['category_key'] = categoryKey;
    if (tags != null) json['tags'] = tags;
    if (timezone != null) json['timezone'] = timezone;
    if (endDate != null) {
      json['end_date'] = endDate!.toIso8601String().split('T').first;
    }
    if (description != null) json['description'] = description;
    if (isActive != null) json['is_active'] = isActive;
    return json;
  }
}
