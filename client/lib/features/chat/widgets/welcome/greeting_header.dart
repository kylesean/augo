// features/chat/widgets/welcome/greeting_header.dart
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// 问候语头部组件
/// 居中显示时段问候语和副标题
class GreetingHeader extends StatelessWidget {
  final String greeting;
  final String subtitle;

  const GreetingHeader({
    super.key,
    required this.greeting,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 问候语 - 更大更醒目
        Text(
          greeting,
          style: theme.typography.xl2.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        // 副标题 - 简洁提示
        Text(
          subtitle,
          style: theme.typography.sm.copyWith(
            color: theme.colors.mutedForeground,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
