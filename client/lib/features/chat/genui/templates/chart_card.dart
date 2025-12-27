import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// 图表卡片 Widget 实现
class ChartCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const ChartCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

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
          const SizedBox(height: 16),
          Container(
            height: 200,
            alignment: Alignment.center,
            child: Text(
              '图表类型: ${data['chartType']}\n(需要 fl_chart 库完整实现)',
              textAlign: TextAlign.center,
              style: theme.typography.sm.copyWith(
                color: colors.mutedForeground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
