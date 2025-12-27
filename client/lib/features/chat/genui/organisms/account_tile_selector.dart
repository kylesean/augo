import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:augo/i18n/strings.g.dart';

/// 账户 Tile 选择器
///
/// 基于 FSelectTileGroup 实现的内联账户选择器
/// 遵循 GenUI organisms 层规范，可被 templates 层复用
class AccountTileSelector extends StatefulWidget {
  /// 账户列表，格式: [{id, name, type?, subtitle?}, ...]
  final List<Map<String, dynamic>> accounts;

  /// 当前选中的账户 ID
  final String? selectedId;

  /// 选择变化回调
  final ValueChanged<String?>? onChanged;

  /// 是否显示"不关联"选项
  final bool showNoAccountOption;

  /// "不关联"选项的文本
  final String? noAccountText;

  /// 最大高度（超出时可滚动）
  final double? maxHeight;

  /// 是否禁用
  final bool enabled;

  const AccountTileSelector({
    super.key,
    required this.accounts,
    this.selectedId,
    this.onChanged,
    this.showNoAccountOption = true,
    this.noAccountText,
    this.maxHeight = 240,
    this.enabled = true,
  });

  @override
  State<AccountTileSelector> createState() => _AccountTileSelectorState();
}

class _AccountTileSelectorState extends State<AccountTileSelector> {
  late FSelectTileGroupController<String> _controller;

  @override
  void initState() {
    super.initState();
    _controller = FMultiValueNotifier<String>.radio(widget.selectedId ?? '');
  }

  @override
  void didUpdateWidget(covariant AccountTileSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedId != widget.selectedId) {
      final newValue = widget.selectedId ?? '';
      if (!_controller.contains(newValue)) {
        _controller.update(newValue, add: true);
      }
    }
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

    final List<FSelectTile<String>> tiles = [];

    // "不关联"选项
    if (widget.showNoAccountOption) {
      tiles.add(
        FSelectTile<String>(
          title: Text(
            widget.noAccountText ?? t.chat.genui.transactionCard.noAccount,
            style: theme.typography.sm.copyWith(color: colors.mutedForeground),
          ),
          suffix: Icon(FIcons.x, size: 14, color: colors.mutedForeground),
          value: '',
          enabled: widget.enabled,
        ),
      );
    }

    // 账户选项
    for (final account in widget.accounts) {
      final id = account['id'] as String;
      final name = account['name'] as String;
      final type = account['type'] as String?;

      tiles.add(
        FSelectTile<String>(
          title: Text(
            name,
            style: theme.typography.sm.copyWith(
              color: colors.foreground,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: type != null
              ? Text(
                  _getAccountTypeDisplay(type),
                  style: theme.typography.xs.copyWith(
                    color: colors.mutedForeground,
                  ),
                )
              : null,
          suffix: _buildAccountIcon(colors, type),
          value: id,
          enabled: widget.enabled,
        ),
      );
    }

    return FSelectTileGroup<String>(
      selectController: _controller,
      maxHeight: widget.maxHeight ?? 240,
      divider: FItemDivider.full,
      onSelect: (record) {
        final (value, selected) = record;
        if (selected) {
          widget.onChanged?.call(value.isEmpty ? null : value);
        }
      },
      children: tiles,
    );
  }

  Widget _buildAccountIcon(FColors colors, String? type) {
    final icon = _getAccountIcon(type);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.secondary,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(icon, size: 14, color: colors.foreground),
    );
  }

  IconData _getAccountIcon(String? type) {
    switch (type?.toUpperCase()) {
      case 'CASH':
        return FIcons.banknote;
      case 'BANK':
      case 'DEPOSIT':
        return FIcons.building;
      case 'CREDIT_CARD':
        return FIcons.creditCard;
      case 'ALIPAY':
      case 'WECHAT':
      case 'EWALLET':
        return FIcons.smartphone;
      case 'INVESTMENT':
        return FIcons.trendingUp;
      case 'RECEIVABLE':
        return FIcons.arrowRightLeft;
      case 'LOAN':
        return FIcons.landmark;
      default:
        return FIcons.wallet;
    }
  }

  String _getAccountTypeDisplay(String type) {
    switch (type.toUpperCase()) {
      case 'CASH':
        return t.account.cash;
      case 'BANK':
      case 'DEPOSIT':
        return t.account.deposit;
      case 'CREDIT_CARD':
        return t.account.creditCard;
      case 'ALIPAY':
      case 'WECHAT':
      case 'EWALLET':
        return t.account.eWallet;
      case 'INVESTMENT':
        return t.account.investment;
      case 'LOAN':
        return t.account.loan;
      case 'RECEIVABLE':
        return t.account.receivable;
      case 'PAYABLE':
        return t.account.payable;
      default:
        return type;
    }
  }
}
