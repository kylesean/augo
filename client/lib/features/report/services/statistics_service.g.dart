// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(statisticsService)
const statisticsServiceProvider = StatisticsServiceProvider._();

final class StatisticsServiceProvider
    extends
        $FunctionalProvider<
          StatisticsService,
          StatisticsService,
          StatisticsService
        >
    with $Provider<StatisticsService> {
  const StatisticsServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'statisticsServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$statisticsServiceHash();

  @$internal
  @override
  $ProviderElement<StatisticsService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  StatisticsService create(Ref ref) {
    return statisticsService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StatisticsService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StatisticsService>(value),
    );
  }
}

String _$statisticsServiceHash() => r'a27db5433fb6d8915a6eb6c54fb0087aa02f0d60';
