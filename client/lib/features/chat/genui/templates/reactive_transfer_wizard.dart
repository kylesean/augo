// ReactiveTransferWizard - GenUI DataContext Reactive Version
//
// Reactive version of TransferWizard using GenUI DataContext for data binding.
// Enables server-driven updates via DataModelUpdate messages.
//
// Key differences from TransferWizard:
// - Uses CatalogItemContext instead of raw data + dispatchEvent
// - Subscribes to DataContext for reactive fields (amount, currency, etc.)
// - Uses ValueListenableBuilder for fine-grained updates

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:genui/genui.dart';
import 'package:augo/app/theme/app_semantic_colors.dart';
import '../organisms/organisms.dart';
import 'package:augo/i18n/strings.g.dart';
import 'package:augo/shared/utils/amount_formatter.dart';

/// Reactive TransferWizard using GenUI DataContext
///
/// This widget uses DataContext subscriptions for reactive updates.
/// When backend sends DataModelUpdate, only affected parts rebuild.
class ReactiveTransferWizard extends StatefulWidget {
  /// The CatalogItemContext from GenUI widget builder
  final CatalogItemContext catalogContext;

  const ReactiveTransferWizard({super.key, required this.catalogContext});

  @override
  State<ReactiveTransferWizard> createState() => _ReactiveTransferWizardState();
}

/// User confirmed state cache to persist across widget rebuilds
class _ConfirmedState {
  final String? sourceId;
  final String? targetId;
  final String amount;

  const _ConfirmedState({
    required this.sourceId,
    required this.targetId,
    required this.amount,
  });
}

class _ReactiveTransferWizardState extends State<ReactiveTransferWizard> {
  // Static cache: saves user's confirmed selection state
  static final Map<String, _ConfirmedState> _confirmedStateCache = {};

  // DataContext subscriptions
  late final ValueNotifier<double?> _amountNotifier;
  late final ValueNotifier<String?> _currencyNotifier;
  late final ValueNotifier<String?> _memoNotifier;
  late final ValueNotifier<String?> _preselectedSourceIdNotifier;
  late final ValueNotifier<String?> _preselectedTargetIdNotifier;

  // Local UI state (not reactive from backend)
  late TextEditingController _amountController;
  String? _sourceId;
  String? _targetId;
  bool _isConfirmed = false;

  DataContext get _dataContext => widget.catalogContext.dataContext;
  Map<String, dynamic> get _data =>
      widget.catalogContext.data as Map<String, dynamic>;
  String get _surfaceId => widget.catalogContext.surfaceId;

  bool get _isHistorical => _data['_isHistorical'] == true;

