// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_rate_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ExchangeRate)
const exchangeRateProvider = ExchangeRateProvider._();

final class ExchangeRateProvider
    extends $AsyncNotifierProvider<ExchangeRate, ExchangeRateResponse> {
  const ExchangeRateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exchangeRateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exchangeRateHash();

  @$internal
  @override
  ExchangeRate create() => ExchangeRate();
}

String _$exchangeRateHash() => r'3d97e897e2aa8c2fd6323fc2af3ef5ad71b627ca';

abstract class _$ExchangeRate extends $AsyncNotifier<ExchangeRateResponse> {
  FutureOr<ExchangeRateResponse> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<ExchangeRateResponse>, ExchangeRateResponse>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<ExchangeRateResponse>,
                ExchangeRateResponse
              >,
              AsyncValue<ExchangeRateResponse>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
