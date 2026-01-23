// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_account_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FinancialAccountNotifier)
const financialAccountProvider = FinancialAccountNotifierProvider._();

final class FinancialAccountNotifierProvider
    extends $NotifierProvider<FinancialAccountNotifier, FinancialAccountState> {
  const FinancialAccountNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'financialAccountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$financialAccountNotifierHash();

  @$internal
  @override
  FinancialAccountNotifier create() => FinancialAccountNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FinancialAccountState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FinancialAccountState>(value),
    );
  }
}

String _$financialAccountNotifierHash() =>
    r'a202b4d38a680498a482effa73804fc664893b70';

abstract class _$FinancialAccountNotifier
    extends $Notifier<FinancialAccountState> {
  FinancialAccountState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<FinancialAccountState, FinancialAccountState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FinancialAccountState, FinancialAccountState>,
              FinancialAccountState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
