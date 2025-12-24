import '../models/item.dart';
import '../services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemRepository {
  final FirestoreService _firestoreService;

  ItemRepository(this._firestoreService);

  Future<void> addItem(Item item) async {
    await _firestoreService.items(item.familyId).doc(item.id).set(item.toMap());
  }

  Future<List<Item>> getItems(String familyId, {String? ownerId}) async {
    Query query = _firestoreService.items(familyId);

    if (ownerId != null) {
      query = query.where('ownerId', isEqualTo: ownerId);
    }

    final snapshot = await query.get();
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
