import 'package:freezed_annotation/freezed_annotation.dart';
import 'chat_message.dart';

part 'paginated_messages.freezed.dart';
part 'paginated_messages.g.dart';

@freezed
abstract class PaginatedMessages with _$PaginatedMessages {
  const factory PaginatedMessages({
    required List<ChatMessage> data,
    required Meta meta,
  }) = _PaginatedMessages;

  factory PaginatedMessages.fromJson(Map<String, dynamic> json) =>
      _$PaginatedMessagesFromJson(json);
}

@freezed
abstract class Meta with _$Meta {
  // Use snake_case for automatic mapping
  const factory Meta({
    required int currentPage,
    required int perPage,
    required int lastPage,
    required int total,
    required bool hasMore,
  }) = _Meta;

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);
}
