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
        PostHogService.log('Error checking user existence: $e',
            level: LogLevel.error);
      }
    }

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
    if (uid == 'demo_user') {
      // Return an empty stream or handling this should happen in Provider
      return const Stream.empty();
    }
    return _firestoreService.users.doc(uid).snapshots();
  }

  /// Helper to join a family for an existing user
  Future<void> joinFamily(String uid, String email, String familyCode) async {
    if (uid == 'demo_user') {
      PostHogService.log('Demo Mode: Join family ignored');
      return;
    }
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
  Future<void> leaveFamily(String uid, String currentFamilyId) async {
    if (uid == 'demo_user') {
      PostHogService.log('Demo Mode: Leave family ignored');
      return;
    }
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
  Future<void> updateUserProfile({
    required String uid,
    String? displayName,
    String? phoneNumber,
    String? photoURL,
    String? familyName,
    String? role,
    Map<String, dynamic>? preferences,
  }) async {
    if (uid == 'demo_user') {
      PostHogService.log('Demo Mode: Update profile ignored');
      return;
    }
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
