import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:rrule/rrule.dart' as rrule_lib;
import 'package:augo/i18n/strings.g.dart';

/// 重复规则返回结果
class RecurrenceRuleResult {
  final String rule;
  final String description;
  final DateTime startDate;
  final DateTime? endDate;

  const RecurrenceRuleResult({
    required this.rule,
    required this.description,
    required this.startDate,
    this.endDate,
  });
}

/// 重复周期类型
enum RecurrenceFrequency {
  daily('天', 'DAILY'),
  weekly('周', 'WEEKLY'),
  monthly('月', 'MONTHLY'),
  yearly('年', 'YEARLY');

  final String zhLabel;
  final String rruleValue;

  const RecurrenceFrequency(this.zhLabel, this.rruleValue);

  String get label {
    final isZh = LocaleSettings.currentLocale == AppLocale.zh;
    if (isZh) return zhLabel;
    switch (this) {
      case daily:
        return 'Day';
      case weekly:
        return 'Week';
      case monthly:
        return 'Month';
      case yearly:
        return 'Year';
    }
  }
}

/// 星期几
enum Weekday {
  monday('一', 'MO', 1),
  tuesday('二', 'TU', 2),
  wednesday('三', 'WE', 3),
  thursday('四', 'TH', 4),
  friday('五', 'FR', 5),
  saturday('六', 'SA', 6),
  sunday('日', 'SU', 7);

  final String zhLabel;
  final String rruleValue;
  final int isoWeekday;

  const Weekday(this.zhLabel, this.rruleValue, this.isoWeekday);

  String get label {
    final isZh = LocaleSettings.currentLocale == AppLocale.zh;
    if (isZh) return zhLabel;
    switch (this) {
      case monday:
        return 'Mon';
      case tuesday:
        return 'Tue';
      case wednesday:
        return 'Wed';
      case thursday:
        return 'Thu';
      case friday:
        return 'Fri';
      case saturday:
        return 'Sat';
      case sunday:
        return 'Sun';
    }
  }
}

/// 重复规则设置底部弹窗
class RecurrenceRuleSheet extends StatefulWidget {
  final DateTime initialStartDate;
  final String? initialRule;

  const RecurrenceRuleSheet({
    super.key,
    required this.initialStartDate,
    this.initialRule,
  });

  /// 显示弹窗
  static Future<RecurrenceRuleResult?> show(
    BuildContext context, {
    required DateTime initialStartDate,
    String? initialRule,
  }) {
    return showModalBottomSheet<RecurrenceRuleResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RecurrenceRuleSheet(
        initialStartDate: initialStartDate,
        initialRule: initialRule,
      ),
    );
  }

  @override
  State<RecurrenceRuleSheet> createState() => _RecurrenceRuleSheetState();
}

class _RecurrenceRuleSheetState extends State<RecurrenceRuleSheet> {
  bool get isZh => LocaleSettings.currentLocale == AppLocale.zh;

  // 当前选中的周期类型
  RecurrenceFrequency _frequency = RecurrenceFrequency.monthly;

  // 重复间隔
  int _interval = 1;

  // 开始日期
  late DateTime _startDate;

  // 结束日期（可选）
  DateTime? _endDate;
  bool _hasEndDate = false;

  // 按周时选中的星期
  final Set<Weekday> _selectedWeekdays = {};

  // 按月时选中的日期
  int _monthDay = 1;

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialStartDate;
    _monthDay = _startDate.day;

