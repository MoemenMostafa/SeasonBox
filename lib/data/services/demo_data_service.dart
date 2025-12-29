import '../models/family_member.dart';
import '../models/item.dart';
import '../models/storage_location.dart';
import '../../core/enums/gender.dart';

class DemoDataService {
  final List<FamilyMember> _members = [];
  final List<Item> _items = [];
  final List<StorageLocation> _locations = [];

  DemoDataService() {
    _initializeData();
  }

  void _initializeData() {
    const familyId = 'demo_family';

    // 1. Create Storage Locations
    const mainStorageId = 'main_storage';
    _locations.add(StorageLocation(
      id: mainStorageId,
      familyId: familyId,
      name: 'Main Storage',
      type: 'Area',
      description: 'Primary storage area for the family',
    ));

    const closetId = 'closet_room';
    _locations.add(StorageLocation(
      id: closetId,
      familyId: familyId,
      name: 'Master Closet',
      parentId: mainStorageId,
      type: 'Closet',
    ));

    // 2. Create Family Members
    _members.addAll([
      FamilyMember(
        id: 'demo_user', // Matches AuthService.currentUid
        familyId: familyId,
        name: 'David Miller',
        role: 'Dad',
        gender: Gender.male,
        photoUrl: 'assets/images/demo/dad.png',
        birthdate: DateTime(1985, 5, 15),
        clothingSize: 'L',
        shoeSize: '43',
        joinedAt: DateTime(2023, 1, 1),
      ),
      FamilyMember(
        id: 'mom',
        familyId: familyId,
        name: 'Elena Miller',
        role: 'Mom',
        gender: Gender.female,
        photoUrl: 'assets/images/demo/mom.png',
        birthdate: DateTime(1987, 8, 22),
        clothingSize: 'M',
        shoeSize: '39',
        joinedAt: DateTime(2023, 1, 1),
      ),
      FamilyMember(
        id: 'son',
        familyId: familyId,
        name: 'Liam Miller',
        role: 'Son',
        gender: Gender.male,
        photoUrl: 'assets/images/demo/son.png',
        birthdate: DateTime(2015, 3, 10),
        clothingSize: '104',
        shoeSize: '27',
        joinedAt: DateTime(2023, 1, 1),
      ),
      FamilyMember(
        id: 'daughter',
        familyId: familyId,
        name: 'Sophie Miller',
        role: 'Daughter',
        gender: Gender.female,
        photoUrl: 'assets/images/demo/daughter.png',
        birthdate: DateTime(2018, 11, 5),
        clothingSize: '122',
        shoeSize: '30',
        joinedAt: DateTime(2023, 1, 1),
      ),
    ]);

    // 3. Create Generic Items
    _items.addAll([
      Item(
        id: 'winter_jacket',
        familyId: familyId,
        title: 'Navy Blue Winter Jacket',
        category: 'Jackets',
        gender: Gender.male,
        size: 'L',
        seasonTags: ['Winter'],
        storageLocationId: closetId,
        ownerId: 'demo_user',
        photos: [
          {
            'full': 'assets/images/demo/winter_jacket.png',
            'thumb': 'assets/images/demo/winter_jacket.png'
          }
        ],
        addedAt: DateTime.now(),
      ),
      Item(
        id: 'rain_boots',
        familyId: familyId,
        title: 'Yellow Rain Boots',
        category: 'Footwear',
        gender: Gender.unisex,
        size: '28',
        seasonTags: ['Spring', 'Autumn'],
        storageLocationId: mainStorageId,
        ownerId: 'son',
        photos: [
          {
            'full': 'assets/images/demo/rain_boots.png',
            'thumb': 'assets/images/demo/rain_boots.png'
          }
        ],
        addedAt: DateTime.now(),
      ),
      Item(
        id: 'summer_dress',
        familyId: familyId,
        title: 'Floral Summer Dress',
        category: 'Dresses',
        gender: Gender.female,
        size: '110',
        seasonTags: ['Summer'],
        storageLocationId: closetId,
        ownerId: 'daughter',
        photos: [
          {
            'full': 'assets/images/demo/summer_dress.png',
            'thumb': 'assets/images/demo/summer_dress.png'
          }
        ],
        addedAt: DateTime.now(),
      ),
      Item(
        id: 'backpack',
        familyId: familyId,
        title: 'Olive Hiking Backpack',
        category: 'Accessories',
        gender: Gender.unisex,
        size: '30L',
        seasonTags: ['Summer', 'Autumn'],
        storageLocationId: mainStorageId,
        ownerId: 'mom',
        photos: [
          {
            'full': 'assets/images/demo/backpack.png',
            'thumb': 'assets/images/demo/backpack.png'
          }
        ],
        addedAt: DateTime.now(),
      ),
    ]);
  }

  // Initial Data Accessors (Copies to avoid direct mutation of source)
  List<Item> get items => List.unmodifiable(_items);
  List<FamilyMember> get members => List.unmodifiable(_members);
  List<StorageLocation> get locations => List.unmodifiable(_locations);

  // CRUD Operations

  // Items
  List<Item> getItems({String? ownerId}) {
    if (ownerId != null) {
      return _items.where((item) => item.ownerId == ownerId).toList();
    }
    return _items;
  }

  void addItem(Item item) {
    _items.add(item);
  }

  void updateItem(Item item) {
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      _items[index] = item;
    }
  }

  void deleteItem(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
  }

  // Members
  List<FamilyMember> getFamilyMembers() {
    return _members;
  }

  void addFamilyMember(FamilyMember member) {
    _members.add(member);
  }

  void updateFamilyMember(FamilyMember member) {
    final index = _members.indexWhere((m) => m.id == member.id);
    if (index != -1) {
      _members[index] = member;
    }
  }

  void deleteFamilyMember(String memberId) {
    _members.removeWhere((member) => member.id == memberId);
  }

  // Locations
  List<StorageLocation> getStorageLocations() {
    return _locations;
  }

  void addStorageLocation(StorageLocation location) {
    _locations.add(location);
  }

  void updateStorageLocation(StorageLocation location) {
    final index = _locations.indexWhere((l) => l.id == location.id);
    if (index != -1) {
      _locations[index] = location;
    }
  }

  void deleteStorageLocation(String locationId) {
    _locations.removeWhere((location) => location.id == locationId);
  }
}
