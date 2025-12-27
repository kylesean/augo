// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_expense_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Current conversation expense Notifier
///
/// Maintains real-time expense accumulation for header display.

@ProviderFor(ConversationExpenseNotifier)
const conversationExpenseProvider = ConversationExpenseNotifierProvider._();

/// Current conversation expense Notifier
///
/// Maintains real-time expense accumulation for header display.
final class ConversationExpenseNotifierProvider
    extends
        $NotifierProvider<
          ConversationExpenseNotifier,
          ConversationExpenseState
        > {
  /// Current conversation expense Notifier
  ///
  /// Maintains real-time expense accumulation for header display.
  const ConversationExpenseNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'conversationExpenseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$conversationExpenseNotifierHash();

  @$internal
  @override
  ConversationExpenseNotifier create() => ConversationExpenseNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConversationExpenseState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConversationExpenseState>(value),
    );
  }
}

String _$conversationExpenseNotifierHash() =>
    r'fa8e7e63445e817ceb94dbe841a35f9b8235f5c4';

/// Current conversation expense Notifier
///
/// Maintains real-time expense accumulation for header display.

abstract class _$ConversationExpenseNotifier
    extends $Notifier<ConversationExpenseState> {
  ConversationExpenseState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<ConversationExpenseState, ConversationExpenseState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ConversationExpenseState, ConversationExpenseState>,
              ConversationExpenseState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Current conversation expense statistics Provider
///
/// Calculates total expenses from historical messages + real-time accumulation.

@ProviderFor(conversationTotalExpense)
const conversationTotalExpenseProvider = ConversationTotalExpenseProvider._();

/// Current conversation expense statistics Provider
///
/// Calculates total expenses from historical messages + real-time accumulation.

final class ConversationTotalExpenseProvider
    extends $FunctionalProvider<double, double, double>
    with $Provider<double> {
  /// Current conversation expense statistics Provider
  ///
  /// Calculates total expenses from historical messages + real-time accumulation.
  const ConversationTotalExpenseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'conversationTotalExpenseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$conversationTotalExpenseHash();

  @$internal
  @override
  $ProviderElement<double> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  double create(Ref ref) {
    return conversationTotalExpense(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }
}

String _$conversationTotalExpenseHash() =>
    r'2a66328616f291979e9d40e490f194c053f1eeb0';

/// Formatted current conversation expense title Provider
///

@ProviderFor(conversationExpenseTitle)
const conversationExpenseTitleProvider = ConversationExpenseTitleProvider._();

/// Formatted current conversation expense title Provider
///

final class ConversationExpenseTitleProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// Formatted current conversation expense title Provider
  ///
  const ConversationExpenseTitleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'conversationExpenseTitleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$conversationExpenseTitleHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return conversationExpenseTitle(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$conversationExpenseTitleHash() =>
    r'd986d45cf47769c948101b9ce1d4e0596027204b';
