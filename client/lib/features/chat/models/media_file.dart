import 'dart:typed_data';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_file.freezed.dart';
part 'media_file.g.dart';

/// Media file type enum
@JsonEnum()
enum MediaType {
  @JsonValue('image')
  image,
  @JsonValue('file')
  file,
}

/// Media file data model
/// Contains basic file information, supports JSON serialization
@freezed
abstract class MediaFile with _$MediaFile {
  const factory MediaFile({
    required String id,
    required String name,
    required String path,
    required int size,
    required MediaType type,
    String? extension,
  }) = _MediaFile;

  factory MediaFile.fromJson(Map<String, dynamic> json) =>
      _$MediaFileFromJson(json);
}

/// MediaFile extension for handling byte data
/// Byte data does not participate in JSON serialization, only used for Web platform memory storage
extension MediaFileExtension on MediaFile {
  /// Create a MediaFile copy with byte data
  MediaFileWithBytes copyWithBytes(Uint8List? bytes) {
    return MediaFileWithBytes(mediaFile: this, bytes: bytes);
  }
}

/// Media file wrapper class containing byte data
/// Used when byte data is needed, does not participate in JSON serialization
class MediaFileWithBytes {
  const MediaFileWithBytes({required this.mediaFile, this.bytes});

  final MediaFile mediaFile;
  final Uint8List? bytes;

  // Proxy MediaFile properties
  String get id => mediaFile.id;
  String get name => mediaFile.name;
  String get path => mediaFile.path;
  int get size => mediaFile.size;
  MediaType get type => mediaFile.type;
  String? get extension => mediaFile.extension;

  /// Create new copy with updated byte data
  MediaFileWithBytes copyWithBytes(Uint8List? newBytes) {
    return MediaFileWithBytes(mediaFile: mediaFile, bytes: newBytes);
  }

  /// Create new copy with updated media file information
  MediaFileWithBytes copyWithMediaFile(MediaFile newMediaFile) {
    return MediaFileWithBytes(mediaFile: newMediaFile, bytes: bytes);
  }
}

/// Validation result data model
@freezed
abstract class ValidationResult with _$ValidationResult {
  const factory ValidationResult({
    required bool isValid,
    String? errorMessage,
  }) = _ValidationResult;

  factory ValidationResult.fromJson(Map<String, dynamic> json) =>
      _$ValidationResultFromJson(json);
}
