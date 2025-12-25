import '../models/item.dart';
import '../services/firestore_service.dart';
import '../services/posthog_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemRepository {
  final FirestoreService _firestoreService;

  ItemRepository(this._firestoreService);

  Future<void> addItem(Item item) async {
    await _firestoreService.setDocument(
      docRef: _firestoreService.items(item.familyId).doc(item.id),
      data: item.toMap(),
    );
  }

  Future<List<Item>> getItems(String familyId, {String? ownerId}) async {
    return await PostHogService().trackLatency('firestore_get_items', () async {
      Query query = _firestoreService.items(familyId);

      if (ownerId != null) {
        query = query.where('ownerId', isEqualTo: ownerId);
      }

      final snapshot = await _firestoreService.getCollection(query: query);
      return snapshot.docs
          .map((doc) => Item.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Future<void> updateItem(Item item) async {
    await _firestoreService.updateDocument(
      docRef: _firestoreService.items(item.familyId).doc(item.id),
      data: item.toMap(),
    );
  }

  Future<void> deleteItem(String familyId, String itemId) async {
    await _firestoreService.deleteDocument(
      docRef: _firestoreService.items(familyId).doc(itemId),
    );
  }
}
