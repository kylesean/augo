import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation_info.freezed.dart';
part 'conversation_info.g.dart';

@freezed
abstract class ConversationInfo with _$ConversationInfo {
  @JsonSerializable(explicitToJson: true)
  const factory ConversationInfo({
    required String id,
    required String title,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? token, // Add token field for storing session token
  }) = _ConversationInfo;

  factory ConversationInfo.fromJson(Map<String, dynamic> json) =>
      _$ConversationInfoFromJson(json);
}
