// features/chat/widgets/image_preview_page.dart
import 'dart:io' show File;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:image_picker/image_picker.dart';

/// 图片预览页面，支持缩放、滑动浏览多张图片
/// iOS/Android：使用高效的 FileImage
/// Web：使用 MemoryImage + readAsBytes
class ImagePreviewPage extends StatefulWidget {
  final List<XFile> images;
  final int initialIndex;
  final Function(int)? onDelete;

  const ImagePreviewPage({
    super.key,
    required this.images,
    this.initialIndex = 0,
    this.onDelete,
  });

  @override
  State<ImagePreviewPage> createState() => _ImagePreviewPageState();
}

class _ImagePreviewPageState extends State<ImagePreviewPage> {
  late PageController _pageController;
  late int _currentIndex;

  // Web 平台：缓存图片字节数据，避免重复读取
  final Map<int, Uint8List> _imageCache = {};

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);

    // Web 平台：预加载当前图片和相邻图片
    if (kIsWeb) {
      _preloadImages();
    }
  }

  void _preloadImages() {
    // 预加载当前、前一张和后一张图片
    for (int i = -1; i <= 1; i++) {
      final index = _currentIndex + i;
      if (index >= 0 &&
          index < widget.images.length &&
          !_imageCache.containsKey(index)) {
        _loadImage(index);
      }
    }
  }

  Future<void> _loadImage(int index) async {
    if (_imageCache.containsKey(index)) return;

    try {
      final bytes = await widget.images[index].readAsBytes();
      if (mounted) {
        setState(() {
          _imageCache[index] = bytes;
        });
      }
    } catch (e) {
      debugPrint('Failed to load image $index: $e');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _imageCache.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('${_currentIndex + 1} / ${widget.images.length}'),
        centerTitle: true,
        actions: [
          if (widget.onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showDeleteConfirmation(),
            ),
        ],
      ),
      body: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: _getImageProvider(index),
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained * 0.5,
            maxScale: PhotoViewComputedScale.covered * 2.0,
            heroAttributes: PhotoViewHeroAttributes(tag: 'image_$index'),
          );
        },
        itemCount: widget.images.length,
        loadingBuilder: (context, event) => Center(
          child: CircularProgressIndicator(
            value: event == null
                ? 0
                : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 1),
            color: Colors.white,
          ),
        ),
        backgroundDecoration: const BoxDecoration(color: Colors.black),
        pageController: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
          // Web 平台：当页面改变时预加载相邻图片
          if (kIsWeb) {
            _preloadImages();
          }
        },
      ),
    );
  }

  /// 获取图片提供者
  /// iOS/Android：使用高效的 FileImage
  /// Web：使用 MemoryImage
  ImageProvider _getImageProvider(int index) {
    final image = widget.images[index];

    if (kIsWeb) {
      // Web 平台：使用缓存的字节数据
      if (_imageCache.containsKey(index)) {
        return MemoryImage(_imageCache[index]!);
      }
      // 如果还没加载，先触发加载，返回一个临时的空图片
      _loadImage(index);
      return MemoryImage(Uint8List(0));
    } else {
      // iOS/Android：使用高效的 FileImage
      return FileImage(File(image.path));
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('删除图片'),
          content: const Text('确定要删除这张图片吗？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteCurrentImage();
              },
              child: const Text('删除', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _deleteCurrentImage() {
    if (widget.onDelete != null) {
      widget.onDelete!(_currentIndex);
      Navigator.of(context).pop();
    }
  }
}
