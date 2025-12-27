// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speech_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SpeechSettings _$SpeechSettingsFromJson(Map<String, dynamic> json) =>
    _SpeechSettings(
      serviceType:
          $enumDecodeNullable(
            _$SpeechServiceTypeEnumMap,
            json['serviceType'],
          ) ??
          SpeechServiceType.system,
      websocketHost: json['websocketHost'] as String?,
      websocketPort: (json['websocketPort'] as num?)?.toInt(),
      websocketPath: json['websocketPath'] as String?,
      localeId: json['localeId'] as String? ?? 'zh_CN',
    );

Map<String, dynamic> _$SpeechSettingsToJson(_SpeechSettings instance) =>
    <String, dynamic>{
      'serviceType': _$SpeechServiceTypeEnumMap[instance.serviceType]!,
      'websocketHost': instance.websocketHost,
      'websocketPort': instance.websocketPort,
      'websocketPath': instance.websocketPath,
      'localeId': instance.localeId,
    };

const _$SpeechServiceTypeEnumMap = {
  SpeechServiceType.system: 'system',
  SpeechServiceType.websocket: 'websocket',
};
