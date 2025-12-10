import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seasonbox/features/auth/presentation/screens/login_screen.dart';
import 'package:seasonbox/features/auth/presentation/screens/email_login_screen.dart';
import 'package:seasonbox/app/routes/dashboard_screen.dart';
import 'package:seasonbox/features/members/screens/add_family_member_screen.dart';
import 'package:seasonbox/features/storage/screens/add_storage_location_screen.dart';
import 'package:seasonbox/features/items/screens/add_item_screen.dart';
import 'package:seasonbox/features/members/screens/family_members_screen.dart';
import 'package:seasonbox/features/storage/screens/storage_screen.dart';
import 'package:seasonbox/features/items/screens/items_screen.dart';
import 'package:seasonbox/data/models/item.dart';
import 'package:seasonbox/data/models/family_member.dart';
import 'package:seasonbox/data/models/storage_location.dart';
import 'package:seasonbox/features/qr_scanner/screens/qr_scanner_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation:
        FirebaseAuth.instance.currentUser != null ? '/home' : '/login',
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
          path: '/email-login',
          builder: (context, state) => const EmailLoginScreen()),
      GoRoute(
          path: '/home', builder: (context, state) => const DashboardScreen()),
      GoRoute(
          path: '/add-member',
          builder: (context, state) =>
              AddFamilyMemberScreen(member: state.extra as FamilyMember?)),
      GoRoute(
          path: '/add-storage-location',
          builder: (context, state) => AddStorageLocationScreen(
              location: state.extra as StorageLocation?)),
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
          builder: (context, state) {
            final extra = state.extra;
            if (extra is Map) {
              // Handle Map (works with both Map<String, dynamic> and IdentityMap)
              return ItemsScreen(
                initialMemberId: extra['initialMemberId'] as String?,
                initialStorageLocationId:
                    extra['initialStorageLocationId'] as String?,
              );
            } else if (extra is String) {
              // For backward compatibility with member ID only
              return ItemsScreen(initialMemberId: extra);
            }
            return const ItemsScreen();
          }),
      GoRoute(
          path: '/qr-scanner',
          builder: (context, state) => const QRScannerScreen()),
    ],
  );
}
