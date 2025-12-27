// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Statistics state notifier

@ProviderFor(Statistics)
const statisticsProvider = StatisticsProvider._();

/// Statistics state notifier
final class StatisticsProvider
    extends $NotifierProvider<Statistics, StatisticsState> {
  /// Statistics state notifier
  const StatisticsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'statisticsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$statisticsHash();

  @$internal
  @override
  Statistics create() => Statistics();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StatisticsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StatisticsState>(value),
    );
  }
}

String _$statisticsHash() => r'e4ceca1a218159bde1eba1e630f54637082dbfc9';

/// Statistics state notifier

abstract class _$Statistics extends $Notifier<StatisticsState> {
  StatisticsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<StatisticsState, StatisticsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<StatisticsState, StatisticsState>,
              StatisticsState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
