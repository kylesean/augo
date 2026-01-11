// features/chat/widgets/enhanced_user_message_bubble.dart
import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../models/chat_message.dart';
import '../models/chat_message_attachment.dart';
import '../providers/chat_history_provider.dart';
import '../services/data_uri_service.dart';
import 'authenticated_image.dart';

/// 用户消息气泡组件
/// 支持显示文本和多媒体附件
class UserMessageBubble extends ConsumerStatefulWidget {
  final ChatMessage message;

  const UserMessageBubble({super.key, required this.message});

  @override
  ConsumerState<UserMessageBubble> createState() => _UserMessageBubbleState();
}

class _UserMessageBubbleState extends ConsumerState<UserMessageBubble> {
  static const double _imagePreviewWidth = 200;
  static const double _imagePreviewHeight = 150;
  static const double _imageBorderRadius = 12;
  static final Map<String, Uint8List> _mediaImageCache = {};

  bool _hasRequestedSignedUrls = false;

  String _mediaCacheKey(DataUriFile file) {
    return '${widget.message.id}_${file.originalName}_${file.size}_${file.dataUri.hashCode}';
  }

  String get _visibilityKey {
    final buffer = StringBuffer(widget.message.id);
    for (final attachment in widget.message.attachments) {
      buffer
        ..write('_')
        ..write(attachment.id)
        ..write('_')
        ..write(attachment.signedUrl ?? '')
        ..write('_')
        ..write(attachment.status.name);
    }
    return buffer.toString();
  }

  bool get _hasAttachmentsNeedingFetch {
    return widget.message.attachments.any(_shouldAutoFetchAttachment);
  }

  bool _shouldAutoFetchAttachment(ChatMessageAttachment attachment) {
    return !attachment.hasSignedUrl &&
        attachment.status != AttachmentLoadStatus.loading &&
        attachment.status != AttachmentLoadStatus.failed;
  }

