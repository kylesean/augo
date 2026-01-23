import 'package:freezed_annotation/freezed_annotation.dart';

part 'genui_surface_info.freezed.dart';
part 'genui_surface_info.g.dart';

/// Surface status for lifecycle tracking
enum SurfaceStatus {
  /// Surface created, widget building
  loading,

  /// Widget rendered successfully
  rendered,

  /// DataModel updated reactively (via DataModelUpdate)
  updated,

  /// Surface is ready
  ready,

  /// Error occurred
  error,

  /// Surface removed (via DeleteSurface)
  removed,
}

/// GenUI Surface info
@freezed
abstract class GenUiSurfaceInfo with _$GenUiSurfaceInfo {
  const factory GenUiSurfaceInfo({
    required String surfaceId,
    required String messageId,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(SurfaceStatus.loading) SurfaceStatus status,
  }) = _GenUiSurfaceInfo;

  factory GenUiSurfaceInfo.fromJson(Map<String, dynamic> json) =>
      _$GenUiSurfaceInfoFromJson(json);
}
