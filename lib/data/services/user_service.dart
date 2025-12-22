import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/family.dart';
import '../models/family_member.dart';
import '../repositories/family_repository.dart';
import '../repositories/family_member_repository.dart';
import 'firestore_service.dart';

/// Service responsible for creating a user record in Firestore and
/// ensuring a corresponding family document exists.
class UserService {
  final FirestoreService _firestoreService;
  final FamilyRepository _familyRepository;
  final FamilyMemberRepository _familyMemberRepository;

  UserService(this._firestoreService, this._familyRepository,
      this._familyMemberRepository);

  Future<void> createUserAndLinkFamily(User firebaseUser,
      {String? familyId, String? inviteCode}) async {
    String? targetFamilyId = familyId;

    // If an invite code (familyId) is provided, verify it exists
    if (inviteCode != null && inviteCode.isNotEmpty) {
      final familyDoc = await _firestoreService.families.doc(inviteCode).get();
      if (familyDoc.exists) {
        targetFamilyId = inviteCode;
      } else {
        // If invalid code, we could throw, or fall back.
        // For better UX, let's assume validation happened before,
        // or we fallback to creating a new one but maybe that's confusing.
        // Let's rely on UI validation for existence?? No, UI can't check easily without auth.
        // Actually, if we are here, USER IS AUTHENTICATED (firebaseUser exists).
        // So we can check.
        // But let's assume if provided functionality is "Join Family", we try to join.
        // If it fails, maybe we should error out?
        // For now, let's implement the logic: if code provided & valid -> join. Else -> create new.
        if (targetFamilyId == null) {
          // if familyId param wasn't set directly
          throw Exception('Invalid Family Code');
        }
      }
    }

    // Default to user's UID if no valid family found/provided
    targetFamilyId ??= firebaseUser.uid;

    // Create / update the user document.
    await _firestoreService.users.doc(firebaseUser.uid).set({
      'uid': firebaseUser.uid,
      'email': firebaseUser.email,
      'displayName': firebaseUser.displayName,
      'familyId': targetFamilyId,
      'photoURL': firebaseUser.photoURL,
      'phoneNumber': firebaseUser.phoneNumber,
      'role': 'member', // Default role
    }, SetOptions(merge: true));

    // Ensure a family exists for this user (if creating new) OR add to existing (logic handled by FamilyMemberRepository separately or implicitly by just setting ID here?)
    // Wait, if joining, we just set familyId. The FamilyMember object needs to be created in the family's members subcollection.

    if (targetFamilyId == firebaseUser.uid) {
      // New Family Case
      final existingFamily =
          await _familyRepository.getFamily(firebaseUser.uid);
      if (existingFamily == null) {
        final family = Family(
          id: firebaseUser.uid,
          settings: const {},
        );
        await _familyRepository.createFamily(family);

        // Add user as Admin of their own new family
        final member = FamilyMember(
          id: firebaseUser.uid,
          familyId: firebaseUser.uid,
          name: firebaseUser.displayName ?? 'Admin',
          role: 'admin',
          birthdate: DateTime.now(),
          gender: 'Unisex',
        );
        await _familyMemberRepository.addFamilyMember(member);
      }
    } else {
      // Joining Existing Family
      final member = FamilyMember(
        id: firebaseUser.uid,
        familyId: targetFamilyId,
        name: firebaseUser.displayName ?? 'New Member',
        role: 'member',
        birthdate: DateTime.now(),
        gender: 'Unisex',
      );
      await _familyMemberRepository.addFamilyMember(member);
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
    await invitedMemberQuery.docs.first.reference.delete();

    // Update User
    await _firestoreService.users.doc(uid).update({'familyId': familyCode});

    // Add to Family Members
    // Fetch current user display name for the member name
    final userDoc = await _firestoreService.users.doc(uid).get();
    final displayName =
        (userDoc.data() as Map<String, dynamic>?)?['displayName'] ?? 'Member';

    final member = FamilyMember(
      id: uid,
      familyId: familyCode,
      name: displayName,
      role: 'member',
      birthdate: DateTime.now(),
      gender: 'Unisex',
    );
    await _familyMemberRepository.addFamilyMember(member);
  }

  /// Helper to leave current family and revert to personal family
  Future<void> leaveFamily(String uid, String currentFamilyId) async {
    if (uid == currentFamilyId) return; // Already in personal family

    // Remove from current family members
    await _familyMemberRepository.deleteFamilyMember(currentFamilyId, uid);

    // Create/Switch to personal family
    // Check if personal family exists (it should usually)
    var personalFamily = await _familyRepository.getFamily(uid);
    if (personalFamily == null) {
      final family = Family(
        id: uid,
        settings: const {},
      );
      await _familyRepository.createFamily(family);
    }

    // Update User
    await _firestoreService.users.doc(uid).update({'familyId': uid});

    // Ensure they are a member of their personal family
    final members = await _familyMemberRepository.getFamilyMembers(uid);
    final exists = members.any((m) => m.id == uid);

    if (!exists) {
      // Fetch current user display name
      final userDoc = await _firestoreService.users.doc(uid).get();
      final displayName =
          (userDoc.data() as Map<String, dynamic>?)?['displayName'] ?? 'Admin';

      final member = FamilyMember(
        id: uid,
        familyId: uid,
        name: displayName,
        role: 'admin',
        birthdate: DateTime.now(),
        gender: 'Unisex',
      );
      await _familyMemberRepository.addFamilyMember(member);
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
