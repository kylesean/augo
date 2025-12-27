import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:genui/genui.dart';
import 'package:augo/app/theme/app_semantic_colors.dart';
import 'package:augo/i18n/strings.g.dart';
import '../organisms/organisms.dart';

class _TransferCache {
  static final Map<String, Map<String, String?>> _cache = {};

  static void markSubmitted(
    String surfaceId,
    String? sourceId,
    String? targetId,
  ) {
    _cache[surfaceId] = {'source': sourceId, 'target': targetId};
  }

  static bool isSubmitted(String surfaceId) => _cache.containsKey(surfaceId);
  static Map<String, String?>? getSelection(String surfaceId) =>
      _cache[surfaceId];
}

class TransferPathBuilder extends StatefulWidget {
  final Map<String, dynamic> data;
  final void Function(UiEvent) dispatchEvent;

  const TransferPathBuilder({
    super.key,
    required this.data,
    required this.dispatchEvent,
  });

  @override
  State<TransferPathBuilder> createState() => _TransferPathBuilderState();
}

class _TransferPathBuilderState extends State<TransferPathBuilder> {
  String? _sourceId;
  String? _targetId;
  bool _isConfirmed = false;

  bool get _isHistorical => widget.data['_isHistorical'] == true;
  String get _surfaceId => widget.data['_surfaceId'] as String? ?? 'unknown';

