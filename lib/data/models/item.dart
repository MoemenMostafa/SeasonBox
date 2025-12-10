class Item {
  final String id;
  final String familyId;
  final String title;
  final List<Map<String, String>>
      photos; // Changed to support {full: url, thumb: url}
  final String category;
  final String gender;
  final String size;
  final Map<String, num>? sizeRange; // {min: number, max: number}
  final List<String> seasonTags;
  final String storageLocationId;
  final String? memberId; // ID of the family member who owns this item
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
    this.memberId,
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
      'memberId': memberId,
      'quantity': quantity,
      'notes': notes,
      'addedAt': addedAt.toIso8601String(),
      'lastUsedAt': lastUsedAt?.toIso8601String(),
      'status': status,
      'loanHistory': loanHistory,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    // Handle backward compatibility: photos can be List<String> or List<Map>
    List<Map<String, String>> photosList = [];
    if (map['photos'] != null) {
      final photosData = map['photos'] as List;
      for (var photo in photosData) {
        if (photo is String) {
          // Old format: just URL strings
          photosList.add({'full': photo, 'thumb': photo});
        } else if (photo is Map) {
          // New format: {full: url, thumb: url}
          photosList.add(Map<String, String>.from(photo));
        }
      }
    }

    return Item(
      id: map['id'] ?? '',
      familyId: map['familyId'] ?? '',
      title: map['title'] ?? '',
      photos: photosList,
      category: map['category'] ?? '',
      gender: map['gender'] ?? '',
      size: map['size'] ?? '',
      sizeRange: map['sizeRange'] != null
          ? Map<String, num>.from(map['sizeRange'])
          : null,
      seasonTags: List<String>.from(map['seasonTags'] ?? []),
      storageLocationId: map['storageLocationId'] ?? '',
      memberId: map['memberId'],
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
