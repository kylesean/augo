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

/// 事件处理器结果
///
/// 包含业务变更 (ClientStateMutation) 和 可选的发送给 LLM 的 Payload 增强数据
class EventProcessingResult {
  final ClientStateMutation? mutation;
  final Map<String, dynamic>? payloadExtensions;

  const EventProcessingResult({this.mutation, this.payloadExtensions});

  bool get isEmpty => mutation == null && payloadExtensions == null;
}

/// 事件处理器类型
///
/// 接收事件上下文，返回结果
typedef StateMutationHandler =
    EventProcessingResult? Function(Map<String, dynamic> context);

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
  static void register(
    String eventName,
    StateMutationHandler handler, {
    bool allowOverride = false,
  }) {
    assert(eventName.isNotEmpty, 'Event name cannot be empty');

    if (_handlers.containsKey(eventName) && !allowOverride) {
      _logger.info(
        'GenUiEventRegistry: WARNING - Event "$eventName" already registered.',
      );
      return;
    }

    _handlers[eventName] = handler;
    _dispatchCounts[eventName] = 0;
    _logger.info('GenUiEventRegistry: Registered event "$eventName"');
  }

  /// 分发事件
  static EventProcessingResult? dispatch(
    String eventName,
    Map<String, dynamic> context,
  ) {
    final handler = _handlers[eventName];
    if (handler == null) {
      _logger.info('GenUiEventRegistry: No handler for event "$eventName"');
      return null;
    }

    _dispatchCounts[eventName] = (_dispatchCounts[eventName] ?? 0) + 1;
    return handler(context);
  }

  /// 初始化注册表
  static void initialize() {
    if (_initialized) return;
    _initialized = true;

    _registerTransferEvents();
    _registerSpaceEvents();
    _registerAccountEvents();
  }

  /// 注册账户相关事件
  static void _registerAccountEvents() {
    register(GenUiEventNames.accountSelected, (context) {
      final selectedAccountId = context['selected_account_id'] as String?;
      final selectionType = context['selection_type'] as String?;

      return EventProcessingResult(
        payloadExtensions: {
          'role': 'user',
          'content': '我选择了账户 ID: $selectedAccountId ($selectionType)',
          'metadata': {
            'event_type': GenUiEventNames.accountSelected,
            ...context,
          },
        },
      );
    });
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

      double amount = 0.0;
      final rawAmount = context['amount'];
      if (rawAmount is num) {
        amount = rawAmount.toDouble();
      } else if (rawAmount is String) {
        amount = double.tryParse(rawAmount) ?? 0.0;
      }

      final currency = context['currency'] as String? ?? 'CNY';

      return EventProcessingResult(
        mutation: ClientStateMutation.forTransfer(
          surfaceId: context['surface_id'] as String?,
          sourceAccountId: sourceAccountId ?? '',
          targetAccountId: targetAccountId ?? '',
          sourceAccountName: sourceAccountName,
          targetAccountName: targetAccountName,
          amount: amount,
          currency: currency,
        ),
        payloadExtensions: {
          'role': 'user',
          'content': '按照我的选择执行转账',
          'metadata': {
            'event_type': GenUiEventNames.transferPathConfirmed,
            ...context,
          },
        },
      );
    });
  }

  /// 注册共享空间相关事件
  static void _registerSpaceEvents() {
    register(SpaceEventNames.spaceSelected, (context) {
      final spaceId = context['space_id'] as int?;
      final transactionIds = context['transaction_ids'] as List<dynamic>?;

      return EventProcessingResult(
        mutation: ClientStateMutation.forSpaceAssociation(
          surfaceId: context['surface_id'] as String?,
          spaceId: spaceId ?? 0,
          transactionIds: transactionIds?.cast<String>() ?? [],
        ),
        payloadExtensions: {
          'role': 'user',
          'content': '关联选定的空间',
          'metadata': {'event_type': SpaceEventNames.spaceSelected, ...context},
        },
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
