// features/chat/services/attachment_manager.dart
//
// Attachment Manager
// Extracted from ChatHistory to manage file attachments
//
// Responsibilities:
// - Fetch signed URLs for attachments
// - Manage attachment loading states
// - Integrate with FileAttachmentService and MessageRepository
//

import 'dart:async';
import 'package:logging/logging.dart';

import '../models/chat_message_attachment.dart';
import '../repositories/message_repository.dart';
import '../services/file_attachment_service.dart';
import '../../../core/network/exceptions/app_exception.dart';

final _logger = Logger('AttachmentManager');

/// Attachment Manager
class AttachmentManager {
  final FileAttachmentService _fileAttachmentService;
  final MessageRepository _messageRepository;

  // Track messages with attachment fetch in flight to prevent duplicate requests
  final Set<String> _messagesWithAttachmentFetchInFlight = {};

  AttachmentManager({
    required FileAttachmentService fileAttachmentService,
    required MessageRepository messageRepository,
  }) : _fileAttachmentService = fileAttachmentService,
       _messageRepository = messageRepository;

  // ============================================================
  // Public Methods
  // ============================================================

  /// Check and fetch signed URLs for attachments if needed
  Future<void> fetchSignedUrlsForMessage(
    String messageId,
    List<ChatMessageAttachment> attachments, {
    bool forceFetch = false,
  }) async {
    // Check if any attachment needs signed URL
    final needsFetch = forceFetch || attachments.any((a) => _isUrlExpired(a));

    if (!needsFetch) {
      return;
    }

    if (_messagesWithAttachmentFetchInFlight.contains(messageId)) {
      return;
    }

    _messagesWithAttachmentFetchInFlight.add(messageId);
    _logger.info(
      "AttachmentManager: Fetching signed URLs for message $messageId",
    );

    try {
      // Set status to loading
      _setAttachmentStatuses(
        messageId: messageId,
        attachmentIds: attachments.map((a) => a.id).toSet(),
        status: AttachmentLoadStatus.loading,
      );

      // Fetch new URLs
      final result = await _fileAttachmentService.fetchSignedUrls(attachments);

      // Create map for easy lookup
      final successMap = {for (var item in result.successful) item.id: item};
      // Try ID first, fall back to filename for failures
      final failureMap = {
        for (var item in result.failed) item.id ?? item.filename: item,
      };

      // Update attachments
      final currentMessage = _messageRepository.findById(messageId);
      if (currentMessage == null) return;

      final updatedAttachments = currentMessage.attachments.map((attachment) {
        // Check success first
        if (successMap.containsKey(attachment.id)) {
          final info = successMap[attachment.id]!;
          return attachment.copyWith(
            signedUrl: info.signedUrl,
            expiresAt: info.expiresAt,
            status: AttachmentLoadStatus.loaded,
            errorMessage: null,
          );
        }

        // Check failure
        final failureKey = failureMap.containsKey(attachment.id)
            ? attachment.id
            : attachment.filename;
        if (failureMap.containsKey(failureKey)) {
          final failure = failureMap[failureKey]!;
          return attachment.copyWith(
            status: AttachmentLoadStatus.failed,
            errorMessage: failure.displayMessage ?? '加载失败',
          );
        }

        // No result for this attachment, keep as is
        return attachment;
      }).toList();

      // Save updates
      _messageRepository.replaceMessageAt(
        _messageRepository.indexOfId(messageId),
        currentMessage.copyWith(attachments: updatedAttachments),
      );
    } catch (e, stackTrace) {
      _logger.severe(
        "AttachmentManager: Failed to fetch signed urls for $messageId",
        e,
        stackTrace,
      );
      final errorMessage = e is AppException ? e.message : e.toString();

      _setAttachmentStatuses(
        messageId: messageId,
        attachmentIds: attachments.map((a) => a.id).toSet(),
        status: AttachmentLoadStatus.failed,
        errorMessage: errorMessage,
      );
    } finally {
      _messagesWithAttachmentFetchInFlight.remove(messageId);
    }
  }

  // ============================================================
  // Private Helpers
  // ============================================================

  bool _isUrlExpired(ChatMessageAttachment attachment) {
    if (attachment.signedUrl == null || attachment.signedUrl!.isEmpty) {
      return true;
    }
    if (attachment.expiresAt == null) {
      return true; // Assume expired if no expiry time
    }
    // Buffer of 5 minutes
    return attachment.expiresAt!.isBefore(
      DateTime.now().add(const Duration(minutes: 5)),
    );
  }

  void _setAttachmentStatuses({
    required String messageId,
    required Set<String> attachmentIds,
    required AttachmentLoadStatus status,
    String? errorMessage,
  }) {
    final index = _messageRepository.indexOfId(messageId);
    if (index == -1) return;

    _messageRepository.setAttachmentStatuses(
      messageIndex: index,
      attachmentIds: attachmentIds,
      status: status,
      errorMessage: errorMessage,
    );
  }
}
