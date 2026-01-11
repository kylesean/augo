// features/chat/widgets/chat_input_field.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import '../providers/chat_input_provider.dart';
import '../providers/chat_input_state.dart';
import '../providers/chat_history_provider.dart';
import '../models/message_attachments.dart';
import 'media_upload_button.dart';
import 'media_preview_widget.dart';
import 'package:augo/i18n/strings.g.dart';

class ChatInputField extends ConsumerStatefulWidget {
  final Future<void> Function(
    String, {
    List<PendingMessageAttachment>? attachments,
  })
  onSendMessage;

  const ChatInputField({super.key, required this.onSendMessage});

  @override
  ConsumerState<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends ConsumerState<ChatInputField>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _textController;
  final FocusNode _focusNode = FocusNode();
  late final provider = chatInputProvider(widget.onSendMessage);

  // Breathing animation controller
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize breathing animation controller
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    // Breathing effect: scale from 0.85 to 1.15, use easeInOut curve to simulate heartbeat/breathing
    _breathingAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );
    _textController = TextEditingController();

    ref.listenManual(provider.select((s) => s.text), (
      previousText,
      currentText,
    ) {
      if (!mounted) return;
      if (_textController.text != currentText) {
        final currentSelection = _textController.selection;
        _textController.text = currentText;
        try {
          if (currentSelection.baseOffset <= currentText.length &&
              currentSelection.extentOffset <= currentText.length) {
            _textController.selection = currentSelection;
          } else {
            _textController.selection = TextSelection.fromPosition(
              TextPosition(offset: currentText.length),
            );
          }
        } catch (e) {
          _textController.selection = TextSelection.fromPosition(
            TextPosition(offset: currentText.length),
          );
        }
      }
    }, fireImmediately: true);

    ref.listenManual(provider, (
      ChatInputState? previousState,
      ChatInputState currentState,
    ) {
      if (!mounted) return;
      final bool wasShowingError = previousState?.showError ?? false;
      final bool isShowingError = currentState.showError;
      if (isShowingError && !wasShowingError) {
        final errorMessage = currentState.errorMessage;
        if (errorMessage.isNotEmpty) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              duration: const Duration(seconds: 3),
              action: SnackBarAction(
                label: t.common.ok,
                onPressed: () => ref.read(provider.notifier).clearError(),
              ),
            ),
          );
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              ref.read(provider.notifier).clearError();
            }
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String _getHintText(
    HintType hintType,
    bool isListening, {
    bool isStreamingResponse = false,
  }) {
    // Streaming response state takes priority - AI is replying
    if (isStreamingResponse) {
      return t.chat.aiThinking;
    }
    if (isListening) {
      return t.chat.listening;
    }
    switch (hintType) {
      case HintType.normal:
        return t.chat.inputMessage;
      case HintType.listening:
        return t.chat.listening;
      case HintType.aiProcessing:
        return t.chat.aiThinking;
      case HintType.speechNotRecognized:
        return t.chat.speechNotRecognized;
    }
  }

  /// Handle media file preview - temporarily removed complex preview functionality
  // void _handleMediaPreview() {
  //   // Simplified version temporarily doesn't need complex preview
  // }

  @override
  Widget build(BuildContext context) {
    final chatInputState = ref.watch(provider);
    final chatInputNotifier = ref.read(provider.notifier);

    // Listen to AI streaming response state - this state remains true throughout the stream
    final isStreamingResponse = ref.watch(
      chatHistoryProvider.select((state) => state.isStreamingResponse),
    );
    final chatHistoryNotifier = ref.read(chatHistoryProvider.notifier);

    IconData currentIcon;
    Color buttonBackgroundColor;
    Color iconColor;
    VoidCallback? currentAction = chatInputNotifier.onMainButtonPressed;

    // Disable input box during streaming response
    final canInteractWithTextField =
        !chatInputState.isListening && !isStreamingResponse;
    final canUseAddButton = !chatInputState.isListening && !isStreamingResponse;

    // Whether in waiting state (requires breathing animation)
    final isWaitingState = isStreamingResponse || chatInputState.isListening;

    // Control breathing animation start/stop
    if (isWaitingState) {
      if (!_breathingController.isAnimating) {
        _breathingController.repeat(reverse: true);
      }
    } else {
      if (_breathingController.isAnimating) {
        _breathingController.stop();
        _breathingController.reset();
      }
    }

    // Get forui theme
    final theme = context.theme;

    // AI streaming response: show square icon (stop button style), click to cancel
    if (isStreamingResponse) {
      currentIcon = Icons.square_rounded;
      buttonBackgroundColor = theme.colors.primary; // Use theme color
      iconColor = theme.colors.primaryForeground;
      currentAction = () => chatHistoryNotifier.cancelPendingOperation();
    } else if (chatInputState.isListening) {
      currentIcon = Icons.square_rounded;
      buttonBackgroundColor = theme.colors.primary; // Use theme color
      iconColor = theme.colors.primaryForeground;
    } else if (chatInputState.text.trim().isNotEmpty) {
      currentIcon = Icons.arrow_upward;
      buttonBackgroundColor =
          theme.colors.primary; // Also use theme color when there is text
      iconColor = theme.colors.primaryForeground;
    } else {
      currentIcon = chatInputState.isSpeechAvailable
          ? Icons.mic_none_outlined
          : Icons.mic_off_outlined;
      buttonBackgroundColor = theme.colors.muted; // Use theme's muted color
      iconColor = chatInputState.isSpeechAvailable
          ? theme.colors.foreground
          : theme.colors.mutedForeground;
    }

    return SafeArea(
      top: false,
      left: false,
      right: false,
      child: Container(
        // Outer container: simple padding, no shadow
        padding: const EdgeInsets.only(
          left: 12.0,
          right: 12.0,
          top: 8.0,
          bottom: 12.0,
        ),
        color: theme.colors.background,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Media preview area
            MediaPreviewWidget(
              selectedFiles: chatInputState.selectedFiles,
              uploadingFiles: chatInputState.uploadingFiles,
              onRemove: (index) => chatInputNotifier.removeSelectedFile(index),
            ),

            // Input box area - capsule-shaped border design
            Container(
              constraints: const BoxConstraints(minHeight: 52.0),
              padding: const EdgeInsets.symmetric(
                horizontal: 6.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                // Background color
                color: theme.colors.background,
                // Full rounded corners - capsule shape
                borderRadius: BorderRadius.circular(28.0),
                // Light gray border
                border: Border.all(color: theme.colors.border, width: 1.0),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Left + button
                  MediaUploadButton(
                    enabled: canUseAddButton,
                    chatInputProvider: provider,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      focusNode: _focusNode,
                      enabled: canInteractWithTextField,
                      onChanged: chatInputNotifier.onTextChanged,
                      decoration: InputDecoration(
                        hintText: _getHintText(
                          chatInputState.hintType,
                          chatInputState.isListening,
                          isStreamingResponse: isStreamingResponse,
                        ),
                        border: InputBorder.none,
                        filled: false,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 8.0,
                        ),
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) {
                        if (chatInputState.text.trim().isNotEmpty &&
                            canInteractWithTextField) {
                          chatInputNotifier.onMainButtonPressed();
                        }
                      },
                      minLines: 1,
                      maxLines: 5,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Right action button: internal icon with breathing animation effect
                  InkWell(
                    onTap: currentAction,
                    borderRadius: BorderRadius.circular(22),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: buttonBackgroundColor,
                        shape: BoxShape.circle,
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                              return ScaleTransition(
                                scale: animation,
                                child: child,
                              );
                            },
                        // Breathing animation only acts on internal icon
                        child: AnimatedBuilder(
                          animation: _breathingAnimation,
                          builder: (context, child) {
                            // Only apply breathing scale in waiting state
                            final scale = isWaitingState
                                ? _breathingAnimation.value
                                : 1.0;
                            return Transform.scale(
                              scale: scale,
                              child: Icon(
                                currentIcon,
                                key: ValueKey<IconData>(currentIcon),
                                color: iconColor,
                                size: 20,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
              ),
            ),
          ],
        ),
      ), // Close Container
    ); // Close SafeArea
  }
}
