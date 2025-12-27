import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:genui/genui.dart' show UiEvent;

final _logger = Logger('HistoricalWrapper');

/// 历史模式工具类
///
/// 提供统一的历史模式处理，包括：
/// - 禁用交互
/// - 视觉反馈
/// - noopDispatch 函数

/// 历史模式包装器
///
/// 自动处理：
/// - 禁用交互（IgnorePointer）
/// - 视觉反馈（可选的透明度调整）
/// - 标记徽章（可选）
///
/// Example:
/// ```dart
/// HistoricalWrapper(
///   isHistorical: _isHistorical,
///   child: MyWidget(),
/// )
/// ```
class HistoricalWrapper extends StatelessWidget {
  final Widget child;
  final bool isHistorical;

  /// 是否降低透明度
  final bool dimOpacity;

  /// 透明度值（当 dimOpacity 为 true 时使用）
  final double opacity;

  /// 是否显示历史标记
  final bool showBadge;

  const HistoricalWrapper({
    super.key,
    required this.child,
    required this.isHistorical,
    this.dimOpacity = false,
    this.opacity = 0.85,
    this.showBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!isHistorical) return child;

    Widget result = child;

    // 可选：降低透明度
    if (dimOpacity) {
      result = Opacity(opacity: opacity, child: result);
    }

    // 禁用交互
    return IgnorePointer(child: result);
  }
}

/// 历史模式辅助函数
class HistoricalModeHelper {
  HistoricalModeHelper._();

  /// 空操作事件分发器
  ///
  /// 用于历史模式下忽略所有事件
  static void noopDispatch(UiEvent event) {
    _logger.info(
      'HistoricalModeHelper: Ignored event in historical mode: ${event.runtimeType}',
    );
  }

  /// 检查 data 中是否包含历史模式标记
  static bool isHistorical(Map<String, dynamic>? data) {
    return data?['_isHistorical'] == true;
  }

  /// 为 data 添加历史模式标记
  static Map<String, dynamic> markAsHistorical(Map<String, dynamic> data) {
    return {...data, '_isHistorical': true};
  }
}
