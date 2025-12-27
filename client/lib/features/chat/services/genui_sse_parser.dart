import 'dart:convert';
import 'package:logging/logging.dart';

final _logger = Logger('GenUiSseParser');

/// SSE event type (Simplified for A2UI Protocol)
enum SseEventType {
  text, // Text streaming from LLM
  a2uiMessage, // Standard A2UI protocol message
  titleUpdate, // Session title update
  sessionInit, // New session initialization
  done, // Stream completed
  error, // Error occurred
  unknown, // Unknown event type
}

/// Parsed SSE event
class ParsedSseEvent {
  final SseEventType type;
  final String? content;
  final String? surfaceId;
  final Map<String, dynamic>? widgetSchema;
  final bool done;
  final String? sessionId;
  final String? conversationId;
  final String? messageId;
  final String? errorCode;
  final String? errorMessage;
  final String? title; // Session title (title_update event)

  // GenUI related fields
  final String? component; // UI component name
  final Map<String, dynamic>? data; // UI component data
  final String? interruptId; // Unique identifier for interrupt

  ParsedSseEvent({
    required this.type,
    this.content,
    this.surfaceId,
    this.widgetSchema,
    this.done = false,
    this.sessionId,
    this.conversationId,
    this.messageId,
    this.errorCode,
    this.errorMessage,
    this.title,
    this.component,
    this.data,
    this.interruptId,
  });

  /// True if this is the first frame containing session info (for new sessions)
  bool get isFirstFrame => sessionId != null;
  bool get hasWidgetSchema => widgetSchema != null;
  bool get isError => type == SseEventType.error;
  bool get isUiEvent => type == SseEventType.a2uiMessage;
}

/// GenUI SSE event parser
class GenUiSseParser {
  /// Parse SSE event data
  static ParsedSseEvent parse(String eventData) {
    try {
      // Remove "data: " prefix (if exists)
      String jsonStr = eventData.trim();
      if (jsonStr.startsWith('data: ')) {
        jsonStr = jsonStr.substring(6).trim();
      }

      if (jsonStr.isEmpty) {
        return ParsedSseEvent(type: SseEventType.unknown, content: '');
      }

      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      return _parseFromJson(json);
    } catch (e) {
      _logger.info('GenUiSseParser: Error parsing SSE event: $e');
      return ParsedSseEvent(
        type: SseEventType.error,
        errorMessage: 'Failed to parse SSE event: ${e.toString()}',
      );
    }
  }

  /// Parse event from JSON
  static ParsedSseEvent _parseFromJson(Map<String, dynamic> json) {
    // Determine event type
    final typeStr = json['type'] as String?;
    final eventType = _parseEventType(typeStr);

    // Extract common fields
    final content = json['content'] as String?;
    final done = json['done'] as bool? ?? false;

    // Handle session_init type metadata
    final metadata = json['metadata'] as Map<String, dynamic>?;
    String? sessionId = json['session_id'] as String?;

    // If there's a metadata field, extract session_id from it
    if (metadata != null) {
      sessionId ??= metadata['session_id'] as String?;
    }

    final conversationId = json['conversation_id'] as String?;
    final messageId = json['message_id'] as String?;

    // Extract GenUI related fields
    final surfaceId = json['surface_id'] as String?;
    final widgetSchemaRaw = json['widget_schema'];
    Map<String, dynamic>? widgetSchema;

    if (widgetSchemaRaw != null) {
      if (widgetSchemaRaw is Map<String, dynamic>) {
        widgetSchema = widgetSchemaRaw;
      } else if (widgetSchemaRaw is String) {
        // If widget_schema is a string, try to parse it
        try {
          widgetSchema = jsonDecode(widgetSchemaRaw) as Map<String, dynamic>;
        } catch (e) {
          _logger.info(
            'GenUiSseParser: Failed to parse widget_schema string: $e',
          );
        }
      }

      // Validate schema
      if (widgetSchema != null && !validateSchema(widgetSchema)) {
        _logger.info('GenUiSseParser: Invalid widget schema structure');
        widgetSchema = null;
      }
    }

    // Extract error information
    final errorCode = json['error_code'] as String?;
    final errorMessage =
        json['error_message'] as String? ?? json['error'] as String?;

    // Extract GenUI UI event related fields
    final component = json['component'] as String?;
    final data = json['data'] as Map<String, dynamic>?;

    // Extract title (title_update event)
    final title = json['title'] as String?;

    // Extract interrupt ID
    final interruptId = json['interrupt_id'] as String?;

    return ParsedSseEvent(
      type: eventType,
      content: content ?? '',
      surfaceId: surfaceId,
      widgetSchema: widgetSchema,
      done: done,
      sessionId: sessionId,
      conversationId: conversationId,
      messageId: messageId,
      errorCode: errorCode,
      errorMessage: errorMessage,
      title: title,
      component: component,
      data: data,
      interruptId: interruptId,
    );
  }

