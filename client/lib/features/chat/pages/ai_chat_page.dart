// features/chat/pages/ai_chat_page.dart
import 'dart:convert';
import 'package:logging/logging.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:forui/forui.dart';

import '../widgets/chat_input_field.dart';
import '../widgets/chat_message_widget.dart';
import '../widgets/genui_error_widget.dart';
import '../providers/chat_history_provider.dart';
import '../providers/conversation_expense_provider.dart';
import '../models/chat_message.dart' as app;
import '../models/message_attachments.dart';
import '../widgets/enhanced_user_message_bubble.dart';
import '../widgets/chat_conversation_drawer.dart';
import '../widgets/welcome/welcome_guide_widget.dart';
import 'package:augo/i18n/strings.g.dart';

class AIChatPage extends ConsumerStatefulWidget {
  final String? conversationId; // 从 GoRouter 获取
  const AIChatPage({super.key, this.conversationId});

  @override
  ConsumerState<AIChatPage> createState() => _AIChatPageState();
}

class _AIChatPageState extends ConsumerState<AIChatPage> {
  final _logger = Logger('AIChatPage');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _logger.info(
      "DEBUG: AIChatPage initState called. conversationId: ${widget.conversationId}",
    );
    // 当 Widget 第一次被插入到树中时，根据传入的 conversationId 加载初始数据。
    // 使用 addPostFrameCallback 确保在第一帧渲染后安全地与 Provider 交互。
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _logger.info(
        "AIChatPage(initState): Initializing with conversationId: ${widget.conversationId}",
      );
      _loadDataForCurrentRoute();
    });
  }

  @override
  void didUpdateWidget(covariant AIChatPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _logger.info(
      "DEBUG: AIChatPage didUpdateWidget called. oldConversationId: ${oldWidget.conversationId}, newConversationId: ${widget.conversationId}",
    );
    // 当 GoRouter 改变路由导致这个 Widget 的参数变化时，此方法被调用。
    // 我们比较新旧 conversationId。
    // 当路由变化导致 Widget 更新时 (例如从 /ai/123 导航到 /ai/456)
    // 重新加载数据
    if (widget.conversationId != oldWidget.conversationId) {
      _logger.info(
        "AIChatPage(didUpdateWidget): conversationId changed from ${oldWidget.conversationId} to ${widget.conversationId}. Reloading data.",
      );
      _loadDataForCurrentRoute();
    }
  }

  void _loadDataForCurrentRoute() {
    _logger.info(
      "DEBUG: _loadDataForCurrentRoute called. Current widget.conversationId: ${widget.conversationId}",
    );
    final notifier = ref.read(chatHistoryProvider.notifier);
    // 如果路由提供了 conversationId，就加载它。
    // 添加一个检查，避免在ID相同时重复加载。
    if (widget.conversationId != null) {
      // 如果有ID，加载对应的会话
      notifier.loadConversation(widget.conversationId!);
    } else {
      // 如果没有ID，检查当前 Notifier 中是否有会话，如果没有则创建新的
      // 如果路由是 /ai (conversationId 为 null)，
      // 检查 Notifier 是否已经有一个会话。如果没有，则创建一个新的。
      // 这处理了“新建聊天”和应用首次启动进入 /ai 的情况。
      final currentConvId = ref.read(chatHistoryProvider).currentConversationId;
      if (currentConvId == null) {
        notifier.createNewConversation();
      }
    }
  }

  // 显示原生 Drawer 侧边栏
  void _showSidebar() {
    _logger.info("DEBUG: _showSidebar called, opening drawer");
    _scaffoldKey.currentState?.openDrawer();
  }

  /// 获取消息的可复制内容
  /// 返回 CopyResult 包含复制内容和提示消息
  ({String content, String message}) _getCopyableContent(
    app.ChatMessage message,
    ChatHistory notifier,
  ) {
    // 1. 如果有纯文本内容，直接返回
    if (message.content.trim().isNotEmpty) {
      return (content: message.content, message: '内容已复制');
    }

    // 2. 如果有 GenUI 组件数据（历史消息），复制 JSON 数据
    if (message.uiComponents.isNotEmpty) {
      try {
        // 将所有 UI 组件数据合并为 JSON
        final componentsData = message.uiComponents
            .map(
              (comp) => {
                'componentType': comp.componentType,
                'surfaceId': comp.surfaceId,
                'data': comp.data,
                if (comp.userSelection != null)
                  'userSelection': comp.userSelection,
              },
            )
            .toList();

        final jsonString = const JsonEncoder.withIndent('  ').convert(
          componentsData.length == 1 ? componentsData.first : componentsData,
        );
        return (content: jsonString, message: 'JSON 数据已复制');
      } catch (e) {
        _logger.info('Failed to serialize UI components: $e');
      }
    }

    // 3. 如果有 surfaceIds（实时消息），从 GenUI Host 获取数据
    if (message.surfaceIds.isNotEmpty) {
      try {
        final genUiHost = notifier.genUiHost;
        if (genUiHost != null) {
          final surfaceDataList = <Map<String, dynamic>>[];

          for (final surfaceId in message.surfaceIds) {
            // 尝试从 GenUI Host 获取 surface 的 UiDefinition
            final surfaceNotifier = genUiHost.getSurfaceNotifier(surfaceId);
            final uiDefinition = surfaceNotifier.value;

            if (uiDefinition != null) {
              // 提取组件数据
              final components = uiDefinition.components;
              if (components.isNotEmpty) {
                for (final entry in components.entries) {
                  surfaceDataList.add({
                    'surfaceId': surfaceId,
                    'componentId': entry.key,
                    'componentProperties': entry.value.componentProperties,
                  });
                }
              }
            }
          }

          if (surfaceDataList.isNotEmpty) {
            final jsonString = const JsonEncoder.withIndent('  ').convert(
              surfaceDataList.length == 1
                  ? surfaceDataList.first
                  : surfaceDataList,
            );
            return (content: jsonString, message: 'JSON 数据已复制');
          }
        }
      } catch (e) {
        _logger.info('Failed to get surface data from GenUI Host: $e');
      }
    }

    // 4. 无可复制内容
    return (content: '', message: '');
  }

  /// Build AI message with GenUI support
  Widget _buildAiMessageWithGenUi(
    BuildContext context,
    app.ChatMessage message,
    ChatHistory notifier,
  ) {
    final theme = context.theme;
    final genUiHost = notifier.genUiHost;

    // If GenUI is not available, show error
    if (genUiHost == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const GenUiCompactErrorWidget(errorMessage: 'GenUI 服务未初始化'),
            const SizedBox(height: 8),
            if (message.content.isNotEmpty)
              Text(message.content, style: theme.typography.base),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Message content with GenUI surfaces
        ChatMessageWidget(message: message, genUiHost: genUiHost),

        // Action buttons for completed messages
        if (message.streamingStatus == app.StreamingStatus.completed ||
            message.streamingStatus == app.StreamingStatus.error)
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 8.0,
            ),
            child: _buildActionButtons(context, message, notifier),
          ),
      ],
    );
  }

  /// Build action buttons for AI messages - 简洁设计，无背景
  Widget _buildActionButtons(
    BuildContext context,
    app.ChatMessage message,
    ChatHistory notifier,
  ) {
    final theme = context.theme;
    final colors = theme.colors;

    // 构建单个操作图标按钮 - 无背景
    Widget buildIconButton({
      required IconData icon,
      required VoidCallback? onTap,
      Color? color,
      bool isFirst = false,
    }) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: EdgeInsets.only(
            left: isFirst ? 0 : 20, // 增大间距
            right: 0,
            top: 4,
            bottom: 4,
          ),
          child: Icon(icon, color: color ?? colors.mutedForeground, size: 16),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 复制按钮 - 第一个，左侧无 padding
        buildIconButton(
          icon: FIcons.copy,
          isFirst: true,
          onTap: () async {
            // 智能复制逻辑：
            // 1. 纯文本 -> 复制 content
            // 2. GenUI 组件 -> 复制 JSON 数据
            // 3. 无内容 -> 提示
            final copyResult = _getCopyableContent(message, notifier);

            if (copyResult.content.isEmpty) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('没有可以复制的内容'),
                    behavior: SnackBarBehavior.fixed,
                    shape: RoundedRectangleBorder(),
                  ),
                );
              }
              return;
            }

            await Clipboard.setData(ClipboardData(text: copyResult.content));
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(copyResult.message),
                  behavior: SnackBarBehavior.fixed,
                  shape: const RoundedRectangleBorder(),
                ),
              );
            }
          },
        ),
        // 点赞按钮
        buildIconButton(
          icon: FIcons.thumbsUp,
          onTap: () =>
              notifier.updateAIFeedback(message.id, app.AIFeedbackStatus.liked),
          color: message.feedbackStatus == app.AIFeedbackStatus.liked
              ? colors.primary
              : colors.mutedForeground,
        ),
        // 点踩按钮
        buildIconButton(
          icon: FIcons.thumbsDown,
          onTap: () => notifier.updateAIFeedback(
            message.id,
            app.AIFeedbackStatus.disliked,
          ),
          color: message.feedbackStatus == app.AIFeedbackStatus.disliked
              ? colors.primary
              : colors.mutedForeground,
        ),
        // 分享按钮
        buildIconButton(
          icon: FIcons.share2,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('分享功能开发中...'),
                duration: Duration(seconds: 1),
                behavior: SnackBarBehavior.fixed,
                shape: RoundedRectangleBorder(),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;
    final chatHistoryState = ref.watch(chatHistoryProvider);
    final messages = chatHistoryState.messages;
    final chatHistoryNotifier = ref.read(chatHistoryProvider.notifier);

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      drawer: const ChatConversationDrawer(),
      backgroundColor: theme.colors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colors.background,
        foregroundColor: colors.foreground,
        leading: FButton.icon(
          style: FButtonStyle.ghost(),
          onPress: _showSidebar,
          child: const Icon(FIcons.menu),
        ),
        // [REFACTORED] 使用今日消费统计替代动态对话标题
        // 财务 Agent 不需要 chatbot 风格的标题
        title: GestureDetector(
          onTap: _showSidebar,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  ref.watch(conversationExpenseTitleProvider),
                  style: theme.typography.xl.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          FButton.icon(
            style: FButtonStyle.ghost(),
            onPress: () {
              ref.read(chatHistoryProvider.notifier).createNewConversation();
              context.go('/ai');
            },
            child: const Icon(FIcons.plus),
          ),
        ],
      ),
      body: Column(
        children: [
          // --- DEBUG INFO START ---
          // Container(
          //   padding: const EdgeInsets.all(8.0),
          //   color: Colors.yellow.withOpacity(0.2),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text('Debug Info:', style: TextStyle(fontWeight: FontWeight.bold)),
          //       Text('Conversation ID: ${widget.conversationId ?? 'N/A'}'),
          //       Text('Is Loading History: ${chatHistoryState.isLoadingHistory}'),
          //       Text('History Error: ${chatHistoryState.historyError ?? 'None'}'),
          //       Text('Messages Count: ${messages.length}'),
          //     ],
          //   ),
          // ),
          // --- DEBUG INFO END ---
          Expanded(
            child: messages.isEmpty && !chatHistoryState.isLoadingHistory
                ? chatHistoryState.historyError != null
                      ? Center(
                          child: Text(
                            '${t.chat.loadingFailed}: ${chatHistoryState.historyError}',
                            style: theme.typography.base,
                          ),
                        )
                      : WelcomeGuideWidget(
                          onSuggestionTap: (prompt) {
                            chatHistoryNotifier.addUserMessageAndGetResponse(
                              prompt,
                            );
                          },
                        )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[messages.length - 1 - index];

                      // 根据消息发送者和类型选择合适的消息气泡
                      switch (message.sender) {
                        case app.MessageSender.user:
                          return UserMessageBubble(message: message);

                        case app.MessageSender.ai:
                        case app.MessageSender.assistant:
                        default:
                          // AI message with GenUI support
                          // CRITICAL: KeyedSubtree is required to force widget rebuild when message state changes
                          // The key must include ALL fields that affect rendering to ensure proper streaming updates
                          // Without this, Flutter may batch updates and only render final state
                          return KeyedSubtree(
                            key: ValueKey(
                              '${message.id}_${message.fullContent.length}',
                            ),
                            child: _buildAiMessageWithGenUi(
                              context,
                              message,
                              chatHistoryNotifier,
                            ),
                          );
                      }
                    },
                  ),
          ),
        ],
      ),
      // 完全复制交易详情页面的做法
      bottomNavigationBar: ChatInputField(
        onSendMessage:
            (String text, {List<PendingMessageAttachment>? attachments}) {
              return chatHistoryNotifier.addUserMessageAndGetResponse(
                text,
                attachments: attachments,
              );
            },
      ),
    );
  }
}
