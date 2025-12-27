// features/chat/services/conversation_manager.dart
//
// Conversation Manager
// Extracted from ChatHistory to manage conversation lifecycle
//
// Design Principles:
// - Handles session initialization and title updates
// - Manages conversation loading and creation
// - Provides clean interface for conversation state
//

import 'package:logging/logging.dart';

import '../models/chat_message.dart';
import '../models/conversation_info.dart';

final _logger = Logger('ConversationManager');

/// Callbacks for conversation events
typedef OnStateChangedCallback = void Function(ConversationStateUpdate update);
typedef OnSessionAddedCallback = void Function(ConversationInfo session);
typedef OnTitleUpdatedCallback =
    void Function(String conversationId, String title);

/// State update model
class ConversationStateUpdate {
  final String? conversationId;
  final String? title;
  final List<ChatMessage>? messages;
  final bool? isLoading;
  final bool? isStreaming;
  final String? error;

  const ConversationStateUpdate({
    this.conversationId,
    this.title,
    this.messages,
    this.isLoading,
    this.isStreaming,
    this.error,
  });
}

/// Conversation Manager
///
/// Manages conversation lifecycle including:
/// - Session initialization
/// - Title updates
/// - Conversation loading state
class ConversationManager {
  /// Current conversation ID
  String? _currentConversationId;

  /// Current conversation title
  String? _currentTitle;

  /// Pending message title fragments (for incremental updates)
  String _titleFragment = '';

  /// Callbacks
  final OnStateChangedCallback onStateChanged;
  final OnSessionAddedCallback onSessionAdded;
  final OnTitleUpdatedCallback onTitleUpdated;

  ConversationManager({
    required this.onStateChanged,
    required this.onSessionAdded,
    required this.onTitleUpdated,
  });

  // ============================================================
  // Public Getters
  // ============================================================

  String? get currentConversationId => _currentConversationId;
  String? get currentTitle => _currentTitle;

  // ============================================================
  // Public Methods - Session Management
  // ============================================================

  /// Handle session initialization event
  ///
  /// Called when receiving a new session ID from the server
  void handleSessionInit({
    required String sessionId,
    String? messageId,
    String? currentStateConversationId,
  }) {
    _logger.info(
      'ConversationManager: Session init - sessionId: $sessionId, messageId: $messageId',
    );

    // Detect if this is a newly established session
    final isNewSession =
        currentStateConversationId == null ||
        currentStateConversationId.isEmpty;

    if (isNewSession) {
      _currentConversationId = sessionId;

      // Notify about new session
      final newTitle = _currentTitle ?? 'New Chat';
      _logger.info(
        'ConversationManager: Adding new session: $sessionId, title: $newTitle',
      );

      onSessionAdded(
        ConversationInfo(
          id: sessionId,
          title: newTitle,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      onStateChanged(ConversationStateUpdate(conversationId: sessionId));
    } else if (currentStateConversationId != sessionId) {
      _logger.warning(
        'ConversationManager: Session ID mismatch. '
        'State: $currentStateConversationId, Received: $sessionId',
      );
    }
  }

  /// Handle title update event
  void handleTitleUpdate(String title, String? conversationId) {
    _logger.info('ConversationManager: Title update: $title');

    _currentTitle = title;

    // Update state
    onStateChanged(ConversationStateUpdate(title: title));

    // Update sidebar list
    if (conversationId != null) {
      onTitleUpdated(conversationId, title);
    }
  }

  /// Prepare for new conversation
  void prepareNewConversation() {
    _currentConversationId = null;
    _currentTitle = null;
    _titleFragment = '';

    _logger.info('ConversationManager: Prepared for new conversation');
  }

  /// Set conversation context for loading
  void setConversationContext(String conversationId, {String? title}) {
    _currentConversationId = conversationId;
    _currentTitle = title;

    _logger.info(
      'ConversationManager: Set context - id: $conversationId, title: $title',
    );
  }

  /// Clear current conversation context
  void clearContext() {
    _currentConversationId = null;
    _currentTitle = null;
    _titleFragment = '';
  }

  // ============================================================
  // Public Methods - Title Fragment Handling
  // ============================================================

  /// Append to title fragment (for incremental title updates)
  void appendTitleFragment(String fragment) {
    _titleFragment += fragment;
  }

  /// Get and clear title fragment
  String consumeTitleFragment() {
    final fragment = _titleFragment;
    _titleFragment = '';
    return fragment;
  }
}
