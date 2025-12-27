import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/conversation_info.dart';
import '../services/conversation_service.dart';

part 'paginated_conversation_provider.freezed.dart';
part 'paginated_conversation_provider.g.dart';

final _logger = Logger('PaginatedConversation');

/// Paginated conversation list state
@freezed
abstract class PaginatedConversationState with _$PaginatedConversationState {
  const factory PaginatedConversationState({
    @Default([]) List<ConversationInfo> conversations,
    @Default(1) int currentPage,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(true) bool hasMore,
    @Default(10) int perPage,
    @Default(0) int total,
    @Default(false)
    bool isInitialized, // Mark whether list has been initialized and loaded
    String? error,
  }) = _PaginatedConversationState;
}

/// Paginated conversation list state management
@riverpod
class PaginatedConversation extends _$PaginatedConversation {
  @override
  PaginatedConversationState build() {
    return const PaginatedConversationState();
  }

  /// Load first page data
  Future<void> loadFirstPage() async {
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true,
      error: null,
      conversations: [],
      currentPage: 1,
    );

    try {
      final service = ref.read(conversationServiceProvider);
      final result = await service.getConversationList(
        page: 1,
        perPage: state.perPage,
      );

      state = state.copyWith(
        conversations: result.data,
        currentPage: result.meta.currentPage,
        hasMore: result.meta.hasMore,
        total: result.meta.total,
        isLoading: false,
        isInitialized: true,
      );

      _logger.info(
        'PaginatedConversation: Loaded first page with ${result.data.length} conversations',
      );
    } catch (e) {
      _logger.warning('PaginatedConversation: Error loading first page: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Load next page data
  Future<void> loadNextPage() async {
    if (state.isLoadingMore || !state.hasMore || state.isLoading) return;

    state = state.copyWith(isLoadingMore: true, error: null);

    try {
      final nextPage = state.currentPage + 1;
      final service = ref.read(conversationServiceProvider);
      final result = await service.getConversationList(
        page: nextPage,
        perPage: state.perPage,
      );

      state = state.copyWith(
        conversations: [...state.conversations, ...result.data],
        currentPage: result.meta.currentPage,
        hasMore: result.meta.hasMore,
        total: result.meta.total,
        isLoadingMore: false,
      );

      _logger.info(
        'PaginatedConversation: Loaded page $nextPage with ${result.data.length} conversations',
      );
    } catch (e) {
      _logger.warning('PaginatedConversation: Error loading next page: $e');
      state = state.copyWith(isLoadingMore: false, error: e.toString());
    }
  }

  /// Refresh data
  Future<void> refresh() async {
    await loadFirstPage();
  }

  /// Add new session to top of list
  void addNewSession(ConversationInfo session) {
    if (!state.isInitialized) {
      _logger.info(
        'PaginatedConversation: List not initialized, skipping addNewSession',
      );
      return;
    }

    final exists = state.conversations.any((c) => c.id == session.id);
    if (exists) {
      _logger.info(
        'PaginatedConversation: Session ${session.id} already exists, skipping add',
      );
      return;
    }

    state = state.copyWith(
      conversations: [session, ...state.conversations],
      total: state.total + 1,
    );
    _logger.info(
      'PaginatedConversation: Added new session ${session.id} to top of list',
    );
  }

  /// Update session title
  void updateSessionTitle(String sessionId, String newTitle) {
    final index = state.conversations.indexWhere((c) => c.id == sessionId);
    if (index == -1) {
      _logger.info(
        'PaginatedConversation: Session $sessionId not found for title update',
      );
      return;
    }

    final updatedConversations = [...state.conversations];
    updatedConversations[index] = state.conversations[index].copyWith(
      title: newTitle,
    );

    state = state.copyWith(conversations: updatedConversations);
    _logger.info(
      'PaginatedConversation: Updated title for session $sessionId to "$newTitle"',
    );
  }

  /// Reset state
  void reset() {
    state = const PaginatedConversationState();
  }
}
