import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:augo/core/network/network_client.dart';
import 'package:augo/features/chat/models/conversation_info.dart';
import 'package:augo/features/chat/models/paginated_conversations.dart';
import 'package:augo/core/network/exceptions/app_exception.dart';
import 'package:augo/features/chat/models/conversation_detail.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/chat_message.dart';
import 'package:augo/features/chat/models/paginated_messages.dart';

part 'conversation_service.g.dart';

final _logger = Logger('ConversationService');

class ConversationService {
  final NetworkClient _networkClient;

  ConversationService(this._networkClient);

  /// Get paginated conversation list
  Future<PaginatedConversations> getConversationList({
    int page = 1,
    int perPage = 10,
  }) async {
    _logger.info(
      'ConversationService: Starting getConversationList API call for page $page...',
    );
    try {
      final result = await _networkClient.request<PaginatedConversations>(
        '/auth/sessions',
        method: HttpMethod.get,
        queryParameters: {'page': page, 'size': perPage},
        fromJsonT: (json) {
          if (json == null) {
            return const PaginatedConversations(
              data: [],
              meta: ConversationMeta(
                currentPage: 1,
                lastPage: 1,
                perPage: 10,
                total: 0,
                hasMore: false,
              ),
            );
          }

          if (json is Map<String, dynamic>) {
            try {
              final data = json['data'] as Map<String, dynamic>?;
              if (data == null) {
                return const PaginatedConversations(
                  data: [],
                  meta: ConversationMeta(
                    currentPage: 1,
                    lastPage: 1,
                    perPage: 10,
                    total: 0,
                    hasMore: false,
                  ),
                );
              }

              final List<dynamic> itemsData =
                  data['items'] as List<dynamic>? ?? [];

              final conversations = itemsData.map((session) {
                DateTime createdAt = DateTime.now();
                DateTime updatedAt = DateTime.now();

                if (session['created_at'] != null &&
                    session['created_at'].toString().isNotEmpty) {
                  try {
                    createdAt = DateTime.parse(session['created_at'] as String);
                  } catch (e) {
                    _logger.warning('Error parsing created_at: $e');
                  }
                }

                if (session['updated_at'] != null &&
                    session['updated_at'].toString().isNotEmpty) {
                  try {
                    updatedAt = DateTime.parse(session['updated_at'] as String);
                  } catch (e) {
                    _logger.warning('Error parsing updated_at: $e');
                  }
                }

                return ConversationInfo(
                  id: session['session_id'] as String,
                  title: session['name'] as String? ?? 'New Chat',
                  createdAt: createdAt,
                  updatedAt: updatedAt,
                  token: session['token'] as String?,
                );
              }).toList();

              final int currentPage = data['page'] as int? ?? page;
              final int totalPages = data['pages'] as int? ?? 1;
              final int size = data['size'] as int? ?? perPage;
              final int total = data['total'] as int? ?? conversations.length;
              final bool hasMore = data['has_more'] as bool? ?? false;

              return PaginatedConversations(
                data: conversations,
                meta: ConversationMeta(
                  currentPage: currentPage,
                  lastPage: totalPages,
                  perPage: size,
                  total: total,
                  hasMore: hasMore,
                ),
              );
            } catch (e) {
              _logger.warning('Error parsing sessions: $e');
              rethrow;
            }
          }

          throw DataParsingException(
            "API /api/v1/auth/sessions expected object, but received ${json.runtimeType}",
          );
        },
      );
      return result;
    } catch (e) {
      _logger.warning('getConversationList failed with error: $e');
      rethrow;
    }
  }

  Future<List<ConversationInfo>> getSimpleConversationList({
    int page = 1,
    int perPage = 10,
  }) async {
    final paginatedResult = await getConversationList(
      page: page,
      perPage: perPage,
    );
    return paginatedResult.data;
  }

  Future<ConversationDetail> getConversationDetail(
    String conversationId,
  ) async {
    _logger.info('Fetching conversation detail for: $conversationId');

    return await _networkClient.request<ConversationDetail>(
      '/chatbot/sessions/$conversationId/messages',
      method: HttpMethod.get,
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          final data = json['data'] as Map<String, dynamic>?;
          if (data == null) {
            throw DataParsingException('Response data field is null');
          }

          final messages = (data['messages'] as List? ?? []).map((msg) {
            if (msg is Map<String, dynamic>) {
              return ChatMessage.fromJson(msg);
            }
            throw DataParsingException('Invalid message format');
          }).toList();

          return ConversationDetail(
            id: data['session_id'] as String? ?? conversationId,
            title: data['title'] as String? ?? 'Chat',
            updatedAt: DateTime.now(),
            messages: messages,
          );
        }
        throw DataParsingException(
          "API response expected Map, but got ${json.runtimeType}",
        );
      },
    );
  }

  Future<PaginatedMessages> getConversationMessagesPage(
    String conversationId, {
    required int page,
    int limit = 20,
  }) async {
    return await _networkClient.request<PaginatedMessages>(
      '/chat/conversations/$conversationId/messages',
      method: HttpMethod.get,
      queryParameters: {'page': page, 'limit': limit},
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          return PaginatedMessages.fromJson(json);
        }
        throw DataParsingException(
          "API .../messages expected Map, but received ${json.runtimeType}",
        );
      },
    );
  }

  Future<ResumeStatus> getResumeStatus(String sessionId) async {
    return await _networkClient.request<ResumeStatus>(
      '/chatbot/sessions/$sessionId/resume-status',
      method: HttpMethod.get,
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          final data = json['data'] as Map<String, dynamic>?;
          if (data == null) {
            return const ResumeStatus(canResume: false, nextNodes: []);
          }
          return ResumeStatus(
            canResume: data['canResume'] as bool? ?? false,
            nextNodes:
                (data['nextNodes'] as List<dynamic>?)
                    ?.map((e) => e.toString())
                    .toList() ??
                [],
          );
        }
        throw DataParsingException(
          "API resume-status expected Map, but got ${json.runtimeType}",
        );
      },
    );
  }

  /// Delete a conversation/session by ID
  /// This performs cascade deletion on the server:
  /// - Session metadata
  /// - LangGraph checkpoints
  /// - Searchable messages
  Future<bool> deleteConversation(String sessionId) async {
    try {
      await _networkClient.requestMap(
        '/auth/session/$sessionId',
        method: HttpMethod.delete,
      );
      _logger.info('Conversation deleted: $sessionId');
      return true;
    } catch (e) {
      _logger.warning('Failed to delete conversation $sessionId: $e');
      return false;
    }
  }
}

class ResumeStatus {
  final bool canResume;
  final List<String> nextNodes;

  const ResumeStatus({required this.canResume, required this.nextNodes});
}

@riverpod
ConversationService conversationService(Ref ref) {
  final networkClient = ref.watch(networkClientProvider);
  return ConversationService(networkClient);
}

@riverpod
Future<List<ConversationInfo>> conversationList(Ref ref) async {
  ref.watch(authTokenProvider);
  final service = ref.watch(conversationServiceProvider);
  try {
    return await service.getSimpleConversationList();
  } catch (e) {
    _logger.warning('Error fetching conversations: $e');
    rethrow;
  }
}

@riverpod
class ConversationListRefresh extends _$ConversationListRefresh {
  @override
  int build() => 0;

  void refresh() => state++;
}

@riverpod
Future<List<ConversationInfo>> refreshableConversationList(Ref ref) async {
  ref.watch(conversationListRefreshProvider);
  final service = ref.watch(conversationServiceProvider);
  return service.getSimpleConversationList();
}
