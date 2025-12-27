// features/chat/widgets/upload_progress_widget.dart
import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:image_picker/image_picker.dart';

/// 上传进度状态
enum UploadStatus { uploading, success, failed, cancelled }

/// 上传进度数据模型
class UploadProgressData {
  final String id;
  final XFile file;
  final double progress; // 0.0 - 1.0
  final UploadStatus status;
  final String? errorMessage;
  final String? uploadUrl;

  const UploadProgressData({
    required this.id,
    required this.file,
    this.progress = 0.0,
    this.status = UploadStatus.uploading,
    this.errorMessage,
    this.uploadUrl,
  });

  UploadProgressData copyWith({
    String? id,
    XFile? file,
    double? progress,
    UploadStatus? status,
    String? errorMessage,
    String? uploadUrl,
  }) {
    return UploadProgressData(
      id: id ?? this.id,
      file: file ?? this.file,
      progress: progress ?? this.progress,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      uploadUrl: uploadUrl ?? this.uploadUrl,
    );
  }

  /// 是否上传完成（成功或失败）
  bool get isCompleted =>
      status == UploadStatus.success || status == UploadStatus.failed;

  /// 是否正在上传
  bool get isUploading => status == UploadStatus.uploading;

  /// 是否上传成功
  bool get isSuccess => status == UploadStatus.success;

  /// 是否上传失败
  bool get isFailed => status == UploadStatus.failed;
}

/// 上传进度显示组件
class UploadProgressWidget extends StatelessWidget {
  final UploadProgressData uploadData;
  final VoidCallback? onCancel;
  final VoidCallback? onRetry;
  final VoidCallback? onRemove;

