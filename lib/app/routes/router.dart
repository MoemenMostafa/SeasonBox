import 'package:go_router/go_router.dart';
import 'package:myapp/features/auth/presentation/screens/login_screen.dart';
import 'package:myapp/features/auth/presentation/screens/splash_screen.dart';
import 'package:myapp/app/routes/dashboard_screen.dart';
import 'package:myapp/features/children/screens/add_child_screen.dart';
import 'package:myapp/features/storage/screens/add_storage_location_screen.dart';
import 'package:myapp/features/items/screens/add_item_screen.dart';
import 'package:myapp/features/children/screens/children_screen.dart';
import 'package:myapp/features/storage/screens/storage_screen.dart';
import 'package:myapp/features/items/screens/items_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
          path: '/home', builder: (context, state) => const DashboardScreen()),
      GoRoute(
          path: '/add-child',
          builder: (context, state) => const AddChildScreen()),
      GoRoute(
          path: '/add-storage-location',
          builder: (context, state) => const AddStorageLocationScreen()),
      GoRoute(
          path: '/add-item',
          builder: (context, state) => const AddItemScreen()),
      GoRoute(
          path: '/children',
          builder: (context, state) => const ChildrenScreen()),
      GoRoute(
          path: '/storage', builder: (context, state) => const StorageScreen()),
      GoRoute(path: '/items', builder: (context, state) => const ItemsScreen()),
    ],
  );
}
