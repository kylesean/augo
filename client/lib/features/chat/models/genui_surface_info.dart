import 'package:freezed_annotation/freezed_annotation.dart';

part 'genui_surface_info.freezed.dart';
part 'genui_surface_info.g.dart';

/// Surface status
enum SurfaceStatus { loading, ready, error, removed }

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
