// features/chat/services/historical_message_processor.dart
//
// Historical Message Processor
// Extracted from ChatHistory to process historical messages
//
// Design Principles:
// - Processes and standardizes historical messages from API
// - Merges consecutive AI messages into single display units
// - Handles historical UI component rendering

import 'package:logging/logging.dart';

import '../models/chat_message.dart';
import '../models/chat_message_attachment.dart';

/// Historical Message Processor
///
/// Processes historical messages from API, including:
/// - Normalizing timestamps and attachments
/// - Rendering historical UI components
/// - Merging consecutive AI messages
class HistoricalMessageProcessor {
  final _logger = Logger('HistoricalMessageProcessor');

  /// Process historical messages from API
  ///
  /// Key logic: Merge consecutive AI messages into a single "Turn"
  /// This follows industry best practices (ChatGPT, Claude):
  /// - Backend stores messages independently (preserves LLM context semantics)
  /// - Frontend merges consecutive assistant messages for display (matches user expectations)
  List<ChatMessage> processHistoricalMessages(List<ChatMessage> rawMessages) {
    final processedMessages = <ChatMessage>[];

    for (int i = 0; i < rawMessages.length; i++) {
      final message = rawMessages[i];

      // Set default timestamp for messages without one
      final processedMessage = message.timestamp == null
          ? message.copyWith(timestamp: DateTime.now())
          : message;

      // Normalize attachment statuses
      final normalizedAttachments = processedMessage.attachments.map((
        attachment,
      ) {
        if (attachment.hasSignedUrl) {
          return attachment.copyWith(status: AttachmentLoadStatus.loaded);
        }
        return attachment;
      }).toList();

      // 不再尝试通过 GenUI 重放历史 UI 组件
      // 原因：replayHistoricalSurface 机制不可靠，历史组件应由 HistoricalComponentRenderer 直接渲染
      // 这是更简单且稳定的方案

      // 记录历史 UI 组件信息（仅用于调试）
      if (processedMessage.uiComponents.isNotEmpty) {
        _logger.info(
          "HistoricalMessageProcessor: Message ${processedMessage.id} has ${processedMessage.uiComponents.length} UI components (will be rendered by HistoricalComponentRenderer)",
        );
      }

      final finalMessage = processedMessage.copyWith(
        streamingStatus: StreamingStatus.completed,
        isTyping: false,
        attachments: normalizedAttachments,
        // 保留原有的 surfaceIds（来自实时渲染的 surfaces）
        // uiComponents 保持不变，供 HistoricalComponentRenderer 使用
      );

      // Merge consecutive AI messages (tool call messages + final reply)
      final isAiMessage =
          finalMessage.sender == MessageSender.ai ||
          finalMessage.sender == MessageSender.assistant;

      if (isAiMessage && processedMessages.isNotEmpty) {
        final lastMessage = processedMessages.last;
        final lastIsAi =
            lastMessage.sender == MessageSender.ai ||
            lastMessage.sender == MessageSender.assistant;

        // If previous message is also AI, merge them
        if (lastIsAi) {
          final mergedMessage = _mergeAiMessages(lastMessage, finalMessage);
          processedMessages[processedMessages.length - 1] = mergedMessage;

          _logger.info(
            "HistoricalMessageProcessor: Merged AI messages ${lastMessage.id} + ${finalMessage.id}",
          );
          continue; // Skip adding, already merged
        }
      }

      processedMessages.add(finalMessage);

      if (finalMessage.surfaceIds.isNotEmpty) {
        _logger.info(
          "HistoricalMessageProcessor: Message ${finalMessage.id} has ${finalMessage.surfaceIds.length} GenUI surfaces",
        );
      }
    }

    _logger.info(
      "HistoricalMessageProcessor: Processed ${rawMessages.length} raw messages into ${processedMessages.length} display messages",
    );
    return processedMessages;
  }

  ChatMessage _mergeAiMessages(ChatMessage first, ChatMessage second) {
    final mergedFullContent = [...first.fullContent, ...second.fullContent];

    // Deduplicate or group adjacent parts if necessary
    // For now, simple concatenation is correct for ordering

    final mergedContent = _mergeContent(first.content, second.content);
    final mergedSurfaceIds = [...first.surfaceIds, ...second.surfaceIds];
    final mergedToolCalls = [...first.toolCalls, ...second.toolCalls];
    final mergedUiComponents = [...first.uiComponents, ...second.uiComponents];

    return second.copyWith(
      content: mergedContent,
      fullContent: mergedFullContent,
      surfaceIds: mergedSurfaceIds,
      toolCalls: mergedToolCalls,
      uiComponents: mergedUiComponents,
      timestamp: first.timestamp ?? second.timestamp,
    );
  }

  /// Merge content from two messages
  String _mergeContent(String content1, String content2) {
    final c1 = content1.trim();
    final c2 = content2.trim();

    if (c1.isEmpty) return c2;
    if (c2.isEmpty) return c1;

    // Both have content, separate with newlines
    return '$c1\n\n$c2';
  }
}
