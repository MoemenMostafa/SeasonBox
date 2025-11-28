import '../models/item.dart';
import '../services/firestore_service.dart';

class ItemRepository {
  final FirestoreService _firestoreService;

  ItemRepository(this._firestoreService);

  Future<void> addItem(Item item) async {
    await _firestoreService
        .items(item.familyId)
        .doc(item.id)
        .set(item.toMap());
  }

  Future<List<Item>> getItems(String familyId) async {
    final snapshot = await _firestoreService.items(familyId).get();
    return snapshot.docs
        .map((doc) => Item.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> updateItem(Item item) async {
    await _firestoreService
        .items(item.familyId)
        .doc(item.id)
        .update(item.toMap());
  }

  Future<void> deleteItem(String familyId, String itemId) async {
    await _firestoreService.items(familyId).doc(itemId).delete();
  }
}
