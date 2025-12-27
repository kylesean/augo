// features/chat/providers/chat_input_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';

part 'chat_input_state.freezed.dart';

@freezed
abstract class ChatInputState with _$ChatInputState {
  const factory ChatInputState({
    @Default('') String text, // Current text in the input box
    @Default(false) bool isListening, // Whether speech recognition is in progress
    @Default(false) bool isSpeechAvailable, // Whether speech recognition service is available
    @Default(false) bool isLoadingResponse, // Whether waiting for AI response
    @Default(false) bool showError, // Whether to show error提示
    @Default('') String errorMessage, // Error message content
    @Default(HintType.normal) HintType hintType, // Used to control input box hint text type
    @Default([]) List<XFile> selectedFiles, // List of selected files
    @Default({}) Map<String, bool> uploadingFiles, // Mapping of files being uploaded (path -> isUploading)
  }) = _ChatInputState;
}

// New enum for more precise control of input box hint text
enum HintType {
  normal, // "Input message..."
  listening, // "Listening..."
  aiProcessing, // "AI thinking..."
  speechNotRecognized, // "Speech not recognized, please try again" (brief提示)
}
