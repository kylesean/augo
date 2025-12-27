import 'package:image_picker/image_picker.dart';

class UploadedAttachmentInfo {
  final String id; // attachmentId
  final String attachmentId; // Explicit attachmentId field
  final String originalName;
  final String objectKey;
  final String uri; // File access URI
  final String mimeType;
  final double size;
  final String? hash; // File hash value

  const UploadedAttachmentInfo({
    required this.id,
    required this.attachmentId,
    required this.originalName,
    required this.objectKey,
    required this.uri,
    required this.mimeType,
    required this.size,
    this.hash,
  });

  int get sizeBytes => size % 1 == 0 ? size.toInt() : (size * 1024).round();

  /// Convert to AI attachment format (simplified version, only includes id and type)
  Map<String, dynamic> toAIAttachment() {
    // Determine attachment type based on mimeType
    String attachmentType = 'other';
    if (mimeType.startsWith('image/')) {
      attachmentType = 'image';
    } else if (mimeType.startsWith('text/')) {
      attachmentType = 'text';
    } else if (mimeType.contains('pdf') ||
        mimeType.contains('document') ||
        mimeType.contains('word') ||
        mimeType.contains('excel') ||
        mimeType.contains('powerpoint')) {
      attachmentType = 'document';
    }

    return {'id': attachmentId, 'type': attachmentType};
  }
}

class PendingMessageAttachment {
  final XFile file;
  final UploadedAttachmentInfo uploadInfo;

  const PendingMessageAttachment({
    required this.file,
    required this.uploadInfo,
  });
}
