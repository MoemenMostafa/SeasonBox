class Family {
  final String id;
  final Map<String, dynamic> settings;

  Family({
    required this.id,
    this.settings = const {},
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'settings': settings,
    };
  }

  factory Family.fromMap(Map<String, dynamic> map) {
    return Family(
      id: map['id'] ?? '',
      settings: Map<String, dynamic>.from(map['settings'] ?? {}),
    );
  }
}
