import 'dart:io';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import '../models/media_file.dart';
import 'media_thumbnail_service.dart';

final _logger = Logger('MediaMemoryManager');

/// Media memory management service
/// Responsible for managing memory usage of media files, including automatic cleanup and resource release
class MediaMemoryManager {
  /// Singleton instance
  static final MediaMemoryManager _instance = MediaMemoryManager._internal();

  /// Get singleton instance
  factory MediaMemoryManager() => _instance;

  /// Get singleton instance (static method)
  static MediaMemoryManager get instance => _instance;

  MediaMemoryManager._internal();

  /// Memory usage threshold (bytes) - 50MB
  static const int memoryThresholdBytes = 50 * 1024 * 1024;

  /// Active media file references
  final Map<String, MediaFileWithBytes> _activeMediaFiles = {};

  /// Memory usage statistics
  int _currentMemoryUsage = 0;

  /// Last cleanup time
  DateTime? _lastCleanupTime;

  /// Cleanup interval (minutes)
  static const int cleanupIntervalMinutes = 5;

  /// Register media file to memory manager
  ///
  /// [mediaFileWithBytes] Media file with byte data
  void registerMediaFile(MediaFileWithBytes mediaFileWithBytes) {
    final id = mediaFileWithBytes.id;

    // If already exists, release old first
    if (_activeMediaFiles.containsKey(id)) {
      unregisterMediaFile(id);
    }

    _activeMediaFiles[id] = mediaFileWithBytes;

    // Update memory usage statistics
    if (mediaFileWithBytes.bytes != null) {
      _currentMemoryUsage += mediaFileWithBytes.bytes!.length;
    }

    _logger.info(
      'Registered media file: ${mediaFileWithBytes.name} '
      '(${_formatFileSize(mediaFileWithBytes.size)}) '
      'Total memory: ${_formatFileSize(_currentMemoryUsage)}',
    );

    // Check if memory cleanup is needed
    _checkMemoryUsage();
  }

  /// Batch register media file list
  ///
  /// [mediaFiles] Media file list
  void registerActiveMediaList(List<MediaFile> mediaFiles) {
    for (final mediaFile in mediaFiles) {
      registerActiveMedia(mediaFile);
    }
  }

  /// Register single active media file
  ///
  /// [mediaFile] Media file
  void registerActiveMedia(MediaFile mediaFile) {
    final mediaFileWithBytes = MediaFileWithBytes(mediaFile: mediaFile);
    registerMediaFile(mediaFileWithBytes);
  }

  /// Unregister media file from memory manager (compatibility method)
  ///
  /// [mediaFile] Media file
  void unregisterMedia(MediaFile mediaFile) {
    unregisterMediaFile(mediaFile.id);
  }

  /// Get image provider
  ///
  /// [mediaFile] Media file
  /// Returns: Image provider or null
  ImageProvider? getImageProvider(MediaFile mediaFile) {
    if (mediaFile.type != MediaType.image) {
      return null;
    }

    // First try to get from memory
    final activeFile = _activeMediaFiles[mediaFile.id];
    if (activeFile?.bytes != null) {
      return MemoryImage(activeFile!.bytes!);
    }

    // Second try to load from file path
    final file = File(mediaFile.path);
    if (file.existsSync()) {
      return FileImage(file);
    }

    return null;
  }

  /// Batch register media files
  ///
  /// [mediaFiles] Media file list
  void registerMediaFiles(List<MediaFileWithBytes> mediaFiles) {
    for (final mediaFile in mediaFiles) {
      registerMediaFile(mediaFile);
    }
  }

  /// Unregister media file from memory manager
  ///
  /// [mediaFileId] Media file ID
  void unregisterMediaFile(String mediaFileId) {
    final mediaFile = _activeMediaFiles.remove(mediaFileId);
    if (mediaFile != null) {
      // Update memory usage statistics
      if (mediaFile.bytes != null) {
        _currentMemoryUsage -= mediaFile.bytes!.length;
      }

      // Clean up related thumbnail cache
      MediaThumbnailService.removeCacheForFile(mediaFileId);

      _logger.info(
        'Unregistered media file: ${mediaFile.name} '
        'Remaining memory: ${_formatFileSize(_currentMemoryUsage)}',
      );
    }
  }

