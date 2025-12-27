// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_conversations.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConversationMeta _$ConversationMetaFromJson(Map<String, dynamic> json) =>
    _ConversationMeta(
      currentPage: (json['currentPage'] as num).toInt(),
      lastPage: (json['lastPage'] as num).toInt(),
      perPage: (json['perPage'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      hasMore: json['hasMore'] as bool,
    );

Map<String, dynamic> _$ConversationMetaToJson(_ConversationMeta instance) =>
    <String, dynamic>{
      'currentPage': instance.currentPage,
      'lastPage': instance.lastPage,
      'perPage': instance.perPage,
      'total': instance.total,
      'hasMore': instance.hasMore,
    };

_PaginatedConversations _$PaginatedConversationsFromJson(
  Map<String, dynamic> json,
) => _PaginatedConversations(
  data: (json['data'] as List<dynamic>)
      .map((e) => ConversationInfo.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: ConversationMeta.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PaginatedConversationsToJson(
  _PaginatedConversations instance,
) => <String, dynamic>{'data': instance.data, 'meta': instance.meta};
