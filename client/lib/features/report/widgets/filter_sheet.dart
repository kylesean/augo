import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import '../../../i18n/strings.g.dart';
import '../../../shared/widgets/app_filter_chip.dart';

/// Filter bottom sheet for account type selection
class FilterSheet extends StatefulWidget {
  final List<String> selectedAccountTypes;
  final ValueChanged<List<String>> onApply;

  const FilterSheet({
    super.key,
    required this.selectedAccountTypes,
    required this.onApply,
  });

  static Future<void> show(
    BuildContext context, {
    required List<String> selectedAccountTypes,
    required ValueChanged<List<String>> onApply,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterSheet(
        selectedAccountTypes: selectedAccountTypes,
        onApply: onApply,
      ),
    );
  }

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late List<String> _selectedTypes;

  // Account type options
  // Account type options
  List<({String key, String label, IconData icon})> get _accountTypes => [
    (key: 'CASH', label: t.account.cash, icon: FIcons.banknote),
    (key: 'DEPOSIT', label: t.account.deposit, icon: FIcons.creditCard),
    (key: 'CREDIT_CARD', label: t.account.creditCard, icon: FIcons.wallet),
    (key: 'INVESTMENT', label: t.account.investment, icon: FIcons.trendingUp),
    (key: 'E_WALLET', label: t.account.eWallet, icon: FIcons.smartphone),
    (key: 'LOAN', label: t.account.loan, icon: FIcons.landmark),
  ];

  @override
  void initState() {
    super.initState();
    _selectedTypes = List.from(widget.selectedAccountTypes);
  }

  void _toggleType(String type) {
    setState(() {
      if (_selectedTypes.contains(type)) {
        _selectedTypes.remove(type);
      } else {
        _selectedTypes.add(type);
      }
    });
  }

  void _selectAll() {
    setState(() {
      _selectedTypes.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: colors.muted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.common.filter,
                    style: theme.typography.lg.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
            const Divider(height: 1),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.statistics.filter.accountType,
                    style: theme.typography.sm.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 10,
                    children: [
                      // "All" chip
                      AppFilterChip(
                        label: t.statistics.filter.allAccounts,
                        isSelected: _selectedTypes.isEmpty,
                        onTap: _selectAll,
                      ),
                      // Account type chips
                      ..._accountTypes.map((type) {
                        final isSelected = _selectedTypes.contains(type.key);
                        return AppFilterChip(
                          label: type.label,
                          icon: type.icon,
                          isSelected: isSelected,
                          onTap: () => _toggleType(type.key),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
            // Apply button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 40,
                child: FButton(
                  onPress: () {
                    widget.onApply(_selectedTypes);
                    Navigator.pop(context);
                  },
                  child: Text(t.statistics.filter.apply),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
