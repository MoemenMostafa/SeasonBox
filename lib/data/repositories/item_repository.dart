import '../services/demo_data_service.dart';
import '../../features/auth/data/auth_service.dart';
import '../models/item.dart';
import '../services/firestore_service.dart';
import '../services/posthog_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemRepository {
  final FirestoreService _firestoreService;
  final AuthService _authService;
  final DemoDataService _demoDataService;

  ItemRepository(
      this._firestoreService, this._authService, this._demoDataService);

  Future<void> addItem(Item item) async {
    if (_authService.isDemoMode) {
      _demoDataService.addItem(item);
      return;
    }
    await _firestoreService.setDocument(
      docRef: _firestoreService.items(item.familyId).doc(item.id),
      data: item.toMap(),
    );
  }

  Future<List<Item>> getItems(String familyId, {String? ownerId}) async {
    if (_authService.isDemoMode) {
      return _demoDataService.getItems(ownerId: ownerId);
    }
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
    if (_authService.isDemoMode) {
      _demoDataService.updateItem(item);
      return;
    }
    await _firestoreService.updateDocument(
      docRef: _firestoreService.items(item.familyId).doc(item.id),
      data: item.toMap(),
    );
  }

  Future<void> deleteItem(String familyId, String itemId) async {
    if (_authService.isDemoMode) {
      _demoDataService.deleteItem(itemId);
      return;
    }
    await _firestoreService.deleteDocument(
      docRef: _firestoreService.items(familyId).doc(itemId),
    );
  }
}
