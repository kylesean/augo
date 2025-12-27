import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/chat_history_provider.dart';
import 'package:augo/i18n/strings.g.dart';

part 'conversation_expense_provider.g.dart';

/// Current conversation expense state
class ConversationExpenseState {
  /// Cumulative expenses from real-time stream (during session)
  final double realtimeExpense;

  /// Current conversation ID
  final String? conversationId;

  const ConversationExpenseState({
    this.realtimeExpense = 0.0,
    this.conversationId,
  });

  ConversationExpenseState copyWith({
    double? realtimeExpense,
    String? conversationId,
  }) {
    return ConversationExpenseState(
      realtimeExpense: realtimeExpense ?? this.realtimeExpense,
      conversationId: conversationId ?? this.conversationId,
    );
  }
}

/// Current conversation expense Notifier
///
/// Maintains real-time expense accumulation for header display.
@riverpod
class ConversationExpenseNotifier extends _$ConversationExpenseNotifier {
  @override
  ConversationExpenseState build() {
    return const ConversationExpenseState();
  }

  /// Add a real-time expense
  void addExpense(double amount, {String? transactionType}) {
    // Only count expense type
    final type = transactionType?.toLowerCase() ?? 'expense';
    if (type != 'expense') return;

    if (amount > 0) {
      state = state.copyWith(realtimeExpense: state.realtimeExpense + amount);
    }
  }

  /// Reset (for new conversation)
  void reset({String? conversationId}) {
    state = ConversationExpenseState(
      realtimeExpense: 0.0,
      conversationId: conversationId,
    );
  }

  /// Switch conversation
  void switchConversation(String? newConversationId) {
    if (state.conversationId != newConversationId) {
      reset(conversationId: newConversationId);
    }
  }
}

/// Current conversation expense statistics Provider
///
/// Calculates total expenses from historical messages + real-time accumulation.
@riverpod
double conversationTotalExpense(Ref ref) {
  // 只订阅 messages 变化，避免其他状态变化触发重算
  final messages = ref.watch(
    chatHistoryProvider.select((state) => state.messages),
  );
  // Use conversationExpenseProvider which comes from ConversationExpenseNotifier (suffix stripped)
  final expenseState = ref.watch(conversationExpenseProvider);

  double totalExpense = expenseState.realtimeExpense;

  // Extract expenses from historical messages
  for (final message in messages) {
    // Process UI components
    for (final component in message.uiComponents) {
      if (component.toolName == 'create_transaction') {
        final data = component.userSelection ?? component.data;
        if (data.isEmpty) continue;

        final type =
            data['transaction_type'] as String? ??
            data['type'] as String? ??
            'expense';

        if (type.toLowerCase() != 'expense') continue;

        final amount = _parseAmount(data['amount']);
        if (amount > 0) {
          totalExpense += amount;
        }
      } else if (component.toolName == 'record_transactions' ||
          component.toolName == 'record_shared_transactions') {
        final data = component.userSelection ?? component.data;
        if (data.isEmpty) continue;

        final summary = data['summary'] as Map<String, dynamic>?;
        if (summary != null) {
          final expenseTotal = _parseAmount(summary['expense_total']);
          if (expenseTotal > 0) {
            totalExpense += expenseTotal;
          }
        }
      } else if (component.toolName == 'create_space_transaction') {
        final data = component.userSelection ?? component.data;
        if (data.isEmpty) continue;

        final type = data['type'] as String? ?? 'expense';
        if (type.toLowerCase() != 'expense') continue;

        final amount = _parseAmount(data['amount']);
        if (amount > 0) {
          totalExpense += amount;
        }
      }
    }

    // Process toolCalls (historical records)
    for (final messageToolCall in message.toolCalls) {
      if (messageToolCall.name == 'create_transaction') {
        final args = messageToolCall.args;
        if (args.isEmpty) continue;

        final type = args['transaction_type'] as String? ?? 'expense';
        if (type.toLowerCase() != 'expense') continue;

        final amount = _parseAmount(args['amount']);
        if (amount > 0) {
          totalExpense += amount;
        }
      } else if (messageToolCall.name == 'record_transactions' ||
          messageToolCall.name == 'record_shared_transactions') {
        final args = messageToolCall.args;
        if (args.isEmpty) continue;

        final transactions = args['transactions'] as List<dynamic>?;
        if (transactions != null) {
          for (final tx in transactions) {
            final txMap = tx as Map<String, dynamic>;
            final type = txMap['type'] as String? ?? 'expense';
            if (type.toLowerCase() != 'expense') continue;

            final amount = _parseAmount(txMap['amount']);
            if (amount > 0) {
              totalExpense += amount;
            }
          }
        }
      } else if (messageToolCall.name == 'create_space_transaction') {
        final args = messageToolCall.args;
        if (args.isEmpty) continue;

        final type = args['transaction_type'] as String? ?? 'expense';
        if (type.toLowerCase() != 'expense') continue;

        final amount = _parseAmount(args['amount']);
        if (amount > 0) {
          totalExpense += amount;
        }
      }
    }
  }

  return totalExpense;
}

/// Parse amount, supporting multiple types
double _parseAmount(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

/// Formatted current conversation expense title Provider
///
@riverpod
String conversationExpenseTitle(Ref ref) {
  final expense = ref.watch(conversationTotalExpenseProvider);

  if (expense <= 0) {
    return '${t.chat.currentExpense}: 0.00';
  }

  final formatter = NumberFormat('#,##0.00');
  return '${t.chat.currentExpense}: ${formatter.format(expense)}';
}
