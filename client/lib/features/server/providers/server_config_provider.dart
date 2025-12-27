import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:augo/core/services/server_config_service.dart';
import 'package:augo/core/storage/secure_storage_service.dart';

part 'server_config_provider.freezed.dart';

final _logger = Logger('ServerConfigProvider');

/// State for server configuration
@freezed
class ServerConfigState with _$ServerConfigState {
  const factory ServerConfigState.initial() = _Initial;
  const factory ServerConfigState.loading() = _Loading;
  const factory ServerConfigState.notConfigured() = _NotConfigured;
  const factory ServerConfigState.checking() = _Checking;
  const factory ServerConfigState.configured({
    required String serverUrl,
    String? version,
    String? environment,
  }) = _Configured;
  const factory ServerConfigState.error(String message) = _Error;
}

/// Notifier for managing server configuration state
class ServerConfigNotifier extends Notifier<ServerConfigState> {
  @override
  ServerConfigState build() {
    final configService = ref.watch(serverConfigServiceProvider);

    if (configService.isConfigured) {
      return ServerConfigState.configured(serverUrl: configService.serverUrl!);
    }
    return const ServerConfigState.notConfigured();
  }

  /// Validate and test connection to a server URL
  Future<bool> testConnection(String url) async {
    final configService = ref.read(serverConfigServiceProvider);

    // Validate URL format first
    final validationError = configService.validateUrl(url);
    if (validationError != null) {
      state = ServerConfigState.error(validationError);
      return false;
    }

    state = const ServerConfigState.checking();

    // Check health
    final result = await configService.checkHealth(url);

    if (result.isHealthy) {
      state = ServerConfigState.configured(
        serverUrl: url,
        version: result.version,
        environment: result.environment,
      );
      return true;
    } else {
      state = ServerConfigState.error(
        result.errorMessage ?? 'Connection failed',
      );
      return false;
    }
  }

  /// Save the server URL and mark as configured
  ///
  /// If switching to a different server, local authentication data
  /// will be cleared to prevent data conflicts between servers.
  Future<void> saveServerUrl(String url) async {
    final configService = ref.read(serverConfigServiceProvider);
    final currentUrl = configService.serverUrl;
    final isNewServer = currentUrl != null && currentUrl != url;

    // If switching to a different server, clear local auth data
    if (isNewServer) {
      _logger.info(
        'Switching server from $currentUrl to $url, clearing auth data',
      );
      final storageService = ref.read(secureStorageServiceProvider);
      await storageService.clearAllData();
    }

    await configService.saveServerUrl(url);

    state = ServerConfigState.configured(serverUrl: url);

    // Invalidate all providers that depend on server URL
    ref.invalidate(serverConfigServiceProvider);
    ref.invalidate(isServerConfiguredProvider);
    ref.invalidate(apiBaseUrlProvider);
    ref.invalidate(serverUrlProvider);
  }

  /// Clear server configuration
  Future<void> clearConfiguration() async {
    final configService = ref.read(serverConfigServiceProvider);
    await configService.clearServerUrl();

    state = const ServerConfigState.notConfigured();

    // Invalidate all providers that depend on server URL
    ref.invalidate(serverConfigServiceProvider);
    ref.invalidate(isServerConfiguredProvider);
    ref.invalidate(apiBaseUrlProvider);
    ref.invalidate(serverUrlProvider);
  }

  /// Reset to initial state (for retry)
  void reset() {
    final configService = ref.read(serverConfigServiceProvider);
    if (configService.isConfigured) {
      state = ServerConfigState.configured(serverUrl: configService.serverUrl!);
    } else {
      state = const ServerConfigState.notConfigured();
    }
  }
}

/// Provider for server configuration state
final serverConfigProvider =
    NotifierProvider<ServerConfigNotifier, ServerConfigState>(() {
      return ServerConfigNotifier();
    });
