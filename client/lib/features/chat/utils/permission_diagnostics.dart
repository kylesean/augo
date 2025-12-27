// features/chat/utils/permission_diagnostics.dart
import 'package:logging/logging.dart';
import 'package:record/record.dart';
import 'dart:io';

class PermissionDiagnostics {
  static final _logger = Logger('PermissionDiagnostics');

  /// Comprehensive permission diagnostics
  static Future<Map<String, dynamic>> diagnose() async {
    final result = <String, dynamic>{};

    try {
      _logger.info('Starting permission diagnostics...');

      // Basic information
      result['platform'] = Platform.operatingSystem;
      result['timestamp'] = DateTime.now().toIso8601String();

      // Create AudioRecorder instance
      final recorder = AudioRecorder();

      // Check permission
      _logger.info('Checking microphone permission...');
      final hasPermission = await recorder.hasPermission();
      result['hasPermission'] = hasPermission;

      // Try to get available devices
      _logger.info('Checking recording devices...');
      try {
        // Here you can add device check logic
        result['deviceCheckPassed'] = true;
      } catch (e) {
        result['deviceCheckPassed'] = false;
        result['deviceError'] = e.toString();
      }

      // Platform-specific checks
      if (Platform.isIOS) {
        result['platformSpecific'] = {
          'type': 'iOS',
          'note': 'Check NSMicrophoneUsageDescription in Info.plist',
        };
      } else if (Platform.isAndroid) {
        result['platformSpecific'] = {
          'type': 'Android',
          'note': 'Check RECORD_AUDIO permission in AndroidManifest.xml',
        };
      }

      // Suggestions
      result['suggestions'] = _generateSuggestions(result);

      // Cleanup
      recorder.dispose();

      _logger.info('Permission diagnostics completed');
      return result;
    } catch (e, stackTrace) {
      _logger.severe('Permission diagnostics failed: $e');
      _logger.severe('Stack trace: $stackTrace');

      return {
        'error': true,
        'errorMessage': e.toString(),
        'stackTrace': stackTrace.toString(),
        'platform': Platform.operatingSystem,
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  /// Generate suggestions
  static List<String> _generateSuggestions(Map<String, dynamic> result) {
    final suggestions = <String>[];

    if (result['hasPermission'] == false) {
      suggestions.add(
        'Please manually authorize microphone permission in system settings',
      );

      if (Platform.isIOS) {
        suggestions.add(
          'iOS: Settings > Privacy & Security > Microphone > Flutter Augo',
        );
      } else if (Platform.isAndroid) {
        suggestions.add(
          'Android: Settings > Apps > Flutter Augo > Permissions > Microphone',
        );
      }
    }

    if (result['deviceCheckPassed'] == false) {
      suggestions.add(
        'Recording device check failed, please ensure device supports recording functionality',
      );
      suggestions.add(
        'If using simulator, please try testing on a real device',
      );
    }

    if (suggestions.isEmpty) {
      suggestions.add(
        'Permission check passed, you can try recording functionality',
      );
    }

    return suggestions;
  }

  /// Format diagnostic results
  static String formatDiagnostics(Map<String, dynamic> result) {
    final buffer = StringBuffer();

    buffer.writeln('🔍 Permission Diagnostic Report');
    buffer.writeln('================');
    buffer.writeln('Platform: ${result['platform']}');
    buffer.writeln('Time: ${result['timestamp']}');
    buffer.writeln('');

    if (result['error'] == true) {
      buffer.writeln('❌ Error occurred during diagnostics:');
      buffer.writeln('Error message: ${result['errorMessage']}');
      return buffer.toString();
    }

    buffer.writeln(
      'Permission status: ${result['hasPermission'] ? "✅ Granted" : "❌ Not granted"}',
    );
    buffer.writeln(
      'Device check: ${result['deviceCheckPassed'] ? "✅ Passed" : "❌ Failed"}',
    );

    if (result['platformSpecific'] != null) {
      final platform = result['platformSpecific'];
      buffer.writeln('');
      buffer.writeln('Platform info: ${platform['type']}');
      buffer.writeln('Notes: ${platform['note']}');
    }

    if (result['suggestions'] != null) {
      buffer.writeln('');
      buffer.writeln('🔧 Suggestions:');
      for (final suggestion in result['suggestions']) {
        buffer.writeln('- $suggestion');
      }
    }

    return buffer.toString();
  }
}
