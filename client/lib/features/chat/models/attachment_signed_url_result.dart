import 'package:flutter/foundation.dart';

class AttachmentSignedUrlResult {
  final List<AttachmentSignedUrlInfo> successful;
  final List<AttachmentSignedUrlFailure> failed;

  const AttachmentSignedUrlResult({
    this.successful = const [],
    this.failed = const [],
  });

  factory AttachmentSignedUrlResult.fromJson(Map<String, dynamic> json) {
    final successfulList = json['successful'];
    final failedList = json['failed'];

    return AttachmentSignedUrlResult(
      successful: _parseInfoList(successfulList),
      failed: _parseFailureList(failedList),
    );
  }

  static const empty = AttachmentSignedUrlResult();

  bool get hasSuccess => successful.isNotEmpty;

  bool get hasFailures => failed.isNotEmpty;

  static List<AttachmentSignedUrlInfo> _parseInfoList(dynamic value) {
    if (value is! List) return const [];

    final result = <AttachmentSignedUrlInfo>[];
    for (final entry in value) {
      if (entry is Map<String, dynamic>) {
        result.add(AttachmentSignedUrlInfo.fromJson(entry));
      } else if (entry is Map) {
        result.add(
          AttachmentSignedUrlInfo.fromJson(entry.cast<String, dynamic>()),
        );
      }
    }
    return result;
  }

  static List<AttachmentSignedUrlFailure> _parseFailureList(dynamic value) {
    if (value is! List) return const [];

    final result = <AttachmentSignedUrlFailure>[];
    for (final entry in value) {
      if (entry is Map<String, dynamic>) {
        result.add(AttachmentSignedUrlFailure.fromJson(entry));
      } else if (entry is Map) {
        result.add(
          AttachmentSignedUrlFailure.fromJson(entry.cast<String, dynamic>()),
        );
      }
    }
    return result;
  }
}

@immutable
class AttachmentSignedUrlInfo {
  final String id;
  final String filename;
  final String signedUrl;
  final DateTime? expiresAt;

  const AttachmentSignedUrlInfo({
    required this.id,
    required this.filename,
    required this.signedUrl,
    this.expiresAt,
  });

  factory AttachmentSignedUrlInfo.fromJson(Map<String, dynamic> json) {
    return AttachmentSignedUrlInfo(
      id: _readRequiredString(json, 'id', 'attachment_id'),
      filename: _readRequiredString(json, 'filename', 'object_key'),
      signedUrl: _readRequiredString(json, 'signed_url', 'signedUrl'),
      expiresAt: _readOptionalDateTime(json, 'expires_at', 'expiresAt'),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'filename': filename,
      'signed_url': signedUrl,
      if (expiresAt != null) 'expires_at': expiresAt!.toIso8601String(),
    };
  }
}

@immutable
class AttachmentSignedUrlFailure {
  final String? id;
  final String? filename;
  final String? error;
  final int? errorCode;
  final String? message;

  const AttachmentSignedUrlFailure({
    this.id,
    this.filename,
    this.error,
    this.errorCode,
    this.message,
  });

  factory AttachmentSignedUrlFailure.fromJson(Map<String, dynamic> json) {
    return AttachmentSignedUrlFailure(
      id: _readOptionalString(json, 'id', 'attachment_id'),
      filename: _readOptionalString(json, 'filename', 'object_key'),
      error: _readOptionalString(json, 'error', 'error'),
      errorCode: _readOptionalInt(json, 'error_code', 'errorCode'),
      message: _readOptionalString(json, 'message', 'message'),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (id != null) 'id': id,
      if (filename != null) 'filename': filename,
      if (error != null) 'error': error,
      if (errorCode != null) 'error_code': errorCode,
      if (message != null) 'message': message,
    };
  }

  String? get displayMessage => error ?? message;
}

String _readRequiredString(
  Map<String, dynamic> json,
  String primaryKey,
  String fallbackKey,
) {
  final value = json[primaryKey] ?? json[fallbackKey];
  if (value == null) {
    throw FormatException('Missing required field `$primaryKey`');
  }
  final stringValue = value.toString();
  if (stringValue.isEmpty) {
    throw FormatException('Required field `$primaryKey` cannot be empty');
  }
  return stringValue;
}

String? _readOptionalString(
  Map<String, dynamic> json,
  String primaryKey,
  String fallbackKey,
) {
  final value = json[primaryKey] ?? json[fallbackKey];
  if (value == null) return null;
  final stringValue = value.toString();
  return stringValue.isEmpty ? null : stringValue;
}

int? _readOptionalInt(
  Map<String, dynamic> json,
  String primaryKey,
  String fallbackKey,
) {
  final value = json[primaryKey] ?? json[fallbackKey];
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  final parsed = int.tryParse(value.toString());
  return parsed;
}

DateTime? _readOptionalDateTime(
  Map<String, dynamic> json,
  String primaryKey,
  String fallbackKey,
) {
  final value = json[primaryKey] ?? json[fallbackKey];
  if (value == null) return null;
  if (value is DateTime) return value;
  final stringValue = value.toString();
  if (stringValue.isEmpty) return null;
  return DateTime.tryParse(stringValue);
}
