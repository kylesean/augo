// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FinancialSettingsRequest _$FinancialSettingsRequestFromJson(
  Map<String, dynamic> json,
) => _FinancialSettingsRequest(
  safetyThreshold: _decimalFromJsonNullable(json['safetyThreshold']),
  dailyBurnRate: _decimalFromJsonNullable(json['dailyBurnRate']),
  burnRateMode: json['burnRateMode'] as String?,
  primaryCurrency: json['primaryCurrency'] as String?,
  monthStartDay: (json['monthStartDay'] as num?)?.toInt(),
);

Map<String, dynamic> _$FinancialSettingsRequestToJson(
  _FinancialSettingsRequest instance,
) => <String, dynamic>{
  'safetyThreshold': _decimalToJsonNullable(instance.safetyThreshold),
  'dailyBurnRate': _decimalToJsonNullable(instance.dailyBurnRate),
  'burnRateMode': instance.burnRateMode,
  'primaryCurrency': instance.primaryCurrency,
  'monthStartDay': instance.monthStartDay,
};

_FinancialSettingsResponse _$FinancialSettingsResponseFromJson(
  Map<String, dynamic> json,
) => _FinancialSettingsResponse(
  safetyThreshold: _decimalFromJson(json['safetyThreshold']),
  dailyBurnRate: _decimalFromJson(json['dailyBurnRate']),
  burnRateMode: json['burnRateMode'] as String,
  primaryCurrency: json['primaryCurrency'] as String,
  monthStartDay: (json['monthStartDay'] as num).toInt(),
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$FinancialSettingsResponseToJson(
  _FinancialSettingsResponse instance,
) => <String, dynamic>{
  'safetyThreshold': _decimalToJson(instance.safetyThreshold),
  'dailyBurnRate': _decimalToJson(instance.dailyBurnRate),
  'burnRateMode': instance.burnRateMode,
  'primaryCurrency': instance.primaryCurrency,
  'monthStartDay': instance.monthStartDay,
  'updatedAt': instance.updatedAt,
};
