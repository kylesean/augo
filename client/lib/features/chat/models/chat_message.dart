import 'package:freezed_annotation/freezed_annotation.dart';

// ignore_for_file: invalid_annotation_target
import 'chat_message_attachment.dart';
import '../services/data_uri_service.dart';
import 'tool_call_info.dart';
import 'message_content_part.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

@JsonEnum()
enum MessageSender { user, ai, system, tool, assistant }

enum AIFeedbackStatus { none, liked, disliked }

enum MessageType { text, aiThinking, toolResult }

enum StreamingStatus { none, connecting, streaming, completed, error }

@freezed
abstract class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    @JsonKey(defaultValue: '') required String id,
    @JsonKey(
      fromJson: _senderFromJson,
      toJson: _senderToJson,
      readValue: _readSenderValue,
    )
    required MessageSender sender,

    @JsonKey(
      fromJson: _dateTimeNullableFromJson,
      toJson: _dateTimeNullableToJson,
    )
    DateTime? timestamp,
    @Default("") String content,

    @JsonKey(name: 'messageType')
    @Default(MessageType.text)
    MessageType messageType,
    @JsonKey(name: 'feedbackStatus')
    @Default(AIFeedbackStatus.none)
    AIFeedbackStatus feedbackStatus,
    @JsonKey(name: 'streamingStatus')
    @Default(StreamingStatus.none)
    StreamingStatus streamingStatus,
    @JsonKey(name: 'isTyping') @Default(false) bool isTyping,
    // conversationId exists in each message from API response, can be added
    @JsonKey(name: 'conversationId') String? conversationId,

    // GenUI surface IDs
    @JsonKey(name: 'surfaceIds') @Default([]) List<String> surfaceIds,

    // Tool calls made by AI (from history)
    @JsonKey(
      name: 'toolCalls',
      fromJson: _toolCallsFromJson,
      toJson: _toolCallsToJson,
    )
    @Default([])
    List<ToolCallInfo> toolCalls,

    // UI components for GenUI rendering (from history)
    @JsonKey(
      name: 'uiComponents',
      fromJson: _uiComponentsFromJson,
      toJson: _uiComponentsToJson,
    )
    @Default([])
    List<UIComponentInfo> uiComponents,

    // Unified content parts (Text, ToolCall, or UIComponent)
    // This allows interleaving text and tools in order.
    @JsonKey(
      name: 'fullContent',
      fromJson: _fullContentFromJson,
      toJson: _fullContentToJson,
      readValue: _readFullContentValue,
    )
    @Default([])
    List<MessageContentPart> fullContent,

    @JsonKey(
      name: 'attachments',
      fromJson: _attachmentsFromJson,
      toJson: _attachmentsToJson,
    )
    @Default([])
    List<ChatMessageAttachment> attachments,

    // Media file data (attachments in user messages)
    @JsonKey(
      name: 'mediaFiles',
      fromJson: _mediaFilesFromJson,
      toJson: _mediaFilesToJson,
    )
    @Default([])
    List<DataUriFile> mediaFiles,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);

  factory ChatMessage.empty() => ChatMessage(
    id: '',
    content: '',
    sender: MessageSender.ai,
    timestamp: DateTime.now(),
    streamingStatus: StreamingStatus.completed,
    isTyping: false,
  );
}

// Custom serializers for MessageSender (handling role/sender field differences)
MessageSender _senderFromJson(dynamic json) {
  if (json == null) return MessageSender.ai;

  final String value = json.toString().toLowerCase();
  switch (value) {
    case 'user':
      return MessageSender.user;
    case 'assistant':
    case 'ai':
      return MessageSender.ai;
    case 'system':
      return MessageSender.system;
    case 'tool':
      return MessageSender.tool;
    default:
      return MessageSender.ai;
  }
}

String _senderToJson(MessageSender sender) {
  switch (sender) {
    case MessageSender.user:
      return 'user';
    case MessageSender.ai:
    case MessageSender.assistant:
      return 'assistant';
    case MessageSender.system:
      return 'system';
    case MessageSender.tool:
      return 'tool';
  }
}

// Custom serializers for nullable DateTime
DateTime? _dateTimeNullableFromJson(dynamic json) {
  if (json == null) return null;
  if (json is String) {
    return DateTime.parse(json);
  }
  throw FormatException('Invalid DateTime format: $json');
}

String? _dateTimeNullableToJson(DateTime? dateTime) =>
    dateTime?.toIso8601String();

// Custom readValue function to handle both 'role' and 'sender' fields
Object? _readSenderValue(Map json, String key) {
  // Prioritize reading 'role' field, if it doesn't exist, read 'sender' field
  return json['role'] ?? json['sender'];
}

