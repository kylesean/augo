// features/home/providers/transaction_feed_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:augo/features/home/models/transaction_model.dart';

part 'transaction_feed_state.freezed.dart';

/// Transaction feed state (using freezed to generate immutable class)
@freezed
abstract class TransactionFeedState with _$TransactionFeedState {
  const factory TransactionFeedState({
    @Default([]) List<TransactionModel> transactions,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasReachedMax,
    @Default(1) int currentPage,
    String? errorMessage,
  }) = _TransactionFeedState;
}
