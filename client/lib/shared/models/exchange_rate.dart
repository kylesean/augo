import 'package:freezed_annotation/freezed_annotation.dart';

part 'exchange_rate.freezed.dart';
part 'exchange_rate.g.dart';

@freezed
abstract class ExchangeRateResponse with _$ExchangeRateResponse {
  const factory ExchangeRateResponse({
    @JsonKey(name: 'base_code') required String baseCode,
    @JsonKey(name: 'last_update_utc') String? lastUpdateUtc,
    @JsonKey(name: 'conversion_rates')
    required Map<String, double> conversionRates,
  }) = _ExchangeRateResponse;

  factory ExchangeRateResponse.fromJson(Map<String, dynamic> json) =>
      _$ExchangeRateResponseFromJson(json);
}
