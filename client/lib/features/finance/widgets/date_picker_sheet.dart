import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:augo/i18n/strings.g.dart';

/// 日期选择底部弹窗（使用 FCalendar）
class DatePickerSheet extends StatefulWidget {
  final DateTime initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String title;

  const DatePickerSheet({
    super.key,
    required this.initialDate,
    this.firstDate,
    this.lastDate,
    this.title = '',
  });

  /// 显示弹窗
  static Future<DateTime?> show(
    BuildContext context, {
    required DateTime initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    String title = '',
  }) {
    return showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DatePickerSheet(
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
        title: title,
      ),
    );
  }

  @override
  State<DatePickerSheet> createState() => _DatePickerSheetState();
}

class _DatePickerSheetState extends State<DatePickerSheet> {
  bool get isZh => LocaleSettings.currentLocale == AppLocale.zh;
  late DateTime _selectedDate;
  late FCalendarController<DateTime?> _controller;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _controller = FCalendarController.date(initialSelection: _selectedDate);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    return Container(
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
            // 标题栏
            _buildHeader(theme, colors),
            const SizedBox(height: 12),
            // 日历
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FCalendar(
                  controller: _controller,
                  start: widget.firstDate ?? DateTime(2020),
                  end: widget.lastDate ?? DateTime(2030),
                  today: DateTime.now(),
                  initialMonth: _selectedDate,
                  onPress: (date) {
                    setState(() => _selectedDate = date);
                  },
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
              widget.title.isNotEmpty ? widget.title : t.time.selectDate,
              textAlign: TextAlign.center,
              style: theme.typography.base.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.foreground,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(_selectedDate),
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
      child: FButton(
        onPress: () => Navigator.of(context).pop(_selectedDate),
        child: Text(
          isZh
              ? '选择 ${_selectedDate.year}/${_selectedDate.month}/${_selectedDate.day}'
              : 'Select ${_selectedDate.year}/${_selectedDate.month}/${_selectedDate.day}',
        ),
      ),
    );
  }
}
