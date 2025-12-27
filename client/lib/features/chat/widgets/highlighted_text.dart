import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import '../providers/conversation_search_state.dart';

/// Highlighted text component
class HighlightedText extends StatelessWidget {
  final String text;
  final List<HighlightRange> highlights;
  final String field;
  final TextStyle? style;
  final TextStyle? highlightStyle;
  final int? maxLines;
  final TextOverflow? overflow;

  const HighlightedText({
    super.key,
    required this.text,
    required this.highlights,
    required this.field,
    this.style,
    this.highlightStyle,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    // Get highlight ranges for current field
    final fieldHighlights = highlights.where((h) => h.field == field).toList()
      ..sort((a, b) => a.start.compareTo(b.start));

    if (fieldHighlights.isEmpty) {
      return Text(text, style: style, maxLines: maxLines, overflow: overflow);
    }

    // Build text segments
    final spans = <TextSpan>[];
    int currentIndex = 0;

    for (final highlight in fieldHighlights) {
      // Add normal text before highlight
      if (currentIndex < highlight.start) {
        spans.add(
          TextSpan(
            text: text.substring(currentIndex, highlight.start),
            style: style,
          ),
        );
      }

      // Add highlighted text
      final highlightText = text.substring(
        highlight.start.clamp(0, text.length),
        highlight.end.clamp(0, text.length),
      );

      spans.add(
        TextSpan(
          text: highlightText,
          style: (highlightStyle ?? style ?? const TextStyle()).copyWith(
            fontWeight: FontWeight.bold,
            backgroundColor: theme.colors.primary.withValues(alpha: 0.2),
            color: theme.colors.primary,
          ),
        ),
      );

      currentIndex = highlight.end;
    }

    // Add remaining normal text
    if (currentIndex < text.length) {
      spans.add(TextSpan(text: text.substring(currentIndex), style: style));
    }

    return RichText(
      text: TextSpan(children: spans),
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.clip,
    );
  }
}
