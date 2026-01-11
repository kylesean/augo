import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logging/logging.dart';
import 'package:image_picker/image_picker.dart';
import '../services/speech_recognition_service.dart';
import '../services/speech_service_factory.dart';
import '../services/file_upload_service.dart';
import '../services/sound_feedback_service.dart';
import '../models/message_attachments.dart';
import 'package:augo/features/profile/providers/speech_settings_provider.dart';
import 'chat_input_state.dart';

part 'chat_input_provider.g.dart';

typedef OnSendMessageCallback =
    Future<void> Function(
      String, {
      List<PendingMessageAttachment>? attachments,
    });

/// Simplified media file handling
extension ChatInputStateMediaHandling on ChatInputState {
  /// Currently uploaded file list
  List<XFile> get currentFiles => selectedFiles;

  /// Check if there are media files
  bool get hasMediaFiles => selectedFiles.isNotEmpty;
}

@riverpod
class ChatInputNotifier extends _$ChatInputNotifier {
  static final _logger = Logger('ChatInputNotifier');

  SpeechRecognitionService? _speechService;
  FileUploadService? _fileUploadService;
  SpeechServiceType? _serviceType;

  final Map<String, UploadedAttachmentInfo> _uploadedInfos = {};

  String _textBeforeSpeechSession = '';
  Timer? _noSpeechInputTimer;
  bool _isManualStop = false;
  StreamSubscription<String>? _resultSubscription;
  StreamSubscription<String>? _statusSubscription;
  StreamSubscription<String>? _errorSubscription;

  @override
  ChatInputState build(OnSendMessageCallback onSendMessage) {
    // Service initialization
    _fileUploadService = ref.watch(fileUploadServiceProvider);

    final settings = ref.watch(speechSettingsProvider).settings;
    final newServiceType = settings?.serviceType ?? SpeechServiceType.system;

    // 检测服务类型是否变化
    final isFirstInit = _serviceType == null;
    final serviceTypeChanged = !isFirstInit && _serviceType != newServiceType;

    _logger.info(
      'build() called: isFirstInit=$isFirstInit, serviceTypeChanged=$serviceTypeChanged, '
      'currentType=$_serviceType, newType=$newServiceType',
    );

    if (serviceTypeChanged) {
      _logger.info(
        'Speech service type changed from $_serviceType to $newServiceType, reinitializing...',
      );

      _cleanupCurrentService();
    }

    // Only create new service on first init or service type change
    if (isFirstInit || serviceTypeChanged) {
      _serviceType = newServiceType;
      _speechService = SpeechServiceFactory.create(
        newServiceType,
        websocketHost: settings?.websocketHost,
        websocketPort: settings?.websocketPort,
        websocketPath: settings?.websocketPath,
      );
      _logger.info('Created new ${newServiceType.name} speech service');
    }

    // Only register dispose callback on first init to avoid duplicate registration
    if (isFirstInit) {
      ref.onDispose(() {
        _logger.info('Provider disposing, cleaning up...');
        _cleanupCurrentService();
      });
    }

    return const ChatInputState();
  }

  /// Cleanup current service resources
  void _cleanupCurrentService() {
    _logger.info('Cleaning up current speech service...');

    // Cancel all subscriptions
    unawaited(_resultSubscription?.cancel());
    unawaited(_statusSubscription?.cancel());
    unawaited(_errorSubscription?.cancel());
    _noSpeechInputTimer?.cancel();

    _resultSubscription = null;
    _statusSubscription = null;
    _errorSubscription = null;
    _noSpeechInputTimer = null;

    // Release old service
    unawaited(_speechService?.dispose());
    _speechService = null;

    // Reset state flags
    _textBeforeSpeechSession = '';
    _isManualStop = false;
  }

  /// Ensure event subscriptions are set up
  ///
  /// Only create new subscriptions if they are not already set up, to avoid duplicate subscriptions
  void _ensureSubscriptionsSetup() {
    if (_speechService == null) return;

    // Skip if subscriptions are already set up
    if (_resultSubscription != null) return;

    _logger.info("Setting up speech service subscriptions...");
    _resultSubscription = _speechService!.onResult.listen(_onSpeechResult);
    _statusSubscription = _speechService!.onStatus.listen(_onSpeechStatus);
    _errorSubscription = _speechService!.onError.listen(_onSpeechError);

    state = state.copyWith(
      isSpeechAvailable: true,
      showError: false,
      errorMessage: '',
      hintType: HintType.normal,
    );
  }

