// features/chat/widgets/welcome/suggestion_card.dart
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// 建议卡片组件
/// 展示单个场景化建议，点击后触发回调
class SuggestionCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String prompt;
  final String description;
  final VoidCallback onTap;

  const SuggestionCard({
    super.key,
    required this.emoji,
    required this.title,
    required this.prompt,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              // 使用 muted 颜色作为背景，透明度降低
              color: theme.colors.muted.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题行：emoji + 标题
                Row(
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: theme.typography.lg.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // 提示语（用户点击后发送的内容）
                Text(
                  '"$prompt"',
                  style: theme.typography.base.copyWith(
                    color: theme.colors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                // 描述说明
                Text(
                  description,
                  style: theme.typography.sm.copyWith(
                    color: theme.colors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
