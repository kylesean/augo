import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/profile_service.dart';
import '../models/user_info.dart';
import '../../chat/services/file_upload_service.dart';
import 'dart:async';

part 'user_profile_provider.g.dart';

/// User profile state
class UserProfileState {
  final UserInfo? user;
  final bool isLoading;
  final bool isSaving;
  final bool isUploadingAvatar;
  final String? error;

  const UserProfileState({
    this.user,
    this.isLoading = false,
    this.isSaving = false,
    this.isUploadingAvatar = false,
    this.error,
  });

  UserProfileState copyWith({
    UserInfo? user,
    bool? isLoading,
    bool? isSaving,
    bool? isUploadingAvatar,
    String? error,
  }) {
    return UserProfileState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isUploadingAvatar: isUploadingAvatar ?? this.isUploadingAvatar,
      error: error,
    );
  }
}

/// User profile notifier
@riverpod
class UserProfile extends _$UserProfile {
  @override
  UserProfileState build() {
    // Auto-load user info when provider is first accessed
    unawaited(Future.microtask(loadUser));
    return const UserProfileState(isLoading: true);
  }

  ProfileService get _service => ref.read(profileServiceProvider);
  FileUploadService get _uploadService => ref.read(fileUploadServiceProvider);

  /// Load current user info
  Future<void> loadUser() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _service.getCurrentUser();
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Update username
  Future<bool> updateUsername(String newUsername) async {
    if (newUsername.trim().isEmpty) return false;

    state = state.copyWith(isSaving: true, error: null);
    try {
      final updatedUser = await _service.updateProfile(username: newUsername);
      state = state.copyWith(user: updatedUser, isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
      return false;
    }
  }

  /// Upload avatar and update profile
  Future<bool> uploadAndUpdateAvatar(XFile imageFile) async {
    state = state.copyWith(isUploadingAvatar: true, error: null);

    try {
      // 1. Upload image to server
      final uploadResult = await _uploadService.uploadFiles([imageFile]);

      if (uploadResult.uploads.isEmpty) {
        throw Exception('Image upload failed');
      }

      // 2. Get uploaded image URL
      final avatarUrl = uploadResult.uploads.first.uri;

      // 3. Update profile with new avatar URL
      final updatedUser = await _service.updateProfile(avatarUrl: avatarUrl);

      state = state.copyWith(user: updatedUser, isUploadingAvatar: false);
      return true;
    } catch (e) {
      state = state.copyWith(isUploadingAvatar: false, error: e.toString());
      return false;
    }
  }

  /// Update avatar with URL directly (for existing images)
  Future<bool> updateAvatarUrl(String avatarUrl) async {
    state = state.copyWith(isSaving: true, error: null);
    try {
      final updatedUser = await _service.updateProfile(avatarUrl: avatarUrl);
      state = state.copyWith(user: updatedUser, isSaving: false);
      return true;
    } catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
      return false;
    }
  }
}
