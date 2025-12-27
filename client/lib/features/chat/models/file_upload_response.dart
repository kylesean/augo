// features/chat/models/file_upload_response.dart
import 'package:json_annotation/json_annotation.dart';

part 'file_upload_response.g.dart';

/// File upload response model
@JsonSerializable()
class FileUploadResponse {
  final FileUploadSummary summary;
  final List<UploadedFile> uploads;
  final List<UploadFailure> failures;

  const FileUploadResponse({
    required this.summary,
    required this.uploads,
    required this.failures,
  });

  factory FileUploadResponse.fromJson(Map<String, dynamic> json) =>
      _$FileUploadResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FileUploadResponseToJson(this);

  /// Check if there are any upload failures
  bool get hasFailures => failures.isNotEmpty;

  /// Check if all uploads were successful
  bool get isAllSuccess => failures.isEmpty && uploads.isNotEmpty;

  /// Get list of successfully uploaded file URLs
  List<String> get successObjectKeys =>
      uploads.map((file) => file.objectKey).toList();
}

/// File upload summary
@JsonSerializable()
class FileUploadSummary {
  final int total;
  final int successfulCount;
  final int failedCount;

  const FileUploadSummary({
    required this.total,
    required this.successfulCount,
    required this.failedCount,
  });

  factory FileUploadSummary.fromJson(Map<String, dynamic> json) =>
      _$FileUploadSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$FileUploadSummaryToJson(this);
}

/// Information for successfully uploaded files
@JsonSerializable()
class UploadedFile {
  final String originalName;
  final String objectKey;
  final double size;
  final String mimeType;

  const UploadedFile({
    required this.originalName,
    required this.objectKey,
    required this.size,
    required this.mimeType,
  });

  factory UploadedFile.fromJson(Map<String, dynamic> json) =>
      _$UploadedFileFromJson(json);

  Map<String, dynamic> toJson() => _$UploadedFileToJson(this);

  String get formattedSize => '${size.toStringAsFixed(2)} KB';

  bool get isImage => mimeType.startsWith('image/');
}

/// Information for failed uploads
@JsonSerializable()
class UploadFailure {
  final int index;
  @JsonKey(name: 'filename')
  final String fileName;
  final String error;
  final int? errorCode;

  const UploadFailure({
    required this.index,
    required this.fileName,
    required this.error,
    this.errorCode,
  });

  factory UploadFailure.fromJson(Map<String, dynamic> json) =>
      _$UploadFailureFromJson(json);

  Map<String, dynamic> toJson() => _$UploadFailureToJson(this);
}
