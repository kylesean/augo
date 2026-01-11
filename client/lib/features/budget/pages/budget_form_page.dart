import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

import '../../../core/constants/category_constants.dart';
import '../../../core/widgets/top_toast.dart';
import '../../finance/widgets/category_selection_sheet.dart';
import '../../finance/models/recurring_transaction.dart';
import '../../profile/providers/financial_settings_provider.dart';
import '../../../shared/models/currency.dart';
import '../models/budget_models.dart';
import '../providers/budget_provider.dart';
import '../services/budget_service.dart';
import 'package:augo/i18n/strings.g.dart';
import '../../../shared/widgets/app_filter_chip.dart';

class BudgetFormPage extends ConsumerStatefulWidget {
  final String? editId;

  const BudgetFormPage({super.key, this.editId});

  @override
  ConsumerState<BudgetFormPage> createState() => _BudgetFormPageState();
}

class _BudgetFormPageState extends ConsumerState<BudgetFormPage> {
  BudgetScope _scope = BudgetScope.total;

  final _amountController = TextEditingController(text: '');

  BudgetPeriodType _periodType = BudgetPeriodType.monthly;

  int _periodAnchorDay = 1;

  bool _rolloverEnabled = true;

  TransactionCategory _category = TransactionCategory.expenseCategories.first;

  final _nameController = TextEditingController();

  bool _isSaving = false;

  bool _isLoadingEdit = false;

  late FPickerController _periodPickerController;
  late FPickerController _anchorDayPickerController;

  @override
  void initState() {
    super.initState();
    _periodPickerController = FPickerController(initialIndexes: [2]);
    _anchorDayPickerController = FPickerController(initialIndexes: [0]);

    if (widget.editId != null) {
      unawaited(_loadEditData());
    }
  }

