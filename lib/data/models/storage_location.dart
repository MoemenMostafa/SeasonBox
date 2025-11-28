class StorageLocation {
  final String id;
  final String familyId;
  final String name;
  final String? parentId;
  final String? qrCodeId;
  final String type; // 'Box', 'Closet', 'Area'
  final String description;
  final bool isCapacityLimited;
  final bool isFamilyAccessible;

  StorageLocation({
    required this.id,
    required this.familyId,
    required this.name,
    this.parentId,
    this.qrCodeId,
    this.type = 'Box',
    this.description = '',
    this.isCapacityLimited = false,
    this.isFamilyAccessible = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'familyId': familyId,
      'name': name,
      'parentId': parentId,
      'qrCodeId': qrCodeId,
      'type': type,
      'description': description,
      'isCapacityLimited': isCapacityLimited,
      'isFamilyAccessible': isFamilyAccessible,
    };
  }

  factory StorageLocation.fromMap(Map<String, dynamic> map) {
    return StorageLocation(
      id: map['id'] ?? '',
      familyId: map['familyId'] ?? '',
      name: map['name'] ?? '',
      parentId: map['parentId'],
      qrCodeId: map['qrCodeId'],
      type: map['type'] ?? 'Box',
      description: map['description'] ?? '',
      isCapacityLimited: map['isCapacityLimited'] ?? false,
      isFamilyAccessible: map['isFamilyAccessible'] ?? true,
    );
  }
}
