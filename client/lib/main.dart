import 'package:flutter/material.dart';
import 'package:augo/app/app.dart';
import 'package:augo/features/chat/genui/genui_event_registry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'i18n/strings.g.dart';
import 'features/chat/pages/media_upload_test_page.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:logging/logging.dart';
import 'core/utils/logger_setup.dart';
import 'core/services/server_config_service.dart';

final _logger = Logger('Main');

void main() async {
  setupLogging();
  WidgetsFlutterBinding.ensureInitialized();

  final SharedPreferences prefs;

  try {
    // Initialize persistent storage
    prefs = await SharedPreferences.getInstance();
    _logger.info('SharedPreferences initialization completed');

    // Initialize slang language service
    // Try to restore language settings from storage, otherwise use device language
    final savedLocale = prefs.getString('app_locale');
    if (savedLocale != null) {
      LocaleSettings.setLocaleRaw(savedLocale);
      _logger.info('Language settings restored: $savedLocale');
    } else {
      LocaleSettings.useDeviceLocale();
      _logger.info('Using device language');
    }

    // Initialize Chinese date format data
    await initializeDateFormatting('zh_CN', null);
    await initializeDateFormatting('en', null);
    _logger.info('Date format initialization completed');

    // Initialize GenUI event registry
    GenUiEventRegistry.initialize();
    _logger.info('GenUI event registry initialization completed');

    _logger.info('Application initialization completed, launching app');
  } catch (e, stackTrace) {
    _logger.severe('Error during initialization', e, stackTrace);
    return; // Should not continue if core components fail to load
  }

  // Create ProviderContainer
  // Optimization: No longer synchronously warming up authProvider, allowing SecureStorage operations
  // to happen asynchronously after the Splash Screen renders to avoid blocking the main thread
  final container = ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
  );

  _logger.info(
    'ProviderContainer created, authentication will initialize on first access',
  );

  runApp(
    TranslationProvider(
      child: UncontrolledProviderScope(
        container: container,
        child: const MyApp(),
      ),
    ),
  );
}

/// Test page routing
Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/media_upload_test':
      return MaterialPageRoute(
        builder: (context) => const MediaUploadTestPage(),
      );
    default:
      return MaterialPageRoute(builder: (context) => const MyApp());
  }
}
