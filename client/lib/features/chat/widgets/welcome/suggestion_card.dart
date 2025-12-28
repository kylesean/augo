// features/chat/widgets/welcome/suggestion_card.dart
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// 建议卡片组件
/// 紧凑设计，点击后发送 prompt 给 AI
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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: theme.colors.muted.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colors.border.withValues(alpha: 0.6),
            ),
          ),
          child: Row(
            children: [
              // Emoji 图标容器
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colors.background,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(emoji, style: const TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 12),
              // 文字内容
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 标题
                    Text(
                      title,
                      style: theme.typography.sm.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    // 描述
                    Text(
                      description,
                      style: theme.typography.xs.copyWith(
                        color: theme.colors.mutedForeground,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // 箭头指示
              Icon(
                FIcons.chevronRight,
                size: 16,
                color: theme.colors.mutedForeground.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
