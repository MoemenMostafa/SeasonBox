import 'dart:io';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

// Tables
class Families extends Table {
  TextColumn get id => text()();
  TextColumn get members =>
      text().map(const ListStringConverter())(); // JSON list of userIds
  TextColumn get settings =>
      text().map(const MapStringDynamicConverter())(); // JSON map

  @override
  Set<Column> get primaryKey => {id};
}

class Children extends Table {
  TextColumn get id => text()();
  TextColumn get familyId => text().references(Families, #id)();
  TextColumn get name => text()();
  DateTimeColumn get birthdate => dateTime()();
  TextColumn get gender => text()();
  TextColumn get currentSizeByCategory =>
      text().map(const MapStringDynamicConverter())(); // JSON
  TextColumn get sizeHistory => text()
      .map(const ListMapStringDynamicConverter())(); // JSON list of objects

  @override
  Set<Column> get primaryKey => {id};
}

class StorageLocations extends Table {
  TextColumn get id => text()();
  TextColumn get familyId => text().references(Families, #id)();
  TextColumn get name => text()();
  TextColumn get parentId =>
      text().nullable().references(StorageLocations, #id)();
  TextColumn get qrCodeId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Items extends Table {
  TextColumn get id => text()();
  TextColumn get familyId => text().references(Families, #id)();
  TextColumn get title => text()();
  TextColumn get photos =>
      text().map(const ListStringConverter())(); // JSON list of URLs
  TextColumn get category => text()();
  TextColumn get gender => text()();
  TextColumn get size => text()();
  TextColumn get sizeRange =>
      text().map(const MapStringDynamicConverter())(); // JSON {min, max}
  TextColumn get seasonTags =>
      text().map(const ListStringConverter())(); // JSON list
  TextColumn get storageLocationId =>
      text().nullable().references(StorageLocations, #id)();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get addedAt => dateTime()();
  DateTimeColumn get lastUsedAt => dateTime().nullable()();
  TextColumn get status => text()();
  TextColumn get loanHistory => text()
      .map(const ListMapStringDynamicConverter())(); // JSON list of objects

  @override
  Set<Column> get primaryKey => {id};
}

// Converters

class ListStringConverter extends TypeConverter<List<String>, String> {
  const ListStringConverter();
  @override
  List<String> fromSql(String fromDb) => List<String>.from(json.decode(fromDb));
  @override
  String toSql(List<String> value) => json.encode(value);
}

class MapStringDynamicConverter
    extends TypeConverter<Map<String, dynamic>, String> {
  const MapStringDynamicConverter();
  @override
  Map<String, dynamic> fromSql(String fromDb) =>
      Map<String, dynamic>.from(json.decode(fromDb));
  @override
  String toSql(Map<String, dynamic> value) => json.encode(value);
}

class ListMapStringDynamicConverter
    extends TypeConverter<List<Map<String, dynamic>>, String> {
  const ListMapStringDynamicConverter();
  @override
  List<Map<String, dynamic>> fromSql(String fromDb) =>
      (json.decode(fromDb) as List)
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
  @override
  String toSql(List<Map<String, dynamic>> value) => json.encode(value);
}

@DriftDatabase(tables: [Families, Children, StorageLocations, Items])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