  /// Batch unregister media files
  ///
  /// [mediaFileIds] Media file ID list
  void unregisterMediaFiles(List<String> mediaFileIds) {
    for (final id in mediaFileIds) {
      unregisterMediaFile(id);
    }
  }

  /// Batch unregister media file list (compatibility method)
  ///
  /// [mediaFiles] Media file list
  void unregisterMediaList(List<MediaFile> mediaFiles) {
    for (final mediaFile in mediaFiles) {
      unregisterMediaFile(mediaFile.id);
    }
  }

  /// Clear all registered media files
  void clearAllMediaFiles() {
    final fileIds = _activeMediaFiles.keys.toList();
    unregisterMediaFiles(fileIds);

    // Clear thumbnail cache
    MediaThumbnailService.clearCache();

    _logger.info('Cleared all media files from memory manager');
  }

  /// Check memory usage
  void _checkMemoryUsage() {
    if (_currentMemoryUsage > memoryThresholdBytes) {
      _logger.warning(
        'Memory usage (${_formatFileSize(_currentMemoryUsage)}) '
        'exceeds threshold (${_formatFileSize(memoryThresholdBytes)}), '
        'triggering cleanup',
      );
      _performMemoryCleanup();
    }

    // Periodic cleanup
    _performPeriodicCleanup();
  }

  /// Perform memory cleanup
  void _performMemoryCleanup() {
    // Clear thumbnail cache
    MediaThumbnailService.clearCache();

    // If memory usage is still high, clean up oldest media files
    if (_currentMemoryUsage > memoryThresholdBytes) {
      _cleanupOldestMediaFiles();
    }

    _lastCleanupTime = DateTime.now();

    _logger.info(
      'Memory cleanup completed. Current usage: ${_formatFileSize(_currentMemoryUsage)}',
    );
  }

  /// Clean up oldest media files (based on registration order)
  void _cleanupOldestMediaFiles() {
    final sortedFiles = _activeMediaFiles.entries.toList();

    // Remove 25% of files to release memory
    final removeCount = (sortedFiles.length * 0.25).ceil();

    for (int i = 0; i < removeCount && i < sortedFiles.length; i++) {
      final entry = sortedFiles[i];
      unregisterMediaFile(entry.key);

      // Stop cleanup if memory usage drops below threshold
      if (_currentMemoryUsage <= memoryThresholdBytes * 0.8) {
        break;
      }
    }

    _logger.info('Cleaned up $removeCount oldest media files');
  }

  /// Perform periodic cleanup
  void _performPeriodicCleanup() {
    final now = DateTime.now();

    if (_lastCleanupTime == null ||
        now.difference(_lastCleanupTime!).inMinutes >= cleanupIntervalMinutes) {
      // Clear thumbnail cache
      MediaThumbnailService.clearCache();

      _lastCleanupTime = now;

      _logger.info('Performed periodic memory cleanup');
    }
  }

  /// Get memory usage statistics (compatibility method)
  ///
  /// Returns: Map containing memory usage information
  Map<String, dynamic> getMemoryUsage() {
    return {
      'trackedItemsCount': _activeMediaFiles.length,
      'currentMemoryUsage': _currentMemoryUsage,
      'currentMemoryUsageMB': (_currentMemoryUsage / (1024 * 1024))
          .toStringAsFixed(2),
      'memoryThresholdMB': (memoryThresholdBytes / (1024 * 1024))
          .toStringAsFixed(2),
      'memoryUsagePercentage':
          ((_currentMemoryUsage / memoryThresholdBytes) * 100).toStringAsFixed(
            1,
          ),
      'lastCleanupTime': _lastCleanupTime?.toIso8601String(),
    };
  }

  /// Clear all registered media files (compatibility method)
  void clearAll() {
    clearAllMediaFiles();
  }

  /// Get memory usage statistics
  ///
  /// Returns: Map containing memory usage information
  Map<String, dynamic> getMemoryStats() {
    final thumbnailStats = MediaThumbnailService.getCacheStats();

    return {
      'activeMediaFiles': _activeMediaFiles.length,
      'currentMemoryUsage': _currentMemoryUsage,
      'currentMemoryUsageMB': (_currentMemoryUsage / (1024 * 1024))
          .toStringAsFixed(2),
      'memoryThresholdMB': (memoryThresholdBytes / (1024 * 1024))
          .toStringAsFixed(2),
      'memoryUsagePercentage':
          ((_currentMemoryUsage / memoryThresholdBytes) * 100).toStringAsFixed(
            1,
          ),
      'lastCleanupTime': _lastCleanupTime?.toIso8601String(),
      'thumbnailCache': thumbnailStats,
    };
  }

