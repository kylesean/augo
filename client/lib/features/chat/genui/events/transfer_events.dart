import 'package:genui/genui.dart';

/// Create transfer path confirmed event
///
/// When user confirms transfer path in TransferPathBuilder.
/// Event is intercepted by GenUiEventRegistry, generating ClientStateMutation,
/// then sent to backend by CustomContentGenerator.
/// [sourceAccountId] Source account ID
/// [targetAccountId] Target account ID
/// [sourceAccountName] Source account name
/// [targetAccountName] Target account name
/// [amount] Transfer amount
/// [currency] Currency, default CNY
UiEvent createTransferPathConfirmedEvent({
  required String sourceAccountId,
  required String targetAccountId,
  required String sourceAccountName,
  required String targetAccountName,
  required double amount,
  String currency = 'CNY',
}) {
  return UserActionEvent(
    name: 'transfer_path_confirmed',
    sourceComponentId: 'transfer_path_builder',
    context: {
      'source_account_id': sourceAccountId,
      'target_account_id': targetAccountId,
      'source_account_name': sourceAccountName,
      'target_account_name': targetAccountName,
      'amount': amount,
      'currency': currency,
    },
  );
}

/// Create transfer path cancelled event
///
/// When user cancels transfer path in TransferPathBuilder.
UiEvent createTransferPathCancelledEvent({String? reason}) {
  return UserActionEvent(
    name: 'transfer_path_cancelled',
    sourceComponentId: 'transfer_path_builder',
    context: {'cancelled': true, 'reason': reason ?? '用户取消操作'},
  );
}

/// Create send chat message event
///
/// Generic send message event, used for non-state mutation scenarios.
UiEvent createSendChatMessageEvent({required String message}) {
  return UserActionEvent(
    name: 'send_chat_message',
    sourceComponentId: 'genui_component',
    context: {'message': message},
  );
}
