import 'package:freezed_annotation/freezed_annotation.dart';
import 'chat_message.dart'; // Import ChatMessage model

part 'conversation_detail.freezed.dart';

part 'conversation_detail.g.dart';

@freezed
abstract class ConversationDetail with _$ConversationDetail {
  const factory ConversationDetail({
    required String id,
    required String title,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson) required DateTime updatedAt,
    // Directly include message list, no longer using pagination structure
    @Default([]) List<ChatMessage> messages,
  }) = _ConversationDetail;

  factory ConversationDetail.fromJson(Map<String, dynamic> json) => _$ConversationDetailFromJson(json);
}

// Custom deserializer for DateTime
DateTime _dateTimeFromJson(dynamic json) {
  if (json == null) {
    return DateTime.now(); // Provide a default if null
  }
  if (json is String) {
    return DateTime.parse(json);
  }
  throw FormatException('Invalid DateTime format: $json');
}

// Custom serializer for DateTime
String _dateTimeToJson(DateTime dateTime) => dateTime.toIso8601String();
