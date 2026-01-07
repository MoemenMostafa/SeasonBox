import 'package:go_router/go_router.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:seasonbox/data/services/posthog_service.dart';

import 'package:seasonbox/features/auth/data/auth_service.dart';
import 'package:seasonbox/features/auth/presentation/screens/login_screen.dart';
import 'package:seasonbox/features/auth/presentation/screens/email_login_screen.dart';
import 'package:seasonbox/features/auth/presentation/screens/register_screen.dart';
import 'package:seasonbox/app/routes/dashboard_screen.dart';
import 'package:seasonbox/features/members/screens/add_family_member_screen.dart';
import 'package:seasonbox/features/storage/screens/add_storage_location_screen.dart';
import 'package:seasonbox/features/items/screens/add_item_screen.dart';
import 'package:seasonbox/features/members/screens/family_members_screen.dart';
import 'package:seasonbox/features/storage/screens/storage_screen.dart';
import 'package:seasonbox/features/storage/screens/print_labels_screen.dart';
import 'package:seasonbox/features/items/screens/items_screen.dart';
import 'package:seasonbox/data/models/item.dart';
import 'package:seasonbox/data/models/family_member.dart';
import 'package:seasonbox/data/models/storage_location.dart';
import 'package:seasonbox/features/qr_scanner/screens/qr_scanner_screen.dart';
import 'package:seasonbox/features/notifications/screens/notifications_screen.dart';
import 'package:seasonbox/features/members/screens/growth_chart_screen.dart';
import 'package:seasonbox/features/profile/presentation/screens/profile_screen.dart';
import 'package:seasonbox/features/easter_egg/presentation/screens/easter_egg_screen.dart';
import 'package:seasonbox/features/subscription/screens/subscription_screen.dart';
import 'package:seasonbox/features/subscription/screens/premium_congratulations_screen.dart';
import 'package:seasonbox/features/auth/presentation/screens/welcome_screen.dart';

import 'package:seasonbox/app/providers/deep_link_provider.dart';

class AppRouter {
  final AuthService authService;
  final DeepLinkProvider deepLinkProvider;

  AppRouter(this.authService, this.deepLinkProvider);

  late final GoRouter router = GoRouter(
    initialLocation: '/login', // Default, redirect will handle the rest
    refreshListenable: authService,
    observers: [PosthogObserver()],
    redirect: (context, state) {
      final uri = state.uri;
      final fullUrl = uri.toString();

      // Centralized Deep Link Tracking
      if (deepLinkProvider.shouldTrack(fullUrl)) {
        final params = uri.queryParameters;
        final campaignId = params['campaign_id'];
        final locationId = params['location_id'] ?? params['id'];
        final memberId = params['member_id'];

        PostHogService().captureEvent('deeplink_opened', properties: {
          'path': uri.path,
          'full_url': fullUrl,
          if (campaignId != null) 'campaign_id': campaignId,
          if (locationId != null) 'location_id': locationId,
          if (memberId != null) 'member_id': memberId,
        });
      }

      final isLoggedIn = authService.currentUser != null;
      final isDemo = authService.isDemoMode;
      final isAuthenticated = isLoggedIn || isDemo;

      final isLoginRoute = uri.path == '/login' ||
          uri.path == '/email-login' ||
          uri.path == '/register';

      if (!isAuthenticated) {
        // If not authenticated, always redirect to login (unless already there)
        if (isLoginRoute) return null;

        // Preserve the intended destination in the provider
        deepLinkProvider.setPendingRedirect(fullUrl);

        return '/login';
      }

      if (isAuthenticated && isLoginRoute) {
        // If authenticated (or demo) and on a login route, redirect to home
        return '/home';
      }

      // Allow access to other routes
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
          path: '/email-login',
          builder: (context, state) => const EmailLoginScreen()),
      GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen()),
      GoRoute(
          path: '/home', builder: (context, state) => const DashboardScreen()),
      GoRoute(
          path: '/add-member',
          builder: (context, state) =>
              AddFamilyMemberScreen(member: state.extra as FamilyMember?)),
      GoRoute(
          path: '/add-storage-location',
          builder: (context, state) {
            final extra = state.extra;
            if (extra is StorageLocation) {
              return AddStorageLocationScreen(location: extra);
            } else if (extra is String) {
              return AddStorageLocationScreen(initialParentId: extra);
            } else if (extra is Map<String, dynamic>) {
              return AddStorageLocationScreen(
                location: extra['location'] as StorageLocation?,
                initialParentId: extra['initialParentId'] as String?,
              );
            }
            return const AddStorageLocationScreen();
          }),
      GoRoute(
          path: '/add-item',
          builder: (context, state) {
            final extra = state.extra;
            if (extra is Item) {
              return AddItemScreen(item: extra);
            } else if (extra is Map<String, dynamic>) {
              return AddItemScreen(
                item: extra['item'] as Item?,
                initialStorageLocationId:
                    extra['initialStorageLocationId'] as String?,
              );
            }
            return const AddItemScreen();
          }),
      GoRoute(
          path: '/members',
          builder: (context, state) => const FamilyMembersScreen()),
      GoRoute(
          path: '/storage',
          builder: (context, state) {
            final locationId = state.uri.queryParameters['id'];
            return StorageScreen(initialLocationId: locationId);
          }),
      GoRoute(
          path: '/items',
          builder: (context, state) {
            final memberId = state.uri.queryParameters['memberId'];
            final locationId = state.uri.queryParameters['locationId'];
            final extra = state.extra;

            if (extra is Map) {
              return ItemsScreen(
                initialMemberId:
                    extra['initialMemberId'] as String? ?? memberId,
                initialStorageLocationId:
                    extra['initialStorageLocationId'] as String? ?? locationId,
              );
            } else if (extra is String) {
              return ItemsScreen(initialMemberId: extra);
            }

            return ItemsScreen(
              initialMemberId: memberId,
              initialStorageLocationId: locationId,
            );
          }),
      GoRoute(
          path: '/qr-scanner',
          builder: (context, state) => const QRScannerScreen()),
      GoRoute(
          path: '/notifications',
          builder: (context, state) => const NotificationsScreen()),
      GoRoute(
          path: '/growth-chart',
          builder: (context, state) =>
              GrowthChartScreen(member: state.extra as FamilyMember)),
      GoRoute(
          path: '/profile', builder: (context, state) => const ProfileScreen()),
      GoRoute(
          path: '/easter-egg',
          builder: (context, state) => const EasterEggScreen()),
      GoRoute(
          path: '/subscription',
          builder: (context, state) => const SubscriptionScreen()),
      GoRoute(
          path: '/premium-congratulations',
          builder: (context, state) => const PremiumCongratulationsScreen()),
      GoRoute(
          path: '/print-labels',
          builder: (context, state) => const PrintLabelsScreen()),
      GoRoute(
          path: '/welcome', builder: (context, state) => const WelcomeScreen()),
    ],
  );
}
