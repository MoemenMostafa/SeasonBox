import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/enums/gender.dart';

class FamilyMember {
  final String id;
  final String?
      userId; // Firebase Auth UID - links member to authenticated user
  final String familyId;
  final String name;
  final DateTime birthdate;
  final Gender gender;
  final String? clothingSize;
  final String? shoeSize;
  final String? notes;
  final Map<String, double> currentSizeByCategory;
  final List<Map<String, dynamic>> sizeHistory;
  final String? inviteEmail;
  final String? inviteStatus; // 'pending', 'accepted', 'none'
  final DateTime? lastInviteSent;
  final String role; // 'admin', 'member', 'child'
  final String? inviterName;

  FamilyMember({
    required this.id,
    this.userId,
    required this.familyId,
    required this.name,
    required this.birthdate,
    required this.gender,
    this.clothingSize,
    this.shoeSize,
    this.notes,
    this.currentSizeByCategory = const {},
    this.sizeHistory = const [],
    this.inviteEmail,
    this.inviteStatus,
    this.lastInviteSent,
    this.role = 'member',
    this.inviterName,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'familyId': familyId,
      'name': name,
      'birthdate': Timestamp.fromDate(birthdate),
      'gender': gender.toFirestore(),
      'clothingSize': clothingSize,
      'shoeSize': shoeSize,
      'notes': notes,
      'currentSizeByCategory': currentSizeByCategory,
      'sizeHistory': sizeHistory,
      'inviteEmail': inviteEmail,
      'inviteStatus': inviteStatus,
      'lastInviteSent':
          lastInviteSent != null ? Timestamp.fromDate(lastInviteSent!) : null,
      'role': role,
      'inviterName': inviterName,
    };
  }

  factory FamilyMember.fromMap(Map<String, dynamic> map, String id) {
    return FamilyMember(
      id: id,
      userId: map['userId'],
      familyId: map['familyId'] ?? '',
      name: map['name'] ?? '',
      birthdate: (map['birthdate'] as Timestamp).toDate(),
      gender: Gender.fromFirestore(map['gender']),
      clothingSize: map['clothingSize']?.toString(),
      shoeSize: map['shoeSize']?.toString(),
      notes: map['notes'],
      currentSizeByCategory:
          Map<String, double>.from(map['currentSizeByCategory'] ?? {}),
      sizeHistory: List<Map<String, dynamic>>.from(map['sizeHistory'] ?? []),
      inviteEmail: map['inviteEmail'],
      inviteStatus: map['inviteStatus'],
      lastInviteSent: map['lastInviteSent'] != null
          ? (map['lastInviteSent'] as Timestamp).toDate()
          : null,
      role: map['role'] ?? 'member',
      inviterName: map['inviterName'],
    );
  }
}
