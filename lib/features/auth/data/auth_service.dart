import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:seasonbox/data/services/posthog_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb
        ? '839774020308-njatk3ugsi9q8ssq7oibs7ops0su7p38.apps.googleusercontent.com'
        : null,
  );

  String? _cachedFamilyId;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  /// Gets the family ID for the current user from Firestore.
  /// Returns null if user is not authenticated.
  /// Caches the result to avoid repeated Firestore calls.
  Future<String?> getCurrentUserFamilyId() async {
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
    try {
      GoogleSignInAccount? googleUser;
      if (trySilentFirst) {
        try {
          googleUser = await _googleSignIn.signInSilently();
        } catch (e) {
          PostHogService.log('Silent sign-in error: $e', level: LogLevel.error);
        }
      }

      // If silent failed or wasn't requested, try interactive
      googleUser ??= await _googleSignIn.signIn();

      if (googleUser == null) {
        // The user canceled the sign-in
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
      }

      return user;
    } on FirebaseAuthException catch (e) {
      // Throw Firebase auth errors with details
      throw Exception('Firebase Auth Error: ${e.code} - ${e.message}');
    } on PlatformException catch (e) {
      // Handle platform-specific errors (e.g., Google Sign-In issues)
      throw Exception('Platform Error: ${e.code} - ${e.message}');
    } catch (e) {
      // Handle any other errors
      throw Exception('Google Sign-In failed: ${e.toString()}');
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
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
      }

      return user;
    } catch (e) {
      rethrow;
    }
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
    try {
      _cachedFamilyId = null; // Clear cache on sign out
      try {
        await _googleSignIn.signOut();
      } catch (e) {
        // Ignore Google Sign-In errors (e.g., if checking on non-Google user)
        PostHogService.log('Google Sign-In signOut error: $e',
            level: LogLevel.error);
      }
      await _auth.signOut();
      await PostHogService().reset();
    } catch (e) {
      // Ignore error
      PostHogService.log('AuthService signOut error: $e',
          level: LogLevel.error);
    }
  }
}
