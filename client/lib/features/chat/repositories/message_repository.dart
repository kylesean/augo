// features/chat/repositories/message_repository.dart
//
// Message Repository
// Extracted from ChatHistory to manage message CRUD operations
//
// Design Principles:
// - Encapsulates all message manipulation logic
// - Provides a clean interface for message operations
// - Uses callbacks to communicate state changes with host

import 'package:logging/logging.dart';
import 'package:collection/collection.dart';

import '../models/chat_message.dart';
import '../models/chat_message_attachment.dart';
import '../models/tool_call_info.dart';
import '../models/message_content_part.dart';

/// Callbacks for message state changes
typedef OnMessagesChangedCallback = void Function(List<ChatMessage> messages);
typedef GetCurrentMessagesCallback = List<ChatMessage> Function();

/// Message Repository
///
/// Manages all message CRUD operations including:
/// - Message content updates
/// - Message ID updates
/// - Surface ID management
/// - Attachment status management
class MessageRepository {
  final _logger = Logger('MessageRepository');

  /// Callback when messages change
  final OnMessagesChangedCallback onMessagesChanged;

  /// Callback to get current messages
  final GetCurrentMessagesCallback getCurrentMessages;

  MessageRepository({
    required this.onMessagesChanged,
    required this.getCurrentMessages,
  });

  // ============================================================
  // Public Methods - Query
  // ============================================================

  /// Find message by ID
  ChatMessage? findById(String id) {
    if (id.isEmpty) return null;
    return getCurrentMessages().firstWhereOrNull((m) => m.id == id);
  }

  /// Find message index by ID
  int indexOfId(String id) {
    if (id.isEmpty) return -1;
    return getCurrentMessages().indexWhere((m) => m.id == id);
  }

  /// Get last AI message
  ChatMessage? getLastAiMessage() {
    final messages = getCurrentMessages();
    for (int i = messages.length - 1; i >= 0; i--) {
      if (messages[i].sender != MessageSender.user) {
        return messages[i];
      }
    }
    return null;
  }

  /// Get message content by ID
  String getMessageContent(String id) {
    final message = findById(id);
    return message?.content ?? '';
  }

  // ============================================================
  // Public Methods - AI Message Updates
  // ============================================================

  /// Update AI message state
  ///
  /// Important: Only updates the specified fields, preserving all other data
  void updateAiMessageState({
    required String id,
    String? content,
    bool? isTyping,
    StreamingStatus? streamingStatus,
    DateTime? timestamp,
  }) {
    if (id.isEmpty) return;

    final messages = getCurrentMessages();
    final updatedMessages = messages.map((msg) {
      if (msg.id == id) {
        // Handle fullContent updates for streaming text
        List<MessageContentPart> updatedFullContent = List.from(
          msg.fullContent,
        );
        if (content != null) {
          // Calculate delta since last state
          // content is full aggregated text, msg.content is previous aggregated text
          String delta = "";
          if (content.startsWith(msg.content)) {
            delta = content.substring(msg.content.length);
          } else if (msg.content.isEmpty) {
            delta = content;
          } else {
            // Fallback: If content changed completely, treat as full update
            delta = content;
          }

          if (delta.isNotEmpty) {
            // Find the position to insert text
            // Design: UI components should ALWAYS stay at the END
            // So we insert text BEFORE any trailing UIComponent parts

            // Count trailing UIComponent parts
            int trailingUiCount = 0;
            for (int i = updatedFullContent.length - 1; i >= 0; i--) {
              if (updatedFullContent[i] is UIComponentPart) {
                trailingUiCount++;
              } else {
                break;
              }
            }

            // Find the last TextPart before trailing UI components
            final insertPosition = updatedFullContent.length - trailingUiCount;

            if (insertPosition > 0 &&
                updatedFullContent[insertPosition - 1] is TextPart) {
              // Merge with existing TextPart
              final lastTextPart =
                  updatedFullContent[insertPosition - 1] as TextPart;
              updatedFullContent[insertPosition - 1] = TextPart(
                text: lastTextPart.text + delta,
              );
            } else {
              // Insert new TextPart before trailing UI components
              updatedFullContent.insert(insertPosition, TextPart(text: delta));
            }
          }
        }

        // Only update AI message, preserve all original data
        return msg.copyWith(
          content: content ?? msg.content,
          fullContent: updatedFullContent,
          isTyping: isTyping ?? msg.isTyping,
          streamingStatus: streamingStatus ?? msg.streamingStatus,
          timestamp: timestamp ?? msg.timestamp,
          // CRITICAL: Preserve existing media files and surface IDs
          mediaFiles: msg.mediaFiles,
          surfaceIds: msg.surfaceIds,
          feedbackStatus: msg.feedbackStatus,
          conversationId: msg.conversationId,
        );
      }
      // Don't modify non-target messages
      return msg;
    }).toList();

    onMessagesChanged(updatedMessages);
  }

