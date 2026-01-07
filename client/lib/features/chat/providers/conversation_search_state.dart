// features/chat/providers/conversation_search_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation_search_state.freezed.dart';

/// Search mode enumeration
enum SearchMode {
  /// Normal mode - Display conversation list and categories
  normal,

  /// Search mode - Display search interface (within drawer)
  search,

  /// Fullscreen search mode - Display search interface in fullscreen
  fullscreenSearch,
}

/// Conversation search result item
@freezed
abstract class ConversationSearchResult with _$ConversationSearchResult {
  const factory ConversationSearchResult({
    required String id,
    required String title,
    required String snippet, // Search matched content snippet
    String? messageId, // Message ID
    DateTime? createdAt, // Creation time
    DateTime? updatedAt, // Update time
    @Default([]) List<HighlightRange> highlights, // Highlight ranges
  }) = _ConversationSearchResult;
}

/// Highlight range
@freezed
abstract class HighlightRange with _$HighlightRange {
  const factory HighlightRange({
    required int start,
    required int end,
    required String field, // 'title' or 'snippet'
  }) = _HighlightRange;
}

/// Conversation search state
@freezed
abstract class ConversationSearchState with _$ConversationSearchState {
  const factory ConversationSearchState({
    @Default(SearchMode.normal) SearchMode mode,
    @Default('') String query,
    @Default([]) List<ConversationSearchResult> results,
    @Default(false) bool isLoading,
    String? error,
    @Default(false) bool hasSearched, // Whether a search has been performed
    @Default(false) bool isFullscreen, // Whether in fullscreen mode
  }) = _ConversationSearchState;
}