  List<Map<String, dynamic>> get _sourceAccounts {
    final list = _data['sourceAccounts'] as List<dynamic>? ?? [];
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  List<Map<String, dynamic>> get _targetAccounts {
    final list = _data['targetAccounts'] as List<dynamic>? ?? [];
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  @override
  void initState() {
    super.initState();
    _initializeSubscriptions();
    _initializeState();
  }

  void _initializeSubscriptions() {
    // Subscribe to reactive fields that backend might update
    _amountNotifier = _dataContext.subscribe<double>(DataPath('/amount'));
    _currencyNotifier = _dataContext.subscribe<String>(DataPath('/currency'));
    _memoNotifier = _dataContext.subscribe<String>(DataPath('/memo'));
    _preselectedSourceIdNotifier = _dataContext.subscribe<String>(
      DataPath('/preselectedSourceId'),
    );
    _preselectedTargetIdNotifier = _dataContext.subscribe<String>(
      DataPath('/preselectedTargetId'),
    );

    // Initialize fallback values from static data
    _initializeFallbackValues();
  }

  void _initializeFallbackValues() {
    if (_amountNotifier.value == null && _data.containsKey('amount')) {
      _amountNotifier.value = (_data['amount'] as num?)?.toDouble();
    }
    if (_currencyNotifier.value == null) {
      _currencyNotifier.value = _data['currency'] as String? ?? 'CNY';
    }
    if (_memoNotifier.value == null) {
      _memoNotifier.value = _data['memo'] as String? ?? '';
    }
    if (_preselectedSourceIdNotifier.value == null) {
      _preselectedSourceIdNotifier.value =
          _data['preselectedSourceId'] as String?;
    }
    if (_preselectedTargetIdNotifier.value == null) {
      _preselectedTargetIdNotifier.value =
          _data['preselectedTargetId'] as String?;
    }
  }

  void _initializeState() {
    final initialAmount = _amountNotifier.value ?? 0.0;

    // Priority 1: Restore from cache (handles widget rebuild)
    final cachedState = _confirmedStateCache[_surfaceId];
    if (cachedState != null) {
      _sourceId = cachedState.sourceId;
      _targetId = cachedState.targetId;
      _amountController = TextEditingController(text: cachedState.amount);
      _isConfirmed = true;
      return;
    }

    // Priority 2: Historical mode
    if (_isHistorical || _data['isConfirmed'] == true) {
      _sourceId = _preselectedSourceIdNotifier.value;
      _targetId = _preselectedTargetIdNotifier.value;
      _amountController = TextEditingController(
        text: initialAmount > 0 ? initialAmount.toStringAsFixed(2) : '',
      );
      _isConfirmed = true;
      return;
    }

    // Normal initialization
    _sourceId = _preselectedSourceIdNotifier.value;
    _targetId = _preselectedTargetIdNotifier.value;
    _amountController = TextEditingController(
      text: initialAmount > 0 ? initialAmount.toStringAsFixed(2) : '',
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  bool get _isValid {
    if (_sourceId == null || _targetId == null) return false;
    if (_sourceId == _targetId) return false;
    final amount = double.tryParse(_amountController.text) ?? 0;
    return amount > 0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    // Use ValueListenableBuilder for reactive currency updates
    return ValueListenableBuilder<String?>(
      valueListenable: _currencyNotifier,
      builder: (context, currency, _) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: colors.background.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: colors.border.withValues(alpha: 0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(theme, colors),
                  const SizedBox(height: 24),
                  _buildAmountSection(theme, colors, currency ?? 'CNY'),
                  const SizedBox(height: 24),
                  _buildTransferPath(context, theme, colors),
                  const SizedBox(height: 32),
                  _buildConfirmButton(theme, colors),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(FThemeData theme, FColors colors) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(FIcons.arrowRightLeft, color: colors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          t.chat.transferWizard.title,
          style: theme.typography.lg.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        const Spacer(),
        if (_isConfirmed)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: theme.semantic.successBackground,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  FIcons.check,
                  color: theme.semantic.successAccent,
                  size: 12,
                ),
                const SizedBox(width: 4),
                Text(
                  t.chat.transferWizard.confirmed,
                  style: theme.typography.xs.copyWith(
                    color: theme.semantic.successAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildAmountSection(
    FThemeData theme,
    FColors colors,
    String currency,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.muted.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.chat.transferWizard.amount,
            style: theme.typography.xs.copyWith(color: colors.mutedForeground),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                AmountFormatter.getCurrencySymbol(currency),
                style: theme.typography.xl.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _isConfirmed
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          _amountController.text.isEmpty
                              ? '0.00'
                              : _amountController.text,
                          style: theme.typography.xl.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colors.foreground,
                            letterSpacing: -1,
                          ),
                        ),
                      )
                    : TextField(
                        controller: _amountController,
                        enabled: !_isConfirmed,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          hintText: '0.00',
                          hintStyle: theme.typography.xl.copyWith(
                            color: colors.mutedForeground.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: theme.typography.xl.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.foreground,
                          letterSpacing: -1,
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransferPath(
    BuildContext context,
    FThemeData theme,
    FColors colors,
  ) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            _buildAccountItem(
              context,
              label: t.chat.transferWizard.sourceAccount,
              accountId: _sourceId,
              accounts: _sourceAccounts,
              onSelect: (id) => setState(() => _sourceId = id),
              theme: theme,
              colors: colors,
              isSource: true,
            ),
            const SizedBox(height: 12),
            _buildAccountItem(
              context,
              label: t.chat.transferWizard.targetAccount,
              accountId: _targetId,
              accounts: _targetAccounts,
              onSelect: (id) => setState(() => _targetId = id),
              theme: theme,
              colors: colors,
              isSource: false,
            ),
          ],
        ),
        // Center overlay circle
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _isConfirmed ? colors.primary : colors.foreground,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: colors.foreground.withValues(alpha: 0.2),
                blurRadius: 12,
              ),
            ],
          ),
          child: Icon(
            _isConfirmed ? FIcons.check : FIcons.arrowDown,
            size: 16,
            color: _isConfirmed ? colors.primaryForeground : colors.background,
          ),
        ),
      ],
    );
  }

