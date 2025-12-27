import 'package:flutter/widgets.dart';

/// 转账链路状态数据
class TransferPathData {
  final String? selectedSourceId;
  final String? selectedTargetId;
  final bool isConfirmed;
  final bool isSubmitted;
  final bool isCancelled;
  final bool isHistorical;
  final bool isReadOnly;
  final String activeSelection; // 'source' | 'target'
  final String surfaceId;

  const TransferPathData({
    this.selectedSourceId,
    this.selectedTargetId,
    this.isConfirmed = false,
    this.isSubmitted = false,
    this.isCancelled = false,
    this.isHistorical = false,
    this.isReadOnly = false,
    this.activeSelection = 'source',
    this.surfaceId = 'unknown',
  });

  TransferPathData copyWith({
    String? selectedSourceId,
    String? selectedTargetId,
    bool? isConfirmed,
    bool? isSubmitted,
    bool? isCancelled,
    bool? isHistorical,
    bool? isReadOnly,
    String? activeSelection,
    String? surfaceId,
  }) {
    return TransferPathData(
      selectedSourceId: selectedSourceId ?? this.selectedSourceId,
      selectedTargetId: selectedTargetId ?? this.selectedTargetId,
      isConfirmed: isConfirmed ?? this.isConfirmed,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      isCancelled: isCancelled ?? this.isCancelled,
      isHistorical: isHistorical ?? this.isHistorical,
      isReadOnly: isReadOnly ?? this.isReadOnly,
      activeSelection: activeSelection ?? this.activeSelection,
      surfaceId: surfaceId ?? this.surfaceId,
    );
  }

  /// 是否可以进入下一步确认
  bool get canConfirm =>
      selectedSourceId != null &&
      selectedTargetId != null &&
      !isConfirmed &&
      !isReadOnly;
}

/// 转账链路状态提供者
///
/// 使用 InheritedWidget 替代静态 Map，实现状态的组件树传递
class TransferPathStateProvider extends InheritedWidget {
  final TransferPathData state;
  final void Function(TransferPathData) onStateChange;
  final void Function() onFirstConfirm;
  final void Function() onFinalConfirm;
  final void Function(String accountId, String selectionType) onAccountSelected;

  const TransferPathStateProvider({
    super.key,
    required this.state,
    required this.onStateChange,
    required this.onFirstConfirm,
    required this.onFinalConfirm,
    required this.onAccountSelected,
    required super.child,
  });

  static TransferPathStateProvider? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TransferPathStateProvider>();
  }

  static TransferPathStateProvider of(BuildContext context) {
    final result = maybeOf(context);
    assert(result != null, 'TransferPathStateProvider not found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(TransferPathStateProvider oldWidget) {
    return state != oldWidget.state;
  }
}

/// 已提交的选择数据（用于防止重复提交）
class SubmittedSelectionData {
  final String? sourceId;
  final String? targetId;

  const SubmittedSelectionData({this.sourceId, this.targetId});
}

/// 全局已提交状态缓存
///
/// 注意：这是一个妥协方案，理想情况下应使用更好的状态管理
/// 但为了保持兼容性和简单性，暂时保留
class TransferPathSubmitCache {
  TransferPathSubmitCache._();

  static final Map<String, SubmittedSelectionData> _cache = {};

  static void markSubmitted(String surfaceId, SubmittedSelectionData data) {
    _cache[surfaceId] = data;
  }

  static SubmittedSelectionData? getSubmitted(String surfaceId) {
    return _cache[surfaceId];
  }

  static bool isSubmitted(String surfaceId) {
    return _cache.containsKey(surfaceId);
  }

  /// 清除缓存（用于测试）
  static void clear() {
    _cache.clear();
  }
}
