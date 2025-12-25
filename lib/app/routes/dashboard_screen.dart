import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seasonbox/features/home/presentation/screens/home_screen.dart';
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
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add-item'),
        backgroundColor: theme.colorScheme.primary,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        padding: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Left side tabs
              _buildNavItem(0, Icons.home,
                  AppLocalizations.of(context)!.nav_home, navigationProvider),
              _buildNavItem(1, Icons.checkroom,
                  AppLocalizations.of(context)!.nav_items, navigationProvider),

              // Spacer for FAB
              const SizedBox(width: 48),

              // Right side tabs
              _buildNavItem(
                  2,
                  Icons.people,
                  AppLocalizations.of(context)!.nav_members,
                  navigationProvider),
              _buildNavItem(
                  3,
                  Icons.inventory_2,
                  AppLocalizations.of(context)!.nav_storage,
                  navigationProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      int index, IconData icon, String label, NavigationProvider nav) {
    final isSelected = nav.selectedIndex == index;
    final color = isSelected
        ? Theme.of(context).colorScheme.primary
        : Colors.grey.shade600;

    return Expanded(
      child: InkWell(
        onTap: () => nav.setIndex(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
