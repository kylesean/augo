// ignore_for_file: deprecated_member_use_from_same_package
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:genui/genui.dart';
import 'package:augo/i18n/strings.g.dart';
import '../organisms/organisms.dart';

/// 提交缓存
class _ConfirmationCache {
  static final Map<String, String?> _cache = {};

  static void markConfirmed(String surfaceId, String? accountId) {
    _cache[surfaceId] = accountId;
  }

  static bool isConfirmed(String surfaceId) => _cache.containsKey(surfaceId);
  static String? getAccountId(String surfaceId) => _cache[surfaceId];
}

/// 交易确认 - 账户选择
///
/// @deprecated 此组件已废弃（2024-12）。
/// 后端工具 `request_transaction_confirmation` 已被删除。
/// 采用"先记录，后关联账户"的设计模式：
/// - 用户直接记账（使用 create_transaction，不填 account_id）
/// - 用户可在交易详情中事后关联账户
///
/// 此组件保留仅为支持历史数据渲染。
@Deprecated(
  'Use create_transaction without account_id, then link account in transaction details',
)
class TransactionConfirmation extends StatefulWidget {
  final Map<String, dynamic> data;
  final void Function(UiEvent) dispatchEvent;

  const TransactionConfirmation({
    super.key,
    required this.data,
    required this.dispatchEvent,
  });

  @override
  State<TransactionConfirmation> createState() =>
      _TransactionConfirmationState();
}

class _TransactionConfirmationState extends State<TransactionConfirmation> {
  String? _selectedAccountId;
  bool _isConfirmed = false;

  bool get _isHistorical => widget.data['_isHistorical'] == true;
  String get _surfaceId => widget.data['_surfaceId'] as String? ?? 'unknown';

  @override
  void initState() {
    super.initState();

    // 检查缓存
    if (_ConfirmationCache.isConfirmed(_surfaceId)) {
      _isConfirmed = true;
      _selectedAccountId = _ConfirmationCache.getAccountId(_surfaceId);
      return;
    }

    _selectedAccountId = widget.data['preselected_account_id'] as String?;
  }

  @override
  Widget build(BuildContext context) {
    final accounts =
        (widget.data['available_accounts'] as List<dynamic>?) ?? [];

    if (accounts.isEmpty) {
      return const SizedBox.shrink();
    }

    final accountMaps = accounts
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();

    // 是否禁用：已确认或历史模式
    final isDisabled = _isConfirmed || _isHistorical;

    final isIncome =
        (widget.data['transaction_type'] as String?)?.toUpperCase() == 'INCOME';
    final titleText = isIncome
        ? t.chat.transferWizard.selectReceiveAccount
        : t.chat.transferWizard.selectAccount;

    return FCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: AccountPickerCard(
          accounts: accountMaps,
          selectedId: _selectedAccountId,
          title: titleText,
          subtitle: isDisabled
              ? null
              : t.chat.genui.transactionConfirmation.multipleAccounts,
          confirmText: isDisabled
              ? t.chat.genui.transactionConfirmation.confirmed
              : t.common.confirm,
          enabled: !isDisabled,
          onSelect: isDisabled
              ? null
              : (id) {
                  setState(() {
                    _selectedAccountId = id;
                  });
                },
          onConfirm: isDisabled ? null : _onConfirm,
        ),
      ),
    );
  }

  void _onConfirm() {
    if (_isConfirmed) return;

    setState(() {
      _isConfirmed = true;
    });

    _ConfirmationCache.markConfirmed(_surfaceId, _selectedAccountId);

    String? accountName;
    if (_selectedAccountId != null) {
      final accounts =
          (widget.data['available_accounts'] as List<dynamic>?) ?? [];
      accountName = _getAccountName(_selectedAccountId!, accounts);
    }

    widget.dispatchEvent(
      UserActionEvent(
        name: 'transaction_confirmed_with_account',
        sourceComponentId: 'TransactionConfirmation',
        context: {
          'account_id': _selectedAccountId,
          'account_name': accountName,
          'amount': widget.data['amount'],
          'description': widget.data['description'],
          'transaction_type': widget.data['transaction_type'],
          'category_key': widget.data['category_key'],
          'currency': widget.data['currency'],
          'raw_input': widget.data['raw_input'],
          'tags': widget.data['tags'],
        },
      ),
    );
  }

  String _getAccountName(String accountId, List<dynamic> accounts) {
    for (final acc in accounts) {
      final accMap = acc as Map<String, dynamic>;
      if (accMap['id'] == accountId) {
        return accMap['name'] as String? ??
            t.chat.genui.transactionCard.noAccount;
      }
    }
    return t.chat.genui.transactionCard.noAccount;
  }
}
