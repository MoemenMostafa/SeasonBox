import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:seasonbox/features/auth/data/auth_service.dart';
import 'package:seasonbox/app/providers/user_profile_provider.dart';

class SeasonBoxAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final Widget? leading;

  const SeasonBoxAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primary, // Purple
              colorScheme.secondary, // Teal/Turquoise
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      leading: leading ??
          (Navigator.of(context).canPop()
              ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                )
              : _buildProfileIcon(context)),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
        ],
      ),
      actions: actions,
      centerTitle: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildProfileIcon(BuildContext context) {
    // Access services via Provider
    // We can use context.watch since we are inside a widget build context (indirectly)
    // but better to use Consumer or Provider.of

    // Check for authenticated user safely
    final authService =
        Provider.of<AuthService>(context); // Listen to auth changes
    final currentUid = authService.currentUid;

    // Listen to profile changes
    final userProfile = Provider.of<UserProfileProvider>(context);
    final userData = userProfile.userData;

    Widget profileImage = Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.person, color: Colors.white, size: 20),
    );

    if (currentUid != null && userData != null) {
      if (userData['photoURL'] != null &&
          (userData['photoURL'] as String).isNotEmpty) {
        profileImage = CircleAvatar(
          backgroundImage:
              (userData['photoURL'] as String).startsWith('assets/')
                  ? AssetImage(userData['photoURL']) as ImageProvider
                  : NetworkImage(userData['photoURL']),
          backgroundColor: Colors.white.withValues(alpha: 0.2),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          context.push('/profile');
        },
        child: profileImage,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
