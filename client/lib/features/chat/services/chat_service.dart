// features/chat/services/chat_service.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/network_client.dart';

class ChatService {
  final NetworkClient _networkClient;

  ChatService(this._networkClient);

  /// Search transaction records
  Future<Map<String, dynamic>> searchTransactions(
    Map<String, dynamic> searchParams,
  ) async {
    final response = await _networkClient.request<Map<String, dynamic>>(
      '/transactions/search',
      method: HttpMethod.get,
      queryParameters: searchParams,
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          return json;
        }
        throw Exception(
          "API /transactions/search expected to return an object but received ${json.runtimeType}",
        );
      },
    );

    // Return the content in the data field, which should contain items and hasNextPage fields
    if (response.containsKey('data') &&
        response['data'] is Map<String, dynamic>) {
      return response['data'] as Map<String, dynamic>;
    }

    // If there is no data field, return the response directly (compatibility handling)
    return response;
  }
}

// Provider for ChatService
final chatServiceProvider = Provider<ChatService>((ref) {
  final networkClient = ref.read(networkClientProvider);
  return ChatService(networkClient);
});
