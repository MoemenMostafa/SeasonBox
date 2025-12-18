import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:seasonbox/features/auth/data/auth_service.dart'; // Import AuthService
import 'package:seasonbox/data/services/user_service.dart'; // Import UserService
import 'package:cloud_firestore/cloud_firestore.dart'; // Import CloudFirestore
import 'package:seasonbox/app/providers/navigation_provider.dart'; // Import NavigationProvider

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
      actions: actions ??
          [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications, color: Colors.white),
            ),
          ],
      centerTitle: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildProfileIcon(BuildContext context) {
    // Access services via Provider without listening in build (stateless widget)
    // Actually, we must resolve them. Since this is a StatelessWidget, we can use context.read/watch.
    // However, to keep it clean, we can do it inside this helper method.

    // Check for authenticated user safely
    final authService = Provider.of<AuthService>(context, listen: false);
    final currentUser = authService.currentUser;

    Widget profileImage = Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.person, color: Colors.white, size: 20),
    );

    if (currentUser != null) {
      // Use StreamBuilder for real-time updates
      final userService = Provider.of<UserService>(context, listen: false);
      return StreamBuilder<DocumentSnapshot>(
        stream: userService.getUserStream(currentUser.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.exists) {
            final data = snapshot.data!.data() as Map<String, dynamic>?;
            if (data != null &&
                data['photoURL'] != null &&
                (data['photoURL'] as String).isNotEmpty) {
              profileImage = CircleAvatar(
                backgroundImage: NetworkImage(data['photoURL']),
                backgroundColor: Colors.white.withValues(alpha: 0.2),
              );
            }
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                // index 4 is Profile tab
                context.read<NavigationProvider>().setIndex(4);
              },
              child: profileImage,
            ),
          );
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => context.read<NavigationProvider>().setIndex(4),
        child: profileImage,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
