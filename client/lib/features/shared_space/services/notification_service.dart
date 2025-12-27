import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/network_client.dart';
import '../../../core/network/exceptions/app_exception.dart';
import '../models/shared_space_models.dart';

class NotificationService {
  final NetworkClient _networkClient;

  NotificationService(this._networkClient);

  Future<NotificationListResponse> getNotifications({
    int page = 1,
    int limit = 20,
    bool? unreadOnly,
  }) async {
    final queryParameters = <String, dynamic>{'page': page, 'limit': limit};
    if (unreadOnly != null) {
      queryParameters['unread_only'] = unreadOnly;
    }

    return await _networkClient.request<NotificationListResponse>(
      '/notifications',
      method: HttpMethod.get,
      queryParameters: queryParameters,
      fromJsonT: (json) =>
          _parsePaginatedResponse(json, NotificationListResponse.fromJson),
    );
  }

  Future<int> getUnreadCount() async {
    final response = await _networkClient.request<Map<String, dynamic>>(
      '/notifications/unread-count',
      method: HttpMethod.get,
      fromJsonT: (json) => _parseItemResponse(json, (data) => data),
    );

    return response['count'] as int? ?? 0;
  }

  Future<void> markAsRead(String notificationId) async {
    await _networkClient.request<void>(
      '/notifications/$notificationId/read',
      method: HttpMethod.patch,
    );
  }

  Future<void> markAllAsRead() async {
    await _networkClient.request<void>(
      '/notifications/mark-all-read',
      method: HttpMethod.patch,
    );
  }

  Future<void> deleteNotification(String notificationId) async {
    await _networkClient.request<void>(
      '/notifications/$notificationId',
      method: HttpMethod.delete,
    );
  }

  Future<void> respondToSpaceInvite(String spaceId, String action) async {
    await _networkClient.request<void>(
      '/shared-spaces/$spaceId/invites/respond',
      method: HttpMethod.put,
      data: {
        'action': action, // 'accept' or 'reject'
      },
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

// Provider for NotificationService
final notificationServiceProvider = Provider<NotificationService>((ref) {
  final networkClient = ref.watch(networkClientProvider);
  return NotificationService(networkClient);
});
