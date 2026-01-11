import 'dart:async';
import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logging/logging.dart';
import '../models/financial_settings.dart';
import '../services/profile_service.dart';
import '../../../core/network/exceptions/app_exception.dart';

part 'financial_settings_provider.g.dart';

final _logger = Logger('FinancialSettingsNotifier');

/// Financial settings state notifier
@riverpod
class FinancialSettingsNotifier extends _$FinancialSettingsNotifier {
  FinancialSettingsResponse? _originalSettings;

  @override
  FinancialSettingsState build() {
    unawaited(Future<void>.microtask(() => unawaited(loadFinancialSettings())));
    return const FinancialSettingsState();
  }

  /// Load financial settings
  Future<void> loadFinancialSettings() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final profileService = ref.read(profileServiceProvider);
      final response = await profileService.getFinancialSettings();
      _originalSettings = response;

      _logger.info('Loaded primaryCurrency: ${response.primaryCurrency}');

      state = state.copyWith(
        safetyThreshold: response.safetyThreshold,
        dailyBurnRate: response.dailyBurnRate,
        burnRateMode: response.burnRateMode,
        primaryCurrency: response.primaryCurrency,
        monthStartDay: response.monthStartDay,
        lastUpdatedAt: response.updatedAt,
        isLoading: false,
        hasChanges: false,
        error: null,
      );
    } catch (e) {
      String errorMessage = 'Failed to load financial settings';
      if (e is AppException) {
        errorMessage = e.message;
      }

      _logger.severe('Failed to load financial settings', e);

      state = state.copyWith(
        isLoading: false,
        hasChanges: false,
        error: errorMessage,
      );
    }
  }

  /// Update safety threshold
  void updateSafetyThreshold(Decimal newThreshold) {
    final hasChanges = _originalSettings?.safetyThreshold != newThreshold;
    state = state.copyWith(
      safetyThreshold: newThreshold,
      hasChanges: hasChanges,
      error: null,
    );
  }

  /// Update daily burn rate
  void updateDailyBurnRate(Decimal newRate) {
    final hasChanges = _originalSettings?.dailyBurnRate != newRate;
    state = state.copyWith(
      dailyBurnRate: newRate,
      hasChanges: hasChanges,
      error: null,
    );
  }

  /// Update burn rate mode
  void updateBurnRateMode(String mode) {
    state = state.copyWith(burnRateMode: mode, hasChanges: true, error: null);
  }

  /// Update primary currency
  void updatePrimaryCurrency(String currency) {
    final hasChanges = _originalSettings?.primaryCurrency != currency;
    state = state.copyWith(
      primaryCurrency: currency,
      hasChanges: hasChanges,
      error: null,
    );
  }

  /// Save financial settings
  Future<bool> saveFinancialSettings() async {
    if (!state.hasChanges) return true;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final profileService = ref.read(profileServiceProvider);
      final request = FinancialSettingsRequest(
        safetyThreshold: state.safetyThreshold,
        dailyBurnRate: state.dailyBurnRate,
        burnRateMode: state.burnRateMode,
        primaryCurrency: state.primaryCurrency,
        monthStartDay: state.monthStartDay,
      );

      final response = await profileService.updateFinancialSettings(request);
      _originalSettings = response;

      state = state.copyWith(
        safetyThreshold: response.safetyThreshold,
        dailyBurnRate: response.dailyBurnRate,
        burnRateMode: response.burnRateMode,
        primaryCurrency: response.primaryCurrency,
        monthStartDay: response.monthStartDay,
        lastUpdatedAt: response.updatedAt,
        isLoading: false,
        hasChanges: false,
        error: null,
      );

      return true;
    } catch (e) {
      String errorMessage = 'Failed to save financial settings';
      if (e is AppException) {
        errorMessage = e.message;
      }

      state = state.copyWith(isLoading: false, error: errorMessage);

      return false;
    }
  }

  /// Reset to original values
  void resetToOriginal() {
    if (_originalSettings != null) {
      state = state.copyWith(
        safetyThreshold: _originalSettings!.safetyThreshold,
        dailyBurnRate: _originalSettings!.dailyBurnRate,
        burnRateMode: _originalSettings!.burnRateMode,
        primaryCurrency: _originalSettings!.primaryCurrency,
        monthStartDay: _originalSettings!.monthStartDay,
        hasChanges: false,
        error: null,
      );
    }
  }

  /// Clear error state
  void clearError() {
    state = state.copyWith(error: null);
  }
}
