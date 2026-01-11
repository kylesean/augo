import 'dart:async';
import 'dart:io' show File;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:image_picker/image_picker.dart';
import 'image_preview_page.dart';

/// Simplified media file list preview component
/// Displays selected files directly using XFile
/// Supports iOS/Android (using efficient Image.file) and Web (using Image.memory)
class MediaPreviewWidget extends StatelessWidget {
  final List<XFile> selectedFiles;
  final Map<String, bool> uploadingFiles;
  final void Function(int) onRemove;

  const MediaPreviewWidget({
    super.key,
    required this.selectedFiles,
    required this.uploadingFiles,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedFiles.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 88.0,
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: selectedFiles.length,
        itemBuilder: (context, index) {
          final file = selectedFiles[index];
          final isUploading = uploadingFiles[file.path] ?? false;
          return Container(
            margin: const EdgeInsets.only(right: 8.0),
            child: _buildFileItem(context, file, index, isUploading),
          );
        },
      ),
    );
  }

  Widget _buildFileItem(
    BuildContext context,
    XFile file,
    int index,
    bool isUploading,
  ) {
    final isImage = _isImage(file.name);

    return Stack(
      children: [
        GestureDetector(
          onTap: isImage && !isUploading
              ? () => _openImagePreview(context, index)
              : null,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: isImage
                  ? Hero(tag: 'image_$index', child: _buildImage(file))
                  : _buildFileIcon(),
            ),
          ),
        ),

        // Upload loading indicator
        if (isUploading)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black.withValues(alpha: 0.5),
              ),
              child: const Center(
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ),
          ),

        Positioned(
          top: -4,
          right: -4,
          child: GestureDetector(
            onTap: () => onRemove(index),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: context.theme.colors.destructive,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                color: context.theme.colors.destructiveForeground,
                size: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build image preview
  /// iOS/Android: Use efficient Image.file
  /// Web: Use Image.memory + readAsBytes
  Widget _buildImage(XFile file) {
    if (kIsWeb) {
      // Web platform: Use FutureBuilder to asynchronously read file bytes
      return FutureBuilder<List<int>>(
        future: file.readAsBytes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.grey.shade100,
              child: const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return _buildFileIcon();
          }

          return Image.memory(
            snapshot.data as Uint8List,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildFileIcon();
            },
          );
        },
      );
    } else {
      // iOS/Android: Use efficient Image.file
      return Image.file(
        File(file.path),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFileIcon();
        },
      );
    }
  }

  Widget _buildFileIcon() {
    return Container(
      color: Colors.grey.shade100,
      child: const Icon(Icons.insert_drive_file, size: 32, color: Colors.grey),
    );
  }

  bool _isImage(String filename) {
    final ext = filename.toLowerCase().split('.').last;
    return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(ext);
  }

  /// Open image preview
  void _openImagePreview(BuildContext context, int initialIndex) {
    // Filter out all image files.
    final images = selectedFiles.where((file) => _isImage(file.name)).toList();

    if (images.isEmpty) return;

    // Find the index of the clicked image in the image list.
    final currentFile = selectedFiles[initialIndex];
    final imageIndex = images.indexWhere((img) => img.path == currentFile.path);

    unawaited(
      Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder: (context) => ImagePreviewPage(
            images: images,
            initialIndex: imageIndex >= 0 ? imageIndex : 0,
            onDelete: (imageIndex) {
              // Find the index of the image to delete in the original list.
              final imageToDelete = images[imageIndex];
              final originalIndex = selectedFiles.indexWhere(
                (file) => file.path == imageToDelete.path,
              );
              if (originalIndex >= 0) {
                onRemove(originalIndex);
              }
            },
          ),
        ),
      ),
    );
  }
}
