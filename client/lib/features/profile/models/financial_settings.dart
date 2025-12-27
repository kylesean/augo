// features/profile/models/financial_settings.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:decimal/decimal.dart';

part 'financial_settings.freezed.dart';
part 'financial_settings.g.dart';

/// Financial settings request model
@freezed
abstract class FinancialSettingsRequest with _$FinancialSettingsRequest {
  const factory FinancialSettingsRequest({
    @JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonNullable)
    Decimal? safetyThreshold,
    @JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonNullable)
    Decimal? dailyBurnRate,
    String? burnRateMode,
    String? primaryCurrency,
    int? monthStartDay,
  }) = _FinancialSettingsRequest;

  factory FinancialSettingsRequest.fromJson(Map<String, dynamic> json) =>
      _$FinancialSettingsRequestFromJson(json);
}

/// Financial settings response model
@freezed
abstract class FinancialSettingsResponse with _$FinancialSettingsResponse {
  const factory FinancialSettingsResponse({
    @JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson)
    required Decimal safetyThreshold,
    @JsonKey(fromJson: _decimalFromJson, toJson: _decimalToJson)
    required Decimal dailyBurnRate,
    required String burnRateMode,
    required String primaryCurrency,
    required int monthStartDay,
    String? updatedAt,
  }) = _FinancialSettingsResponse;

  factory FinancialSettingsResponse.fromJson(Map<String, dynamic> json) =>
      _$FinancialSettingsResponseFromJson(json);
}

/// Financial settings state model
@freezed
abstract class FinancialSettingsState with _$FinancialSettingsState {
  const factory FinancialSettingsState({
    @JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonNullable)
    Decimal? safetyThreshold,
    @JsonKey(fromJson: _decimalFromJsonNullable, toJson: _decimalToJsonNullable)
    Decimal? dailyBurnRate,
    @Default("AI_AUTO") String burnRateMode,
    @Default("USD") String primaryCurrency,
    @Default(1) int monthStartDay,
    String? lastUpdatedAt,
    @Default(false) bool isLoading,
    @Default(false) bool hasChanges,
    String? error,
  }) = _FinancialSettingsState;

  const FinancialSettingsState._();

  /// Get effective safety threshold (with default value)
  Decimal get effectiveSafetyThreshold {
    return safetyThreshold ?? Decimal.fromInt(1000);
  }

  /// Get effective daily burn rate (with default value)
  Decimal get effectiveDailyBurnRate {
    return dailyBurnRate ?? Decimal.fromInt(100);
  }

  /// Get persona description
  String get personalityDescription {
    final amount = effectiveSafetyThreshold.toDouble();
    if (amount <= 500) {
      return 'Casual type: I believe things will work out on their own.';
    } else if (amount <= 2000) {
      return 'Steady type: I like to keep a margin for life.';
    } else if (amount <= 5000) {
      return 'Cautious type: Ample reserves give me absolute peace of mind.';
    } else {
      return 'Control type: Everything is under my absolute control.';
    }
  }

  /// Get persona type (for UI styling)
  PersonalityType get personalityType {
    final amount = effectiveSafetyThreshold.toDouble();
    if (amount <= 500) {
      return PersonalityType.casual;
    } else if (amount <= 2000) {
      return PersonalityType.steady;
    } else if (amount <= 5000) {
      return PersonalityType.cautious;
    } else {
      return PersonalityType.control;
    }
  }
}

/// Persona type enum
enum PersonalityType {
  casual, // Casual type
  steady, // Steady type
  cautious, // Cautious type
  control, // Control type
}

/// Persona type extension
extension PersonalityTypeExtension on PersonalityType {
  String get displayName {
    switch (this) {
      case PersonalityType.casual:
        return 'Casual';
      case PersonalityType.steady:
        return 'Steady';
      case PersonalityType.cautious:
        return 'Cautious';
      case PersonalityType.control:
        return 'Control';
    }
  }

  String get description {
    switch (this) {
      case PersonalityType.casual:
        return 'I believe things will work out on their own.';
      case PersonalityType.steady:
        return 'I like to keep a margin for life.';
      case PersonalityType.cautious:
        return 'Ample reserves give me absolute peace of mind.';
      case PersonalityType.control:
        return 'Everything is under my absolute control.';
    }
  }
}

// Helper functions: Decimal serialization/deserialization
Decimal _decimalFromJson(dynamic value) {
  if (value is String) {
    return Decimal.parse(value);
  } else if (value is num) {
    return Decimal.parse(value.toString());
  }
  throw ArgumentError('Cannot convert $value to Decimal');
}

Decimal? _decimalFromJsonNullable(dynamic value) {
  if (value == null) return null;
  return _decimalFromJson(value);
}

String _decimalToJson(Decimal value) => value.toString();

String? _decimalToJsonNullable(Decimal? value) => value?.toString();
