// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_view_currency_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider to manage the currency used for displaying account summaries.
///
/// This provider follows the global primary currency by default,
/// but allows temporary switching to view assets in other currencies.
///
/// Usage:
/// ```dart
/// // Get the effective currency (resolves temporary or global)
/// final viewCurrency = ref.watch(effectiveViewCurrencyProvider);
///
/// // Temporarily switch to another currency
/// ref.read(accountViewCurrencyProvider.notifier).setTemporary('USD');
///
/// // Reset to follow global settings
/// ref.read(accountViewCurrencyProvider.notifier).resetToGlobal();
/// ```

@ProviderFor(AccountViewCurrency)
const accountViewCurrencyProvider = AccountViewCurrencyProvider._();

/// Provider to manage the currency used for displaying account summaries.
///
/// This provider follows the global primary currency by default,
/// but allows temporary switching to view assets in other currencies.
///
/// Usage:
/// ```dart
/// // Get the effective currency (resolves temporary or global)
/// final viewCurrency = ref.watch(effectiveViewCurrencyProvider);
///
/// // Temporarily switch to another currency
/// ref.read(accountViewCurrencyProvider.notifier).setTemporary('USD');
///
/// // Reset to follow global settings
/// ref.read(accountViewCurrencyProvider.notifier).resetToGlobal();
/// ```
final class AccountViewCurrencyProvider
    extends $NotifierProvider<AccountViewCurrency, AccountViewCurrencyState> {
  /// Provider to manage the currency used for displaying account summaries.
  ///
  /// This provider follows the global primary currency by default,
  /// but allows temporary switching to view assets in other currencies.
  ///
  /// Usage:
  /// ```dart
  /// // Get the effective currency (resolves temporary or global)
  /// final viewCurrency = ref.watch(effectiveViewCurrencyProvider);
  ///
  /// // Temporarily switch to another currency
  /// ref.read(accountViewCurrencyProvider.notifier).setTemporary('USD');
  ///
  /// // Reset to follow global settings
  /// ref.read(accountViewCurrencyProvider.notifier).resetToGlobal();
  /// ```
  const AccountViewCurrencyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountViewCurrencyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountViewCurrencyHash();

  @$internal
  @override
  AccountViewCurrency create() => AccountViewCurrency();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccountViewCurrencyState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccountViewCurrencyState>(value),
    );
  }
}

String _$accountViewCurrencyHash() =>
    r'73a867de11aa63ff0eb8a6bdde146d3996f7db95';

/// Provider to manage the currency used for displaying account summaries.
///
/// This provider follows the global primary currency by default,
/// but allows temporary switching to view assets in other currencies.
///
/// Usage:
/// ```dart
/// // Get the effective currency (resolves temporary or global)
/// final viewCurrency = ref.watch(effectiveViewCurrencyProvider);
///
/// // Temporarily switch to another currency
/// ref.read(accountViewCurrencyProvider.notifier).setTemporary('USD');
///
/// // Reset to follow global settings
/// ref.read(accountViewCurrencyProvider.notifier).resetToGlobal();
/// ```

abstract class _$AccountViewCurrency
    extends $Notifier<AccountViewCurrencyState> {
  AccountViewCurrencyState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AccountViewCurrencyState, AccountViewCurrencyState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AccountViewCurrencyState, AccountViewCurrencyState>,
              AccountViewCurrencyState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Derived provider that resolves the actual currency string to use.
///
/// This provider:
/// - Returns the temporary currency if set
/// - Otherwise returns the global primary currency

@ProviderFor(effectiveViewCurrency)
const effectiveViewCurrencyProvider = EffectiveViewCurrencyProvider._();

/// Derived provider that resolves the actual currency string to use.
///
/// This provider:
/// - Returns the temporary currency if set
/// - Otherwise returns the global primary currency

final class EffectiveViewCurrencyProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// Derived provider that resolves the actual currency string to use.
  ///
  /// This provider:
  /// - Returns the temporary currency if set
  /// - Otherwise returns the global primary currency
  const EffectiveViewCurrencyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'effectiveViewCurrencyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$effectiveViewCurrencyHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return effectiveViewCurrency(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$effectiveViewCurrencyHash() =>
    r'8df3efb675d6e904ca70e27d3bf6d78574c752c2';
