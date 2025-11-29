import 'package:flutter/material.dart';

class SkeletonContainer extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? margin;

  const SkeletonContainer._({
    this.width = double.infinity,
    this.height = double.infinity,
    this.borderRadius,
    this.margin,
  });

  const SkeletonContainer.square({
    required double size,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? margin,
  }) : this._(
          width: size,
          height: size,
          borderRadius: borderRadius,
          margin: margin,
        );

  const SkeletonContainer.rectangular({
    double width = double.infinity,
    required double height,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? margin,
  }) : this._(
          width: width,
          height: height,
          borderRadius: borderRadius,
          margin: margin,
        );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color =
        isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade200;

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
    );
  }
}
