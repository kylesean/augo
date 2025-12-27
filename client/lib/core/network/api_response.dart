import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_response.freezed.dart';
part 'api_response.g.dart';

@Freezed(
  genericArgumentFactories: true,
) // Enable generic serialization/deserialization
abstract class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse({
    @JsonKey(name: 'code') required int code,
    @JsonKey(name: 'message') required String message,
    @JsonKey(name: 'data') T? data, // data field can be null
  }) = _ApiResponse<T>;

  // Add a private constructor to allow instance methods
  const ApiResponse._();

  /// Deserialize from JSON, requires a function to deserialize generic T
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$ApiResponseFromJson(json, fromJsonT);

  /// Helper getter to determine if business logic was successful
  bool get isSuccess => code == 0;
}