  void _onSpeechStatus(String status) {
    _logger.info("Speech status: $status");
    final isCurrentlyListening = status == 'listening';

    if (state.isListening && !isCurrentlyListening) {
      _noSpeechInputTimer?.cancel();
      _logger.info("Stopped listening.");

      if (state.isLoadingResponse) {
        _logger.info("Sending message, ignoring speech status change");
        return;
      }

      if (_isManualStop) {
        _logger.info(
          "User manually stopped speech recognition, setting to normal state",
        );
        _isManualStop = false;
        state = state.copyWith(isListening: false, hintType: HintType.normal);
        _textBeforeSpeechSession = state.text;
        return;
      }

      final recognizedNewContent = state.text
          .replaceFirst(_textBeforeSpeechSession, '')
          .trim();

      if (recognizedNewContent.isEmpty && _textBeforeSpeechSession.isEmpty) {
        _logger.info("Listening ended, no speech recognized.");
        state = state.copyWith(
          isListening: false,
          text: '',
          hintType: HintType.speechNotRecognized,
        );
      } else if (recognizedNewContent.isEmpty &&
          _textBeforeSpeechSession.isNotEmpty) {
        _logger.info("Listening ended, no new content recognized.");
        state = state.copyWith(
          isListening: false,
          text: _textBeforeSpeechSession,
          hintType: HintType.speechNotRecognized,
        );
      } else {
        _logger.info(
          "Listening ended, content recognized. Final text: '${state.text}'",
        );
        state = state.copyWith(isListening: false, hintType: HintType.normal);
        _textBeforeSpeechSession = state.text;
      }

      if (state.hintType == HintType.speechNotRecognized) {
        unawaited(
          Future<void>.delayed(const Duration(seconds: 2), () {
            if (state.hintType == HintType.speechNotRecognized &&
                !state.isListening &&
                !state.isLoadingResponse) {
              state = state.copyWith(hintType: HintType.normal);
            }
          }),
        );
      }
    } else if (!state.isListening && isCurrentlyListening) {
      _logger.info("Started listening.");
      state = state.copyWith(isListening: true, hintType: HintType.listening);
    }
  }

  void _onSpeechError(String error) {
    _noSpeechInputTimer?.cancel();
    _logger.severe("Speech error: $error");

    if (state.isLoadingResponse) {
      _logger.info("Sending message, ignoring speech error: $error");
      return;
    }

    if (_isManualStop) {
      _logger.info("Error caused by user manual stop, ignoring: $error");
      _isManualStop = false;
      return;
    }

    String userMessage = 'Error occurred during speech recognition';
    if (error.toLowerCase().contains('connection') ||
        error.toLowerCase().contains('connect')) {
      userMessage =
          'Cannot connect to ASR service, please check if service is running';
    } else if (error.toLowerCase().contains('timeout')) {
      userMessage = 'No speech recognized, please try again';
      _textBeforeSpeechSession = '';
      state = state.copyWith(text: '');
    }

    state = state.copyWith(
      isListening: false,
      showError: true,
      errorMessage: userMessage,
      hintType: HintType.normal,
    );
  }

  void _onSpeechResult(String recognizedText) {
    _noSpeechInputTimer?.cancel();
    final newText = _textBeforeSpeechSession.isEmpty
        ? recognizedText
        : '${_textBeforeSpeechSession.trim()} $recognizedText'.trim();
    _logger.info(
      "Speech result: '$recognizedText', concatenated text: '$newText'",
    );
    state = state.copyWith(text: newText.trim());
    _textBeforeSpeechSession = newText.trim();
  }

  Future<void> onMainButtonPressed() async {
    if (state.isLoadingResponse) return;

    if (state.isListening) {
      _isManualStop = true;
      _noSpeechInputTimer?.cancel();
      await _speechService?.stopListening();
    } else if (state.text.trim().isNotEmpty || state.hasMediaFiles) {
      await _submitMessage();
    } else {
      await _startNewSpeechSession();
    }
  }

