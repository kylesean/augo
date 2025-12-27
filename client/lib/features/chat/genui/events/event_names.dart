/// GenUI event naming convention
///
/// Event naming format: {domain}_{action}_{modifier?}
///
/// Domain:
/// - transfer: transfer related
/// - transaction: transaction related
/// - account: account related
/// - filter: filter related
/// - search: search related
///
/// Action:
/// - confirmed: confirmed action
/// - selected: selected action
/// - submitted: submitted action
/// - cancelled: cancelled action
/// - updated: updated action
///
/// Modifier (optional):
/// - with_account: associated account
/// - partial: partial completion
abstract class GenUiEventNames {
  GenUiEventNames._();

  // ===== Transfer events =====

  /// Transfer path confirmed
  ///
  /// Context should contain:
  /// - source_account_id: String
  /// - target_account_id: String
  /// - source_account_name: String
  /// - target_account_name: String
  /// - amount: num
  /// - currency: String
  static const transferPathConfirmed = 'transfer_path_confirmed';

  // ===== Transaction events =====

  /// Transaction confirmed (no account association)
  ///
  /// Context should contain:
  /// - amount: num
  /// - description: String
  /// - transaction_type: 'EXPENSE' | 'INCOME'
  /// - category_key: String
  /// - currency: String
  /// - raw_input: String?
  /// - tags: `List<String>?`
  static const transactionConfirmed = 'transaction_confirmed';

  /// Transaction confirmed (associated account)
  ///
  /// Context should contain:
  /// - account_id: String
  /// - account_name: String
  static const transactionConfirmedWithAccount =
      'transaction_confirmed_with_account';

  // ===== Account events =====

  /// Account selected
  ///
  /// Context should contain:
  /// - account_id: String
  /// - account_name: String
  /// - account_type: String?
  static const accountSelected = 'account_selected';

  // ===== All registered event names =====

  /// Get all registered event names
  static List<String> get allEventNames => [
    transferPathConfirmed,
    transactionConfirmed,
    transactionConfirmedWithAccount,
    accountSelected,
  ];
}
