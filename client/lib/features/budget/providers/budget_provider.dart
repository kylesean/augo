import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/budget_models.dart';
import '../services/budget_service.dart';
import 'package:augo/i18n/strings.g.dart';

part 'budget_provider.g.dart';

@riverpod
class BudgetFilterState extends _$BudgetFilterState {
  @override
  BudgetFilter build() => BudgetFilter.active;

  void setFilter(BudgetFilter filter) => state = filter;
}

enum BudgetFilter { active, all }

extension BudgetFilterExtension on BudgetFilter {
  String get label => switch (this) {
    BudgetFilter.active => t.budget.active,
    BudgetFilter.all => t.budget.all,
  };

  bool get includePaused => this == BudgetFilter.all;
}

class BudgetSummaryState {
  final BudgetSummary? summary;
  final bool isLoading;
  final String? error;

  const BudgetSummaryState({this.summary, this.isLoading = false, this.error});

  BudgetSummaryState copyWith({
    BudgetSummary? summary,
    bool? isLoading,
    String? error,
  }) {
    return BudgetSummaryState(
      summary: summary ?? this.summary,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  bool get hasBudgets => summary?.hasBudgets ?? false;
}

@riverpod
class BudgetSummaryNotifier extends _$BudgetSummaryNotifier {
  @override
  BudgetSummaryState build() {
    return const BudgetSummaryState();
  }

  Future<void> load() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final service = ref.read(budgetServiceProvider);
      final filter = ref.read(budgetFilterStateProvider);
      final summary = await service.getSummary(
        includePaused: filter.includePaused,
      );
      state = state.copyWith(summary: summary, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(error: null);
    await load();
  }

  Future<bool> deleteBudget(String id) async {
    final service = ref.read(budgetServiceProvider);
    try {
      await service.delete(id);
      await refresh();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }
}

@riverpod
Future<List<Budget>> budgetList(Ref ref) async {
  final service = ref.watch(budgetServiceProvider);
  return await service.getAll();
}
