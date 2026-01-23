// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_search_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Conversation search state management

@ProviderFor(ConversationSearch)
const conversationSearchProvider = ConversationSearchProvider._();

/// Conversation search state management
final class ConversationSearchProvider
    extends $NotifierProvider<ConversationSearch, ConversationSearchState> {
  /// Conversation search state management
  const ConversationSearchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'conversationSearchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$conversationSearchHash();

  @$internal
  @override
  ConversationSearch create() => ConversationSearch();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConversationSearchState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConversationSearchState>(value),
    );
  }
}

String _$conversationSearchHash() =>
    r'2cd83e80bfea9d776771081b1eae82cc3926edf1';

/// Conversation search state management

abstract class _$ConversationSearch extends $Notifier<ConversationSearchState> {
  ConversationSearchState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<ConversationSearchState, ConversationSearchState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ConversationSearchState, ConversationSearchState>,
              ConversationSearchState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
