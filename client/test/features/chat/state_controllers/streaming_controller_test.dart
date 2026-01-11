import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:augo/features/chat/state_controllers/streaming_controller.dart';
import 'package:augo/features/chat/state_controllers/stream_state_controller.dart';
import 'package:augo/features/chat/services/genui_service.dart';
import 'package:augo/features/chat/models/chat_message.dart';

import 'streaming_controller_test.mocks.dart';

@GenerateMocks([GenUiService, StreamStateController])
void main() {
  late StreamingController controller;
  late MockStreamStateController mockStreamState;
  late MockGenUiService mockGenUiService;

  // Callbacks

  late String? lastDelayExceededReceived;
  late String? lastStreamCompleteFinalText;
  late dynamic lastStreamError;

  setUp(() {
    mockStreamState = MockStreamStateController();
    mockGenUiService = MockGenUiService();

    // Reset callback trackers
    lastDelayExceededReceived = null;
    lastStreamCompleteFinalText = null;
    lastStreamError = null;

    controller = StreamingController(
      config: const StreamingConfig(
        initialDelayMs: 100,
      ), // Short delay for testing
      streamState: mockStreamState,
      onUpdateMessageState:
          ({
            required String id,
            String? content,
            bool? isTyping,
            StreamingStatus? streamingStatus,
          }) {},
      getCurrentMessageContent: (id) => "Current Content",
      onInitialDelayExceeded: () {
        lastDelayExceededReceived = "Exceeded";
      },
      onStreamComplete: (finalText) {
        lastStreamCompleteFinalText = finalText;
      },
      onStreamError: (error) {
        lastStreamError = error;
      },
      onStreamCancelled: (hasContent) {},
    );

    controller.setGenUiService(mockGenUiService);
  });

  group('StreamingController', () {
    test(
      'resetForNewMessage should reset internal state and call streamState',
      () {
        controller.resetForNewMessage('msg-1');

        expect(controller.currentMessageId, 'msg-1');
        expect(controller.isStreamDone, false);
        expect(controller.isFirstChunkReceived, false);
        expect(controller.isMessageCompleted, false);
        expect(controller.isUserCancelled, false);

        verify(mockStreamState.startStreaming('msg-1')).called(1);
      },
    );

    test(
      'startInitialDelayTimer should trigger callback after delay if no chunk received',
      () async {
        controller.startInitialDelayTimer();

        // Wait for delay + buffer
        await Future<void>.delayed(const Duration(milliseconds: 150));

        expect(lastDelayExceededReceived, "Exceeded");
      },
    );

    test('handleTextChunk should mark first chunk and cancel timer', () async {
      controller.startInitialDelayTimer();

      // Send first chunk immediately
      final isFirst = controller.handleTextChunk("Hello");

      expect(isFirst, true);
      expect(controller.isFirstChunkReceived, true);
      verify(mockStreamState.markFirstChunkReceived()).called(1);

      // Wait to ensure timer was cancelled (callback shouldn't fire)
      await Future<void>.delayed(const Duration(milliseconds: 150));
      expect(lastDelayExceededReceived, null);
    });

    test('handleTextChunk subsequent chunks should return false', () {
      controller.handleTextChunk("Hello");
      final isFirst = controller.handleTextChunk(" World");

      expect(isFirst, false);
      // markFirstChunkReceived should still verify handled correctly internally,
      // but strictly we verify it was called once overall.
      verify(mockStreamState.markFirstChunkReceived()).called(1);
    });

    test('handleStreamComplete should update flags and notify', () {
      controller.handleStreamComplete("Final Text");

      expect(controller.isStreamDone, true);
      expect(controller.isMessageCompleted, true);
      expect(lastStreamCompleteFinalText, "Final Text");
      verify(mockStreamState.markCompleted()).called(1);
    });

    test('handleStreamError should update flags and notify', () {
      controller.handleStreamError("Error");

      expect(controller.isStreamDone, true);
      expect(controller.isMessageCompleted, true);
      expect(lastStreamError, "Error");
      verify(mockStreamState.markError()).called(1);
    });

    test(
      'markStreamEnded should update flags without callback notification',
      () {
        controller.markStreamEnded();

        expect(controller.isStreamDone, true);
        expect(controller.isMessageCompleted, true);
        // Callbacks should NOT be fired
        expect(lastStreamCompleteFinalText, null);
        expect(lastStreamError, null);
      },
    );

    test('markFirstChunkReceived should check flag before updating', () {
      controller.markFirstChunkReceived();
      expect(controller.isFirstChunkReceived, true);
      verify(mockStreamState.markFirstChunkReceived()).called(1);

      controller.markFirstChunkReceived();
      // Should not call again
      verifyNever(mockStreamState.markFirstChunkReceived());
    });
  });
}
