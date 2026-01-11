// features/home/widgets/calendar/monthly_calendar_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart'; // Import shimmer package
import 'package:augo/features/home/providers/home_providers.dart';
import 'package:augo/features/home/widgets/calendar/daily_cell_widget.dart';
import 'package:augo/features/home/models/daily_expense_summary_model.dart';
import 'package:forui/forui.dart'; // Import forui
import 'package:intl/intl.dart';
import 'package:augo/i18n/strings.g.dart';
import 'package:augo/shared/models/currency.dart';
import 'package:augo/features/profile/providers/financial_settings_provider.dart';

class MonthlyCalendarView extends ConsumerWidget {
  const MonthlyCalendarView({super.key});

  // Skeleton cell (adapted to Shadcn UI style)
  Widget _buildShimmerCell(BuildContext context) {
    final theme = context.theme;
    return AspectRatio(
      aspectRatio: 1.0, // Keep square
      child: Container(
        margin: const EdgeInsets.all(1.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade200, // Use theme color
          borderRadius: theme.style.borderRadius, // Use theme border radius
        ),
      ),
    );
  }

  // Calendar skeleton
  Widget _buildCalendarSkeleton(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: GridView.count(
        crossAxisCount: 7,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.6,
        padding: EdgeInsets.zero,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        children: List.generate(35, (index) => _buildShimmerCell(context)),
      ),
    );
  }

  // Helper method: Get color for the bottom trend strip (logic similar to cell background)
  Color _getStripColorForHeatLevel(
    BuildContext context,
    ExpenseHeatLevel level,
  ) {
    final theme = context.theme;
    final colors = theme.colors;
    final isDark = colors.brightness == Brightness.dark;
    final baseHotColor = colors.primary;
    final baseColdBackgroundColor = colors.background; // Use background color

    switch (level) {
      case ExpenseHeatLevel.none: // Usually not shown in the trend strip
        return Colors.transparent;
      case ExpenseHeatLevel.low:
        return Color.alphaBlend(
          baseHotColor.withValues(alpha: isDark ? 0.15 : 0.12),
          baseColdBackgroundColor,
        );
      case ExpenseHeatLevel.medium:
        return Color.alphaBlend(
          baseHotColor.withValues(alpha: isDark ? 0.3 : 0.25),
          baseColdBackgroundColor,
        );
      case ExpenseHeatLevel.high:
        return Color.alphaBlend(
          baseHotColor.withValues(alpha: isDark ? 0.5 : 0.45),
          baseColdBackgroundColor,
        );
      case ExpenseHeatLevel.veryHigh:
        return baseHotColor.withValues(alpha: isDark ? 0.75 : 0.7);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.theme;
    final colors = theme.colors;

    final displayMonth = ref.watch(currentDisplayMonthProvider);
    final calendarDataAsyncValue = ref.watch(
      calendarMonthDataProvider(displayMonth),
    );
    final selectedDateState = ref.watch(selectedDateProvider);

    final now = DateTime.now();
    final nextMonthToDisplay = DateTime(
      displayMonth.year,
      displayMonth.month + 1,
      1,
    );
    final canNavigateToNextMonth =
        !(nextMonthToDisplay.year > now.year ||
            (nextMonthToDisplay.year == now.year &&
                nextMonthToDisplay.month > now.month));
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 4.0,
        bottom: 12.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t.calendar.title,
                  style: theme.typography.xl.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.foreground,
                  ),
                ),
                Row(
                  children: [
                    FButton.icon(
                      style: FButtonStyle.ghost(),
                      onPress: () {
                        ref
                            .read(currentDisplayMonthProvider.notifier)
                            .update(
                              (state) => DateTime(state.year, state.month - 1),
                            );
                      },
                      child: Icon(
                        FIcons.chevronLeft,
                        color: colors.primary,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      () {
                        final locale = LocaleSettings.currentLocale;
                        final (dateFormatLocale, pattern) = switch (locale) {
                          AppLocale.zh => ('zh_CN', 'yyyy年M月'),
                          AppLocale.en => ('en', 'yyyy MMM'),
                          AppLocale.ja => ('ja', 'yyyy年M月'),
                          AppLocale.ko => ('ko', 'yyyy년 M월'),
                          AppLocale.zhHant => ('zh_TW', 'yyyy年M月'),
                        };
                        return DateFormat(
                          pattern,
                          dateFormatLocale,
                        ).format(displayMonth);
                      }(),
                      style: theme.typography.sm.copyWith(
                        fontWeight: FontWeight.w500,
                        color: colors.foreground,
                      ),
                    ),
                    const SizedBox(width: 4),
                    FButton.icon(
                      style: FButtonStyle.ghost(),
                      onPress: canNavigateToNextMonth
                          ? () {
                              ref
                                  .read(currentDisplayMonthProvider.notifier)
                                  .update(
                                    (state) =>
                                        DateTime(state.year, state.month + 1),
                                  );
                            }
                          : null,
                      child: Icon(
                        FIcons.chevronRight,
                        color: canNavigateToNextMonth
                            ? colors.primary
                            : colors.mutedForeground,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 4. Weekday headers (using Shadcn UI text styles)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:
                  [
                        t.calendar.weekdays.mon,
                        t.calendar.weekdays.tue,
                        t.calendar.weekdays.wed,
                        t.calendar.weekdays.thu,
                        t.calendar.weekdays.fri,
                        t.calendar.weekdays.sat,
                        t.calendar.weekdays.sun,
                      ]
                      .map(
                        (day) => Text(
                          day,
                          style: theme.typography.sm.copyWith(
                            color: colors.mutedForeground,
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
          // 5. Date grid
          calendarDataAsyncValue.when(
            data: (calendarData) {
              final daysInMonth = DateUtils.getDaysInMonth(
                calendarData.year,
                calendarData.month,
              );
              final firstDayOfMonth = DateTime(
                calendarData.year,
                calendarData.month,
                1,
              );
              final firstWeekdayOfMonth = firstDayOfMonth.weekday;
              final daysToPadAtStart =
                  firstWeekdayOfMonth -
                  1; // Assume Monday (1) corresponds to index 0, Sunday (7) to index 6
              final List<Widget> dayWidgets = [];

              // Fill end of previous month
              for (int i = 0; i < daysToPadAtStart; i++) {
                final padDay = firstDayOfMonth.subtract(
                  Duration(days: daysToPadAtStart - i),
                );
                // Important: DailyCellWidget needs internal refactoring
                dayWidgets.add(
                  DailyCellWidget(day: padDay, isOutOfMonth: true),
                );
              }

              // Fill current month's dates
              for (int i = 0; i < daysInMonth; i++) {
                final day = DateTime(
                  calendarData.year,
                  calendarData.month,
                  i + 1,
                );
                final summary = calendarData.dailySummaries.firstWhere(
                  (s) => DateUtils.isSameDay(s.date, day),
                  orElse: () => DailyExpenseSummaryModel(
                    date: day,
                    totalExpense: 0,
                    heatLevel: ExpenseHeatLevel.none,
                  ),
                );
                // Important: DailyCellWidget needs internal refactoring
                dayWidgets.add(
                  DailyCellWidget(
                    day: day,
                    summary: summary,
                    isSelected:
                        selectedDateState != null &&
                        DateUtils.isSameDay(selectedDateState, day),
                    isToday: DateUtils.isSameDay(now, day),
                    onTap: () {
                      // 6. Popup replacement
                      final currentSelectedDateValue = ref.read(
                        selectedDateProvider,
                      );
                      if (currentSelectedDateValue != null &&
                          DateUtils.isSameDay(currentSelectedDateValue, day)) {
                        ref.read(selectedDateProvider.notifier).set(null);
                      } else {
                        ref.read(selectedDateProvider.notifier).set(day);
                      }
                    },
                  ),
                );
              }

              // Fill beginning of next month
              final totalCellsFilled = daysToPadAtStart + daysInMonth;
              final daysToPadAtEnd = (totalCellsFilled % 7 == 0)
                  ? 0
                  : 7 - (totalCellsFilled % 7);
              final DateTime firstDayOfNextCalendarMonth = DateTime(
                calendarData.year,
                calendarData.month + 1,
                1,
              );
              for (int i = 0; i < daysToPadAtEnd; i++) {
                final padDay = firstDayOfNextCalendarMonth.add(
                  Duration(days: i),
                );
                // Important: DailyCellWidget needs internal refactoring
                dayWidgets.add(
                  DailyCellWidget(day: padDay, isOutOfMonth: true),
                );
              }

              return GridView.count(
                crossAxisCount: 7,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.6,
                padding: EdgeInsets.zero,
                mainAxisSpacing: 2.0,
                // Can be adjusted based on ShadTheme
                crossAxisSpacing: 2.0,
                // Can be adjusted based on ShadTheme
                children: dayWidgets,
              );
            },
            loading: () => _buildCalendarSkeleton(context),
            error: (err, stack) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Center(
                child: Text(
                  t.calendar.loadFailed,
                  style: theme.typography.sm.copyWith(
                    color: colors.mutedForeground,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0), // Increase top spacing
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: calendarDataAsyncValue.when(
                    data: (calendarData) {
                      final locale = LocaleSettings.currentLocale;

                      // Use user preferred currency, instead of inferring from language
                      final currencyCode = ref
                          .watch(financialSettingsProvider)
                          .primaryCurrency;
                      final currency = Currency.fromCode(currencyCode);
                      final currencySymbol = currency?.symbol ?? '¥';

                      // Get locale based on language, not currency
                      final numberLocale = switch (locale) {
                        AppLocale.zh => 'zh_CN',
                        AppLocale.en => 'en_US',
                        AppLocale.ja => 'ja_JP',
                        AppLocale.ko => 'ko_KR',
                        AppLocale.zhHant => 'zh_TW',
                      };
                      final currencyFormat = NumberFormat.currency(
                        locale: numberLocale,
                        symbol: currencySymbol,
                        decimalDigits: 2,
                      );

                      // Get selected date (default today)
                      final targetDate = selectedDateState ?? now;

                      // Find expense for selected date
                      final selectedSummary = calendarData.dailySummaries
                          .firstWhere(
                            (s) => DateUtils.isSameDay(s.date, targetDate),
                            orElse: () => DailyExpenseSummaryModel(
                              date: targetDate,
                              totalExpense: 0,
                              heatLevel: ExpenseHeatLevel.none,
                            ),
                          );

                      // Format date display
                      final dateLabel = () {
                        if (DateUtils.isSameDay(targetDate, now)) {
                          return t.time.today;
                        }
                        // Format date based on language
                        final (dateFormatLocale, pattern) = switch (locale) {
                          AppLocale.zh => ('zh_CN', 'M月d日'),
                          AppLocale.en => ('en', 'MMM d'),
                          AppLocale.ja => ('ja', 'M月d日'),
                          AppLocale.ko => ('ko', 'M월 d일'),
                          AppLocale.zhHant => ('zh_TW', 'M月d日'),
                        };
                        return DateFormat(
                          pattern,
                          dateFormatLocale,
                        ).format(targetDate);
                      }();

                      return Text(
                        '$dateLabel: ${currencyFormat.format(selectedSummary.totalExpense)}',
                        style: theme.typography.sm.copyWith(
                          color: colors.mutedForeground,
                        ),
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                    loading: () => Text(
                      t.calendar.counting,
                      style: theme.typography.sm.copyWith(
                        color: colors.mutedForeground,
                      ),
                    ),
                    error: (error, stacktrace) => Text(
                      t.calendar.unableToCount,
                      style: theme.typography.sm.copyWith(
                        color: colors.mutedForeground,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      t.calendar.trend,
                      style: theme.typography.sm.copyWith(
                        color: colors.mutedForeground,
                      ),
                    ),
                    if (calendarDataAsyncValue.hasValue &&
                        calendarDataAsyncValue.value?.trendColors != null &&
                        calendarDataAsyncValue.value!.trendColors!.isNotEmpty)
                      ...calendarDataAsyncValue.value!.trendColors!.map((
                        hexColor,
                      ) {
                        try {
                          final colorValue = int.parse(
                            hexColor.startsWith('#')
                                ? hexColor.substring(1)
                                : hexColor,
                            radix: 16,
                          );
                          final color = Color(0xFF000000 | colorValue);
                          return Container(
                            width: 10,
                            height: 8,
                            margin: const EdgeInsets.only(left: 1.5),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: theme.style.borderRadius / 2,
                            ), // Use theme border radius
                          );
                        } catch (e) {
                          return const SizedBox.shrink();
                        }
                      })
                    else
                      ...ExpenseHeatLevel.values
                          .where((level) => level != ExpenseHeatLevel.none)
                          .map(
                            (level) => Container(
                              width: 10,
                              height: 8,
                              margin: const EdgeInsets.only(left: 1.5),
                              decoration: BoxDecoration(
                                color: _getStripColorForHeatLevel(
                                  context,
                                  level,
                                ),
                                // Adjust based on theme
                                borderRadius:
                                    theme.style.borderRadius /
                                    2, // Use theme border radius
                              ),
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
}
