import 'dart:async';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:augo/i18n/strings.g.dart';
import 'package:augo/shared/widgets/amount_text.dart';
import 'package:augo/features/home/models/transaction_model.dart';
import 'package:augo/app/theme/app_semantic_colors.dart';

import '../atoms/atoms.dart';

/// 转账成功收据卡片 Widget - 简洁三段式设计
///
/// 特色设计：
/// - 电流动画连线（从转出到转入）
/// - 只显示账户图标（标签已有名称）
/// - 紧凑的横版布局
///
/// 参考设计：
/// ┌─────────────────────────────────────────────────┐
/// │ ✓ 转账成功                           14:30      │
/// ├─────────────────────────────────────────────────┤
/// │                    🔄                           │
/// │                 ¥1,000.00                       │
/// │            #转账 #储蓄卡 #现金                     │
/// ├─────────────────────────────────────────────────┤
/// │         💳  ~~~⚡~~~>  💵                       │  ← 电流动画
/// └─────────────────────────────────────────────────┘
class TransferReceipt extends StatelessWidget {
  final Map<String, dynamic> data;

  const TransferReceipt({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;

    // 提取数据
    final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
    final currency = data['currency'] as String? ?? 'CNY';
    final time = data['transaction_at'] as String? ?? '';
    final tags =
        (data['tags'] as List?)?.map((e) => e.toString()).toList() ?? [];

    // 转账信息
    final transferInfo = data['transfer_info'] as Map<String, dynamic>?;
    final sourceAccount =
        transferInfo?['source_account'] as Map<String, dynamic>?;
    final targetAccount =
        transferInfo?['target_account'] as Map<String, dynamic>?;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 第一段：顶部状态栏
          _buildStatusHeader(theme, colors, time),

          // 第二段：中部内容 - 金额 + 标签
          _buildMainContent(theme, colors, currency, amount, tags),

          // 第三段：底部账户动画（含账户名）
          _TransferAnimation(
            colors: colors,
            sourceAccount: sourceAccount,
            targetAccount: targetAccount,
          ),
        ],
      ),
    );
  }

  /// 构建顶部状态栏
  Widget _buildStatusHeader(FThemeData theme, FColors colors, String time) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: colors.primary.withValues(alpha: 0.1)),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: colors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(FIcons.check, color: Colors.white, size: 14),
          ),
          const SizedBox(width: 8),
          Text(
            t.chat.transferWizard.transferSuccess,
            style: theme.typography.base.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            _formatTimeOnly(time),
            style: theme.typography.sm.copyWith(
              color: colors.primary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建中部主内容区
  Widget _buildMainContent(
    FThemeData theme,
    FColors colors,
    String currency,
    double amount,
    List<String> tags,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        children: [
          // 转账图标
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(FIcons.arrowRightLeft, color: colors.primary, size: 24),
          ),
          const SizedBox(height: 12),

          // 金额 - 使用统一的 AmountText（转账类型）
          AmountText(
            amount: amount,
            type: TransactionType.transfer,
            currency: currency,
            showSign: false,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: colors.foreground,
              letterSpacing: -0.5,
            ),
          ),

          // 标签
          if (tags.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              alignment: WrapAlignment.center,
              children: tags.map((tag) => Tag(label: tag)).toList(),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTimeOnly(String isoTime) {
    if (isoTime.isEmpty) {
      final now = DateTime.now();
      return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    }
    try {
      final dateTime = DateTime.parse(isoTime);
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '';
    }
  }
}

/// 转账动画组件 - 电流效果
class _TransferAnimation extends StatefulWidget {
  final FColors colors;
  final Map<String, dynamic>? sourceAccount;
  final Map<String, dynamic>? targetAccount;

  const _TransferAnimation({
    required this.colors,
    this.sourceAccount,
    this.targetAccount,
  });

  @override
  State<_TransferAnimation> createState() => _TransferAnimationState();
}

class _TransferAnimationState extends State<_TransferAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    unawaited(
      (_controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1500),
      )).repeat(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = widget.colors;

    final sourceName = widget.sourceAccount?['name'] as String? ?? '';
    final targetName = widget.targetAccount?['name'] as String? ?? '';
    final sourceType = widget.sourceAccount?['type'] as String?;
    final targetType = widget.targetAccount?['type'] as String?;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(color: colors.muted.withValues(alpha: 0.15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 转出账户
          _buildAccountWithLabel(theme, colors, sourceName, sourceType),

          // 电流动画连线
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SizedBox(
              width: 70,
              height: 30,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _ElectricLinePainter(
                      progress: _controller.value,
                      color: colors.primary,
                    ),
                  );
                },
              ),
            ),
          ),

          // 转入账户
          _buildAccountWithLabel(theme, colors, targetName, targetType),
        ],
      ),
    );
  }

  Widget _buildAccountWithLabel(
    FThemeData theme,
    FColors colors,
    String name,
    String? type,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildAccountIcon(colors, type),
        const SizedBox(height: 8),
        SizedBox(
          width: 100,
          child: Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.typography.xs.copyWith(
              color: colors.foreground,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountIcon(FColors colors, String? type) {
    final semantic = context.theme.semantic;
    IconData icon;
    Color bgColor;

    switch (type?.toUpperCase()) {
      case 'CASH':
        icon = FIcons.banknote;
        bgColor = semantic.successAccent;
        break;
      case 'BANK':
      case 'DEPOSIT':
        icon = FIcons.building;
        bgColor = colors.primary;
        break;
      case 'CREDIT_CARD':
        icon = FIcons.creditCard;
        bgColor = semantic.warningAccent;
        break;
      case 'ALIPAY':
        icon = FIcons.smartphone;
        bgColor = const Color(0xFF1677FF); // 支付宝品牌色
        break;
      case 'WECHAT':
        icon = FIcons.smartphone;
        bgColor = const Color(0xFF07C160); // 微信品牌色
        break;
      default:
        icon = FIcons.wallet;
        bgColor = colors.mutedForeground;
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: bgColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Icon(icon, size: 22, color: bgColor),
    );
  }
}

/// 电流连线绘制器
class _ElectricLinePainter extends CustomPainter {
  final double progress;
  final Color color;

  _ElectricLinePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // 基础线条
    final basePath = Path();
    basePath.moveTo(0, size.height / 2);
    basePath.lineTo(size.width, size.height / 2);
    canvas.drawPath(basePath, paint);

    // 箭头
    final arrowPaint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final arrowPath = Path();
    arrowPath.moveTo(size.width - 8, size.height / 2 - 5);
    arrowPath.lineTo(size.width, size.height / 2);
    arrowPath.lineTo(size.width - 8, size.height / 2 + 5);
    canvas.drawPath(arrowPath, arrowPaint);

    // 电流光点（移动效果）
    final glowPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // 多个光点，形成电流流动效果
    for (int i = 0; i < 3; i++) {
      final dotProgress = (progress + i * 0.33) % 1.0;
      final x = dotProgress * (size.width - 12) + 4;
      final alpha = (1 - (dotProgress - 0.5).abs() * 2).clamp(0.3, 1.0);

      canvas.drawCircle(
        Offset(x, size.height / 2),
        3,
        glowPaint..color = color.withValues(alpha: alpha),
      );
    }
  }

  @override
  bool shouldRepaint(_ElectricLinePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
