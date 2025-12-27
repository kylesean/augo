import 'dart:async';
import 'package:logging/logging.dart';
// ignore: unused_import - Used conditionally on non-web platforms
import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../../../core/network/network_client.dart';
import '../../../core/network/exceptions/app_exception.dart';

/// Upload progress listener
typedef ProgressCallback = void Function(int bytes, int total);

/// Progress event
class ProgressEvent {
  final int bytes;
  final int total;

  ProgressEvent({required this.bytes, required this.total});

  double get progress => total == 0 ? 0 : bytes / total;
}

class FileUploadService {
  final NetworkClient _networkClient;
  final SecureStorageService _storageService;
  final _logger = Logger('FileUploadService');

  FileUploadService(this._networkClient, this._storageService);

  /// Get correct MIME type from file extension
  static String? _getMimeTypeFromExtension(String fileName) {
    final extension = fileName.toLowerCase().split('.').last;

    switch (extension) {
      // Image formats
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'bmp':
        return 'image/bmp';
      case 'svg':
        return 'image/svg+xml';

      // Video formats
      case 'mp4':
        return 'video/mp4';
      case 'avi':
        return 'video/x-msvideo';
      case 'mov':
        return 'video/quicktime';
      case 'wmv':
        return 'video/x-ms-wmv';

      // Audio formats
      case 'mp3':
        return 'audio/mpeg';
      case 'wav':
        return 'audio/wav';
      case 'm4a':
        return 'audio/mp4';

      // Document formats
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'xls':
        return 'application/vnd.ms-excel';
      case 'xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      case 'ppt':
        return 'application/vnd.ms-powerpoint';
      case 'pptx':
        return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
      case 'txt':
        return 'text/plain';

      // Compressed files
      case 'zip':
        return 'application/zip';
      case 'rar':
        return 'application/vnd.rar';

      default:
        return null; // Let Dio auto-detect
    }
  }

  /// Upload files using Dio to handle FormData directly, but unified error handling
  Future<FileUploadResult> uploadFiles(
    List<XFile> files, {
    ProgressCallback? onProgress,
  }) async {
    if (files.isEmpty) {
      throw FileUploadException('No files selected to upload');
    }

    _logger.info(
      'File upload started: count=${files.length}, target=/files/upload',
    );
    for (var i = 0; i < files.length; i++) {
      _logger.info('File $i: ${files[i].name} (${files[i].path})');
    }

    try {
      final formData = await _buildFormData(files);
      _logger.info('FormData built, sending request...');

      // Use NetworkClient's Dio instance directly, enjoying all interceptors
      final response = await _networkClient.dio.post(
        '/files/upload',
        data: formData,
        onSendProgress: (sent, total) {
          _logger.fine(
            'Upload progress: $sent / $total (${(sent / total * 100).toStringAsFixed(1)}%)',
          );
          onProgress?.call(sent, total);
        },
      );

      _logger.info('Upload status code: ${response.statusCode}');
      _logger.finer('Response data: ${response.data}');

      // BusinessInterceptor has already processed API response format, response.data is the data part
      if (response.data is Map<String, dynamic>) {
        try {
          final jsonData = response.data as Map<String, dynamic>;
          final dataField = jsonData['data'] as Map<String, dynamic>;
          final result = FileUploadResult.fromJson(dataField);
          _logger.info(
            'Upload result parsed successfully: successful=${result.summary.successfulCount}, failed=${result.summary.failedCount}',
          );

          for (var upload in result.uploads) {
            _logger.info(
              '✓ ${upload.originalName} -> objectKey: ${upload.objectKey}',
            );
          }

          for (var failure in result.failures) {
            _logger.warning('✗ ${failure.fileName}: ${failure.error}');
          }

          return result;
        } catch (e, stackTrace) {
          _logger.severe('Failed to parse upload result', e, stackTrace);
          throw DataParsingException('Failed to parse file upload result: $e');
        }
      }
      throw DataParsingException(
        'File upload API expected object, but received ${response.data.runtimeType}',
      );
    } catch (e, stackTrace) {
      _logger.severe('Upload exception occurred', e, stackTrace);

      // Errors have been handled by interceptor as AppException
      if (e is AppException) {
        throw FileUploadException('Upload failed: ${e.message}');
      }
      throw FileUploadException('Error occurred during upload: $e');
    }
  }