  /// Parse event type string
  static SseEventType _parseEventType(String? typeStr) {
    if (typeStr == null) {
      return SseEventType.text;
    }

    switch (typeStr.toLowerCase()) {
      case 'text':
      case 'text_delta': // Text increment type returned by backend
      case 'content':
      case 'message':
        return SseEventType.text;

      // A2UI protocol events
      case 'a2ui_message':
      case 'ui_render':
        return SseEventType.a2uiMessage;

      case 'session_init':
        return SseEventType.sessionInit;
      case 'title_update':
        return SseEventType.titleUpdate;
      case 'done':
      case 'complete':
      case 'stream_end':
        return SseEventType.done;
      case 'error':
        return SseEventType.error;

      default:
        return SseEventType.unknown;
    }
  }

  /// Validate widget schema structure
  ///
  /// A valid widget schema should contain:
  /// - id: Unique identifier
  /// - type: Component type
  /// - properties or props: Component properties
  static bool validateSchema(Map<String, dynamic> schema) {
    try {
      // Check required fields
      if (!schema.containsKey('id') && !schema.containsKey('surfaceId')) {
        _logger.info('GenUiSseParser: Schema missing id/surfaceId field');
        return false;
      }

      if (!schema.containsKey('type') && !schema.containsKey('componentType')) {
        _logger.info('GenUiSseParser: Schema missing type/componentType field');
        return false;
      }

      // Check if there's a properties field (properties or props or data)
      if (!schema.containsKey('properties') &&
          !schema.containsKey('props') &&
          !schema.containsKey('data')) {
        _logger.info(
          'GenUiSseParser: Schema missing properties/props/data field',
        );
        return false;
      }

      // Validate id is string
      final id = schema['id'] ?? schema['surfaceId'];
      if (id is! String || id.isEmpty) {
        _logger.info('GenUiSseParser: Schema id is not a valid string');
        return false;
      }

      // Validate type is string
      final type = schema['type'] ?? schema['componentType'];
      if (type is! String || type.isEmpty) {
        _logger.info('GenUiSseParser: Schema type is not a valid string');
        return false;
      }

      // Validate properties is Map
      final props = schema['properties'] ?? schema['props'] ?? schema['data'];
      if (props is! Map) {
        _logger.info('GenUiSseParser: Schema properties is not a Map');
        return false;
      }

      return true;
    } catch (e) {
      _logger.info('GenUiSseParser: Schema validation error: $e');
      return false;
    }
  }

  /// Extract normalized version of widget schema
  ///
  /// Convert different schema formats to unified format
  static Map<String, dynamic>? extractNormalizedSchema(
    Map<String, dynamic>? schema,
  ) {
    if (schema == null) return null;

    try {
      final id = schema['id'] ?? schema['surfaceId'];
      final type = schema['type'] ?? schema['componentType'];
      final props = schema['properties'] ?? schema['props'] ?? schema['data'];

      if (id == null || type == null || props == null) {
        return null;
      }

      return {
        'id': id,
        'type': type,
        'properties': props,
        // Keep other optional fields
        if (schema.containsKey('children')) 'children': schema['children'],
        if (schema.containsKey('metadata')) 'metadata': schema['metadata'],
      };
    } catch (e) {
      _logger.info('GenUiSseParser: Error normalizing schema: $e');
      return null;
    }
  }
}