  /// Update message ID (replace temp ID with persisted ID)
  void updateMessageId(String oldId, String newId) {
    if (oldId.isEmpty || newId.isEmpty || oldId == newId) return;

    final messages = getCurrentMessages();
    final updatedMessages = messages.map((msg) {
      if (msg.id == oldId) {
        return msg.copyWith(id: newId);
      }
      return msg;
    }).toList();

    onMessagesChanged(updatedMessages);
    _logger.info(
      "MessageRepository: Updated message ID from '$oldId' to '$newId'",
    );
  }

  // ============================================================
  // Public Methods - Surface ID Management
  // ============================================================

  /// Add a surface ID to a message (with deduplication)
  bool addSurfaceIdToMessage(
    String messageId,
    String surfaceId, {
    String? toolName,
  }) {
    final messages = getCurrentMessages();
    final messageIndex = messages.indexWhere((m) => m.id == messageId);

    if (messageIndex == -1) {
      _logger.info(
        'MessageRepository: ⚠️ Message $messageId not found for surface $surfaceId',
      );
      return false;
    }

    final message = messages[messageIndex];

    // Deduplication check
    if (message.surfaceIds.contains(surfaceId)) {
      _logger.info(
        'MessageRepository: [DEDUP] Surface $surfaceId already exists in message $messageId',
      );
      return false;
    }

    final updatedSurfaceIds = [...message.surfaceIds, surfaceId];

    // CRITICAL: Also add to fullContent to ensure order-aware interleaved rendering
    final updatedFullContent = List<MessageContentPart>.from(
      message.fullContent,
    );

    // Check if this surface is already in fullContent (unlikely but safe)
    bool existsInParts = false;
    for (int i = 0; i < updatedFullContent.length; i++) {
      final part = updatedFullContent[i];
      if (part is UIComponentPart && part.component.surfaceId == surfaceId) {
        existsInParts = true;

        // Update tool info if missing
        if (part.component.toolName == null && toolName != null) {
          updatedFullContent[i] = MessageContentPart.uiComponent(
            component: part.component.copyWith(toolName: toolName),
          );
        }
        break;
      }
    }

    if (!existsInParts) {
      // Create a live UI component part (initially loading)
      updatedFullContent.add(
        MessageContentPart.uiComponent(
          component: UIComponentInfo(
            surfaceId: surfaceId,
            componentType: 'loading',
            mode: UIComponentMode.live,
            toolName: toolName,
          ),
        ),
      );
    }

    final updatedMessage = message.copyWith(
      surfaceIds: updatedSurfaceIds,
      fullContent: updatedFullContent,
    );

    final updatedMessages = [...messages];
    updatedMessages[messageIndex] = updatedMessage;

    onMessagesChanged(updatedMessages);
    _logger.info(
      'MessageRepository: ✓ Added surface $surfaceId (tool: $toolName) to message $messageId and fullContent',
    );
    return true;
  }

  /// Remove a surface ID from its message
  bool removeSurfaceIdFromMessage(String surfaceId) {
    final messages = getCurrentMessages();

    for (int i = 0; i < messages.length; i++) {
      final message = messages[i];
      if (message.surfaceIds.contains(surfaceId)) {
        final updatedSurfaceIds = message.surfaceIds
            .where((id) => id != surfaceId)
            .toList();

        final updatedMessage = message.copyWith(surfaceIds: updatedSurfaceIds);
        final updatedMessages = [...messages];
        updatedMessages[i] = updatedMessage;

        onMessagesChanged(updatedMessages);
        _logger.info(
          'MessageRepository: Removed surface $surfaceId from message ${message.id}',
        );
        return true;
      }
    }
    return false;
  }

  // ============================================================
  // Public Methods - Attachment Management
  // ============================================================

  /// Update attachment statuses for a message
  void setAttachmentStatuses({
    required int messageIndex,
    required Set<String> attachmentIds,
    required AttachmentLoadStatus status,
    String? errorMessage,
  }) {
    final messages = getCurrentMessages();

    if (messageIndex < 0 || messageIndex >= messages.length) {
      return;
    }

    final currentMessage = messages[messageIndex];
    final updatedAttachments = currentMessage.attachments.map((attachment) {
      if (!attachmentIds.contains(attachment.id)) {
        return attachment;
      }

      return attachment.copyWith(
        status: status,
        errorMessage: status == AttachmentLoadStatus.loading
            ? null
            : errorMessage,
      );
    }).toList();

    replaceMessageAt(
      messageIndex,
      currentMessage.copyWith(attachments: updatedAttachments),
    );
  }

  // ============================================================
  // Public Methods - Direct Mutation
  // ============================================================

  /// Replace message at specific index
  void replaceMessageAt(int index, ChatMessage updatedMessage) {
    final messages = getCurrentMessages();

    if (index < 0 || index >= messages.length) {
      return;
    }

    final updatedMessages = [...messages];
    updatedMessages[index] = updatedMessage;
    onMessagesChanged(updatedMessages);
  }

  /// Add messages to the list
  void addMessages(List<ChatMessage> newMessages) {
    final messages = getCurrentMessages();
    onMessagesChanged([...messages, ...newMessages]);
  }

