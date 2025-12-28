// features/chat/widgets/welcome/welcome_guide_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/welcome_guide_provider.dart';
import 'greeting_header.dart';
import 'suggestion_card.dart';

/// 欢迎引导组件
/// 在聊天页面无消息时显示，根据时段提供场景化建议
class WelcomeGuideWidget extends ConsumerWidget {
  /// 当用户点击建议卡片时的回调
  /// 参数为建议的 prompt，用于发送给 AI
  final void Function(String prompt) onSuggestionTap;

  const WelcomeGuideWidget({super.key, required this.onSuggestionTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guideState = ref.watch(welcomeGuideProvider);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: ConstrainedBox(
          // 限制最大宽度，在大屏幕上保持居中紧凑
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 问候语头部
              GreetingHeader(
                greeting: guideState.greeting,
                subtitle: guideState.subtitle,
              ),
              const SizedBox(height: 28),
              // 场景化建议卡片 - 使用 Column + gap
              ...guideState.suggestions.asMap().entries.map((entry) {
                final index = entry.key;
                final suggestion = entry.value;
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index < guideState.suggestions.length - 1 ? 10 : 0,
                  ),
                  child: SuggestionCard(
                    emoji: suggestion.emoji,
                    title: suggestion.title,
                    prompt: suggestion.prompt,
                    description: suggestion.description,
                    onTap: () => onSuggestionTap(suggestion.prompt),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
