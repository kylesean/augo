import 'dart:io';

import 'package:logging/logging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/network_client.dart';
import 'package:augo/features/auth/models/user.dart';
import 'package:augo/core/utils/map_require.dart';
import '../../../core/services/timezone_service.dart';

class AuthService {
  final NetworkClient _networkClient;
  final TimezoneService _timezoneService;
  final FlutterSecureStorage _storage;
  late final SharedPreferences _prefs;
  final _logger = Logger('AuthService');

  // Keys for secure storage
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id'; // Store user ID securely

  // Keys for shared preferences
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';
  static const String _userPhoneKey = 'user_phone';

  AuthService(this._networkClient, this._timezoneService)
    : _storage = const FlutterSecureStorage() {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Helper to save authentication data
  Future<void> _saveAuthData(String token, UserModel user) async {
    // Save sensitive data to secure storage
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _userIdKey, value: user.id);

    // Save non-sensitive data to shared preferences
    await _prefs.setString(_userNameKey, user.username?.toString() ?? '');
    if (user.email != null) {
      await _prefs.setString(_userEmailKey, user.email!);
    } else {
      await _prefs.remove(_userEmailKey);
    }
    if (user.phone != null) {
      await _prefs.setString(_userPhoneKey, user.phone!);
    } else {
      await _prefs.remove(_userPhoneKey);
    }
    _logger.info('Auth data saved to secure storage and shared preferences.');
  }

  // Helper to delete authentication data
  Future<void> _deleteAuthData() async {
    // Clear sensitive data from secure storage
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userIdKey);

    // Clear non-sensitive data from shared preferences
    await _prefs.remove(_userNameKey);
    await _prefs.remove(_userEmailKey);
    await _prefs.remove(_userPhoneKey);
    _logger.info(
      'Auth data deleted from secure storage and shared preferences.',
    );
  }

  // Method to retrieve stored authentication data
  Future<Map<String, dynamic>?> getStoredAuthData() async {
    final token = await _storage.read(key: _tokenKey);
    final userId = await _storage.read(key: _userIdKey);

    if (token != null && userId != null) {
      // Retrieve non-sensitive data from shared preferences
      final username = _prefs.getString(_userNameKey);
      final email = _prefs.getString(_userEmailKey);
      final phone = _prefs.getString(_userPhoneKey);

      if (username != null) {
        // Ensure at least username is present for a valid user model
        final user = UserModel(
          id: userId,
          username: username,
          email: email,
          phone: phone,
        );
        _logger.info('Stored auth data retrieved.');
        return {'user': user, 'token': token};
      }
    }
    return null;
  }

  Future<({UserModel user, String token})> login(
    String account,
    String password,
  ) async {
    // Get user timezone
    final timezone = await _timezoneService.getCurrentTimezone();

    final response = await _networkClient.request<Map<String, dynamic>>(
      '/auth/login',
      method: HttpMethod.post,
      data: {
        'account': account,
        'password': password,
        'type': 'email',
        'timezone': timezone, // Add timezone information
      },
      fromJsonT: (json) => json as Map<String, dynamic>,
    );
    // Extract data from response['data']
    final data = response.require<Map<String, dynamic>>('data');
    final userJson = data.require<Map<String, dynamic>>('user');
    final token = data.require<String>('token');
    final UserModel user = UserModel.fromJson(userJson);
    await _saveAuthData(token, user); // Save data after successful registration
    // Return a tuple with strongly typed objects (Record)
    return (user: user, token: token);
  }

  // --- Connect to send verification code API ---
  Future<void> sendVerificationCode(String account) async {
    await _networkClient.request<void>(
      '/auth/send-code',
      method: HttpMethod.post,
      data: {'account': account, 'type': 'email'},
    );
    _logger.info("Verification code sent to $account (API call successful)");
  }

  // User registration
  Future<({UserModel user, String token})> register({
    required String account,
    required String password,
    required String verificationCode,
  }) async {
    // Get user timezone
    final timezone = await _timezoneService.getCurrentTimezone();

    // Get device locale for smart currency default (no permission required)
    final locale = _getDeviceLocale();

    final response = await _networkClient.request<Map<String, dynamic>>(
      '/auth/register',
      method: HttpMethod.post,
      data: {
        'type': 'email',
        'account': account,
        'password': password,
        'code': verificationCode,
        'timezone': timezone, // Add timezone information
        'locale': locale, // Add locale for smart currency default
      },
      fromJsonT: (json) => json as Map<String, dynamic>,
    );
    // Extract data from response['data']
    final data = response.require<Map<String, dynamic>>('data');
    final userJson = data.require<Map<String, dynamic>>('user');
    final token = data.require<String>('token');
    final UserModel user = UserModel.fromJson(userJson);
    await _saveAuthData(token, user); // Save data after successful registration

    _logger.info('User registered with locale: $locale');

    // Return a tuple with strongly typed objects (Record)
    return (user: user, token: token);
  }

  /// Get device locale string (e.g., 'zh_CN', 'en_US')
  /// This does NOT require any permission.
  String _getDeviceLocale() {
    try {
      // Platform.localeName returns the device's locale (e.g., 'zh_CN', 'en_US')
      // This is a synchronous call and does not require any permission
      final locale = Platform.localeName;
      _logger.fine('Device locale detected: $locale');
      return locale;
    } catch (e) {
      _logger.warning('Failed to get device locale: $e');
      return 'zh_CN'; // Fallback to Chinese
    }
  }

  // Removed unnecessary validateToken and getCurrentUser methods
  // Because login already retrieves complete user information and Token, no additional API calls needed

  Future<void> logout() async {
    // Simulate logout delay
    await Future.delayed(const Duration(seconds: 1));
    await _deleteAuthData(); // Clear token and user data from secure storage and shared preferences
    _logger.info('User logged out and data cleared.');
  }
}

// Provider for AuthService (ensure NetworkClientProvider is defined)
final authServiceProvider = Provider<AuthService>((ref) {
  final networkClient = ref.watch(
    networkClientProvider,
  ); // Get from your network layer
  final timezoneService = ref.watch(
    timezoneServiceProvider,
  ); // Get timezone service
  return AuthService(networkClient, timezoneService);
});
