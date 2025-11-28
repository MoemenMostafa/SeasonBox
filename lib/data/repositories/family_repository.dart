import '../models/family.dart';
import '../services/firestore_service.dart';

class FamilyRepository {
  final FirestoreService _firestoreService;

  FamilyRepository(this._firestoreService);

  Future<void> createFamily(Family family) async {
    await _firestoreService.families.doc(family.id).set(family.toMap());
  }

  Future<Family?> getFamily(String id) async {
    final doc = await _firestoreService.families.doc(id).get();
    if (doc.exists) {
      return Family.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateFamily(Family family) async {
    await _firestoreService.families.doc(family.id).update(family.toMap());
  }
}
