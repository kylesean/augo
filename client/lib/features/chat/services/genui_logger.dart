import 'package:logging/logging.dart';

/// GenUI logging and monitoring service
///
/// This class provides logging and performance monitoring for GenUI components.
/// Includes:
/// - Widget rendering time logs
/// - Detailed error logs (with schema and stack trace)
/// - Builder invocation tracking
/// - Schema structure logs
/// - Performance warnings
///
/// Requirements: 9.1, 9.2, 9.3, 9.4, 9.5
class GenUiLogger {
  // Performance threshold (milliseconds)
  static const int _slowRenderingThresholdMs = 100;

  static final _logger = Logger('GenUI');

  // Builder invocation statistics
  static final Map<String, BuilderStats> _builderStats = {};

  /// Log widget rendering time
  ///
  /// [componentName] - Component name
  /// [surfaceId] - Surface ID
  /// [durationMs] - Rendering duration (milliseconds)
  ///
  /// Requirements: 9.1
  static void logWidgetRendering({
    required String componentName,
    required String surfaceId,
    required int durationMs,
  }) {
    _logger.info(
      'Widget rendered: $componentName (Surface: $surfaceId) in ${durationMs}ms',
    );

    // Issue performance warning if rendering time exceeds threshold
    if (durationMs > _slowRenderingThresholdMs) {
      logPerformanceWarning(
        componentName: componentName,
        surfaceId: surfaceId,
        durationMs: durationMs,
      );
    }
  }

