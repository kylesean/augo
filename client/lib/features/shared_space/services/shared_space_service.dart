import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:augo/core/network/network_client.dart';
import '../../../core/network/exceptions/app_exception.dart';
import '../models/shared_space_models.dart';

part 'shared_space_service.g.dart';

class SharedSpaceService {
  final NetworkClient _networkClient;

  SharedSpaceService(this._networkClient);

  /// Get the list of shared spaces for the user
  Future<SharedSpaceListResponse> getSharedSpaces({
    int page = 1,
    int limit = 20,
  }) async {
    return await _networkClient.request<SharedSpaceListResponse>(
      '/shared-spaces',
      method: HttpMethod.get,
      queryParameters: {'page': page, 'limit': limit},
      fromJsonT: (json) =>
          _parsePaginatedResponse(json, SharedSpaceListResponse.fromJson),
    );
  }

  /// Create a new shared space
  Future<SharedSpace> createSharedSpace({
    required String name,
    String? description,
  }) async {
    return await _networkClient.request<SharedSpace>(
      '/shared-spaces',
      method: HttpMethod.post,
      data: {'name': name, if (description != null) 'description': description},
      fromJsonT: (json) => _parseItemResponse(json, SharedSpace.fromJson),
    );
  }

  /// Get shared space details
  Future<SharedSpace> getSharedSpaceDetail(String spaceId) async {
    return await _networkClient.request<SharedSpace>(
      '/shared-spaces/$spaceId',
      method: HttpMethod.get,
      fromJsonT: (json) => _parseItemResponse(json, SharedSpace.fromJson),
    );
  }

  /// Generate invite code
  Future<InviteCode> generateInviteCode(String spaceId) async {
    return await _networkClient.request<InviteCode>(
      '/shared-spaces/$spaceId/invite-code',
      method: HttpMethod.post,
      fromJsonT: (json) => _parseItemResponse(json, InviteCode.fromJson),
    );
  }

  /// Join space with invite code
  Future<SharedSpace> joinSpaceWithCode(String inviteCode) async {
    return await _networkClient.request<SharedSpace>(
      '/shared-spaces/join-with-code',
      method: HttpMethod.post,
      data: {'code': inviteCode},
      fromJsonT: (json) => _parseItemResponse(json, SharedSpace.fromJson),
    );
  }

  /// Remove member
  Future<void> removeMember(String spaceId, String userId) async {
    await _networkClient.request<void>(
      '/shared-spaces/$spaceId/members/$userId',
      method: HttpMethod.delete,
    );
  }

  /// Leave space
  Future<void> leaveSpace(String spaceId) async {
    await _networkClient.request<void>(
      '/shared-spaces/$spaceId/leave',
      method: HttpMethod.post,
    );
  }

  /// Delete space
  Future<void> deleteSpace(String spaceId) async {
    await _networkClient.request<void>(
      '/shared-spaces/$spaceId',
      method: HttpMethod.delete,
    );
  }

  /// Get space settlement information
  Future<Settlement> getSpaceSettlement(String spaceId) async {
    return await _networkClient.request<Settlement>(
      '/shared-spaces/$spaceId/settlement',
      method: HttpMethod.get,
      fromJsonT: (json) => _parseItemResponse(json, Settlement.fromJson),
    );
  }

  /// Get transactions in this space
  Future<SpaceTransactionListResponse> getSpaceTransactions(
    String spaceId, {
    int page = 1,
    int limit = 20,
  }) async {
    return await _networkClient.request<SpaceTransactionListResponse>(
      '/shared-spaces/$spaceId/transactions',
      method: HttpMethod.get,
      queryParameters: {'page': page, 'limit': limit},
      fromJsonT: (json) => _parseTransactionListResponse(json),
    );
  }

  SpaceTransactionListResponse _parseTransactionListResponse(dynamic json) {
    if (json is Map<String, dynamic>) {
      final dataField = json['data'];
      if (dataField is List) {
        final transactions = dataField
            .map(
              (item) => SpaceTransaction.fromJson(item as Map<String, dynamic>),
            )
            .toList();
        return SpaceTransactionListResponse(
          transactions: transactions,
          total: transactions.length,
          page: 1,
          limit: 20,
        );
      }
    }
    throw DataParsingException("Failed to parse space transactions response");
  }

  /// Update space information
  Future<SharedSpace> updateSpace(
    String spaceId, {
    String? name,
    String? description,
  }) async {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (description != null) data['description'] = description;

    return await _networkClient.request<SharedSpace>(
      '/shared-spaces/$spaceId',
      method: HttpMethod.put,
      data: data,
      fromJsonT: (json) => _parseItemResponse(json, SharedSpace.fromJson),
    );
  }

  // --- Parsing Helpers ---

  T _parseItemResponse<T>(
    dynamic json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (json is Map<String, dynamic>) {
      final dataField = json['data'];
      if (dataField is Map<String, dynamic>) {
        try {
          return fromJson(dataField);
        } catch (e) {
          throw DataParsingException("Failed to parse item: ${e.toString()}");
        }
      }
    }
    throw DataParsingException("Expected JSON Object in 'data' field");
  }

  T _parsePaginatedResponse<T>(
    dynamic json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (json is Map<String, dynamic>) {
      final dataField = json['data'];
      if (dataField is Map<String, dynamic>) {
        try {
          return fromJson(dataField);
        } catch (e) {
          throw DataParsingException(
            "Failed to parse paginated response: ${e.toString()}",
          );
        }
      }
    }
    throw DataParsingException("Expected JSON Object in 'data' field");
  }
}

// Provider for SharedSpaceService
@riverpod
SharedSpaceService sharedSpaceService(Ref ref) {
  final networkClient = ref.watch(networkClientProvider);
  return SharedSpaceService(networkClient);
}
