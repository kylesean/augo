// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_messages.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaginatedMessages _$PaginatedMessagesFromJson(Map<String, dynamic> json) =>
    _PaginatedMessages(
      data: (json['data'] as List<dynamic>)
          .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: Meta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaginatedMessagesToJson(_PaginatedMessages instance) =>
    <String, dynamic>{'data': instance.data, 'meta': instance.meta};

_Meta _$MetaFromJson(Map<String, dynamic> json) => _Meta(
  currentPage: (json['currentPage'] as num).toInt(),
  perPage: (json['perPage'] as num).toInt(),
  lastPage: (json['lastPage'] as num).toInt(),
  total: (json['total'] as num).toInt(),
  hasMore: json['hasMore'] as bool,
);

Map<String, dynamic> _$MetaToJson(_Meta instance) => <String, dynamic>{
  'currentPage': instance.currentPage,
  'perPage': instance.perPage,
  'lastPage': instance.lastPage,
  'total': instance.total,
  'hasMore': instance.hasMore,
};
