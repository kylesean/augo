import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:augo/features/chat/services/speech_recognition_service.dart';
import '../models/speech_settings.dart';

part 'speech_settings_provider.g.dart';

/// SharedPreferences storage keys
const String _speechSettingsKey = 'speech_settings';

/// Speech settings Notifier
@riverpod
class SpeechSettingsNotifier extends _$SpeechSettingsNotifier {
  static final _logger = Logger('SpeechSettingsNotifier');

  @override
  SpeechSettingsState build() {
    Future.microtask(() => _loadSettings());
    return const SpeechSettingsState();
  }

  /// Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_speechSettingsKey);

      SpeechSettings settings;
      if (jsonString != null) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        settings = SpeechSettings.fromJson(json);
        _logger.info(
          'Loaded speech settings successfully: ${settings.serviceType}',
        );
      } else {
        // Default settings
        settings = const SpeechSettings();
        _logger.info('Using default speech settings');
      }

      state = state.copyWith(isLoading: false, settings: settings);
    } catch (e) {
      _logger.severe('Failed to load speech settings: $e');
      state = state.copyWith(
        isLoading: false,
        settings: const SpeechSettings(), // Use default settings
        errorMessage: 'Failed to load settings',
      );
    }
  }

  /// Save settings to SharedPreferences
  Future<bool> _saveSettings(SpeechSettings settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(settings.toJson());
      await prefs.setString(_speechSettingsKey, jsonString);
      _logger.info('Saved speech settings successfully');
      return true;
    } catch (e) {
      _logger.severe('Failed to save speech settings: $e');
      return false;
    }
  }

  /// Update service type
  Future<void> updateServiceType(SpeechServiceType type) async {
    if (state.settings == null) return;

    state = state.copyWith(isSaving: true, errorMessage: null);

    final newSettings = state.settings!.copyWith(serviceType: type);
    final success = await _saveSettings(newSettings);

    if (success) {
      state = state.copyWith(isSaving: false, settings: newSettings);
    } else {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Failed to save settings',
      );
    }
  }

  /// Update WebSocket configuration
  Future<void> updateWebsocketConfig({
    String? host,
    int? port,
    String? path,
  }) async {
    if (state.settings == null) return;

    state = state.copyWith(isSaving: true, errorMessage: null);

    final newSettings = state.settings!.copyWith(
      websocketHost: host ?? state.settings!.websocketHost,
      websocketPort: port ?? state.settings!.websocketPort,
      websocketPath: path ?? state.settings!.websocketPath,
    );
    final success = await _saveSettings(newSettings);

    if (success) {
      state = state.copyWith(isSaving: false, settings: newSettings);
    } else {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Failed to save settings',
      );
    }
  }

  /// Update speech recognition language
  Future<void> updateLocaleId(String localeId) async {
    if (state.settings == null) return;

    state = state.copyWith(isSaving: true, errorMessage: null);

    final newSettings = state.settings!.copyWith(localeId: localeId);
    final success = await _saveSettings(newSettings);

    if (success) {
      state = state.copyWith(isSaving: false, settings: newSettings);
    } else {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Failed to save settings',
      );
    }
  }

  /// Reset to default settings
  Future<void> resetToDefault() async {
    state = state.copyWith(isSaving: true, errorMessage: null);

    const defaultSettings = SpeechSettings();
    final success = await _saveSettings(defaultSettings);

    if (success) {
      state = state.copyWith(isSaving: false, settings: defaultSettings);
    } else {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Failed to reset settings',
      );
    }
  }
}

/// Convenience provider for the current speech service type
@riverpod
SpeechServiceType currentSpeechServiceType(Ref ref) {
  final state = ref.watch(speechSettingsProvider);
  return state.settings?.serviceType ?? SpeechServiceType.system;
}
