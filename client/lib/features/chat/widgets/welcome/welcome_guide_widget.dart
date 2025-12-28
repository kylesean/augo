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

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 问候语头部
          GreetingHeader(
            greeting: guideState.greeting,
            subtitle: guideState.subtitle,
          ),
          const SizedBox(height: 32),
          // 场景化建议卡片
          ...guideState.suggestions.map(
            (suggestion) => SuggestionCard(
              emoji: suggestion.emoji,
              title: suggestion.title,
              prompt: suggestion.prompt,
              description: suggestion.description,
              onTap: () => onSuggestionTap(suggestion.prompt),
            ),
          ),
        ],
      ),
    );
  }
}
