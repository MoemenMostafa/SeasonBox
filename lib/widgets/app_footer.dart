import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppFooter extends StatefulWidget {
  final VoidCallback? onSignOut;

  const AppFooter({super.key, this.onSignOut});

  @override
  State<AppFooter> createState() => _AppFooterState();
}

class _AppFooterState extends State<AppFooter> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _version = info.version;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.inventory_2, color: Colors.purple.shade700),
          ),
          const SizedBox(height: 12),
          const Text(
            'SeasonBox',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            'Version $_version',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          if (widget.onSignOut != null) ...[
            const SizedBox(height: 12),
            TextButton(
              onPressed: widget.onSignOut,
              child: const Text(
                'Sign Out',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
