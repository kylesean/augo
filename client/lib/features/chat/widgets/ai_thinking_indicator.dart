// features/chat/widgets/ai_thinking_indicator.dart
import 'dart:async';
import 'package:flutter/material.dart';

class AiThinkingIndicator extends StatefulWidget {
  final double dotSize;
  final Color? dotColor;
  final Duration duration;
  final String thinkingText;

  const AiThinkingIndicator({
    super.key,
    this.dotSize = 7.0,
    this.dotColor,
    this.duration = const Duration(milliseconds: 1400),
    this.thinkingText = "AI is thinking...", // Can customize thinking text
  });

  @override
  State<AiThinkingIndicator> createState() => _AiThinkingIndicatorState();
}

class _AiThinkingIndicatorState extends State<AiThinkingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    unawaited(_controller.repeat());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDot(int index, Color color) {
    // Each dot animation delay and duration relative to total time ratio
    final double begin = (index * 0.2).clamp(0.0, 1.0); // 0.0, 0.2, 0.4
    final double end = (begin + 0.4).clamp(0.0, 1.0); // 0.4, 0.6, 0.8

    // Use combination of ScaleTransition and FadeTransition
    return ScaleTransition(
      scale: Tween<double>(begin: 0.4, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(begin, end, curve: Curves.easeInOutSine),
        ),
      ),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.5, end: 1.0).animate(
          // From semi-transparent to completely opaque and back
          CurvedAnimation(
            parent: _controller,
            curve: Interval(begin, end, curve: Curves.easeInOutSine),
          ),
        ),
        child: Container(
          width: widget.dotSize,
          height: widget.dotSize,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color =
        widget.dotColor ??
        Theme.of(context).colorScheme.primary.withValues(alpha: 0.8);

    // If there is thinking text, display text + animation dots
    if (widget.thinkingText.isNotEmpty) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.thinkingText,
            style: TextStyle(
              fontSize: 13, // Slightly smaller font
              color: Theme.of(
                context,
              ).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(width: 6),
          _buildDot(0, color),
          SizedBox(width: widget.dotSize * 0.4),
          _buildDot(1, color),
          SizedBox(width: widget.dotSize * 0.4),
          _buildDot(2, color),
        ],
      );
    } else {
      // Otherwise only display animation dots
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDot(0, color),
          SizedBox(width: widget.dotSize * 0.4),
          _buildDot(1, color),
          SizedBox(width: widget.dotSize * 0.4),
          _buildDot(2, color),
        ],
      );
    }
  }
}