  Future<void> _startNewSpeechSession() async {
    _logger.info("Starting new speech recognition session");

    if (_speechService == null) {
      _logger.warning("Speech service not configured");
      state = state.copyWith(
        showError: true,
        errorMessage: '语音服务未配置',
        hintType: HintType.normal,
      );
      return;
    }

    // Play start sound immediately to give user instant feedback
    // Regardless of the service connection status, the user should be informed
    // that the system has responded.
    if (_serviceType == SpeechServiceType.websocket) {
      await SoundFeedbackService.instance.playStartSound();
    }

    try {
      // Use the unified ensureReady() method to ensure service readiness
      // The service handles its own initialization/reconnection logic
      final isReady = await _speechService!.ensureReady();

      if (!isReady) {
        _logger.warning("Speech service not ready");
        state = state.copyWith(
          showError: true,
          errorMessage: '语音服务连接失败，请检查网络',
          hintType: HintType.normal,
        );
        return;
      }

      // Ensure event subscriptions are set up
      _ensureSubscriptionsSetup();

      _textBeforeSpeechSession = state.text.trim();
      state = state.copyWith(
        isListening: true,
        showError: false,
        errorMessage: '',
        hintType: HintType.listening,
      );

      await _speechService!.startListening();
      _noSpeechInputTimer?.cancel();
      _noSpeechInputTimer = Timer(const Duration(seconds: 30), () {
        if (state.isListening && state.text == _textBeforeSpeechSession) {
          _logger.info(
            "No valid speech input after 30 seconds, stopping actively",
          );
          unawaited(_speechService?.stopListening());
        }
      });
    } catch (e) {
      _logger.severe("Failed to start speech recognition session: $e");
      state = state.copyWith(
        isListening: false,
        showError: true,
        errorMessage:
            'Voice service connection failed. Please check your network connection.',
        hintType: HintType.normal,
      );
    }
  }

  void onTextChanged(String newText) {
    if (state.isListening) {
      _logger.info("User manually input, stopping current speech listening");
      _noSpeechInputTimer?.cancel();
      unawaited(_speechService?.stopListening());
    }
    _textBeforeSpeechSession = newText;
    state = state.copyWith(text: newText, hintType: HintType.normal);
  }

  Future<void> _submitMessage() async {
    if (state.isLoadingResponse) return;

    final textToSend = state.text.trim();
    final hasMediaFiles = state.hasMediaFiles;

    if (textToSend.isEmpty && !hasMediaFiles) return;

    if (state.isListening) {
      _noSpeechInputTimer?.cancel();
      await _speechService?.stopListening();
      state = state.copyWith(isListening: false, hintType: HintType.normal);
    }

    final currentTextAfterStop = state.text.trim();
    final currentMediaFiles = List<XFile>.from(state.selectedFiles);

    if (currentTextAfterStop.isEmpty && currentMediaFiles.isEmpty) return;

    final pendingAttachments = <PendingMessageAttachment>[];
    if (currentMediaFiles.isNotEmpty) {
      for (final file in currentMediaFiles) {
        final uploadInfo = _uploadedInfos[file.path];
        if (uploadInfo == null) {
          state = state.copyWith(
            showError: true,
            errorMessage: 'Attachment still uploading, please try again later',
            hintType: HintType.normal,
          );
          return;
        }
        pendingAttachments.add(
          PendingMessageAttachment(file: file, uploadInfo: uploadInfo),
        );
      }
    }

    state = state.copyWith(
      isLoadingResponse: true,
      hintType: HintType.aiProcessing,
    );

    try {
      await onSendMessage(
        currentTextAfterStop,
        attachments: pendingAttachments.isEmpty ? null : pendingAttachments,
      );

      for (final attachment in pendingAttachments) {
        _uploadedInfos.remove(attachment.file.path);
      }

      _textBeforeSpeechSession = '';
      state = state.copyWith(
        text: '',
        selectedFiles: [],
        isLoadingResponse: false,
        hintType: HintType.normal,
      );
    } catch (e, s) {
      _logger.severe("Message send failed: $e\n$s");
      state = state.copyWith(
        isLoadingResponse: false,
        showError: true,
        errorMessage: 'Send failed, please try again later',
        hintType: HintType.normal,
      );
    }
  }

