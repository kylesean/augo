import 'package:flutter/material.dart';
import 'package:tabler_icons_next/tabler_icons_next.dart' as tabler;

import '../../profile/models/financial_account.dart';

/// UI 层的账户性质分类（用于分组显示）
enum AccountNature {
  liquidAssets,
  creditAccounts,
  investmentAssets,
  longTermLiabilities,
  receivablesPayables,
  otherAssets,
}

extension AccountNatureX on AccountNature {
  /// Chinese + English header to match the PRD wording.
  String get displayName {
    switch (this) {
      case AccountNature.liquidAssets:
        return '流动资产';
      case AccountNature.creditAccounts:
        return '信用账户';
      case AccountNature.investmentAssets:
        return '投资资产';
      case AccountNature.longTermLiabilities:
        return '长期负债 ';
      case AccountNature.receivablesPayables:
        return '往来款项';
      case AccountNature.otherAssets:
        return '其他资产';
    }
  }

  /// Supporting description surfaced under the header.
  String get description {
    switch (this) {
      case AccountNature.liquidAssets:
        return '日常随时可用、流动性最高的钱。';
      case AccountNature.creditAccounts:
        return '金融机构授予的循环使用信贷额度。';
      case AccountNature.investmentAssets:
        return '以增值为目的、价值随市场波动的资产。';
      case AccountNature.longTermLiabilities:
        return '结构化的长期贷款或融资性债务。';
      case AccountNature.receivablesPayables:
        return '因往来产生的短期债权债务。';
      case AccountNature.otherAssets:
        return '其他特殊用途或流动性较低的资产。';
    }
  }
}

typedef AccountTypeIconBuilder = Widget Function(Color color);

class AccountTypeDefinition {
  const AccountTypeDefinition({
    required this.id,
    required this.apiType,
    required this.nature,
    required this.title,
    required this.subtitle,
    required this.iconBuilder,
    required this.accentColor,
    this.helper,
    this.requiresCustomName = true,
    this.keywords = const [],
  });

  /// UI 层的唯一标识（与后端 FinancialAccountType 一致）
  final String id;

  /// 对应后端的 FinancialAccountType 枚举值
  final FinancialAccountType apiType;

  /// UI 层的账户性质分类
  final AccountNature nature;

  final String title;
  final String subtitle;
  final AccountTypeIconBuilder iconBuilder;
  final Color accentColor;
  final String? helper;
  final bool requiresCustomName;
  final List<String> keywords;

  bool matches(String query) {
    final lowerQuery = query.trim().toLowerCase();
    if (lowerQuery.isEmpty) {
      return true;
    }
    final haystack = <String?>[
      id,
      title,
      subtitle,
      helper,
      ...keywords,
    ].whereType<String>().map((value) => value.toLowerCase());
    return haystack.any((value) => value.contains(lowerQuery));
  }
}

AccountTypeIconBuilder _tablerIcon(
  Widget Function({Color? color, double? width, double? height}) builder,
) {
  return (Color color) => SizedBox.square(
    dimension: 28, // 进一步增大容器尺寸
    child: builder(color: color, width: 24, height: 24), // 进一步增大图标尺寸
  );
}

