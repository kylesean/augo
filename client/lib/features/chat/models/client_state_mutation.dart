/// Client State Mutation Models
///
/// Corresponding Dart models for backend `app/schemas/client_state.py`.
/// Defines the subset of state operations allowed by the client for GenUI atomic mode.
library;

/// Client state mutation
///
/// GenUI 原子模式协议：
/// - Client 在消息请求中附带 state mutation
/// - Server 在图执行前原子性地应用 mutation
class ClientStateMutation {
  /// UI mode: Controls graph entry routing
  /// - 'idle': Goes through agent node
  /// - 'direct_execute': Skips LLM, executes tool_name directly
  final String? uiMode;

  /// Tool name to execute directly (must be registered in INTERNAL_TOOLS)
  final String? toolName;

  /// Tool parameters
  final Map<String, dynamic>? toolParams;

  const ClientStateMutation({this.uiMode, this.toolName, this.toolParams});

  /// Quick creation for transfer execution
  factory ClientStateMutation.forTransfer({
    String? surfaceId,
    required String sourceAccountId,
    required String targetAccountId,
    required String sourceAccountName,
    required String targetAccountName,
    required double amount,
    String currency = 'CNY',
  }) {
    return ClientStateMutation(
      uiMode: 'direct_execute',
      toolName: 'execute_transfer',
      toolParams: {
        'surface_id': surfaceId,
        'source_account_id': sourceAccountId,
        'target_account_id': targetAccountId,
        'source_account_name': sourceAccountName,
        'target_account_name': targetAccountName,
        'amount': amount,
        'currency': currency,
      },
    );
  }

  /// Quick creation for space association (direct_execute)
  factory ClientStateMutation.forSpaceAssociation({
    String? surfaceId,
    required int spaceId,
    required List<String> transactionIds,
  }) {
    return ClientStateMutation(
      uiMode: 'direct_execute',
      toolName: 'associate_transactions_to_space',
      toolParams: {
        'surface_id': surfaceId,
        'space_id': spaceId,
        'transaction_ids': transactionIds,
      },
    );
  }

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};
    if (uiMode != null) {
      result['ui_mode'] = uiMode;
    }
    if (toolName != null) {
      result['tool_name'] = toolName;
    }
    if (toolParams != null) {
      result['tool_params'] = toolParams;
    }
    return result;
  }

  bool get isEmpty => uiMode == null && toolName == null;
}
