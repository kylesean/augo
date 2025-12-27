// features/chat/services/media_thumbnail_service.dart
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import '../models/media_file.dart';

/// Media thumbnail generation service
/// Responsible for generating thumbnails for images to improve preview performance
class MediaThumbnailService {
  static final _logger = Logger('MediaThumbnailService');
  static const int _thumbnailSize = 200; // Maximum thumbnail size
  static const int _quality = 85; // JPEG quality (0-100)

  // Cache for generated thumbnails
  static final Map<String, Uint8List> _thumbnailCache = {};

  /// Generate thumbnail for image file
  /// Returns thumbnail byte data, or null if generation fails
  static Future<Uint8List?> generateThumbnail(MediaFile mediaFile) async {
    if (mediaFile.type != MediaType.image) {
      return null;
    }

    // Check cache
    final cacheKey = '${mediaFile.id}_${mediaFile.size}';
    if (_thumbnailCache.containsKey(cacheKey)) {
      return _thumbnailCache[cacheKey];
    }

    try {
      final file = File(mediaFile.path);
      if (!await file.exists()) {
        return null;
      }

      // Read original image data
      final originalBytes = await file.readAsBytes();

      // Decode image
      final codec = await ui.instantiateImageCodec(
        originalBytes,
        targetWidth: _thumbnailSize,
        targetHeight: _thumbnailSize,
      );

      final frame = await codec.getNextFrame();
      final image = frame.image;

      // Convert to byte data
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        image.dispose();
        return null;
      }

      final thumbnailBytes = byteData.buffer.asUint8List();

      // Cache thumbnail
      _thumbnailCache[cacheKey] = thumbnailBytes;

      // Clean up resources
      image.dispose();

      return thumbnailBytes;
    } catch (e) {
      _logger.warning('Failed to generate thumbnail', e);
      return null;
    }
  }

  /// Batch generate thumbnails
  /// Returns list of file IDs for which thumbnails were successfully generated
  static Future<List<String>> generateThumbnails(
    List<MediaFile> mediaFiles,
  ) async {
    final List<String> successIds = [];

    for (final mediaFile in mediaFiles) {
      if (mediaFile.type == MediaType.image) {
        final thumbnail = await generateThumbnail(mediaFile);
        if (thumbnail != null) {
          successIds.add(mediaFile.id);
        }
      }
    }

    return successIds;
  }

  /// Get cached thumbnail
  static Uint8List? getCachedThumbnail(MediaFile mediaFile) {
    final cacheKey = '${mediaFile.id}_${mediaFile.size}';
    return _thumbnailCache[cacheKey];
  }

  /// Check if cached thumbnail exists
  static bool hasCachedThumbnail(MediaFile mediaFile) {
    final cacheKey = '${mediaFile.id}_${mediaFile.size}';
    return _thumbnailCache.containsKey(cacheKey);
  }

  /// Clear thumbnail cache for specific file
  static void clearThumbnailCache(MediaFile mediaFile) {
    final cacheKey = '${mediaFile.id}_${mediaFile.size}';
    _thumbnailCache.remove(cacheKey);
  }

  /// Clear all thumbnail cache
  static void clearAllThumbnailCache() {
    _thumbnailCache.clear();
  }

  /// Get cache size (in bytes)
  static int getCacheSize() {
    int totalSize = 0;
    for (final bytes in _thumbnailCache.values) {
      totalSize += bytes.length;
    }
    return totalSize;
  }

  /// Get cache item count
  static int getCacheCount() {
    return _thumbnailCache.length;
  }

  /// Clean up expired cache items
  /// When cache size exceeds limit, clean up oldest cache items
  static void cleanupCache({int maxCacheSize = 50 * 1024 * 1024}) {
    // 50MB default limit
    if (getCacheSize() <= maxCacheSize) {
      return;
    }

    // Simple cleanup strategy: clear all cache
    // In practice, LRU strategy can be implemented
    clearAllThumbnailCache();
    _logger.info('Thumbnail cache cleared');
  }

  /// Remove cache by file ID
  static void removeCacheForFile(String fileId) {
    // Find and remove matching cache entries
    _thumbnailCache.removeWhere((key, value) => key.startsWith(fileId));
  }

  /// Clear cache (alias method, for compatibility)
  static void clearCache() {
    clearAllThumbnailCache();
  }

  /// Get cache statistics
  static Map<String, dynamic> getCacheStats() {
    return {
      'count': getCacheCount(),
      'size': getCacheSize(),
      'sizeMB': (getCacheSize() / (1024 * 1024)).toStringAsFixed(2),
    };
  }

  /// Image compression method
  static Future<Uint8List> compressImage(
    Uint8List imageBytes, {
    int quality = 85,
    int maxWidth = 800,
    int maxHeight = 600,
  }) async {
    try {
      // Decode original image
      final codec = await ui.instantiateImageCodec(
        imageBytes,
        targetWidth: maxWidth,
        targetHeight: maxHeight,
      );

      final frame = await codec.getNextFrame();
      final image = frame.image;

      // Convert to byte data (use PNG format to ensure quality)
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      // Clean up resources
      image.dispose();

      if (byteData == null) {
        throw Exception('Unable to compress image');
      }

      return byteData.buffer.asUint8List();
    } catch (e) {
      _logger.warning('Image compression failed', e);
      // If compression fails, return original data
      return imageBytes;
    }
  }

  /// Preload thumbnails
  /// Generate thumbnails asynchronously in background without blocking UI
  static Future<void> preloadThumbnails(List<MediaFile> mediaFiles) async {
    // Use compute to generate thumbnails in background thread
    for (final mediaFile in mediaFiles) {
      if (mediaFile.type == MediaType.image && !hasCachedThumbnail(mediaFile)) {
        // Generate asynchronously without waiting for result
        generateThumbnail(mediaFile).catchError((error) {
          _logger.warning('Failed to preload thumbnail', error);
          return null;
        });
      }
    }
  }
}
