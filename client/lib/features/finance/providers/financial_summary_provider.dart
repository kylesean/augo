import 'package:decimal/decimal.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../profile/models/financial_account.dart';
import '../../profile/providers/financial_account_provider.dart';
// import '../../profile/providers/financial_settings_provider.dart'; // Removed
import '../../../shared/providers/exchange_rate_provider.dart';

part 'financial_summary_provider.g.dart';

class FinancialSummary {
  final Decimal totalNetWorth;
  final Decimal totalAssets;
  final Decimal totalLiabilities;
  final String currencyCode;
  final bool isLoading;

  const FinancialSummary({
    required this.totalNetWorth,
    required this.totalAssets,
    required this.totalLiabilities,
    required this.currencyCode,
    this.isLoading = false,
  });

  static final empty = FinancialSummary(
    totalNetWorth: Decimal.zero,
    totalAssets: Decimal.zero,
    totalLiabilities: Decimal.zero,
    currencyCode: 'CNY',
  );
}

@riverpod
class FinancialSummaryNotifier extends _$FinancialSummaryNotifier {
  @override
  FinancialSummary build(String targetCurrency) {
    // 监听必要的 Providers
    final accountsState = ref.watch(financialAccountProvider);
    // ratesNotifier needs the state to be ready to access .value inside convert
    // So we watch the provider to rebuild when it changes.
    final ratesAsync = ref.watch(exchangeRateProvider);

    // 如果汇率还在加载，返回带有 loading 标记的状态
    if (ratesAsync.isLoading) {
      return FinancialSummary.empty.copyWith(
        isLoading: true,
        currencyCode: targetCurrency,
      );
    }

    // 如果账户也在加载，同理
    if (accountsState.isLoading) {
      return FinancialSummary.empty.copyWith(
        isLoading: true,
        currencyCode: targetCurrency,
      );
    }

    final ratesNotifier = ref.read(exchangeRateProvider.notifier);

    var totalAssets = Decimal.zero;
    var totalLiabilities = Decimal.zero;
    var totalNetWorth = Decimal.zero;

    for (final account in accountsState.accounts) {
      if (!account.includeInNetWorth) continue;

      final currency = account.currencyCode;

      final convertedAmount =
          ratesNotifier.convert(
            account.currentBalance ?? account.initialBalance,
            currency,
            targetCurrency,
          ) ??
          Decimal.zero;

      if (account.nature == FinancialNature.liability) {
        totalLiabilities += convertedAmount;
        totalNetWorth -= convertedAmount;
      } else {
        totalAssets += convertedAmount;
        totalNetWorth += convertedAmount;
      }
    }

    return FinancialSummary(
      totalNetWorth: totalNetWorth,
      totalAssets: totalAssets,
      totalLiabilities: totalLiabilities,
      currencyCode: targetCurrency,
      isLoading: false,
    );
  }
}

extension FinancialSummaryCopy on FinancialSummary {
  FinancialSummary copyWith({
    Decimal? totalNetWorth,
    Decimal? totalAssets,
    Decimal? totalLiabilities,
    String? currencyCode,
    bool? isLoading,
  }) {
    return FinancialSummary(
      totalNetWorth: totalNetWorth ?? this.totalNetWorth,
      totalAssets: totalAssets ?? this.totalAssets,
      totalLiabilities: totalLiabilities ?? this.totalLiabilities,
      currencyCode: currencyCode ?? this.currencyCode,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
