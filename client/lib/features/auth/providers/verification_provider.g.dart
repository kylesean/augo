// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Verification)
const verificationProvider = VerificationProvider._();

final class VerificationProvider
    extends $NotifierProvider<Verification, VerificationState> {
  const VerificationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'verificationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$verificationHash();

  @$internal
  @override
  Verification create() => Verification();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VerificationState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VerificationState>(value),
    );
  }
}

String _$verificationHash() => r'31922c9784316fc4d066a604aa83aed42bcc8348';

abstract class _$Verification extends $Notifier<VerificationState> {
  VerificationState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<VerificationState, VerificationState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<VerificationState, VerificationState>,
              VerificationState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
