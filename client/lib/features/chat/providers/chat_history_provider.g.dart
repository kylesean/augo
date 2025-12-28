// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_history_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChatHistory)
const chatHistoryProvider = ChatHistoryProvider._();

final class ChatHistoryProvider
    extends $NotifierProvider<ChatHistory, ChatHistoryState> {
  const ChatHistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatHistoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatHistoryHash();

  @$internal
  @override
  ChatHistory create() => ChatHistory();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatHistoryState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatHistoryState>(value),
    );
  }
}

String _$chatHistoryHash() => r'5495131eaa440e8ebfb6b6fc7039b4596c3259df';

abstract class _$ChatHistory extends $Notifier<ChatHistoryState> {
  ChatHistoryState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ChatHistoryState, ChatHistoryState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ChatHistoryState, ChatHistoryState>,
              ChatHistoryState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
