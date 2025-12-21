import 'package:flutter/material.dart';
import 'package:seasonbox/features/home/presentation/screens/home_screen.dart';
import 'package:seasonbox/features/profile/presentation/screens/profile_screen.dart';
import 'package:seasonbox/features/items/screens/items_screen.dart';
import 'package:seasonbox/features/members/screens/family_members_screen.dart';
import 'package:seasonbox/features/storage/screens/storage_screen.dart';
import 'package:seasonbox/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:seasonbox/app/providers/navigation_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const List<Widget> _pages = <Widget>[
    HomeScreen(),
    ItemsScreen(),
    FamilyMembersScreen(),
    StorageScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final navigationProvider = context.watch<NavigationProvider>();
    final selectedIndex = navigationProvider.selectedIndex;

    // Ensure index is within bounds (safety check)
    final safeIndex = (selectedIndex >= 0 && selectedIndex < _pages.length)
        ? selectedIndex
        : 0;

    return Scaffold(
      body: IndexedStack(
        index: safeIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: AppLocalizations.of(context)!.nav_home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.checkroom),
            label: AppLocalizations.of(context)!.nav_items,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.people),
            label: AppLocalizations.of(context)!.nav_members,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.inventory_2),
            label: AppLocalizations.of(context)!.nav_storage,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: AppLocalizations.of(context)!.nav_profile,
          ),
        ],
        currentIndex: safeIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: (index) => context.read<NavigationProvider>().setIndex(index),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
