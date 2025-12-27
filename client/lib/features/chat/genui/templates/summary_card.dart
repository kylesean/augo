import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// 摘要卡片 Widget 实现
class SummaryCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const SummaryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;
    final items = data['items'] as List<dynamic>;

    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data['title'] as String,
            style: theme.typography.base.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Text(
            data['summary'] as String,
            style: theme.typography.sm.copyWith(
              color: colors.mutedForeground,
              height: 1.5,
            ),
          ),
          if (items.isNotEmpty) ...[
            const SizedBox(height: 16),
            ...items.map((item) {
              final i = item as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        i['label'] as String,
                        style: theme.typography.sm.copyWith(
                          color: colors.mutedForeground,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        i['value'] as String,
                        style: theme.typography.sm.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}
