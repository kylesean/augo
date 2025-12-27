import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// GenUI 可复用底部弹窗容器
///
/// Layer 3 (Organism) 组件，提供统一的底部弹窗外观和行为。
/// 包含拖拽手柄、标题栏和可滚动内容区。
///
/// 使用方式：
/// ```dart
/// GenUIBottomSheet.show(
///   context: context,
///   title: '消费明细',
///   builder: (context) => TransactionListView(data: data),
/// );
/// ```
class GenUIBottomSheet extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;
  final double heightFactor;

  const GenUIBottomSheet({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
    this.heightFactor = 0.85,
  });

  /// 显示底部弹窗
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required WidgetBuilder builder,
    Widget? trailing,
    double heightFactor = 0.85,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => GenUIBottomSheet(
        title: title,
        trailing: trailing,
        heightFactor: heightFactor,
        child: builder(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * heightFactor,
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // 拖拽手柄
          const SizedBox(height: 8),
          Container(
            width: 32,
            height: 4,
            decoration: BoxDecoration(
              color: colors.muted,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // 标题栏
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.typography.lg.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (trailing != null) ...[trailing!, const SizedBox(width: 8)],
                FButton.icon(
                  style: FButtonStyle.ghost(),
                  onPress: () => Navigator.pop(context),
                  child: Icon(
                    FIcons.x,
                    size: 20,
                    color: colors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),

          Container(height: 1, color: colors.border),

          // 内容区 - 填充到底部
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomPadding),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