  /// Force memory cleanup
  ///
  /// Manually trigger memory cleanup, for testing or special cases
  void forceCleanup() {
    _logger.warning('Force cleanup triggered');
    _performMemoryCleanup();
  }

  /// Get specified media file
  ///
  /// [mediaFileId] Media file ID
  /// Returns: Media file, or null if not exists
  MediaFileWithBytes? getMediaFile(String mediaFileId) {
    return _activeMediaFiles[mediaFileId];
  }

  /// Get all active media files
  ///
  /// Returns: All registered media file list
  List<MediaFileWithBytes> getAllMediaFiles() {
    return _activeMediaFiles.values.toList();
  }

  /// Check if near memory limit
  ///
  /// Returns: True if memory usage exceeds 80% of threshold
  bool isNearMemoryLimit() {
    return _currentMemoryUsage > (memoryThresholdBytes * 0.8);
  }

  /// Estimate memory usage after adding new file
  ///
  /// [newFileSize] New file size
  /// Returns: Estimated memory usage after adding new file
  int estimateMemoryUsageAfterAdd(int newFileSize) {
    return _currentMemoryUsage + newFileSize;
  }

  /// Check if can add new file without exceeding memory limit
  ///
  /// [newFileSize] New file size
  /// Returns: True if can add
  bool canAddFile(int newFileSize) {
    return estimateMemoryUsageAfterAdd(newFileSize) <= memoryThresholdBytes;
  }

  /// Optimize memory usage
  ///
  /// Optimize memory usage by compressing images and clearing cache
  Future<void> optimizeMemoryUsage() async {
    _logger.info('Starting memory optimization');

    // Clear thumbnail cache
    MediaThumbnailService.clearCache();

    // Compress large images
    final largeImages = _activeMediaFiles.values
        .where(
          (mf) =>
              mf.type == MediaType.image &&
              mf.bytes != null &&
              mf.bytes!.length > 2 * 1024 * 1024,
        ) // Images larger than 2MB
        .toList();

    for (final mediaFile in largeImages) {
      try {
        final compressedBytes = await MediaThumbnailService.compressImage(
          mediaFile.bytes!,
          maxWidth: 1920,
          maxHeight: 1080,
          quality: 85,
        );

        if (compressedBytes.length < mediaFile.bytes!.length) {
          // Update memory usage statistics
          final oldSize = mediaFile.bytes!.length;
          final newSize = compressedBytes.length;
          _currentMemoryUsage -= oldSize;
          _currentMemoryUsage += newSize;

          // Update file data
          final compressedMediaFile = MediaFileWithBytes(
            mediaFile: mediaFile.mediaFile.copyWith(
              size: compressedBytes.length,
            ),
            bytes: compressedBytes,
          );

          _activeMediaFiles[mediaFile.id] = compressedMediaFile;

          _logger.info(
            'Compressed ${mediaFile.name}: '
            '${_formatFileSize(mediaFile.bytes!.length)} -> '
            '${_formatFileSize(compressedBytes.length)}',
          );
        }
      } catch (e) {
        _logger.warning('Failed to compress ${mediaFile.name}', e);
      }
    }

    _logger.info(
      'Memory optimization completed. Current usage: ${_formatFileSize(_currentMemoryUsage)}',
    );
  }

  /// Format file size as readable string
  ///
  /// [bytes] Number of bytes
  /// Returns: Formatted string, e.g. "1.5 MB"
  String _formatFileSize(int bytes) {
    if (bytes < 0) return '0 B';

    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    int unitIndex = 0;
    double size = bytes.toDouble();

    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }

    // Display as integer for bytes; otherwise display with one decimal place
    if (unitIndex == 0) {
      return '${size.toInt()} ${units[unitIndex]}';
    } else {
      return '${size.toStringAsFixed(1)} ${units[unitIndex]}';
    }
  }
}
