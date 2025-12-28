// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// User profile notifier

@ProviderFor(UserProfile)
const userProfileProvider = UserProfileProvider._();

/// User profile notifier
final class UserProfileProvider
    extends $NotifierProvider<UserProfile, UserProfileState> {
  /// User profile notifier
  const UserProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userProfileHash();

  @$internal
  @override
  UserProfile create() => UserProfile();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserProfileState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserProfileState>(value),
    );
  }
}

String _$userProfileHash() => r'e180c3b225553570554712865f97679232999915';

/// User profile notifier

abstract class _$UserProfile extends $Notifier<UserProfileState> {
  UserProfileState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<UserProfileState, UserProfileState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UserProfileState, UserProfileState>,
              UserProfileState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