  void clearError() {
    if (state.showError) {
      state = state.copyWith(showError: false, errorMessage: '');
    }
  }

  void showError(String message) {
    state = state.copyWith(showError: true, errorMessage: message);
  }

  /// Reset loading state - called by ChatHistory when AI response stream ends
  void resetLoadingState() {
    if (state.isLoadingResponse) {
      state = state.copyWith(
        isLoadingResponse: false,
        hintType: HintType.normal,
      );
    }
  }

  void addSelectedFiles(List<XFile> files) {
    final updatedFiles = [...state.selectedFiles, ...files];
    final uploadingMap = Map<String, bool>.from(state.uploadingFiles);
    for (final file in files) {
      uploadingMap[file.path] = true;
    }

    state = state.copyWith(
      selectedFiles: updatedFiles,
      uploadingFiles: uploadingMap,
      showError: false,
      errorMessage: '',
    );
    unawaited(_uploadFilesInBackground(files));
  }

  void removeSelectedFile(int index) {
    if (index < 0 || index >= state.selectedFiles.length) return;

    final fileToRemove = state.selectedFiles[index];
    final updatedFiles = List<XFile>.from(state.selectedFiles)..removeAt(index);
    final uploadingMap = Map<String, bool>.from(state.uploadingFiles);
    uploadingMap.remove(fileToRemove.path);
    _uploadedInfos.remove(fileToRemove.path);

    state = state.copyWith(
      selectedFiles: updatedFiles,
      uploadingFiles: uploadingMap,
    );
  }

  void clearSelectedFiles() {
    if (state.selectedFiles.isNotEmpty) {
      state = state.copyWith(selectedFiles: []);
    }
  }

  void handleUploadCompleted(
    FileUploadResult result,
    List<XFile> originalFiles,
  ) {
    final failedFileNames = result.failures.map((f) => f.fileName).toSet();
    final failedPaths = <String>{};
    final failedNames = <String>[];

    for (final file in originalFiles) {
      if (failedFileNames.contains(file.name)) {
        failedPaths.add(file.path);
        failedNames.add(file.name);
      }
    }

    final uploadingMap = Map<String, bool>.from(state.uploadingFiles);

    if (failedPaths.isNotEmpty) {
      final updatedFiles = state.selectedFiles
          .where((file) => !failedPaths.contains(file.path))
          .toList();
      for (final path in failedPaths) {
        _uploadedInfos.remove(path);
        uploadingMap.remove(path);
      }
      state = state.copyWith(
        selectedFiles: updatedFiles,
        uploadingFiles: uploadingMap,
        showError: true,
        errorMessage: 'Attachment upload failed: ${failedNames.join(', ')}',
      );
    }

    for (final upload in result.uploads) {
      final file = originalFiles.firstWhere(
        (f) => f.name == upload.originalName,
      );
      _uploadedInfos[file.path] = UploadedAttachmentInfo(
        id: upload.id,
        attachmentId: upload.attachmentId,
        originalName: upload.originalName,
        objectKey: upload.objectKey,
        uri: upload.uri,
        mimeType: upload.mimeType,
        size: upload.size,
        hash: upload.hash,
      );
      uploadingMap[file.path] = false;
    }

    state = state.copyWith(uploadingFiles: uploadingMap);
  }

  Future<void> _uploadFilesInBackground(List<XFile> files) async {
    try {
      final uploadResult = await _fileUploadService!.uploadFiles(files);
      handleUploadCompleted(uploadResult, files);
    } catch (e, stackTrace) {
      _logger.severe('Background upload exception: $e\n$stackTrace');
      final uploadingMap = Map<String, bool>.from(state.uploadingFiles);
      for (final file in files) {
        uploadingMap.remove(file.path);
      }
      state = state.copyWith(
        uploadingFiles: uploadingMap,
        showError: true,
        errorMessage: 'File upload failed: $e',
      );
    }
  }
}
