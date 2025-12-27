import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:augo/i18n/strings.g.dart';
import 'package:augo/shared/models/currency.dart';

class CurrencySelectionSheet extends StatefulWidget {
  final String initialCurrency;

  const CurrencySelectionSheet({super.key, required this.initialCurrency});

  static Future<String?> show(BuildContext context, String currentCurrency) {
    return showFDialog(
      context: context,
      builder: (context, style, animation) =>
          CurrencySelectionSheet(initialCurrency: currentCurrency),
    );
  }

  @override
  State<CurrencySelectionSheet> createState() => _CurrencySelectionSheetState();
}

class _CurrencySelectionSheetState extends State<CurrencySelectionSheet> {
  late FPickerController _controller;

  @override
  void initState() {
    super.initState();
    final initialCurrency =
        Currency.fromCode(widget.initialCurrency) ?? Currency.cny;
    final initialIndex = Currency.values.indexOf(initialCurrency);
    _controller = FPickerController(
      initialIndexes: [initialIndex >= 0 ? initialIndex : 0],
    );
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

    return FDialog.raw(
      builder: (context, style) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              t.financial.selectCurrency,
              style: theme.typography.lg.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.foreground,
              ),
            ),
          ),

          // Picker
          SizedBox(
            height: 200,
            child: FPicker(
              controller: _controller,
              children: [
                FPickerWheel(
                  loop: true,
                  children: Currency.values.map((currency) {
                    return Center(
                      child: Text(
                        '${currency.code}  ${currency.localizedName}',
                        style: theme.typography.base.copyWith(
                          color: colors.foreground,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // Actions
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: FButton(
                    style: FButtonStyle.outline(),
                    onPress: () => Navigator.pop(context),
                    child: Text(t.financial.cancel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FButton(
                    onPress: () {
                      final selectedIndex = _controller.value[0];
                      final safeIndex = selectedIndex % Currency.values.length;
                      Navigator.pop(context, Currency.values[safeIndex].code);
                    },
                    child: Text(t.financial.confirm),
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
