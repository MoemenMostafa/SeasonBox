import 'package:go_router/go_router.dart';
import 'package:myapp/features/auth/presentation/screens/login_screen.dart';
import 'package:myapp/features/auth/presentation/screens/splash_screen.dart';
import 'package:myapp/app/routes/dashboard_screen.dart';
import 'package:myapp/features/members/screens/add_family_member_screen.dart';
import 'package:myapp/features/storage/screens/add_storage_location_screen.dart';
import 'package:myapp/features/items/screens/add_item_screen.dart';
import 'package:myapp/features/members/screens/family_members_screen.dart';
import 'package:myapp/features/storage/screens/storage_screen.dart';
import 'package:myapp/features/items/screens/items_screen.dart';
import 'package:myapp/data/models/item.dart';
import 'package:myapp/data/models/family_member.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
          path: '/home', builder: (context, state) => const DashboardScreen()),
      GoRoute(
          path: '/add-member',
          builder: (context, state) =>
              AddFamilyMemberScreen(member: state.extra as FamilyMember?)),
      GoRoute(
          path: '/add-storage-location',
          builder: (context, state) => const AddStorageLocationScreen()),
      GoRoute(
          path: '/add-item',
          builder: (context, state) =>
              AddItemScreen(item: state.extra as Item?)),
      GoRoute(
          path: '/members',
          builder: (context, state) => const FamilyMembersScreen()),
      GoRoute(
          path: '/storage', builder: (context, state) => const StorageScreen()),
      GoRoute(
          path: '/items',
          builder: (context, state) =>
              ItemsScreen(initialMemberId: state.extra as String?)),
    ],
  );
}
