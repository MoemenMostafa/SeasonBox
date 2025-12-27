import 'package:cloud_firestore/cloud_firestore.dart';
import 'posthog_service.dart';
import '../../core/errors/app_exception.dart';

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

  Future<T> _handleFirestoreOperation<T>(Future<T> Function() operation,
      String operationName, Map<String, dynamic> context) async {
    try {
      await PostHogService.log('Firestore $operationName START',
          level: LogLevel.info, context: context);
      final result = await operation();
      return result;
    } catch (e) {
      String message = 'An unexpected error occurred. Please try again.';
      String code = 'unknown';

      if (e is FirebaseException) {
        code = e.code;
        switch (e.code) {
          case 'permission-denied':
            message = 'You do not have permission to perform this action.';
            break;
          case 'unavailable':
            message =
                'Service is currently unavailable. Please checking your internet connection.';
            break;
          case 'not-found':
            message = 'The requested resource was not found.';
            break;
          default:
            message = 'Database error: ${e.message ?? "Unknown error"}';
        }
      }

      PostHogService().logError(
          'firestore_${operationName.toLowerCase()}_failed', e,
          context: {...context, 'code': code});

      throw AppException(message, code: code, originalError: e);
    }
  }

  Future<void> setDocument({
    required DocumentReference docRef,
    required Map<String, dynamic> data,
  }) async {
    await _handleFirestoreOperation(
      () => docRef.set(data),
      'SET',
      {'path': docRef.path},
    );
  }

  Future<void> updateDocument({
    required DocumentReference docRef,
    required Map<String, dynamic> data,
  }) async {
    await _handleFirestoreOperation(
      () => docRef.update(data),
      'UPDATE',
      {'path': docRef.path},
    );
  }

  Future<void> deleteDocument({required DocumentReference docRef}) async {
    await _handleFirestoreOperation(
      () => docRef.delete(),
      'DELETE',
      {'path': docRef.path},
    );
  }

  Future<DocumentReference> addDocument({
    required CollectionReference collectionRef,
    required Map<String, dynamic> data,
  }) async {
    return await _handleFirestoreOperation(
      () => collectionRef.add(data),
      'ADD',
      {'path': collectionRef.path},
    );
  }

  Future<DocumentSnapshot> getDocument(
      {required DocumentReference docRef}) async {
    return await _handleFirestoreOperation(
      () => docRef.get(),
      'GET',
      {'path': docRef.path},
    );
  }

  Future<QuerySnapshot> getCollection({required Query query}) async {
    String path = 'unknown';
    if (query is CollectionReference) {
      path = query.path;
    } else {
      path = query.toString();
    }

    return await _handleFirestoreOperation(
      () => query.get(),
      'GET_COLL',
      {'path': path},
    );
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
      String message = 'Failed to save changes. Please try again.';
      if (e is FirebaseException && e.code == 'permission-denied') {
        message = 'You do not have permission to perform this action.';
      }
      PostHogService().logError('firestore_batch_commit_failed', e);
      throw AppException(message, code: 'batch_failed', originalError: e);
    }
  }
}
