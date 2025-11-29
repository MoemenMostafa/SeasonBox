import 'package:flutter/material.dart';

class SeasonBoxFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final int? count;

  const SeasonBoxFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary
                : (isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.grey[200]),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            count != null ? '$label ($count)' : label,
            style: TextStyle(
              color:
                  isSelected ? Colors.white : theme.textTheme.bodyMedium?.color,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
