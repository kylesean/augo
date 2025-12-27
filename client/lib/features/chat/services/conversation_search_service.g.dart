// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_search_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Conversation search service provider

@ProviderFor(conversationSearchService)
const conversationSearchServiceProvider = ConversationSearchServiceProvider._();

/// Conversation search service provider

final class ConversationSearchServiceProvider
    extends
        $FunctionalProvider<
          ConversationSearchService,
          ConversationSearchService,
          ConversationSearchService
        >
    with $Provider<ConversationSearchService> {
  /// Conversation search service provider
  const ConversationSearchServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'conversationSearchServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$conversationSearchServiceHash();

  @$internal
  @override
  $ProviderElement<ConversationSearchService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ConversationSearchService create(Ref ref) {
    return conversationSearchService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConversationSearchService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConversationSearchService>(value),
    );
  }
}

String _$conversationSearchServiceHash() =>
    r'd2d00aa7b2667b6b26a67b0623d723b415e747ba';
