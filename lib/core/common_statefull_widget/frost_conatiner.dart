import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sales_app_redesign/core/utils/app_colors.dart';

class Frost extends StatelessWidget {
  final Widget? child;
  final double blur;
  final double opacity; // 0..1
  final double radius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BoxBorder? frame; // optional outline

  const Frost({
    super.key,
    this.child,
    this.blur = 18,
    this.opacity = .16,
    this.radius = 16,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.frame,
  });

  // ⬇️ Make the glass outline subtly blue
  static BoxBorder outlineBorder() =>
      Border.all(color: AppColors.primary.withOpacity(.18), width: 1);

  @override
  Widget build(BuildContext context) {
    // ⬇️ Tint the glass with brand blue while keeping a frosted look
    final p = AppColors.primary;
    final clamped = opacity.clamp(0.0, 1.0).toDouble();
    final top = Colors.white.withOpacity(clamped * 0.90);
    final bottom = p.withOpacity(clamped * 0.60);

    return Container(
      margin: margin,
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: frame,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [top, bottom],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
