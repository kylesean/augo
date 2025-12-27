// features/chat/providers/chat_history_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'chat_message.dart';

part 'chat_history_state.freezed.dart';

@freezed
abstract class ChatHistoryState with _$ChatHistoryState {
  const factory ChatHistoryState({
    String? currentConversationId,
    String? currentConversationTitle,
    @Default(false) bool isLoadingHistory,
    @Default([]) List<ChatMessage> messages,
    String? historyError,
    @Default(1) int historyCurrentPage, // Current loaded history message page
    @Default(true)
    bool historyHasMore, // Whether there are more history messages to load
    @Default(false)
    bool isStreamingResponse, // Whether AI is currently streaming response
  }) = _ChatHistoryState;
}
