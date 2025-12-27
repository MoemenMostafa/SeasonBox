/// Represents a user in the application.
/// Note: Named AppUser to avoid conflict with Firebase Auth's User class.
class AppUser {
  final String uid;
  final String? email;
  final String? displayName;
  final String familyId;
  final String subscriptionTier; // 'free' or 'paid'

  AppUser({
    required this.uid,
    this.email,
    this.displayName,
    required this.familyId,
    this.subscriptionTier = 'free',
  });

  factory AppUser.fromMap(Map<String, dynamic> map, String uid) {
    return AppUser(
      uid: uid,
      email: map['email'],
      displayName: map['displayName'],
      familyId:
          map['familyId'] ?? uid, // Default to uid for backward compatibility
      subscriptionTier: map['subscriptionTier'] ?? 'free',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'familyId': familyId,
      'subscriptionTier': subscriptionTier,
    };
  }
}
