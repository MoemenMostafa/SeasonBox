import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:go_router/go_router.dart';

class AppFooter extends StatefulWidget {
  final VoidCallback? onSignOut;

  const AppFooter({super.key, this.onSignOut});

  @override
  State<AppFooter> createState() => _AppFooterState();
}

class _AppFooterState extends State<AppFooter> {
  String _version = '';
  int _clickCount = 0;

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

  void _handleVersionClick() {
    setState(() {
      _clickCount++;
    });

    if (_clickCount >= 5) {
      _clickCount = 0;
      context.push('/easter-egg');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/app_icon.png',
              height: 64,
              width: 64,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'SeasonBox',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          GestureDetector(
            onTap: _handleVersionClick,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Version $_version',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
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
