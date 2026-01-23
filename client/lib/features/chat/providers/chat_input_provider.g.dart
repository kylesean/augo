// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_input_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChatInputNotifier)
const chatInputProvider = ChatInputNotifierFamily._();

final class ChatInputNotifierProvider
    extends $NotifierProvider<ChatInputNotifier, ChatInputState> {
  const ChatInputNotifierProvider._({
    required ChatInputNotifierFamily super.from,
    required OnSendMessageCallback super.argument,
  }) : super(
         retry: null,
         name: r'chatInputProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatInputNotifierHash();

  @override
  String toString() {
    return r'chatInputProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ChatInputNotifier create() => ChatInputNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatInputState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatInputState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ChatInputNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatInputNotifierHash() => r'c5b049a036a1b506c103e4cf15e169f4cc42e1fe';

final class ChatInputNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          ChatInputNotifier,
          ChatInputState,
          ChatInputState,
          ChatInputState,
          OnSendMessageCallback
        > {
  const ChatInputNotifierFamily._()
    : super(
        retry: null,
        name: r'chatInputProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChatInputNotifierProvider call(OnSendMessageCallback onSendMessage) =>
      ChatInputNotifierProvider._(argument: onSendMessage, from: this);

  @override
  String toString() => r'chatInputProvider';
}

abstract class _$ChatInputNotifier extends $Notifier<ChatInputState> {
  late final _$args = ref.$arg as OnSendMessageCallback;
  OnSendMessageCallback get onSendMessage => _$args;

  ChatInputState build(OnSendMessageCallback onSendMessage);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<ChatInputState, ChatInputState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ChatInputState, ChatInputState>,
              ChatInputState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
