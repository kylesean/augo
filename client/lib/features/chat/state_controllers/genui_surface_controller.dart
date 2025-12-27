// features/chat/state_controllers/genui_surface_controller.dart
//
// GenUI Surface Controller
// Extracted from ChatHistory to handle GenUI surface lifecycle events
//
// Design Principles:
// - Standalone controller class for cleaner separation of concerns
// - Uses callbacks to communicate with host (ChatHistory)
// - Encapsulates all surface-related state tracking
//

import 'package:logging/logging.dart';
import 'package:genui/genui.dart' as genui;
import '../models/genui_surface_info.dart';
import '../services/genui_logger.dart';

final _logger = Logger('GenUiSurfaceController');

/// Callbacks for GenUI surface control
typedef OnSurfaceAddedToMessageCallback =
    void Function(String messageId, String surfaceId);
typedef OnFirstChunkReceivedCallback = void Function();
typedef GetCurrentStreamingMessageIdCallback = String Function();
typedef GetLastAiMessageIdCallback = String? Function();

/// Error transformation result
class UserFriendlyError {
  final String message;
  final String originalError;

  const UserFriendlyError({required this.message, required this.originalError});
}

/// GenUI Surface Controller
///
/// Manages GenUI surface lifecycle events, including:
/// - Surface creation and tracking
/// - Surface updates and removal
/// - Error message transformation
class GenUiSurfaceController {
  /// Track surface information for messages
  final Map<String, List<GenUiSurfaceInfo>> _messageSurfaces = {};

  /// Callback when surface should be added to message
  final OnSurfaceAddedToMessageCallback onSurfaceAddedToMessage;

  /// Callback when first chunk is received (for silent mode detection)
  final OnFirstChunkReceivedCallback onFirstChunkReceived;

  /// Callback to get current streaming message ID
  final GetCurrentStreamingMessageIdCallback getCurrentStreamingMessageId;

  /// Callback to get last AI message ID (for resume flow)
  final GetLastAiMessageIdCallback getLastAiMessageId;

  GenUiSurfaceController({
    required this.onSurfaceAddedToMessage,
    required this.onFirstChunkReceived,
    required this.getCurrentStreamingMessageId,
    required this.getLastAiMessageId,
  });

  // ============================================================
  // Public Methods - Surface Lifecycle
  // ============================================================

  /// Handle surface added event from GenUI
  void handleSurfaceAdded(genui.SurfaceAdded event) {
    _logger.info('GenUiSurfaceController: Surface added - ${event.surfaceId}');

    // Skip historical surfaces - they are already in the message's surfaceIds
    if (event.surfaceId.startsWith('history_')) {
      _logger.info(
        'GenUiSurfaceController: Skipping historical surface ${event.surfaceId} (already processed)',
      );
      return;
    }

    final messageId = _resolveMessageId(event.surfaceId);
    if (messageId == null) return;

    _trackSurface(messageId, event.surfaceId);
    onSurfaceAddedToMessage(messageId, event.surfaceId);
  }

  /// Unified entry: Handle SurfaceUpdate created surface (Requirement 7.3, 7.4)
  /// Shares the same add logic with handleSurfaceAdded
  void handleSurfaceIdAdded(String surfaceId, {bool markAsFirstChunk = true}) {
    _logger.info(
      'GenUiSurfaceController: ========== UNIFIED SURFACE ENTRY ==========',
    );
    _logger.info('GenUiSurfaceController: Surface ID added - $surfaceId');

    final messageId = _resolveMessageId(surfaceId);
    if (messageId == null) return;

    // Mark first chunk received for silent mode detection
    if (markAsFirstChunk) {
      _logger.info(
        'GenUiSurfaceController: Silent mode - UI component received',
      );
      onFirstChunkReceived();
    }

    _trackSurface(messageId, surfaceId);
    onSurfaceAddedToMessage(messageId, surfaceId);

    _logger.info(
      'GenUiSurfaceController: ========== SURFACE ENTRY COMPLETE ==========',
    );
  }

