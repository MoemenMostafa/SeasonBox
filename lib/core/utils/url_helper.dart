import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlHelper {
  static Future<void> launchWebsiteUrl(BuildContext context, String path,
      {bool isExternal = false}) async {
    final Uri url;
    if (path.startsWith('http')) {
      url = Uri.parse(path);
    } else {
      // In a real app, you might want to get the locale from a provider
      // but since this is a static helper, we'll try to find it from the context
      final locale = Localizations.maybeLocaleOf(context);
      final langCode = locale?.languageCode ?? 'en';

      // Ensure path starts with /
      final normalizedPath = path.startsWith('/') ? path : '/$path';
      url = Uri.parse('https://seasonbox.app/$langCode$normalizedPath');
    }

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not launch $url')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error launching $url: $e')),
        );
      }
    }
  }
}
