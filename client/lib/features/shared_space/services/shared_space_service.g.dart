// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_space_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sharedSpaceService)
const sharedSpaceServiceProvider = SharedSpaceServiceProvider._();

final class SharedSpaceServiceProvider
    extends
        $FunctionalProvider<
          SharedSpaceService,
          SharedSpaceService,
          SharedSpaceService
        >
    with $Provider<SharedSpaceService> {
  const SharedSpaceServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedSpaceServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedSpaceServiceHash();

  @$internal
  @override
  $ProviderElement<SharedSpaceService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SharedSpaceService create(Ref ref) {
    return sharedSpaceService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedSpaceService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedSpaceService>(value),
    );
  }
}

String _$sharedSpaceServiceHash() =>
    r'426f6995d2f2b7823d761f4830bd89fb68e46f93';