  Widget _buildAccountItem(
    BuildContext context, {
    required String label,
    required String? accountId,
    required List<Map<String, dynamic>> accounts,
    required void Function(String) onSelect,
    required FThemeData theme,
    required FColors colors,
    required bool isSource,
  }) {
    final account = _getAccount(accountId, accounts);

    return GestureDetector(
      onTap: _isConfirmed
          ? null
          : () async {
              final result = await AccountSelectSheet.show(
                context: context,
                title: label,
                accounts: accounts,
                selectedId: accountId,
              );
              if (result != null) onSelect(result);
            },
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isSource
                  ? colors.primary.withValues(alpha: 0.1)
                  : colors.foreground.withValues(alpha: 0.05),
              shape: BoxShape.circle,
              border: Border.all(
                color: isSource
                    ? colors.primary.withValues(alpha: 0.3)
                    : colors.border,
                width: 2,
              ),
            ),
            child: Icon(
              isSource ? FIcons.logOut : FIcons.logIn,
              size: 18,
              color: isSource ? colors.primary : colors.mutedForeground,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: colors.muted.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: accountId == null
                      ? colors.border.withValues(alpha: 0.5)
                      : colors.foreground.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: theme.typography.xs.copyWith(
                            color: colors.mutedForeground,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          account?['name'] as String? ??
                              t.chat.transferWizard.selectAccount,
                          style: theme.typography.sm.copyWith(
                            fontWeight: FontWeight.bold,
                            color: accountId == null
                                ? colors.mutedForeground
                                : colors.foreground,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!_isConfirmed)
                    Icon(
                      FIcons.chevronRight,
                      size: 16,
                      color: colors.mutedForeground.withValues(alpha: 0.5),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(FThemeData theme, FColors colors) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      child: FButton(
        onPress: _isValid && !_isConfirmed ? _onConfirm : null,
        style: _isConfirmed ? FButtonStyle.outline() : FButtonStyle.primary(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_isConfirmed) ...[
              const Icon(FIcons.send, size: 16),
              const SizedBox(width: 8),
            ],
            Text(
              _isConfirmed
                  ? t.chat.transferWizard.confirmed
                  : t.chat.transferWizard.confirmTransfer,
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic>? _getAccount(
    String? id,
    List<Map<String, dynamic>> accounts,
  ) {
    if (id == null) return null;
    try {
      return accounts.firstWhere((acc) => acc['id'] == id);
    } catch (_) {
      return null;
    }
  }

  void _onConfirm() {
    setState(() => _isConfirmed = true);
    final finalAmount = double.tryParse(_amountController.text) ?? 0;

    // Cache state to persist across widget rebuilds
    _confirmedStateCache[_surfaceId] = _ConfirmedState(
      sourceId: _sourceId,
      targetId: _targetId,
      amount: _amountController.text,
    );

    // Get account names for backend display
    final sourceAccount = _getAccount(_sourceId, _sourceAccounts);
    final targetAccount = _getAccount(_targetId, _targetAccounts);
    final sourceAccountName =
        sourceAccount?['name'] as String? ??
        t.chat.transferWizard.sourceAccount;
    final targetAccountName =
        targetAccount?['name'] as String? ??
        t.chat.transferWizard.targetAccount;

    widget.catalogContext.dispatchEvent(
      UserActionEvent(
        name: 'transfer_path_confirmed',
        sourceComponentId: 'ReactiveTransferWizard',
        context: {
          'surface_id': _surfaceId,
          'source_account_id': _sourceId,
          'target_account_id': _targetId,
          'source_account_name': sourceAccountName,
          'target_account_name': targetAccountName,
          'amount': finalAmount,
          'currency': _currencyNotifier.value ?? 'CNY',
          'memo': _memoNotifier.value ?? '',
        },
      ),
    );
  }
}
