// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'genui_surface_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GenUiSurfaceInfo _$GenUiSurfaceInfoFromJson(Map<String, dynamic> json) =>
    _GenUiSurfaceInfo(
      surfaceId: json['surfaceId'] as String,
      messageId: json['messageId'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      status:
          $enumDecodeNullable(_$SurfaceStatusEnumMap, json['status']) ??
          SurfaceStatus.loading,
    );

Map<String, dynamic> _$GenUiSurfaceInfoToJson(_GenUiSurfaceInfo instance) =>
    <String, dynamic>{
      'surfaceId': instance.surfaceId,
      'messageId': instance.messageId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'status': _$SurfaceStatusEnumMap[instance.status]!,
    };

const _$SurfaceStatusEnumMap = {
  SurfaceStatus.loading: 'loading',
  SurfaceStatus.ready: 'ready',
  SurfaceStatus.error: 'error',
  SurfaceStatus.removed: 'removed',
};
