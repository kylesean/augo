// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => _ChatMessage(
  id: json['id'] as String? ?? '',
  sender: _senderFromJson(_readSenderValue(json, 'sender')),
  timestamp: _dateTimeNullableFromJson(json['timestamp']),
  content: json['content'] as String? ?? "",
  messageType:
      $enumDecodeNullable(_$MessageTypeEnumMap, json['messageType']) ??
      MessageType.text,
  feedbackStatus:
      $enumDecodeNullable(_$AIFeedbackStatusEnumMap, json['feedbackStatus']) ??
      AIFeedbackStatus.none,
  streamingStatus:
      $enumDecodeNullable(_$StreamingStatusEnumMap, json['streamingStatus']) ??
      StreamingStatus.none,
  isTyping: json['isTyping'] as bool? ?? false,
  conversationId: json['conversationId'] as String?,
  surfaceIds:
      (json['surfaceIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  toolCalls: json['toolCalls'] == null
      ? const []
      : _toolCallsFromJson(json['toolCalls']),
  uiComponents: json['uiComponents'] == null
      ? const []
      : _uiComponentsFromJson(json['uiComponents']),
  fullContent: _readFullContentValue(json, 'fullContent') == null
      ? const []
      : _fullContentFromJson(_readFullContentValue(json, 'fullContent')),
  attachments: json['attachments'] == null
      ? const []
      : _attachmentsFromJson(json['attachments']),
  mediaFiles: json['mediaFiles'] == null
      ? const []
      : _mediaFilesFromJson(json['mediaFiles']),
);

Map<String, dynamic> _$ChatMessageToJson(_ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sender': _senderToJson(instance.sender),
      'timestamp': _dateTimeNullableToJson(instance.timestamp),
      'content': instance.content,
      'messageType': _$MessageTypeEnumMap[instance.messageType]!,
      'feedbackStatus': _$AIFeedbackStatusEnumMap[instance.feedbackStatus]!,
      'streamingStatus': _$StreamingStatusEnumMap[instance.streamingStatus]!,
      'isTyping': instance.isTyping,
      'conversationId': instance.conversationId,
      'surfaceIds': instance.surfaceIds,
      'toolCalls': _toolCallsToJson(instance.toolCalls),
      'uiComponents': _uiComponentsToJson(instance.uiComponents),
      'fullContent': _fullContentToJson(instance.fullContent),
      'attachments': _attachmentsToJson(instance.attachments),
      'mediaFiles': _mediaFilesToJson(instance.mediaFiles),
    };

const _$MessageTypeEnumMap = {
  MessageType.text: 'text',
  MessageType.aiThinking: 'aiThinking',
  MessageType.toolResult: 'toolResult',
};

const _$AIFeedbackStatusEnumMap = {
  AIFeedbackStatus.none: 'none',
  AIFeedbackStatus.liked: 'liked',
  AIFeedbackStatus.disliked: 'disliked',
};

const _$StreamingStatusEnumMap = {
  StreamingStatus.none: 'none',
  StreamingStatus.connecting: 'connecting',
  StreamingStatus.streaming: 'streaming',
  StreamingStatus.completed: 'completed',
  StreamingStatus.error: 'error',
};
