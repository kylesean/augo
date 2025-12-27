// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(commentService)
const commentServiceProvider = CommentServiceProvider._();

final class CommentServiceProvider
    extends $FunctionalProvider<CommentService, CommentService, CommentService>
    with $Provider<CommentService> {
  const CommentServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'commentServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$commentServiceHash();

  @$internal
  @override
  $ProviderElement<CommentService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CommentService create(Ref ref) {
    return commentService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CommentService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CommentService>(value),
    );
  }
}

String _$commentServiceHash() => r'fb5aae10a9dfde74b0c71bd7988e577907c4b6be';
