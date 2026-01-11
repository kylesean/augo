import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:genui/genui.dart';
import 'package:augo/app/theme/app_semantic_colors.dart';
import '../organisms/organisms.dart';
import 'package:augo/i18n/strings.g.dart';
import 'package:augo/shared/utils/amount_formatter.dart';

/// 转账向导数据模型 (Data Layer)
class TransferWizardData {
  final double amount;
  final String currency;
  final List<Map<String, dynamic>> sourceAccounts;
  final List<Map<String, dynamic>> targetAccounts;
  final String? preselectedSourceId;
  final String? preselectedTargetId;
  final String memo;
  final String surfaceId;
  final bool isHistorical;
  final bool isConfirmed;

  TransferWizardData({
    required this.amount,
    required this.currency,
    required this.sourceAccounts,
    required this.targetAccounts,
    this.preselectedSourceId,
    this.preselectedTargetId,
    this.memo = '',
    required this.surfaceId,
    this.isHistorical = false,
    this.isConfirmed = false,
  });

  factory TransferWizardData.fromJson(Map<String, dynamic> json) {
    return TransferWizardData(
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'CNY',
      sourceAccounts: (json['sourceAccounts'] as List<dynamic>? ?? [])
          .map((e) => Map<String, dynamic>.from(e as Map<dynamic, dynamic>))
          .toList(),
      targetAccounts: (json['targetAccounts'] as List<dynamic>? ?? [])
          .map((e) => Map<String, dynamic>.from(e as Map<dynamic, dynamic>))
          .toList(),
      preselectedSourceId: json['preselectedSourceId'] as String?,
      preselectedTargetId: json['preselectedTargetId'] as String?,
      memo: json['memo'] as String? ?? '',
      surfaceId: json['_surfaceId'] as String? ?? 'unknown',
      isHistorical: json['_isHistorical'] == true,
      isConfirmed: json['isConfirmed'] == true || json['_isHistorical'] == true,
    );
  }
}

class TransferWizard extends StatefulWidget {
  final Map<String, dynamic> data;
  final void Function(UiEvent) dispatchEvent;

  const TransferWizard({
    super.key,
    required this.data,
    required this.dispatchEvent,
  });

  @override
  State<TransferWizard> createState() => _TransferWizardState();
}

/// 用户确认时的状态缓存
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

class _TransferWizardState extends State<TransferWizard> {
  // 静态缓存：保存用户确认时的选择状态
  // 当组件重建时，可以从缓存恢复状态
  static final Map<String, _ConfirmedState> _confirmedStateCache = {};

  late TransferWizardData _model;
  late TextEditingController _amountController;
  String? _sourceId;
  String? _targetId;
  bool _isConfirmed = false;

  @override
  void initState() {
    super.initState();
    _model = TransferWizardData.fromJson(widget.data);

    // 优先从缓存恢复确认状态（解决组件重建后状态丢失问题）
    final cachedState = _confirmedStateCache[_model.surfaceId];
    if (cachedState != null) {
      _sourceId = cachedState.sourceId;
      _targetId = cachedState.targetId;
      _amountController = TextEditingController(text: cachedState.amount);
      _isConfirmed = true;
    } else if (_model.isConfirmed) {
      // 历史加载场景：从后端回填的数据恢复
      _sourceId = _model.preselectedSourceId;
      _targetId = _model.preselectedTargetId;
      _amountController = TextEditingController(
        text: _model.amount > 0 ? _model.amount.toStringAsFixed(2) : '',
      );
      _isConfirmed = true;
    } else {
      // 使用原始数据初始化
      _sourceId = _model.preselectedSourceId;
      _targetId = _model.preselectedTargetId;
      _amountController = TextEditingController(
        text: _model.amount > 0 ? _model.amount.toStringAsFixed(2) : '',
      );

      if (_model.isHistorical) {
        _isConfirmed = true;
      }
    }
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
              // Header
              _buildHeader(theme, colors),
              const SizedBox(height: 24),

              // Amount Section
              _buildAmountSection(theme, colors),
              const SizedBox(height: 24),

              // Account Path Section
              _buildTransferPath(context, theme, colors),
              const SizedBox(height: 32),

              // Action Button
              _buildConfirmButton(theme, colors),
            ],
          ),
        ),
      ),
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

  Widget _buildAmountSection(FThemeData theme, FColors colors) {
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
                AmountFormatter.getCurrencySymbol(_model.currency),
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
        // 2. 基础卡片层
        Column(
          children: [
            _buildAccountItem(
              context,
              label: t.chat.transferWizard.sourceAccount,
              accountId: _sourceId,
              accounts: _model.sourceAccounts,
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
              accounts: _model.targetAccounts,
              onSelect: (id) => setState(() => _targetId = id),
              theme: theme,
              colors: colors,
              isSource: false,
            ),
          ],
        ),

        // 3. 特色交互：中心重叠圆圈
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
          // 恢复：左侧固有的图标圆圈
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
          // 卡片主体
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

    // 将用户选择保存到缓存，防止组件重建时状态丢失
    _confirmedStateCache[_model.surfaceId] = _ConfirmedState(
      sourceId: _sourceId,
      targetId: _targetId,
      amount: _amountController.text,
    );

    // 获取账户名称用于后端 TransferReceipt 组件显示
    final sourceAccount = _getAccount(_sourceId, _model.sourceAccounts);
    final targetAccount = _getAccount(_targetId, _model.targetAccounts);
    final sourceAccountName =
        sourceAccount?['name'] as String? ??
        t.chat.transferWizard.sourceAccount;
    final targetAccountName =
        targetAccount?['name'] as String? ??
        t.chat.transferWizard.targetAccount;

    widget.dispatchEvent(
      UserActionEvent(
        name: 'transfer_path_confirmed',
        sourceComponentId: 'TransferWizard',
        context: {
          'surface_id': _model.surfaceId,
          'source_account_id': _sourceId,
          'target_account_id': _targetId,
          'source_account_name': sourceAccountName,
          'target_account_name': targetAccountName,
          'amount': finalAmount,
          'currency': _model.currency,
          'memo': _model.memo,
        },
      ),
    );
  }
}
