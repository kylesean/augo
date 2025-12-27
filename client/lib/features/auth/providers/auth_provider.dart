import 'package:flutter/scheduler.dart';
import 'package:logging/logging.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:augo/core/network/exceptions/app_exception.dart';
import 'package:augo/core/storage/secure_storage_service.dart';
import 'package:augo/features/auth/models/user.dart';
import '../services/auth_service.dart';
import 'auth_state.dart';

// Re-export AuthState and AuthStatus for convenience
export 'auth_state.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  late final AuthService _authService;
  late final SecureStorageService _storageService;
  final _logger = Logger('Auth');

  @override
  AuthState build() {
    // Use ref.read to get services (no need to subscribe to changes)
    _authService = ref.read(authServiceProvider);
    _storageService = ref.read(secureStorageServiceProvider);

    // Use addPostFrameCallback to ensure post-frame rendering before performing
    // SecureStorage operations to avoid blocking the main thread during UI rendering
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _initializeAuthState();
    });

    return const AuthState();
  }

  /// Restore authentication state on app startup
  Future<void> _initializeAuthState() async {
    try {
      _logger.info('Starting authentication state initialization...');
      state = state.copyWith(status: AuthStatus.loading);

      final token = await _storageService.getToken();
      if (token != null && token.isNotEmpty) {
        _logger.info('Found local token, restoring login state');
        final userData = await _authService.getStoredAuthData();
        if (userData != null) {
          state = state.copyWith(
            status: AuthStatus.authenticated,
            user: userData['user'] as UserModel,
            token: token,
          );
        } else {
          state = state.copyWith(
            status: AuthStatus.authenticated,
            token: token,
          );
        }
      } else {
        state = state.copyWith(status: AuthStatus.unauthenticated);
      }
    } catch (e) {
      state = state.copyWith(status: AuthStatus.unauthenticated);
      _logger.severe('State initialization failed', e);
    }
  }

  Future<void> _handleAuthenticationSuccess({
    required UserModel user,
    required String token,
  }) async {
    await _storageService.saveToken(token);
    state = state.copyWith(
      status: AuthStatus.authenticated,
      user: user,
      token: token,
    );
    _logger.info('Login successful, state updated - user: ${user.email}');
  }

  Future<void> login(String email, String password) async {
    try {
      final result = await _authService.login(email, password);
      await _handleAuthenticationSuccess(
        user: result.user,
        token: result.token,
      );
    } catch (e) {
      if (state.status != AuthStatus.unauthenticated) {
        state = state.copyWith(status: AuthStatus.unauthenticated);
      }
      if (e is DioException && e.error is AppException) {
        throw e.error as AppException;
      }
      rethrow;
    }
  }

  Future<void> register({
    required String account,
    required String password,
    required String verificationCode,
  }) async {
    try {
      final result = await _authService.register(
        account: account,
        password: password,
        verificationCode: verificationCode,
      );
      await _handleAuthenticationSuccess(
        user: result.user,
        token: result.token,
      );
    } catch (e) {
      if (e is DioException && e.error is AppException) {
        throw e.error as AppException;
      }
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
      await _storageService.deleteToken();
      state = const AuthState(status: AuthStatus.unauthenticated);
    } catch (e) {
      await _storageService.deleteToken();
      state = const AuthState(status: AuthStatus.unauthenticated);
      _logger.warning('Error during logout, but local state cleared', e);
    }
  }

  Future<void> refreshUser() async {
    if (state.status != AuthStatus.authenticated) return;
    try {
      final userData = await _authService.getStoredAuthData();
      if (userData != null) {
        state = state.copyWith(user: userData['user'] as UserModel);
      }
    } catch (e) {
      _logger.warning('Failed to refresh user info', e);
    }
  }

  Future<void> checkAuthStatus() async {
    await _initializeAuthState();
  }
}

@Riverpod(keepAlive: true)
String? authToken(Ref ref) {
  final authState = ref.watch(authProvider);
  return authState.token;
}

@Riverpod(keepAlive: true)
UserModel? currentUser(Ref ref) {
  final authState = ref.watch(authProvider);
  return authState.user;
}

@Riverpod(keepAlive: true)
AuthStatus authStatus(Ref ref) {
  final authState = ref.watch(authProvider);
  return authState.status;
}