    // 解析初始规则（如果有）
    if (widget.initialRule != null) {
      _parseInitialRule(widget.initialRule!);
    } else {
      // 默认选中当前星期
      final today = DateTime.now().weekday;
      final weekday = Weekday.values.firstWhere((w) => w.isoWeekday == today);
      _selectedWeekdays.add(weekday);
    }
  }

  void _parseInitialRule(String rule) {
    // 使用 rrule 库解析
    final ruleString = rule.startsWith('RRULE:') ? rule : 'RRULE:$rule';
    final rrule = rrule_lib.RecurrenceRule.fromString(ruleString);

    // 解析频率
    switch (rrule.frequency) {
      case rrule_lib.Frequency.daily:
        _frequency = RecurrenceFrequency.daily;
      case rrule_lib.Frequency.weekly:
        _frequency = RecurrenceFrequency.weekly;
      case rrule_lib.Frequency.monthly:
        _frequency = RecurrenceFrequency.monthly;
      case rrule_lib.Frequency.yearly:
        _frequency = RecurrenceFrequency.yearly;
      default:
        _frequency = RecurrenceFrequency.monthly;
    }

    // 解析间隔
    _interval = rrule.interval ?? 1;

    // 解析星期 (BYDAY)
    if (rrule.byWeekDays.isNotEmpty) {
      _selectedWeekdays.clear();
      for (final entry in rrule.byWeekDays) {
        final weekday = _getWeekdayFromDartWeekday(entry.day);
        if (weekday != null) {
          _selectedWeekdays.add(weekday);
        }
      }
    }

    // 解析月日 (BYMONTHDAY)
    if (rrule.byMonthDays.isNotEmpty) {
      _monthDay = rrule.byMonthDays.first;
    }

    // 解析结束日期 (UNTIL)
    if (rrule.until != null) {
      _hasEndDate = true;
      _endDate = rrule.until;
    }
  }

  /// 从 Dart 的 weekday 转换为 Weekday 枚举
  Weekday? _getWeekdayFromDartWeekday(int dartWeekday) {
    return Weekday.values.cast<Weekday?>().firstWhere(
      (w) => w?.isoWeekday == dartWeekday,
      orElse: () => null,
    );
  }

  String _buildRruleString() {
    final parts = <String>['FREQ=${_frequency.rruleValue}'];

    if (_interval > 1) {
      parts.add('INTERVAL=$_interval');
    }

    switch (_frequency) {
      case RecurrenceFrequency.weekly:
        if (_selectedWeekdays.isNotEmpty) {
          final days = _selectedWeekdays.map((w) => w.rruleValue).join(',');
          parts.add('BYDAY=$days');
        }
      case RecurrenceFrequency.monthly:
        parts.add('BYMONTHDAY=$_monthDay');
      default:
        break;
    }

    if (_hasEndDate && _endDate != null) {
      final until = _endDate!
          .toUtc()
          .toIso8601String()
          .replaceAll('-', '')
          .replaceAll(':', '')
          .split('.')[0];
      parts.add('UNTIL=${until}Z');
    }

    return parts.join(';');
  }

  String _buildDescription() {
    final buffer = StringBuffer();

    if (isZh) {
      switch (_frequency) {
        case RecurrenceFrequency.daily:
          if (_interval == 1) {
            buffer.write('每天');
          } else {
            buffer.write('每 $_interval 天');
          }
        case RecurrenceFrequency.weekly:
          if (_interval == 1) {
            buffer.write('每周');
          } else {
            buffer.write('每 $_interval 周');
          }
          if (_selectedWeekdays.isNotEmpty) {
            final sortedDays = _selectedWeekdays.toList()
              ..sort((a, b) => a.isoWeekday.compareTo(b.isoWeekday));
            buffer.write('的');
            buffer.write(sortedDays.map((w) => '周${w.zhLabel}').join('、'));
          }
        case RecurrenceFrequency.monthly:
          if (_interval == 1) {
            buffer.write('每月 $_monthDay 号');
          } else {
            buffer.write('每 $_interval 个月的 $_monthDay 号');
          }
        case RecurrenceFrequency.yearly:
          if (_interval == 1) {
            buffer.write('每年');
          } else {
            buffer.write('每 $_interval 年');
          }
          buffer.write(' ${_startDate.month}/${_startDate.day}');
      }
    } else {
      // English descriptions
      switch (_frequency) {
        case RecurrenceFrequency.daily:
          if (_interval == 1) {
            buffer.write('Daily');
          } else {
            buffer.write('Every $_interval days');
          }
        case RecurrenceFrequency.weekly:
          if (_interval == 1) {
            buffer.write('Weekly');
          } else {
            buffer.write('Every $_interval weeks');
          }
          if (_selectedWeekdays.isNotEmpty) {
            final sortedDays = _selectedWeekdays.toList()
              ..sort((a, b) => a.isoWeekday.compareTo(b.isoWeekday));
            buffer.write(' on ');
            buffer.write(sortedDays.map((w) => w.label).join(', '));
          }
        case RecurrenceFrequency.monthly:
          final daySuffix = _getDaySuffix(_monthDay);
          if (_interval == 1) {
            buffer.write('Monthly on the $_monthDay$daySuffix');
          } else {
            buffer.write('Every $_interval months on the $_monthDay$daySuffix');
          }
        case RecurrenceFrequency.yearly:
          if (_interval == 1) {
            buffer.write('Yearly');
          } else {
            buffer.write('Every $_interval years');
          }
          buffer.write(' on ${_startDate.month}/${_startDate.day}');
      }
    }

    return buffer.toString();
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // 拖动条
            Container(
              width: 32,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // 标题栏
            _buildHeader(theme, colors),
            const SizedBox(height: 16),
            // 内容区域
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 周期类型切换
                    _buildFrequencySelector(theme, colors),
                    const SizedBox(height: 24),
                    // 重复间隔
                    _buildIntervalSection(theme, colors),
                    const SizedBox(height: 24),
                    // 周期特定选项
                    _buildFrequencySpecificOptions(theme, colors),
                    const SizedBox(height: 24),
                    // 结束日期
                    _buildEndDateSection(theme, colors),
                    const SizedBox(height: 24),
                    // 规则预览
                    _buildRulePreview(theme, colors),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            // 底部按钮
            _buildBottomBar(theme, colors),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(FThemeData theme, FColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Text(
              t.common.cancel,
              style: theme.typography.base.copyWith(
                color: colors.mutedForeground,
              ),
            ),
          ),
          Expanded(
            child: Text(
              t.budget.period,
              textAlign: TextAlign.center,
              style: theme.typography.base.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.foreground,
              ),
            ),
          ),
          GestureDetector(
            onTap: _handleConfirm,
            child: Text(
              t.common.ok,
              style: theme.typography.base.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 周期类型切换 - 使用 FTabs 组件
  Widget _buildFrequencySelector(FThemeData theme, FColors colors) {
    return FTabs(
      initialIndex: RecurrenceFrequency.values.indexOf(_frequency),
      onPress: (index) {
        setState(() => _frequency = RecurrenceFrequency.values[index]);
      },
      children: RecurrenceFrequency.values.map((freq) {
        return FTabEntry(
          label: Text(freq.label),
          child: const SizedBox.shrink(), // 不需要显示内容区域
        );
      }).toList(),
    );
  }

  /// 重复间隔 - 一行式设计（参考图片）
  Widget _buildIntervalSection(FThemeData theme, FColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // 左侧标签
          Text(
            isZh ? '重复间隔' : 'Interval',
            style: theme.typography.sm.copyWith(color: colors.foreground),
          ),
          const Spacer(),
          // 右侧：- 数字 周期 +
          // 减少按钮
          GestureDetector(
            onTap: () {
              if (_interval > 1) {
                setState(() => _interval--);
              }
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: colors.border),
              ),
              child: Center(
                child: Icon(
                  Icons.remove,
                  size: 16,
                  color: _interval > 1
                      ? colors.foreground
                      : colors.mutedForeground,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // 数字 + 周期单位
          Text(
            '$_interval ${isZh ? _frequency.label : (_frequency.label + (_interval > 1 ? 's' : ''))}',
            style: theme.typography.base.copyWith(
              fontWeight: FontWeight.w600,
              color: colors.foreground,
            ),
          ),
          const SizedBox(width: 16),
          // 增加按钮
          GestureDetector(
            onTap: () => setState(() => _interval++),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: colors.border),
              ),
              child: Center(
                child: Icon(Icons.add, size: 16, color: colors.foreground),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 周期特定选项
  Widget _buildFrequencySpecificOptions(FThemeData theme, FColors colors) {
    switch (_frequency) {
      case RecurrenceFrequency.weekly:
        return _buildWeekdaySelector(theme, colors);
      case RecurrenceFrequency.monthly:
        return _buildMonthDayInfo(theme, colors);
      default:
        return const SizedBox.shrink();
    }
  }

  /// 星期选择器
  Widget _buildWeekdaySelector(FThemeData theme, FColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isZh ? '选择星期' : 'Select Days',
          style: theme.typography.sm.copyWith(
            color: colors.mutedForeground,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: Weekday.values.map((weekday) {
            final isSelected = _selectedWeekdays.contains(weekday);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedWeekdays.remove(weekday);
                  } else {
                    _selectedWeekdays.add(weekday);
                  }
                });
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected ? colors.primary : colors.muted,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    weekday.label,
                    style: theme.typography.sm.copyWith(
                      color: isSelected
                          ? colors.primaryForeground
                          : colors.foreground,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// 月日信息（只读，从开始日期获取）
  Widget _buildMonthDayInfo(FThemeData theme, FColors colors) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(FIcons.calendarDays, size: 20, color: colors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isZh
                  ? '将在每月 ${_startDate.day} 号执行（基于开始日期）'
                  : 'Will execute on the ${_startDate.day}${_getDaySuffix(_startDate.day)} of each month (based on start date)',
              style: theme.typography.sm.copyWith(color: colors.foreground),
            ),
          ),
        ],
      ),
    );
  }

  /// 结束日期
  Widget _buildEndDateSection(FThemeData theme, FColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.dateRange.endDate,
          style: theme.typography.sm.copyWith(
            color: colors.mutedForeground,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.border),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      isZh ? '设置结束日期' : 'Set End Date',
                      style: theme.typography.sm.copyWith(
                        color: colors.foreground,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  FSwitch(
                    value: _hasEndDate,
                    onChange: (value) {
                      setState(() {
                        _hasEndDate = value;
                        if (value && _endDate == null) {
                          _endDate = _startDate.add(const Duration(days: 365));
                        }
                      });
                    },
                  ),
                ],
              ),
              if (_hasEndDate) ...[
                const SizedBox(height: 12),
                // 点击选择结束日期
                GestureDetector(
                  onTap: () => _showEndDatePicker(theme, colors),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: colors.muted,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          FIcons.calendar,
                          size: 20,
                          color: colors.mutedForeground,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _endDate != null
                                ? '${_endDate!.year}/${_endDate!.month}/${_endDate!.day}'
                                : (isZh ? '选择结束日期' : 'Select End Date'),
                            style: theme.typography.sm.copyWith(
                              color: _endDate != null
                                  ? colors.foreground
                                  : colors.mutedForeground,
                            ),
                          ),
                        ),
                        Icon(
                          FIcons.chevronRight,
                          size: 16,
                          color: colors.mutedForeground,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  /// 规则预览
  Widget _buildRulePreview(FThemeData theme, FColors colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(FIcons.repeat, size: 18, color: colors.primary),
              const SizedBox(width: 8),
              Text(
                isZh ? '规则预览' : 'Preview',
                style: theme.typography.sm.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _buildDescription(),
            style: theme.typography.base.copyWith(
              color: colors.foreground,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// 显示结束日期选择器（使用 FCalendar）
  void _showEndDatePicker(FThemeData theme, FColors colors) {
    final now = DateTime.now();
    final controller = FCalendarController.date(
      initialSelection: _endDate ?? _startDate.add(const Duration(days: 365)),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.55,
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 拖动条
              Container(
                width: 32,
                height: 4,
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                decoration: BoxDecoration(
                  color: colors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // 标题
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Text(
                      t.dateRange.endDate,
                      style: theme.typography.base.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.foreground,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        FIcons.x,
                        size: 20,
                        color: colors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // 日历
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: FCalendar(
                    controller: controller,
                    start: now,
                    end: now.add(const Duration(days: 365 * 10)),
                    today: now,
                    onPress: (date) {
                      setState(() => _endDate = date);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 底部按钮栏
  Widget _buildBottomBar(FThemeData theme, FColors colors) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: colors.background,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: FButton(onPress: _handleConfirm, child: Text(t.common.ok)),
    );
  }

  void _handleConfirm() {
    // 根据规则计算正确的开始日期
    final adjustedStartDate = _calculateAdjustedStartDate();

    Navigator.of(context).pop(
      RecurrenceRuleResult(
        rule: _buildRruleString(),
        description: _buildDescription(),
        startDate: adjustedStartDate,
        endDate: _hasEndDate ? _endDate : null,
      ),
    );
  }

  /// 根据当前规则计算合理的开始日期
  ///
  /// 如果用户选择"每月8号"，但当前日期是15号，
  /// 则开始日期应该是下个月8号（第一次执行的日期）
  DateTime _calculateAdjustedStartDate() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (_frequency) {
      case RecurrenceFrequency.monthly:
        // 计算下一个 _monthDay 号
        DateTime targetDate = DateTime(
          _startDate.year,
          _startDate.month,
          _monthDay,
        );

        // 如果目标日期已过，移到下个月
        if (targetDate.isBefore(today)) {
          targetDate = DateTime(
            _startDate.year,
            _startDate.month + 1,
            _monthDay,
          );
        }
        return targetDate;

      case RecurrenceFrequency.weekly:
        // 计算下一个选中的星期几
        if (_selectedWeekdays.isNotEmpty) {
          final sortedDays = _selectedWeekdays.toList()
            ..sort((a, b) => a.isoWeekday.compareTo(b.isoWeekday));

          // 找到下一个符合条件的星期
          for (int i = 0; i < 7; i++) {
            final checkDate = today.add(Duration(days: i));
            if (sortedDays.any((w) => w.isoWeekday == checkDate.weekday)) {
              return checkDate;
            }
          }
        }
        return _startDate;

      case RecurrenceFrequency.daily:
        // 每天执行，从今天或用户选择的日期开始
        return _startDate.isBefore(today) ? today : _startDate;

      case RecurrenceFrequency.yearly:
        // 每年执行
        DateTime targetDate = DateTime(
          _startDate.year,
          _startDate.month,
          _startDate.day,
        );
        if (targetDate.isBefore(today)) {
          targetDate = DateTime(
            _startDate.year + 1,
            _startDate.month,
            _startDate.day,
          );
        }
        return targetDate;
    }
  }
}
