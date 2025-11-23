import 'package:go_router/go_router.dart';
import 'package:myapp/src/auth/presentation/screens/login_screen.dart';
import 'package:myapp/src/auth/presentation/screens/splash_screen.dart';
import 'package:myapp/src/subscription/presentation/screens/subscription_screen.dart';
import 'package:myapp/src/widgets/home_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/subscription',
        builder: (context, state) => const SubscriptionScreen(),
      ),
    ],
  );
}
