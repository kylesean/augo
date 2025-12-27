import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/recurring_transaction.dart';
import '../services/recurring_transaction_service.dart';

part 'recurring_transaction_provider.g.dart';

/// The state of the recurring transaction list.
class RecurringTransactionState {
  final List<RecurringTransaction> items;
  final bool isLoading;
  final String? error;
  final RecurringTransactionType? filterType;

  const RecurringTransactionState({
    this.items = const [],
    this.isLoading = false,
    this.error,
    this.filterType,
  });

  RecurringTransactionState copyWith({
    List<RecurringTransaction>? items,
    bool? isLoading,
    String? error,
    RecurringTransactionType? filterType,
    bool clearError = false,
    bool clearFilterType = false,
  }) {
    return RecurringTransactionState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      filterType: clearFilterType ? null : (filterType ?? this.filterType),
    );
  }
}

/// The recurring transaction list state manager.
@riverpod
class RecurringTransactionNotifier extends _$RecurringTransactionNotifier {
  @override
  RecurringTransactionState build() {
    return const RecurringTransactionState();
  }

  /// Load the list of recurring transactions.
  Future<void> loadList({RecurringTransactionType? type}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final service = ref.read(recurringTransactionServiceProvider);
      final items = await service.getList(type: type);
      state = state.copyWith(
        items: items,
        isLoading: false,
        filterType: type,
        clearFilterType: type == null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Create a recurring transaction.
  Future<bool> create(RecurringTransactionCreateRequest request) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final service = ref.read(recurringTransactionServiceProvider);
      await service.create(request);
      await loadList(type: state.filterType);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// Update a recurring transaction.
  Future<bool> update(String id, Map<String, dynamic> updates) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final service = ref.read(recurringTransactionServiceProvider);
      await service.update(id, updates);
      await loadList(type: state.filterType);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// Delete a recurring transaction.
  Future<bool> delete(String id) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final service = ref.read(recurringTransactionServiceProvider);
      await service.delete(id);
      await loadList(type: state.filterType);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// Toggle the active status of a recurring transaction (optimistic update).
  Future<bool> toggleActive(String id, bool isActive) async {
    // 1. Save original state for rollback
    final originalItems = List<RecurringTransaction>.from(state.items);

    // 2. Optimistic update UI
    state = state.copyWith(
      items: state.items
          .map(
            (item) => item.id == id ? item.copyWith(isActive: isActive) : item,
          )
          .toList(),
    );

    // 3. Make request
    try {
      final service = ref.read(recurringTransactionServiceProvider);
      await service.update(id, {'is_active': isActive});
      return true;
    } catch (e) {
      // 4. Rollback on failure.
      state = state.copyWith(items: originalItems, error: e.toString());
      return false;
    }
  }
}
