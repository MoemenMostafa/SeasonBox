import '../models/family_member.dart';
import '../services/firestore_service.dart';

class FamilyMemberRepository {
  final FirestoreService _firestoreService;

  FamilyMemberRepository(this._firestoreService);

  Future<void> addFamilyMember(FamilyMember member) async {
    await _firestoreService
        .familyMembers(member.familyId)
        .doc(member.id)
        .set(member.toMap());
  }

  Future<List<FamilyMember>> getFamilyMembers(String familyId) async {
    final snapshot = await _firestoreService.familyMembers(familyId).get();
    return snapshot.docs
        .map((doc) =>
            FamilyMember.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<void> updateFamilyMember(FamilyMember member) async {
    await _firestoreService
        .familyMembers(member.familyId)
        .doc(member.id)
        .update(member.toMap());
  }

  Future<void> deleteFamilyMember(String familyId, String memberId) async {
    await _firestoreService.familyMembers(familyId).doc(memberId).delete();
  }
}