  /// Build FormData for file upload
  /// Use conditional compilation: iOS/Android use efficient fromFile, Web uses fromBytes
  Future<FormData> _buildFormData(List<XFile> files) async {
    final formData = FormData();

    for (final file in files) {
      // Determine correct MIME type based on file extension
      String? mimeType = _getMimeTypeFromExtension(file.name);
      _logger.fine('File: ${file.name}, MIME: ${mimeType ?? "auto"}');

      late MultipartFile multipartFile;

      if (kIsWeb) {
        // Web platform: use fromBytes (dart:io not available on Web)
        final bytes = await file.readAsBytes();
        multipartFile = MultipartFile.fromBytes(
          bytes,
          filename: file.name,
          contentType: mimeType != null ? MediaType.parse(mimeType) : null,
        );
      } else {
        // iOS/Android: use efficient fromFile (stream reading, more memory-efficient)
        multipartFile = await MultipartFile.fromFile(
          file.path,
          filename: file.name,
          contentType: mimeType != null ? MediaType.parse(mimeType) : null,
        );
      }

      formData.files.add(MapEntry('files[]', multipartFile));
    }

    return formData;
  }
}

/// File upload result
/// Contains information about uploaded and failed files
class FileUploadResult {
  final UploadSummary summary;
  final List<UploadedFile> uploads;
  final List<UploadFailure> failures;

  FileUploadResult({
    required this.summary,
    required this.uploads,
    required this.failures,
  });

  factory FileUploadResult.fromJson(Map<String, dynamic> json) {
    return FileUploadResult(
      summary: UploadSummary.fromJson(json['summary']),
      uploads: (json['uploads'] as List)
          .map((upload) => UploadedFile.fromJson(upload))
          .toList(),
      failures:
          (json['failures'] as List?)
              ?.map((failure) => UploadFailure.fromJson(failure))
              .toList() ??
          [],
    );
  }
}

/// Upload summary information
class UploadSummary {
  final int total;
  final int successfulCount;
  final int failedCount;

  UploadSummary({
    required this.total,
    required this.successfulCount,
    required this.failedCount,
  });

  factory UploadSummary.fromJson(Map<String, dynamic> json) {
    return UploadSummary(
      total: json['total'] as int,
      successfulCount: json['successfulCount'] as int,
      failedCount: json['failedCount'] as int,
    );
  }
}

/// Information about successfully uploaded files
class UploadedFile {
  final String id; // attachmentId (UUID)
  final String attachmentId; // Explicit attachmentId field
  final String originalName;
  final String fileKey; // File storage path (original objectKey)
  final String uri; // File access URI
  final double size;
  final String mimeType;
  final String? hash; // File hash value
  final bool compressed; // Whether compressed
  final String? threadId; // Associated session ID

  UploadedFile({
    required this.id,
    required this.attachmentId,
    required this.originalName,
    required this.fileKey,
    required this.uri,
    required this.size,
    required this.mimeType,
    this.hash,
    this.compressed = false,
    this.threadId,
  });

  factory UploadedFile.fromJson(Map<String, dynamic> json) {
    return UploadedFile(
      id: json['id']?.toString() ?? '',
      attachmentId: json['attachmentId']?.toString() ?? '',
      originalName:
          json['originalName'] as String? ?? json['filename'] as String? ?? '',
      fileKey: json['fileKey'] as String? ?? '',
      uri: json['uri'] as String? ?? '',
      size: (json['size'] as num?)?.toDouble() ?? 0,
      mimeType: json['mimeType'] as String? ?? 'application/octet-stream',
      hash: json['hash'] as String?,
      compressed: json['compressed'] as bool? ?? false,
      threadId: json['threadId'] as String?,
    );
  }

  // Compatibility: objectKey maps to fileKey
  String get objectKey => fileKey;

  bool get isImage => mimeType.startsWith('image/');
}

/// Information about failed uploads
class UploadFailure {
  final String fileName;
  final String error;
  final String? errorCode;

  UploadFailure({required this.fileName, required this.error, this.errorCode});

  factory UploadFailure.fromJson(Map<String, dynamic> json) {
    return UploadFailure(
      fileName: json['filename'] as String? ?? 'unknown',
      error: json['error'] as String? ?? 'Unknown error',
      errorCode: json['errorCode'] as String?,
    );
  }
}

/// File upload exception
class FileUploadException implements Exception {
  final String message;

  FileUploadException(this.message);

  @override
  String toString() => 'FileUploadException: $message';
}

// Provider for FileUploadService
final fileUploadServiceProvider = Provider<FileUploadService>((ref) {
  final networkClient = ref.watch(networkClientProvider);
  final storageService = ref.watch(secureStorageServiceProvider);
  return FileUploadService(networkClient, storageService);
});
