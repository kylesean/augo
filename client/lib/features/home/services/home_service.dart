import 'package:augo/core/network/network_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:augo/features/home/models/daily_expense_summary_model.dart';
import 'package:augo/features/home/models/total_expense_model.dart';
import 'package:augo/features/home/models/transaction_model.dart';

import 'package:augo/core/network/exceptions/app_exception.dart';
// import 'package:augo/i18n/strings.g.dart'; // Unused

class HomeService {
  final NetworkClient _networkClient;

  HomeService(this._networkClient);

  // Get daily expense summary for a specific month (for calendar heat map)
  Future<CalendarMonthData> getCalendarMonthDetails(int year, int month) async {
    return await _networkClient.request<CalendarMonthData>(
      '/home/calendar-month-details',
      method: HttpMethod.get,
      queryParameters: {'year': year, 'month': month},
      fromJsonT: (json) => _parseItemResponse(json, CalendarMonthData.fromJson),
    );
  }

  // Get total expense amount
  Future<TotalExpenseData> getTotalExpense() async {
    return await _networkClient.request<TotalExpenseData>(
      '/home/total-expense',
      method: HttpMethod.get,
      fromJsonT: (json) => _parseItemResponse(json, TotalExpenseData.fromJson),
    );
  }

  // Get transaction feed data
  // New endpoint: GET /api/v1/transactions
  Future<List<TransactionModel>> getTransactionFeed({
    int page = 1,
    int size = 20,
    String? type, // EXPENSE, INCOME, TRANSFER
    String? date, // (YYYY-MM-DD)
  }) async {
    // Build query parameters
    final Map<String, dynamic> queryParameters = {'page': page, 'size': size};
    if (type != null && type.isNotEmpty) {
      queryParameters['transaction_type'] = type.toUpperCase();
    }
    if (date != null && date.isNotEmpty) {
      queryParameters['date'] = date;
    }

    return await _networkClient.request<List<TransactionModel>>(
      '/transactions',
      method: HttpMethod.get,
      queryParameters: queryParameters,
      fromJsonT: (json) =>
          _parseListResponse(json, TransactionModel.fromApiJson),
    );
  }

  // Get transactions for a specific date (for bottom modal)
  Future<List<TransactionModel>> getTransactionsForDate(DateTime date) async {
    final dateStr =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    return await _networkClient.request<List<TransactionModel>>(
      '/transactions',
      method: HttpMethod.get,
      queryParameters: {
        'date': dateStr,
        'size': 100,
      }, // Fetch enough for a day view
      fromJsonT: (json) =>
          _parseListResponse(json, TransactionModel.fromApiJson),
    );
  }

  // Get transaction details
  Future<TransactionModel> getTransactionDetail(String transactionId) async {
    return await _networkClient.request<TransactionModel>(
      '/transactions/$transactionId',
      method: HttpMethod.get,
      fromJsonT: (json) =>
          _parseItemResponse(json, TransactionModel.fromApiJson),
    );
  }

  // Create a transaction record
  Future<TransactionModel> createTransaction(
    Map<String, dynamic> transactionData,
  ) async {
    return await _networkClient.request<TransactionModel>(
      '/transactions',
      method: HttpMethod.post,
      data: transactionData,
      fromJsonT: (json) =>
          _parseItemResponse(json, TransactionModel.fromApiJson),
    );
  }

  // Delete a transaction record
  Future<void> deleteTransaction(String transactionId) async {
    await _networkClient.request<void>(
      '/transactions/$transactionId',
      method: HttpMethod.delete,
      fromJsonT: (_) {},
    );
  }

  // Search transactions - for infinite scroll pagination
  Future<Map<String, dynamic>> searchTransactions({
    int page = 1,
    int size = 20,
    String? keyword,
    String? startDate,
    String? endDate,
    String? type,
    String? categoryKeys,
    String? tags,
  }) async {
    final Map<String, dynamic> queryParameters = {'page': page, 'size': size};
    if (keyword != null) queryParameters['keyword'] = keyword;
    if (startDate != null) queryParameters['start_date'] = startDate;
    if (endDate != null) queryParameters['end_date'] = endDate;
    if (type != null) queryParameters['transaction_type'] = type.toUpperCase();
    if (categoryKeys != null) queryParameters['category_keys'] = categoryKeys;
    if (tags != null) queryParameters['tags'] = tags;

    return await _networkClient.request<Map<String, dynamic>>(
      '/transactions/search',
      method: HttpMethod.get,
      queryParameters: queryParameters,
      fromJsonT: (json) {
        if (json is Map<String, dynamic> && json.containsKey('data')) {
          return json['data'] as Map<String, dynamic>;
        }
        return {};
      },
    );
  }

  // --- Helpers for centralized parsing logic ---

  /// Helper to parse a single item response { code: 0, data: { ... } } or direct { ... }
  T _parseItemResponse<T>(
    dynamic json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (json is Map<String, dynamic>) {
      // API Standard Response: { code: 0, message: "...", data: {...} }
      if (json.containsKey('data')) {
        final dataField = json['data'];
        if (dataField is Map<String, dynamic>) {
          return fromJson(dataField);
        }
        // Fallback if data is null or not a map, might depend on specific API behavior
        // If data is expected but null, logic might need adjustment based on requirements
      }
      // Fallback: try parsing the root object directly (for legacy or direct returns)
      try {
        return fromJson(json);
      } catch (e) {
        throw DataParsingException("Failed to parse item response: $json");
      }
    }
    throw DataParsingException("Expected JSON Object, got ${json.runtimeType}");
  }

  /// Helper to parse a list response { code: 0, data: { items: [...] } }
  List<T> _parseListResponse<T>(
    dynamic json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (json is Map<String, dynamic>) {
      final dataField = json['data'];

      // Handle case where data is null (empty list)
      if (dataField == null) return [];

      // Handle standard pagination format: data: { items: [...] }
      if (dataField is Map<String, dynamic>) {
        final items = dataField['items'];
        if (items is List) {
          return items.map((item) {
            if (item is Map<String, dynamic>) {
              return fromJson(item);
            }
            throw DataParsingException(
              "Item in list is not a Map: ${item.runtimeType}",
            );
          }).toList();
        }
        // If data is a map but has no 'items' key, verify if it is itself the list (unlikely based on API spec but safe to check)
      }

      // Handle case where data itself is the list: data: [...]
      if (dataField is List) {
        return dataField.map((item) {
          if (item is Map<String, dynamic>) {
            return fromJson(item);
          }
          throw DataParsingException(
            "Item in list is not a Map: ${item.runtimeType}",
          );
        }).toList();
      }
    }
    // If structure doesn't match known patterns, return empty or throw
    // For robustness, returning empty list is safer than crashing UI in some views, but strict parsing helps debugging
    return [];
  }
}

// Provider for HomeService
final homeServiceProvider = Provider<HomeService>((ref) {
  final networkClient = ref.watch(networkClientProvider);
  return HomeService(networkClient);
});
