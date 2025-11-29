import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/foundation.dart';

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

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // The user canceled the sign-in

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      // Handle specific errors if needed
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      _cachedFamilyId = null; // Clear cache on sign out
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      // Ignore error
    }
  }
}
