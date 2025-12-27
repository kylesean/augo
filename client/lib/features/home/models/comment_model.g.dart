// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CommentModel _$CommentModelFromJson(Map<String, dynamic> json) =>
    _CommentModel(
      id: json['id'] as String,
      transactionId: json['transactionId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userAvatarUrl: json['userAvatarUrl'] as String,
      parentCommentId: json['parentCommentId'] as String?,
      commentText: json['commentText'] as String,
      repliedToUserId: json['repliedToUserId'] as String?,
      repliedToUserName: json['repliedToUserName'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: _dateTimeNullableParse(json['updatedAt'] as String?),
      replies:
          (json['replies'] as List<dynamic>?)
              ?.map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
      likedByCurrentUser: json['likedByCurrentUser'] as bool? ?? false,
    );

Map<String, dynamic> _$CommentModelToJson(_CommentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'transactionId': instance.transactionId,
      'userId': instance.userId,
      'userName': instance.userName,
      'userAvatarUrl': instance.userAvatarUrl,
      'parentCommentId': instance.parentCommentId,
      'commentText': instance.commentText,
      'repliedToUserId': instance.repliedToUserId,
      'repliedToUserName': instance.repliedToUserName,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': _dateTimeNullableToIso8601String(instance.updatedAt),
      'replies': instance.replies.map((e) => e.toJson()).toList(),
      'likeCount': instance.likeCount,
      'likedByCurrentUser': instance.likedByCurrentUser,
    };
