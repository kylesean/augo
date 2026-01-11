import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:genui/genui.dart';
import 'package:augo/i18n/strings.g.dart';
import '../../genui_widgets.dart';
import 'transfer_path_state.dart';
import 'transfer_path_header.dart';
import 'transfer_path_visualization.dart';
import 'transfer_path_actions.dart';

/// 转账链路构建器
///
/// 重构后的版本，拆分为多个子组件：
/// - TransferPathHeader: 头部（标题+金额）
/// - TransferPathVisualization: 双框可视化
/// - TransferPathActions: 操作按钮
/// - TransferPathStateProvider: 状态管理
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
  late TransferPathData _state;

  // 从 data 中提取的常用属性
  String get _surfaceId => widget.data['_surfaceId'] as String? ?? 'unknown';
  bool get _isHistorical => widget.data['_isHistorical'] == true;
  bool get _isCancelledFromData => widget.data['_isCancelled'] == true;
  bool get _wasCancelledFromHistory => widget.data['_wasCancelled'] == true;
  String? get _cancelMessage => widget.data['_cancelMessage'] as String?;
  Map<String, dynamic>? get _userSelection =>
      widget.data['_userSelection'] as Map<String, dynamic>?;

  @override
  void initState() {
    super.initState();
    _initializeState();
  }

  void _initializeState() {
    // 检查缓存：如果之前已提交，恢复状态
    final cached = TransferPathSubmitCache.getSubmitted(_surfaceId);
    if (cached != null) {
      _state = TransferPathData(
        selectedSourceId: cached.sourceId,
        selectedTargetId: cached.targetId,
        isConfirmed: true,
        isSubmitted: true,
        isHistorical: _isHistorical,
        isReadOnly: true,
        surfaceId: _surfaceId,
      );
      return;
    }

    // 历史模式：使用用户当时的选择
    if (_isHistorical && _userSelection != null) {
      _state = TransferPathData(
        selectedSourceId: _userSelection!['source_account_id'] as String?,
        selectedTargetId: _userSelection!['target_account_id'] as String?,
        isConfirmed: true,
        isHistorical: true,
        isReadOnly: true,
        surfaceId: _surfaceId,
      );
      return;
    }

    // 实时模式：使用预选值
    final sourceId = widget.data['preselected_source_id'] as String?;
    final targetId = widget.data['preselected_target_id'] as String?;

    _state = TransferPathData(
      selectedSourceId: sourceId,
      selectedTargetId: targetId,
      activeSelection: sourceId != null && targetId == null
          ? 'target'
          : 'source',
      isCancelled: _isCancelledFromData,
      surfaceId: _surfaceId,
    );
  }

  @override
  void didUpdateWidget(covariant TransferPathBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 检查是否被标记为已取消
    if (_isCancelledFromData && !_state.isCancelled) {
      setState(() {
        _state = _state.copyWith(isCancelled: true);
      });
    }
  }

  void _onStateChange(TransferPathData newState) {
    setState(() {
      _state = newState;
    });
  }

  void _onAccountSelected(String accountId, String selectionType) {
    if (_state.isReadOnly) return;

    setState(() {
      if (selectionType == 'activate_source') {
        _state = _state.copyWith(activeSelection: 'source');
      } else if (selectionType == 'activate_target') {
        _state = _state.copyWith(activeSelection: 'target');
      } else if (_state.activeSelection == 'source') {
        _state = _state.copyWith(
          selectedSourceId: accountId,
          activeSelection: _state.selectedTargetId == null
              ? 'target'
              : 'source',
        );
      } else {
        _state = _state.copyWith(selectedTargetId: accountId);
      }
    });
  }

  void _onFirstConfirm() {
    if (_state.isReadOnly) return;
    setState(() {
      _state = _state.copyWith(isConfirmed: true);
    });
  }

  void _onFinalConfirm() {
    if (_state.isSubmitted || _state.isReadOnly) return;

    setState(() {
      _state = _state.copyWith(isSubmitted: true);
    });

    // 缓存提交状态
    TransferPathSubmitCache.markSubmitted(
      _surfaceId,
      SubmittedSelectionData(
        sourceId: _state.selectedSourceId,
        targetId: _state.selectedTargetId,
      ),
    );

    // 获取账户名称
    final sourceAccounts =
        widget.data['source_accounts'] as List<dynamic>? ?? [];
    final targetAccounts =
        widget.data['target_accounts'] as List<dynamic>? ?? [];
    String sourceName = t.chat.genui.transferPath.unknownAccount;
    String targetName = t.chat.genui.transferPath.unknownAccount;

    for (final acc in sourceAccounts) {
      if ((acc as Map<String, dynamic>)['id'] == _state.selectedSourceId) {
        sourceName = acc['name'] as String;
        break;
      }
    }
    for (final acc in targetAccounts) {
      if ((acc as Map<String, dynamic>)['id'] == _state.selectedTargetId) {
        targetName = acc['name'] as String;
        break;
      }
    }

    // 分发事件
    widget.dispatchEvent(
      UserActionEvent(
        name: 'transfer_path_confirmed',
        sourceComponentId: 'TransferPathBuilder',
        context: {
          'source_account_id': _state.selectedSourceId,
          'target_account_id': _state.selectedTargetId,
          'source_account_name': sourceName,
          'target_account_name': targetName,
          'amount': (widget.data['amount'] as num? ?? 0).toDouble(),
          'currency': widget.data['currency'] as String? ?? 'CNY',
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    final amount = (widget.data['amount'] as num?) ?? 0;
    final currency = widget.data['currency'] as String? ?? 'CNY';
    final sourceAccounts =
        (widget.data['source_accounts'] as List<dynamic>?) ?? [];
    final targetAccounts =
        (widget.data['target_accounts'] as List<dynamic>?) ?? [];

    // 历史取消状态：显示简化卡片
    if (_wasCancelledFromHistory) {
      return _buildCancelledCard(theme, colors);
    }

    // 无数据：显示错误
    if (sourceAccounts.isEmpty && targetAccounts.isEmpty) {
      return _buildErrorCard(theme, colors);
    }

    // 准备账户列表
    final activeAccounts =
        (_state.activeSelection == 'source' ? sourceAccounts : targetAccounts)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();

    // 使用 Provider 包装子组件
    return TransferPathStateProvider(
      state: _state.copyWith(
        isReadOnly:
            _state.isHistorical ||
            _state.isSubmitted ||
            _state.isCancelled ||
            _isCancelledFromData ||
            _wasCancelledFromHistory ||
            TransferPathSubmitCache.isSubmitted(_surfaceId),
      ),
      onStateChange: _onStateChange,
      onFirstConfirm: _onFirstConfirm,
      onFinalConfirm: _onFinalConfirm,
      onAccountSelected: _onAccountSelected,
      child: FCard(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 头部
              TransferPathHeader(
                amount: amount,
                currency: currency,
                isHistorical: _isHistorical,
              ),

              const SizedBox(height: 10),

              // 取消状态横幅
              if (_state.isCancelled || _isCancelledFromData)
                _buildCancelledBanner(theme, colors),

              // 可视化
              Opacity(
                opacity: (_state.isCancelled || _isCancelledFromData)
                    ? 0.5
                    : 1.0,
                child: TransferPathVisualization(
                  sourceAccounts: sourceAccounts,
                  targetAccounts: targetAccounts,
                ),
              ),

              // 账户列表（未确认时）
              if (!_state.isConfirmed && !_state.isReadOnly) ...[
                const SizedBox(height: 8),
                const FDivider(),
                const SizedBox(height: 6),
                AccountList(
                  accounts: activeAccounts,
                  title: _state.activeSelection == 'source'
                      ? t.chat.genui.transferPath.selectSource
                      : t.chat.genui.transferPath.selectTarget,
                  selectedId: _state.activeSelection == 'source'
                      ? _state.selectedSourceId
                      : _state.selectedTargetId,
                  enabled: !_state.isReadOnly,
                  onAccountSelected: (id, _) =>
                      _onAccountSelected(id, 'select'),
                ),
              ],

              // 完成状态指示器
              const TransferPathCompletionIndicator(),

              const SizedBox(height: 10),

              // 操作按钮
              TransferPathActions(
                sourceAccounts: sourceAccounts,
                targetAccounts: targetAccounts,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCancelledCard(FThemeData theme, FColors colors) {
    return FCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colors.mutedForeground.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.cancel_outlined,
                color: colors.mutedForeground,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _cancelMessage ?? t.chat.genui.transferPath.cancelled,
                  style: theme.typography.sm.copyWith(
                    color: colors.mutedForeground,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard(FThemeData theme, FColors colors) {
    return FCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: colors.destructive, size: 48),
            const SizedBox(height: 16),
            Text(
              t.chat.genui.transferPath.loadError,
              style: theme.typography.base.copyWith(
                color: colors.destructive,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              t.chat.genui.transferPath.historyMissing,
              style: theme.typography.sm.copyWith(
                color: colors.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelledBanner(FThemeData theme, FColors colors) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: colors.mutedForeground.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colors.mutedForeground.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.cancel_outlined, color: colors.mutedForeground, size: 20),
          const SizedBox(width: 8),
          Text(
            t.chat.genui.transferPath.cancelled,
            style: theme.typography.sm.copyWith(
              color: colors.mutedForeground,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
