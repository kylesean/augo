import 'package:logging/logging.dart';
import 'package:genui/genui.dart' as genui;
import 'custom_content_generator.dart';

final _logger = Logger('ExtendedGenUiConversation');

/// Extended GenUI conversation manager
///
/// Encapsulates GenUI 0.6.0's core Facade and Host logic.
class ExtendedGenUiConversation {
  final CustomContentGenerator _customGenerator;
  // ignore: unused_field - configured through constructor callbacks
  final genui.GenUiConversation _conversation;
  final genui.A2uiMessageProcessor _host;
  String? _currentSessionId;

  // Callbacks
  final Function(String) _onTextResponse;
  final Function(String, dynamic) _onError;

  ExtendedGenUiConversation({
    required genui.A2uiMessageProcessor host,
    required CustomContentGenerator contentGenerator,
    required Function(String) onSurfaceAdded,
    required Function(String) onSurfaceDeleted,
    required Function(String) onTextResponse,
    required Function(String, dynamic) onError,
    Function(String, String?)? onSessionInit,
  }) : _host = host,
       _customGenerator = contentGenerator,
       _onTextResponse = onTextResponse,
       _onError = onError,
       _conversation = genui.GenUiConversation(
         a2uiMessageProcessor: host,
         contentGenerator: contentGenerator,
         onSurfaceAdded: (event) {
           _logger.info(
             'ExtendedGenUiConversation: Surface added: ${event.surfaceId}',
           );
           onSurfaceAdded(event.surfaceId);
         },
         onSurfaceDeleted: (event) {
           _logger.info(
             'ExtendedGenUiConversation: Surface deleted: ${event.surfaceId}',
           );
           onSurfaceDeleted(event.surfaceId);
         },
       ) {
    // Listen to Session initialization events
    _customGenerator.onSessionInit = (sessionId, messageId) {
      _logger.info(
        'ExtendedGenUiConversation: Session initialized: $sessionId',
      );
      _currentSessionId = sessionId;
      onSessionInit?.call(sessionId, messageId);
    };

    // Listen to text stream
    _customGenerator.onTextChunk = _onTextResponse;

    // Listen to errors (Requirement 2.1)
    _customGenerator.onError = (String error) {
      _onError(error, error);
    };
  }

  /// Get current Session ID
  String? get currentSessionId => _currentSessionId;

  /// Expose the content generator for callback registration
  CustomContentGenerator get contentGenerator => _customGenerator;

  /// Set current Session ID
  void setSessionId(String sessionId) {
    _currentSessionId = sessionId;
    _customGenerator.setSessionId(sessionId);
  }

  /// Send text message (Requirement 1.1)
  Future<void> sendRequest(genui.ChatMessage message) async {
    return _customGenerator.sendRequest(message);
  }

  /// Unified send entry: send message with attachments (Requirement 1.4)
  Future<void> sendRequestWithAttachments(
    String content, {
    List<Map<String, dynamic>>? attachments,
  }) async {
    _logger.info(
      'ExtendedGenUiConversation: Sending request with ${attachments?.length ?? 0} attachments',
    );

    // Call CustomContentGenerator's extended method
    await _customGenerator.sendRequestWithAttachments(
      content,
      sessionId: _currentSessionId,
      attachments: attachments,
    );
  }

  /// Cancel current request
  void cancel() {
    _customGenerator.cancel();
  }

  /// Clear current session
  void clearSession() {
    _currentSessionId = null;
    _customGenerator.clearSessionToken();
  }

  /// Resource release
  void dispose() {
    _customGenerator.dispose();
  }

  /// Compatibility setter for old code
  set onUserMessageSent(Function(String)? callback) {
    _customGenerator.onUserMessageSent = callback;
  }

  /// Expose internal Host (A2uiMessageProcessor) for UI rendering
  genui.GenUiHost get host => _host;
}
