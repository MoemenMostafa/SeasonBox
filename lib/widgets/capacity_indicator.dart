import 'package:flutter/material.dart';

class CapacityIndicator extends StatelessWidget {
  final double percentage;
  final String? customLabel;
  final Color? customColor;

  const CapacityIndicator({
    super.key,
    required this.percentage,
    this.customLabel,
    this.customColor,
  });

  Color _getColorForPercentage() {
    if (customColor != null) return customColor!;
    if (percentage >= 90) return Colors.red;
    if (percentage >= 70) return Colors.orange;
    if (percentage >= 50) return Colors.yellow.shade700;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColorForPercentage();
    final label = customLabel ?? '${percentage.toInt()}% Full';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
