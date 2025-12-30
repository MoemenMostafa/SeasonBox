import '../services/demo_data_service.dart';
import '../../features/auth/data/auth_service.dart';
import '../models/item.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';
import '../services/posthog_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemRepository {
  final FirestoreService _firestoreService;
  final AuthService _authService;
  final DemoDataService _demoDataService;
  final StorageService _storageService;

  ItemRepository(this._firestoreService, this._authService,
      this._demoDataService, this._storageService);

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

    // Delete associated images from storage first
    try {
      final doc = await _firestoreService.getDocument(
        docRef: _firestoreService.items(familyId).doc(itemId),
      );

      if (doc.exists) {
        final item = Item.fromMap(doc.data() as Map<String, dynamic>);
        for (var photo in item.photos) {
          final fullUrl = photo['full'];
          final thumbUrl = photo['thumb'];

          if (fullUrl != null && fullUrl.isNotEmpty) {
            await _storageService.deleteFile(fullUrl);
          }
          if (thumbUrl != null && thumbUrl.isNotEmpty && thumbUrl != fullUrl) {
            await _storageService.deleteFile(thumbUrl);
          }
        }
      }
    } catch (e) {
      // Log error but continue with document deletion to avoid orphaned records
      PostHogService().logError('item_images_deletion_failed', e, context: {
        'itemId': itemId,
        'familyId': familyId,
      });
    }

    await _firestoreService.deleteDocument(
      docRef: _firestoreService.items(familyId).doc(itemId),
    );
  }
}
