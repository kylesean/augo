import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../models/media_file.dart';

/// 图片全屏查看器
/// 使用 photo_view 组件实现图片缩放和拖拽，支持多图片左右滑动切换
/// iOS/Android：使用高效的 FileImage
/// Web：使用 NetworkImage（因为 MediaFile.path 通常是服务器 URL）
class ImageFullScreenViewer extends StatefulWidget {
  /// 图片文件列表
  final List<MediaFile> imageFiles;

  /// 初始显示的图片索引
  final int initialIndex;

  const ImageFullScreenViewer({
    super.key,
    required this.imageFiles,
    this.initialIndex = 0,
  });

  /// 显示全屏图片查看器
  static Future<void> show(
    BuildContext context, {
    required List<MediaFile> imageFiles,
    int initialIndex = 0,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ImageFullScreenViewer(
          imageFiles: imageFiles,
          initialIndex: initialIndex,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<ImageFullScreenViewer> createState() => _ImageFullScreenViewerState();
}

class _ImageFullScreenViewerState extends State<ImageFullScreenViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    // 确保初始索引在有效范围内
    _currentIndex = widget.imageFiles.isEmpty
        ? 0
        : (widget.initialIndex >= 0 &&
              widget.initialIndex < widget.imageFiles.length)
        ? widget.initialIndex
        : 0;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 处理空列表情况
    if (widget.imageFiles.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              const Center(
                child: Text(
                  '没有图片可显示',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              Positioned(
                top: 8,
                left: 16,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.white, size: 28),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 图片查看器主体
          PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              final imageFile = widget.imageFiles[index];
              return PhotoViewGalleryPageOptions(
                imageProvider: _getImageProvider(imageFile),
                initialScale: PhotoViewComputedScale.contained,
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: PhotoViewComputedScale.covered * 2.0,
                heroAttributes: PhotoViewHeroAttributes(tag: imageFile.id),
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.white,
                          size: 48,
                        ),
                        SizedBox(height: 16),
                        Text('图片加载失败', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  );
                },
              );
            },
            itemCount: widget.imageFiles.length,
            loadingBuilder: (context, event) => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            pageController: _pageController,
            onPageChanged: (index) {
              if (mounted && index >= 0 && index < widget.imageFiles.length) {
                setState(() {
                  _currentIndex = index;
                });
              }
            },
          ),

          // 顶部工具栏
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    // 关闭按钮
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),

                    const Spacer(),

                    // 图片计数器
                    if (widget.imageFiles.length > 1)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          '${_currentIndex + 1} / ${widget.imageFiles.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // 底部图片信息
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: _buildImageInfo(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建图片信息组件
  Widget _buildImageInfo() {
    if (widget.imageFiles.isEmpty ||
        _currentIndex < 0 ||
        _currentIndex >= widget.imageFiles.length) {
      return const SizedBox.shrink();
    }

    final currentImage = widget.imageFiles[_currentIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          currentImage.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          _formatFileSize(currentImage.size),
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  /// 获取图片提供者
  /// MediaFile.path 通常是服务器 URL，所以使用 NetworkImage
  /// 如果是本地文件路径，在 iOS/Android 上使用 FileImage
  ImageProvider _getImageProvider(MediaFile imageFile) {
    final path = imageFile.path;

    // 如果是网络 URL
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return NetworkImage(path);
    }

    // 如果是本地文件路径
    if (kIsWeb) {
      // Web 平台：本地文件路径不可用，尝试作为 URL 使用
      return NetworkImage(path);
    } else {
      // iOS/Android：使用高效的 FileImage
      return FileImage(File(path));
    }
  }

  /// 格式化文件大小
  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }
}
