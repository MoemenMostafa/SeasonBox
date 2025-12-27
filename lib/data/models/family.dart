class Family {
  final String id;
  final Map<String, dynamic> settings;
  final int itemCount;
  final int memberCount;

  Family({
    required this.id,
    this.settings = const {},
    this.itemCount = 0,
    this.memberCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'settings': settings,
      'itemCount': itemCount,
      'memberCount': memberCount,
    };
  }

  factory Family.fromMap(Map<String, dynamic> map) {
    return Family(
      id: map['id'] ?? '',
      settings: Map<String, dynamic>.from(map['settings'] ?? {}),
      itemCount: map['itemCount'] ?? 0,
      memberCount: map['memberCount'] ?? 0,
    );
  }
}