List<ChatMessageAttachment> _attachmentsFromJson(dynamic json) {
  if (json == null) return [];
  if (json is List) {
    return json.map((item) {
      if (item is Map<String, dynamic>) {
        return ChatMessageAttachment.fromJson(item);
      } else if (item is Map) {
        return ChatMessageAttachment.fromJson(Map<String, dynamic>.from(item));
      }
      throw FormatException('Invalid ChatMessageAttachment format: $item');
    }).toList();
  }
  throw FormatException('Invalid attachments list format: $json');
}

List<Map<String, dynamic>> _attachmentsToJson(
  List<ChatMessageAttachment> attachments,
) {
  return attachments.map((attachment) => attachment.toJson()).toList();
}

// Custom serializers for mediaFiles
List<DataUriFile> _mediaFilesFromJson(dynamic json) {
  if (json == null) return [];
  if (json is List) {
    return json.map((item) {
      if (item is Map<String, dynamic>) {
        return DataUriFile.fromJson(item);
      } else if (item is Map) {
        // Convert Map<dynamic, dynamic> to Map<String, dynamic>
        final convertedMap = Map<String, dynamic>.from(item);
        return DataUriFile.fromJson(convertedMap);
      }
      throw FormatException('Invalid DataUriFile format: $item');
    }).toList();
  }
  throw FormatException('Invalid DataUriFile list format: $json');
}

List<Map<String, dynamic>> _mediaFilesToJson(List<DataUriFile> mediaFiles) {
  return mediaFiles.map((file) => file.toJson()).toList();
}

// Custom serializers for toolCalls
List<ToolCallInfo> _toolCallsFromJson(dynamic json) {
  if (json == null) return [];
  if (json is List) {
    return json.map((item) {
      if (item is Map<String, dynamic>) {
        return ToolCallInfo.fromJson(item);
      } else if (item is Map) {
        return ToolCallInfo.fromJson(Map<String, dynamic>.from(item));
      }
      throw FormatException('Invalid ToolCallInfo format: $item');
    }).toList();
  }
  return [];
}

List<Map<String, dynamic>> _toolCallsToJson(List<ToolCallInfo> toolCalls) {
  return toolCalls.map((tc) => tc.toJson()).toList();
}

// Custom serializers for uiComponents
List<UIComponentInfo> _uiComponentsFromJson(dynamic json) {
  if (json == null) return [];
  if (json is List) {
    return json.map((item) {
      if (item is Map<String, dynamic>) {
        return UIComponentInfo.fromJson(item);
      } else if (item is Map) {
        return UIComponentInfo.fromJson(Map<String, dynamic>.from(item));
      }
      throw FormatException('Invalid UIComponentInfo format: $item');
    }).toList();
  }
  return [];
}

List<Map<String, dynamic>> _uiComponentsToJson(
  List<UIComponentInfo> uiComponents,
) {
  return uiComponents.map((uc) => uc.toJson()).toList();
}

// Custom serializers for fullContent (Interleaved content)
List<MessageContentPart> _fullContentFromJson(dynamic json) {
  if (json == null) return [];
  if (json is List) {
    return json.map((item) {
      if (item is Map<String, dynamic>) {
        return MessageContentPart.fromJson(item);
      } else if (item is Map) {
        return MessageContentPart.fromJson(Map<String, dynamic>.from(item));
      }
      throw FormatException('Invalid MessageContentPart format: $item');
    }).toList();
  }
  return [];
}

List<Map<String, dynamic>> _fullContentToJson(List<MessageContentPart> parts) {
  return parts.map((part) => part.toJson()).toList();
}

/// Custom readValue for fullContent to support interleaving and legacy compatibility
Object? _readFullContentValue(Map json, String key) {
  // 1. If 'fullContent' already exists, use it
  if (json.containsKey('fullContent') && json['fullContent'] != null) {
    return json['fullContent'];
  }

  // 2. Otherwise, synthesize from legacy fields (content, toolCalls, uiComponents)
  final parts = <Map<String, dynamic>>[];

  // Note: For history synthesis, we assume the pattern [Preamble Text -> Tools -> UI]
  // This matches common AI behavior where the preamble explains the action.

  // Legacy Text Content (Preamble)
  final content = json['content'];
  if (content is String && content.isNotEmpty) {
    parts.add({'runtimeType': 'text', 'text': content});
  }

  // Legacy Tool Calls
  final toolCalls = json['toolCalls'];
  if (toolCalls is List) {
    for (final tc in toolCalls) {
      parts.add({'runtimeType': 'tool_call', 'toolCall': tc});
    }
  }

  // Legacy UI Components
  final uiComponents = json['uiComponents'];
  if (uiComponents is List) {
    for (final uc in uiComponents) {
      parts.add({'runtimeType': 'ui_component', 'component': uc});
    }
  }

  return parts.isEmpty ? null : parts;
}
