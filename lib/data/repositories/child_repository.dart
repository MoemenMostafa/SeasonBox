import '../models/child.dart';
import '../services/firestore_service.dart';

class ChildRepository {
  final FirestoreService _firestoreService;

  ChildRepository(this._firestoreService);

  Future<void> addChild(Child child) async {
    await _firestoreService
        .children(child.familyId)
        .doc(child.id)
        .set(child.toMap());
  }

  Future<List<Child>> getChildren(String familyId) async {
    final snapshot = await _firestoreService.children(familyId).get();
    return snapshot.docs
        .map((doc) => Child.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> updateChild(Child child) async {
    await _firestoreService
        .children(child.familyId)
        .doc(child.id)
        .update(child.toMap());
  }

  Future<void> deleteChild(String familyId, String childId) async {
    await _firestoreService.children(familyId).doc(childId).delete();
  }
}
