/// GenUI Event Registry
///
/// 事件注册表 —— 解耦 ContentGenerator 与业务逻辑。
///
/// 设计理念：
/// - ContentGenerator 不再需要知道具体的业务事件（如 transfer_path_confirmed）
/// - 业务模块在启动时注册自己的事件处理器
/// - Generator 只负责查表、获取 mutation、发送请求
///
/// 使用方式：
/// ```dart
/// // 在 app 启动时注册
/// GenUiEventRegistry.register(
///   GenUiEventNames.transferPathConfirmed,
///   (context) => ClientStateMutation.forTransfer(...),
/// );
///
/// // 在 Generator 中使用
/// final mutation = GenUiEventRegistry.dispatch(eventName, context);
/// if (mutation != null && !mutation.isEmpty) {
///   body['client_state'] = mutation.toJson();
/// }
/// ```
library;

import 'package:logging/logging.dart';
import '../models/client_state_mutation.dart';
import 'events/events.dart';

/// 事件处理器类型
///
/// 接收事件上下文，返回对应的 ClientStateMutation
typedef StateMutationHandler =
    ClientStateMutation? Function(Map<String, dynamic> context);

/// GenUI 事件注册表
///
/// 静态注册表，用于解耦 Generator 和业务逻辑。
class GenUiEventRegistry {
  GenUiEventRegistry._(); // 禁止实例化

  static final _logger = Logger('GenUiEventRegistry');
  static final Map<String, StateMutationHandler> _handlers = {};
  static final Map<String, int> _dispatchCounts = {};
  static bool _initialized = false;

  /// 注册事件处理器
  ///
  /// [eventName] 事件名称，建议使用 GenUiEventNames 常量
  /// [handler] 处理器函数，接收 context 返回 mutation
  /// [allowOverride] 是否允许覆盖已有处理器（默认 false）
  static void register(
    String eventName,
    StateMutationHandler handler, {
    bool allowOverride = false,
  }) {
    assert(eventName.isNotEmpty, 'Event name cannot be empty');

    if (_handlers.containsKey(eventName) && !allowOverride) {
      _logger.info(
        'GenUiEventRegistry: WARNING - Event "$eventName" already registered. Use allowOverride=true to override.',
      );
      return;
    }

    _handlers[eventName] = handler;
    _dispatchCounts[eventName] = 0;
    _logger.info('GenUiEventRegistry: Registered event "$eventName"');
  }

  /// 分发事件，获取对应的 ClientStateMutation
  ///
  /// 如果事件未注册，返回 null
  static ClientStateMutation? dispatch(
    String eventName,
    Map<String, dynamic> context,
  ) {
    final handler = _handlers[eventName];
    if (handler == null) {
      _logger.info('GenUiEventRegistry: No handler for event "$eventName"');
      return null;
    }

    // 记录分发次数
    _dispatchCounts[eventName] = (_dispatchCounts[eventName] ?? 0) + 1;

    return handler(context);
  }

  /// 检查事件是否已注册
  static bool hasHandler(String eventName) => _handlers.containsKey(eventName);

  /// 获取已注册的事件名称列表
  static List<String> get registeredEvents => _handlers.keys.toList();

  /// 获取事件分发统计
  static Map<String, int> get dispatchStats =>
      Map.unmodifiable(_dispatchCounts);

  /// 打印调试信息
  static void debugPrintStats() {
    _logger.info('=== GenUiEventRegistry Stats ===');
    _logger.info('Registered events: ${_handlers.keys.toList()}');
    _logger.info('Dispatch counts: $_dispatchCounts');
    _logger.info('================================');
  }

  /// 初始化注册表（注册所有业务事件）
  ///
  /// 应在 app 启动时调用一次
  static void initialize() {
    if (_initialized) return;
    _initialized = true;

    // 注册转账相关事件
    // 注意：只有参数完全确定、无需 AI 判断的场景才应该注册为 direct_execute
    // 交易确认（transaction_confirmed）走 agent 节点，让 AI 处理 tags 生成和账户语义
    _registerTransferEvents();

    // 注册共享空间相关事件
    _registerSpaceEvents();

    // 未来可扩展：
    // _registerFilterEvents();
    // _registerSearchEvents();
  }

  /// 注册转账相关事件
  static void _registerTransferEvents() {
    register(GenUiEventNames.transferPathConfirmed, (context) {
      final sourceAccountId = context['source_account_id'] as String?;
      final targetAccountId = context['target_account_id'] as String?;
      final sourceAccountName =
          context['source_account_name'] as String? ?? '转出账户';
      final targetAccountName =
          context['target_account_name'] as String? ?? '转入账户';

      // 安全解析 amount
      double amount = 0.0;
      final rawAmount = context['amount'];
      if (rawAmount is num) {
        amount = rawAmount.toDouble();
      } else if (rawAmount is String) {
        amount = double.tryParse(rawAmount) ?? 0.0;
      }

      final currency = context['currency'] as String? ?? 'CNY';

      _logger.info('transfer_path_confirmed: $amount $currency');

      return ClientStateMutation.forTransfer(
        surfaceId: context['surface_id'] as String?,
        sourceAccountId: sourceAccountId ?? '',
        targetAccountId: targetAccountId ?? '',
        sourceAccountName: sourceAccountName,
        targetAccountName: targetAccountName,
        amount: amount,
        currency: currency,
      );
    });
  }

  /// 注册共享空间相关事件
  static void _registerSpaceEvents() {
    register(SpaceEventNames.spaceSelected, (context) {
      final spaceId = context['space_id'] as int?;
      final transactionIds = context['transaction_ids'] as List<dynamic>?;
      final surfaceId = context['surface_id'] as String?;

      _logger.info(
        'space_selected: spaceId=$spaceId, txCount=${transactionIds?.length}',
      );

      return ClientStateMutation.forSpaceAssociation(
        surfaceId: surfaceId,
        spaceId: spaceId ?? 0,
        transactionIds: transactionIds?.cast<String>() ?? [],
      );
    });
  }

  /// 重置注册表（仅用于测试）
  static void reset() {
    _handlers.clear();
    _dispatchCounts.clear();
    _initialized = false;
    _logger.info('GenUiEventRegistry: Reset complete');
  }
}
