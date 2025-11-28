import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseFirestore get instance => _firestore;

  // Collections
  CollectionReference get families => _firestore.collection('families');

  // Helper to get subcollection
  CollectionReference children(String familyId) =>
      families.doc(familyId).collection('children');

  CollectionReference items(String familyId) =>
      families.doc(familyId).collection('items');

  CollectionReference locations(String familyId) =>
      families.doc(familyId).collection('locations');
}
