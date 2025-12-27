import 'dart:async';
import 'package:logging/logging.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:genui/genui.dart' as genui;
import 'custom_content_generator.dart';
import 'extended_genui_conversation.dart';
import '../../../core/storage/secure_storage_service.dart';

final _logger = Logger('GenUiService');

// Typedefs (Aligning with potential existing types in project)
typedef OnSessionInit = void Function(String sessionId, String? messageId);
typedef OnStreamComplete = void Function();
typedef OnTitleUpdate = void Function(String title);
typedef OnErrorCallback = void Function(String message, dynamic error);

/// GenUI initialization and configuration service (Requirement 1.1, 1.4)
///
/// Manages the lifecycle of GenUI 0.6.0 components.
class GenUiService {
  genui.A2uiMessageProcessor? _processor;
  ExtendedGenUiConversation? _genUiConversation;
  CustomContentGenerator? _contentGenerator;
  bool _isInitialized = false;

  /// Callbacks for surface lifecycle events
  Function(genui.SurfaceAdded)? _onSurfaceAdded;
  Function(genui.SurfaceRemoved)? _onSurfaceRemoved;
  Function(String)? _onTextResponse;
  Function(String surfaceId)? _onSurfaceIdAdded;

  /// Initialize GenUI with the provided catalog and callbacks
  Future<void> initialize({
    required genui.Catalog catalog,
    required SecureStorageService storageService,
    required String sseBaseUrl,
    required Function(genui.SurfaceAdded) onSurfaceAdded,
    required Function(genui.SurfaceRemoved) onSurfaceRemoved,
    required Function(String) onTextResponse,
    OnSessionInit? onSessionInit,
    OnStreamComplete? onStreamComplete,
    OnTitleUpdate? onTitleUpdate,
    OnErrorCallback? onError,
    Function(String surfaceId)? onSurfaceIdAdded,
    void Function(Map<String, dynamic>)? onTransactionCreated,
    dynamic configuration,
    Dio? dio,
  }) async {
    try {
      _logger.info('GenUiService: Starting initialization');

      _onSurfaceAdded = onSurfaceAdded;
      _onSurfaceRemoved = onSurfaceRemoved;
      _onTextResponse = onTextResponse;
      _onSurfaceIdAdded = onSurfaceIdAdded;

      // GenUI 0.6.0: A2uiMessageProcessor is the implementation of GenUiHost
      _processor = genui.A2uiMessageProcessor(catalogs: [catalog]);
      _logger.info('GenUiService: A2uiMessageProcessor created');

      // Create custom ContentGenerator
      _contentGenerator = CustomContentGenerator(
        storageService,
        dio: dio,
        sseBaseUrl: sseBaseUrl,
      );

      // Wire up callbacks
      _contentGenerator!.onTextChunk = onTextResponse;
      _contentGenerator!.onStreamComplete = onStreamComplete;
      _contentGenerator!.onTitleUpdate = onTitleUpdate;
      _contentGenerator!.onError = (err) {
        _logger.warning('GenUiService: ContentGenerator error - $err');
        onError?.call(err.toString(), err);
      };
      _contentGenerator!.onTransactionCreated = (amount, type, currency) {
        onTransactionCreated?.call({
          'amount': amount,
          'transactionType': type,
          'currency': currency,
        });
      };

      _contentGenerator!.onSurfaceCreated = (String surfaceId) {
        _logger.info(
          'GenUiService: Surface created via SurfaceUpdate - $surfaceId',
        );
        _onSurfaceIdAdded?.call(surfaceId);
      };

      // Create ExtendedGenUiConversation to orchestrate everything
      _genUiConversation = ExtendedGenUiConversation(
        host: _processor!,
        contentGenerator: _contentGenerator!,
        onSurfaceAdded: (surfaceId) {
          // SurfaceAdded constructor is (String surfaceId, UiDefinition content)
          // UiDefinition needs (surfaceId: ..., components: Map<String, Component>)
          _onSurfaceAdded?.call(
            genui.SurfaceAdded(
              surfaceId,
              genui.UiDefinition(surfaceId: surfaceId, components: const {}),
            ),
          );
        },
        onSurfaceDeleted: (surfaceId) {
          // SurfaceRemoved constructor is (String surfaceId)
          _onSurfaceRemoved?.call(genui.SurfaceRemoved(surfaceId));
        },
        onTextResponse: (text) => _onTextResponse?.call(text),
        onError: (message, rawError) => onError?.call(message, rawError),
        onSessionInit: onSessionInit,
      );

      _isInitialized = true;
      _logger.info('GenUiService: Initialization complete');
    } catch (e, stackTrace) {
      _logger.severe('GenUiService: Initialization failed', e, stackTrace);
      _isInitialized = false;
      await _cleanup();
      rethrow;
    }
  }

  /// Send a message to the AI
  Future<void> sendMessage(String message) async {
    if (!_isInitialized || _genUiConversation == null) {
      throw StateError('GenUiService not initialized.');
    }

    // GenUI 0.6.0: Construct UserMessage with positional parts
    final userMessage = genui.UserMessage([genui.TextPart(message)]);

    await _genUiConversation!.sendRequest(userMessage);
  }

  /// Get the ExtendedGenUiConversation instance
  ExtendedGenUiConversation get conversation {
    if (!_isInitialized || _genUiConversation == null) {
      throw StateError('GenUiService not initialized.');
    }
    return _genUiConversation!;
  }

  /// Get the GenUiHost instance (for direct surface manipulation)
  genui.GenUiHost get manager {
    if (!_isInitialized || _processor == null) {
      throw StateError('GenUiService not initialized.');
    }
    return _processor!;
  }

  /// Alias for manager (for backward compatibility)
  genui.GenUiHost get host => manager;

  bool get isInitialized => _isInitialized;

  /// Get a ValueNotifier for a specific surface
  ValueNotifier<genui.UiDefinition?> getSurfaceNotifier(String surfaceId) {
    if (!_isInitialized || _processor == null) {
      throw StateError('GenUiService not initialized.');
    }
    return _processor!.getSurfaceNotifier(surfaceId);
  }

  /// Clear the current session state
  void clearSessionToken() {
    _genUiConversation?.clearSession();
    _logger.info('GenUiService: Session cleared');
  }

  /// Replay historical UI components (Requirement 7.1)
  void replayHistoricalSurface({
    required String surfaceId,
    required String componentType,
    required Map<String, dynamic> data,
  }) {
    if (!_isInitialized || _processor == null) return;

    try {
      // 0.6.0: Construct Component then SurfaceUpdate
      final comp = genui.Component(
        id: surfaceId,
        componentProperties: {componentType: data},
      );

      final surfaceUpdate = genui.SurfaceUpdate(
        surfaceId: surfaceId,
        components: [comp],
      );

      // Inject via handleMessage (Validated API)
      _processor!.handleMessage(surfaceUpdate);
      _logger.info(
        'GenUiService: Surface $surfaceId replayed via handleMessage',
      );
    } catch (e) {
      _logger.warning('GenUiService: Replay failed: $e');
    }
  }

  Future<void> _cleanup() async {
    _genUiConversation?.dispose();
    _genUiConversation = null;
    _processor = null;
    _isInitialized = false;
  }

  Future<void> dispose() async {
    await _cleanup();
  }
}
