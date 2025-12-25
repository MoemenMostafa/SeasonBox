import '../models/family.dart';
import '../services/firestore_service.dart';

class FamilyRepository {
  final FirestoreService _firestoreService;

  FamilyRepository(this._firestoreService);

  Future<void> createFamily(Family family) async {
    await _firestoreService.setDocument(
      docRef: _firestoreService.families.doc(family.id),
      data: family.toMap(),
    );
  }

  Future<Family?> getFamily(String id) async {
    final doc = await _firestoreService.getDocument(
      docRef: _firestoreService.families.doc(id),
    );
    if (doc.exists) {
      return Family.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateFamily(Family family) async {
    await _firestoreService.updateDocument(
      docRef: _firestoreService.families.doc(family.id),
      data: family.toMap(),
    );
  }
}
