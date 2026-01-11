import 'dart:async';
import 'package:logging/logging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'network_diagnostics.dart';
import '../constants/api_constants.dart';

/// Network status provider
/// Used to monitor and manage the app's network connection status
class NetworkStatusNotifier extends Notifier<NetworkStatus> {
  final _logger = Logger('NetworkStatusNotifier');
  Timer? _periodicTimer;
  static const Duration _checkInterval = Duration(minutes: 1);

  @override
  NetworkStatus build() {
    // Schedule the check to run after the build phase
    unawaited(Future.microtask(() => _startPeriodicCheck()));

    // Register cleanup
    ref.onDispose(() {
      _periodicTimer?.cancel();
    });

    return NetworkStatus.unknown;
  }

  /// Start periodic network status check
  void _startPeriodicCheck() {
    _periodicTimer
        ?.cancel(); // Cancel logic if called multiple times (though build is once per ref life)
    _periodicTimer = Timer.periodic(_checkInterval, (_) {
      unawaited(checkNetworkStatus());
    });

    // Execute check immediately
    unawaited(checkNetworkStatus());
  }

  /// Check network status
  Future<void> checkNetworkStatus() async {
    try {
      state = NetworkStatus.checking;

      // Get dynamic baseUrl from apiConstantsProvider
      final apiConstants = ref.read(apiConstantsProvider);
      final diagnostic = await NetworkDiagnostics.runFullDiagnostic(
        apiConstants.baseUrl,
      );

      if (diagnostic.isNetworkOk) {
        state = NetworkStatus.connected;
      } else if (diagnostic.internetAvailable) {
        state = NetworkStatus.serverUnavailable;
      } else {
        state = NetworkStatus.disconnected;
      }

      _logger.info('NetworkStatusProvider: Status updated to $state');
    } catch (e) {
      _logger.info('NetworkStatusProvider: Error checking network status: $e');
      state = NetworkStatus.error;
    }
  }

  /// Manually refresh network status
  Future<void> refresh() async {
    await checkNetworkStatus();
  }
}

/// Network status enum
enum NetworkStatus {
  unknown, // Unknown status
  checking, // Checking status
  connected, // Connected and server available
  disconnected, // Network disconnected
  serverUnavailable, // Network connected but server unavailable
  error, // Error during check
}

/// Network status extension methods
extension NetworkStatusExtension on NetworkStatus {
  /// Whether network requests can be made
  bool get canMakeRequests => this == NetworkStatus.connected;

  /// Get status description
  String get description {
    switch (this) {
      case NetworkStatus.unknown:
        return 'Network status unknown';
      case NetworkStatus.checking:
        return 'Checking network status...';
      case NetworkStatus.connected:
        return 'Network connection normal';
      case NetworkStatus.disconnected:
        return 'Network connection disconnected';
      case NetworkStatus.serverUnavailable:
        return 'Server temporarily unavailable';
      case NetworkStatus.error:
        return 'Network status check failed';
    }
  }

  /// Get user-friendly advice
  String get userAdvice {
    switch (this) {
      case NetworkStatus.unknown:
      case NetworkStatus.checking:
        return 'Please wait...';
      case NetworkStatus.connected:
        return 'Everything is normal';
      case NetworkStatus.disconnected:
        return 'Please check your network connection';
      case NetworkStatus.serverUnavailable:
        return 'Server maintenance, please try again later';
      case NetworkStatus.error:
        return 'Please check network settings or restart the app';
    }
  }

  /// Whether to display as error status
  bool get isError =>
      this == NetworkStatus.disconnected ||
      this == NetworkStatus.serverUnavailable ||
      this == NetworkStatus.error;
}

/// Network status provider
final networkStatusProvider =
    NotifierProvider<NetworkStatusNotifier, NetworkStatus>(
      NetworkStatusNotifier.new,
    );

/// Network connection status provider (simplified version)
final isNetworkConnectedProvider = Provider<bool>((ref) {
  final status = ref.watch(networkStatusProvider);
  return status.canMakeRequests;
});

/// Network status description provider
final networkStatusDescriptionProvider = Provider<String>((ref) {
  final status = ref.watch(networkStatusProvider);
  return status.description;
});

/// Network advice provider
final networkAdviceProvider = Provider<String>((ref) {
  final status = ref.watch(networkStatusProvider);
  return status.userAdvice;
});
