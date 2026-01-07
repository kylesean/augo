// features/chat/widgets/conversation_item_skeleton.dart
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class ConversationItemSkeleton extends StatelessWidget {
  const ConversationItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final placeholderColor = theme.colors.muted; // Use a soft placeholder color

    return Container(
      width: double.infinity,
      height: 48, // Keep consistent with actual ShadButton height
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        // The background of the skeleton item can be similar to the ghost style background of the real button
        color: theme.colors.background, // Or other suitable background color
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Simulate title line
          Container(
            height: 14, // Simulate text height
            width: 150, // Simulate title length
            decoration: BoxDecoration(
              color: placeholderColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 4),
          // Simulate date line
          Container(
            height: 10, // Simulate text height
            width: 80, // Simulate date length
            decoration: BoxDecoration(
              color: placeholderColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
