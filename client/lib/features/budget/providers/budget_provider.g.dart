// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BudgetFilterState)
const budgetFilterStateProvider = BudgetFilterStateProvider._();

final class BudgetFilterStateProvider
    extends $NotifierProvider<BudgetFilterState, BudgetFilter> {
  const BudgetFilterStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'budgetFilterStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$budgetFilterStateHash();

  @$internal
  @override
  BudgetFilterState create() => BudgetFilterState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BudgetFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BudgetFilter>(value),
    );
  }
}

String _$budgetFilterStateHash() => r'7b2ed20675cbed3ee3d166fd17ea0a2e1f2aee3c';

abstract class _$BudgetFilterState extends $Notifier<BudgetFilter> {
  BudgetFilter build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<BudgetFilter, BudgetFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BudgetFilter, BudgetFilter>,
              BudgetFilter,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(BudgetSummaryNotifier)
const budgetSummaryProvider = BudgetSummaryNotifierProvider._();

final class BudgetSummaryNotifierProvider
    extends $NotifierProvider<BudgetSummaryNotifier, BudgetSummaryState> {
  const BudgetSummaryNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'budgetSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$budgetSummaryNotifierHash();

  @$internal
  @override
  BudgetSummaryNotifier create() => BudgetSummaryNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BudgetSummaryState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BudgetSummaryState>(value),
    );
  }
}

String _$budgetSummaryNotifierHash() =>
    r'623cf9e86602ad4605495d4248693314134279e9';

abstract class _$BudgetSummaryNotifier extends $Notifier<BudgetSummaryState> {
  BudgetSummaryState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<BudgetSummaryState, BudgetSummaryState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BudgetSummaryState, BudgetSummaryState>,
              BudgetSummaryState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(budgetList)
const budgetListProvider = BudgetListProvider._();

final class BudgetListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Budget>>,
          List<Budget>,
          FutureOr<List<Budget>>
        >
    with $FutureModifier<List<Budget>>, $FutureProvider<List<Budget>> {
  const BudgetListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'budgetListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$budgetListHash();

  @$internal
  @override
  $FutureProviderElement<List<Budget>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Budget>> create(Ref ref) {
    return budgetList(ref);
  }
}

String _$budgetListHash() => r'853225cae37707dac03f0478d2f16a4fa1ac449d';