  const UploadProgressWidget({
    super.key,
    required this.uploadData,
    this.onCancel,
    this.onRetry,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border, width: 1),
      ),
      child: Row(
        children: [
          // 文件缩略图
          _buildThumbnail(theme, colors),
          const SizedBox(width: 12),

          // 文件信息和进度
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 文件名
                Text(
                  uploadData.file.name,
                  style: theme.typography.sm.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colors.foreground,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),

                // 状态和进度
                _buildStatusInfo(theme, colors),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // 操作按钮
          _buildActionButton(colors),
        ],
      ),
    );
  }

  /// 构建文件缩略图
  /// iOS/Android：使用高效的 Image.file
  /// Web：使用 Image.memory + readAsBytes
  Widget _buildThumbnail(FThemeData theme, FColors colors) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: colors.muted.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: _isImageFile(uploadData.file.name)
            ? _buildImageThumbnail(colors)
            : _buildFileIcon(colors),
      ),
    );
  }

  /// 构建图片缩略图
  Widget _buildImageThumbnail(FColors colors) {
    if (kIsWeb) {
      // Web 平台：使用 readAsBytes
      return FutureBuilder<List<int>>(
        future: uploadData.file.readAsBytes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colors.mutedForeground,
                ),
              ),
            );
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return _buildFileIcon(colors);
          }

          return Image.memory(
            snapshot.data! as dynamic,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildFileIcon(colors);
            },
          );
        },
      );
    } else {
      // iOS/Android：使用高效的 Image.file
      return Image.file(
        File(uploadData.file.path),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFileIcon(colors);
        },
      );
    }
  }

  /// 构建文件图标
  Widget _buildFileIcon(FColors colors) {
    return Center(
      child: Icon(FIcons.file, size: 24, color: colors.mutedForeground),
    );
  }

  /// 构建状态信息
  Widget _buildStatusInfo(FThemeData theme, FColors colors) {
    switch (uploadData.status) {
      case UploadStatus.uploading:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 进度条
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: uploadData.progress,
                backgroundColor: colors.muted,
                valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                minHeight: 4,
              ),
            ),
            const SizedBox(height: 2),
            // 进度文本
            Text(
              '上传中... ${(uploadData.progress * 100).toInt()}%',
              style: theme.typography.xs.copyWith(
                color: colors.mutedForeground,
              ),
            ),
          ],
        );

      case UploadStatus.success:
        return Row(
          children: [
            Icon(FIcons.check, size: 16, color: Colors.green),
            const SizedBox(width: 4),
            Text(
              '上传成功',
              style: theme.typography.xs.copyWith(color: Colors.green),
            ),
          ],
        );

      case UploadStatus.failed:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(FIcons.x, size: 16, color: colors.destructive),
                const SizedBox(width: 4),
                Text(
                  '上传失败',
                  style: theme.typography.xs.copyWith(
                    color: colors.destructive,
                  ),
                ),
              ],
            ),
            if (uploadData.errorMessage != null) ...[
              const SizedBox(height: 2),
              Text(
                uploadData.errorMessage!,
                style: theme.typography.xs.copyWith(
                  color: colors.destructive.withValues(alpha: 0.8),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        );

      case UploadStatus.cancelled:
        return Row(
          children: [
            Icon(FIcons.ban, size: 16, color: colors.mutedForeground),
            const SizedBox(width: 4),
            Text(
              '已取消',
              style: theme.typography.xs.copyWith(
                color: colors.mutedForeground,
              ),
            ),
          ],
        );
    }
  }

  /// 构建操作按钮
  Widget _buildActionButton(FColors colors) {
    switch (uploadData.status) {
      case UploadStatus.uploading:
        return FButton.icon(
          style: FButtonStyle.ghost(),
          onPress: onCancel,
          child: Icon(FIcons.x, size: 16, color: colors.mutedForeground),
        );

      case UploadStatus.success:
        return FButton.icon(
          style: FButtonStyle.ghost(),
          onPress: onRemove,
          child: Icon(FIcons.x, size: 16, color: colors.mutedForeground),
        );

      case UploadStatus.failed:
        return Row(
          children: [
            FButton.icon(
              style: FButtonStyle.ghost(),
              onPress: onRetry,
              child: Icon(FIcons.refreshCcw, size: 16, color: colors.primary),
            ),
            FButton.icon(
              style: FButtonStyle.ghost(),
              onPress: onRemove,
              child: Icon(FIcons.x, size: 16, color: colors.mutedForeground),
            ),
          ],
        );

      case UploadStatus.cancelled:
        return FButton.icon(
          style: FButtonStyle.ghost(),
          onPress: onRemove,
          child: Icon(FIcons.x, size: 16, color: colors.mutedForeground),
        );
    }
  }

  /// 判断是否是图片文件
  bool _isImageFile(String fileName) {
    const imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
    final extension = fileName.split('.').last.toLowerCase();
    return imageExtensions.contains(extension);
  }
}

/// 批量上传进度显示组件
class BatchUploadProgressWidget extends StatelessWidget {
  final List<UploadProgressData> uploadList;
  final Function(String id)? onCancel;
  final Function(String id)? onRetry;
  final Function(String id)? onRemove;

  const BatchUploadProgressWidget({
    super.key,
    required this.uploadList,
    this.onCancel,
    this.onRetry,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    if (uploadList.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              '上传进度 (${_getCompletedCount()}/${uploadList.length})',
              style: theme.typography.sm.copyWith(
                fontWeight: FontWeight.w500,
                color: colors.foreground,
              ),
            ),
          ),

          // 上传项列表
          ...uploadList.map((uploadData) {
            return UploadProgressWidget(
              uploadData: uploadData,
              onCancel: onCancel != null
                  ? () => onCancel!(uploadData.id)
                  : null,
              onRetry: onRetry != null ? () => onRetry!(uploadData.id) : null,
              onRemove: onRemove != null
                  ? () => onRemove!(uploadData.id)
                  : null,
            );
          }),
        ],
      ),
    );
  }

  /// 获取已完成的上传数量
  int _getCompletedCount() {
    return uploadList.where((data) => data.isCompleted).length;
  }
}
