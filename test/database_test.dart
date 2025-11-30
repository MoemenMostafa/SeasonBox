import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/data/local_db/database.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('items can be created', () async {
    const familyId = 'family1';
    const userId = 'user1';
    const itemId = 'item_1';

    // Create a family first (referential integrity)
    await database.into(database.families).insert(
          FamiliesCompanion.insert(
            id: familyId,
            members: [userId],
            settings: {},
          ),
        );

    // Create an item
    await database.into(database.items).insert(
          ItemsCompanion.insert(
            id: itemId,
            familyId: familyId,
            title: 'Winter Coat',
            photos: [],
            category: 'Clothes',
            gender: 'Unisex',
            size: 'M',
            sizeRange: {'min': 0, 'max': 0},
            seasonTags: ['Winter'],
            status: 'Stored',
            loanHistory: [],
            addedAt: DateTime.now(),
          ),
        );

    final item = await (database.select(database.items)
          ..where((t) => t.id.equals(itemId)))
        .getSingle();

    expect(item.title, 'Winter Coat');
    expect(item.familyId, familyId);
    expect(item.seasonTags, ['Winter']);
  });
}
