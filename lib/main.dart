import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/data/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:myapp/firebase_options.dart';
import 'package:myapp/features/auth/data/auth_service.dart';
import 'package:myapp/app/routes/router.dart';
import 'package:myapp/app/theme/theme.dart';
import 'package:myapp/data/services/firestore_service.dart';
import 'package:myapp/data/repositories/family_repository.dart';
import 'package:myapp/data/repositories/family_member_repository.dart';
import 'package:myapp/data/repositories/item_repository.dart';
import 'package:myapp/data/repositories/storage_location_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<FirestoreService>(create: (_) => FirestoreService()),
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
      child: MaterialApp.router(
        title: 'SeasonBox',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
