import 'dart:async';
import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/financial_account.dart';
import '../services/profile_service.dart';
import '../../../core/network/exceptions/app_exception.dart';

part 'financial_account_provider.freezed.dart';
part 'financial_account_provider.g.dart';

// Account state
@freezed
abstract class FinancialAccountState with _$FinancialAccountState {
  const factory FinancialAccountState({
    @Default([]) List<FinancialAccount> accounts,
    Decimal? totalBalance,
    DateTime? lastUpdatedAt,
    @Default(false) bool isLoading,
    String? error,
  }) = _FinancialAccountState;

  const FinancialAccountState._();

  // Calculate account net worth (Assets - Liabilities)
  Decimal get calculatedNetWorth {
    return accounts.fold(Decimal.zero, (sum, account) {
      // Only count active accounts included in net worth
      if (account.status == AccountStatus.active && account.includeInNetWorth) {
        if (account.nature == FinancialNature.asset) {
          return sum + account.initialBalance;
        } else {
          return sum - account.initialBalance.abs();
        }
      }
      return sum;
    });
  }

  // Get actual total balance (priority to server-returned value)
  Decimal get effectiveTotalBalance {
    return totalBalance ?? calculatedNetWorth;
  }
}

// Account state notifier
@riverpod
class FinancialAccountNotifier extends _$FinancialAccountNotifier {
  @override
  FinancialAccountState build() {
    // Auto-load logic: automatically trigger loading when the provider is first created or reset
    unawaited(Future<void>.microtask(() => unawaited(loadFinancialAccounts())));
    return const FinancialAccountState();
  }

  /// Load account data
  Future<void> loadFinancialAccounts() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final profileService = ref.read(profileServiceProvider);
      final response = await profileService.getFinancialAccounts();

      // Safely parse lastUpdatedAt, handle empty string
      DateTime? parsedDate;
      if (response.lastUpdatedAt.isNotEmpty) {
        try {
          parsedDate = DateTime.parse(response.lastUpdatedAt);
        } catch (_) {
          parsedDate = DateTime.now();
        }
      }

      state = state.copyWith(
        accounts: response.accounts,
        totalBalance: response.totalBalance,
        lastUpdatedAt: parsedDate,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      String errorMessage = 'Failed to load cash sources';
      if (e is AppException) {
        errorMessage = e.message;
      }

      state = state.copyWith(isLoading: false, error: errorMessage);
    }
  }

  /// Save account data
  Future<bool> saveFinancialAccounts(List<FinancialAccount> accounts) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final profileService = ref.read(profileServiceProvider);
      final summary = await profileService.saveFinancialAccounts(accounts);

      // After successful save, use local source list + server returned balance/time
      state = state.copyWith(
        accounts: accounts,
        totalBalance: summary.totalBalance,
        lastUpdatedAt: summary.lastUpdatedAt,
        isLoading: false,
        error: null,
      );

      return true;
    } catch (e) {
      String errorMessage = 'Failed to save cash sources';
      if (e is AppException) {
        errorMessage = e.message;
      }

      state = state.copyWith(isLoading: false, error: errorMessage);

      return false;
    }
  }

  /// Add new account
  void addFinancialAccount(FinancialAccount account) {
    final updatedAccounts = [...state.accounts, account];
    state = state.copyWith(
      accounts: updatedAccounts,
      totalBalance: _calculateAccountsTotal(updatedAccounts),
    );
  }

  /// Clear error state
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Calculate account net worth
  Decimal _calculateAccountsTotal(List<FinancialAccount> accounts) {
    return accounts.fold(Decimal.zero, (sum, account) {
      if (account.status == AccountStatus.active && account.includeInNetWorth) {
        if (account.nature == FinancialNature.asset) {
          return sum + account.initialBalance;
        } else {
          return sum - account.initialBalance.abs();
        }
      }
      return sum;
    });
  }

  /// Update single account
  Future<bool> updateFinancialAccount(
    String accountId,
    FinancialAccount account,
  ) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final profileService = ref.read(profileServiceProvider);
      final updatedAccount = await profileService.updateFinancialAccount(
        accountId,
        account,
      );

      // Update local list
      final updatedAccounts = state.accounts.map((a) {
        return a.id == accountId ? updatedAccount : a;
      }).toList();

      state = state.copyWith(
        accounts: updatedAccounts,
        totalBalance: _calculateAccountsTotal(updatedAccounts),
        isLoading: false,
        error: null,
      );

      return true;
    } catch (e) {
      String errorMessage = 'Failed to update account';
      if (e is AppException) {
        errorMessage = e.message;
      }

      state = state.copyWith(isLoading: false, error: errorMessage);
      return false;
    }
  }

  /// Delete single account
  Future<bool> deleteFinancialAccount(String accountId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final profileService = ref.read(profileServiceProvider);
      await profileService.deleteFinancialAccount(accountId);

      // Remove from local list
      final updatedAccounts = state.accounts
          .where((a) => a.id != accountId)
          .toList();

      state = state.copyWith(
        accounts: updatedAccounts,
        totalBalance: _calculateAccountsTotal(updatedAccounts),
        isLoading: false,
        error: null,
      );

      return true;
    } catch (e) {
      String errorMessage = 'Failed to delete account';
      if (e is AppException) {
        errorMessage = e.message;
      }

      state = state.copyWith(isLoading: false, error: errorMessage);
      return false;
    }
  }
}
