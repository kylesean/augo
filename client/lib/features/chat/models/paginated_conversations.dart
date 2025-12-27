// features/chat/models/paginated_conversations.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'conversation_info.dart';

part 'paginated_conversations.freezed.dart';
part 'paginated_conversations.g.dart';

/// Pagination metadata
@freezed
abstract class ConversationMeta with _$ConversationMeta {
  const factory ConversationMeta({
    required int currentPage,
    required int lastPage,
    required int perPage,
    required int total,
    required bool hasMore,
  }) = _ConversationMeta;

  factory ConversationMeta.fromJson(Map<String, dynamic> json) =>
      _$ConversationMetaFromJson(json);
}

/// Paginated conversations list response
@freezed
abstract class PaginatedConversations with _$PaginatedConversations {
  const factory PaginatedConversations({
    required List<ConversationInfo> data,
    required ConversationMeta meta,
  }) = _PaginatedConversations;

  factory PaginatedConversations.fromJson(Map<String, dynamic> json) =>
      _$PaginatedConversationsFromJson(json);
}
