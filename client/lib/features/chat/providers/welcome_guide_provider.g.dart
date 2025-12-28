// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'welcome_guide_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 欢迎引导 Provider - 根据当前时段返回问候语和场景化建议

@ProviderFor(welcomeGuide)
const welcomeGuideProvider = WelcomeGuideProvider._();

/// 欢迎引导 Provider - 根据当前时段返回问候语和场景化建议

final class WelcomeGuideProvider
    extends
        $FunctionalProvider<
          WelcomeGuideState,
          WelcomeGuideState,
          WelcomeGuideState
        >
    with $Provider<WelcomeGuideState> {
  /// 欢迎引导 Provider - 根据当前时段返回问候语和场景化建议
  const WelcomeGuideProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'welcomeGuideProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$welcomeGuideHash();

  @$internal
  @override
  $ProviderElement<WelcomeGuideState> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WelcomeGuideState create(Ref ref) {
    return welcomeGuide(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WelcomeGuideState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WelcomeGuideState>(value),
    );
  }
}

String _$welcomeGuideHash() => r'a294e1ba5d37c0e2ad6394d78e87d26a51a61202';
