import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:augo/core/network/network_client.dart';
import '../models/comment_model.dart';
import 'package:augo/core/network/exceptions/app_exception.dart';

part 'comment_service.g.dart';

class CommentService {
  final NetworkClient _networkClient;
  CommentService(this._networkClient);

  Future<List<CommentModel>> getComments(String transactionId) async {
    return await _networkClient.request<List<CommentModel>>(
      '/transactions/$transactionId/comments', // API endpoint
      method: HttpMethod.get,
      fromJsonT: (json) {
        if (json is Map<String, dynamic> && json.containsKey('data')) {
          final data = json['data'];
          if (data is List) {
            return data
                .map(
                  (item) => CommentModel.fromJson(item as Map<String, dynamic>),
                )
                .toList();
          }
        }

        // Fallback or error if data is not in envelope or 'data' is not a list
        if (json is List) {
          // Backward compatibility just in case
          return json
              .map(
                (item) => CommentModel.fromJson(item as Map<String, dynamic>),
              )
              .toList();
        }
        throw DataParsingException(
          "API /transactions/$transactionId/comments: expected a list or an object containing a list, but received ${json.runtimeType}",
        );
      },
    );
  }

  Future<CommentModel> addComment({
    required String transactionId,
    required String commentText,
    String? parentCommentId,
  }) async {
    final Map<String, dynamic> requestData = {'comment_text': commentText};
    if (parentCommentId != null) {
      requestData['parent_comment_id'] = parentCommentId;
    }

    return await _networkClient.request<CommentModel>(
      '/transactions/$transactionId/comments',
      method: HttpMethod.post,
      data: requestData,
      fromJsonT: (json) {
        final map = json as Map<String, dynamic>;
        // Check if wrapped in data envelope
        if (map.containsKey('data') && map['data'] is Map<String, dynamic>) {
          return CommentModel.fromJson(map['data'] as Map<String, dynamic>);
        }
        return CommentModel.fromJson(map);
      },
    );
  }

  Future<void> deleteComment(String commentId) async {
    await _networkClient.request<void>(
      // Or <Map<String,dynamic>> if there's a response body
      '/transactions/comments/$commentId',
      method: HttpMethod.delete,
      // fromJsonT: (json) => {}, // Not needed for void if interceptor handles empty data
    );
  }
}

@riverpod
CommentService commentService(Ref ref) {
  final networkClient = ref.watch(networkClientProvider);
  return CommentService(networkClient);
}