  List<Map<String, dynamic>> get _sourceAccounts {
    final list = widget.data['sourceAccounts'] as List<dynamic>? ?? [];
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  List<Map<String, dynamic>> get _targetAccounts {
    final list = widget.data['targetAccounts'] as List<dynamic>? ?? [];
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  @override
  void initState() {
    super.initState();

    // check cache
    if (_TransferCache.isSubmitted(_surfaceId)) {
      final cached = _TransferCache.getSelection(_surfaceId)!;
      _sourceId = cached['source'];
      _targetId = cached['target'];
      _isConfirmed = true;
      return;
    }

    // historical mode
    if (_isHistorical) {
      final selection = widget.data['_userSelection'] as Map<String, dynamic>?;
      if (selection != null) {
        _sourceId = selection['source_account_id'] as String?;
        _targetId = selection['target_account_id'] as String?;
      }
      _isConfirmed = true;
      return;
    }

    // normal mode: preselected
    _sourceId = widget.data['preselectedSourceId'] as String?;
    _targetId = widget.data['preselectedTargetId'] as String?;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    final isDisabled = _isConfirmed || _isHistorical;

    return FCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // FROM + arrow + TO use Stack to implement arrow mask effect
            Stack(
              alignment: Alignment.center,
              children: [
                // two cards (with spacing, arrow will cover the spacing)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // FROM card
                    _buildAccountCard(
                      context,
                      theme,
                      colors,
                      label: 'FROM',
                      account: _getAccount(_sourceId, _sourceAccounts),
                      placeholder: t.chat.genui.transferPath.selectSource,
                      onTap: isDisabled ? null : () => _selectSource(context),
                    ),
                    // spacing (arrow will cover)
                    const SizedBox(height: 16),
                    // TO card
                    _buildAccountCard(
                      context,
                      theme,
                      colors,
                      label: 'TO',
                      account: _getAccount(_targetId, _targetAccounts),
                      placeholder: t.chat.genui.transferPath.selectTarget,
                      onTap: isDisabled ? null : () => _selectTarget(context),
                    ),
                  ],
                ),
                // middle arrow (mask effect, primary color)
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isConfirmed ? FIcons.check : FIcons.arrowDown,
                    size: 18,
                    color: colors.primaryForeground,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // confirm button
            _buildConfirmButton(theme, colors, isDisabled),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountCard(
    BuildContext context,
    FThemeData theme,
    FColors colors, {
    required String label,
    required Map<String, dynamic>? account,
    required String placeholder,
    required VoidCallback? onTap,
  }) {
    final hasAccount = account != null;
    final name = account?['name'] as String?;
    final type = account?['type'] as String?;
    final suffix = account?['suffix'] as String?;

    final displayName = hasAccount
        ? (suffix != null ? '$name ($suffix)' : name!)
        : placeholder;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          children: [
            // icon
            _buildAccountIcon(colors, context.theme.semantic, type),
            const SizedBox(width: 12),
            // label + name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.typography.xs.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    displayName,
                    style: theme.typography.sm.copyWith(
                      fontWeight: FontWeight.w600,
                      color: hasAccount
                          ? colors.foreground
                          : colors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
            // right arrow
            if (onTap != null)
              Icon(
                FIcons.chevronRight,
                size: 18,
                color: colors.mutedForeground,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountIcon(
    FColors colors,
    AppSemanticColors semantic,
    String? type,
  ) {
    IconData icon;
    Color bgColor;

    switch (type?.toUpperCase()) {
      case 'CASH':
        icon = FIcons.banknote;
        bgColor = semantic.successAccent;
        break;
      case 'BANK':
        icon = FIcons.building;
        bgColor = colors.primary;
        break;
      case 'CREDIT_CARD':
        icon = FIcons.creditCard;
        bgColor = semantic.warningAccent;
        break;
      case 'ALIPAY':
        icon = FIcons.smartphone;
        bgColor = colors.primary; // 统一使用主题色
        break;
      case 'WECHAT':
        icon = FIcons.smartphone;
        bgColor = semantic.successAccent; // 绿色语义
        break;
      default:
        icon = FIcons.wallet;
        bgColor = colors.mutedForeground;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 20, color: bgColor),
    );
  }

  Widget _buildConfirmButton(
    FThemeData theme,
    FColors colors,
    bool isDisabled,
  ) {
    final canConfirm = !isDisabled && _sourceId != null && _targetId != null;
    final isConfirmedState =
        isDisabled && _sourceId != null && _targetId != null;

    return GestureDetector(
      onTap: canConfirm ? _onConfirm : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isConfirmedState
              ? colors.primary.withValues(alpha: 0.1)
              : (canConfirm ? colors.foreground : colors.muted),
          borderRadius: BorderRadius.circular(12),
          border: isConfirmedState
              ? Border.all(color: colors.primary.withValues(alpha: 0.3))
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isConfirmedState) ...[
              Icon(FIcons.check, size: 16, color: colors.primary),
              const SizedBox(width: 6),
            ],
            Text(
              isConfirmedState
                  ? t.chat.transferWizard.confirmed
                  : t.chat.transferWizard.confirmTransfer,
              style: theme.typography.sm.copyWith(
                fontWeight: FontWeight.w600,
                color: isConfirmedState
                    ? colors.primary
                    : (canConfirm ? colors.background : colors.mutedForeground),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectSource(BuildContext context) async {
    // remove focus, prevent keyboard from showing after closing the sheet
    final result = await AccountSelectSheet.show(
      context: context,
      title: t.chat.genui.transferPath.selectSource,
      accounts: _sourceAccounts,
      selectedId: _sourceId,
    );
    if (result != null) {
      setState(() => _sourceId = result);
    }
  }

  Future<void> _selectTarget(BuildContext context) async {
    // remove focus, prevent keyboard from showing after closing the sheet
    FocusScope.of(context).unfocus();

    final result = await AccountSelectSheet.show(
      context: context,
      title: t.chat.genui.transferPath.selectTarget,
      accounts: _targetAccounts,
      selectedId: _targetId,
    );
    if (result != null) {
      setState(() => _targetId = result);
    }
  }

  Map<String, dynamic>? _getAccount(
    String? id,
    List<Map<String, dynamic>> accounts,
  ) {
    if (id == null) return null;
    for (final acc in accounts) {
      if (acc['id'] == id) return acc;
    }
    return null;
  }

  void _onConfirm() {
    if (_isConfirmed) return;

    setState(() => _isConfirmed = true);

    _TransferCache.markSubmitted(_surfaceId, _sourceId, _targetId);

    final sourceName =
        _getAccount(_sourceId, _sourceAccounts)?['name'] as String? ??
        t.common.unknown;
    final targetName =
        _getAccount(_targetId, _targetAccounts)?['name'] as String? ??
        t.common.unknown;

    // 安全解析 amount，支持 num 和 String 类型
    double amount = 0.0;
    final rawAmount = widget.data['amount'];
    if (rawAmount is num) {
      amount = rawAmount.toDouble();
    } else if (rawAmount is String) {
      amount = double.tryParse(rawAmount) ?? 0.0;
    }

    widget.dispatchEvent(
      UserActionEvent(
        name: 'transfer_path_confirmed',
        sourceComponentId: 'TransferPathBuilder',
        context: {
          'source_account_id': _sourceId,
          'target_account_id': _targetId,
          'source_account_name': sourceName,
          'target_account_name': targetName,
          'amount': amount,
          'currency': widget.data['currency'] as String? ?? 'CNY',
        },
      ),
    );
  }
}