  /// Handle surface updated event from GenUI
  void handleSurfaceUpdated(genui.SurfaceUpdated event) {
    _logger.info(
      'GenUiSurfaceController: Surface updated - ${event.surfaceId}',
    );

    for (final surfaces in _messageSurfaces.values) {
      final index = surfaces.indexWhere((s) => s.surfaceId == event.surfaceId);
      if (index != -1) {
        surfaces[index] = surfaces[index].copyWith(
          updatedAt: DateTime.now(),
          status: SurfaceStatus.ready,
        );
        break;
      }
    }
  }

  /// Handle surface removed event from GenUI
  void handleSurfaceRemoved(genui.SurfaceRemoved event) {
    _logger.info(
      'GenUiSurfaceController: Surface removed - ${event.surfaceId}',
    );

    for (final surfaces in _messageSurfaces.values) {
      final index = surfaces.indexWhere((s) => s.surfaceId == event.surfaceId);
      if (index != -1) {
        surfaces[index] = surfaces[index].copyWith(
          status: SurfaceStatus.removed,
        );
        break;
      }
    }
  }

  // ============================================================
  // Public Methods - Error Handling
  // ============================================================

  /// Transform technical error to user-friendly message
  static UserFriendlyError transformError(String error) {
    String userFriendlyMessage;

    if (error.contains('No generations') || error.contains('empty stream')) {
      userFriendlyMessage =
          'Service is temporarily busy, please try again later';
    } else if (error.contains('timeout') || error.contains('Timeout')) {
      userFriendlyMessage = 'Request timed out, please check network and retry';
    } else if (error.contains('network') || error.contains('connection')) {
      userFriendlyMessage = 'Network connection issue, please check and retry';
    } else if (error.contains('Authentication') || error.contains('token')) {
      userFriendlyMessage = 'Session expired, please log in again';
    } else {
      userFriendlyMessage = 'Something went wrong, please try again 🙏';
    }

    return UserFriendlyError(
      message: userFriendlyMessage,
      originalError: error,
    );
  }

  // ============================================================
  // Public Methods - Surface Management
  // ============================================================

  /// Get surfaces for a specific message
  List<GenUiSurfaceInfo> getSurfacesForMessage(String messageId) {
    return _messageSurfaces[messageId] ?? [];
  }

  /// Cleanup surfaces for a specific message
  void cleanupMessageSurfaces(String messageId) {
    _messageSurfaces.remove(messageId);
    _logger.info(
      'GenUiSurfaceController: Cleaned up surfaces for message $messageId',
    );
  }

  /// Clear all tracked surfaces
  void clearAllSurfaces() {
    _messageSurfaces.clear();
    _logger.info('GenUiSurfaceController: Cleared all surfaces');
  }

  // ============================================================
  // Private Methods
  // ============================================================

  /// Resolve which message a surface belongs to
  String? _resolveMessageId(String surfaceId) {
    String messageId = getCurrentStreamingMessageId();

    if (messageId.isEmpty) {
      _logger.info(
        'GenUiSurfaceController: No current streaming message, searching for last AI message',
      );
      messageId = getLastAiMessageId() ?? '';

      if (messageId.isNotEmpty) {
        _logger.info(
          'GenUiSurfaceController: Using last AI message $messageId for surface $surfaceId',
        );
      }
    } else {
      _logger.info(
        'GenUiSurfaceController: Using current streaming message $messageId for surface $surfaceId',
      );
    }

    if (messageId.isEmpty) {
      _logger.info(
        'GenUiSurfaceController: ⚠️ No AI message found for surface $surfaceId',
      );
      return null;
    }

    return messageId;
  }

  /// Track surface info internally
  void _trackSurface(String messageId, String surfaceId) {
    GenUiLogger.logSurfaceLifecycle(
      event: 'added',
      surfaceId: surfaceId,
      messageId: messageId,
    );

    final surfaceInfo = GenUiSurfaceInfo(
      surfaceId: surfaceId,
      messageId: messageId,
      createdAt: DateTime.now(),
      status: SurfaceStatus.loading,
    );

    _messageSurfaces.putIfAbsent(messageId, () => []).add(surfaceInfo);
    _logger.info(
      'GenUiSurfaceController: ✓ Surface info tracked for message $messageId',
    );
  }
}
