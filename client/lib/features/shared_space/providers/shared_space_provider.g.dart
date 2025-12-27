// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_space_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SharedSpaceNotifier)
const sharedSpaceProvider = SharedSpaceNotifierProvider._();

final class SharedSpaceNotifierProvider
    extends $NotifierProvider<SharedSpaceNotifier, SharedSpaceState> {
  const SharedSpaceNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedSpaceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedSpaceNotifierHash();

  @$internal
  @override
  SharedSpaceNotifier create() => SharedSpaceNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedSpaceState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedSpaceState>(value),
    );
  }
}

String _$sharedSpaceNotifierHash() =>
    r'3a553ba079e5881996d90f76e7a9ae73606a03f4';

abstract class _$SharedSpaceNotifier extends $Notifier<SharedSpaceState> {
  SharedSpaceState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SharedSpaceState, SharedSpaceState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SharedSpaceState, SharedSpaceState>,
              SharedSpaceState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(spaceDetail)
const spaceDetailProvider = SpaceDetailFamily._();

final class SpaceDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<SharedSpace>,
          SharedSpace,
          FutureOr<SharedSpace>
        >
    with $FutureModifier<SharedSpace>, $FutureProvider<SharedSpace> {
  const SpaceDetailProvider._({
    required SpaceDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'spaceDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$spaceDetailHash();

  @override
  String toString() {
    return r'spaceDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<SharedSpace> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SharedSpace> create(Ref ref) {
    final argument = this.argument as String;
    return spaceDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SpaceDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$spaceDetailHash() => r'6aff9136a09a1b8c7f83a3fb932f73908b740909';

final class SpaceDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<SharedSpace>, String> {
  const SpaceDetailFamily._()
    : super(
        retry: null,
        name: r'spaceDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SpaceDetailProvider call(String spaceId) =>
      SpaceDetailProvider._(argument: spaceId, from: this);

  @override
  String toString() => r'spaceDetailProvider';
}

@ProviderFor(spaceSettlement)
const spaceSettlementProvider = SpaceSettlementFamily._();

final class SpaceSettlementProvider
    extends
        $FunctionalProvider<
          AsyncValue<Settlement>,
          Settlement,
          FutureOr<Settlement>
        >
    with $FutureModifier<Settlement>, $FutureProvider<Settlement> {
  const SpaceSettlementProvider._({
    required SpaceSettlementFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'spaceSettlementProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$spaceSettlementHash();

  @override
  String toString() {
    return r'spaceSettlementProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Settlement> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Settlement> create(Ref ref) {
    final argument = this.argument as String;
    return spaceSettlement(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SpaceSettlementProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$spaceSettlementHash() => r'4d3556fbef2a5b7da9a8152b4d4e44313ca68f61';

final class SpaceSettlementFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Settlement>, String> {
  const SpaceSettlementFamily._()
    : super(
        retry: null,
        name: r'spaceSettlementProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SpaceSettlementProvider call(String spaceId) =>
      SpaceSettlementProvider._(argument: spaceId, from: this);

  @override
  String toString() => r'spaceSettlementProvider';
}

@ProviderFor(spaceTransactions)
const spaceTransactionsProvider = SpaceTransactionsFamily._();

final class SpaceTransactionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<SpaceTransactionListResponse>,
          SpaceTransactionListResponse,
          FutureOr<SpaceTransactionListResponse>
        >
    with
        $FutureModifier<SpaceTransactionListResponse>,
        $FutureProvider<SpaceTransactionListResponse> {
  const SpaceTransactionsProvider._({
    required SpaceTransactionsFamily super.from,
    required (String, {int page, int limit}) super.argument,
  }) : super(
         retry: null,
         name: r'spaceTransactionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$spaceTransactionsHash();

  @override
  String toString() {
    return r'spaceTransactionsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<SpaceTransactionListResponse> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SpaceTransactionListResponse> create(Ref ref) {
    final argument = this.argument as (String, {int page, int limit});
    return spaceTransactions(
      ref,
      argument.$1,
      page: argument.page,
      limit: argument.limit,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SpaceTransactionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$spaceTransactionsHash() => r'58987d525e1c576b0b88b417238350da03600fa9';

final class SpaceTransactionsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<SpaceTransactionListResponse>,
          (String, {int page, int limit})
        > {
  const SpaceTransactionsFamily._()
    : super(
        retry: null,
        name: r'spaceTransactionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SpaceTransactionsProvider call(
    String spaceId, {
    int page = 1,
    int limit = 20,
  }) => SpaceTransactionsProvider._(
    argument: (spaceId, page: page, limit: limit),
    from: this,
  );

  @override
  String toString() => r'spaceTransactionsProvider';
}
