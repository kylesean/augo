import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:augo/shared/theme/amount_theme.dart';
import 'package:augo/core/constants/category_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:augo/shared/providers/amount_theme_provider.dart';
import 'package:augo/i18n/strings.g.dart';

/// 现金流预测图表 - GenUI Template
///
/// 用于在 AI 聊天中展示用户的未来现金流预测。
/// 包含：
/// - 折线图（预测余额曲线 + 置信区间）
/// - 关键事件标记
/// - 预警信息
class CashFlowForecastChart extends StatefulWidget {
  final Map<String, dynamic> data;

  const CashFlowForecastChart({super.key, required this.data});

  @override
  State<CashFlowForecastChart> createState() => _CashFlowForecastChartState();
}

class _CashFlowForecastChartState extends State<CashFlowForecastChart> {
  bool _isExpanded = false;
  final bool _showConfidenceInterval = true;

  // Parse data points from the response
  List<_ForecastDataPoint> get _dataPoints {
    final points = widget.data['data_points'] as List<dynamic>? ?? [];
    return points.map((p) => _ForecastDataPoint.fromJson(p)).toList();
  }

  List<_ForecastWarning> get _warnings {
    final warnings = widget.data['warnings'] as List<dynamic>? ?? [];
    return warnings.map((w) => _ForecastWarning.fromJson(w)).toList();
  }

  Map<String, dynamic>? get _summary =>
      widget.data['summary'] as Map<String, dynamic>?;

  Map<String, dynamic>? get _forecastPeriod =>
      widget.data['forecast_period'] as Map<String, dynamic>?;

  double get _currentBalance {
    final balance = widget.data['current_balance'];
    if (balance is num) return balance.toDouble();
    if (balance is String) return double.tryParse(balance) ?? 0;
    return 0;
  }

  String _formatAmount(dynamic amount) {
    final numberFormat = NumberFormat("#,##0", "zh_CN");
    if (amount is String) {
      return numberFormat.format(double.tryParse(amount) ?? 0);
    }
    return numberFormat.format((amount as num?)?.toDouble() ?? 0);
  }

