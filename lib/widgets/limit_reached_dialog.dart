import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seasonbox/l10n/app_localizations.dart';

class LimitReachedDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? buttonLabel;
  final String? source;
  final IconData? icon;
  final Color? iconColor;

  const LimitReachedDialog({
    super.key,
    required this.title,
    required this.message,
    this.buttonLabel,
    this.source,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: iconColor ?? Colors.blue),
            const SizedBox(width: 8),
          ],
          Expanded(child: Text(title)),
        ],
      ),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(l10n.common_cancel),
        ),
        ElevatedButton(
          onPressed: () {
            context.pop();
            final queryParams = source != null ? '?source=$source' : '';
            context.push('/subscription$queryParams');
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: Text(buttonLabel ?? l10n.home_premium_banner_button),
        ),
      ],
    );
  }

  static void show(
    BuildContext context, {
    required String title,
    required String message,
    String? buttonLabel,
    String? source,
    IconData? icon = Icons.stars,
    Color? iconColor,
  }) {
    showDialog(
      context: context,
      builder: (context) => LimitReachedDialog(
        title: title,
        message: message,
        buttonLabel: buttonLabel,
        source: source,
        icon: icon,
        iconColor: iconColor,
      ),
    );
  }
}
