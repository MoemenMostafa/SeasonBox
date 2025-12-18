import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:seasonbox/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:seasonbox/firebase_options.dart';
import 'package:seasonbox/features/auth/data/auth_service.dart';
import 'package:seasonbox/data/services/user_service.dart';
import 'package:seasonbox/data/services/biometric_service.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const SeasonBox());
}

class SeasonBox extends StatelessWidget {
  const SeasonBox({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ChangeNotifierProvider<NavigationProvider>(
            create: (_) => NavigationProvider()),
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<FirestoreService>(create: (_) => FirestoreService()),
        Provider<BiometricService>(create: (_) => BiometricService()),
        Provider<StorageService>(create: (_) => StorageService()),
        ProxyProvider<FirestoreService, FamilyRepository>(
          update: (_, firestoreService, __) =>
              FamilyRepository(firestoreService),
        ),
        ProxyProvider<FirestoreService, FamilyMemberRepository>(
          update: (_, firestoreService, __) =>
              FamilyMemberRepository(firestoreService),
        ),
        ProxyProvider<FirestoreService, ItemRepository>(
          update: (_, firestoreService, __) => ItemRepository(firestoreService),
        ),
        ProxyProvider<FirestoreService, StorageLocationRepository>(
          update: (_, firestoreService, __) =>
              StorageLocationRepository(firestoreService),
        ),
        ProxyProvider2<FirestoreService, FamilyRepository, UserService>(
          update: (_, firestoreService, familyRepository, __) =>
              UserService(firestoreService, familyRepository),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            title: 'SeasonBox',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            routerConfig: AppRouter.router,
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
          );
        },
      ),
    );
  }
}
