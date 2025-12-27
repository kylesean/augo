// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MediaFile _$MediaFileFromJson(Map<String, dynamic> json) => _MediaFile(
  id: json['id'] as String,
  name: json['name'] as String,
  path: json['path'] as String,
  size: (json['size'] as num).toInt(),
  type: $enumDecode(_$MediaTypeEnumMap, json['type']),
  extension: json['extension'] as String?,
);

Map<String, dynamic> _$MediaFileToJson(_MediaFile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'path': instance.path,
      'size': instance.size,
      'type': _$MediaTypeEnumMap[instance.type]!,
      'extension': instance.extension,
    };

const _$MediaTypeEnumMap = {MediaType.image: 'image', MediaType.file: 'file'};

_ValidationResult _$ValidationResultFromJson(Map<String, dynamic> json) =>
    _ValidationResult(
      isValid: json['isValid'] as bool,
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$ValidationResultToJson(_ValidationResult instance) =>
    <String, dynamic>{
      'isValid': instance.isValid,
      'errorMessage': instance.errorMessage,
    };
