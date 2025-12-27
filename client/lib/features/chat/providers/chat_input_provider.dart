import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logging/logging.dart';
import 'package:image_picker/image_picker.dart';
import '../services/speech_recognition_service.dart';
import '../services/speech_service_factory.dart';
import '../services/file_upload_service.dart';
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

  bool _isSpeechInitialized = false;
  String _textBeforeSpeechSession = '';
  Timer? _noSpeechInputTimer;
  bool _isManualStop = false;
  StreamSubscription? _resultSubscription;
  StreamSubscription? _statusSubscription;
  StreamSubscription? _errorSubscription;

  @override
  ChatInputState build(OnSendMessageCallback onSendMessage) {
    // Service initialization
    _fileUploadService = ref.watch(fileUploadServiceProvider);

    final settings = ref.watch(speechSettingsProvider).settings;
    final serviceType = settings?.serviceType ?? SpeechServiceType.system;
    _serviceType = serviceType;

    _speechService = SpeechServiceFactory.create(
      serviceType,
      websocketHost: settings?.websocketHost,
      websocketPort: settings?.websocketPort,
      websocketPath: settings?.websocketPath,
    );

    ref.onDispose(() {
      _resultSubscription?.cancel();
      _statusSubscription?.cancel();
      _errorSubscription?.cancel();
      _noSpeechInputTimer?.cancel();
      _speechService?.dispose();
    });

    _initializeSpeech();

    return const ChatInputState();
  }

  Future<void> _initializeSpeech() async {
    final serviceTypeName = _serviceType == SpeechServiceType.system
        ? 'System Speech'
        : 'WebSocket ASR';
    _logger.info("Initializing $serviceTypeName service...");
    try {
      final available = await _speechService!.initialize();

      if (available) {
        if (!_isSpeechInitialized) {
          _resultSubscription = _speechService!.onResult.listen(
            _onSpeechResult,
          );
          _statusSubscription = _speechService!.onStatus.listen(
            _onSpeechStatus,
          );
          _errorSubscription = _speechService!.onError.listen(_onSpeechError);
          _isSpeechInitialized = true;
        }

        state = state.copyWith(
          isSpeechAvailable: true,
          showError: false,
          errorMessage: '',
          hintType: HintType.normal,
        );
      } else {
        state = state.copyWith(
          isSpeechAvailable: false,
          showError: false,
          errorMessage: '',
          hintType: HintType.normal,
        );
      }
    } catch (e) {
      _logger.severe("Speech service initialization exception: $e");
      state = state.copyWith(
        isSpeechAvailable: false,
        showError: false,
        errorMessage: '',
        hintType: HintType.normal,
      );
    }
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

      String recognizedNewContent = state.text
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
        Future.delayed(const Duration(seconds: 2), () {
          if (state.hintType == HintType.speechNotRecognized &&
              !state.isListening &&
              !state.isLoadingResponse) {
            state = state.copyWith(hintType: HintType.normal);
          }
        });
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
    String newText = _textBeforeSpeechSession.isEmpty
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

    try {
      await _initializeSpeech();

      if (!state.isSpeechAvailable) {
        _logger.warning("Speech service initialization failed");
        state = state.copyWith(
          showError: true,
          errorMessage:
              'Speech service initialization failed, please check network connection',
          hintType: HintType.normal,
        );
        return;
      }

      _textBeforeSpeechSession = state.text.trim();
      state = state.copyWith(
        isListening: true,
        showError: false,
        errorMessage: '',
        hintType: HintType.listening,
      );

      await _speechService?.startListening();
      _noSpeechInputTimer?.cancel();
      _noSpeechInputTimer = Timer(const Duration(seconds: 30), () {
        if (state.isListening && state.text == _textBeforeSpeechSession) {
          _logger.info(
            "No valid speech input after 30 seconds, stopping actively",
          );
          _speechService?.stopListening();
        }
      });
    } catch (e) {
      _logger.severe("Failed to start speech recognition session: $e");
      state = state.copyWith(
        isListening: false,
        showError: true,
        errorMessage:
            'Cannot connect to ASR service, please check network connection',
        hintType: HintType.normal,
      );
    }
  }

  void onTextChanged(String newText) {
    if (state.isListening) {
      _logger.info("User manually input, stopping current speech listening");
      _noSpeechInputTimer?.cancel();
      _speechService?.stopListening();
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
    _uploadFilesInBackground(files);
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
