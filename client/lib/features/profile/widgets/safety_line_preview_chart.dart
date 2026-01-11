// features/profile/widgets/safety_line_preview_chart.dart
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'dart:math' as math;

/// Safety line preview chart component
class SafetyLinePreviewChart extends StatefulWidget {
  final double safetyLineValue;

  const SafetyLinePreviewChart({super.key, required this.safetyLineValue});

  @override
  State<SafetyLinePreviewChart> createState() => _SafetyLinePreviewChartState();
}

class _SafetyLinePreviewChartState extends State<SafetyLinePreviewChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void didUpdateWidget(SafetyLinePreviewChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.safetyLineValue != widget.safetyLineValue) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colors;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: SafetyLineChartPainter(
            safetyLineValue: widget.safetyLineValue,
            animationValue: _animation.value,
            colorScheme: colorScheme,
          ),
          size: const Size(double.infinity, 200),
        );
      },
    );
  }
}

/// Safety line chart painter
class SafetyLineChartPainter extends CustomPainter {
  final double safetyLineValue;
  final double animationValue;
  final FColors colorScheme;

  SafetyLineChartPainter({
    required this.safetyLineValue,
    required this.animationValue,
    required this.colorScheme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw axes
    _drawAxes(canvas, size, paint);

    // Draw balance curve
    _drawBalanceCurve(canvas, size, paint);

    // Draw safety line
    _drawSafetyLine(canvas, size, paint);

    // Draw labels
    _drawLabels(canvas, size);
  }

  /// Draw axes
  void _drawAxes(Canvas canvas, Size size, Paint paint) {
    paint.color = colorScheme.border;

    // Y-axis
    canvas.drawLine(const Offset(40, 20), Offset(40, size.height - 40), paint);

    // X-axis
    canvas.drawLine(
      Offset(40, size.height - 40),
      Offset(size.width - 20, size.height - 40),
      paint,
    );
  }

  /// Draw balance curve
  void _drawBalanceCurve(Canvas canvas, Size size, Paint paint) {
    paint.color = colorScheme.primary;
    paint.strokeWidth = 3;

    final path = Path();
    final chartWidth = size.width - 60;
    final chartHeight = size.height - 60;

    // Generate sample data points
    final points = _generateSampleData(chartWidth, chartHeight);

    if (points.isNotEmpty) {
      path.moveTo(points.first.dx + 40, points.first.dy + 20);

      for (int i = 1; i < points.length; i++) {
        final animatedX = 40 + (points[i].dx * animationValue);
        final animatedY = 20 + points[i].dy;
        path.lineTo(animatedX, animatedY);
      }

      canvas.drawPath(path, paint);
    }

    // Draw data points
    paint.style = PaintingStyle.fill;
    for (int i = 0; i < points.length; i++) {
      final progress = i / (points.length - 1);
      if (progress <= animationValue) {
        canvas.drawCircle(
          Offset(points[i].dx + 40, points[i].dy + 20),
          4,
          paint,
        );
      }
    }
    paint.style = PaintingStyle.stroke;
  }

  /// Draw safety line
  void _drawSafetyLine(Canvas canvas, Size size, Paint paint) {
    paint.color = Colors.red;
    paint.strokeWidth = 2;

    // Calculate safety line Y position
    final chartHeight = size.height - 60;
    const maxValue = 8000.0; // Chart max value
    final safetyLineY =
        20 + chartHeight - (safetyLineValue / maxValue * chartHeight);

    // Draw dashed line
    _drawDashedLine(
      canvas,
      Offset(40, safetyLineY),
      Offset(size.width - 20, safetyLineY),
      paint,
    );

    // Draw safety line label background
    final labelText = 'Safety Line ¥${safetyLineValue.toInt()}';
    final textPainter = TextPainter(
      text: TextSpan(
        text: labelText,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final labelX = size.width - textPainter.width - 30;
    final labelY = safetyLineY - textPainter.height - 5;

    // Draw label background
    final labelBgPaint = Paint()
      ..color = Colors.red.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          labelX - 8,
          labelY - 4,
          textPainter.width + 16,
          textPainter.height + 8,
        ),
        const Radius.circular(4),
      ),
      labelBgPaint,
    );

    // Draw label text
    textPainter.paint(canvas, Offset(labelX, labelY));
  }

  /// Draw dashed line
  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dashWidth = 5.0;
    const dashSpace = 3.0;

    final distance = (end - start).distance;
    final dashCount = (distance / (dashWidth + dashSpace)).floor();

    for (int i = 0; i < dashCount; i++) {
      final startOffset =
          start + (end - start) * (i * (dashWidth + dashSpace) / distance);
      final endOffset =
          start +
          (end - start) *
              ((i * (dashWidth + dashSpace) + dashWidth) / distance);
      canvas.drawLine(startOffset, endOffset, paint);
    }
  }

  /// Generate sample data
  List<Offset> _generateSampleData(double width, double height) {
    final points = <Offset>[];
    const pointCount = 12;

    for (int i = 0; i < pointCount; i++) {
      final x = (i / (pointCount - 1)) * width;

      // Generate fluctuating balance data
      final baseValue = 5000 + math.sin(i * 0.5) * 1500;
      final randomVariation = (math.sin(i * 1.2) * 800);
      final value = baseValue + randomVariation;

      final y = height - (value / 8000 * height);
      points.add(Offset(x, y));
    }

    return points;
  }

  /// Draw labels
  void _drawLabels(Canvas canvas, Size size) {
    final textStyle = TextStyle(
      color: colorScheme.mutedForeground,
      fontSize: 10,
    );

    // Y-axis labels
    final yLabels = ['0', '2K', '4K', '6K', '8K'];
    for (int i = 0; i < yLabels.length; i++) {
      final textPainter = TextPainter(
        text: TextSpan(text: yLabels[i], style: textStyle),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      final y =
          size.height - 40 - (i / (yLabels.length - 1)) * (size.height - 60);
      textPainter.paint(canvas, Offset(5, y - textPainter.height / 2));
    }

    // X-axis labels
    final xLabels = ['Today', '1w', '2w', '3w', '1m'];
    for (int i = 0; i < xLabels.length; i++) {
      final textPainter = TextPainter(
        text: TextSpan(text: xLabels[i], style: textStyle),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      final x = 40 + (i / (xLabels.length - 1)) * (size.width - 60);
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, size.height - 35),
      );
    }
  }

  @override
  bool shouldRepaint(SafetyLineChartPainter oldDelegate) {
    return oldDelegate.safetyLineValue != safetyLineValue ||
        oldDelegate.animationValue != animationValue;
  }
}
