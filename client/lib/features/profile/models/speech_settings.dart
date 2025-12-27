import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:augo/features/chat/services/speech_recognition_service.dart';

part 'speech_settings.freezed.dart';
part 'speech_settings.g.dart';

/// Speech recognition settings
@freezed
abstract class SpeechSettings with _$SpeechSettings {
  const factory SpeechSettings({
    /// Speech recognition service type
    @Default(SpeechServiceType.system) SpeechServiceType serviceType,

    /// WebSocket server host (Only used for websocket type)
    String? websocketHost,

    /// WebSocket server port (Only used for websocket type)
    int? websocketPort,

    /// WebSocket path (Only used for websocket type)
    String? websocketPath,

    /// Speech recognition language (Only valid for system type)
    @Default('zh_CN') String localeId,
  }) = _SpeechSettings;

  factory SpeechSettings.fromJson(Map<String, dynamic> json) =>
      _$SpeechSettingsFromJson(json);
}

/// Speech settings state (for UI)
@freezed
abstract class SpeechSettingsState with _$SpeechSettingsState {
  const factory SpeechSettingsState({
    @Default(false) bool isLoading,
    @Default(false) bool isSaving,
    @Default(null) SpeechSettings? settings,
    @Default(null) String? errorMessage,
  }) = _SpeechSettingsState;
}