  /// Set all messages
  void setMessages(List<ChatMessage> messages) {
    onMessagesChanged(messages);
  }

  /// Clear all messages
  void clearMessages() {
    onMessagesChanged([]);
  }

  /// Update feedback status for a message
  void updateFeedbackStatus(String messageId, AIFeedbackStatus newStatus) {
    final messages = getCurrentMessages();
    final index = messages.indexWhere((m) => m.id == messageId);

    if (index == -1) return;

    final updatedMessages = [...messages];
    updatedMessages[index] = messages[index].copyWith(
      feedbackStatus: newStatus,
    );
    onMessagesChanged(updatedMessages);
  }

  // ============================================================
  // Public Methods - Tool Call Management
  // ============================================================

  /// Add or update a tool call in a message
  ///
  /// If a tool call with the same ID exists, it will be updated.
  /// Otherwise, the tool call will be added.
  void addOrUpdateToolCall(String messageId, ToolCallInfo toolCall) {
    final messages = getCurrentMessages();
    final messageIndex = messages.indexWhere((m) => m.id == messageId);

    if (messageIndex == -1) {
      _logger.info(
        'MessageRepository: ⚠️ Message $messageId not found for tool call ${toolCall.id}',
      );
      return;
    }

    final message = messages[messageIndex];
    final existingIndex = message.toolCalls.indexWhere(
      (tc) => tc.id == toolCall.id,
    );

    List<ToolCallInfo> updatedToolCalls;
    List<MessageContentPart> updatedFullContent = List.from(
      message.fullContent,
    );

    if (existingIndex != -1) {
      // Update existing tool call
      updatedToolCalls = List.from(message.toolCalls);
      updatedToolCalls[existingIndex] = toolCall;

      // Update in fullContent too
      final partIndex = updatedFullContent.indexWhere(
        (p) => p is ToolCallPart && p.toolCall.id == toolCall.id,
      );
      if (partIndex != -1) {
        updatedFullContent[partIndex] = ToolCallPart(toolCall: toolCall);
      }

      _logger.info(
        'MessageRepository: Updated tool call ${toolCall.id} (${toolCall.name}) status=${toolCall.status}',
      );
    } else {
      // Add new tool call
      updatedToolCalls = [...message.toolCalls, toolCall];

      // Add as new part to fullContent
      // IMPORTANT: Insert BEFORE any trailing UIComponentPart to keep UI at the end
      int trailingUiCount = 0;
      for (int i = updatedFullContent.length - 1; i >= 0; i--) {
        if (updatedFullContent[i] is UIComponentPart) {
          trailingUiCount++;
        } else {
          break;
        }
      }
      final insertPosition = updatedFullContent.length - trailingUiCount;
      updatedFullContent.insert(
        insertPosition,
        ToolCallPart(toolCall: toolCall),
      );

      _logger.info(
        'MessageRepository: Added tool call ${toolCall.id} (${toolCall.name}) at position $insertPosition',
      );
    }

    final updatedMessage = message.copyWith(
      toolCalls: updatedToolCalls,
      fullContent: updatedFullContent,
    );
    final updatedMessages = [...messages];
    updatedMessages[messageIndex] = updatedMessage;
    onMessagesChanged(updatedMessages);
  }

  /// Cancel all pending/running tool calls for a message
  ///
  /// Called when user cancels the SSE stream to stop loading animations
  void cancelPendingToolCalls(String messageId) {
    final messages = getCurrentMessages();
    final messageIndex = messages.indexWhere((m) => m.id == messageId);

    if (messageIndex == -1) return;

    final message = messages[messageIndex];

    // Check if there are any pending/running tool calls
    final hasPendingTools = message.toolCalls.any(
      (tc) =>
          tc.status == ToolExecutionStatus.pending ||
          tc.status == ToolExecutionStatus.running,
    );

    if (!hasPendingTools) return;

    // Update all pending/running tool calls to cancelled
    final updatedToolCalls = message.toolCalls.map((tc) {
      if (tc.status == ToolExecutionStatus.pending ||
          tc.status == ToolExecutionStatus.running) {
        return tc.copyWith(status: ToolExecutionStatus.cancelled);
      }
      return tc;
    }).toList();

    // Update fullContent as well
    final updatedFullContent = message.fullContent.map((part) {
      if (part is ToolCallPart) {
        final tc = part.toolCall;
        if (tc.status == ToolExecutionStatus.pending ||
            tc.status == ToolExecutionStatus.running) {
          return ToolCallPart(
            toolCall: tc.copyWith(status: ToolExecutionStatus.cancelled),
          );
        }
      }
      return part;
    }).toList();

    final updatedMessage = message.copyWith(
      toolCalls: updatedToolCalls,
      fullContent: updatedFullContent,
    );

    final updatedMessages = [...messages];
    updatedMessages[messageIndex] = updatedMessage;
    onMessagesChanged(updatedMessages);

    _logger.info(
      'MessageRepository: Cancelled pending tool calls for message $messageId',
    );
  }
}
