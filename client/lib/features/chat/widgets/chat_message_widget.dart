import 'dart:async';
import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:genui/genui.dart' as genui;
import 'package:gpt_markdown/gpt_markdown.dart';
import '../models/chat_message.dart' as app;
import '../genui/components/historical_component_renderer.dart';
import 'authenticated_image.dart';
import 'tool_execution_block.dart';
import '../models/tool_call_info.dart';
import '../models/message_content_part.dart';
import '../../../i18n/strings.g.dart';

final _logger = Logger('ChatMessageWidget');

/// Chat message widget that renders both text content and GenUI surfaces
///
/// This widget integrates GenUI's dynamic UI generation with traditional
/// text-based chat messages. It handles:
/// - Text content rendering using Markdown
/// - GenUI surface rendering for dynamic UI components
/// - Surface event handling
/// - Loading and error states
///
/// Requirements: 10.1, 10.3
class ChatMessageWidget extends ConsumerStatefulWidget {
  final app.ChatMessage message;
  final genui.GenUiHost genUiHost;

  const ChatMessageWidget({
    super.key,
    required this.message,
    required this.genUiHost,
  });

  @override
  ConsumerState<ChatMessageWidget> createState() => _ChatMessageWidgetState();
}

class _ChatMessageWidgetState extends ConsumerState<ChatMessageWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    unawaited(_controller.repeat());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    // Access message from widget.message
    final message = widget.message;

    // Debug: 追踪消息数据
    if (message.surfaceIds.isNotEmpty || message.uiComponents.isNotEmpty) {
      _logger.info(
        'ChatMessageWidget: Rendering message ${message.id} - surfaceIds: ${message.surfaceIds.length}, uiComponents: ${message.uiComponents.length}',
      );
    }

    // Debug: 追踪附件数据
    if (message.sender == app.MessageSender.user) {
      _logger.info(
        'ChatMessageWidget: User message ${message.id} has ${message.attachments.length} attachments',
      );
    }

    return Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 主内容流：文本 + 工具执行日志（过程）
          // 保持原始的时间顺序，确保 Loading 状态和执行日志出现在正确的位置（如：“正在查询...”应该在结果之前）
          ...message.fullContent
              .where(
                (part) => part.maybeWhen(
                  uiComponent: (_) => false, // 排除 UI 组件
                  orElse: () => true, // 包含 Text 和 ToolCall
                ),
              )
              .map((part) => _buildContentPart(context, theme, part, message)),

          // 结果附件：GenUI 组件（卡片/结果）
          // 将大块的 UI 结果沉底，类似邮件附件或报表展示，避免打断文本阅读流
          ...message.fullContent
              .where(
                (part) => part.maybeWhen(
                  uiComponent: (_) => true, // 只包含 UI 组件
                  orElse: () => false,
                ),
              )
              .map((part) => _buildContentPart(context, theme, part, message)),

          // 如果没有任何工具正在运行，且消息正在 typing，则在末尾显示流式指示器
          if (_shouldShowStreamingIndicator())
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: _buildStreamingIndicator(context, theme),
            ),

          // 4. 用户消息的附件
          if (message.attachments.isNotEmpty) ...[
            const SizedBox(height: 12.0),
            _buildAttachments(context, theme, message),
          ],
        ],
      ),
    );
  }

  /// Build specific content part based on its type
  Widget _buildContentPart(
    BuildContext context,
    FThemeData theme,
    MessageContentPart part,
    app.ChatMessage message,
  ) {
    return part.when(
      text: (text) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: _buildTextContentFromPart(context, theme, text),
      ),
      toolCall: (toolCall) => ToolExecutionBlock(
        key: ValueKey('tool_${toolCall.id}'),
        toolCall: toolCall,
      ),
      uiComponent: (component) {
        if (component.mode == UIComponentMode.live) {
          // Live Real-time Surface (Streaming)
          return Container(
            key: ValueKey('live_${component.surfaceId}'),
            margin: const EdgeInsets.only(top: 4.0, bottom: 12.0),
            child: genui.GenUiSurface(
              host: widget.genUiHost,
              surfaceId: component.surfaceId,
            ),
          );
        } else {
          // Historical Static Surface
          return Container(
            key: ValueKey('historical_${component.surfaceId}'),
            margin: const EdgeInsets.only(top: 4.0, bottom: 12.0),
            child: HistoricalComponentRenderer(
              componentType: component.componentType,
              data: component.data,
            ),
          );
        }
      },
    );
  }

  /// Process message content to handle UserActionEvent JSON
  String _processContent(String content) {
    if (content.trim().startsWith('{')) {
      try {
        final json = jsonDecode(content);
        if (json is Map<String, dynamic> && json.containsKey('userAction')) {
          final eventData = json['userAction'] as Map<String, dynamic>;
          final eventName = eventData['name'] as String?;
          final context = eventData['context'] as Map<String, dynamic>?;

          if (eventName == 'transfer_path_confirmed' && context != null) {
            final sourceName = context['source_account_name'] ?? 'Unknown';
            final targetName = context['target_account_name'] ?? 'Unknown';
            final sourceId = context['source_account_id'] ?? '';
            final targetId = context['target_account_id'] ?? '';
            final amount = context['amount'];
            final currency = context['currency'] ?? 'CNY';

            final sourceDisplay = (sourceId as String).isNotEmpty
                ? '$sourceName ($sourceId)'
                : sourceName as String;
            final targetDisplay = (targetId as String).isNotEmpty
                ? '$targetName ($targetId)'
                : targetName as String;

            return 'Confirmed transfer path: from $sourceDisplay to $targetDisplay, amount $currency $amount. Please execute this transfer operation.';
          }
        }
      } catch (e) {
        // Ignore JSON parse errors, treat as normal text
      }
    }
    return content;
  }

  /// Build text content from a part
  Widget _buildTextContentFromPart(
    BuildContext context,
    FThemeData theme,
    String text,
  ) {
    if (text.isEmpty) return const SizedBox.shrink();

    return AnimatedSize(
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeOut,
      alignment: Alignment.topLeft,
      child: GptMarkdownTheme(
        gptThemeData: _gptThemeData(context, theme),
        child: GptMarkdown(
          _processContent(text),
          style: TextStyle(
            fontSize: 15,
            color: theme.colors.foreground,
            height: 1.5,
          ),
          // Custom ordered list builder for proper number alignment
          orderedListBuilder: (ctx, no, child, config) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fixed-width container for right-aligned numbers
                  SizedBox(
                    width: 28,
                    child: Text(
                      '$no.',
                      style: TextStyle(
                        fontSize: 15,
                        color: theme.colors.foreground,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: child),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Build attachments (images) for user messages
  Widget _buildAttachments(
    BuildContext context,
    FThemeData theme,
    app.ChatMessage message,
  ) {
    _logger.info(
      'Building attachments for message ${message.id}: ${message.attachments.length} attachments',
    );
    for (final att in message.attachments) {
      _logger.info(
        '  Attachment: id=${att.id}, filename=${att.filename}, signedUrl=${att.signedUrl}',
      );
    }

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: message.attachments.map((attachment) {
        final url = attachment.signedUrl;
        if (url == null || url.isEmpty) {
          _logger.warning(
            'Attachment ${attachment.id} has no signedUrl, skipping',
          );
          return const SizedBox.shrink();
        }

        Widget imageWidget;
        if (url.startsWith('data:')) {
          // Base64 data URI - 直接解码并渲染
          final base64Data = url.split(',').last;
          imageWidget = Image.memory(
            base64Decode(base64Data),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildImageError(theme, attachment.filename);
            },
          );
        } else {
          // Network URL - 使用 AuthenticatedImage 组件（带认证 header）
          // 从 URL 中提取 attachment ID（如：/api/v1/files/view/{id}）
          final attachmentId = attachment.id;
          imageWidget = AuthenticatedImage(
            attachmentId: attachmentId,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildImageError(theme, attachment.filename);
            },
          );
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 200, maxHeight: 200),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colors.muted, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: imageWidget,
          ),
        );
      }).toList(),
    );
  }

  /// Build error placeholder for image loading failures
  Widget _buildImageError(FThemeData theme, String filename) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: theme.colors.muted.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FIcons.image, color: theme.colors.primaryForeground, size: 24),
          const SizedBox(height: 4),
          Text(
            filename,
            style: theme.typography.sm.copyWith(
              color: theme.colors.mutedForeground,
              fontSize: 10,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// Build streaming indicator with shimmer effect
  Widget _buildStreamingIndicator(BuildContext context, FThemeData theme) {
    final colors = theme.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 动态图标 - 与 ToolExecutionBlock 保持一致
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _controller.value * 2 * 3.14159,
                child: Icon(FIcons.loader, size: 14, color: colors.primary),
              );
            },
          ),
          const SizedBox(width: 8),
          // Shimmer 文字 - 与 ToolExecutionBlock 保持一致
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final shimmerPosition = _controller.value * 3 - 1.0;

              return ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) {
                  return LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      colors.mutedForeground,
                      colors.primary,
                      colors.mutedForeground,
                    ],
                    stops: [
                      (shimmerPosition - 0.3).clamp(0.0, 1.0),
                      shimmerPosition.clamp(0.0, 1.0),
                      (shimmerPosition + 0.3).clamp(0.0, 1.0),
                    ],
                  ).createShader(bounds);
                },
                child: Text(
                  Translations.of(context).chat.aiThinking,
                  style: theme.typography.sm.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Check if streaming indicator should be shown
  bool _shouldShowStreamingIndicator() {
    return widget.message.isTyping &&
        (widget.message.streamingStatus == app.StreamingStatus.connecting ||
            widget.message.streamingStatus == app.StreamingStatus.streaming);
  }

  /// Get Markdown theme configuration
  GptMarkdownThemeData _gptThemeData(BuildContext context, FThemeData theme) {
    return GptMarkdownThemeData(
      brightness: Theme.of(context).brightness,
      h1: TextStyle(
        fontSize: 28,
        color: theme.colors.primary,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
