// ignore_for_file: deprecated_member_use_from_same_package
import 'package:flutter/material.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';
import '../services/genui_logger.dart';
import 'templates/templates.dart';

/// 应用特定的组件目录
///
/// 此类定义了聊天应用中可用的自定义 GenUI 组件。
/// 包括交易卡片、数据表格、图表卡片和摘要卡片。
class AppCatalog {
  /// 构建完整的组件目录
  ///
  /// 从核心组件开始，然后添加应用特定的自定义组件。
  static Catalog build() {
    // 从核心组件开始
    final catalog = CoreCatalogItems.asCatalog();

    // 添加自定义组件
    return catalog.copyWith([
      _buildTransactionCard(),
      _buildTransferReceipt(),
      _buildExpenseTable(),
      _buildChartCard(),
      _buildSummaryCard(),
      _buildTransferWizard(),
      _buildBudgetStatusCard(),
      _buildBudgetReceipt(),
      _buildBudgetAnalysisCard(),
      _buildTransactionGroupReceipt(),
      _buildTransactionList(),
      _buildCashFlowCard(),
      _buildHealthScoreCard(),
      _buildCashFlowForecastChart(),
      _buildExpenseSummaryCard(),
      _buildSpaceSelectorCard(),
      _buildSpaceAssociationReceipt(),
    ]);
  }

  /// 交易卡片组件
  ///
  /// 用于显示交易收据信息，包括状态、金额、详情等。
  static CatalogItem _buildTransactionCard() {
    return CatalogItem(
      name: 'TransactionReceipt',
      dataSchema: ObjectSchema(
        properties: {
          // 后端返回的字段
          'success': BooleanSchema(description: '操作是否成功'),
          'transaction_id': IntegerSchema(description: '交易唯一标识符'),
          'raw_input': StringSchema(description: '交易描述'),
          'amount': NumberSchema(description: '交易金额'),
          'type': BooleanSchema(description: '交易类型'),
          'transaction_at': StringSchema(description: '交易时间（ISO 8601格式）'),
          'message': StringSchema(description: '操作结果消息'),

          // 可选字段（兼容旧格式）
          'transactionId': StringSchema(description: '交易唯一标识符（旧格式）'),
          'status': StringSchema(
            description: '交易状态',
            enumValues: ['completed', 'pending', 'failed', 'cancelled'],
          ),
          'title': StringSchema(description: '交易标题或描述（旧格式）'),
          'currency': StringSchema(description: '货币类型代码（如 CNY, USD）'),
          'amountColor': StringSchema(description: '金额显示颜色（如 red, green）'),
          'category': StringSchema(description: '交易类别'),
          'timestamp': StringSchema(description: '交易时间戳（旧格式）'),
          'details': ListSchema(
            description: '交易详细信息列表',
            items: ObjectSchema(
              properties: {
                'label': StringSchema(description: '详情标签'),
                'value': StringSchema(description: '详情值'),
              },
              required: ['label', 'value'],
            ),
          ),
          'tags': ListSchema(description: '交易标签列表', items: StringSchema()),
        },
        required: [
          // 只要求后端实际返回的必需字段
          // raw_input 和 type 可能为空，不作为必需字段
          'transaction_id',
          'amount',
        ],
      ),
      widgetBuilder: _buildTransactionCardWidget,
    );
  }

  /// 转账收据组件
  ///
  /// 专用于显示转账交易结果，与普通交易卡片分离。
  /// 显示双账户（转出 → 转入）的布局。
  static CatalogItem _buildTransferReceipt() {
    return CatalogItem(
      name: 'TransferReceipt',
      dataSchema: ObjectSchema(
        properties: {
          'success': BooleanSchema(description: '操作是否成功'),
          'transaction_id': StringSchema(description: '交易唯一标识符'),
          'amount': NumberSchema(description: '转账金额'),
          'currency': StringSchema(description: '货币代码'),
          'type': StringSchema(description: '交易类型（应为 TRANSFER）'),
          'transaction_at': StringSchema(description: '交易时间（ISO 8601格式）'),
          'category_key': StringSchema(description: '交易分类'),
          'tags': ListSchema(description: '交易标签', items: StringSchema()),
          'transfer_info': ObjectSchema(
            description: '转账详情',
            properties: {
              'source_account': ObjectSchema(
                properties: {
                  'id': StringSchema(description: '转出账户ID'),
                  'name': StringSchema(description: '转出账户名称'),
                  'type': StringSchema(description: '账户类型'),
                  'new_balance': StringSchema(description: '转账后余额'),
                },
                required: ['id', 'name'],
              ),
              'target_account': ObjectSchema(
                properties: {
                  'id': StringSchema(description: '转入账户ID'),
                  'name': StringSchema(description: '转入账户名称'),
                  'type': StringSchema(description: '账户类型'),
                  'new_balance': StringSchema(description: '转账后余额'),
                },
                required: ['id', 'name'],
              ),
            },
            required: ['source_account', 'target_account'],
          ),
        },
        required: ['transaction_id', 'amount', 'transfer_info'],
      ),
      widgetBuilder: _buildTransferReceiptWidget,
    );
  }

