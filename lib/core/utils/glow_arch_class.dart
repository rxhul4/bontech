import 'package:flutter/material.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';

class GlowingArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 1.0;
    final padding = strokeWidth / 2;

    final rect = Rect.fromLTWH(
      padding,
      padding,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );

    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(20));
    final borderPath = Path()..addRRect(rrect);

    final pathMetrics = borderPath.computeMetrics().first;
    final totalLength = pathMetrics.length;

    final start = totalLength * 0.3;
    final end = totalLength * 0.65;

    final glowingArc = pathMetrics.extractPath(start, end);

    // Outer glow layer - soft and diffused
    final outerGlowPaint = Paint()
      ..color = AppColors.colorSecondary.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 4
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    canvas.drawPath(glowingArc, outerGlowPaint);

    // Mid glow layer
    final midGlowPaint = Paint()
      ..color = AppColors.colorSecondary.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    canvas.drawPath(glowingArc, midGlowPaint);

    // Inner bright stroke
    final innerPaint = Paint()
      ..color = AppColors.colorSecondary // Light core
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(glowingArc, innerPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}