  @override
  void didUpdateWidget(covariant UserMessageBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_hasAttachmentsNeedingFetch) {
      _hasRequestedSignedUrls = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final attachments = widget.message.attachments;
    final hasMediaFiles = widget.message.mediaFiles.isNotEmpty;
    final hasText = widget.message.content.isNotEmpty;

    final children = <Widget>[];

    if (attachments.isNotEmpty) {
      children.add(
        VisibilityDetector(
          key: ValueKey(_visibilityKey),
          onVisibilityChanged: _handleAttachmentVisibilityChanged,
          child: _buildAttachmentsSection(theme),
        ),
      );

      if (hasMediaFiles || hasText) {
        children.add(const SizedBox(height: 8));
      }
    }

    if (hasMediaFiles) {
      children.add(_buildMediaFilesPreview(context, theme));
      if (hasText) {
        children.add(const SizedBox(height: 8));
      }
    }

    if (hasText) {
      children.add(_buildTextBubble(theme));
    }

    return Align(
      key: ValueKey('user_message_${widget.message.id}'),
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: children,
        ),
      ),
    );
  }

  void _handleAttachmentVisibilityChanged(VisibilityInfo info) {
    if (!mounted) return;
    if (info.visibleFraction < 0.25) return;
    if (!_hasAttachmentsNeedingFetch) return;
    if (_hasRequestedSignedUrls) return;

    _hasRequestedSignedUrls = true;
    unawaited(
      ref
          .read(chatHistoryProvider.notifier)
          .ensureAttachmentsSignedUrls(widget.message.id),
    );
  }

  Widget _buildAttachmentsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (final attachment in widget.message.attachments)
          _buildAttachmentItem(attachment, theme),
      ],
    );
  }

  Widget _buildAttachmentItem(
    ChatMessageAttachment attachment,
    ThemeData theme,
  ) {
    if (attachment.isPreviewable) {
      return _buildAttachmentImage(attachment, theme);
    }
    return _buildAttachmentFileTile(attachment, theme);
  }

  Widget _buildAttachmentImage(
    ChatMessageAttachment attachment,
    ThemeData theme,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        width: _imagePreviewWidth,
        height: _imagePreviewHeight,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_imageBorderRadius),
          child: SizedBox.expand(
            child: _buildAttachmentImageContent(attachment, theme),
          ),
        ),
      ),
    );
  }

  /// 渲染附件图片内容
  ///
  /// 设计原则：**数据优先于状态**
  /// - 如果 signedUrl 已存在，直接渲染，不依赖 status
  /// - 只有在没有数据时才根据 status 显示骨架屏或错误
  Widget _buildAttachmentImageContent(
    ChatMessageAttachment attachment,
    ThemeData theme,
  ) {
    final url = attachment.signedUrl;

    // 1. 数据优先：如果有 URL，直接渲染
    if (url != null && url.isNotEmpty) {
      if (url.startsWith('data:')) {
        // Base64 data URI - 直接解码渲染
        return _renderBase64Image(attachment, url, theme);
      } else {
        // 网络 URL - 使用认证图片组件
        return _renderNetworkImage(attachment, theme);
      }
    }

    // 2. 没有数据时，根据状态显示不同 UI
    switch (attachment.status) {
      case AttachmentLoadStatus.initial:
      case AttachmentLoadStatus.loading:
        return _buildAttachmentSkeleton(theme);
      case AttachmentLoadStatus.loaded:
        // 状态是 loaded 但没有 URL，显示错误
        return _buildAttachmentError(theme, attachment);
      case AttachmentLoadStatus.failed:
        return _buildAttachmentError(theme, attachment);
    }
  }

  /// 渲染 Base64 图片
  Widget _renderBase64Image(
    ChatMessageAttachment attachment,
    String dataUri,
    ThemeData theme,
  ) {
    try {
      final bytes = _getImageBytesFromDataUri(dataUri);
      return Hero(
        tag: 'history_attachment_${attachment.id}',
        child: GestureDetector(
          onTap: () =>
              _showImagePreview(bytes, 'history_attachment_${attachment.id}'),
          child: Image.memory(
            bytes,
            fit: BoxFit.cover,
            gaplessPlayback: true,
            errorBuilder: (context, error, stackTrace) =>
                _buildAttachmentError(theme, attachment),
          ),
        ),
      );
    } catch (e) {
      return _buildAttachmentError(theme, attachment);
    }
  }

  /// 渲染网络图片（带认证）
  Widget _renderNetworkImage(
    ChatMessageAttachment attachment,
    ThemeData theme,
  ) {
    return Hero(
      tag: 'history_attachment_${attachment.id}',
      child: GestureDetector(
        onTap: () => _handleRemoteImageTap(attachment),
        child: AuthenticatedImage(
          attachmentId: attachment.id,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) {
            return _buildAttachmentSkeleton(theme);
          },
          errorBuilder: (context, error, stackTrace) =>
              _buildAttachmentError(theme, attachment),
        ),
      ),
    );
  }

  void _showImagePreview(Uint8List bytes, String heroTag) {
    unawaited(
      Navigator.of(context).push(
        PageRouteBuilder<void>(
          opaque: false,
          barrierColor: Colors.black87,
          barrierDismissible: true,
          pageBuilder: (context, animation, secondaryAnimation) {
            return _ImagePreviewOverlay(bytes: bytes, heroTag: heroTag);
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
    );
  }

  Widget _buildAttachmentFileTile(
    ChatMessageAttachment attachment,
    ThemeData theme,
  ) {
    switch (attachment.status) {
      case AttachmentLoadStatus.initial:
      case AttachmentLoadStatus.loading:
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          height: 60,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.3,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: _buildAttachmentSkeleton(theme),
        );
      case AttachmentLoadStatus.failed:
        return _buildAttachmentError(theme, attachment);
      case AttachmentLoadStatus.loaded:
        final fileCategory = DataUriService.getFileCategory(
          attachment.filename,
        );
        final icon = _getFileTypeIcon(fileCategory);
        final color = _getFileTypeColor(fileCategory, theme);
        return InkWell(
          onTap: attachment.hasSignedUrl
              ? () => _openAttachmentLink(attachment)
              : null,
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.3,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 20, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        attachment.filename,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        attachment.fileExtension.isEmpty
                            ? ''
                            : attachment.fileExtension.toUpperCase(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                if (attachment.hasSignedUrl) ...[
                  const SizedBox(width: 8),
                  Icon(
                    FIcons.externalLink,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ],
            ),
          ),
        );
    }
  }

  Widget _buildAttachmentSkeleton(ThemeData theme) {
    final baseColor = theme.colorScheme.surfaceContainerHighest.withValues(
      alpha: 0.35,
    );
    final highlightColor = theme.colorScheme.surface.withValues(alpha: 0.6);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: SizedBox.expand(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttachmentError(
    ThemeData theme,
    ChatMessageAttachment attachment,
  ) {
    final message = attachment.errorMessage ?? '附件加载失败，点击重试';
    return InkWell(
      onTap: () => _retryAttachment(attachment),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              FIcons.refreshCcw,
              color: theme.colorScheme.onErrorContainer,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onErrorContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextBubble(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(4),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        widget.message.content,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onPrimary,
          fontSize: 15,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildMediaFilesPreview(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (final file in widget.message.mediaFiles)
          _buildMediaFileItem(context, file, theme),
        if (widget.message.mediaFiles.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '共 ${widget.message.mediaFiles.length} 个文件',
              style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
            ),
          ),
      ],
    );
  }

  Widget _buildMediaFileItem(
    BuildContext context,
    DataUriFile file,
    ThemeData theme,
  ) {
    final fileCategory = DataUriService.getFileCategory(file.originalName);

    if (fileCategory == 'image') {
      return _buildImagePreview(context, file, theme);
    }

    return _buildFileInfo(context, file, fileCategory, theme);
  }

  Widget _buildImagePreview(
    BuildContext context,
    DataUriFile file,
    ThemeData theme,
  ) {
    final cacheKey = _mediaCacheKey(file);
    final bytes = _mediaImageCache.putIfAbsent(
      cacheKey,
      () => _getImageBytesFromDataUri(file.dataUri),
    );
    final heroTag = 'media_$cacheKey';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        width: _imagePreviewWidth,
        height: _imagePreviewHeight,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_imageBorderRadius),
          child: SizedBox.expand(
            child: GestureDetector(
              onTap: () => _showInlineImagePreview(context, file),
              child: Hero(
                tag: heroTag,
                child: Image.memory(
                  bytes,
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFileInfo(
    BuildContext context,
    DataUriFile file,
    String fileCategory,
    ThemeData theme,
  ) {
    final formattedSize = DataUriService.formatFileSize(file.size);

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getFileTypeColor(fileCategory, theme),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getFileTypeIcon(fileCategory),
              size: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.originalName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '$formattedSize · ${fileCategory.toUpperCase()}',
                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showInlineImagePreview(
    BuildContext context,
    DataUriFile file,
  ) async {
    final heroTag = 'media_${_mediaCacheKey(file)}';

    await Navigator.of(context).push(
      PageRouteBuilder<void>(
        opaque: false,
        barrierColor: Colors.black87,
        barrierDismissible: true,
        pageBuilder: (dialogContext, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: _ImagePreviewOverlay(
              bytes: _getImageBytesFromDataUri(file.dataUri),
              heroTag: heroTag,
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleRemoteImageTap(ChatMessageAttachment attachment) async {
    await Navigator.of(context).push(
      PageRouteBuilder<void>(
        opaque: false,
        barrierColor: Colors.black87,
        barrierDismissible: true,
        pageBuilder: (dialogContext, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: _AuthenticatedImagePreviewOverlay(
              attachmentId: attachment.id,
              heroTag: 'history_attachment_${attachment.id}',
            ),
          );
        },
      ),
    );
  }

  void _retryAttachment(ChatMessageAttachment attachment) {
    unawaited(
      ref
          .read(chatHistoryProvider.notifier)
          .ensureAttachmentsSignedUrls(
            widget.message.id,
            attachmentIds: [attachment.id],
            forceRetry: true,
          ),
    );
    _hasRequestedSignedUrls = false;
  }

  Future<void> _openAttachmentLink(ChatMessageAttachment attachment) async {
    final url = attachment.signedUrl;
    if (url == null || url.isEmpty) return;

    final uri = Uri.tryParse(url);
    if (uri == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('附件链接无效')));
      return;
    }

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!launched && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('无法打开附件链接')));
    }
  }

  Uint8List _getImageBytesFromDataUri(String dataUri) {
    final base64String = dataUri.split(',').last;
    return base64Decode(base64String);
  }

  Color _getFileTypeColor(String fileCategory, ThemeData theme) {
    switch (fileCategory) {
      case 'image':
        return Colors.blue;
      case 'document':
        return Colors.green;
      case 'video':
        return Colors.purple;
      case 'audio':
        return Colors.orange;
      default:
        return theme.colorScheme.onSurfaceVariant;
    }
  }

  IconData _getFileTypeIcon(String fileCategory) {
    switch (fileCategory) {
      case 'image':
        return FIcons.image;
      case 'document':
        return FIcons.fileText;
      case 'video':
        return FIcons.video;
      case 'audio':
        return FIcons.volume2;
      default:
        return FIcons.file;
    }
  }
}

class _ImagePreviewOverlay extends StatelessWidget {
  final Uint8List bytes;
  final String heroTag;

  const _ImagePreviewOverlay({required this.bytes, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.black87,
        body: SafeArea(
          child: Center(
            child: Hero(
              tag: heroTag,
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4,
                child: Image.memory(bytes, fit: BoxFit.contain),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthenticatedImagePreviewOverlay extends ConsumerWidget {
  final String attachmentId;
  final String heroTag;

  const _AuthenticatedImagePreviewOverlay({
    required this.attachmentId,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.black87,
        body: SafeArea(
          child: Center(
            child: Hero(
              tag: heroTag,
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4,
                child: AuthenticatedImage(
                  attachmentId: attachmentId,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
