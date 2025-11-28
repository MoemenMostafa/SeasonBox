class Item {
  final String id;
  final String familyId;
  final String title;
  final List<String> photos;
  final String category;
  final String gender;
  final String size;
  final Map<String, num>? sizeRange; // {min: number, max: number}
  final List<String> seasonTags;
  final String storageLocationId;
  final int quantity;
  final String notes;
  final DateTime addedAt;
  final DateTime? lastUsedAt;
  final String status;
  final List<Map<String, dynamic>> loanHistory;

  Item({
    required this.id,
    required this.familyId,
    required this.title,
    this.photos = const [],
    required this.category,
    required this.gender,
    required this.size,
    this.sizeRange,
    this.seasonTags = const [],
    required this.storageLocationId,
    this.quantity = 1,
    this.notes = '',
    required this.addedAt,
    this.lastUsedAt,
    this.status = 'stored',
    this.loanHistory = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'familyId': familyId,
      'title': title,
      'photos': photos,
      'category': category,
      'gender': gender,
      'size': size,
      'sizeRange': sizeRange,
      'seasonTags': seasonTags,
      'storageLocationId': storageLocationId,
      'quantity': quantity,
      'notes': notes,
      'addedAt': addedAt.toIso8601String(),
      'lastUsedAt': lastUsedAt?.toIso8601String(),
      'status': status,
      'loanHistory': loanHistory,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'] ?? '',
      familyId: map['familyId'] ?? '',
      title: map['title'] ?? '',
      photos: List<String>.from(map['photos'] ?? []),
      category: map['category'] ?? '',
      gender: map['gender'] ?? '',
      size: map['size'] ?? '',
      sizeRange: map['sizeRange'] != null
          ? Map<String, num>.from(map['sizeRange'])
          : null,
      seasonTags: List<String>.from(map['seasonTags'] ?? []),
      storageLocationId: map['storageLocationId'] ?? '',
      quantity: map['quantity'] ?? 1,
      notes: map['notes'] ?? '',
      addedAt:
          DateTime.parse(map['addedAt'] ?? DateTime.now().toIso8601String()),
      lastUsedAt:
          map['lastUsedAt'] != null ? DateTime.parse(map['lastUsedAt']) : null,
      status: map['status'] ?? 'stored',
      loanHistory: List<Map<String, dynamic>>.from(map['loanHistory'] ?? []),
    );
  }
}
