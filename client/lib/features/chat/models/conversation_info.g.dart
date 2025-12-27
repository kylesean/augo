// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConversationInfo _$ConversationInfoFromJson(Map<String, dynamic> json) =>
    _ConversationInfo(
      id: json['id'] as String,
      title: json['title'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      token: json['token'] as String?,
    );

Map<String, dynamic> _$ConversationInfoToJson(_ConversationInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'token': instance.token,
    };
