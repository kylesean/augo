import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction_model.dart';
import '../services/home_service.dart';

// Transaction detail state
class TransactionDetailState {
  final TransactionModel? transaction;
  final bool isLoading;
  final String? errorMessage;

  const TransactionDetailState({
    this.transaction,
    this.isLoading = false,
    this.errorMessage,
  });

  TransactionDetailState copyWith({
    TransactionModel? transaction,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return TransactionDetailState(
      transaction: transaction ?? this.transaction,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

// Transaction detail Notifier
class TransactionDetailNotifier extends Notifier<TransactionDetailState> {
  final String transactionId;
  bool _mounted = true;

  TransactionDetailNotifier(this.transactionId);

  @override
  TransactionDetailState build() {
    _mounted = true;
    ref.onDispose(() => _mounted = false);
    // Auto-load data
    unawaited(
      Future<void>.microtask(() => fetchTransactionDetail(transactionId)),
    );
    return const TransactionDetailState();
  }

  // Fetch transaction detail
  Future<void> fetchTransactionDetail(String id) async {
    if (state.isLoading) return; // Prevent duplicate requests

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final homeService = ref.read(homeServiceProvider);
      final transaction = await homeService.getTransactionDetail(id);

      if (_mounted) {
        state = state.copyWith(transaction: transaction, isLoading: false);
      }
    } catch (e) {
      if (_mounted) {
        state = state.copyWith(isLoading: false, errorMessage: e.toString());
      }
    }
  }

  // Reload
  Future<void> reload() async {
    await fetchTransactionDetail(transactionId);
  }
}

// Provider for TransactionDetailNotifier
final transactionDetailProvider = NotifierProvider.autoDispose
    .family<TransactionDetailNotifier, TransactionDetailState, String>(
      TransactionDetailNotifier.new,
    );