/// Registry of all account-type definitions.
///
/// 每个后端 FinancialAccountType 对应唯一一个 UI 定义。
class AccountTypeRegistry {
  static final List<AccountTypeDefinition> definitions = [
    // === 资产类 (ASSET) ===

    // CASH: 实体货币、零钱
    AccountTypeDefinition(
      id: 'cash',
      apiType: FinancialAccountType.cash,
      nature: AccountNature.liquidAssets,
      title: '现金 (Cash)',
      subtitle: '手头的实体货币、零钱。',
      iconBuilder: _tablerIcon(tabler.Cash.new),
      accentColor: const Color(0xFF16A34A),
      requiresCustomName: false,
      keywords: ['现金', 'cash', 'wallet', '零钱'],
    ),

    // DEPOSIT: 银行存款（活期、定期、支票账户）
    AccountTypeDefinition(
      id: 'deposit',
      apiType: FinancialAccountType.deposit,
      nature: AccountNature.liquidAssets,
      title: '银行存款 (Deposit)',
      subtitle: '储蓄卡、活期、定期、支票账户等。',
      iconBuilder: _tablerIcon(tabler.BuildingBank.new),
      accentColor: const Color(0xFF2563EB),
      keywords: ['bank', '银行卡', '储蓄卡', '支票', '活期', '定期'],
    ),

    // E_MONEY: 电子货币账户、第三方支付平台余额
    AccountTypeDefinition(
      id: 'e_money',
      apiType: FinancialAccountType.eMoney,
      nature: AccountNature.liquidAssets,
      title: '电子钱包 (E-Money)',
      subtitle: '微信零钱、支付宝、PayPal等。',
      iconBuilder: _tablerIcon(tabler.Wallet.new),
      accentColor: const Color(0xFF7C3AED),
      keywords: ['digital', 'wallet', '支付宝', '微信', 'pay', 'e-wallet'],
    ),

    // INVESTMENT: 股票、基金、债券、理财产品
    AccountTypeDefinition(
      id: 'investment',
      apiType: FinancialAccountType.investment,
      nature: AccountNature.investmentAssets,
      title: '投资 (Investment)',
      subtitle: '股票、基金、债券、理财产品等。',
      iconBuilder: _tablerIcon(tabler.ChartLine.new),
      accentColor: const Color(0xFF0EA5E9),
      keywords: ['stocks', 'funds', '证券', '基金', '理财', '债券'],
    ),

    // RECEIVABLE: 应收款项（如借给朋友的钱）
    AccountTypeDefinition(
      id: 'receivable',
      apiType: FinancialAccountType.receivable,
      nature: AccountNature.receivablesPayables,
      title: '应收账款 (Receivable)',
      subtitle: '别人欠你的钱、借出去的钱。',
      helper: '别人欠我',
      iconBuilder: _tablerIcon(tabler.ArrowRightCircle.new),
      accentColor: const Color(0xFF10B981),
      keywords: ['receivable', '别人欠我', '借出去'],
    ),

    // === 负债类 (LIABILITY) ===

    // CREDIT_CARD: 信用卡账户（欠款）
    AccountTypeDefinition(
      id: 'credit_card',
      apiType: FinancialAccountType.creditCard,
      nature: AccountNature.creditAccounts,
      title: '信用卡 (Credit Card)',
      subtitle: '银行发行的信用卡欠款。',
      iconBuilder: _tablerIcon(tabler.CreditCard.new),
      accentColor: const Color(0xFFDB2777),
      keywords: ['信用卡', 'credit card'],
    ),

    // LOAN: 贷款、房贷、车贷
    AccountTypeDefinition(
      id: 'loan',
      apiType: FinancialAccountType.loan,
      nature: AccountNature.longTermLiabilities,
      title: '贷款 (Loan)',
      subtitle: '房贷、车贷、消费贷、学生贷款等。',
      iconBuilder: _tablerIcon(tabler.HomeDollar.new),
      accentColor: const Color(0xFFFB7185),
      keywords: ['mortgage', '房贷', '车贷', '消费贷', 'loan'],
    ),

    // PAYABLE: 应付款项（如花呗账单未出）
    AccountTypeDefinition(
      id: 'payable',
      apiType: FinancialAccountType.payable,
      nature: AccountNature.receivablesPayables,
      title: '应付账款 (Payable)',
      subtitle: '你欠别人的钱、花呗等未出账单。',
      helper: '我欠别人',
      iconBuilder: _tablerIcon(tabler.ArrowLeftCircle.new),
      accentColor: const Color(0xFFEF4444),
      keywords: ['payable', '我欠别人', '花呗', '短期借款'],
    ),
  ];

  static final Map<String, AccountTypeDefinition> _definitionsById = {
    for (final definition in definitions) definition.id: definition,
  };

  static final Map<FinancialAccountType, AccountTypeDefinition>
  _definitionsByApiType = {
    for (final definition in definitions) definition.apiType: definition,
  };

  /// 根据 UI id 查找定义
  static AccountTypeDefinition? resolve(String? id) {
    if (id == null) {
      return null;
    }
    return _definitionsById[id];
  }

  /// 根据后端 FinancialAccountType 查找定义
  static AccountTypeDefinition? resolveByApiType(FinancialAccountType? type) {
    if (type == null) {
      return null;
    }
    return _definitionsByApiType[type];
  }

  static List<AccountTypeDefinition> byNature(AccountNature nature) {
    return definitions
        .where((definition) => definition.nature == nature)
        .toList();
  }

  /// 根据后端的 FinancialNature 获取默认的账户类型定义
  /// 用于当无法找到对应定义时提供后备方案
  static AccountTypeDefinition getDefaultDefinition(FinancialNature nature) {
    if (nature == FinancialNature.liability) {
      // 负债账户默认使用 PAYABLE 类型
      return _definitionsByApiType[FinancialAccountType.payable] ??
          definitions.last;
    } else {
      // 资产账户默认使用 CASH 类型
      return _definitionsByApiType[FinancialAccountType.cash] ??
          definitions.first;
    }
  }
}
