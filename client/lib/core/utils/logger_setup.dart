import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

final _logger = Logger('LoggerSetup');

/// Initialize logging configuration
void setupLogging() {
  // Set global log level
  // Can be set to Level.ALL in development, Level.INFO recommended for production
  Logger.root.level = kDebugMode ? Level.ALL : Level.INFO;

  // Configure log output format
  Logger.root.onRecord.listen((record) {
    final message =
        '${record.time}: [${record.level.name}] ${record.loggerName}: ${record.message}';

    // Print stack trace if error exists
    if (record.error != null) {
      debugPrint('$message\nError: ${record.error}');
    } else {
      debugPrint(message);
    }

    if (record.stackTrace != null) {
      debugPrint('StackTrace: ${record.stackTrace}');
    }
  });

  _logger.info('Logging system initialized');
}
