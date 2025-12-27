import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:image_picker/image_picker.dart';

import 'package:augo/features/chat/services/chat_interaction_manager.dart';
import 'package:augo/features/chat/repositories/message_repository.dart';
import 'package:augo/features/chat/services/genui_lifecycle_manager.dart';
import 'package:augo/features/chat/state_controllers/streaming_controller.dart';
import 'package:augo/features/chat/services/data_uri_service.dart';
import 'package:augo/features/chat/services/genui_service.dart';
import 'package:augo/features/chat/models/chat_message.dart';
import 'package:augo/features/chat/models/message_attachments.dart';
import 'package:augo/features/chat/services/extended_genui_conversation.dart';

import 'chat_interaction_manager_test.mocks.dart';

// Create a custom mock class for ExtendedGenUiConversation since it might be hard to mock if it has complex inheritance
// But Mockito should handle it if we include it in GenerateMocks
// GenUiService has `ExtendedGenUiConversation get conversation`.

@GenerateMocks([
  MessageRepository,
  GenUiLifecycleManager,
  StreamingController,
  GenUiService,
  ExtendedGenUiConversation,
])
void main() {
  late ChatInteractionManager manager;
  late MockMessageRepository mockMessageRepository;
  late MockGenUiLifecycleManager mockLifecycleManager;
  late MockStreamingController mockStreamingController;
  late MockGenUiService mockGenUiService;
  late MockExtendedGenUiConversation mockConversation;

  // Callbacks
  bool lastIsStreaming = false;
  String currentConversationId = '';

  // Real DataUriService instance (since it's static methods are used, exact instance doesn't matter much)
  // But we need it for constructor
  final dataUriService = DataUriService();

  setUp(() {
    mockMessageRepository = MockMessageRepository();
    mockLifecycleManager = MockGenUiLifecycleManager();
    mockStreamingController = MockStreamingController();
    mockGenUiService = MockGenUiService();
    mockConversation = MockExtendedGenUiConversation();

    // Setup mocks
    when(mockLifecycleManager.service).thenReturn(mockGenUiService);
    when(mockLifecycleManager.isInitialized).thenReturn(true);
    when(mockGenUiService.conversation).thenReturn(mockConversation);

    // Default mock behavior
    when(
      mockStreamingController.cancelStreamAndTimers(),
    ).thenAnswer((_) async {});
    when(mockStreamingController.resetForNewMessage(any)).thenReturn(null);
    when(mockStreamingController.startInitialDelayTimer()).thenReturn(null);
    when(
      mockConversation.sendRequestWithAttachments(
        any,
        attachments: anyNamed('attachments'),
      ),
    ).thenAnswer((_) async {});
    when(mockConversation.setSessionId(any)).thenReturn(null);

    manager = ChatInteractionManager(
      messageRepository: mockMessageRepository,
      genUiLifecycleManager: mockLifecycleManager,
      streamingController: mockStreamingController,
      dataUriService: dataUriService,
      setStreamingStatus: (val) => lastIsStreaming = val,
      getCurrentConversationId: () => currentConversationId,
      getCurrentConversationTitle: () => 'Test Chat',
    );

    lastIsStreaming = false;
    currentConversationId = '';
  });

  group('ChatInteractionManager', () {
    test('addUserMessageAndGetResponse basic flow', () async {
      final text = "Hello AI";

      await manager.addUserMessageAndGetResponse(text);

      // 1. Cancel previous
      verify(mockStreamingController.cancelStreamAndTimers()).called(1);

      // 2. Reset status
      verify(mockStreamingController.resetForNewMessage(any)).called(1);

      // 3. Add to Repo
      verify(mockMessageRepository.addMessages(any)).called(1);

      // 4. Update status
      expect(lastIsStreaming, true);

      // 5. Start timer
      verify(mockStreamingController.startInitialDelayTimer()).called(1);

      // Wait for unawaited async call
      await Future.delayed(const Duration(milliseconds: 100));

      // 6. Send request
      verify(
        mockConversation.sendRequestWithAttachments(text, attachments: null),
      ).called(1);
    });

    test('addUserMessageAndGetResponse with attachments', () async {
      final text = "Check this file";
      final fakeFile = FakeXFile('test.jpg', Uint8List.fromList([0, 1, 2, 3]));

      final attachment = PendingMessageAttachment(
        file: fakeFile,
        uploadInfo: UploadedAttachmentInfo(
          id: 'att-1',
          attachmentId: 'att-1',
          originalName: 'test.jpg',
          mimeType: 'image/jpeg',
          size: 4.0,
          uri: 'http://example.com/test.jpg',
          objectKey: 'key/test.jpg',
        ),
      );

      await manager.addUserMessageAndGetResponse(
        text,
        attachments: [attachment],
      );

      // Verify repo added message with attachment
      final captured = verify(
        mockMessageRepository.addMessages(captureAny),
      ).captured;
      final messages = captured.first as List<ChatMessage>;
      expect(messages.length, 2); // User + AI Placeholder
      expect(messages[0].attachments.length, 1);
      expect(messages[0].attachments[0].id, 'att-1');

      // Wait for unawaited async call and data uri conversion
      await Future.delayed(const Duration(milliseconds: 100));

      // Verify request sent with attachment payload
      // DataUriService converts to data uri, we expect base64 encoded [0,1,2,3]
      // AAECAw==

      final capturedPayload =
          verify(
                mockConversation.sendRequestWithAttachments(
                  text,
                  attachments: captureAnyNamed('attachments'),
                ),
              ).captured.first
              as List<Map<String, dynamic>>?;

      expect(capturedPayload, isNotNull);
      expect(capturedPayload!.length, 1);
      expect(capturedPayload[0]['id'], 'att-1');
      expect(capturedPayload[0]['type'], 'image/jpeg');
      expect(capturedPayload[0]['data'], contains('base64,AAECAw=='));
    });

    test('handleOptimisticUserMessage basic flow', () async {
      final text = "Optimistic Msg";

      await manager.handleOptimisticUserMessage(text);

      // 1. Cancel previous
      verify(mockStreamingController.cancelStreamAndTimers()).called(1);

      // 2. Reset status
      verify(mockStreamingController.resetForNewMessage(any)).called(1);

      // 3. Add messages
      verify(mockMessageRepository.addMessages(any)).called(1);

      // 4. Send request (internal)
      // Wait for unawaited async call
      await Future.delayed(const Duration(milliseconds: 100));
      verify(
        mockConversation.sendRequestWithAttachments(text, attachments: null),
      ).called(1);
    });

    test('Send logic respects current conversation ID', () async {
      currentConversationId = 'session-123';

      await manager.addUserMessageAndGetResponse("Test");

      await Future.delayed(const Duration(milliseconds: 100));

      verify(mockConversation.setSessionId('session-123')).called(1);
    });

    test('Handles GenUI service uninitialized', () async {
      when(mockLifecycleManager.isInitialized).thenReturn(false);

      await manager.addUserMessageAndGetResponse("Test");

      await Future.delayed(const Duration(milliseconds: 100));

      verifyNever(mockConversation.sendRequestWithAttachments(any));
      verify(mockStreamingController.handleStreamError(any)).called(1);
      expect(lastIsStreaming, false);
    });
  });
}

class FakeXFile extends Fake implements XFile {
  @override
  final String name;
  final Uint8List bytes;

  FakeXFile(this.name, this.bytes);

  @override
  Future<Uint8List> readAsBytes() async => bytes;
}
