// features/chat/widgets/media_upload_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';

import 'media_upload_bottom_sheet.dart';

/// 媒体上传按钮组件
/// 点击后弹出底部菜单，显示多个功能选项
class MediaUploadButton extends ConsumerWidget {
  final bool enabled;
  final dynamic chatInputProvider;

  const MediaUploadButton({
    super.key,
    this.enabled = true,
    required this.chatInputProvider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.theme;
    final colors = theme.colors;

    // 与右侧按钮保持一致的样式
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        // 使用与右侧按钮相同的 muted 背景色
        color: colors.muted,
        shape: BoxShape.circle,
        // 无边框
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled
              ? () => _handleUploadButtonPressed(context, ref)
              : null,
          borderRadius: BorderRadius.circular(20),
          child: Center(
            child: Icon(
              FIcons.plus,
              size: 20,
              color: enabled ? colors.foreground : colors.mutedForeground,
            ),
          ),
        ),
      ),
    );
  }

  /// 处理上传按钮点击事件
  void _handleUploadButtonPressed(BuildContext context, WidgetRef ref) {
    MediaUploadBottomSheet.show(
      context,
      onFilesSelected: (files) {
        if (files.isNotEmpty) {
          final notifier = ref.read(chatInputProvider.notifier);
          notifier.addSelectedFiles(files);
        }
      },
    );
  }
}
