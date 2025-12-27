// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_upload_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileUploadResponse _$FileUploadResponseFromJson(Map<String, dynamic> json) =>
    FileUploadResponse(
      summary: FileUploadSummary.fromJson(
        json['summary'] as Map<String, dynamic>,
      ),
      uploads: (json['uploads'] as List<dynamic>)
          .map((e) => UploadedFile.fromJson(e as Map<String, dynamic>))
          .toList(),
      failures: (json['failures'] as List<dynamic>)
          .map((e) => UploadFailure.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FileUploadResponseToJson(FileUploadResponse instance) =>
    <String, dynamic>{
      'summary': instance.summary,
      'uploads': instance.uploads,
      'failures': instance.failures,
    };

FileUploadSummary _$FileUploadSummaryFromJson(Map<String, dynamic> json) =>
    FileUploadSummary(
      total: (json['total'] as num).toInt(),
      successfulCount: (json['successfulCount'] as num).toInt(),
      failedCount: (json['failedCount'] as num).toInt(),
    );

Map<String, dynamic> _$FileUploadSummaryToJson(FileUploadSummary instance) =>
    <String, dynamic>{
      'total': instance.total,
      'successfulCount': instance.successfulCount,
      'failedCount': instance.failedCount,
    };

UploadedFile _$UploadedFileFromJson(Map<String, dynamic> json) => UploadedFile(
  originalName: json['originalName'] as String,
  objectKey: json['objectKey'] as String,
  size: (json['size'] as num).toDouble(),
  mimeType: json['mimeType'] as String,
);

Map<String, dynamic> _$UploadedFileToJson(UploadedFile instance) =>
    <String, dynamic>{
      'originalName': instance.originalName,
      'objectKey': instance.objectKey,
      'size': instance.size,
      'mimeType': instance.mimeType,
    };

UploadFailure _$UploadFailureFromJson(Map<String, dynamic> json) =>
    UploadFailure(
      index: (json['index'] as num).toInt(),
      fileName: json['filename'] as String,
      error: json['error'] as String,
      errorCode: (json['errorCode'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UploadFailureToJson(UploadFailure instance) =>
    <String, dynamic>{
      'index': instance.index,
      'filename': instance.fileName,
      'error': instance.error,
      'errorCode': instance.errorCode,
    };