  /// 本地化事件描述
  /// 尝试将 category_key 或 type 转换为本地化显示文本
  String _localizeDescription(String? description) {
    if (description == null || description.isEmpty) {
      return t.chat.genui.cashFlowForecast.recurringTransaction;
    }

    final upper = description.toUpperCase();

    // 1. 先检查是否是交易类型（INCOME, EXPENSE, TRANSFER）
    switch (upper) {
      case 'INCOME':
        return t.chat.genui.cashFlowForecast.recurringIncome;
      case 'EXPENSE':
        return t.chat.genui.cashFlowForecast.recurringExpense;
      case 'TRANSFER':
        return t.chat.genui.cashFlowForecast.recurringTransfer;
    }

    // 2. 检查是否是有效的分类键
    final category = TransactionCategory.fromKey(upper);
    // fromKey 在找不到时返回 others，我们需要验证是否真的匹配
    if (category.key == upper) {
      return category.displayText;
    }

    // 3. 返回原始描述（可能是用户自定义的描述）
    return description;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final theme = context.theme;
        final colors = theme.colors;
        final amountTheme = ref.watch(currentAmountThemeValueProvider);
        final hasWarnings = _warnings.isNotEmpty;

        return GestureDetector(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: colors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasWarnings
                    ? amountTheme.expenseColor.withValues(alpha: 0.5)
                    : colors.border,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(context, amountTheme, hasWarnings),

                // Chart Area
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: SizedBox(height: 180, child: _buildChart(context)),
                ),

                // Warnings (if any)
                if (hasWarnings) _buildWarnings(context, amountTheme),

                // Expanded Details
                if (_isExpanded) _buildExpandedDetails(context, amountTheme),

                // Expand indicator
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Icon(
                      _isExpanded ? FIcons.chevronUp : FIcons.chevronDown,
                      size: 16,
                      color: colors.mutedForeground,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AmountTheme amountTheme,
    bool hasWarnings,
  ) {
    final theme = context.theme;
    final colors = theme.colors;
    final days = _forecastPeriod?['days'] ?? 30;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: hasWarnings
                      ? amountTheme.expenseColor.withValues(alpha: 0.1)
                      : colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  hasWarnings ? FIcons.info : FIcons.trendingUp,
                  size: 16,
                  color: hasWarnings
                      ? amountTheme.expenseColor
                      : colors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.chat.genui.cashFlowForecast.title,
                    style: theme.typography.sm.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    t.chat.genui.cashFlowForecast.nextDays(days: days),
                    style: theme.typography.xs.copyWith(
                      color: colors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Current balance badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colors.secondary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '¥${_formatAmount(_currentBalance)}',
              style: theme.typography.sm.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.secondaryForeground,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    if (_dataPoints.isEmpty) {
      return Center(
        child: Text(
          t.chat.genui.cashFlowForecast.noData,
          style: theme.typography.sm.copyWith(color: colors.mutedForeground),
        ),
      );
    }

    // Prepare chart data
    final spots = <FlSpot>[];
    final lowerSpots = <FlSpot>[];
    final upperSpots = <FlSpot>[];

    for (int i = 0; i < _dataPoints.length; i++) {
      final point = _dataPoints[i];
      spots.add(FlSpot(i.toDouble(), point.predictedBalance));
      lowerSpots.add(FlSpot(i.toDouble(), point.lowerBound));
      upperSpots.add(FlSpot(i.toDouble(), point.upperBound));
    }

    // Calculate Y axis range
    final allValues = [
      ..._dataPoints.map((p) => p.predictedBalance),
      ..._dataPoints.map((p) => p.lowerBound),
      ..._dataPoints.map((p) => p.upperBound),
    ];
    final minY = allValues.reduce((a, b) => a < b ? a : b);
    final maxY = allValues.reduce((a, b) => a > b ? a : b);
    final padding = (maxY - minY) * 0.1;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: (maxY - minY) / 4,
          getDrawingHorizontalLine: (value) => FlLine(
            color: colors.border.withValues(alpha: 0.3),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(
                    _formatAmount(value),
                    style: theme.typography.xs.copyWith(
                      color: colors.mutedForeground,
                      fontSize: 10,
                    ),
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              interval: (_dataPoints.length / 4).ceilToDouble(),
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < _dataPoints.length) {
                  final date = _dataPoints[index].date;
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat('M/d').format(date),
                      style: theme.typography.xs.copyWith(
                        color: colors.mutedForeground,
                        fontSize: 10,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        minY: minY - padding,
        maxY: maxY + padding,
        lineBarsData: [
          // Confidence interval (filled area between upper and lower)
          if (_showConfidenceInterval)
            LineChartBarData(
              spots: upperSpots,
              isCurved: true,
              color: Colors.transparent,
              barWidth: 0,
              belowBarData: BarAreaData(
                show: true,
                color: colors.primary.withValues(alpha: 0.1),
              ),
            ),
          if (_showConfidenceInterval)
            LineChartBarData(
              spots: lowerSpots,
              isCurved: true,
              color: Colors.transparent,
              barWidth: 0,
              belowBarData: BarAreaData(show: true, color: colors.background),
            ),
          // Main prediction line
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: colors.primary,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final index = spot.x.toInt();
                if (index >= 0 && index < _dataPoints.length) {
                  final point = _dataPoints[index];
                  return LineTooltipItem(
                    '${DateFormat('M/d').format(point.date)}\n¥${_formatAmount(point.predictedBalance)}',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  );
                }
                return null;
              }).toList();
            },
          ),
        ),
      ),
      // 启用缩放和平移手势（fl_chart 0.70.0+）
      transformationConfig: const FlTransformationConfig(
        scaleAxis: FlScaleAxis.horizontal, // 仅水平方向缩放
        minScale: 1.0,
        maxScale: 3.0, // 最大3倍缩放
        panEnabled: true,
        scaleEnabled: true,
      ),
    );
  }

  Widget _buildWarnings(BuildContext context, AmountTheme amountTheme) {
    final theme = context.theme;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: amountTheme.expenseColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: amountTheme.expenseColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _warnings.map((warning) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                Icon(FIcons.info, size: 14, color: amountTheme.expenseColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    warning.message,
                    style: theme.typography.xs.copyWith(
                      color: amountTheme.expenseColor,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildExpandedDetails(BuildContext context, AmountTheme amountTheme) {
    final theme = context.theme;
    final summary = _summary;

    if (summary == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const SizedBox(height: 8),
          Text(
            t.chat.genui.cashFlowForecast.summary,
            style: theme.typography.sm.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  context,
                  amountTheme,
                  label: t.chat.genui.cashFlowForecast.recurringIncome,
                  value: summary['total_recurring_income'],
                  isPositive: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryItem(
                  context,
                  amountTheme,
                  label: t.chat.genui.cashFlowForecast.recurringExpense,
                  value: summary['total_recurring_expense'],
                  isPositive: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  context,
                  amountTheme,
                  label: t.chat.genui.cashFlowForecast.variableExpense,
                  value: summary['predicted_variable_expense'],
                  isPositive: false,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryItem(
                  context,
                  amountTheme,
                  label: t.chat.genui.cashFlowForecast.netChange,
                  value: summary['net_change'],
                  isPositive: (summary['net_change'] ?? 0) >= 0,
                ),
              ),
            ],
          ),

          // Key events section
          if (_dataPoints.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              t.chat.genui.cashFlowForecast.keyEvents,
              style: theme.typography.sm.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ..._buildKeyEvents(context, amountTheme),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    AmountTheme amountTheme, {
    required String label,
    required dynamic value,
    required bool isPositive,
  }) {
    final theme = context.theme;
    final colors = theme.colors;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.typography.xs.copyWith(color: colors.mutedForeground),
          ),
          const SizedBox(height: 4),
          Text(
            '¥${_formatAmount(value)}',
            style: theme.typography.sm.copyWith(
              fontWeight: FontWeight.w600,
              color: isPositive
                  ? amountTheme.incomeColor
                  : amountTheme.expenseColor,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildKeyEvents(BuildContext context, AmountTheme amountTheme) {
    final theme = context.theme;
    final colors = theme.colors;

    // Collect significant events (recurring with amount > 500)
    // 使用 source_id 去重，每种周期事件只保留第一次出现
    final seenSourceIds = <String>{};
    final keyEvents = <Map<String, dynamic>>[];

    for (final point in _dataPoints) {
      for (final event in point.events) {
        if (event['type'] == 'RECURRING' &&
            (event['amount'] as num).abs() > 500) {
          final sourceId = event['source_id'] as String? ?? '';

          // 去重：每个 source_id 只保留第一次出现
          if (sourceId.isEmpty || !seenSourceIds.contains(sourceId)) {
            if (sourceId.isNotEmpty) seenSourceIds.add(sourceId);
            keyEvents.add({'date': point.date, ...event});
          }
        }
      }
    }

    // Sort by absolute amount and take top 5
    keyEvents.sort(
      (a, b) =>
          (b['amount'] as num).abs().compareTo((a['amount'] as num).abs()),
    );
    final topEvents = keyEvents.take(5).toList();

    if (topEvents.isEmpty) {
      return [
        Text(
          t.chat.genui.cashFlowForecast.noSignificantEvents,
          style: theme.typography.xs.copyWith(color: colors.mutedForeground),
        ),
      ];
    }

    return topEvents.map((event) {
      final date = event['date'] as DateTime;
      final amount = (event['amount'] as num).toDouble();
      final rawDescription = event['description'] as String?;
      final description = _localizeDescription(rawDescription);
      final isIncome = amount > 0;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                color: isIncome
                    ? amountTheme.incomeColor
                    : amountTheme.expenseColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    description,
                    style: theme.typography.xs,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    DateFormat(
                      t.chat.genui.cashFlowForecast.dateFormat,
                    ).format(date),
                    style: theme.typography.xs.copyWith(
                      color: colors.mutedForeground,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${isIncome ? '+' : ''}¥${_formatAmount(amount)}',
              style: theme.typography.xs.copyWith(
                fontWeight: FontWeight.w600,
                color: isIncome
                    ? amountTheme.incomeColor
                    : amountTheme.expenseColor,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}

// Data models for parsing forecast response
class _ForecastDataPoint {
  final DateTime date;
  final double predictedBalance;
  final double lowerBound;
  final double upperBound;
  final List<Map<String, dynamic>> events;

  _ForecastDataPoint({
    required this.date,
    required this.predictedBalance,
    required this.lowerBound,
    required this.upperBound,
    required this.events,
  });

  factory _ForecastDataPoint.fromJson(Map<String, dynamic> json) {
    return _ForecastDataPoint(
      date: DateTime.parse(json['date'] as String),
      predictedBalance: (json['predicted_balance'] as num).toDouble(),
      lowerBound: (json['lower_bound'] as num).toDouble(),
      upperBound: (json['upper_bound'] as num).toDouble(),
      events:
          (json['events'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [],
    );
  }
}

class _ForecastWarning {
  final DateTime date;
  final String type;
  final String message;

  _ForecastWarning({
    required this.date,
    required this.type,
    required this.message,
  });

  factory _ForecastWarning.fromJson(Map<String, dynamic> json) {
    return _ForecastWarning(
      date: DateTime.parse(json['date'] as String),
      type: json['type'] as String,
      message: json['message'] as String,
    );
  }
}
