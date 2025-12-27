/// Media upload error type enum
/// Defines all possible media upload error types
enum MediaUploadError {
  /// File size exceeds limit
  fileSizeExceeded,

  /// Unsupported file format
  unsupportedFormat,

  /// Permission denied
  permissionDenied,

  /// Insufficient storage space
  storageInsufficient,

  /// Network error
  networkError,

  /// No files selected
  noFilesSelected,

  /// Platform not supported
  platformNotSupported,

  /// File read error
  fileReadError,

  /// File not found
  fileNotFound,

  /// File validation failed
  validationError,

  /// Thumbnail generation failed
  thumbnailGenerationError,

  /// Unknown error
  unknownError,
}

/// Media upload exception class
/// Unified media upload error handling exception class
class MediaUploadException implements Exception {
  /// Create media upload exception
  ///
  /// [type] Error type
  /// [message] Error message
  /// [originalError] Original error object (optional)
  const MediaUploadException(this.type, this.message, [this.originalError]);

  /// Error type
  final MediaUploadError type;

  /// Error message
  final String message;

  /// Original error object
  final dynamic originalError;

  @override
  String toString() => 'MediaUploadException: $message';

  /// Create file size exceeded exception
  ///
  /// [actualSize] Actual file size
  /// [maxSize] Maximum allowed size
  /// [fileName] File name (optional)
  factory MediaUploadException.fileSizeExceeded({
    required int actualSize,
    required int maxSize,
    String? fileName,
  }) {
    final actualSizeFormatted = _formatFileSize(actualSize);
    final maxSizeFormatted = _formatFileSize(maxSize);
    final fileInfo = fileName != null ? ' ($fileName)' : '';

    return MediaUploadException(
      MediaUploadError.fileSizeExceeded,
      'File size $actualSizeFormatted exceeds limit $maxSizeFormatted$fileInfo',
    );
  }

  /// Create unsupported format exception
  ///
  /// [extension] File extension
  /// [fileName] File name (optional)
  /// [supportedFormats] List of supported formats (optional)
  factory MediaUploadException.unsupportedFormat({
    required String extension,
    String? fileName,
    String? supportedFormats,
  }) {
    final fileInfo = fileName != null ? ' ($fileName)' : '';
    final supportedInfo = supportedFormats != null
        ? '\nSupported formats: $supportedFormats'
        : '';

    return MediaUploadException(
      MediaUploadError.unsupportedFormat,
      'Unsupported file format: .$extension$fileInfo$supportedInfo',
    );
  }

  /// Create permission denied exception
  ///
  /// [permissionType] Permission type description
  factory MediaUploadException.permissionDenied({
    required String permissionType,
  }) {
    return MediaUploadException(
      MediaUploadError.permissionDenied,
      'Requires $permissionType permission to select files, please enable relevant permissions in settings',
    );
  }

  /// Create insufficient storage exception
  ///
  /// [requiredSpace] Required space size (optional)
  factory MediaUploadException.storageInsufficient({int? requiredSpace}) {
    final spaceInfo = requiredSpace != null
        ? ', requires ${_formatFileSize(requiredSpace)} space'
        : '';

    return MediaUploadException(
      MediaUploadError.storageInsufficient,
      'Device storage insufficient$spaceInfo, please clear device storage and try again',
    );
  }

  /// Create network error exception
  ///
  /// [message] Error message
  /// [originalError] Original network error
  factory MediaUploadException.networkError({
    String? message,
    dynamic originalError,
  }) {
    return MediaUploadException(
      MediaUploadError.networkError,
      message ?? 'Network connection failed, please check network connection and try again',
      originalError,
    );
  }

  /// Create no files selected exception
  factory MediaUploadException.noFilesSelected() {
    return const MediaUploadException(
      MediaUploadError.noFilesSelected,
      'No files selected',
    );
  }

  /// Create platform not supported exception
  ///
  /// [platform] Platform name
  /// [feature] Unsupported feature
  factory MediaUploadException.platformNotSupported({
    required String platform,
    required String feature,
  }) {
    return MediaUploadException(
      MediaUploadError.platformNotSupported,
      '$platform platform does not support $feature feature',
    );
  }

  /// Create file read error exception
  ///
  /// [fileName] File name
  /// [originalError] Original error
  factory MediaUploadException.fileReadError({
    required String fileName,
    dynamic originalError,
  }) {
    return MediaUploadException(
      MediaUploadError.fileReadError,
      'Cannot read file: $fileName',
      originalError,
    );
  }

  /// Create file not found exception
  ///
  /// [filePath] File path
  factory MediaUploadException.fileNotFound({required String filePath}) {
    return MediaUploadException(
      MediaUploadError.fileNotFound,
      'File not found: $filePath',
    );
  }

  /// Create file validation failed exception
  ///
  /// [fileName] File name
  /// [reason] Validation failure reason
  factory MediaUploadException.validationError({
    required String fileName,
    required String reason,
  }) {
    return MediaUploadException(
      MediaUploadError.validationError,
      'File validation failed ($fileName): $reason',
    );
  }

  /// Create thumbnail generation failed exception
  ///
  /// [fileName] File name
  /// [originalError] Original error
  factory MediaUploadException.thumbnailGenerationError({
    required String fileName,
    dynamic originalError,
  }) {
    return MediaUploadException(
      MediaUploadError.thumbnailGenerationError,
      'Cannot generate thumbnail for file $fileName',
      originalError,
    );
  }

  /// Create unknown error exception
  ///
  /// [originalError] Original error
  factory MediaUploadException.unknownError({dynamic originalError}) {
    return MediaUploadException(
      MediaUploadError.unknownError,
      'Unknown error occurred, please try again',
      originalError,
    );
  }

  /// Format file size as readable string
  ///
  /// [bytes] Number of bytes
  /// Returns: Formatted string, e.g., "1.5 MB"
  static String _formatFileSize(int bytes) {
    if (bytes < 0) return '0 B';

    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    int unitIndex = 0;
    double size = bytes.toDouble();

    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }

    // If bytes, display as integer; otherwise display with one decimal place
    if (unitIndex == 0) {
      return '${size.toInt()} ${units[unitIndex]}';
    } else {
      return '${size.toStringAsFixed(1)} ${units[unitIndex]}';
    }
  }
}