  /// 数据表格组件
  ///
  /// 用于显示结构化的表格数据，支持分页。
  static CatalogItem _buildExpenseTable() {
    return CatalogItem(
      name: 'DataTable',
      dataSchema: ObjectSchema(
        properties: {
          'title': StringSchema(description: '表格标题'),
          'headers': ListSchema(description: '表头列表', items: StringSchema()),
          'rows': ListSchema(
            description: '表格行数据',
            items: ListSchema(items: StringSchema()),
          ),
          'styling': ObjectSchema(
            description: '表格样式配置',
            properties: {
              'headerColor': StringSchema(description: '表头背景色'),
              'rowColor': StringSchema(description: '行背景色'),
              'borderColor': StringSchema(description: '边框颜色'),
            },
          ),
          'pagination': ObjectSchema(
            description: '分页信息',
            properties: {
              'currentPage': IntegerSchema(description: '当前页码'),
              'totalPages': IntegerSchema(description: '总页数'),
              'totalItems': IntegerSchema(description: '总条目数'),
              'itemsPerPage': IntegerSchema(description: '每页条目数'),
              'hasNextPage': BooleanSchema(description: '是否有下一页'),
              'hasPreviousPage': BooleanSchema(description: '是否有上一页'),
            },
            required: [
              'currentPage',
              'totalPages',
              'totalItems',
              'itemsPerPage',
            ],
          ),
        },
        required: ['title', 'headers', 'rows'],
      ),
      widgetBuilder: _buildExpenseTableWidget,
    );
  }

  /// 图表卡片组件
  ///
  /// 用于显示各种类型的图表（饼图、柱状图、折线图等）。
  static CatalogItem _buildChartCard() {
    return CatalogItem(
      name: 'ChartCard',
      dataSchema: ObjectSchema(
        properties: {
          'title': StringSchema(description: '图表标题'),
          'chartType': StringSchema(
            description: '图表类型',
            enumValues: ['pie', 'bar', 'line', 'radar', 'area'],
          ),
          'chartData': ObjectSchema(
            description: '图表数据',
            properties: {
              'labels': ListSchema(description: '数据标签', items: StringSchema()),
              'datasets': ListSchema(
                description: '数据集',
                items: ObjectSchema(
                  properties: {
                    'label': StringSchema(description: '数据集标签'),
                    'data': ListSchema(
                      description: '数据值',
                      items: NumberSchema(),
                    ),
                    'backgroundColor': StringSchema(description: '背景色'),
                    'borderColor': StringSchema(description: '边框色'),
                  },
                  required: ['label', 'data'],
                ),
              ),
            },
            required: ['labels', 'datasets'],
          ),
          'chartOptions': ObjectSchema(
            description: '图表配置选项',
            properties: {
              'showLegend': BooleanSchema(description: '是否显示图例'),
              'showGrid': BooleanSchema(description: '是否显示网格'),
              'animationDuration': IntegerSchema(description: '动画时长（毫秒）'),
            },
          ),
        },
        required: ['title', 'chartType', 'chartData'],
      ),
      widgetBuilder: _buildChartCardWidget,
    );
  }

  /// 摘要卡片组件
  ///
  /// 用于显示摘要信息和关键指标。
  static CatalogItem _buildSummaryCard() {
    return CatalogItem(
      name: 'SummaryCard',
      dataSchema: ObjectSchema(
        properties: {
          'title': StringSchema(description: '摘要标题'),
          'summary': StringSchema(description: '摘要文本内容'),
          'items': ListSchema(
            description: '摘要项目列表',
            items: ObjectSchema(
              properties: {
                'label': StringSchema(description: '项目标签'),
                'value': StringSchema(description: '项目值'),
                'color': StringSchema(description: '显示颜色'),
                'icon': StringSchema(description: '图标名称'),
              },
              required: ['label', 'value'],
            ),
          ),
          'styling': ObjectSchema(
            description: '样式配置',
            properties: {
              'backgroundColor': StringSchema(description: '背景色'),
              'textColor': StringSchema(description: '文本颜色'),
              'borderRadius': NumberSchema(description: '圆角半径'),
            },
          ),
        },
        required: ['title', 'summary', 'items'],
      ),
      widgetBuilder: _buildSummaryCardWidget,
    );
  }

  /// 转账向导组件
  static CatalogItem _buildTransferWizard() {
    return CatalogItem(
      name: 'TransferWizard',
      dataSchema: ObjectSchema(
        properties: {
          'amount': NumberSchema(description: '转账金额'),
          'currency': StringSchema(description: '货币代码'),
          'sourceAccounts': ListSchema(
            description: '可选转出账户列表',
            items: ObjectSchema(
              properties: {
                'id': StringSchema(description: '账户ID'),
                'name': StringSchema(description: '账户名称'),
                'type': StringSchema(description: '账户类型'),
                'balance': NumberSchema(description: '账户余额'),
                'currency': StringSchema(description: '货币代码'),
                'subtitle': StringSchema(description: '账户副标题'),
              },
              required: ['id', 'name', 'type'],
            ),
          ),
          'targetAccounts': ListSchema(
            description: '可选转入账户列表',
            items: ObjectSchema(
              properties: {
                'id': StringSchema(description: '账户ID'),
                'name': StringSchema(description: '账户名称'),
                'type': StringSchema(description: '账户类型'),
                'balance': NumberSchema(description: '账户余额'),
                'currency': StringSchema(description: '货币代码'),
                'subtitle': StringSchema(description: '账户副标题'),
              },
              required: ['id', 'name', 'type'],
            ),
          ),
          'preselectedSourceId': StringSchema(description: '预选的转出账户ID'),
          'preselectedTargetId': StringSchema(description: '预选的转入账户ID'),
        },
        required: ['sourceAccounts', 'targetAccounts'],
      ),
      widgetBuilder: _buildTransferWizardWidget,
    );
  }

