import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:seasonbox/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:seasonbox/firebase_options.dart';
import 'package:seasonbox/features/auth/data/auth_service.dart';
import 'package:seasonbox/data/services/user_service.dart';
import 'package:seasonbox/data/services/biometric_service.dart';
import 'package:seasonbox/data/services/posthog_service.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:seasonbox/app/routes/router.dart';
import 'package:seasonbox/app/theme/theme.dart';
import 'package:seasonbox/app/providers/navigation_provider.dart';
import 'package:seasonbox/app/providers/theme_provider.dart';
import 'package:seasonbox/data/services/firestore_service.dart';
import 'package:seasonbox/data/repositories/family_repository.dart';
import 'package:seasonbox/data/repositories/family_member_repository.dart';
import 'package:seasonbox/data/repositories/item_repository.dart';
import 'package:seasonbox/data/repositories/storage_location_repository.dart';
import 'package:seasonbox/data/services/storage_service.dart';
import 'package:seasonbox/data/services/subscription_service.dart';
import 'package:seasonbox/app/providers/user_profile_provider.dart';
import 'package:seasonbox/data/services/remote_config_service.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:seasonbox/data/services/app_check_service.dart';
import 'package:seasonbox/data/services/demo_data_service.dart';

void main() async {
  // Ensure bindings are initialized in the root zone
  WidgetsFlutterBinding.ensureInitialized();

  // Run app in error-catching zone
  runZonedGuarded(() async {
    // Initialize Firebase
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    // Initialize PostHog
    final postHogService = PostHogService();
    await postHogService.initialize();

    // Initialize Remote Config
    final remoteConfigService =
        RemoteConfigService(FirebaseRemoteConfig.instance);
    await remoteConfigService.initialize();

    // Initialize App Check (for Play Integrity)
    final appCheckService = AppCheckService();
    await appCheckService.initialize();

    // Set up global error handlers
    FlutterError.onError = (FlutterErrorDetails details) {
      // Log Flutter framework errors to PostHog
      postHogService.logFlutterError(details);

      // Also print to console in debug mode
      FlutterError.presentError(details);
    };

    runApp(SeasonBox(
      postHogService: postHogService,
      remoteConfigService: remoteConfigService,
      appCheckService: appCheckService,
    ));
  }, (error, stackTrace) {
    // Catch errors that occur outside of Flutter framework
    // This includes async errors, platform errors, etc.
    // ignore: avoid_print
    print('Uncaught error: $error');
    // ignore: avoid_print
    print('Stack trace: $stackTrace');

    // Display error in the console but also try to show it on screen
    // This helps "un-stick" the app from the splash screen
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InitializationErrorScreen(error: error),
    ));

    // Try to log to PostHog if possible
    try {
      final postHog = PostHogService();
      postHog.logError(
        'uncaught_zone_error',
        error,
        stackTrace: stackTrace,
        context: {'error_source': 'runZonedGuarded'},
      );
    } catch (e) {
      // ignore: avoid_print
      print('Failed to log error to PostHog: $e');
    }
  });
}

class InitializationErrorScreen extends StatelessWidget {
  final dynamic error;

  const InitializationErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 64),
              const SizedBox(height: 16),
              const Text(
                'Initialization Error',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'The app failed to start due to a configuration error.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  error.toString(),
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    color: Colors.red,
                  ),
                ),
              ),
              if (error.toString().contains('firebase_options.dart') ||
                  error.toString().contains('appId')) ...[
                const SizedBox(height: 24),
                const Text(
                  'Possible Fix:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const SelectableText(
                  'Run "flutterfire configure" in your terminal to regenerate your Firebase configuration.',
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class SeasonBox extends StatelessWidget {
  final PostHogService postHogService;
  final RemoteConfigService remoteConfigService;
  final AppCheckService appCheckService;

  const SeasonBox({
    super.key,
    required this.postHogService,
    required this.remoteConfigService,
    required this.appCheckService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ChangeNotifierProvider<NavigationProvider>(
            create: (_) => NavigationProvider()),
        ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),
        ProxyProvider<AuthService, AppRouter>(
          update: (_, authService, __) => AppRouter(authService),
        ),
        Provider<FirestoreService>(create: (_) => FirestoreService()),
        Provider<BiometricService>(create: (_) => BiometricService()),
        Provider<StorageService>(create: (_) => StorageService()),
        Provider<PostHogService>.value(value: postHogService),
        Provider<RemoteConfigService>.value(value: remoteConfigService),
        Provider<AppCheckService>.value(value: appCheckService),
        ProxyProvider<RemoteConfigService, SubscriptionService>(
          update: (_, remoteConfigService, __) =>
              SubscriptionService(remoteConfigService),
        ),
        Provider<DemoDataService>(
          create: (_) => DemoDataService(),
        ),
        ProxyProvider<FirestoreService, FamilyRepository>(
          update: (_, firestoreService, __) =>
              FamilyRepository(firestoreService),
        ),
        ProxyProvider3<FirestoreService, AuthService, DemoDataService,
            FamilyMemberRepository>(
          update: (_, firestoreService, authService, demoDataService, __) =>
              FamilyMemberRepository(
                  firestoreService, authService, demoDataService),
        ),
        ProxyProvider4<FirestoreService, AuthService, DemoDataService,
            StorageService, ItemRepository>(
          update: (_, firestoreService, authService, demoDataService,
                  storageService, __) =>
              ItemRepository(firestoreService, authService, demoDataService,
                  storageService),
        ),
        ProxyProvider3<FirestoreService, AuthService, DemoDataService,
            StorageLocationRepository>(
          update: (_, firestoreService, authService, demoDataService, __) =>
              StorageLocationRepository(
                  firestoreService, authService, demoDataService),
        ),
        ProxyProvider<FirestoreService, UserService>(
          update: (_, firestoreService, __) => UserService(
            firestoreService,
          ),
        ),
        ChangeNotifierProxyProvider3<UserService, AuthService,
            SubscriptionService, UserProfileProvider>(
          create: (context) => UserProfileProvider(
            Provider.of<UserService>(context, listen: false),
            Provider.of<AuthService>(context, listen: false),
            Provider.of<SubscriptionService>(context, listen: false),
          ),
          update:
              (_, userService, authService, subscriptionService, previous) =>
                  previous ??
                  UserProfileProvider(
                      userService, authService, subscriptionService),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          final appRouter = Provider.of<AppRouter>(context, listen: false);
          return PostHogWidget(
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'SeasonBox',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeProvider.themeMode,
              routerConfig: appRouter.router,
              locale: themeProvider.locale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'), // English
                Locale('es'), // Spanish
                Locale('fr'), // French
                Locale('it'), // Italian
                Locale('de'), // German
              ],
            ),
          );
        },
      ),
    );
  }
}
