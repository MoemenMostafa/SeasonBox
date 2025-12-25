import 'package:cloud_firestore/cloud_firestore.dart';
import 'posthog_service.dart';

/// Centralised Firestore access used throughout the app.
class FirestoreService {
  // Singleton Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseFirestore get instance => _firestore;

  // Top‑level collections
  CollectionReference get families => _firestore.collection('families');
  CollectionReference get users => _firestore.collection('users');

  // Sub‑collections scoped to a family
  CollectionReference familyMembers(String familyId) =>
      families.doc(familyId).collection('members');

  CollectionReference items(String familyId) =>
      families.doc(familyId).collection('items');

  CollectionReference locations(String familyId) =>
      families.doc(familyId).collection('locations');

  // --- Logging Wrappers ---

  Future<void> setDocument({
    required DocumentReference docRef,
    required Map<String, dynamic> data,
  }) async {
    try {
      await PostHogService.log('Firestore SET: ${docRef.path}',
          level: LogLevel.info, context: {'path': docRef.path});
      await docRef.set(data);
    } catch (e) {
      PostHogService()
          .logError('firestore_set_failed', e, context: {'path': docRef.path});
      rethrow;
    }
  }

  Future<void> updateDocument({
    required DocumentReference docRef,
    required Map<String, dynamic> data,
  }) async {
    try {
      await PostHogService.log('Firestore UPDATE: ${docRef.path}',
          level: LogLevel.info, context: {'path': docRef.path});
      await docRef.update(data);
    } catch (e) {
      PostHogService().logError('firestore_update_failed', e,
          context: {'path': docRef.path});
      rethrow;
    }
  }

  Future<void> deleteDocument({required DocumentReference docRef}) async {
    try {
      await PostHogService.log('Firestore DELETE: ${docRef.path}',
          level: LogLevel.info, context: {'path': docRef.path});
      await docRef.delete();
    } catch (e) {
      PostHogService().logError('firestore_delete_failed', e,
          context: {'path': docRef.path});
      rethrow;
    }
  }

  Future<DocumentReference> addDocument({
    required CollectionReference collectionRef,
    required Map<String, dynamic> data,
  }) async {
    try {
      await PostHogService.log('Firestore ADD: ${collectionRef.path}',
          level: LogLevel.info, context: {'path': collectionRef.path});
      final docRef = await collectionRef.add(data);
      return docRef;
    } catch (e) {
      PostHogService().logError('firestore_add_failed', e,
          context: {'path': collectionRef.path});
      rethrow;
    }
  }

  Future<DocumentSnapshot> getDocument(
      {required DocumentReference docRef}) async {
    try {
      await PostHogService.log('Firestore GET: ${docRef.path}',
          level: LogLevel.debug, context: {'path': docRef.path});
      return await docRef.get();
    } catch (e) {
      PostHogService().logError('firestore_get_doc_failed', e,
          context: {'path': docRef.path});
      rethrow;
    }
  }

  Future<QuerySnapshot> getCollection({required Query query}) async {
    String path = 'unknown';
    if (query is CollectionReference) {
      path = query.path;
    } else {
      // For general queries, we might not have a simple path
      path = query.toString();
    }

    try {
      await PostHogService.log('Firestore GET_COLL: $path',
          level: LogLevel.debug, context: {'path': path});
      return await query.get();
    } catch (e) {
      PostHogService()
          .logError('firestore_get_coll_failed', e, context: {'path': path});
      rethrow;
    }
  }

  WriteBatch batch() {
    PostHogService.log('Firestore BATCH START', level: LogLevel.debug);
    return _firestore.batch();
  }

  Future<void> commitBatch(WriteBatch batch) async {
    try {
      await PostHogService.log('Firestore BATCH COMMIT', level: LogLevel.info);
      await batch.commit();
    } catch (e) {
      PostHogService().logError('firestore_batch_commit_failed', e);
      rethrow;
    }
  }
}
