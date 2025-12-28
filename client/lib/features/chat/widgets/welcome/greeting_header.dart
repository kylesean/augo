// features/chat/widgets/welcome/greeting_header.dart
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// 问候语头部组件
/// 显示时段问候语和副标题
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
        // 问候语
        Text(
          greeting,
          style: theme.typography.xl3.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        // 副标题
        Text(
          subtitle,
          style: theme.typography.base.copyWith(
            color: theme.colors.mutedForeground,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
