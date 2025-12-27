import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:shimmer/shimmer.dart';

/// Streaming Analysis Toast - Displays streaming text at the top when GenUI components are rendering.
///
/// Design Philosophy:
/// - GenUI components render first in the message area (allowing user focus).
/// - AI streaming text is displayed in a top Toast (with shimmer animation).
/// - Toast disappears when the stream ends, and the text appears in a bubble below the card.
class StreamingToast {
  static OverlayEntry? _currentEntry;
  static _StreamingToastState? _currentState;

  /// Displays the streaming Toast.
  static void show(BuildContext context) {
    // Remove existing Toast.
    hide();

    final overlay = Overlay.of(context);
    final theme = context.theme;

    _currentEntry = OverlayEntry(
      builder: (context) => _StreamingToastWidget(
        theme: theme,
        onDismiss: hide,
        onStateCreated: (state) => _currentState = state,
      ),
    );

    overlay.insert(_currentEntry!);
  }

  /// Appends streaming text.
  static void appendText(String text) {
    _currentState?.appendText(text);
  }

  /// Hides and destroys the Toast.
  static void hide() {
    _currentEntry?.remove();
    _currentEntry = null;
    _currentState = null;
  }

  /// Checks if the Toast is currently showing.
  static bool get isShowing => _currentEntry != null;
}

class _StreamingToastWidget extends StatefulWidget {
  final FThemeData theme;
  final VoidCallback onDismiss;
  final void Function(_StreamingToastState) onStateCreated;

  const _StreamingToastWidget({
    required this.theme,
    required this.onDismiss,
    required this.onStateCreated,
  });

  @override
  State<_StreamingToastWidget> createState() => _StreamingToastState();
}

class _StreamingToastState extends State<_StreamingToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final _textBuffer = StringBuffer();
  String _displayText = '';

  @override
  void initState() {
    super.initState();
    widget.onStateCreated(this);

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  /// Appends streaming text.
  void appendText(String text) {
    if (!mounted) return;
    _textBuffer.write(text);
    setState(() {
      // Only show the last 100 characters to prevent the Toast from becoming too long.
      final full = _textBuffer.toString();
      _displayText = full.length > 100
          ? '...${full.substring(full.length - 100)}'
          : full;
    });
  }

  Future<void> dismiss() async {
    await _controller.reverse();
    widget.onDismiss();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.theme.colors;
    final topPadding = MediaQuery.of(context).padding.top;

    return Positioned(
      top: topPadding + 12,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: dismiss,
              onVerticalDragEnd: (details) {
                if (details.velocity.pixelsPerSecond.dy < 0) {
                  dismiss();
                }
              },
              child: Container(
                constraints: const BoxConstraints(maxHeight: 80),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: colors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colors.primary.withValues(alpha: 0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colors.primary.withValues(alpha: 0.1),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Shimmer effect icon on the left.
                    Shimmer.fromColors(
                      baseColor: colors.primary,
                      highlightColor: colors.primary.withValues(alpha: 0.5),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: colors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          FIcons.sparkles,
                          size: 16,
                          color: colors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Streaming text area.
                    Expanded(
                      child: _displayText.isEmpty
                          ? Shimmer.fromColors(
                              baseColor: colors.mutedForeground,
                              highlightColor: colors.foreground.withValues(
                                alpha: 0.5,
                              ),
                              child: Text(
                                'Analyzing...',
                                style: widget.theme.typography.sm.copyWith(
                                  color: colors.mutedForeground,
                                ),
                              ),
                            )
                          : Text(
                              _displayText,
                              style: widget.theme.typography.sm.copyWith(
                                color: colors.foreground,
                                height: 1.4,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
