import 'package:flutter/foundation.dart';

enum AttachmentLoadStatus { initial, loading, loaded, failed }

@immutable
class ChatMessageAttachment {
  final String id;
  final String filename;
  final String? signedUrl;
  final DateTime? expiresAt;
  final AttachmentLoadStatus status;
  final String? errorMessage;

  const ChatMessageAttachment({
    required this.id,
    required this.filename,
    this.signedUrl,
    this.expiresAt,
    this.status = AttachmentLoadStatus.initial,
    this.errorMessage,
  });

  bool get hasSignedUrl => signedUrl != null && signedUrl!.isNotEmpty;

  String get fileExtension {
    final name = filename;
    final dotIndex = name.lastIndexOf('.');
    if (dotIndex == -1 || dotIndex == name.length - 1) {
      return '';
    }
    return name.substring(dotIndex + 1).toLowerCase();
  }

  bool get isPreviewable {
    const imageExtensions = <String>{
      'jpg',
      'jpeg',
      'png',
      'gif',
      'webp',
      'bmp',
      'svg',
    };
    return imageExtensions.contains(fileExtension);
  }

  ChatMessageAttachment copyWith({
    String? id,
    String? filename,
    String? signedUrl,
    DateTime? expiresAt,
    AttachmentLoadStatus? status,
    String? errorMessage,
  }) {
    return ChatMessageAttachment(
      id: id ?? this.id,
      filename: filename ?? this.filename,
      signedUrl: signedUrl ?? this.signedUrl,
      expiresAt: expiresAt ?? this.expiresAt,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory ChatMessageAttachment.fromJson(Map<String, dynamic> json) {
    return ChatMessageAttachment(
      id: _readRequiredString(json, 'id', 'attachmentId'),
      filename: _readRequiredString(json, 'filename', 'objectKey'),
      signedUrl: _readOptionalString(json, 'signedUrl', 'signed_url'),
      expiresAt: _readOptionalDateTime(json, 'expiresAt', 'expires_at'),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'filename': filename,
      if (signedUrl != null) 'signed_url': signedUrl,
      if (expiresAt != null) 'expires_at': expiresAt!.toIso8601String(),
    };
  }

  static String _readRequiredString(
    Map<String, dynamic> json,
    String primaryKey,
    String fallbackKey,
  ) {
    final value = json[primaryKey] ?? json[fallbackKey];
    if (value is String && value.isNotEmpty) {
      return value;
    }
    // Fallback for filename: try deriving from object_key or just return unknown
    if (primaryKey == 'filename' && fallbackKey == 'object_key') {
      // Note: object_key often contains the filename
      return 'unknown_file';
    }

    // Allow empty strings for robustness?
    // No, user wants id to be required.
    throw FormatException(
      'Missing required field: $primaryKey (or $fallbackKey)',
    );
  }

  static String? _readOptionalString(
    Map<String, dynamic> json,
    String primaryKey,
    String fallbackKey,
  ) {
    final value = json[primaryKey] ?? json[fallbackKey];
    if (value == null) return null;
    return value.toString();
  }

  static DateTime? _readOptionalDateTime(
    Map<String, dynamic> json,
    String primaryKey,
    String fallbackKey,
  ) {
    final value = json[primaryKey] ?? json[fallbackKey];
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}
