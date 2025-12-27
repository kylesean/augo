import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../profile/providers/financial_settings_provider.dart';

part 'account_view_currency_provider.freezed.dart';
part 'account_view_currency_provider.g.dart';

/// Represents the state of the account view currency.
///
/// Uses a sealed class pattern to represent two distinct states:
/// - Following global settings (default)
/// - Using a temporary override
@freezed
sealed class AccountViewCurrencyState with _$AccountViewCurrencyState {
  /// Following global primary currency settings
  const factory AccountViewCurrencyState.global() = AccountViewCurrencyGlobal;

  /// Using a temporary currency override
  const factory AccountViewCurrencyState.temporary(String currency) =
      AccountViewCurrencyTemporary;
}

/// Provider to manage the currency used for displaying account summaries.
///
/// This provider follows the global primary currency by default,
/// but allows temporary switching to view assets in other currencies.
///
/// Usage:
/// ```dart
/// // Get the effective currency (resolves temporary or global)
/// final viewCurrency = ref.watch(effectiveViewCurrencyProvider);
///
/// // Temporarily switch to another currency
/// ref.read(accountViewCurrencyProvider.notifier).setTemporary('USD');
///
/// // Reset to follow global settings
/// ref.read(accountViewCurrencyProvider.notifier).resetToGlobal();
/// ```
@riverpod
class AccountViewCurrency extends _$AccountViewCurrency {
  @override
  AccountViewCurrencyState build() {
    // Listen to global currency changes and auto-reset temporary state
    ref.listen(financialSettingsProvider, (prev, next) {
      // When global currency changes, reset to follow global
      if (prev?.primaryCurrency != next.primaryCurrency) {
        state = const AccountViewCurrencyState.global();
      }
    });

    // Default: follow global settings
    return const AccountViewCurrencyState.global();
  }

  /// Set a temporary currency for viewing (local only, does not affect global).
  void setTemporary(String currency) {
    state = AccountViewCurrencyState.temporary(currency);
  }

  /// Reset to follow global primary currency settings.
  void resetToGlobal() {
    state = const AccountViewCurrencyState.global();
  }
}

/// Derived provider that resolves the actual currency string to use.
///
/// This provider:
/// - Returns the temporary currency if set
/// - Otherwise returns the global primary currency
@riverpod
String effectiveViewCurrency(Ref ref) {
  final viewState = ref.watch(accountViewCurrencyProvider);
  final globalCurrency = ref.watch(financialSettingsProvider).primaryCurrency;

  // 使用 freezed 生成的 .map 方法进行模式匹配
  return viewState.map(
    global: (_) => globalCurrency,
    temporary: (temp) => temp.currency,
  );
}
