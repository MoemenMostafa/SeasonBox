import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../models/family.dart';
import '../models/family_member.dart';
import '../repositories/family_repository.dart';

import 'firestore_service.dart';
import 'posthog_service.dart';

/// Service responsible for user and family management.
/// Uses Cloud Functions for registration to bypass permission issues.
class UserService {
  final FirestoreService _firestoreService;
  final FamilyRepository _familyRepository;

  UserService(this._firestoreService, this._familyRepository);

  Future<void> createUserAndLinkFamily(User firebaseUser,
      {String? familyId, String? inviteCode}) async {
    // Optimization: Check if user already exists and is linked
    // If inviteCode is null, we can skip the Cloud Function if the user is already linked.
    if (inviteCode == null) {
      try {
        final userDoc =
            await _firestoreService.users.doc(firebaseUser.uid).get();
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
      final result =
          await functions.httpsCallable('createUserAndJoinFamily').call({
        'uid': firebaseUser.uid,
        'email': firebaseUser.email,
        'displayName': firebaseUser.displayName,
        'familyCode': inviteCode,
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
  Future<void> joinFamily(String uid, String email, String familyCode) async {
    final familyDoc = await _firestoreService.families.doc(familyCode).get();
    if (!familyDoc.exists) {
      throw Exception('Invalid Family Code');
    }

    // Verify invitation
    final invitedMemberQuery = await _firestoreService
        .familyMembers(familyCode)
        .where('inviteEmail', isEqualTo: email)
        .where('inviteStatus', isEqualTo: 'pending')
        .limit(1)
        .get();

    if (invitedMemberQuery.docs.isEmpty) {
      throw Exception('No active invitation found for this family.');
    }

    // Clean up pending invite
    // Start a batch
    final batch = _firestoreService.instance.batch();

    // 1. Delete the pending invite
    batch.delete(invitedMemberQuery.docs.first.reference);

    // 2. Add to Family Members
    // Fetch current user display name for the member name
    final userDoc = await _firestoreService.users.doc(uid).get();
    final displayName =
        (userDoc.data() as Map<String, dynamic>?)?['displayName'] ?? 'Member';

    final member = FamilyMember(
      id: uid,
      userId: uid,
      familyId: familyCode,
      name: displayName,
      role: 'member',
      birthdate: DateTime.now(),
      gender: 'Unisex',
    );

    // Manual set to include in batch (bypassing repo for atomicity)
    batch.set(
      _firestoreService.familyMembers(familyCode).doc(uid),
      member.toMap(),
    );

    // 3. Update User's familyId
    batch.update(_firestoreService.users.doc(uid), {'familyId': familyCode});

    // Commit all changes atomically
    await batch.commit();
  }

  /// Helper to leave current family and revert to personal family
  Future<void> leaveFamily(String uid, String currentFamilyId) async {
    final batch = _firestoreService.instance.batch();

    // If leaving own family (disbanding/resetting to solo)
    if (uid == currentFamilyId) {
      // Logic: "Leave" means reverting to a true solo state.
      // If there are other members, we should remove them (Disband).
      final membersQuery =
          await _firestoreService.familyMembers(currentFamilyId).get();
      for (var doc in membersQuery.docs) {
        batch.delete(doc.reference);
      }
    } else {
      // Regular leave: Remove self from old family
      batch.delete(_firestoreService.familyMembers(currentFamilyId).doc(uid));
    }

    // Ensure personal family exists
    var personalFamily = await _familyRepository.getFamily(uid);
    if (personalFamily == null) {
      final family = Family(
        id: uid,
        settings: const {},
      );
      // Manually set in batch to ensure atomicity
      batch.set(_firestoreService.families.doc(uid), family.toMap());
    }

    // Ensure they are a member of their personal family (as Admin)
    // We will blindly overwrite/set the user as admin in personal family to ensure they are there.
    // This avoids the 'exists' check which might be stale or slow.

    // Fetch current user display name (if needed) - read before batch
    final userDoc = await _firestoreService.users.doc(uid).get();
    final displayName =
        (userDoc.data() as Map<String, dynamic>?)?['displayName'] ?? 'Admin';

    final member = FamilyMember(
      id: uid,
      userId: uid,
      familyId: uid,
      name: displayName,
      role: 'admin',
      birthdate: DateTime.now(),
      gender: 'Unisex',
    );

    batch.set(_firestoreService.familyMembers(uid).doc(uid), member.toMap());

    // Update User to point to personal family
    batch.update(_firestoreService.users.doc(uid), {'familyId': uid});

    await batch.commit();
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
    final Map<String, dynamic> data = {};
    if (displayName != null) data['displayName'] = displayName;
    if (phoneNumber != null) data['phoneNumber'] = phoneNumber;
    if (photoURL != null) data['photoURL'] = photoURL;
    if (familyName != null) data['familyName'] = familyName;
    if (role != null) data['role'] = role;
    if (preferences != null) data['preferences'] = preferences;

    if (data.isNotEmpty) {
      await _firestoreService.users.doc(uid).update(data);
    }
  }
}
