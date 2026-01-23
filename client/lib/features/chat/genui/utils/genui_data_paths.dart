/// GenUI DataPath Constants
///
/// 集中管理所有业务相关的 DataPath 字符串，避免在多个组件中硬编码导致的拼写错误。
class GenUiDataPaths {
  GenUiDataPaths._();

  // 通用字段
  static const String amount = '/amount';
  static const String currency = '/currency';
  static const String memo = '/memo';
  static const String surfaceId = '/_surfaceId';

  // 账户相关
  static const String preselectedSourceId = '/preselectedSourceId';
  static const String preselectedTargetId = '/preselectedTargetId';
  static const String sourceBalance = '/source_balance';
  static const String targetBalance = '/target_balance';

  // 警告与错误
  static const String balanceWarning = '/balance_warning';
  static const String amountError = '/amount_error';
  static const String generalError = '/_error';
}
