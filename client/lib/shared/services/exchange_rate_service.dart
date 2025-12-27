import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/network_client.dart';
import '../../core/network/exceptions/app_exception.dart';
import '../models/exchange_rate.dart';

class ExchangeRateService {
  final NetworkClient _networkClient;

  ExchangeRateService(this._networkClient);

  Future<ExchangeRateResponse> getExchangeRates() async {
    return await _networkClient.request<ExchangeRateResponse>(
      '/exchange-rates',
      method: HttpMethod.get,
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          final data = json['data'];
          if (data is Map<String, dynamic>) {
            return ExchangeRateResponse.fromJson(data);
          }
        }
        throw DataParsingException('Invalid exchange rate response format');
      },
    );
  }
}

final exchangeRateServiceProvider = Provider<ExchangeRateService>((ref) {
  final networkClient = ref.watch(networkClientProvider);
  return ExchangeRateService(networkClient);
});
