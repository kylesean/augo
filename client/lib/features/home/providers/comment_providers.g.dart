// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TransactionComments)
const transactionCommentsProvider = TransactionCommentsFamily._();

final class TransactionCommentsProvider
    extends $AsyncNotifierProvider<TransactionComments, List<CommentModel>> {
  const TransactionCommentsProvider._({
    required TransactionCommentsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'transactionCommentsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$transactionCommentsHash();

  @override
  String toString() {
    return r'transactionCommentsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TransactionComments create() => TransactionComments();

  @override
  bool operator ==(Object other) {
    return other is TransactionCommentsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$transactionCommentsHash() =>
    r'6954808296356d8b712ab7c1a95e526ff2aa79d2';

final class TransactionCommentsFamily extends $Family
    with
        $ClassFamilyOverride<
          TransactionComments,
          AsyncValue<List<CommentModel>>,
          List<CommentModel>,
          FutureOr<List<CommentModel>>,
          String
        > {
  const TransactionCommentsFamily._()
    : super(
        retry: null,
        name: r'transactionCommentsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TransactionCommentsProvider call(String transactionId) =>
      TransactionCommentsProvider._(argument: transactionId, from: this);

  @override
  String toString() => r'transactionCommentsProvider';
}

abstract class _$TransactionComments
    extends $AsyncNotifier<List<CommentModel>> {
  late final _$args = ref.$arg as String;
  String get transactionId => _$args;

  FutureOr<List<CommentModel>> build(String transactionId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref as $Ref<AsyncValue<List<CommentModel>>, List<CommentModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<CommentModel>>, List<CommentModel>>,
              AsyncValue<List<CommentModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ReplyingToCommentId)
const replyingToCommentIdProvider = ReplyingToCommentIdProvider._();

final class ReplyingToCommentIdProvider
    extends $NotifierProvider<ReplyingToCommentId, String?> {
  const ReplyingToCommentIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'replyingToCommentIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$replyingToCommentIdHash();

  @$internal
  @override
  ReplyingToCommentId create() => ReplyingToCommentId();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$replyingToCommentIdHash() =>
    r'834efd03f9761a87fe84a248dc2ebd7147cbbdf1';

abstract class _$ReplyingToCommentId extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ReplyingToUserName)
const replyingToUserNameProvider = ReplyingToUserNameProvider._();

final class ReplyingToUserNameProvider
    extends $NotifierProvider<ReplyingToUserName, String?> {
  const ReplyingToUserNameProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'replyingToUserNameProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$replyingToUserNameHash();

  @$internal
  @override
  ReplyingToUserName create() => ReplyingToUserName();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$replyingToUserNameHash() =>
    r'9df9f97c537e6ece1ed2516dc416dec2c71b485a';

abstract class _$ReplyingToUserName extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
