import 'dart:async';
import 'package:logging/logging.dart';

import 'package:uuid/uuid.dart';

import '../models/chat_message.dart';
// import '../models/message_sender.dart'; // Removed invalid import
import '../models/message_attachments.dart';
import '../models/chat_message_attachment.dart';
import '../repositories/message_repository.dart';
import '../state_controllers/streaming_controller.dart';
import '../services/genui_lifecycle_manager.dart';
import '../services/data_uri_service.dart';

final _logger = Logger('ChatInteractionManager');

/// Chat Interaction Manager
///
/// Responsibilities:
/// - Handles user message input and optimistic UI updates
/// - Constructs payload (text + attachments)
/// - Initiates GenUI requests
/// - Coordinates with StreamingController for stream lifecycle
class ChatInteractionManager {
  final MessageRepository _messageRepository;
  final GenUiLifecycleManager _genUiLifecycleManager;
  final StreamingController _streamingController;

  final Uuid _uuid = const Uuid();

  // Callbacks
  final void Function(bool isStreaming) _setStreamingStatus;
  final String Function() _getCurrentConversationId;

  ChatInteractionManager({
    required MessageRepository messageRepository,
    required GenUiLifecycleManager genUiLifecycleManager,
    required StreamingController streamingController,
    required DataUriService
    dataUriService, // kept for DI but unused (static methods)
    required void Function(bool) setStreamingStatus,
    required String Function() getCurrentConversationId,
    required String Function()
    getCurrentConversationTitle, // kept for DI but unused
  }) : _messageRepository = messageRepository,
       _genUiLifecycleManager = genUiLifecycleManager,
       _streamingController = streamingController,
       _setStreamingStatus = setStreamingStatus,
       _getCurrentConversationId = getCurrentConversationId;

  // Note: DataUriService methods are static in the file seen previously.
  // But usage in Notifier was ref.read(dataUriServiceProvider).
  // If DataUriService has static methods, we don't need an instance.
  // Let's assume we use static methods if possible, or instance if provider returns instance.
  // Code view of DataUriService showed static methods.
  // But Notifier passes `ref.read(dataUriServiceProvider)`.
  // I will check if I should use static calls or instance calls.
  // Step 913 view: class DataUriService { static ... }
  // It has NO instance methods. It's a utility class.
  // So constructor injection is weird if it's static.
  // But let's keep the field in case it changes or for testing mocking.
  // Actually, I should just call DataUriService.convert...

  /// User sends a message, triggering AI response flow
  Future<void> addUserMessageAndGetResponse(
    String text, {
    List<PendingMessageAttachment>? attachments,
  }) async {
    final attachmentList = attachments ?? const <PendingMessageAttachment>[];
    if (text.trim().isEmpty && attachmentList.isEmpty) {
      _logger.info("ChatInteractionManager: Empty message, returning");
      return;
    }

    // 1. Cancel previous stream
    _logger.info(
      "ChatInteractionManager: Cancelling previous stream and timers...",
    );
    await _streamingController.cancelStreamAndTimers();

    // 2. Generate IDs
    final messageId = _uuid.v4();
    final aiMessageId = _uuid.v4();

    // 3. Reset streaming state for new message
    _streamingController.resetForNewMessage(aiMessageId);

    // 4. Create user message
    // 注意：需要提供 signedUrl 以便在 UI 中显示图片预览
    // 对于用户刚发送的消息，使用后端返回的 view URL
    final userAttachments = attachmentList.map((a) {
      _logger.info(
        'ChatInteractionManager: Creating attachment - id=${a.uploadInfo.attachmentId}, uri=${a.uploadInfo.uri}',
      );
      return ChatMessageAttachment(
        id: a.uploadInfo.attachmentId,
        filename: a.file.name,
        // 使用后端返回的 uri 作为 signedUrl（新的渲染逻辑会自动检测并渲染）
        signedUrl: a.uploadInfo.uri,
      );
    }).toList();

    _logger.info(
      'ChatInteractionManager: Created ${userAttachments.length} attachments for user message',
    );

    final userMessage = ChatMessage(
      id: messageId,
      content: text,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
      attachments: userAttachments,
    );

    // 5. Create AI placeholder
    final aiMessagePlaceholder = ChatMessage(
      id: aiMessageId,
      content: '', // Empty initially
      sender: MessageSender.ai,
      timestamp: DateTime.now(),
      isTyping: true, // Optimistic update
      streamingStatus: StreamingStatus.streaming,
    );

    // 6. Update Repository (triggers UI update via Notifier)
    _messageRepository.addMessages([userMessage, aiMessagePlaceholder]);

    // 7. Update streaming status
    _setStreamingStatus(true);

    // 8. Start Initial Delay Timer (Thinking indicator logic)
    _streamingController.startInitialDelayTimer();

    // 9. Send Request
    unawaited(_sendRequestInternal(text, aiMessageId, attachmentList));
  }

