import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/comment_model.dart';
import '../services/comment_service.dart';

part 'comment_providers.g.dart';

@riverpod
class TransactionComments extends _$TransactionComments {
  @override
  FutureOr<List<CommentModel>> build(String transactionId) async {
    final service = ref.watch(commentServiceProvider);
    final comments = await service.getComments(transactionId);
    comments.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return comments;
  }

  Future<void> addComment(String text, String? parentId) async {
    final service = ref.read(commentServiceProvider);

    // Temporarily not manually setting loading state, let AsyncValue.guard handle it
    // Or if immediate feedback is wanted, uncomment below
    // state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await service.addComment(
        transactionId: transactionId,
        commentText: text,
        parentCommentId: parentId,
      );
      return await service.getComments(transactionId);
    });
  }

  Future<void> deleteComment(String commentId) async {
    final service = ref.read(commentServiceProvider);
    state = await AsyncValue.guard(() async {
      await service.deleteComment(commentId);
      return await service.getComments(transactionId);
    });
  }
}

@riverpod
class ReplyingToCommentId extends _$ReplyingToCommentId {
  @override
  String? build() => null;

  void set(String? id) => state = id;
}

@riverpod
class ReplyingToUserName extends _$ReplyingToUserName {
  @override
  String? build() => null;

  void set(String? name) => state = name;
}
