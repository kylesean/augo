import 'package:logging/logging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const String _authTokenKey = 'auth_token';
const String _userIdKey = 'user_id'; // Optional, if also want to store user ID
const String _userDataKey = 'user_data'; // Optional, if also store user info

class SecureStorageService {
  final _logger = Logger('SecureStorageService');
  final FlutterSecureStorage _secureStorage;

  // Memory cache to avoid repeated reading causing performance overhead
  String? _cachedToken;
  bool _tokenCacheInitialized = false;

  SecureStorageService(this._secureStorage);

  Future<void> saveToken(String token) async {
    try {
      await _secureStorage.write(key: _authTokenKey, value: token);
      // Update cache
      _cachedToken = token;
      _tokenCacheInitialized = true;
      _logger.info(
        'SecureStorageService: Token saved - ${token.substring(0, 10)}...',
      );
    } catch (e) {
      _logger.info('SecureStorageService: Failed to save token: $e');
      rethrow;
    }
  }

  Future<String?> getToken() async {
    // If cache is initialized, return cache value directly
    if (_tokenCacheInitialized) {
      _logger.info(
        'SecureStorageService: Read token from cache - ${_cachedToken != null ? '${_cachedToken!.substring(0, 10)}...' : 'null'}',
      );
      return _cachedToken;
    }

    try {
      final token = await _secureStorage.read(key: _authTokenKey);
      // Initialize cache
      _cachedToken = token;
      _tokenCacheInitialized = true;
      _logger.info(
        'SecureStorageService: Read token - ${token != null ? '${token.substring(0, 10)}...' : 'null'}',
      );
      return token;
    } catch (e) {
      _logger.info('SecureStorageService: Failed to read token: $e');
      // Mark cache as initialized (even if failed, do not try again)
      _tokenCacheInitialized = true;
      _cachedToken = null;
      return null;
    }
  }

  Future<void> deleteToken() async {
    try {
      await _secureStorage.delete(key: _authTokenKey);
      // Clear cache
      _cachedToken = null;
      _tokenCacheInitialized = true;
      _logger.info('SecureStorageService: Token deleted');
    } catch (e) {
      _logger.info('SecureStorageService: Failed to delete token: $e');
    }
  }

  /// Clear memory cache (for scenarios such as server switching)
  void invalidateCache() {
    _cachedToken = null;
    _tokenCacheInitialized = false;
    _logger.info('SecureStorageService: Cache invalidated');
  }

  Future<void> clearAllData() async {
    await deleteToken();
    invalidateCache();
    // Clear other authentication-related data
  }
}

final flutterSecureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    // Configure Android options
    // Note: encryptedSharedPreferences has been deprecated in v10+, the library will automatically use Tink encryption
    aOptions: AndroidOptions(
      // Set shared preferences name
      sharedPreferencesName: 'augo_secure_storage',
      // Set key prefix
      preferencesKeyPrefix: 'augo_',
    ),
    // Configure iOS options
    iOptions: IOSOptions(
      // first_unlock provides better performance while maintaining security
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );
});

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  final secureStorage = ref.watch(flutterSecureStorageProvider);
  return SecureStorageService(secureStorage);
});
