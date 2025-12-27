// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speech_settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Speech settings Notifier

@ProviderFor(SpeechSettingsNotifier)
const speechSettingsProvider = SpeechSettingsNotifierProvider._();

/// Speech settings Notifier
final class SpeechSettingsNotifierProvider
    extends $NotifierProvider<SpeechSettingsNotifier, SpeechSettingsState> {
  /// Speech settings Notifier
  const SpeechSettingsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'speechSettingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$speechSettingsNotifierHash();

  @$internal
  @override
  SpeechSettingsNotifier create() => SpeechSettingsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SpeechSettingsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SpeechSettingsState>(value),
    );
  }
}

String _$speechSettingsNotifierHash() =>
    r'9c7aaca66153ce279e9664e1d5d9a9cc9629c54d';

/// Speech settings Notifier

abstract class _$SpeechSettingsNotifier extends $Notifier<SpeechSettingsState> {
  SpeechSettingsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SpeechSettingsState, SpeechSettingsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SpeechSettingsState, SpeechSettingsState>,
              SpeechSettingsState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// 当前语音服务类型的便捷 Provider

@ProviderFor(currentSpeechServiceType)
const currentSpeechServiceTypeProvider = CurrentSpeechServiceTypeProvider._();

/// 当前语音服务类型的便捷 Provider

final class CurrentSpeechServiceTypeProvider
    extends
        $FunctionalProvider<
          SpeechServiceType,
          SpeechServiceType,
          SpeechServiceType
        >
    with $Provider<SpeechServiceType> {
  /// 当前语音服务类型的便捷 Provider
  const CurrentSpeechServiceTypeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentSpeechServiceTypeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentSpeechServiceTypeHash();

  @$internal
  @override
  $ProviderElement<SpeechServiceType> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SpeechServiceType create(Ref ref) {
    return currentSpeechServiceType(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SpeechServiceType value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SpeechServiceType>(value),
    );
  }
}

String _$currentSpeechServiceTypeHash() =>
    r'6cf3bd4865a875973a38d9b487233fb4f108f4c9';
