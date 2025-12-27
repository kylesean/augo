// features/home/models/comment_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_model.freezed.dart';
part 'comment_model.g.dart';

@freezed
abstract class CommentModel with _$CommentModel {
  @JsonSerializable(explicitToJson: true)
  const factory CommentModel({
    required String id,
    required String transactionId, // Ensure API returns or can set
    required String userId, // ID of the user who posted the comment
    required String userName, // Username of the user who posted the comment
    required String
    userAvatarUrl, // Avatar URL of the user who posted the comment
    String? parentCommentId, // Parent comment ID, used for replies
    required String commentText, // Reply text content
    String?
    repliedToUserId, // ID of the user being replied to (optional, recommended)
    String?
    repliedToUserName, // Name of the user being replied to (optional, recommended)
    required DateTime createdAt,
    @JsonKey(
      fromJson: _dateTimeNullableParse,
      toJson: _dateTimeNullableToIso8601String,
    )
    DateTime? updatedAt,
    @Default([])
    List<CommentModel>
    replies, // Current field only for backend returned data, UI no longer renders recursively
    // Or backend returns nested structure directly, but mind the hierarchy depth
    @Default(0) int likeCount, // Optional: comment like count
    @Default(false)
    bool likedByCurrentUser, // Optional: whether current user liked the comment
  }) = _CommentModel;

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);
}

// Helper functions for date serialization/deserialization
String _dateTimeToIso8601String(DateTime dt) => dt.toIso8601String();
DateTime? _dateTimeNullableParse(String? dateString) =>
    dateString != null ? DateTime.parse(dateString) : null;
String? _dateTimeNullableToIso8601String(DateTime? dt) => dt?.toIso8601String();
