import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:intl/intl.dart';
import '../../../i18n/strings.g.dart';

class DateRangePickerSheet extends StatefulWidget {
  final DateTime? initialStart;
  final DateTime? initialEnd;
  final void Function(DateTime start, DateTime end) onConfirm;

  const DateRangePickerSheet({
    super.key,
    this.initialStart,
    this.initialEnd,
    required this.onConfirm,
  });

  /// 显示日期范围选择器
  static Future<void> show(
    BuildContext context, {
    DateTime? initialStart,
    DateTime? initialEnd,
    required void Function(DateTime start, DateTime end) onConfirm,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DateRangePickerSheet(
        initialStart: initialStart,
        initialEnd: initialEnd,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<DateRangePickerSheet> createState() => _DateRangePickerSheetState();
}

class _DateRangePickerSheetState extends State<DateRangePickerSheet> {
  late final FCalendarController<(DateTime, DateTime)?> _controller;

  @override
  void initState() {
    super.initState();
    _controller = FCalendarController.range(
      initialSelection: widget.initialStart != null && widget.initialEnd != null
          ? (widget.initialStart!, widget.initialEnd!)
          : null,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDateRange((DateTime, DateTime)? range) {
    if (range == null) return t.dateRange.hint;
    final format = DateFormat('yyyy.MM.dd');
    return '${format.format(range.$1)} - ${format.format(range.$2)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(theme.style.borderRadius.topLeft.x),
          topRight: Radius.circular(theme.style.borderRadius.topRight.x),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 拖动指示器
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colors.muted,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // 标题
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t.dateRange.pickerTitle,
                  style: theme.typography.lg.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                FButton.icon(
                  style: FButtonStyle.ghost(),
                  onPress: () => Navigator.pop(context),
                  child: Icon(FIcons.x, color: colors.foreground),
                ),
              ],
            ),
          ),
          ListenableBuilder(
            listenable: _controller,
            builder: (context, _) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.muted,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(FIcons.calendar, size: 16, color: colors.foreground),
                    const SizedBox(width: 8),
                    Text(
                      _formatDateRange(_controller.value),
                      style: theme.typography.sm.copyWith(
                        color: colors.foreground,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FCalendar(
              controller: _controller,
              start: DateTime.now().subtract(const Duration(days: 365 * 2)),
              end: DateTime.now(),
              today: DateTime.now(),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).padding.bottom + 16,
            ),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: FButton(
                      style: FButtonStyle.outline(),
                      onPress: () {
                        setState(() {
                          _controller.value = null;
                        });
                      },
                      child: Text(t.common.reset),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: ListenableBuilder(
                      listenable: _controller,
                      builder: (context, _) {
                        final hasSelection = _controller.value != null;
                        return FButton(
                          onPress: hasSelection
                              ? () {
                                  final range = _controller.value;
                                  if (range != null) {
                                    Navigator.pop(context);
                                    widget.onConfirm(range.$1, range.$2);
                                  }
                                }
                              : null,
                          child: Text(t.common.confirm),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
