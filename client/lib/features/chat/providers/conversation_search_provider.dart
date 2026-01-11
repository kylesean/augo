import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'conversation_search_state.dart';
import '../services/conversation_search_service.dart';

part 'conversation_search_provider.g.dart';

/// Conversation search state management
@riverpod
class ConversationSearch extends _$ConversationSearch {
  Timer? _debounceTimer;

  @override
  ConversationSearchState build() {
    ref.onDispose(() {
      _debounceTimer?.cancel();
    });

    return const ConversationSearchState();
  }

  /// Enter search mode
  void enterSearchMode() {
    state = state.copyWith(
      mode: SearchMode.search,
      query: '',
      results: [],
      error: null,
      hasSearched: false,
      isLoading: false,
      isFullscreen: false,
    );
  }

  /// Enter fullscreen search mode
  void enterFullscreenSearchMode() {
    state = state.copyWith(
      mode: SearchMode.fullscreenSearch,
      query: '',
      results: [],
      error: null,
      hasSearched: false,
      isLoading: false,
      isFullscreen: true,
    );
  }

  /// Exit search mode
  void exitSearchMode() {
    _debounceTimer?.cancel();
    state = state.copyWith(
      mode: SearchMode.normal,
      query: '',
      results: [],
      error: null,
      hasSearched: false,
      isLoading: false,
      isFullscreen: false,
    );
  }

  /// Exit fullscreen search mode to normal search mode
  void exitFullscreenSearchMode() {
    _debounceTimer?.cancel();
    state = state.copyWith(mode: SearchMode.search, isFullscreen: false);
  }

  /// Update search query (with debounce)
  void updateQuery(String query) {
    state = state.copyWith(query: query);

    // Cancel previous debounce timer
    _debounceTimer?.cancel();

    if (query.trim().isEmpty) {
      // If query is empty, clear results
      state = state.copyWith(
        results: [],
        error: null,
        hasSearched: false,
        isLoading: false,
      );
      return;
    }

    // Immediately set loading state to show skeleton screen in UI
    state = state.copyWith(isLoading: true, hasSearched: false);

    // Set debounce timer
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      unawaited(_performSearch(query.trim()));
    });
  }

  /// Perform search
  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final searchService = ref.read(conversationSearchServiceProvider);
      final results = await searchService.searchConversations(query);
      state = state.copyWith(
        results: results,
        isLoading: false,
        hasSearched: true,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
        hasSearched: true,
      );
    }
  }

  /// Clear search
  void clearSearch() {
    _debounceTimer?.cancel();
    state = state.copyWith(
      query: '',
      results: [],
      error: null,
      hasSearched: false,
      isLoading: false,
    );
  }
}
