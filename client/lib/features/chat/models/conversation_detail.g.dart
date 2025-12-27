// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConversationDetail _$ConversationDetailFromJson(Map<String, dynamic> json) =>
    _ConversationDetail(
      id: json['id'] as String,
      title: json['title'] as String,
      updatedAt: _dateTimeFromJson(json['updatedAt']),
      messages:
          (json['messages'] as List<dynamic>?)
              ?.map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ConversationDetailToJson(_ConversationDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'updatedAt': _dateTimeToJson(instance.updatedAt),
      'messages': instance.messages,
    };
