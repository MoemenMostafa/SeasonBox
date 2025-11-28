class Child {
  final String id;
  final String familyId;
  final String name;
  final DateTime birthdate;
  final String gender;
  final Map<String, double> currentSizeByCategory;
  final List<Map<String, dynamic>> sizeHistory;

  Child({
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
      'id': id,
      'familyId': familyId,
      'name': name,
      'birthdate': birthdate.toIso8601String(),
      'gender': gender,
      'currentSizeByCategory': currentSizeByCategory,
      'sizeHistory': sizeHistory,
    };
  }

  factory Child.fromMap(Map<String, dynamic> map) {
    return Child(
      id: map['id'] ?? '',
      familyId: map['familyId'] ?? '',
      name: map['name'] ?? '',
      birthdate:
          DateTime.parse(map['birthdate'] ?? DateTime.now().toIso8601String()),
      gender: map['gender'] ?? '',
      currentSizeByCategory:
          Map<String, double>.from(map['currentSizeByCategory'] ?? {}),
      sizeHistory: List<Map<String, dynamic>>.from(map['sizeHistory'] ?? []),
    );
  }
}