  /// 构建交易卡片 Widget
  static Widget _buildTransactionCardWidget(CatalogItemContext context) {
    final startTime = DateTime.now();
    const componentName = 'TransactionReceipt';

    try {
      final data = context.data as Map<String, dynamic>;

      // 验证必需字段（只检查真正必需的字段）
      // transaction_id 和 amount 是必需的
      // raw_input/description 可以为空，会使用默认值
      final hasTransactionId =
          data.containsKey('transaction_id') && data['transaction_id'] != null;
      final hasAmount = data.containsKey('amount') && data['amount'] != null;

      if (!hasTransactionId || !hasAmount) {
        final duration = DateTime.now().difference(startTime).inMilliseconds;
        GenUiLogger.logBuilderInvocation(
          componentName: componentName,
          success: false,
          durationMs: duration,
        );
        GenUiLogger.logError(
          message: 'TransactionReceipt missing required fields',
          schema: data,
        );
        return _buildErrorWidget(context.buildContext, '交易记录加载失败，请重试');
      }

      // Use standard TransactionCard (no reactive binding needed for one-shot receipts)
      final widget = TransactionCard(data: data);
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      GenUiLogger.logBuilderInvocation(
        componentName: componentName,
        success: true,
        durationMs: duration,
      );
      return widget;
    } catch (e, stackTrace) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      GenUiLogger.logBuilderInvocation(
        componentName: componentName,
        success: false,
        durationMs: duration,
      );
      GenUiLogger.logError(
        message: 'Builder failed for $componentName',
        error: e,
        stackTrace: stackTrace,
      );
      return _buildErrorWidget(context.buildContext, '渲染失败: $e');
    }
  }

  /// 构建转账收据 Widget
  static Widget _buildTransferReceiptWidget(CatalogItemContext context) {
    final startTime = DateTime.now();
    const componentName = 'TransferReceipt';

    try {
      final data = context.data as Map<String, dynamic>;

      // 验证必需字段
      final hasTransactionId =
          data.containsKey('transaction_id') && data['transaction_id'] != null;
      final hasAmount = data.containsKey('amount') && data['amount'] != null;
      final hasTransferInfo =
          data.containsKey('transfer_info') && data['transfer_info'] != null;

      if (!hasTransactionId || !hasAmount || !hasTransferInfo) {
        final duration = DateTime.now().difference(startTime).inMilliseconds;
        GenUiLogger.logBuilderInvocation(
          componentName: componentName,
          success: false,
          durationMs: duration,
        );
        GenUiLogger.logError(
          message: 'TransferReceipt missing required fields',
          schema: data,
        );
        return _buildErrorWidget(context.buildContext, '转账记录加载失败，请重试');
      }

      final widget = TransferReceipt(data: data);
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      GenUiLogger.logBuilderInvocation(
        componentName: componentName,
        success: true,
        durationMs: duration,
      );
      return widget;
    } catch (e, stackTrace) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      GenUiLogger.logBuilderInvocation(
        componentName: componentName,
        success: false,
        durationMs: duration,
      );
      GenUiLogger.logError(
        message: 'Builder failed for $componentName',
        error: e,
        stackTrace: stackTrace,
      );
      return _buildErrorWidget(context.buildContext, '渲染失败: $e');
    }
  }

  /// 构建数据表格 Widget
  static Widget _buildExpenseTableWidget(CatalogItemContext context) {
    final startTime = DateTime.now();
    const componentName = 'DataTable';

    try {
      final data = context.data as Map<String, dynamic>;

      // 验证必需字段
      if (!_validateRequiredFields(data, ['title', 'headers', 'rows'])) {
        final duration = DateTime.now().difference(startTime).inMilliseconds;
        GenUiLogger.logBuilderInvocation(
          componentName: componentName,
          success: false,
          durationMs: duration,
        );
        return _buildErrorWidget(context.buildContext, '缺少必需字段');
      }

      final widget = ExpenseTable(data: data);
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      GenUiLogger.logBuilderInvocation(
        componentName: componentName,
        success: true,
        durationMs: duration,
      );
      return widget;
    } catch (e, stackTrace) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      GenUiLogger.logBuilderInvocation(
        componentName: componentName,
        success: false,
        durationMs: duration,
      );
      GenUiLogger.logError(
        message: 'Builder failed for $componentName',
        error: e,
        stackTrace: stackTrace,
      );
      return _buildErrorWidget(context.buildContext, '渲染失败: $e');
    }
  }

  /// 构建图表卡片 Widget
  static Widget _buildChartCardWidget(CatalogItemContext context) {
    final startTime = DateTime.now();
    const componentName = 'ChartCard';

    try {
      final data = context.data as Map<String, dynamic>;

      // 验证必需字段
      if (!_validateRequiredFields(data, ['title', 'chartType', 'chartData'])) {
        final duration = DateTime.now().difference(startTime).inMilliseconds;
        GenUiLogger.logBuilderInvocation(
          componentName: componentName,
          success: false,
          durationMs: duration,
        );
        return _buildErrorWidget(context.buildContext, '缺少必需字段');
      }

      final widget = ChartCard(data: data);
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      GenUiLogger.logBuilderInvocation(
        componentName: componentName,
        success: true,
        durationMs: duration,
      );
      return widget;
    } catch (e, stackTrace) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      GenUiLogger.logBuilderInvocation(
        componentName: componentName,
        success: false,
        durationMs: duration,
      );
      GenUiLogger.logError(
        message: 'Builder failed for $componentName',
        error: e,
        stackTrace: stackTrace,
      );
      return _buildErrorWidget(context.buildContext, '渲染失败: $e');
    }
  }

  /// 构建摘要卡片 Widget
  static Widget _buildSummaryCardWidget(CatalogItemContext context) {
    final startTime = DateTime.now();
    const componentName = 'SummaryCard';

    try {
      final data = context.data as Map<String, dynamic>;

      // 验证必需字段
      if (!_validateRequiredFields(data, ['title', 'summary', 'items'])) {
        final duration = DateTime.now().difference(startTime).inMilliseconds;
        GenUiLogger.logBuilderInvocation(
          componentName: componentName,
          success: false,
          durationMs: duration,
        );
        return _buildErrorWidget(context.buildContext, '缺少必需字段');
      }

      final widget = SummaryCard(data: data);
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      GenUiLogger.logBuilderInvocation(
        componentName: componentName,
        success: true,
        durationMs: duration,
      );
      return widget;
    } catch (e, stackTrace) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      GenUiLogger.logBuilderInvocation(
        componentName: componentName,
        success: false,
        durationMs: duration,
      );
      GenUiLogger.logError(
        message: 'Builder failed for $componentName',
        error: e,
        stackTrace: stackTrace,
      );
      return _buildErrorWidget(context.buildContext, '渲染失败: $e');
    }
  }

  /// 构建转账向导 Widget
  static Widget _buildTransferWizardWidget(CatalogItemContext context) {
    final startTime = DateTime.now();
    const componentName = 'TransferWizard';

    try {
      final data = context.data as Map<String, dynamic>;

      // 验证必需字段
      if (!_validateRequiredFields(data, [
        'sourceAccounts',
        'targetAccounts',
      ])) {
        final duration = DateTime.now().difference(startTime).inMilliseconds;
        GenUiLogger.logBuilderInvocation(
          componentName: componentName,
          success: false,
          durationMs: duration,
        );
        return _buildErrorWidget(context.buildContext, '转账向导加载失败，请重试');
      }
      // Use ReactiveTransferWizard for DataContext reactive updates
      final widget = ReactiveTransferWizard(catalogContext: context);
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      GenUiLogger.logBuilderInvocation(
        componentName: componentName,
        success: true,
        durationMs: duration,
      );
      return widget;
    } catch (e, stackTrace) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      GenUiLogger.logBuilderInvocation(
        componentName: componentName,
        success: false,
        durationMs: duration,
      );
      GenUiLogger.logError(
        message: 'Builder failed for $componentName',
        error: e,
        stackTrace: stackTrace,
      );
      return _buildErrorWidget(context.buildContext, '转账向导渲染失败: $e');
    }
  }

  /// 验证必需字段
  static bool _validateRequiredFields(
    Map<String, dynamic> data,
    List<String> requiredFields,
  ) {
    for (final field in requiredFields) {
      if (!data.containsKey(field) || data[field] == null) {
        return false;
      }
    }
    return true;
  }

  /// 构建错误 Widget
  static Widget _buildErrorWidget(BuildContext context, String message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '组件加载失败: $message',
              style: TextStyle(color: Colors.red.shade900),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 预算相关组件
  // ═══════════════════════════════════════════════════════════════════════════

  /// 预算状态卡片组件
  static CatalogItem _buildBudgetStatusCard() {
    return CatalogItem(
      name: 'BudgetStatusCard',
      dataSchema: ObjectSchema(
        properties: {
          'success': BooleanSchema(description: '操作是否成功'),
          'has_budget': BooleanSchema(description: '是否有预算'),
          'message': StringSchema(description: '消息'),
          // 单个预算查询
          'budget': ObjectSchema(
            description: '单个预算信息',
            properties: {
              'id': StringSchema(description: '预算ID'),
              'name': StringSchema(description: '预算名称'),
              'category_key': StringSchema(description: '分类键'),
              'amount': NumberSchema(description: '预算金额'),
              'spent': NumberSchema(description: '已用金额'),
              'remaining': NumberSchema(description: '剩余金额'),
              'percentage': NumberSchema(description: '使用百分比'),
              'status': StringSchema(description: '状态'),
              'period_start': StringSchema(description: '周期开始'),
              'period_end': StringSchema(description: '周期结束'),
            },
          ),
          // 预算摘要
          'overall_spent': NumberSchema(description: '总已用金额'),
          'overall_remaining': NumberSchema(description: '总剩余金额'),
          'overall_percentage': NumberSchema(description: '总使用百分比'),
          'budgets': ListSchema(
            description: '预算列表',
            items: ObjectSchema(
              properties: {
                'id': StringSchema(description: '预算ID'),
                'name': StringSchema(description: '预算名称'),
                'scope': StringSchema(description: '范围'),
                'category_key': StringSchema(description: '分类键'),
                'amount': NumberSchema(description: '预算金额'),
                'spent': NumberSchema(description: '已用金额'),
                'remaining': NumberSchema(description: '剩余金额'),
                'percentage': NumberSchema(description: '使用百分比'),
                'status': StringSchema(description: '状态'),
              },
            ),
          ),
          'alerts': ListSchema(
            description: '警告列表',
            items: ObjectSchema(
              properties: {
                'budget_name': StringSchema(description: '预算名称'),
                'alert_type': StringSchema(description: '警告类型'),
                'message': StringSchema(description: '警告消息'),
              },
            ),
          ),
          'period_start': StringSchema(description: '周期开始'),
          'period_end': StringSchema(description: '周期结束'),
        },
        required: ['success'],
      ),
      widgetBuilder: _buildBudgetStatusCardWidget,
    );
  }

  /// 交易列表组件
  static CatalogItem _buildTransactionList() {
    return CatalogItem(
      name: 'TransactionList',
      dataSchema: ObjectSchema(
        properties: {
          'items': ListSchema(
            description: '交易记录列表',
            items: ObjectSchema(
              properties: {
                'id': StringSchema(description: '交易ID'),
                'amount': NumberSchema(description: '金额'),
                'currency': StringSchema(description: '货币'),
                'description': StringSchema(description: '描述'),
                'category': StringSchema(description: '分类'),
                'type': StringSchema(description: '类型'),
                'transaction_time': StringSchema(description: '时间'),
                'tags': ListSchema(items: StringSchema()),
              },
            ),
          ),
          'total': IntegerSchema(description: '总条数'),
          'page': IntegerSchema(description: '当前页'),
          'has_more': BooleanSchema(description: '是否有更多'),
        },
        required: ['items'],
      ),
      widgetBuilder: _buildTransactionListWidget,
    );
  }

  /// 预算创建收据组件
  static CatalogItem _buildBudgetReceipt() {
    return CatalogItem(
      name: 'BudgetReceipt',
      dataSchema: ObjectSchema(
        properties: {
          'success': BooleanSchema(description: '操作是否成功'),
          'budget_id': StringSchema(description: '预算ID'),
          'name': StringSchema(description: '预算名称'),
          'scope': StringSchema(description: '范围: TOTAL 或 CATEGORY'),
          'category_key': StringSchema(description: '分类键'),
          'amount': NumberSchema(description: '预算金额'),
          'period_start': StringSchema(description: '周期开始日期'),
          'period_end': StringSchema(description: '周期结束日期'),
          'rollover_enabled': BooleanSchema(description: '是否启用滚动预算'),
          'status': StringSchema(description: '状态'),
          'message': StringSchema(description: '消息'),
        },
        required: ['success'],
      ),
      widgetBuilder: _buildBudgetReceiptWidget,
    );
  }

  /// 预算分析卡片组件（Skills 专用）
  static CatalogItem _buildBudgetAnalysisCard() {
    return CatalogItem(
      name: 'BudgetAnalysisCard',
      dataSchema: ObjectSchema(
        properties: {
          'success': BooleanSchema(description: '操作是否成功'),
          'total_expense': NumberSchema(description: '总支出金额'),
          'period_days': IntegerSchema(description: '分析周期天数'),
          'transaction_count': IntegerSchema(description: '交易笔数'),
          'by_category': ObjectSchema(description: '分类统计', properties: {}),
          'trends': ObjectSchema(
            description: '趋势信息',
            properties: {
              'month_over_month': ObjectSchema(
                properties: {
                  'change_amount': NumberSchema(description: '变化金额'),
                  'change_percent': NumberSchema(description: '变化百分比'),
                  'direction': StringSchema(description: '趋势方向: up/down/flat'),
                },
              ),
            },
          ),
          'top_spenders': ListSchema(
            description: '大额支出列表',
            items: ObjectSchema(
              properties: {
                'amount': NumberSchema(description: '金额'),
                'category': StringSchema(description: '分类'),
                'description': StringSchema(description: '描述'),
                'date': StringSchema(description: '日期'),
              },
            ),
          ),
          'suggestions': ListSchema(description: '建议列表', items: StringSchema()),
          'ai_insight': StringSchema(description: 'AI 洞察文本'),
        },
        required: ['success'],
      ),
      widgetBuilder: _buildBudgetAnalysisCardWidget,
    );
  }

  /// 批量交易收据组件
  static CatalogItem _buildTransactionGroupReceipt() {
    return CatalogItem(
      name: 'TransactionGroupReceipt',
      dataSchema: ObjectSchema(
        properties: {
          'success': BooleanSchema(description: '操作是否成功'),
          'count': IntegerSchema(description: '交易笔数'),
          'transactions': ListSchema(
            description: '交易列表',
            items: ObjectSchema(
              properties: {
                'id': StringSchema(description: '交易ID'),
                'amount': StringSchema(description: '交易金额'),
                'tags': ListSchema(items: StringSchema()),
                'category_key': StringSchema(description: '分类键'),
              },
              required: ['id', 'amount'],
            ),
          ),
          'account_id': StringSchema(description: '已关联的账户ID'),
        },
        required: ['success', 'transactions'],
      ),
      widgetBuilder: _buildTransactionGroupReceiptWidget,
    );
  }

  /// 现金流分析卡片组件
  static CatalogItem _buildCashFlowCard() {
    return CatalogItem(
      name: 'CashFlowCard',
      dataSchema: ObjectSchema(
        properties: {
          'total_income': StringSchema(description: '总收入'),
          'total_expense': StringSchema(description: '总支出'),
          'net_cash_flow': StringSchema(description: '净现金流'),
          'savings_rate': NumberSchema(description: '储蓄率'),
          'expense_to_income_ratio': NumberSchema(description: '支出收入比'),
          'essential_expense_ratio': NumberSchema(description: '必要支出占比'),
          'discretionary_expense_ratio': NumberSchema(description: '可选消费占比'),
          'income_change_percent': NumberSchema(description: '收入环比变化'),
          'expense_change_percent': NumberSchema(description: '支出环比变化'),
          'savings_rate_change': NumberSchema(description: '储蓄率变化'),
          'period_start': StringSchema(description: '统计周期开始时间'),
          'period_end': StringSchema(description: '统计周期结束时间'),
        },
        required: ['net_cash_flow', 'savings_rate'],
      ),
      widgetBuilder: _buildCashFlowCardWidget,
    );
  }

  /// 财务健康评分卡片组件
  static CatalogItem _buildHealthScoreCard() {
    return CatalogItem(
      name: 'HealthScoreCard',
      dataSchema: ObjectSchema(
        properties: {
          'total_score': IntegerSchema(description: '总分 (0-100)'),
          'grade': StringSchema(description: '等级 (A/B/C/D/F)'),
          'dimensions': ListSchema(
            description: '各维度评分',
            items: ObjectSchema(
              properties: {
                'name': StringSchema(description: '维度名称'),
                'score': IntegerSchema(description: '维度得分'),
                'weight': NumberSchema(description: '权重'),
                'description': StringSchema(description: '维度描述'),
                'status': StringSchema(
                  description: '状态 (excellent/good/fair/poor)',
                ),
              },
              required: ['name', 'score'],
            ),
          ),
          'suggestions': ListSchema(
            description: '改进建议列表',
            items: StringSchema(),
          ),
          'period_start': StringSchema(description: '统计周期开始时间'),
          'period_end': StringSchema(description: '统计周期结束时间'),
        },
        required: ['total_score', 'grade'],
      ),
      widgetBuilder: _buildHealthScoreCardWidget,
    );
  }

  /// 现金流预测图表组件
  static CatalogItem _buildCashFlowForecastChart() {
    return CatalogItem(
      name: 'CashFlowForecastChart',
      dataSchema: ObjectSchema(
        properties: {
          'success': BooleanSchema(description: '操作是否成功'),
          'forecast_period': ObjectSchema(
            description: '预测周期信息',
            properties: {
              'start': StringSchema(description: '开始日期 (ISO)'),
              'end': StringSchema(description: '结束日期 (ISO)'),
              'days': IntegerSchema(description: '预测天数'),
            },
          ),
          'current_balance': NumberSchema(description: '当前余额'),
          'data_points': ListSchema(
            description: '预测数据点',
            items: ObjectSchema(
              properties: {
                'date': StringSchema(description: '日期 (ISO)'),
                'predicted_balance': NumberSchema(description: '预测余额'),
                'lower_bound': NumberSchema(description: '下限（保守估计）'),
                'upper_bound': NumberSchema(description: '上限（乐观估计）'),
                'events': ListSchema(
                  description: '当日事件',
                  items: ObjectSchema(
                    properties: {
                      'type': StringSchema(
                        description: '事件类型',
                        enumValues: [
                          'RECURRING',
                          'PREDICTED_VARIABLE',
                          'SIMULATED',
                        ],
                      ),
                      'description': StringSchema(description: '事件描述'),
                      'amount': NumberSchema(description: '金额'),
                      'source_id': StringSchema(description: '来源ID'),
                      'category_key': StringSchema(description: '分类'),
                      'confidence': NumberSchema(description: '置信度 (0-1)'),
                    },
                    required: ['type', 'description', 'amount'],
                  ),
                ),
              },
              required: ['date', 'predicted_balance'],
            ),
          ),
          'warnings': ListSchema(
            description: '预警信息',
            items: ObjectSchema(
              properties: {
                'date': StringSchema(description: '预警日期'),
                'type': StringSchema(
                  description: '预警类型',
                  enumValues: ['BELOW_SAFETY', 'NEGATIVE_BALANCE'],
                ),
                'message': StringSchema(description: '预警消息'),
              },
              required: ['date', 'type', 'message'],
            ),
          ),
          'summary': ObjectSchema(
            description: '预测摘要',
            properties: {
              'total_recurring_income': NumberSchema(description: '周期性收入总计'),
              'total_recurring_expense': NumberSchema(description: '周期性支出总计'),
              'predicted_variable_expense': NumberSchema(description: '预测可变支出'),
              'net_change': NumberSchema(description: '净变化'),
            },
          ),
          'purchase_analysis': ObjectSchema(
            description: '购买分析（simulate_purchase 专用）',
            properties: {
              'purchase_date': StringSchema(description: '购买日期'),
              'purchase_amount': NumberSchema(description: '购买金额'),
              'description': StringSchema(description: '购买描述'),
              'balance_before': NumberSchema(description: '购买前余额'),
              'balance_after_purchase': NumberSchema(description: '购买后余额'),
              'will_trigger_warning': BooleanSchema(description: '是否触发预警'),
            },
          ),
        },
        required: ['success'],
      ),
      widgetBuilder: _buildCashFlowForecastChartWidget,
    );
  }

  /// 构建交易列表 Widget
  static Widget _buildTransactionListWidget(CatalogItemContext context) {
    final startTime = DateTime.now();
    const componentName = 'TransactionList';
    try {
      final data = context.data as Map<String, dynamic>;
      final widget = TransactionList(data: data);
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      GenUiLogger.logBuilderInvocation(
        componentName: componentName,
        success: true,
        durationMs: duration,
      );
      return widget;
    } catch (e, stackTrace) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      GenUiLogger.logBuilderInvocation(
        componentName: componentName,
        success: false,
        durationMs: duration,
      );
      GenUiLogger.logError(
        message: 'Builder failed for $componentName',
        error: e,
        stackTrace: stackTrace,
      );
      return _buildErrorWidget(context.buildContext, '渲染失败: $e');
    }
  }

  /// 构建预算状态卡片 Widget
  static Widget _buildBudgetStatusCardWidget(CatalogItemContext context) {
    final startTime = DateTime.now();
    const componentName = 'BudgetStatusCard';
    try {
      final data = context.data as Map<String, dynamic>;
      final widget = BudgetStatusCard(data: data);
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      GenUiLogger.logBuilderInvocation(
        componentName: componentName,
        success: true,
        durationMs: duration,
      );
      return widget;
    } catch (e, stackTrace) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      GenUiLogger.logBuilderInvocation(
        componentName: componentName,
        success: false,
        durationMs: duration,
      );
      GenUiLogger.logError(
        message: 'Builder failed for $componentName',
        error: e,
        stackTrace: stackTrace,
      );
      return _buildErrorWidget(context.buildContext, '预算状态卡片渲染失败: $e');
    }
  }

  /// 构建预算创建收据 Widget
  static Widget _buildBudgetReceiptWidget(CatalogItemContext context) {
    final startTime = DateTime.now();
    const componentName = 'BudgetReceipt';
    try {
      final data = context.data as Map<String, dynamic>;
      final widget = BudgetReceipt(data: data);
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      GenUiLogger.logBuilderInvocation(
        componentName: componentName,
        success: true,
        durationMs: duration,
      );
      return widget;
    } catch (e, stackTrace) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      GenUiLogger.logBuilderInvocation(
        componentName: componentName,
        success: false,
        durationMs: duration,
      );
      GenUiLogger.logError(
        message: 'Builder failed for $componentName',
        error: e,
        stackTrace: stackTrace,
      );
      return _buildErrorWidget(context.buildContext, '预算收据渲染失败: $e');
    }
  }

  /// 构建预算分析卡片 Widget（Skills 专用）
  static Widget _buildBudgetAnalysisCardWidget(CatalogItemContext context) {
    final startTime = DateTime.now();
    const componentName = 'BudgetAnalysisCard';
    try {
      final data = context.data as Map<String, dynamic>;
      final widget = BudgetAnalysisCard(data: data);
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      GenUiLogger.logBuilderInvocation(
        componentName: componentName,
        success: true,
        durationMs: duration,
      );
      return widget;
    } catch (e, stackTrace) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      GenUiLogger.logBuilderInvocation(
        componentName: componentName,
        success: false,
        durationMs: duration,
      );
      GenUiLogger.logError(
        message: 'Builder failed for $componentName',
        error: e,
        stackTrace: stackTrace,
      );
      return _buildErrorWidget(context.buildContext, '预算分析卡片渲染失败: $e');
    }
  }

  /// 构建批量交易收据 Widget
  static Widget _buildTransactionGroupReceiptWidget(
    CatalogItemContext context,
  ) {
    final startTime = DateTime.now();
    const componentName = 'TransactionGroupReceipt';
    try {
      final data = context.data as Map<String, dynamic>;
      final success = data['success'] as bool? ?? false;
      final transactions = data['transactions'] as List?;
      if (!success || transactions == null || transactions.isEmpty) {
        final duration = DateTime.now().difference(startTime).inMilliseconds;
        GenUiLogger.logBuilderInvocation(
          componentName: componentName,
          success: false,
          durationMs: duration,
        );
        return _buildErrorWidget(context.buildContext, '批量交易数据不完整');
      }
      final widget = TransactionGroupReceipt(
        data: data,
        dispatchEvent: context.dispatchEvent,
      );
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      GenUiLogger.logBuilderInvocation(
        componentName: componentName,
        success: true,
        durationMs: duration,
      );
      return widget;
    } catch (e, stackTrace) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      GenUiLogger.logBuilderInvocation(
        componentName: componentName,
        success: false,
        durationMs: duration,
      );
      GenUiLogger.logError(
        message: 'Builder failed for $componentName',
        error: e,
        stackTrace: stackTrace,
      );
      return _buildErrorWidget(context.buildContext, '批量收据渲染失败: $e');
    }
  }

  /// 构建现金流卡片 Widget
  static Widget _buildCashFlowCardWidget(CatalogItemContext context) {
    final startTime = DateTime.now();
    const componentName = 'CashFlowCard';
    try {
      final data = context.data as Map<String, dynamic>;
      if (!_validateRequiredFields(data, ['netCashFlow', 'savingsRate'])) {
        final duration = DateTime.now().difference(startTime).inMilliseconds;
        GenUiLogger.logBuilderInvocation(
          componentName: componentName,
          success: false,
          durationMs: duration,
        );
        return _buildErrorWidget(context.buildContext, '现金流数据不完整');
      }
      final widget = CashFlowAnalysisCard(data: data);
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      GenUiLogger.logBuilderInvocation(
        componentName: componentName,
        success: true,
        durationMs: duration,
      );
      return widget;
    } catch (e, stackTrace) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      GenUiLogger.logBuilderInvocation(
        componentName: componentName,
        success: false,
        durationMs: duration,
      );
      GenUiLogger.logError(
        message: 'Builder failed for $componentName',
        error: e,
        stackTrace: stackTrace,
      );
      return _buildErrorWidget(context.buildContext, '现金流分析渲染失败: $e');
    }
  }

  /// 构建财务健康评分卡片 Widget
  static Widget _buildHealthScoreCardWidget(CatalogItemContext context) {
    final startTime = DateTime.now();
    const componentName = 'HealthScoreCard';
    try {
      final data = context.data as Map<String, dynamic>;
      if (!_validateRequiredFields(data, ['totalScore', 'grade'])) {
        final duration = DateTime.now().difference(startTime).inMilliseconds;
        GenUiLogger.logBuilderInvocation(
          componentName: componentName,
          success: false,
          durationMs: duration,
        );
        return _buildErrorWidget(context.buildContext, '财务健康评分数据不完整');
      }
      final widget = HealthScoreAnalysisCard(data: data);
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      GenUiLogger.logBuilderInvocation(
        componentName: componentName,
        success: true,
        durationMs: duration,
      );
      return widget;
    } catch (e, stackTrace) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      GenUiLogger.logBuilderInvocation(
        componentName: componentName,
        success: false,
        durationMs: duration,
      );
      GenUiLogger.logError(
        message: 'Builder failed for $componentName',
        error: e,
        stackTrace: stackTrace,
      );
      return _buildErrorWidget(context.buildContext, '财务健康评分渲染失败: $e');
    }
  }

  /// 构建现金流预测图表 Widget
  static Widget _buildCashFlowForecastChartWidget(CatalogItemContext context) {
    final startTime = DateTime.now();
    const componentName = 'CashFlowForecastChart';
    try {
      final data = context.data as Map<String, dynamic>;
      final success = data['success'] as bool? ?? false;
      if (!success) {
        final errorMsg = data['error'] as String? ?? '预测失败';
        final duration = DateTime.now().difference(startTime).inMilliseconds;
        GenUiLogger.logBuilderInvocation(
          componentName: componentName,
          success: false,
          durationMs: duration,
        );
        return _buildErrorWidget(context.buildContext, errorMsg);
      }
      final widget = CashFlowForecastChart(data: data);
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      GenUiLogger.logBuilderInvocation(
        componentName: componentName,
        success: true,
        durationMs: duration,
      );
      return widget;
    } catch (e, stackTrace) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      GenUiLogger.logBuilderInvocation(
        componentName: componentName,
        success: false,
        durationMs: duration,
      );
      GenUiLogger.logError(
        message: 'Builder failed for $componentName',
        error: e,
        stackTrace: stackTrace,
      );
      return _buildErrorWidget(context.buildContext, '现金流预测渲染失败: $e');
    }
  }

  /// 账单概览卡片组件
  static CatalogItem _buildExpenseSummaryCard() {
    return CatalogItem(
      name: 'ExpenseSummaryCard',
      dataSchema: ObjectSchema(
        properties: {
          'summary': ObjectSchema(
            properties: {
              'total_expense': NumberSchema(),
              'currency': StringSchema(),
              'distribution': ListSchema(items: ObjectSchema()),
              'top_items': ListSchema(items: ObjectSchema()),
              'count': IntegerSchema(),
            },
          ),
          'items': ListSchema(items: ObjectSchema()),
        },
        required: ['summary'],
      ),
      widgetBuilder: _buildExpenseSummaryCardWidget,
    );
  }

  static Widget _buildExpenseSummaryCardWidget(CatalogItemContext context) {
    try {
      final data = context.data as Map<String, dynamic>;
      return ExpenseSummaryCard(data: data);
    } catch (e) {
      return _buildErrorWidget(context.buildContext, '账单概览加载失败');
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 共享空间相关组件
  // ═══════════════════════════════════════════════════════════════════════════

  /// 空间选择器卡片组件
  static CatalogItem _buildSpaceSelectorCard() {
    return CatalogItem(
      name: 'SpaceSelectorCard',
      dataSchema: ObjectSchema(
        properties: {
          'matched_spaces': ListSchema(
            description: '匹配到的共享空间列表',
            items: ObjectSchema(
              properties: {
                'id': IntegerSchema(description: '空间ID'),
                'name': StringSchema(description: '空间名称'),
                'description': StringSchema(description: '空间描述'),
                'role': StringSchema(description: '用户角色'),
              },
              required: ['id', 'name'],
            ),
          ),
          'all_spaces': ListSchema(
            description: '所有可用共享空间列表',
            items: ObjectSchema(
              properties: {
                'id': IntegerSchema(description: '空间ID'),
                'name': StringSchema(description: '空间名称'),
                'description': StringSchema(description: '空间描述'),
                'role': StringSchema(description: '用户角色'),
              },
              required: ['id', 'name'],
            ),
          ),
          'pending_transaction_ids': ListSchema(
            description: '待关联的交易ID列表',
            items: StringSchema(),
          ),
          'match_keyword': StringSchema(description: '匹配关键词'),
          'message': StringSchema(description: '提示消息'),
        },
        required: ['pending_transaction_ids'],
      ),
      widgetBuilder: _buildSpaceSelectorCardWidget,
    );
  }

  static Widget _buildSpaceSelectorCardWidget(CatalogItemContext context) {
    try {
      final data = context.data as Map<String, dynamic>;
      final widgetData = Map<String, dynamic>.from(data);
      widgetData['_surfaceId'] = context.surfaceId;

      return SpaceSelectorCard(
        data: widgetData,
        dispatchEvent: context.dispatchEvent,
      );
    } catch (e) {
      return _buildErrorWidget(context.buildContext, '空间选择器加载失败: $e');
    }
  }

  /// 空间关联确认组件
  static CatalogItem _buildSpaceAssociationReceipt() {
    return CatalogItem(
      name: 'SpaceAssociationReceipt',
      dataSchema: ObjectSchema(
        properties: {
          'space': ObjectSchema(
            description: '关联的空间信息',
            properties: {
              'id': IntegerSchema(description: '空间ID'),
              'name': StringSchema(description: '空间名称'),
            },
            required: ['id', 'name'],
          ),
          'association': ObjectSchema(
            description: '关联统计',
            properties: {
              'total_count': IntegerSchema(description: '总数'),
              'success_count': IntegerSchema(description: '成功数'),
              'failed_count': IntegerSchema(description: '失败数'),
            },
          ),
          'message': StringSchema(description: '结果消息'),
        },
        required: ['space', 'association'],
      ),
      widgetBuilder: _buildSpaceAssociationReceiptWidget,
    );
  }

  static Widget _buildSpaceAssociationReceiptWidget(
    CatalogItemContext context,
  ) {
    try {
      final data = context.data as Map<String, dynamic>;
      final widgetData = Map<String, dynamic>.from(data);
      widgetData['_surfaceId'] = context.surfaceId;

      return SpaceAssociationReceipt(
        data: widgetData,
        dispatchEvent: context.dispatchEvent,
      );
    } catch (e) {
      return _buildErrorWidget(context.buildContext, '关联确认加载失败: $e');
    }
  }
}
