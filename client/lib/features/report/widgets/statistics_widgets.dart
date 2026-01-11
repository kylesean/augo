import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../i18n/strings.g.dart';
import '../models/statistics_models.dart';
import '../../../shared/providers/amount_theme_provider.dart';
import '../../../core/constants/category_constants.dart';
import '../../../shared/models/currency.dart';
import '../../profile/providers/financial_settings_provider.dart';
import '../../../shared/widgets/amount_text.dart';
import '../../../shared/widgets/themed_icon.dart';
import '../../home/models/transaction_model.dart';
import '../../../app/theme/app_semantic_colors.dart';
import '../../../shared/widgets/app_filter_chip.dart';

/// A premium overview that uses large typography and subtle depth
class OverviewCard extends ConsumerWidget {
  final StatisticsOverview overview;

  const OverviewCard({super.key, required this.overview});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.theme;
    final colors = theme.colors;
    final amountTheme = ref.watch(currentAmountThemeProvider);
    final currencyCode = ref.watch(financialSettingsProvider).primaryCurrency;
    final currencySymbol =
        Currency.fromCode(currencyCode)?.symbol ?? currencyCode;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.primary.withValues(alpha: 0.95),
            colors.primary.withValues(alpha: 0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.25),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: -30,
            bottom: -30,
            child: Icon(
              FIcons.trendingUp,
              size: 160,
              color: Colors.white.withValues(alpha: 0.04),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  t.statistics.overview.balance,
                  style: theme.typography.sm.copyWith(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: AmountText(
                      amount: double.tryParse(overview.totalBalance) ?? 0,
                      type: (double.tryParse(overview.totalBalance) ?? 0) >= 0
                          ? TransactionType.income
                          : TransactionType.expense,
                      semantic: AmountSemantic.status,
                      currency: currencyCode,
                      shrinkCurrency: true,
                      style: theme.typography.xl4.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -1.2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildIndicator(
                        context,
                        ref,
                        theme,
                        t.statistics.overview.income,
                        overview.totalIncome,
                        overview.incomeChangePercent,
                        FIcons.arrowUpRight,
                        amountTheme.incomeColor,
                        currencySymbol,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildIndicator(
                        context,
                        ref,
                        theme,
                        t.statistics.overview.expense,
                        overview.totalExpense,
                        overview.expenseChangePercent,
                        FIcons.arrowDownRight,
                        amountTheme.expenseColor,
                        currencySymbol,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(
    BuildContext context,
    WidgetRef ref,
    FThemeData theme,
    String label,
    String amount,
    double change,
    IconData icon,
    Color color,
    String currencySymbol,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 10, color: Colors.white.withValues(alpha: 0.5)),
            const SizedBox(width: 4),
            Text(
              label,
              style: theme.typography.xs.copyWith(
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: AmountText(
                amount: double.tryParse(amount) ?? 0,
                type: label == t.statistics.overview.income
                    ? TransactionType.income
                    : TransactionType.expense,
                semantic: AmountSemantic.transaction,
                currency:
                    currencySymbol, // AmountText handles symbol via currency code
                showSign: false,
                shrinkCurrency: true,
                style: theme.typography.base.copyWith(
                  color: Colors.white, // 确保在大卡片上始终为白色
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 4),
            AmountChangeIndicator(
              changePercent: change,
              inverseColor: label == t.statistics.overview.expense,
              theme: ref.watch(currentAmountThemeValueProvider),
              style: theme.typography.xs.copyWith(
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// A compact card to compare current vs previous period metrics
class MetricComparisonCard extends ConsumerWidget {
  final String label;
  final String currentAmount;
  final double changePercent;
  final String compareLabel;
  final bool isExpense;

  const MetricComparisonCard({
    super.key,
    required this.label,
    required this.currentAmount,
    required this.changePercent,
    required this.compareLabel,
    this.isExpense = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.theme;
    final colors = theme.colors;
    final amountTheme = ref.watch(currentAmountThemeProvider);
    final isPositive = changePercent >= 0;
    final currencyCode = ref.watch(financialSettingsProvider).primaryCurrency;
    final currencySymbol =
        Currency.fromCode(currencyCode)?.symbol ?? currencyCode;

    final displayColor = isExpense
        ? amountTheme.expenseColor
        : amountTheme.incomeColor;

    return FCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.typography.xs.copyWith(color: colors.mutedForeground),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      currencySymbol,
                      style: theme.typography.xs.copyWith(
                        color: colors.mutedForeground,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Flexible(
                      child: AmountText(
                        amount: double.tryParse(currentAmount) ?? 0,
                        type: isExpense
                            ? TransactionType.expense
                            : TransactionType.income,
                        semantic: AmountSemantic.transaction,
                        currency: currencyCode,
                        style: theme.typography.lg.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _buildTrendIndicator(theme, isPositive, displayColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrendIndicator(
    FThemeData theme,
    bool isPositive,
    Color displayColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isPositive ? FIcons.trendingUp : FIcons.trendingDown,
              size: 12,
              color: displayColor,
            ),
            const SizedBox(width: 2),
            Text(
              '${isPositive ? '+' : ''}${changePercent.abs().toStringAsFixed(1)}%',
              style: theme.typography.xs.copyWith(
                color: displayColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Text(
          compareLabel,
          style: theme.typography.xs.copyWith(
            color: theme.colors.mutedForeground,
            fontSize: 8,
          ),
        ),
      ],
    );
  }
}

/// Redesigned TrendChart with income/expense toggle using FTabs
class TrendChart extends ConsumerWidget {
  final TrendDataResponse trendData;
  final ChartType chartType;
  final Function(ChartType) onChartTypeChanged;

  const TrendChart({
    super.key,
    required this.trendData,
    required this.chartType,
    required this.onChartTypeChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.theme;
    final colors = theme.colors;
    final amountTheme = ref.watch(currentAmountThemeProvider);

    final expenseColor = amountTheme.expenseColor;
    final incomeColor = amountTheme.incomeColor;
    final currentColor = chartType == ChartType.expense
        ? expenseColor
        : incomeColor;

    return FCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                t.statistics.trend.title,
                style: theme.typography.lg.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppFilterChip(
                    label: t.statistics.trend.expense,
                    isSelected: chartType == ChartType.expense,
                    onTap: () => onChartTypeChanged(ChartType.expense),
                  ),
                  const SizedBox(width: 8),
                  AppFilterChip(
                    label: t.statistics.trend.income,
                    isSelected: chartType == ChartType.income,
                    onTap: () => onChartTypeChanged(ChartType.income),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: null,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: colors.border.withValues(alpha: 0.08),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      // Calculate interval based on time range and data points
                      interval: _calculateLabelInterval(
                        trendData.dataPoints.length,
                        trendData.timeRange,
                      ),
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        // Skip if out of bounds or fractional
                        if (index < 0 ||
                            index >= trendData.dataPoints.length ||
                            value != index.toDouble()) {
                          return const SizedBox();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _formatLabel(
                              trendData.dataPoints[index].label,
                              trendData.timeRange,
                            ),
                            style: theme.typography.xs.copyWith(
                              color: colors.mutedForeground,
                              fontSize: 10,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  _buildLineData(trendData.dataPoints, currentColor, colors),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (spot) => colors.primary,
                    getTooltipItems: (touchedSpots) {
                      final currencyCode = ref
                          .read(financialSettingsProvider)
                          .primaryCurrency;
                      final currencySymbol =
                          Currency.fromCode(currencyCode)?.symbol ??
                          currencyCode;
                      return touchedSpots.map((spot) {
                        final label = chartType == ChartType.expense
                            ? t.statistics.trend.expense
                            : t.statistics.trend.income;
                        return LineTooltipItem(
                          '$label: $currencySymbol${NumberFormat("#,##0", "en_US").format(spot.y)}',
                          theme.typography.xs.copyWith(
                            color: colors.primaryForeground,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  LineChartBarData _buildLineData(
    List<TrendDataPoint> points,
    Color color,
    FColors colors,
  ) {
    return LineChartBarData(
      spots: points.asMap().entries.map((e) {
        return FlSpot(e.key.toDouble(), double.tryParse(e.value.amount) ?? 0);
      }).toList(),
      isCurved: true,
      curveSmoothness: 0.35,
      color: color,
      barWidth: 2.5,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
          radius: 3,
          color: colors.background,
          strokeWidth: 2,
          strokeColor: color,
        ),
        checkToShowDot: (spot, barData) => spot.x == barData.spots.last.x,
      ),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: 0.15), color.withValues(alpha: 0.0)],
        ),
      ),
    );
  }

  /// Calculate the interval for X-axis labels based on time range
  double _calculateLabelInterval(int dataPointsCount, String timeRange) {
    switch (timeRange.toLowerCase()) {
      case 'week':
        // Show all 7 days for week view
        return 1;
      case 'month':
        // For month view (~30 days), show about 5 labels to avoid overlap
        // Using interval of 7 gives us ~5 labels: 1, 8, 15, 22, 29
        if (dataPointsCount <= 7) return 1;
        if (dataPointsCount <= 14) return 2;
        return 7; // ~5 labels for 28-31 days, avoids first/last overlap
      case 'year':
        // For year view (12 months), show every 2nd month (6 labels)
        return 2;
      default:
        if (dataPointsCount <= 7) return 1;
        if (dataPointsCount <= 14) return 2;
        return 7;
    }
  }

  String _formatLabel(String label, String timeRange) {
    // Backend returns standard date strings (YYYY-MM-DD or YYYY-MM) as label
    try {
      DateTime date;
      if (label.length == 7) {
        // YYYY-MM
        date = DateFormat('yyyy-MM').parse(label);
      } else {
        date = DateTime.parse(label);
      }

      switch (timeRange.toLowerCase()) {
        case 'week':
          // Use localized weekday names from i18n
          final weekday = date.weekday;
          final weekdays = [
            t.calendar.weekdays.mon,
            t.calendar.weekdays.tue,
            t.calendar.weekdays.wed,
            t.calendar.weekdays.thu,
            t.calendar.weekdays.fri,
            t.calendar.weekdays.sat,
            t.calendar.weekdays.sun,
          ];
          return weekdays[weekday - 1];
        case 'month':
          // Return just the day number
          return '${date.day}';
        case 'year':
          // Return just the month number
          return '${date.month}';
        default:
          // For custom range, return day/month format
          return '${date.day}/${date.month}';
      }
    } catch (_) {
      return label;
    }
  }
}

/// Unified Category Analysis Section with multi-view switching
/// Replaces both CategoryDonutChart and CategoryDetailedReport
class CategoryAnalysisSection extends ConsumerStatefulWidget {
  final CategoryBreakdownResponse breakdown;

  const CategoryAnalysisSection({super.key, required this.breakdown});

  @override
  ConsumerState<CategoryAnalysisSection> createState() =>
      _CategoryAnalysisSectionState();
}

enum CategoryViewMode { bar, pie, radar, list }

class _CategoryAnalysisSectionState
    extends ConsumerState<CategoryAnalysisSection> {
  CategoryViewMode _viewMode = CategoryViewMode.bar;

  String _formatAmount(String amount) {
    final numberFormat = NumberFormat("#,##0", "zh_CN");
    return numberFormat.format(double.tryParse(amount) ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    if (widget.breakdown.items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with custom view switcher
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              t.statistics.analysis.title,
              style: theme.typography.lg.copyWith(fontWeight: FontWeight.w600),
            ),
            // Custom icon toggle (FTabs needs bounded width)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppFilterChip(
                  icon: FIcons.chartColumn,
                  isSelected: _viewMode == CategoryViewMode.bar,
                  onTap: () => setState(() => _viewMode = CategoryViewMode.bar),
                ),
                const SizedBox(width: 4),
                AppFilterChip(
                  icon: FIcons.chartPie,
                  isSelected: _viewMode == CategoryViewMode.pie,
                  onTap: () => setState(() => _viewMode = CategoryViewMode.pie),
                ),
                const SizedBox(width: 4),
                AppFilterChip(
                  icon: FIcons.hexagon,
                  isSelected: _viewMode == CategoryViewMode.radar,
                  onTap: () =>
                      setState(() => _viewMode = CategoryViewMode.radar),
                ),
                const SizedBox(width: 4),
                AppFilterChip(
                  icon: FIcons.list,
                  isSelected: _viewMode == CategoryViewMode.list,
                  onTap: () =>
                      setState(() => _viewMode = CategoryViewMode.list),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Chart content based on view mode
        FCard(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _buildChartContent(theme, colors),
          ),
        ),
      ],
    );
  }

  Widget _buildChartContent(FThemeData theme, FColors colors) {
    switch (_viewMode) {
      case CategoryViewMode.bar:
        return _buildBarChart(theme, colors);
      case CategoryViewMode.pie:
        return _buildPieChart(theme, colors);
      case CategoryViewMode.radar:
        return _buildRadarChart(theme, colors);
      case CategoryViewMode.list:
        return _buildListView(theme, colors);
    }
  }

  Widget _buildBarChart(FThemeData theme, FColors colors) {
    final maxY =
        widget.breakdown.items
            .map((e) => e.percentage)
            .reduce((a, b) => a > b ? a : b) *
        1.2;

    return SizedBox(
      key: const ValueKey('bar'),
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) => colors.primary,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final item = widget.breakdown.items[group.x];
                final category = TransactionCategory.fromKey(item.categoryKey);
                final currencyCode = ref
                    .read(financialSettingsProvider)
                    .primaryCurrency;
                final currencySymbol =
                    Currency.fromCode(currencyCode)?.symbol ?? currencyCode;
                return BarTooltipItem(
                  '${category.displayText}\n$currencySymbol${_formatAmount(item.amount)}',
                  theme.typography.xs.copyWith(
                    color: colors.primaryForeground,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= widget.breakdown.items.length) {
                    return const SizedBox();
                  }
                  final item = widget.breakdown.items[index];
                  final category = TransactionCategory.fromKey(
                    item.categoryKey,
                  );
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Icon(
                      category.icon,
                      size: 14,
                      color: colors.foreground,
                    ),
                  );
                },
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          barGroups: widget.breakdown.items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final chartColor = context.theme.chartColorAt(index);
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: item.percentage,
                  color: chartColor,
                  width: 18,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPieChart(FThemeData theme, FColors colors) {
    // Calculate total for center display
    final total = widget.breakdown.items.fold<double>(
      0,
      (sum, item) => sum + (double.tryParse(item.amount) ?? 0),
    );
    final topItems = widget.breakdown.items.take(4).toList();

    return Column(
      key: const ValueKey('pie'),
      children: [
        SizedBox(
          height: 180,
          child: Row(
            children: [
              // Pie chart
              Expanded(
                flex: 3,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 42,
                        sections: widget.breakdown.items.asMap().entries.map((
                          entry,
                        ) {
                          final index = entry.key;
                          final item = entry.value;
                          final chartColor = context.theme.chartColorAt(index);
                          return PieChartSectionData(
                            color: chartColor,
                            value: item.percentage,
                            title: '',
                            radius: 28,
                          );
                        }).toList(),
                      ),
                    ),
                    // Center total
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          t.statistics.analysis.total,
                          style: theme.typography.xs.copyWith(
                            color: colors.mutedForeground,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${Currency.fromCode(ref.read(financialSettingsProvider).primaryCurrency)?.symbol ?? ""}${_formatAmount(total.toStringAsFixed(0))}',
                          style: theme.typography.base.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Legend
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: topItems.asMap().entries.map((entry) {
                    final item = entry.value;
                    final category = TransactionCategory.fromKey(
                      item.categoryKey,
                    );
                    // 图例颜色需要与饼图扣区对应，使用原始 items 中的索引
                    final originalIndex = widget.breakdown.items.indexOf(item);
                    final chartColor = context.theme.chartColorAt(
                      originalIndex,
                    );
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: chartColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              category.displayText,
                              style: theme.typography.xs.copyWith(
                                color: colors.foreground,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '${item.percentage.toStringAsFixed(0)}%',
                            style: theme.typography.xs.copyWith(
                              color: colors.mutedForeground,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRadarChart(FThemeData theme, FColors colors) {
    // Take top 6 categories for radar chart
    final items = widget.breakdown.items.take(6).toList();
    if (items.length < 3) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Text(
            '雷达图需要至少3个分类数据',
            style: theme.typography.sm.copyWith(color: colors.mutedForeground),
          ),
        ),
      );
    }

    return SizedBox(
      key: const ValueKey('radar'),
      height: 200,
      child: RadarChart(
        RadarChartData(
          radarShape: RadarShape.polygon,
          tickCount: 4,
          ticksTextStyle: theme.typography.xs.copyWith(
            color: colors.mutedForeground,
            fontSize: 8,
          ),
          tickBorderData: BorderSide(
            color: colors.border.withValues(alpha: 0.2),
          ),
          gridBorderData: BorderSide(
            color: colors.border.withValues(alpha: 0.3),
          ),
          radarBorderData: BorderSide(
            color: colors.primary.withValues(alpha: 0.5),
          ),
          titleTextStyle: theme.typography.xs.copyWith(
            color: colors.mutedForeground,
            fontSize: 9,
          ),
          getTitle: (index, angle) {
            if (index >= items.length) return RadarChartTitle(text: '');
            final category = TransactionCategory.fromKey(
              items[index].categoryKey,
            );
            final text = category.displayText;
            return RadarChartTitle(
              text: text.length > 2 ? text.substring(0, 2) : text,
            );
          },
          dataSets: [
            RadarDataSet(
              fillColor: colors.primary.withValues(alpha: 0.2),
              borderColor: colors.primary,
              borderWidth: 2,
              entryRadius: 3,
              dataEntries: items
                  .map((item) => RadarEntry(value: item.percentage))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(FThemeData theme, FColors colors) {
    return Column(
      key: const ValueKey('list'),
      children: widget.breakdown.items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final category = TransactionCategory.fromKey(item.categoryKey);
        final chartColor = context.theme.chartColorAt(index);
        final isLast = index == widget.breakdown.items.length - 1;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  ThemedIcon.compact(icon: category.icon),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.displayText,
                          style: theme.typography.sm.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value: (item.percentage / 100).clamp(0.0, 1.0),
                            backgroundColor: colors.muted,
                            valueColor: AlwaysStoppedAnimation(chartColor),
                            minHeight: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AmountText(
                        amount: double.tryParse(item.amount) ?? 0,
                        type: TransactionType.expense,
                        semantic: AmountSemantic.status,
                        currency: ref
                            .read(financialSettingsProvider)
                            .primaryCurrency,
                        showSign: false,
                        style: theme.typography.sm.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${item.percentage.toStringAsFixed(1)}%',
                        style: theme.typography.xs.copyWith(
                          color: colors.mutedForeground,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (!isLast)
              Divider(height: 1, color: colors.border.withValues(alpha: 0.2)),
          ],
        );
      }).toList(),
    );
  }
}

/// A premium list showing top transaction items with progress indicators
class TopTransactionCard extends ConsumerWidget {
  final TopTransactionItem transaction;
  final VoidCallback onTap;

  const TopTransactionCard({
    super.key,
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.theme;
    final colors = theme.colors;
    final category = TransactionCategory.fromKey(transaction.categoryKey);

    final currencyCode = ref.watch(financialSettingsProvider).primaryCurrency;

    return FCard(
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            ThemedIcon.large(icon: category.icon),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.displayText,
                    style: theme.typography.sm.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        DateFormat('MM-dd').format(transaction.transactionAt),
                        style: theme.typography.xs.copyWith(
                          color: colors.mutedForeground,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            AmountText(
              amount: double.tryParse(transaction.amount) ?? 0,
              type: TransactionType.expense,
              semantic: AmountSemantic.status,
              currency: currencyCode,
              showSign: false,
              style: theme.typography.base.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.foreground, // 统计卡片使用中性颜色
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A high-fidelity placeholder for when there's no data.
class PremiumEmptyState extends StatelessWidget {
  final VoidCallback onAddTransaction;

  const PremiumEmptyState({super.key, required this.onAddTransaction});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    return Column(
      children: [
        const SizedBox(height: 16),
        // Ghost Overview Card (Visual Preview)
        Container(
          width: double.infinity,
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: colors.primary.withValues(alpha: 0.1),
              width: 1.5,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colors.background, colors.muted.withValues(alpha: 0.2)],
            ),
          ),
          child: Stack(
            children: [
              // Abstract background elements
              Positioned(
                right: -20,
                bottom: -20,
                child: Icon(
                  FIcons.activity,
                  size: 120,
                  color: colors.primary.withValues(alpha: 0.05),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 8,
                          decoration: BoxDecoration(
                            color: colors.muted.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: 120,
                      height: 32,
                      decoration: BoxDecoration(
                        color: colors.muted.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        _buildGhostIndicator(colors),
                        const SizedBox(width: 24),
                        _buildGhostIndicator(colors),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Main CTA Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(FIcons.sparkles, size: 32, color: colors.primary),
              ),
              const SizedBox(height: 24),
              Text(
                t.statistics.emptyState.title,
                style: theme.typography.xl.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.foreground,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                t.statistics.emptyState.description,
                textAlign: TextAlign.center,
                style: theme.typography.sm.copyWith(
                  color: colors.mutedForeground,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: 200,
                height: 40,
                child: FButton(
                  onPress: onAddTransaction,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(FIcons.plus, size: 18),
                      const SizedBox(width: 8),
                      Text(t.statistics.emptyState.action),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Ghost Charts (Bottom Visual Balance)
        Opacity(
          opacity: 0.5,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 100,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: colors.muted.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colors.border.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      FIcons.chartPie,
                      color: colors.mutedForeground.withValues(alpha: 0.2),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 100,
                  margin: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    color: colors.muted.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colors.border.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      FIcons.chartColumn,
                      color: colors.mutedForeground.withValues(alpha: 0.2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGhostIndicator(FColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 6,
          decoration: BoxDecoration(
            color: colors.muted.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 60,
          height: 16,
          decoration: BoxDecoration(
            color: colors.muted.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}
