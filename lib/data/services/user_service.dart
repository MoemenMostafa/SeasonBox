import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

import 'firestore_service.dart';
import 'posthog_service.dart';

/// Service responsible for user and family management.
/// Uses Cloud Functions for registration to bypass permission issues.
class UserService {
  final FirestoreService _firestoreService;

  UserService(this._firestoreService);

  Future<void> createUserAndLinkFamily(User firebaseUser,
      {String? familyId, String? inviteCode}) async {
    // Optimization: Check if user already exists and is linked
    // If inviteCode is null, we can skip the Cloud Function if the user is already linked.
    if (inviteCode == null) {
      try {
        final userDoc = await _firestoreService.getDocument(
          docRef: _firestoreService.users.doc(firebaseUser.uid),
        );
        if (userDoc.exists) {
          final data = userDoc.data() as Map<String, dynamic>?;
          if (data != null && data['familyId'] != null) {
            PostHogService.log(
                'User already exists and is linked to family: ${data['familyId']}');
            return;
          }
        }
      } catch (e) {
        // Log error but continue to ensure user is created if there's an issue with the check
        PostHogService.log('Error checking user existence: $e',
            level: LogLevel.error);
      }
    }

    // Call Cloud Function instead of client-side Firestore operations
    // This bypasses permission issues by using admin SDK
    final functions = FirebaseFunctions.instance;

    try {
      final result = await PostHogService()
          .trackLatency('createUserAndJoinFamily_function', () async {
        return await functions.httpsCallable('createUserAndJoinFamily').call({
          'uid': firebaseUser.uid,
          'email': firebaseUser.email,
          'displayName': firebaseUser.displayName,
          'familyCode': inviteCode,
        });
      });

      PostHogService.log('User created successfully: ${result.data}');
    } catch (e) {
      PostHogService.log('Error calling createUserAndJoinFamily: $e',
          level: LogLevel.error);
      rethrow;
    }
  }

  /// Returns a stream of the user document for the given [uid].
  Stream<DocumentSnapshot> getUserStream(String uid) {
    return _firestoreService.users.doc(uid).snapshots();
  }

  /// Helper to join a family for an existing user
  /// Now calls a Cloud Function to handle updates securely.
  Future<void> joinFamily(String uid, String email, String familyCode) async {
    final functions = FirebaseFunctions.instance;
    try {
      await PostHogService().trackLatency('joinFamily_function', () async {
        return await functions.httpsCallable('joinFamily').call({
          'uid': uid,
          'email': email,
          'familyCode': familyCode,
        });
      });
      PostHogService.log('Joined family successfully via function');
    } catch (e) {
      PostHogService.log('Error joining family via function: $e',
          level: LogLevel.error);
      rethrow;
    }
  }

  /// Helper to leave current family and revert to personal family
  /// Now calls a Cloud Function to handle updates securely.
  Future<void> leaveFamily(String uid, String currentFamilyId) async {
    final functions = FirebaseFunctions.instance;
    try {
      await PostHogService().trackLatency('leaveFamily_function', () async {
        return await functions.httpsCallable('leaveFamily').call({
          'uid': uid,
          'currentFamilyId': currentFamilyId,
        });
      });
      PostHogService.log('Left family successfully via function');
    } catch (e) {
      PostHogService.log('Error leaving family via function: $e',
          level: LogLevel.error);
      rethrow;
    }
  }

  /// Updates the user's profile information in Firestore.
  /// Now calls a Cloud Function to handle updates securely.
  Future<void> updateUserProfile({
    required String uid,
    String? displayName,
    String? phoneNumber,
    String? photoURL,
    String? familyName,
    String? role,
    Map<String, dynamic>? preferences,
  }) async {
    final functions = FirebaseFunctions.instance;
    try {
      await PostHogService().trackLatency('updateUserProfile_function',
          () async {
        return await functions.httpsCallable('updateUserProfile').call({
          'uid': uid,
          if (displayName != null) 'displayName': displayName,
          if (phoneNumber != null) 'phoneNumber': phoneNumber,
          if (photoURL != null) 'photoURL': photoURL,
          if (familyName != null) 'familyName': familyName,
          if (role != null) 'role': role,
          if (preferences != null) 'preferences': preferences,
        });
      });
      PostHogService.log('User profile updated successfully via function');
    } catch (e) {
      PostHogService.log('Error updating user profile via function: $e',
          level: LogLevel.error);
      rethrow;
    }
  }
}
