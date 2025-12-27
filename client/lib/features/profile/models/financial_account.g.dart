// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccountDisplay _$AccountDisplayFromJson(Map<String, dynamic> json) =>
    _AccountDisplay(
      sign: json['sign'] as String,
      value: json['value'] as String,
      valueFormatted: json['valueFormatted'] as String,
      currencySymbol: json['currencySymbol'] as String,
      fullString: json['fullString'] as String,
    );

Map<String, dynamic> _$AccountDisplayToJson(_AccountDisplay instance) =>
    <String, dynamic>{
      'sign': instance.sign,
      'value': instance.value,
      'valueFormatted': instance.valueFormatted,
      'currencySymbol': instance.currencySymbol,
      'fullString': instance.fullString,
    };

_FinancialAccount _$FinancialAccountFromJson(Map<String, dynamic> json) =>
    _FinancialAccount(
      id: json['id'] as String?,
      name: json['name'] as String,
      nature: $enumDecode(_$FinancialNatureEnumMap, json['nature']),
      type: $enumDecodeNullable(_$FinancialAccountTypeEnumMap, json['type']),
      currencyCode: json['currencyCode'] as String? ?? 'CNY',
      initialBalance: _decimalFromJson(json['initialBalance']),
      currentBalance: _decimalFromJsonNullable(json['currentBalance']),
      includeInNetWorth: json['includeInNetWorth'] as bool? ?? true,
      includeInCashFlow: json['includeInCashFlow'] as bool? ?? false,
      display: json['display'] == null
          ? null
          : AccountDisplay.fromJson(json['display'] as Map<String, dynamic>),
      status:
          $enumDecodeNullable(_$AccountStatusEnumMap, json['status']) ??
          AccountStatus.active,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$FinancialAccountToJson(_FinancialAccount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nature': _$FinancialNatureEnumMap[instance.nature]!,
      'type': _$FinancialAccountTypeEnumMap[instance.type],
      'currencyCode': instance.currencyCode,
      'initialBalance': _decimalToJson(instance.initialBalance),
      'currentBalance': _decimalToJsonOrZero(instance.currentBalance),
      'includeInNetWorth': instance.includeInNetWorth,
      'includeInCashFlow': instance.includeInCashFlow,
      'display': instance.display,
      'status': _$AccountStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

const _$FinancialNatureEnumMap = {
  FinancialNature.asset: 'ASSET',
  FinancialNature.liability: 'LIABILITY',
};

const _$FinancialAccountTypeEnumMap = {
  FinancialAccountType.cash: 'CASH',
  FinancialAccountType.deposit: 'DEPOSIT',
  FinancialAccountType.eMoney: 'E_MONEY',
  FinancialAccountType.investment: 'INVESTMENT',
  FinancialAccountType.receivable: 'RECEIVABLE',
  FinancialAccountType.creditCard: 'CREDIT_CARD',
  FinancialAccountType.loan: 'LOAN',
  FinancialAccountType.payable: 'PAYABLE',
};

const _$AccountStatusEnumMap = {
  AccountStatus.active: 'ACTIVE',
  AccountStatus.inactive: 'INACTIVE',
  AccountStatus.closed: 'CLOSED',
};

_FinancialAccountSummary _$FinancialAccountSummaryFromJson(
  Map<String, dynamic> json,
) => _FinancialAccountSummary(
  totalBalance: _decimalFromJson(json['totalBalance']),
  lastUpdatedAt: DateTime.parse(json['lastUpdatedAt'] as String),
);

Map<String, dynamic> _$FinancialAccountSummaryToJson(
  _FinancialAccountSummary instance,
) => <String, dynamic>{
  'totalBalance': _decimalToJson(instance.totalBalance),
  'lastUpdatedAt': instance.lastUpdatedAt.toIso8601String(),
};

_FinancialAccountResponse _$FinancialAccountResponseFromJson(
  Map<String, dynamic> json,
) => _FinancialAccountResponse(
  accounts:
      (json['accounts'] as List<dynamic>?)
          ?.map((e) => FinancialAccount.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  totalBalance: _decimalFromJsonNullable(json['totalBalance']),
  lastUpdatedAt: json['lastUpdatedAt'] as String? ?? '',
);

Map<String, dynamic> _$FinancialAccountResponseToJson(
  _FinancialAccountResponse instance,
) => <String, dynamic>{
  'accounts': instance.accounts,
  'totalBalance': _decimalToJson(instance.totalBalance),
  'lastUpdatedAt': instance.lastUpdatedAt,
};

_FinancialAccountRequest _$FinancialAccountRequestFromJson(
  Map<String, dynamic> json,
) => _FinancialAccountRequest(
  accounts: (json['accounts'] as List<dynamic>)
      .map((e) => FinancialAccount.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$FinancialAccountRequestToJson(
  _FinancialAccountRequest instance,
) => <String, dynamic>{
  'accounts': instance.accounts.map((e) => e.toJson()).toList(),
};