  Future<void> _loadEditData() async {
    setState(() => _isLoadingEdit = true);
    try {
      final service = ref.read(budgetServiceProvider);
      final budget = await service.getById(widget.editId!);

      if (mounted) {
        setState(() {
          // Destructure budget into form fields
          _scope = budget.scope;
          _amountController.text = budget.amount.toString();
          _periodType = budget.periodType;
          _rolloverEnabled = budget.rolloverEnabled;
          _nameController.text = budget.displayName;

          if (budget.categoryKey != null) {
            _category = TransactionCategory.fromKey(budget.categoryKey!);
          }
          final periodIndex = BudgetPeriodType.values.indexOf(_periodType);
          _periodPickerController.dispose();
          _periodPickerController = FPickerController(
            initialIndexes: [periodIndex >= 0 ? periodIndex : 2],
          );

          _isLoadingEdit = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingEdit = false);
        TopToast.error(context, '${t.budget.loadFailed}: $e');
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _nameController.dispose();
    _periodPickerController.dispose();
    _anchorDayPickerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    if (_isLoadingEdit) {
      return Scaffold(
        backgroundColor: colors.background,
        appBar: _buildAppBar(theme, colors),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: colors.background,
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(theme, colors),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildScopeSelector(theme, colors),
              const SizedBox(height: 24),

              _buildAmountSection(theme, colors),
              const SizedBox(height: 24),

              if (_scope == BudgetScope.category) ...[
                _buildCategorySection(theme, colors),
                const SizedBox(height: 24),
              ],
              _buildPeriodSection(theme, colors),
              const SizedBox(height: 24),
              _buildAdvancedOptions(theme, colors),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(theme, colors),
    );
  }

  PreferredSizeWidget _buildAppBar(FThemeData theme, FColors colors) {
    return AppBar(
      backgroundColor: colors.background,
      elevation: 0,
      leading: IconButton(
        icon: Icon(FIcons.arrowBigLeft, color: colors.foreground, size: 20),
        onPressed: () => context.pop(),
      ),
      title: Text(
        widget.editId != null ? t.budget.editBudget : t.budget.newBudget,
        style: theme.typography.lg.copyWith(
          fontWeight: FontWeight.w600,
          color: colors.foreground,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildScopeSelector(FThemeData theme, FColors colors) {
    if (widget.editId != null) {
      return Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: colors.muted,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              _scope == BudgetScope.total ? FIcons.wallet : FIcons.layers,
              color: colors.primary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              _scope == BudgetScope.total
                  ? t.budget.totalBudget
                  : t.budget.categoryBudget,
              style: theme.typography.base.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.foreground,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: AppFilterChip(
                label: t.budget.totalBudget,
                isSelected: _scope == BudgetScope.total,
                onTap: () => setState(() => _scope = BudgetScope.total),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: AppFilterChip(
                label: t.budget.categoryBudget,
                isSelected: _scope == BudgetScope.category,
                onTap: () => setState(() => _scope = BudgetScope.category),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountSection(FThemeData theme, FColors colors) {
    final amountFontSize = theme.typography.xl2.fontSize ?? 24.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.budget.budgetAmountLabel,
          style: theme.typography.sm.copyWith(
            color: colors.mutedForeground,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: colors.border, width: 1)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Currency symbol - follows global settings
              Text(
                Currency.fromCode(
                      ref.watch(financialSettingsProvider).primaryCurrency,
                    )?.symbol ??
                    '¥',
                style: TextStyle(
                  fontSize: amountFontSize,
                  color: colors.mutedForeground,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: amountFontSize,
                    color: colors.foreground,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                  cursorColor: colors.primary,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                    isCollapsed: true,
                    hintText: '0.00',
                    hintStyle: TextStyle(
                      fontSize: amountFontSize,
                      color: colors.mutedForeground,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
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

  Widget _buildCategorySection(FThemeData theme, FColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.budget.budgetCategory,
          style: theme.typography.sm.copyWith(
            color: colors.mutedForeground,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _showCategoryPicker,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _category.themedColor(theme).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _category.icon,
                    color: _category.themedColor(theme),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _category.displayText,
                    style: theme.typography.base.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colors.foreground,
                    ),
                  ),
                ),
                Icon(FIcons.chevronRight, color: colors.mutedForeground),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodSection(FThemeData theme, FColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.budget.periodSettings,
          style: theme.typography.sm.copyWith(
            color: colors.mutedForeground,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.border),
          ),
          child: Column(
            children: [
              // Period type
              InkWell(
                onTap: _showPeriodTypePicker,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        FIcons.calendarClock,
                        size: 22,
                        color: colors.mutedForeground,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.budget.periodType,
                              style: theme.typography.xs.copyWith(
                                color: colors.mutedForeground,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _periodType.label,
                              style: theme.typography.sm.copyWith(
                                color: colors.foreground,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        FIcons.chevronRight,
                        size: 20,
                        color: colors.mutedForeground,
                      ),
                    ],
                  ),
                ),
              ),
              if (_periodType == BudgetPeriodType.monthly) ...[
                Divider(height: 1, color: colors.border),
                InkWell(
                  onTap: _showAnchorDayPicker,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          FIcons.calendar,
                          size: 22,
                          color: colors.mutedForeground,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t.budget.anchorDay,
                                style: theme.typography.xs.copyWith(
                                  color: colors.mutedForeground,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                t.budget.everyMonthDay(
                                  day: _periodAnchorDay.toString(),
                                ),
                                style: theme.typography.sm.copyWith(
                                  color: colors.foreground,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          FIcons.chevronRight,
                          size: 20,
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

  Widget _buildAdvancedOptions(FThemeData theme, FColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.budget.advancedOptions,
          style: theme.typography.sm.copyWith(
            color: colors.mutedForeground,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.border),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(FIcons.repeat, size: 22, color: colors.mutedForeground),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.budget.rollover,
                        style: theme.typography.sm.copyWith(
                          color: colors.foreground,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        t.budget.rolloverDescription,
                        style: theme.typography.xs.copyWith(
                          color: colors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
                FSwitch(
                  value: _rolloverEnabled,
                  onChange: (value) {
                    setState(() => _rolloverEnabled = value);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(FThemeData theme, FColors colors) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.background,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: SafeArea(
        child: FButton(
          onPress: _isSaving ? null : _handleSave,
          child: _isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  widget.editId != null ? t.budget.save : t.budget.createBudget,
                ),
        ),
      ),
    );
  }

  Future<void> _showCategoryPicker() async {
    final result = await CategorySelectionSheet.show(
      context,
      selectedCategory: _category,
      transactionType: RecurringTransactionType
          .expense, // Budget is only for expense categories
    );
    if (result != null && mounted) {
      setState(() => _category = result.category);
    }
  }

  Future<void> _showPeriodTypePicker() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _PeriodTypePicker(
        selectedType: _periodType,
        onSelected: (type) {
          setState(() => _periodType = type);
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> _showAnchorDayPicker() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AnchorDayPicker(
        selectedDay: _periodAnchorDay,
        onSelected: (day) {
          setState(() => _periodAnchorDay = day);
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> _handleSave() async {
    final amountText = _amountController.text.trim();
    if (amountText.isEmpty) {
      TopToast.error(context, t.budget.pleaseEnterAmount);
      return;
    }

    final amount = Decimal.tryParse(amountText);
    if (amount == null || amount <= Decimal.zero) {
      TopToast.error(context, t.budget.invalidAmount);
      return;
    }

    setState(() => _isSaving = true);

    try {
      final service = ref.read(budgetServiceProvider);

      if (widget.editId != null) {
        // Update budget
        final request = BudgetUpdateRequest(
          name: _nameController.text.isNotEmpty ? _nameController.text : null,
          amount: amount,
          rolloverEnabled: _rolloverEnabled,
        );
        await service.update(widget.editId!, request);
        if (mounted) TopToast.success(context, t.budget.updateSuccess);
      } else {
        // Create budget
        final request = BudgetCreateRequest(
          scope: _scope,
          categoryKey: _scope == BudgetScope.category ? _category.key : null,
          amount: amount,
          periodType: _periodType,
          periodAnchorDay: _periodAnchorDay,
          rolloverEnabled: _rolloverEnabled,
          name: _nameController.text.isNotEmpty
              ? _nameController.text
              : (_scope == BudgetScope.category
                    ? _category.displayText
                    : t.budget.totalBudget),
        );
        await service.create(request);
        if (mounted) TopToast.success(context, t.budget.createSuccess);
      }

      // Refresh budget list
      await ref.read(budgetSummaryProvider.notifier).refresh();

      if (mounted) {
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        TopToast.error(context, '${t.budget.operationFailed}: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}

class _PeriodTypePicker extends StatelessWidget {
  final BudgetPeriodType selectedType;
  final ValueChanged<BudgetPeriodType> onSelected;

  const _PeriodTypePicker({
    required this.selectedType,
    required this.onSelected,
  });

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
            Container(
              width: 32,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              t.budget.selectPeriodType,
              style: theme.typography.base.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.foreground,
              ),
            ),
            const SizedBox(height: 16),
            ...BudgetPeriodType.values.map((type) {
              final isSelected = type == selectedType;
              return ListTile(
                leading: Icon(
                  isSelected ? FIcons.check : FIcons.calendarDays,
                  color: isSelected ? colors.primary : colors.mutedForeground,
                ),
                title: Text(
                  type.label,
                  style: theme.typography.sm.copyWith(
                    color: colors.foreground,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                onTap: () => onSelected(type),
              );
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _AnchorDayPicker extends StatefulWidget {
  final int selectedDay;
  final ValueChanged<int> onSelected;

  const _AnchorDayPicker({required this.selectedDay, required this.onSelected});

  @override
  State<_AnchorDayPicker> createState() => _AnchorDayPickerState();
}

class _AnchorDayPickerState extends State<_AnchorDayPicker> {
  late FPickerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FPickerController(initialIndexes: [widget.selectedDay - 1]);
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
      height: 360,
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: 32,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              t.budget.selectAnchorDay,
              style: theme.typography.base.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.foreground,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FPicker(
                controller: _controller,
                children: [
                  FPickerWheel(
                    loop: false,
                    children: List.generate(31, (index) {
                      final day = index + 1;
                      return Center(
                        child: Text(
                          t.budget.dayOfMonth(day: day.toString()),
                          style: theme.typography.base.copyWith(
                            color: colors.foreground,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: FButton(
                      style: FButtonStyle.outline(),
                      onPress: () => Navigator.pop(context),
                      child: Text(t.common.cancel),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FButton(
                      onPress: () {
                        final index = _controller.value[0];
                        widget.onSelected(index + 1);
                      },
                      child: Text(t.common.confirm),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
