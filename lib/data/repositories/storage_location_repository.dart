import '../models/storage_location.dart';
import '../services/firestore_service.dart';

class StorageLocationRepository {
  final FirestoreService _firestoreService;

  StorageLocationRepository(this._firestoreService);

  Future<void> addLocation(StorageLocation location) async {
    await _firestoreService
        .locations(location.familyId)
        .doc(location.id)
        .set(location.toMap());
  }

  Future<List<StorageLocation>> getLocations(String familyId) async {
    final snapshot = await _firestoreService.locations(familyId).get();
    return snapshot.docs
        .map((doc) =>
            StorageLocation.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> updateLocation(StorageLocation location) async {
    await _firestoreService
        .locations(location.familyId)
        .doc(location.id)
        .update(location.toMap());
  }

  Future<void> deleteLocation(String familyId, String locationId) async {
    await _firestoreService.locations(familyId).doc(locationId).delete();
  }
}
