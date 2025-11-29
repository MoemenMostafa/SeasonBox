import 'package:cloud_firestore/cloud_firestore.dart';

/// Centralised Firestore access used throughout the app.
class FirestoreService {
  // Singleton Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseFirestore get instance => _firestore;

  // Top‑level collections
  CollectionReference get families => _firestore.collection('families');
  CollectionReference get users => _firestore.collection('users');

  // Sub‑collections scoped to a family
  CollectionReference children(String familyId) =>
      families.doc(familyId).collection('children');

  CollectionReference items(String familyId) =>
      families.doc(familyId).collection('items');

  CollectionReference locations(String familyId) =>
      families.doc(familyId).collection('locations');
}
