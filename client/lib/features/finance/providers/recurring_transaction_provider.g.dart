// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_transaction_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The recurring transaction list state manager.

@ProviderFor(RecurringTransactionNotifier)
const recurringTransactionProvider = RecurringTransactionNotifierProvider._();

/// The recurring transaction list state manager.
final class RecurringTransactionNotifierProvider
    extends
        $NotifierProvider<
          RecurringTransactionNotifier,
          RecurringTransactionState
        > {
  /// The recurring transaction list state manager.
  const RecurringTransactionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recurringTransactionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recurringTransactionNotifierHash();

  @$internal
  @override
  RecurringTransactionNotifier create() => RecurringTransactionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecurringTransactionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecurringTransactionState>(value),
    );
  }
}

String _$recurringTransactionNotifierHash() =>
    r'757167e8997ed391bdc23e385814a9a3c2842400';

/// The recurring transaction list state manager.

abstract class _$RecurringTransactionNotifier
    extends $Notifier<RecurringTransactionState> {
  RecurringTransactionState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<RecurringTransactionState, RecurringTransactionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RecurringTransactionState, RecurringTransactionState>,
              RecurringTransactionState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
