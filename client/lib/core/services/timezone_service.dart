import 'package:logging/logging.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Timezone service for getting user's local timezone information
class TimezoneService {
  final _logger = Logger('TimezoneService');

  /// Get user's local timezone
  /// Returns timezone identifier, e.g.: "Asia/Shanghai", "America/New_York"
  Future<String> getCurrentTimezone() async {
    try {
      final dynamic result = await FlutterTimezone.getLocalTimezone();
      _logger.info('TimezoneService: Got user timezone object: $result');
      // Compatible with 5.0.0+ returning TimezoneInfo or legacy String
      if (result is String) return result;

      // Handle potential object return (some platforms/versions return TimezoneInfo)
      try {
        final Map<String, dynamic> data = result as Map<String, dynamic>;
        if (data.containsKey('id')) return data['id'] as String;
        if (data.containsKey('name')) return data['name'] as String;
      } catch (_) {}

      try {
        // Try accessing properties if it's a class instance
        final dynamic d = result;
        if (d.id != null) return d.id.toString();
        if (d.name != null) return d.name.toString();
      } catch (_) {}

      // Fallback: extract ID from toString() if it looks like "TimezoneInfo(ID, ...)"
      final str = result.toString();
      if (str.contains('(') && str.contains(',')) {
        final start = str.indexOf('(') + 1;
        final end = str.indexOf(',');
        if (end > start) {
          return str.substring(start, end).trim();
        }
      }

      return str;
    } catch (e) {
      _logger.info('TimezoneService: Failed to get timezone: $e');
      // Return default timezone if retrieval fails
      return 'UTC';
    }
  }

  /// Get list of all available timezones (optional feature)
  Future<List<String>> getAvailableTimezones() async {
    try {
      final dynamic result = await FlutterTimezone.getAvailableTimezones();
      final list = result as List<dynamic>;
      return list.map((e) {
        if (e is String) return e;
        try {
          return (e as dynamic).id as String;
        } catch (_) {
          return e.toString();
        }
      }).toList();
    } catch (e) {
      _logger.info('TimezoneService: Failed to get available timezones: $e');
      return [];
    }
  }
}

/// Riverpod Provider for TimezoneService
final timezoneServiceProvider = Provider<TimezoneService>((ref) {
  return TimezoneService();
});
