import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/family.dart';
import '../repositories/family_repository.dart';
import 'firestore_service.dart';

/// Service responsible for creating a user record in Firestore and
/// ensuring a corresponding family document exists.
class UserService {
  final FirestoreService _firestoreService;
  final FamilyRepository _familyRepository;

  UserService(this._firestoreService, this._familyRepository);

  /// Creates a user document under the `users` collection and links the
  /// user to a family. If a family with the same ID does not exist, it is
  /// created with the user as the first member.
  Future<void> createUserAndLinkFamily(User firebaseUser) async {
    // Create / update the user document.
    await _firestoreService.users.doc(firebaseUser.uid).set({
      'uid': firebaseUser.uid,
      'email': firebaseUser.email,
      'displayName': firebaseUser.displayName,
      'familyId': firebaseUser.uid, // User's own family by default
    }, SetOptions(merge: true));

    // Ensure a family exists for this user.
    final existingFamily = await _familyRepository.getFamily(firebaseUser.uid);
    if (existingFamily == null) {
      final family = Family(
        id: firebaseUser.uid,
        settings: const {},
      );
      await _familyRepository.createFamily(family);
    }
  }
}
