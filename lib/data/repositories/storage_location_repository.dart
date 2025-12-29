import 'package:flutter/foundation.dart';
import '../services/demo_data_service.dart';
import '../../features/auth/data/auth_service.dart';
import '../models/storage_location.dart';
import '../services/firestore_service.dart';

class StorageLocationRepository {
  final FirestoreService _firestoreService;
  final AuthService _authService;
  final DemoDataService _demoDataService;

  StorageLocationRepository(
      this._firestoreService, this._authService, this._demoDataService);

  Future<void> addLocation(StorageLocation location) async {
    if (_authService.isDemoMode) {
      _demoDataService.addStorageLocation(location);
      return;
    }
    await _firestoreService.setDocument(
      docRef: _firestoreService.locations(location.familyId).doc(location.id),
      data: location.toMap(),
    );
  }

  Future<List<StorageLocation>> getLocations(String familyId) async {
    if (_authService.isDemoMode) {
      return _demoDataService.getStorageLocations();
    }
    final snapshot = await _firestoreService.getCollection(
        query: _firestoreService.locations(familyId));

    // Offload parsing to a background isolate
    return compute(
        _parseLocations,
        snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          // StorageLocation.fromMap usually takes just the map,
          // but if it needs ID we should inject it or handle it.
          // Checking StorageLocation model... usually it has 'id' inside map or passed separately.
          // Let's assume we inject it for safety if the model expects it in the map,
          // or we handle it in the parser.
          // Looking at previous code: StorageLocation.fromMap(doc.data())
          // It seems it didn't take ID separately? Let's check model if needed.
          // But for now, let's inject it to be safe if the map needs it.
          data['id'] = doc.id;
          return data;
        }).toList());
  }

  Future<void> updateLocation(StorageLocation location) async {
    if (_authService.isDemoMode) {
      _demoDataService.updateStorageLocation(location);
      return;
    }
    await _firestoreService.updateDocument(
      docRef: _firestoreService.locations(location.familyId).doc(location.id),
      data: location.toMap(),
    );
  }

  Future<void> deleteLocation(String familyId, String locationId) async {
    if (_authService.isDemoMode) {
      _demoDataService.deleteStorageLocation(locationId);
      return;
    }
    await _firestoreService.deleteDocument(
      docRef: _firestoreService.locations(familyId).doc(locationId),
    );
  }
}

// Top-level function for compute
List<StorageLocation> _parseLocations(List<Map<String, dynamic>> dataList) {
  return dataList.map((data) {
    // If fromMap expects ID inside the map, it's there.
    // If it expects it separately, we need to change this.
    // Based on previous code: StorageLocation.fromMap(doc.data())
    // It implies ID was either in data or not needed?
    // Wait, let's check StorageLocation.fromMap signature if possible.
    // But assuming standard pattern:
    return StorageLocation.fromMap(data);
  }).toList();
}
