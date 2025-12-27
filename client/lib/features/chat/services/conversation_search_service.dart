import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../providers/conversation_search_state.dart';
import 'package:augo/core/network/network_client.dart';

part 'conversation_search_service.g.dart';

/// Conversation search service
class ConversationSearchService {
  final NetworkClient _networkClient;

  ConversationSearchService(this._networkClient);

  /// Search conversation history
  Future<List<ConversationSearchResult>> searchConversations(
    String query,
  ) async {
    // Only execute search when there are keywords
    return _apiSearchConversations(query);
  }

  /// Real API search implementation
  Future<List<ConversationSearchResult>> _apiSearchConversations(
    String query,
  ) async {
    if (query.trim().isEmpty) {
      return [];
    }

    try {
      final response = await _networkClient.request<dynamic>(
        '/chatbot/sessions/messages/search',
        method: HttpMethod.get,
        queryParameters: {'q': query.trim(), 'limit': 20},
        fromJsonT: (json) =>
            json, // Return raw data directly, no type conversion
      );

      // Handle different response formats
      List<dynamic> results;
      if (response is Map<String, dynamic>) {
        if (response.containsKey('data')) {
          results = response['data'] as List<dynamic>? ?? [];
        } else {
          results = [];
        }
      } else if (response is List<dynamic>) {
        results = response;
      } else {
        results = [];
      }

      return results.map((item) {
        final data = item as Map<String, dynamic>;

        // Generate highlight ranges
        final highlights = _generateHighlights(
          query: query,
          title: data['title'] as String,
          snippet: data['snippet'] as String,
        );

        return ConversationSearchResult(
          id: data['id'] as String,
          title: data['title'] as String,
          snippet: data['snippet'] as String,
          messageId: data['messageId'] as String?,
          createdAt: data['createdAt'] != null
              ? DateTime.parse(data['createdAt'] as String)
              : null,
          updatedAt: data['updatedAt'] != null
              ? DateTime.parse(data['updatedAt'] as String)
              : null,
          highlights: highlights,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to search conversations: $e');
    }
  }

  /// Generate highlight ranges
  List<HighlightRange> _generateHighlights({
    required String query,
    required String title,
    required String snippet,
  }) {
    final highlights = <HighlightRange>[];
    final queryLower = query.toLowerCase();

    // Find matches in title
    final titleLower = title.toLowerCase();
    int titleIndex = 0;
    while (titleIndex < titleLower.length) {
      final index = titleLower.indexOf(queryLower, titleIndex);
      if (index == -1) break;

      highlights.add(
        HighlightRange(start: index, end: index + query.length, field: 'title'),
      );
      titleIndex = index + query.length;
    }

    // Find matches in snippet
    final snippetLower = snippet.toLowerCase();
    int snippetIndex = 0;
    while (snippetIndex < snippetLower.length) {
      final index = snippetLower.indexOf(queryLower, snippetIndex);
      if (index == -1) break;

      highlights.add(
        HighlightRange(
          start: index,
          end: index + query.length,
          field: 'snippet',
        ),
      );
      snippetIndex = index + query.length;
    }

    return highlights;
  }
}

/// Conversation search service provider
@riverpod
ConversationSearchService conversationSearchService(Ref ref) {
  final networkClient = ref.watch(networkClientProvider);
  return ConversationSearchService(networkClient);
}