  /// Handle optimistic user message (triggered internally by GenUI components)
  ///
  /// If content starts with [GENUI_INTERNAL], it means the request is already
  /// being sent by CustomContentGenerator.sendRequest(), so we only add the
  /// user message to UI without sending a duplicate request.
  Future<void> handleOptimisticUserMessage(String content) async {
    if (content.isEmpty) return;

    // Check for GenUI internal marker
    const marker = '[GENUI_INTERNAL]';
    final bool isInternalEvent = content.startsWith(marker);
    final String displayContent = isInternalEvent
        ? content.substring(marker.length)
        : content;

    _logger.info(
      'ChatInteractionManager: Handling optimistic user message: $displayContent (internal: $isInternalEvent)',
    );

    // Similar flow to addUserMessageAndGetResponse but simpler
    await _streamingController.cancelStreamAndTimers();

    final messageId = _uuid.v4();
    final aiMessageId = _uuid.v4();

    _streamingController.resetForNewMessage(aiMessageId);

    final userMessage = ChatMessage(
      id: messageId,
      content: displayContent,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
    );

    final aiMessagePlaceholder = ChatMessage(
      id: aiMessageId,
      content: '',
      sender: MessageSender.ai,
      timestamp: DateTime.now(),
      isTyping: true,
      streamingStatus: StreamingStatus.streaming,
    );

    _messageRepository.addMessages([userMessage, aiMessagePlaceholder]);

    _setStreamingStatus(true);
    _streamingController.startInitialDelayTimer();

    // CRITICAL: Only send request for regular messages, NOT for internal events
    // (internal events are already being sent by CustomContentGenerator.sendRequest)
    if (!isInternalEvent) {
      unawaited(_sendRequestInternal(displayContent, aiMessageId, const []));
    }
  }

  /// Internal method to process attachments and send request
  Future<void> _sendRequestInternal(
    String text,
    String aiMessageId,
    List<PendingMessageAttachment> attachments,
  ) async {
    try {
      final genUiService = _genUiLifecycleManager.service;

      // Check service availability
      if (genUiService == null || !_genUiLifecycleManager.isInitialized) {
        _logger.info("ChatInteractionManager: GenUI service not available");
        _streamingController.handleStreamError("服务未初始化，请刷新重试");
        _setStreamingStatus(false);
        return;
      }

      // Check session consistency
      final conversationId = _getCurrentConversationId();
      if (conversationId.isNotEmpty) {
        genUiService.conversation.setSessionId(conversationId);
      }

      // Prepare attachments
      List<Map<String, dynamic>>? attachmentPayload;
      if (attachments.isNotEmpty) {
        _logger.info(
          "ChatInteractionManager: Processing ${attachments.length} attachments...",
        );
        // Convert to Data URI format using static method
        final dataUriFiles = await DataUriService.convertFilesToDataUri(
          attachments.map((a) => a.file).toList(),
          uploadedInfos: attachments.map((a) => a.uploadInfo).toList(),
        );

        if (dataUriFiles.length != attachments.length) {
          _logger.warning(
            "ChatInteractionManager: Warning - Attachment count mismatch after conversion",
          );
        }

        attachmentPayload = dataUriFiles
            .map(
              (f) => {
                'id': f.attachmentId ?? _uuid.v4(),
                'type': f.mimeType,
                'data': f.dataUri,
              },
            )
            .toList();
      }

      _logger.info(
        "ChatInteractionManager: Calling GenUI service sendRequest...",
      );

      await genUiService.conversation.sendRequestWithAttachments(
        text,
        attachments: attachmentPayload,
      );

      _logger.info("ChatInteractionManager: Request sent successfully");
    } catch (e, stackTrace) {
      _logger.severe(
        "ChatInteractionManager: Error sending request",
        e,
        stackTrace,
      );
      _streamingController.handleStreamError(e);
      _setStreamingStatus(false);
    }
  }
}
