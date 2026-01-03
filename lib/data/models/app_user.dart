import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a user in the application.
/// Note: Named AppUser to avoid conflict with Firebase Auth's User class.
class AppUser {
  final String uid;
  final String? email;
  final String? displayName;
  final String familyId;
  final String subscriptionTier; // 'free' or 'paid'
  final DateTime? subscriptionExpiry;
  final String? subscriptionId;

  AppUser({
    required this.uid,
    this.email,
    this.displayName,
    required this.familyId,
    this.subscriptionTier = 'free',
    this.subscriptionExpiry,
    this.subscriptionId,
  });

  factory AppUser.fromMap(Map<String, dynamic> map, String uid) {
    DateTime? expiry;
    if (map['subscriptionExpiry'] != null) {
      if (map['subscriptionExpiry'] is Timestamp) {
        expiry = (map['subscriptionExpiry'] as Timestamp).toDate();
      } else if (map['subscriptionExpiry'] is int) {
        expiry = DateTime.fromMillisecondsSinceEpoch(map['subscriptionExpiry']);
      }
    }

    return AppUser(
      uid: uid,
      email: map['email'],
      displayName: map['displayName'],
      familyId:
          map['familyId'] ?? uid, // Default to uid for backward compatibility
      subscriptionTier: map['subscriptionTier'] ?? 'free',
      subscriptionExpiry: expiry,
      subscriptionId: map['subscriptionId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'familyId': familyId,
      'subscriptionTier': subscriptionTier,
      'subscriptionExpiry': subscriptionExpiry != null
          ? Timestamp.fromDate(subscriptionExpiry!)
          : null,
      'subscriptionId': subscriptionId,
    };
  }
}
