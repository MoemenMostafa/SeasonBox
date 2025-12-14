import 'package:flutter/material.dart';
import 'package:seasonbox/features/home/presentation/screens/home_screen.dart';
import 'package:seasonbox/features/profile/presentation/screens/profile_screen.dart';
import 'package:seasonbox/features/items/screens/items_screen.dart';
import 'package:seasonbox/features/members/screens/family_members_screen.dart';
import 'package:seasonbox/features/storage/screens/storage_screen.dart';
import 'package:seasonbox/l10n/app_localizations.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomeScreen(),
    ItemsScreen(),
    FamilyMembersScreen(),
    StorageScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(_selectedIndex),
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
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
