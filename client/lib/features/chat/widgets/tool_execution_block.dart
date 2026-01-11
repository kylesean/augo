// features/chat/widgets/tool_execution_block.dart
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import '../models/tool_call_info.dart';
import '../../../i18n/strings.g.dart';

/// A simplified row showing tool execution status
/// Consistent with the semantic "Processing..." indicator
class ToolExecutionBlock extends StatefulWidget {
  final ToolCallInfo toolCall;

  const ToolExecutionBlock({super.key, required this.toolCall});

  @override
  State<ToolExecutionBlock> createState() => _ToolExecutionBlockState();
}

class _ToolExecutionBlockState extends State<ToolExecutionBlock>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    if (widget.toolCall.status == ToolExecutionStatus.running ||
        widget.toolCall.status == ToolExecutionStatus.pending) {
      _controller.repeat();
    }
    // cancelled/success/error 状态不启动动画
  }

  @override
  void didUpdateWidget(ToolExecutionBlock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.toolCall.status == ToolExecutionStatus.running ||
        widget.toolCall.status == ToolExecutionStatus.pending) {
      if (!_controller.isAnimating) {
        _controller.repeat();
      }
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final t = Translations.of(context);

    // 根据状态获取不同的语义化文本
    final label = _getLabelForStatus(
      widget.toolCall.name,
      widget.toolCall.status,
      t,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildStatusIcon(theme),
          const SizedBox(width: 8),
          _buildStatusLabel(theme, label),
          if (widget.toolCall.status == ToolExecutionStatus.success &&
              widget.toolCall.durationMs != null)
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Text(
                '(${widget.toolCall.durationMs}ms)',
                style: theme.typography.sm.copyWith(
                  color: theme.colors.mutedForeground.withValues(alpha: 0.5),
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusLabel(FThemeData theme, String label) {
    final colors = theme.colors;

    if (widget.toolCall.status != ToolExecutionStatus.running &&
        widget.toolCall.status != ToolExecutionStatus.pending) {
      return Text(
        label,
        style: theme.typography.sm.copyWith(
          color: widget.toolCall.status == ToolExecutionStatus.error
              ? colors.destructive
              : colors.mutedForeground,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                colors.mutedForeground,
                colors.primary,
                colors.mutedForeground,
              ],
              stops: [
                (_shimmerAnimation.value - 0.3).clamp(0.0, 1.0),
                _shimmerAnimation.value.clamp(0.0, 1.0),
                (_shimmerAnimation.value + 0.3).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          child: Text(
            label,
            style: theme.typography.sm.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      },
    );
  }

  /// 根据状态获取不同的标签文本
  /// - pending/running: 带 "..." 的进行中标签
  /// - success: 不带 "..." 的完成标签
  /// - error: 失败标签
  String _getLabelForStatus(
    String toolName,
    ToolExecutionStatus status,
    Translations t,
  ) {
    // 对于 execute 工具，尝试从 args 中解析脚本名以显示更语义化的状态
    final semanticName = _getSemanticToolName(toolName, widget.toolCall.args);

    switch (status) {
      case ToolExecutionStatus.pending:
      case ToolExecutionStatus.running:
        return _getRunningLabel(semanticName, t);
      case ToolExecutionStatus.success:
        return _getDoneLabel(semanticName, t);
      case ToolExecutionStatus.error:
        return t.chat.tools.failed.unknown;
      case ToolExecutionStatus.cancelled:
        return t.chat.tools.cancelled;
    }
  }

  /// 从 execute 工具的参数中解析语义化的工具名
  /// 例如：execute({command: "python analyze_finance.py"}) -> "analyze_finance"
  String _getSemanticToolName(String toolName, Map<String, dynamic> args) {
    if (toolName != 'execute') return toolName;

    final command = args['command']?.toString() ?? '';

    // 脚本名到语义名的映射（精简后的 5 个脚本）
    const scriptMappings = {
      // finance-analyst
      'analyze_finance.py': 'analyze_finance',
      'forecast_finance.py': 'forecast_finance',
      // budget-expert
      'analyze_budget.py': 'analyze_budget',
      // shared-space
      'list_spaces.py': 'list_spaces',
      'query_space_summary.py': 'query_space_summary',
      // transfer-expert
      'prepare_transfer.py': 'prepare_transfer',
    };

    for (final entry in scriptMappings.entries) {
      if (command.contains(entry.key)) {
        return entry.value;
      }
    }

    return toolName; // 无法识别时返回原始工具名
  }

  /// 进行中标签（带 ...）
  String _getRunningLabel(String toolName, Translations t) {
    final tools = t.chat.tools;
    return switch (toolName) {
      'read_file' => tools.readFile,
      'search_transactions' => tools.searchTransactions,
      'query_budget_status' => tools.queryBudgetStatus,
      'create_budget' => tools.createBudget,
      // 脚本语义映射
      'analyze_finance' => tools.analyzeFinance,
      'forecast_finance' => tools.forecastFinance,
      'analyze_budget' => tools.analyzeBudget,
      'audit_analysis' => tools.auditAnalysis,
      'budget_ops' => tools.budgetOps,
      'create_shared_transaction' => tools.createSharedTransaction,
      'list_spaces' => tools.listSpaces,
      'query_space_summary' => tools.querySpaceSummary,
      'prepare_transfer' => tools.prepareTransfer,
      // 保留旧工具映射（向后兼容）
      'get_cash_flow_analysis' => tools.getCashFlowAnalysis,
      'get_financial_health_score' => tools.getFinancialHealthScore,
      'get_financial_summary' => tools.getFinancialSummary,
      'evaluate_financial_health' => tools.evaluateFinancialHealth,
      'forecast_balance' => tools.forecastBalance,
      'simulate_expense_impact' => tools.simulateExpenseImpact,
      'record_transactions' => tools.recordTransactions,
      'create_transaction' => tools.createTransaction,
      'duckduckgo_search' => tools.duckduckgoSearch,
      'execute_transfer' => tools.executeTransfer,
      'list_dir' => tools.listDir,
      'execute' => tools.execute,
      _ => tools.unknown,
    };
  }

  /// 完成标签（无 ...）
  String _getDoneLabel(String toolName, Translations t) {
    final done = t.chat.tools.done;
    return switch (toolName) {
      'read_file' => done.readFile,
      'search_transactions' => done.searchTransactions,
      'query_budget_status' => done.queryBudgetStatus,
      'create_budget' => done.createBudget,
      // 脚本语义映射
      'analyze_finance' => done.analyzeFinance,
      'forecast_finance' => done.forecastFinance,
      'analyze_budget' => done.analyzeBudget,
      'audit_analysis' => done.auditAnalysis,
      'budget_ops' => done.budgetOps,
      'create_shared_transaction' => done.createSharedTransaction,
      'list_spaces' => done.listSpaces,
      'query_space_summary' => done.querySpaceSummary,
      'prepare_transfer' => done.prepareTransfer,
      // 保留旧工具映射（向后兼容）
      'get_cash_flow_analysis' => done.getCashFlowAnalysis,
      'get_financial_health_score' => done.getFinancialHealthScore,
      'get_financial_summary' => done.getFinancialSummary,
      'evaluate_financial_health' => done.evaluateFinancialHealth,
      'forecast_balance' => done.forecastBalance,
      'simulate_expense_impact' => done.simulateExpenseImpact,
      'record_transactions' => done.recordTransactions,
      'create_transaction' => done.createTransaction,
      'duckduckgo_search' => done.duckduckgoSearch,
      'execute_transfer' => done.executeTransfer,
      'list_dir' => done.listDir,
      'execute' => done.execute,
      _ => done.unknown,
    };
  }

  Widget _buildStatusIcon(FThemeData theme) {
    switch (widget.toolCall.status) {
      case ToolExecutionStatus.pending:
      case ToolExecutionStatus.running:
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: _controller.value * 2 * 3.14159,
              child: Icon(FIcons.loader, size: 14, color: theme.colors.primary),
            );
          },
        );
      case ToolExecutionStatus.success:
        return const Icon(FIcons.check, size: 14, color: Colors.green);
      case ToolExecutionStatus.error:
        return Icon(
          FIcons.triangleAlert,
          size: 14,
          color: theme.colors.destructive,
        );
      case ToolExecutionStatus.cancelled:
        return Icon(FIcons.x, size: 14, color: theme.colors.mutedForeground);
    }
  }
}
