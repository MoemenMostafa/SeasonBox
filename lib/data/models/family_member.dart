import 'package:cloud_firestore/cloud_firestore.dart';

class FamilyMember {
  final String id;
  final String familyId;
  final String name;
  final DateTime birthdate;
  final String gender;
  final Map<String, double> currentSizeByCategory;
  final List<Map<String, dynamic>> sizeHistory;

  FamilyMember({
    required this.id,
    required this.familyId,
    required this.name,
    required this.birthdate,
    required this.gender,
    this.currentSizeByCategory = const {},
    this.sizeHistory = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'familyId': familyId,
      'name': name,
      'birthdate': Timestamp.fromDate(birthdate),
      'gender': gender,
      'currentSizeByCategory': currentSizeByCategory,
      'sizeHistory': sizeHistory,
    };
  }

  factory FamilyMember.fromMap(Map<String, dynamic> map, String id) {
    return FamilyMember(
      id: id,
      familyId: map['familyId'] ?? '',
      name: map['name'] ?? '',
      birthdate: (map['birthdate'] as Timestamp).toDate(),
      gender: map['gender'] ?? 'Unisex',
      currentSizeByCategory:
          Map<String, double>.from(map['currentSizeByCategory'] ?? {}),
      sizeHistory: List<Map<String, dynamic>>.from(map['sizeHistory'] ?? []),
    );
  }
}
