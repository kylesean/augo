import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:decimal/decimal.dart';
import 'package:logging/logging.dart';
import '../../../core/network/network_client.dart';
import '../../../core/network/exceptions/app_exception.dart';
import '../models/financial_account.dart';
import '../models/financial_settings.dart';
import '../models/user_info.dart';

class ProfileService {
  final NetworkClient _networkClient;
  final _logger = Logger('ProfileService');

  ProfileService(this._networkClient);

  /// Get current user information
  Future<UserInfo> getCurrentUser() async {
    return await _networkClient.request<UserInfo>(
      '/user',
      method: HttpMethod.get,
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          try {
            final data = json['data'];
            if (data == null) {
              throw DataParsingException("data field is null");
            }
            if (data is Map<String, dynamic>) {
              return UserInfo.fromJson(data);
            }
            throw DataParsingException("data field is not an object");
          } catch (e) {
            throw DataParsingException(
              "Failed to parse user info: ${e.toString()}",
            );
          }
        }
        throw DataParsingException("API /user expects an object");
      },
    );
  }

  /// Update user profile (username, avatar)
  Future<UserInfo> updateProfile({String? username, String? avatarUrl}) async {
    final data = <String, dynamic>{};
    if (username != null) data['username'] = username;
    if (avatarUrl != null) data['avatarUrl'] = avatarUrl;

    return await _networkClient.request<UserInfo>(
      '/user',
      method: HttpMethod.patch,
      data: data,
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          try {
            final respData = json['data'];
            if (respData == null) {
              throw DataParsingException("data field is null");
            }
            if (respData is Map<String, dynamic>) {
              return UserInfo.fromJson(respData);
            }
            throw DataParsingException("data field is not an object");
          } catch (e) {
            throw DataParsingException(
              "Failed to parse profile update response: ${e.toString()}",
            );
          }
        }
        throw DataParsingException("API /user PATCH expects an object");
      },
    );
  }

  Future<FinancialAccountResponse> getFinancialAccounts() async {
    return await _networkClient.request<FinancialAccountResponse>(
      '/user/financial-accounts',
      method: HttpMethod.get,
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          try {
            // Response format is {code, message, data}, need to extract data field
            final data = json['data'];

            if (data == null) {
              return FinancialAccountResponse(totalBalance: Decimal.zero);
            }

            if (data is Map<String, dynamic>) {
              return FinancialAccountResponse.fromJson(data);
            }

            throw DataParsingException(
              "data field is not an object, but ${data.runtimeType}",
            );
          } catch (e) {
            throw DataParsingException(
              "Failed to parse financial accounts response: ${e.toString()}",
            );
          }
        }
        throw DataParsingException(
          "API /user/financial-accounts expects an object, but received ${json.runtimeType}",
        );
      },
    );
  }

  /// Save user financial accounts information
  Future<FinancialAccountSummary> saveFinancialAccounts(
    List<FinancialAccount> accounts,
  ) async {
    final request = FinancialAccountRequest(accounts: accounts);

    return await _networkClient.request<FinancialAccountSummary>(
      '/user/financial-accounts',
      method: HttpMethod.post,
      data: request.toJson(),
      fromJsonT: (json) {
        _logger.fine('saveFinancialAccounts response: $json');
        if (json is Map<String, dynamic>) {
          try {
            // Response format is {code, message, data}, need to extract data field
            final data = json['data'];

            if (data == null) {
              throw DataParsingException("data field is null");
            }

            if (data is Map<String, dynamic>) {
              return FinancialAccountSummary.fromJson(data);
            }

            throw DataParsingException(
              "data field is not an object, but ${data.runtimeType}",
            );
          } catch (e) {
            _logger.severe('saveFinancialAccounts parsing error', e);
            throw DataParsingException(
              "Failed to parse financial accounts response: ${e.toString()}",
            );
          }
        }
        throw DataParsingException(
          "API /user/financial-accounts expects an object, but received ${json.runtimeType}",
        );
      },
    );
  }

  /// Get user financial settings
  Future<FinancialSettingsResponse> getFinancialSettings() async {
    return await _networkClient.request<FinancialSettingsResponse>(
      '/financial-settings',
      method: HttpMethod.get,
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          try {
            // Response format is {code, message, data}, need to extract data field
            final data = json['data'];
            if (data == null) {
              throw DataParsingException("data field is null");
            }
            if (data is Map<String, dynamic>) {
              return FinancialSettingsResponse.fromJson(data);
            }
            throw DataParsingException("data field is not an object");
          } catch (e) {
            throw DataParsingException(
              "Failed to parse financial settings response: ${e.toString()}",
            );
          }
        }
        throw DataParsingException(
          "API /financial-settings expects an object, but received ${json.runtimeType}",
        );
      },
    );
  }

  /// Update user financial settings
  Future<FinancialSettingsResponse> updateFinancialSettings(
    FinancialSettingsRequest request,
  ) async {
    return await _networkClient.request<FinancialSettingsResponse>(
      '/financial-settings',
      method: HttpMethod.patch,
      data: request.toJson(),
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          try {
            // Response format is {code, message, data}, need to extract data field
            final data = json['data'];
            if (data == null) {
              throw DataParsingException("data field is null");
            }
            if (data is Map<String, dynamic>) {
              return FinancialSettingsResponse.fromJson(data);
            }
            throw DataParsingException("data field is not an object");
          } catch (e) {
            throw DataParsingException(
              "Failed to parse financial settings response: ${e.toString()}",
            );
          }
        }
        throw DataParsingException(
          "API /financial-settings expects an object, but received ${json.runtimeType}",
        );
      },
    );
  }

  /// Update a single account
  Future<FinancialAccount> updateFinancialAccount(
    String accountId,
    FinancialAccount account,
  ) async {
    return await _networkClient.request<FinancialAccount>(
      '/user/financial-accounts/$accountId',
      method: HttpMethod.patch,
      data: account.toJson(),
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          try {
            return FinancialAccount.fromJson(json);
          } catch (e) {
            throw DataParsingException(
              "Failed to parse update account response: ${e.toString()}",
            );
          }
        }
        throw DataParsingException(
          "API expects an object, but received ${json.runtimeType}",
        );
      },
    );
  }

  /// Delete a single account
  Future<void> deleteFinancialAccount(String accountId) async {
    await _networkClient.request<void>(
      '/user/financial-accounts/$accountId',
      method: HttpMethod.delete,
      fromJsonT: (_) {},
    );
  }
}

// Provider for ProfileService
final profileServiceProvider = Provider<ProfileService>((ref) {
  final networkClient = ref.watch(networkClientProvider);
  return ProfileService(networkClient);
});
