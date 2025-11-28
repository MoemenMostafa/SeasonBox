class Family {
  final String id;
  final List<String> members;
  final Map<String, dynamic> settings;

  Family({
    required this.id,
    required this.members,
    this.settings = const {},
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'members': members,
      'settings': settings,
    };
  }

  factory Family.fromMap(Map<String, dynamic> map) {
    return Family(
      id: map['id'] ?? '',
      members: List<String>.from(map['members'] ?? []),
      settings: Map<String, dynamic>.from(map['settings'] ?? {}),
    );
  }
}
