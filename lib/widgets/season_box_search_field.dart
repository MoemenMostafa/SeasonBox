import 'package:flutter/material.dart';

class SeasonBoxSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const SeasonBoxSearchField({
    super.key,
    this.controller,
    this.hintText = 'Search...',
    this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
        ),
        prefixIcon: Icon(
          Icons.search,
          color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
        ),
        suffixIcon: controller?.text.isNotEmpty == true || onClear != null
            ? IconButton(
                icon: const Icon(Icons.clear, size: 20),
                onPressed: () {
                  controller?.clear();
                  onChanged?.call('');
                  onClear?.call();
                },
                color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
              )
            : const Icon(Icons.filter_list, color: Colors.grey),
        // If we want a filter icon when empty, but clear when not.
        // Actually adhering to the existing design: default had filter list suffix.
        // Let's keep it simple: clear button if text exists, filter list otherwise?
        // Or just fixed filter list as in original design?
        // Original: prefix search, suffix filter_list.
        // Let's support an optional trailing widget or default to filter.

        filled: true,
        fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      ),
    );
  }
}