  /// Log detailed error information
  ///
  /// [message] - Error message
  /// [error] - Error object
  /// [stackTrace] - Stack trace
  /// [schema] - Related widget schema (optional)
  /// [surfaceId] - Surface ID (optional)
  ///
  /// Requirements: 9.2
  static void logError({
    required String message,
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? schema,
    String? surfaceId,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('GenUI Error: $message');

    if (surfaceId != null) {
      buffer.writeln('Surface ID: $surfaceId');
    }

    if (error != null) {
      buffer.writeln('Error: $error');
    }

    if (schema != null) {
      buffer.writeln('Schema: ${_formatSchema(schema)}');
    }

    _logger.severe(buffer.toString(), error, stackTrace);
  }

  /// Log builder invocation
  ///
  /// [componentName] - Component name
  /// [success] - Whether successful
  /// [durationMs] - Execution duration (milliseconds)
  ///
  /// Requirements: 9.3
  static void logBuilderInvocation({
    required String componentName,
    required bool success,
    required int durationMs,
  }) {
    // Update statistics
    final stats = _builderStats.putIfAbsent(
      componentName,
      () => BuilderStats(componentName),
    );
    stats.recordInvocation(success, durationMs);

    _logger.log(
      success ? Level.INFO : Level.WARNING,
      'Builder invoked: $componentName - ${success ? 'SUCCESS' : 'FAILED'} in ${durationMs}ms',
    );
  }

  /// Log schema structure
  ///
  /// [schema] - Widget schema
  /// [surfaceId] - Surface ID (optional)
  ///
  /// Requirements: 9.4
  static void logSchemaStructure({
    required Map<String, dynamic> schema,
    String? surfaceId,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('Schema structure:');

    if (surfaceId != null) {
      buffer.writeln('Surface ID: $surfaceId');
    }

    buffer.writeln(_formatSchema(schema));

    _logger.info(buffer.toString());
  }

  /// Issue performance warning
  ///
  /// [componentName] - Component name
  /// [surfaceId] - Surface ID
  /// [durationMs] - Rendering duration (milliseconds)
  ///
  /// Requirements: 9.5
  static void logPerformanceWarning({
    required String componentName,
    required String surfaceId,
    required int durationMs,
  }) {
    _logger.warning(
      'SLOW RENDERING: $componentName (Surface: $surfaceId) took ${durationMs}ms (threshold: ${_slowRenderingThresholdMs}ms)',
    );
  }

  /// Get builder statistics
  ///
  /// [componentName] - Component name
  ///
  /// Returns: Builder statistics, or null if not exists
  static BuilderStats? getBuilderStats(String componentName) {
    return _builderStats[componentName];
  }

  /// Get all builder statistics
  static Map<String, BuilderStats> getAllBuilderStats() {
    return Map.unmodifiable(_builderStats);
  }

  /// Reset all statistics
  static void resetStats() {
    _builderStats.clear();
    _logger.info('All builder statistics reset');
  }

  /// Format schema as readable string
  static String _formatSchema(Map<String, dynamic> schema) {
    final buffer = StringBuffer();
    _formatSchemaRecursive(schema, buffer, 0);
    return buffer.toString();
  }

  /// Recursively format schema
  static void _formatSchemaRecursive(
    dynamic value,
    StringBuffer buffer,
    int indent,
  ) {
    final indentStr = '  ' * indent;

    if (value is Map<String, dynamic>) {
      buffer.writeln('{');
      for (final entry in value.entries) {
        buffer.write('$indentStr  ${entry.key}: ');
        _formatSchemaRecursive(entry.value, buffer, indent + 1);
      }
      buffer.writeln('$indentStr}');
    } else if (value is List) {
      buffer.writeln('[');
      for (var i = 0; i < value.length; i++) {
        buffer.write('$indentStr  [$i]: ');
        _formatSchemaRecursive(value[i], buffer, indent + 1);
      }
      buffer.writeln('$indentStr]');
    } else {
      buffer.writeln(value.toString());
    }
  }

  /// Log GenUI initialization
  static void logInitialization({required bool success, String? errorMessage}) {
    if (success) {
      _logger.info('GenUI service initialized successfully');
    } else {
      _logger.severe('GenUI service initialization failed: $errorMessage');
    }
  }

  /// Log surface lifecycle events
  static void logSurfaceLifecycle({
    required String event,
    required String surfaceId,
    String? messageId,
  }) {
    final buffer = StringBuffer();
    buffer.write('Surface $event: $surfaceId');
    if (messageId != null) {
      buffer.write(' (Message: $messageId)');
    }

    _logger.info(buffer.toString());
  }

  /// Log schema validation results
  static void logSchemaValidation({
    required bool isValid,
    String? surfaceId,
    String? errorMessage,
  }) {
    if (isValid) {
      _logger.info(
        'Schema validation passed${surfaceId != null ? ' for surface $surfaceId' : ''}',
      );
    } else {
      _logger.warning(
        'Schema validation failed${surfaceId != null ? ' for surface $surfaceId' : ''}: $errorMessage',
      );
    }
  }
}

/// Builder invocation statistics
class BuilderStats {
  final String componentName;
  int _totalInvocations = 0;
  int _successfulInvocations = 0;
  int _failedInvocations = 0;
  int _totalDurationMs = 0;
  int _minDurationMs = 0;
  int _maxDurationMs = 0;

  BuilderStats(this.componentName);

  /// Record one invocation
  void recordInvocation(bool success, int durationMs) {
    _totalInvocations++;
    _totalDurationMs += durationMs;

    if (success) {
      _successfulInvocations++;
    } else {
      _failedInvocations++;
    }

    if (_minDurationMs == 0 || durationMs < _minDurationMs) {
      _minDurationMs = durationMs;
    }

    if (durationMs > _maxDurationMs) {
      _maxDurationMs = durationMs;
    }
  }

  /// Get total invocations
  int get totalInvocations => _totalInvocations;

  /// Get successful invocations
  int get successfulInvocations => _successfulInvocations;

  /// Get failed invocations
  int get failedInvocations => _failedInvocations;

  /// Get success rate (0-100)
  double get successRate => _totalInvocations > 0
      ? (_successfulInvocations / _totalInvocations) * 100
      : 0;

  /// Get average execution duration (milliseconds)
  double get averageDurationMs =>
      _totalInvocations > 0 ? _totalDurationMs / _totalInvocations : 0;

  /// Get minimum execution duration (milliseconds)
  int get minDurationMs => _minDurationMs;

  /// Get maximum execution duration (milliseconds)
  int get maxDurationMs => _maxDurationMs;

  @override
  String toString() {
    return 'BuilderStats($componentName): '
        'total=$_totalInvocations, '
        'success=$_successfulInvocations, '
        'failed=$_failedInvocations, '
        'successRate=${successRate.toStringAsFixed(1)}%, '
        'avgDuration=${averageDurationMs.toStringAsFixed(1)}ms, '
        'minDuration=${_minDurationMs}ms, '
        'maxDuration=${_maxDurationMs}ms';
  }
}
