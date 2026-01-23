// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Financial settings state notifier

@ProviderFor(FinancialSettingsNotifier)
const financialSettingsProvider = FinancialSettingsNotifierProvider._();

/// Financial settings state notifier
final class FinancialSettingsNotifierProvider
    extends
        $NotifierProvider<FinancialSettingsNotifier, FinancialSettingsState> {
  /// Financial settings state notifier
  const FinancialSettingsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'financialSettingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$financialSettingsNotifierHash();

  @$internal
  @override
  FinancialSettingsNotifier create() => FinancialSettingsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FinancialSettingsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FinancialSettingsState>(value),
    );
  }
}

String _$financialSettingsNotifierHash() =>
    r'c0f79dbd55f07a6da2e218cbc7fc9e21cefa2463';

/// Financial settings state notifier

abstract class _$FinancialSettingsNotifier
    extends $Notifier<FinancialSettingsState> {
  FinancialSettingsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<FinancialSettingsState, FinancialSettingsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FinancialSettingsState, FinancialSettingsState>,
              FinancialSettingsState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
