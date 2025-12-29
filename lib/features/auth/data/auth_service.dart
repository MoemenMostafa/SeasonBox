import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:seasonbox/data/services/posthog_service.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb
        ? '839774020308-njatk3ugsi9q8ssq7oibs7ops0su7p38.apps.googleusercontent.com'
        : null,
  );

  String? _cachedFamilyId;
  bool _isDemoMode = false;
  bool get isDemoMode => _isDemoMode;

  AuthService() {
    _auth.authStateChanges().listen((user) {
      notifyListeners();
    });
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  /// Returns 'demo_user' in demo mode, otherwise the Firebase User ID.
  String? get currentUid {
    if (_isDemoMode) return 'demo_user';
    return currentUser?.uid;
  }

  /// Enters Demo Mode locally without Firebase Auth.
  void enterDemoMode() {
    _isDemoMode = true;
    _cachedFamilyId = 'demo_family';
    notifyListeners();
    PostHogService.log('Entered Demo Mode', level: LogLevel.info);
  }

  /// Exits Demo Mode locally.
  void exitDemoMode() {
    _isDemoMode = false;
    _cachedFamilyId = null;
    notifyListeners();
    PostHogService.log('Exited Demo Mode', level: LogLevel.info);
  }

  /// Gets the family ID for the current user from Firestore.
  /// Returns null if user is not authenticated.
  /// Caches the result to avoid repeated Firestore calls.
  Future<String?> getCurrentUserFamilyId() async {
    if (_isDemoMode) return 'demo_family';

    final user = currentUser;
    if (user == null) return null;

    // Return cached value if available
    if (_cachedFamilyId != null) return _cachedFamilyId;

    try {
      // Fetch user document from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data();
        _cachedFamilyId = data?['familyId'] ?? user.uid;
      } else {
        // Fallback to uid if user document doesn't exist
        _cachedFamilyId = user.uid;
      }

      return _cachedFamilyId;
    } catch (e) {
      // On error, fallback to uid
      return user.uid;
    }
  }

  Future<User?> signInWithGoogle({bool trySilentFirst = false}) async {
    return await PostHogService().trackLatency('google_sign_in', () async {
      try {
        GoogleSignInAccount? googleUser;
        if (trySilentFirst) {
          try {
            await PostHogService.log('Attempting silent sign-in',
                level: LogLevel.info);
            googleUser = await _googleSignIn.signInSilently();
          } catch (e) {
            PostHogService.log('Silent sign-in error: $e',
                level: LogLevel.error);
          }
        }

        // If silent failed or wasn't requested, try interactive
        if (googleUser == null) {
          await PostHogService.log('Attempting interactive Google sign-in',
              level: LogLevel.info);
          googleUser = await _googleSignIn.signIn();
        }

        if (googleUser == null) {
          await PostHogService.log('Google sign-in canceled by user',
              level: LogLevel.info);
          return null;
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        final user = userCredential.user;

        if (user != null && user.email != null) {
          await PostHogService().identify(
            userId: user.uid,
            userProperties: {
              'email': user.email!,
              'sign_in_method': 'google',
            },
          );
          await PostHogService.log('Google sign-in successful: ${user.uid}',
              level: LogLevel.info);
        }

        return user;
      } on FirebaseAuthException catch (e) {
        PostHogService().logError('google_sign_in_auth_failed', e);
        throw Exception('Firebase Auth Error: ${e.code} - ${e.message}');
      } on PlatformException catch (e) {
        PostHogService().logError('google_sign_in_platform_failed', e);
        throw Exception('Platform Error: ${e.code} - ${e.message}');
      } catch (e) {
        PostHogService().logError('google_sign_in_failed', e);
        throw Exception('Google Sign-In failed: ${e.toString()}');
      }
    });
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    return await PostHogService().trackLatency('email_sign_in', () async {
      try {
        await PostHogService.log('Attempting email sign-in',
            level: LogLevel.info);
        final UserCredential userCredential =
            await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        final user = userCredential.user;

        if (user != null && user.email != null) {
          await PostHogService().identify(
            userId: user.uid,
            userProperties: {
              'email': user.email!,
              'sign_in_method': 'email',
            },
          );
          await PostHogService.log('Email sign-in successful: ${user.uid}',
              level: LogLevel.info);
        }

        return user;
      } catch (e) {
        PostHogService().logError('email_sign_in_failed', e);
        rethrow;
      }
    }, context: {'email': email});
  }

  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;

      if (user != null && user.email != null) {
        await PostHogService().identify(
          userId: user.uid,
          userProperties: {
            'email': user.email!,
            'sign_in_method': 'email_create',
          },
        );
      }

      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await PostHogService().trackLatency('sign_out', () async {
      try {
        if (_isDemoMode) {
          exitDemoMode();
          return;
        }
        _cachedFamilyId = null; // Clear cache on sign out
        await PostHogService.log('Signing out', level: LogLevel.info);
        try {
          await _googleSignIn.signOut();
        } catch (e) {
          // Ignore Google Sign-In errors (e.g., if checking on non-Google user)
          PostHogService.log('Google Sign-In signOut error: $e',
              level: LogLevel.error);
        }
        await _auth.signOut();
        await PostHogService().reset();
        await PostHogService.log('Sign out successful', level: LogLevel.info);
      } catch (e) {
        PostHogService().logError('sign_out_failed', e);
      }
    });
  }

  // NOTE: signInAnonymously is effectively replaced by enterDemoMode for the "Demo" use case,
  // but we can keep it if it's used for true anonymous auth elsewhere.
  // For this task, we will remove the isDemo param support from it or just ignore it.
  Future<User?> signInAnonymously() async {
    try {
      final userCredential = await _auth.signInAnonymously();
      return userCredential.user;
    } catch (e) {
      PostHogService().logError('anonymous_sign_in_failed', e);
      rethrow;
    }
  }
}
