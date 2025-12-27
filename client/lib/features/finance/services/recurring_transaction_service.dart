import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/network_client.dart';
import '../models/recurring_transaction.dart';

part 'recurring_transaction_service.g.dart';

/// 周期交易服务
class RecurringTransactionService {
  final NetworkClient _networkClient;

  RecurringTransactionService(this._networkClient);

  /// 获取周期交易列表
  Future<List<RecurringTransaction>> getList({
    RecurringTransactionType? type,
    bool? isActive,
  }) async {
    final queryParams = <String, dynamic>{};
    if (type != null) {
      queryParams['type'] = type.value;
    }
    if (isActive != null) {
      queryParams['is_active'] = isActive.toString();
    }

    final response = await _networkClient.requestMap(
      '/transactions/recurring',
      method: HttpMethod.get,
      queryParameters: queryParams,
    );

    final data = response['data'] as List<dynamic>;
    return data
        .map(
          (json) => RecurringTransaction.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }

  /// 获取周期交易详情
  Future<RecurringTransaction> getById(String id) async {
    final response = await _networkClient.requestMap(
      '/transactions/recurring/$id',
      method: HttpMethod.get,
    );
    return RecurringTransaction.fromJson(
      response['data'] as Map<String, dynamic>,
    );
  }

  /// 创建周期交易
  Future<RecurringTransaction> create(
    RecurringTransactionCreateRequest request,
  ) async {
    final response = await _networkClient.requestMap(
      '/transactions/recurring',
      method: HttpMethod.post,
      data: request.toJson(),
    );
    return RecurringTransaction.fromJson(
      response['data'] as Map<String, dynamic>,
    );
  }

  /// 更新周期交易
  Future<RecurringTransaction> update(
    String id,
    Map<String, dynamic> updates,
  ) async {
    final response = await _networkClient.requestMap(
      '/transactions/recurring/$id',
      method: HttpMethod.put,
      data: updates,
    );
    return RecurringTransaction.fromJson(
      response['data'] as Map<String, dynamic>,
    );
  }

  /// 删除周期交易
  Future<void> delete(String id) async {
    await _networkClient.requestMap(
      '/transactions/recurring/$id',
      method: HttpMethod.delete,
    );
  }
}

/// 周期交易服务提供者
@riverpod
RecurringTransactionService recurringTransactionService(Ref ref) {
  final networkClient = ref.watch(networkClientProvider);
  return RecurringTransactionService(networkClient);
}
