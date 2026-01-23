import 'dart:collection';
import 'package:logging/logging.dart';

/// Centralized cache service for GenUI components to prevent memory leaks
///
/// Many GenUI components need to persist state across rebuilds (e.g., when a user
/// scrolls away and back). This service provides a size-limited cache to store
/// these states without leaking memory over long sessions.
class GenUiCacheService {
  static final _logger = Logger('GenUiCacheService');
  static final GenUiCacheService _instance = GenUiCacheService._internal();

  factory GenUiCacheService() => _instance;

  GenUiCacheService._internal();

  /// Maximum number of items to keep in each cache category
  static const int _maxItemsPerCategory = 50;

  /// Cache storage organized by category
  final Map<String, LinkedHashMap<String, dynamic>> _caches = {};

  /// Store a value in the cache
  void put(String category, String key, dynamic value) {
    final cache = _getCache(category);
    if (cache.containsKey(key)) {
      cache.remove(key);
    } else if (cache.length >= _maxItemsPerCategory) {
      final oldestKey = cache.keys.first;
      cache.remove(oldestKey);
      _logger.finer(
        'Evicted oldest item from GenUI cache [$category]: $oldestKey',
      );
    }
    cache[key] = value;
  }

  /// Retrieve a value from the cache
  T? get<T>(String category, String key) {
    final cache = _getCache(category);
    if (!cache.containsKey(key)) return null;

    // Move to end (most recently used)
    final value = cache.remove(key);
    cache[key] = value;
    return value as T?;
  }

  /// Check if a key exists in the cache
  bool containsKey(String category, String key) {
    return _caches[category]?.containsKey(key) ?? false;
  }

  /// Clear a specific category
  void clearCategory(String category) {
    _caches[category]?.clear();
    _logger.info('Cleared GenUI cache category: $category');
  }

  /// Clear all caches
  void clearAll() {
    for (final cache in _caches.values) {
      cache.clear();
    }
    _logger.info('Cleared all GenUI caches');
  }

  LinkedHashMap<String, dynamic> _getCache(String category) {
    return _caches.putIfAbsent(
      category,
      () => LinkedHashMap<String, dynamic>(),
    );
  }
}
