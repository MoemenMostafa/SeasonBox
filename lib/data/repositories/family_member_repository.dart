import 'package:flutter/foundation.dart';
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

    // Offload parsing to a background isolate to prevent UI blocking
    return compute(
        _parseFamilyMembers,
        snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id; // Inject ID into map
          return data;
        }).toList());
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

  Future<List<FamilyMember>> getPendingInvites(String email) async {
    // Collection Group Query to find invites across all families
    final snapshot = await _firestoreService.instance
        .collectionGroup('members')
        .where('inviteEmail', isEqualTo: email)
        .where('inviteStatus', isEqualTo: 'pending')
        .get();

    return compute(
        _parseFamilyMembers,
        snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          // We need the familyId, which is usually in the data, but if not,
          // we can extract it from the reference path: families/{familyId}/members/{memberId}
          // The model expects familyId in the map.
          if (data['familyId'] == null) {
            data['familyId'] = doc.reference.parent.parent!.id;
          }
          return data;
        }).toList());
  }
}

// Top-level function for compute
List<FamilyMember> _parseFamilyMembers(List<Map<String, dynamic>> dataList) {
  return dataList.map((data) {
    final id = data['id'] as String;
    // Remove injected ID before passing to fromMap if necessary,
    // but fromMap takes ID as separate arg.
    // We need to handle this carefully.
    // Let's assume we pass the map and the ID is inside or we extract it.
    // Actually FamilyMember.fromMap takes (map, id).
    // So we need to restructure the map or change fromMap.
    // Ideally we pass a custom DTO or just use the map.
    return FamilyMember.fromMap(data, id);
  }).toList();
}
