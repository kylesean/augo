import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/network_client.dart';
import '../models/budget_models.dart';

class BudgetService {
  final NetworkClient _networkClient;

  BudgetService(this._networkClient);

  /// Get budget summary
  ///
  /// Includes usage, totals, and other statistics for all budgets
  /// [includePaused] whether to include paused budgets
  Future<BudgetSummary> getSummary({bool includePaused = false}) async {
    return await _networkClient.request<BudgetSummary>(
      '/budgets/summary',
      method: HttpMethod.get,
      queryParameters: {'include_paused': includePaused},
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          final data = json['data'];
          if (data is Map<String, dynamic>) {
            return BudgetSummary.fromJson(data);
          }
          throw DataParsingException(
            'API /budgets/summary: invalid "data" field format',
          );
        }
        throw DataParsingException(
          'API /budgets/summary: expected an object response',
        );
      },
    );
  }

  /// Get list of all budgets
  Future<List<Budget>> getAll() async {
    return await _networkClient.request<List<Budget>>(
      '/budgets',
      method: HttpMethod.get,
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          final data = json['data'];
          if (data is List) {
            return data
                .map((e) => Budget.fromJson(e as Map<String, dynamic>))
                .toList();
          }
        }
        throw DataParsingException('Invalid format for /budgets response');
      },
    );
  }

  /// Get single budget details
  Future<Budget> getById(String id) async {
    return await _networkClient.request<Budget>(
      '/budgets/$id',
      method: HttpMethod.get,
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          final data = json['data'];
          if (data is Map<String, dynamic>) {
            return Budget.fromJson(data);
          }
        }
        throw DataParsingException('Invalid format for /budgets/$id response');
      },
    );
  }

  /// Delete budget
  Future<void> delete(String id) async {
    await _networkClient.request<void>(
      '/budgets/$id',
      method: HttpMethod.delete,
      fromJsonT: (_) {},
    );
  }

  /// Create budget
  Future<Budget> create(BudgetCreateRequest request) async {
    return await _networkClient.request<Budget>(
      '/budgets',
      method: HttpMethod.post,
      data: request.toJson(),
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          final data = json['data'];
          if (data is Map<String, dynamic>) {
            return Budget.fromJson(data);
          }
        }
        throw DataParsingException('Invalid format for POST /budgets response');
      },
    );
  }

  /// Update budget
  Future<Budget> update(String id, BudgetUpdateRequest request) async {
    return await _networkClient.request<Budget>(
      '/budgets/$id',
      method: HttpMethod.put,
      data: request.toJson(),
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          final data = json['data'];
          if (data is Map<String, dynamic>) {
            return Budget.fromJson(data);
          }
        }
        throw DataParsingException(
          'Invalid format for PUT /budgets/$id response',
        );
      },
    );
  }
}

/// Data parsing exception
class DataParsingException implements Exception {
  final String message;
  DataParsingException(this.message);

  @override
  String toString() => 'DataParsingException: $message';
}

/// BudgetService Provider
final budgetServiceProvider = Provider<BudgetService>((ref) {
  final networkClient = ref.watch(networkClientProvider);
  return BudgetService(networkClient);
});
