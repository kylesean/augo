import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import '../templates/templates.dart';
import '../utils/utils.dart';

/// Renders historical UI components from stored message data.
///
/// This widget is used to render UI components that were saved in message
/// history. It uses the same widget builders as the GenUI catalog but
/// bypasses the dynamic surface system.
///
class HistoricalComponentRenderer extends StatelessWidget {
  /// The component type name (e.g., 'TransactionReceipt')
  final String componentType;

  /// The component data
  final Map<String, dynamic> data;

  const HistoricalComponentRenderer({
    super.key,
    required this.componentType,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    // Use HistoricalModeHelper to add historical mode marker
    final historicalData = HistoricalModeHelper.markAsHistorical(data);

    // Reuse templates/ widgets
    // Note: Component names must match the definitions in the backend TOOL_UI_MAP
    return switch (componentType) {
      'TransactionReceipt' => TransactionCard(data: historicalData),
      'TransferReceipt' => TransferReceipt(data: historicalData),
      'ExpenseTable' => ExpenseTable(data: historicalData),
      'ChartCard' => ChartCard(data: historicalData),
      'SummaryCard' => SummaryCard(data: historicalData),
      'TransferPathBuilder' => TransferPathBuilder(
        data: historicalData,
        dispatchEvent: HistoricalModeHelper.noopDispatch,
      ),
      // Budget components
      'BudgetStatusCard' => BudgetStatusCard(data: historicalData),
      'BudgetReceipt' => BudgetReceipt(data: historicalData),
      'BudgetAnalysisCard' => BudgetAnalysisCard(data: historicalData),
      // Transaction group receipt
      'TransactionGroupReceipt' => TransactionGroupReceipt(
        data: historicalData,
      ),
      // Transaction list
      'TransactionList' => TransactionList(data: historicalData),
      // Statistics analysis components
      'CashFlowCard' => CashFlowAnalysisCard(data: historicalData),
      'HealthScoreCard' => HealthScoreAnalysisCard(data: historicalData),
      // Expense summary
      'ExpenseSummaryCard' => ExpenseSummaryCard(data: historicalData),
      // Forecast prediction components
      'CashFlowForecastChart' => CashFlowForecastChart(data: historicalData),
      'TransferWizard' => TransferWizard(
        data: historicalData,
        dispatchEvent: HistoricalModeHelper.noopDispatch,
      ),
      _ => _buildUnsupportedComponent(context),
    };
  }

  Widget _buildUnsupportedComponent(BuildContext context) {
    final colors = context.theme.colors;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.muted,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: colors.mutedForeground),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Unsupported component type: $componentType',
              style: TextStyle(color: colors.mutedForeground),
            ),
          ),
        ],
      ),
    );
  }
}
