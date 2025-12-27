import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

abstract class PaginationConstants {
  static const int defaultPageSize = 20;

  static const int maxPageSize = 100;

  static const int calendarDayMaxItems = 100;
}

abstract class UIConstants {
  static const double paddingXs = 4.0;
  static const double paddingSm = 8.0;
  static const double paddingMd = 16.0;
  static const double paddingLg = 24.0;
  static const double paddingXl = 32.0;

  static const double radiusSm = 4.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;

  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  static const Duration debounceDelay = Duration(milliseconds: 300);
}

abstract class LoggingConstants {
  static const Level debugLevel = Level.ALL;

  static const Level productionLevel = Level.INFO;

  static Level get currentLevel => kDebugMode ? debugLevel : productionLevel;
}

abstract class RetryConstants {
  static const int maxRetries = 3;

  static const int baseRetryDelayMs = 500;
}
