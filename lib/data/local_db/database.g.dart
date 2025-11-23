// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $FamiliesTable extends Families with TableInfo<$FamiliesTable, Family> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FamiliesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> members =
      GeneratedColumn<String>('members', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<String>>($FamiliesTable.$convertermembers);
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
      settings = GeneratedColumn<String>('settings', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<Map<String, dynamic>>(
              $FamiliesTable.$convertersettings);
  @override
  List<GeneratedColumn> get $columns => [id, members, settings];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'families';
  @override
  VerificationContext validateIntegrity(Insertable<Family> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Family map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Family(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      members: $FamiliesTable.$convertermembers.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}members'])!),
      settings: $FamiliesTable.$convertersettings.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}settings'])!),
    );
  }

  @override
  $FamiliesTable createAlias(String alias) {
    return $FamiliesTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $convertermembers =
      const ListStringConverter();
  static TypeConverter<Map<String, dynamic>, String> $convertersettings =
      const MapStringDynamicConverter();
}

class Family extends DataClass implements Insertable<Family> {
  final String id;
  final List<String> members;
  final Map<String, dynamic> settings;
  const Family(
      {required this.id, required this.members, required this.settings});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['members'] =
          Variable<String>($FamiliesTable.$convertermembers.toSql(members));
    }
    {
      map['settings'] =
          Variable<String>($FamiliesTable.$convertersettings.toSql(settings));
    }
    return map;
  }

  FamiliesCompanion toCompanion(bool nullToAbsent) {
    return FamiliesCompanion(
      id: Value(id),
      members: Value(members),
      settings: Value(settings),
    );
  }

  factory Family.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Family(
      id: serializer.fromJson<String>(json['id']),
      members: serializer.fromJson<List<String>>(json['members']),
      settings: serializer.fromJson<Map<String, dynamic>>(json['settings']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'members': serializer.toJson<List<String>>(members),
      'settings': serializer.toJson<Map<String, dynamic>>(settings),
    };
  }

  Family copyWith(
          {String? id,
          List<String>? members,
          Map<String, dynamic>? settings}) =>
      Family(
        id: id ?? this.id,
        members: members ?? this.members,
        settings: settings ?? this.settings,
      );
  Family copyWithCompanion(FamiliesCompanion data) {
    return Family(
      id: data.id.present ? data.id.value : this.id,
      members: data.members.present ? data.members.value : this.members,
      settings: data.settings.present ? data.settings.value : this.settings,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Family(')
          ..write('id: $id, ')
          ..write('members: $members, ')
          ..write('settings: $settings')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, members, settings);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Family &&
          other.id == this.id &&
          other.members == this.members &&
          other.settings == this.settings);
}

class FamiliesCompanion extends UpdateCompanion<Family> {
  final Value<String> id;
  final Value<List<String>> members;
  final Value<Map<String, dynamic>> settings;
  final Value<int> rowid;
  const FamiliesCompanion({
    this.id = const Value.absent(),
    this.members = const Value.absent(),
    this.settings = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FamiliesCompanion.insert({
    required String id,
    required List<String> members,
    required Map<String, dynamic> settings,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        members = Value(members),
        settings = Value(settings);
  static Insertable<Family> custom({
    Expression<String>? id,
    Expression<String>? members,
    Expression<String>? settings,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (members != null) 'members': members,
      if (settings != null) 'settings': settings,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FamiliesCompanion copyWith(
      {Value<String>? id,
      Value<List<String>>? members,
      Value<Map<String, dynamic>>? settings,
      Value<int>? rowid}) {
    return FamiliesCompanion(
      id: id ?? this.id,
      members: members ?? this.members,
      settings: settings ?? this.settings,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (members.present) {
      map['members'] = Variable<String>(
          $FamiliesTable.$convertermembers.toSql(members.value));
    }
    if (settings.present) {
      map['settings'] = Variable<String>(
          $FamiliesTable.$convertersettings.toSql(settings.value));
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FamiliesCompanion(')
          ..write('id: $id, ')
          ..write('members: $members, ')
          ..write('settings: $settings, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChildrenTable extends Children
    with TableInfo<$ChildrenTable, ChildrenData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChildrenTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _familyIdMeta =
      const VerificationMeta('familyId');
  @override
  late final GeneratedColumn<String> familyId = GeneratedColumn<String>(
      'family_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES families (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _birthdateMeta =
      const VerificationMeta('birthdate');
  @override
  late final GeneratedColumn<DateTime> birthdate = GeneratedColumn<DateTime>(
      'birthdate', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
      'gender', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
      currentSizeByCategory = GeneratedColumn<String>(
              'current_size_by_category', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<Map<String, dynamic>>(
              $ChildrenTable.$convertercurrentSizeByCategory);
  @override
  late final GeneratedColumnWithTypeConverter<List<Map<String, dynamic>>,
      String> sizeHistory = GeneratedColumn<String>(
          'size_history', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true)
      .withConverter<List<Map<String, dynamic>>>(
          $ChildrenTable.$convertersizeHistory);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        familyId,
        name,
        birthdate,
        gender,
        currentSizeByCategory,
        sizeHistory
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'children';
  @override
  VerificationContext validateIntegrity(Insertable<ChildrenData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('family_id')) {
      context.handle(_familyIdMeta,
          familyId.isAcceptableOrUnknown(data['family_id']!, _familyIdMeta));
    } else if (isInserting) {
      context.missing(_familyIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('birthdate')) {
      context.handle(_birthdateMeta,
          birthdate.isAcceptableOrUnknown(data['birthdate']!, _birthdateMeta));
    } else if (isInserting) {
      context.missing(_birthdateMeta);
    }
    if (data.containsKey('gender')) {
      context.handle(_genderMeta,
          gender.isAcceptableOrUnknown(data['gender']!, _genderMeta));
    } else if (isInserting) {
      context.missing(_genderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChildrenData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChildrenData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      familyId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}family_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      birthdate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}birthdate'])!,
      gender: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gender'])!,
      currentSizeByCategory: $ChildrenTable.$convertercurrentSizeByCategory
          .fromSql(attachedDatabase.typeMapping.read(DriftSqlType.string,
              data['${effectivePrefix}current_size_by_category'])!),
      sizeHistory: $ChildrenTable.$convertersizeHistory.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}size_history'])!),
    );
  }

  @override
  $ChildrenTable createAlias(String alias) {
    return $ChildrenTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<String, dynamic>, String>
      $convertercurrentSizeByCategory = const MapStringDynamicConverter();
  static TypeConverter<List<Map<String, dynamic>>, String>
      $convertersizeHistory = const ListMapStringDynamicConverter();
}

class ChildrenData extends DataClass implements Insertable<ChildrenData> {
  final String id;
  final String familyId;
  final String name;
  final DateTime birthdate;
  final String gender;
  final Map<String, dynamic> currentSizeByCategory;
  final List<Map<String, dynamic>> sizeHistory;
  const ChildrenData(
      {required this.id,
      required this.familyId,
      required this.name,
      required this.birthdate,
      required this.gender,
      required this.currentSizeByCategory,
      required this.sizeHistory});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['family_id'] = Variable<String>(familyId);
    map['name'] = Variable<String>(name);
    map['birthdate'] = Variable<DateTime>(birthdate);
    map['gender'] = Variable<String>(gender);
    {
      map['current_size_by_category'] = Variable<String>($ChildrenTable
          .$convertercurrentSizeByCategory
          .toSql(currentSizeByCategory));
    }
    {
      map['size_history'] = Variable<String>(
          $ChildrenTable.$convertersizeHistory.toSql(sizeHistory));
    }
    return map;
  }

  ChildrenCompanion toCompanion(bool nullToAbsent) {
    return ChildrenCompanion(
      id: Value(id),
      familyId: Value(familyId),
      name: Value(name),
      birthdate: Value(birthdate),
      gender: Value(gender),
      currentSizeByCategory: Value(currentSizeByCategory),
      sizeHistory: Value(sizeHistory),
    );
  }

  factory ChildrenData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChildrenData(
      id: serializer.fromJson<String>(json['id']),
      familyId: serializer.fromJson<String>(json['familyId']),
      name: serializer.fromJson<String>(json['name']),
      birthdate: serializer.fromJson<DateTime>(json['birthdate']),
      gender: serializer.fromJson<String>(json['gender']),
      currentSizeByCategory: serializer
          .fromJson<Map<String, dynamic>>(json['currentSizeByCategory']),
      sizeHistory:
          serializer.fromJson<List<Map<String, dynamic>>>(json['sizeHistory']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'familyId': serializer.toJson<String>(familyId),
      'name': serializer.toJson<String>(name),
      'birthdate': serializer.toJson<DateTime>(birthdate),
      'gender': serializer.toJson<String>(gender),
      'currentSizeByCategory':
          serializer.toJson<Map<String, dynamic>>(currentSizeByCategory),
      'sizeHistory': serializer.toJson<List<Map<String, dynamic>>>(sizeHistory),
    };
  }

  ChildrenData copyWith(
          {String? id,
          String? familyId,
          String? name,
          DateTime? birthdate,
          String? gender,
          Map<String, dynamic>? currentSizeByCategory,
          List<Map<String, dynamic>>? sizeHistory}) =>
      ChildrenData(
        id: id ?? this.id,
        familyId: familyId ?? this.familyId,
        name: name ?? this.name,
        birthdate: birthdate ?? this.birthdate,
        gender: gender ?? this.gender,
        currentSizeByCategory:
            currentSizeByCategory ?? this.currentSizeByCategory,
        sizeHistory: sizeHistory ?? this.sizeHistory,
      );
  ChildrenData copyWithCompanion(ChildrenCompanion data) {
    return ChildrenData(
      id: data.id.present ? data.id.value : this.id,
      familyId: data.familyId.present ? data.familyId.value : this.familyId,
      name: data.name.present ? data.name.value : this.name,
      birthdate: data.birthdate.present ? data.birthdate.value : this.birthdate,
      gender: data.gender.present ? data.gender.value : this.gender,
      currentSizeByCategory: data.currentSizeByCategory.present
          ? data.currentSizeByCategory.value
          : this.currentSizeByCategory,
      sizeHistory:
          data.sizeHistory.present ? data.sizeHistory.value : this.sizeHistory,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChildrenData(')
          ..write('id: $id, ')
          ..write('familyId: $familyId, ')
          ..write('name: $name, ')
          ..write('birthdate: $birthdate, ')
          ..write('gender: $gender, ')
          ..write('currentSizeByCategory: $currentSizeByCategory, ')
          ..write('sizeHistory: $sizeHistory')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, familyId, name, birthdate, gender,
      currentSizeByCategory, sizeHistory);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChildrenData &&
          other.id == this.id &&
          other.familyId == this.familyId &&
          other.name == this.name &&
          other.birthdate == this.birthdate &&
          other.gender == this.gender &&
          other.currentSizeByCategory == this.currentSizeByCategory &&
          other.sizeHistory == this.sizeHistory);
}

class ChildrenCompanion extends UpdateCompanion<ChildrenData> {
  final Value<String> id;
  final Value<String> familyId;
  final Value<String> name;
  final Value<DateTime> birthdate;
  final Value<String> gender;
  final Value<Map<String, dynamic>> currentSizeByCategory;
  final Value<List<Map<String, dynamic>>> sizeHistory;
  final Value<int> rowid;
  const ChildrenCompanion({
    this.id = const Value.absent(),
    this.familyId = const Value.absent(),
    this.name = const Value.absent(),
    this.birthdate = const Value.absent(),
    this.gender = const Value.absent(),
    this.currentSizeByCategory = const Value.absent(),
    this.sizeHistory = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChildrenCompanion.insert({
    required String id,
    required String familyId,
    required String name,
    required DateTime birthdate,
    required String gender,
    required Map<String, dynamic> currentSizeByCategory,
    required List<Map<String, dynamic>> sizeHistory,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        familyId = Value(familyId),
        name = Value(name),
        birthdate = Value(birthdate),
        gender = Value(gender),
        currentSizeByCategory = Value(currentSizeByCategory),
        sizeHistory = Value(sizeHistory);
  static Insertable<ChildrenData> custom({
    Expression<String>? id,
    Expression<String>? familyId,
    Expression<String>? name,
    Expression<DateTime>? birthdate,
    Expression<String>? gender,
    Expression<String>? currentSizeByCategory,
    Expression<String>? sizeHistory,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (familyId != null) 'family_id': familyId,
      if (name != null) 'name': name,
      if (birthdate != null) 'birthdate': birthdate,
      if (gender != null) 'gender': gender,
      if (currentSizeByCategory != null)
        'current_size_by_category': currentSizeByCategory,
      if (sizeHistory != null) 'size_history': sizeHistory,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChildrenCompanion copyWith(
      {Value<String>? id,
      Value<String>? familyId,
      Value<String>? name,
      Value<DateTime>? birthdate,
      Value<String>? gender,
      Value<Map<String, dynamic>>? currentSizeByCategory,
      Value<List<Map<String, dynamic>>>? sizeHistory,
      Value<int>? rowid}) {
    return ChildrenCompanion(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      name: name ?? this.name,
      birthdate: birthdate ?? this.birthdate,
      gender: gender ?? this.gender,
      currentSizeByCategory:
          currentSizeByCategory ?? this.currentSizeByCategory,
      sizeHistory: sizeHistory ?? this.sizeHistory,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (familyId.present) {
      map['family_id'] = Variable<String>(familyId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (birthdate.present) {
      map['birthdate'] = Variable<DateTime>(birthdate.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (currentSizeByCategory.present) {
      map['current_size_by_category'] = Variable<String>($ChildrenTable
          .$convertercurrentSizeByCategory
          .toSql(currentSizeByCategory.value));
    }
    if (sizeHistory.present) {
      map['size_history'] = Variable<String>(
          $ChildrenTable.$convertersizeHistory.toSql(sizeHistory.value));
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChildrenCompanion(')
          ..write('id: $id, ')
          ..write('familyId: $familyId, ')
          ..write('name: $name, ')
          ..write('birthdate: $birthdate, ')
          ..write('gender: $gender, ')
          ..write('currentSizeByCategory: $currentSizeByCategory, ')
          ..write('sizeHistory: $sizeHistory, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StorageLocationsTable extends StorageLocations
    with TableInfo<$StorageLocationsTable, StorageLocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StorageLocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _familyIdMeta =
      const VerificationMeta('familyId');
  @override
  late final GeneratedColumn<String> familyId = GeneratedColumn<String>(
      'family_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES families (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _parentIdMeta =
      const VerificationMeta('parentId');
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
      'parent_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES storage_locations (id)'));
  static const VerificationMeta _qrCodeIdMeta =
      const VerificationMeta('qrCodeId');
  @override
  late final GeneratedColumn<String> qrCodeId = GeneratedColumn<String>(
      'qr_code_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, familyId, name, parentId, qrCodeId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'storage_locations';
  @override
  VerificationContext validateIntegrity(Insertable<StorageLocation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('family_id')) {
      context.handle(_familyIdMeta,
          familyId.isAcceptableOrUnknown(data['family_id']!, _familyIdMeta));
    } else if (isInserting) {
      context.missing(_familyIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(_parentIdMeta,
          parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta));
    }
    if (data.containsKey('qr_code_id')) {
      context.handle(_qrCodeIdMeta,
          qrCodeId.isAcceptableOrUnknown(data['qr_code_id']!, _qrCodeIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StorageLocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StorageLocation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      familyId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}family_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      parentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parent_id']),
      qrCodeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}qr_code_id']),
    );
  }

  @override
  $StorageLocationsTable createAlias(String alias) {
    return $StorageLocationsTable(attachedDatabase, alias);
  }
}

class StorageLocation extends DataClass implements Insertable<StorageLocation> {
  final String id;
  final String familyId;
  final String name;
  final String? parentId;
  final String? qrCodeId;
  const StorageLocation(
      {required this.id,
      required this.familyId,
      required this.name,
      this.parentId,
      this.qrCodeId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['family_id'] = Variable<String>(familyId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    if (!nullToAbsent || qrCodeId != null) {
      map['qr_code_id'] = Variable<String>(qrCodeId);
    }
    return map;
  }

  StorageLocationsCompanion toCompanion(bool nullToAbsent) {
    return StorageLocationsCompanion(
      id: Value(id),
      familyId: Value(familyId),
      name: Value(name),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      qrCodeId: qrCodeId == null && nullToAbsent
          ? const Value.absent()
          : Value(qrCodeId),
    );
  }

  factory StorageLocation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StorageLocation(
      id: serializer.fromJson<String>(json['id']),
      familyId: serializer.fromJson<String>(json['familyId']),
      name: serializer.fromJson<String>(json['name']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      qrCodeId: serializer.fromJson<String?>(json['qrCodeId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'familyId': serializer.toJson<String>(familyId),
      'name': serializer.toJson<String>(name),
      'parentId': serializer.toJson<String?>(parentId),
      'qrCodeId': serializer.toJson<String?>(qrCodeId),
    };
  }

  StorageLocation copyWith(
          {String? id,
          String? familyId,
          String? name,
          Value<String?> parentId = const Value.absent(),
          Value<String?> qrCodeId = const Value.absent()}) =>
      StorageLocation(
        id: id ?? this.id,
        familyId: familyId ?? this.familyId,
        name: name ?? this.name,
        parentId: parentId.present ? parentId.value : this.parentId,
        qrCodeId: qrCodeId.present ? qrCodeId.value : this.qrCodeId,
      );
  StorageLocation copyWithCompanion(StorageLocationsCompanion data) {
    return StorageLocation(
      id: data.id.present ? data.id.value : this.id,
      familyId: data.familyId.present ? data.familyId.value : this.familyId,
      name: data.name.present ? data.name.value : this.name,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      qrCodeId: data.qrCodeId.present ? data.qrCodeId.value : this.qrCodeId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StorageLocation(')
          ..write('id: $id, ')
          ..write('familyId: $familyId, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('qrCodeId: $qrCodeId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, familyId, name, parentId, qrCodeId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StorageLocation &&
          other.id == this.id &&
          other.familyId == this.familyId &&
          other.name == this.name &&
          other.parentId == this.parentId &&
          other.qrCodeId == this.qrCodeId);
}

class StorageLocationsCompanion extends UpdateCompanion<StorageLocation> {
  final Value<String> id;
  final Value<String> familyId;
  final Value<String> name;
  final Value<String?> parentId;
  final Value<String?> qrCodeId;
  final Value<int> rowid;
  const StorageLocationsCompanion({
    this.id = const Value.absent(),
    this.familyId = const Value.absent(),
    this.name = const Value.absent(),
    this.parentId = const Value.absent(),
    this.qrCodeId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StorageLocationsCompanion.insert({
    required String id,
    required String familyId,
    required String name,
    this.parentId = const Value.absent(),
    this.qrCodeId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        familyId = Value(familyId),
        name = Value(name);
  static Insertable<StorageLocation> custom({
    Expression<String>? id,
    Expression<String>? familyId,
    Expression<String>? name,
    Expression<String>? parentId,
    Expression<String>? qrCodeId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (familyId != null) 'family_id': familyId,
      if (name != null) 'name': name,
      if (parentId != null) 'parent_id': parentId,
      if (qrCodeId != null) 'qr_code_id': qrCodeId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StorageLocationsCompanion copyWith(
      {Value<String>? id,
      Value<String>? familyId,
      Value<String>? name,
      Value<String?>? parentId,
      Value<String?>? qrCodeId,
      Value<int>? rowid}) {
    return StorageLocationsCompanion(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      qrCodeId: qrCodeId ?? this.qrCodeId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (familyId.present) {
      map['family_id'] = Variable<String>(familyId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (qrCodeId.present) {
      map['qr_code_id'] = Variable<String>(qrCodeId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StorageLocationsCompanion(')
          ..write('id: $id, ')
          ..write('familyId: $familyId, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('qrCodeId: $qrCodeId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ItemsTable extends Items with TableInfo<$ItemsTable, Item> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _familyIdMeta =
      const VerificationMeta('familyId');
  @override
  late final GeneratedColumn<String> familyId = GeneratedColumn<String>(
      'family_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES families (id)'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> photos =
      GeneratedColumn<String>('photos', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<String>>($ItemsTable.$converterphotos);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
      'gender', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sizeMeta = const VerificationMeta('size');
  @override
  late final GeneratedColumn<String> size = GeneratedColumn<String>(
      'size', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
      sizeRange = GeneratedColumn<String>('size_range', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<Map<String, dynamic>>($ItemsTable.$convertersizeRange);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> seasonTags =
      GeneratedColumn<String>('season_tags', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<String>>($ItemsTable.$converterseasonTags);
  static const VerificationMeta _storageLocationIdMeta =
      const VerificationMeta('storageLocationId');
  @override
  late final GeneratedColumn<String> storageLocationId =
      GeneratedColumn<String>('storage_location_id', aliasedName, true,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'REFERENCES storage_locations (id)'));
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addedAtMeta =
      const VerificationMeta('addedAt');
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
      'added_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _lastUsedAtMeta =
      const VerificationMeta('lastUsedAt');
  @override
  late final GeneratedColumn<DateTime> lastUsedAt = GeneratedColumn<DateTime>(
      'last_used_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<List<Map<String, dynamic>>,
      String> loanHistory = GeneratedColumn<String>(
          'loan_history', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true)
      .withConverter<List<Map<String, dynamic>>>(
          $ItemsTable.$converterloanHistory);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        familyId,
        title,
        photos,
        category,
        gender,
        size,
        sizeRange,
        seasonTags,
        storageLocationId,
        quantity,
        notes,
        addedAt,
        lastUsedAt,
        status,
        loanHistory
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'items';
  @override
  VerificationContext validateIntegrity(Insertable<Item> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('family_id')) {
      context.handle(_familyIdMeta,
          familyId.isAcceptableOrUnknown(data['family_id']!, _familyIdMeta));
    } else if (isInserting) {
      context.missing(_familyIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('gender')) {
      context.handle(_genderMeta,
          gender.isAcceptableOrUnknown(data['gender']!, _genderMeta));
    } else if (isInserting) {
      context.missing(_genderMeta);
    }
    if (data.containsKey('size')) {
      context.handle(
          _sizeMeta, size.isAcceptableOrUnknown(data['size']!, _sizeMeta));
    } else if (isInserting) {
      context.missing(_sizeMeta);
    }
    if (data.containsKey('storage_location_id')) {
      context.handle(
          _storageLocationIdMeta,
          storageLocationId.isAcceptableOrUnknown(
              data['storage_location_id']!, _storageLocationIdMeta));
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('added_at')) {
      context.handle(_addedAtMeta,
          addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta));
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    if (data.containsKey('last_used_at')) {
      context.handle(
          _lastUsedAtMeta,
          lastUsedAt.isAcceptableOrUnknown(
              data['last_used_at']!, _lastUsedAtMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Item map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Item(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      familyId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}family_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      photos: $ItemsTable.$converterphotos.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photos'])!),
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      gender: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gender'])!,
      size: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}size'])!,
      sizeRange: $ItemsTable.$convertersizeRange.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}size_range'])!),
      seasonTags: $ItemsTable.$converterseasonTags.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}season_tags'])!),
      storageLocationId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}storage_location_id']),
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      addedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}added_at'])!,
      lastUsedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_used_at']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      loanHistory: $ItemsTable.$converterloanHistory.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}loan_history'])!),
    );
  }

  @override
  $ItemsTable createAlias(String alias) {
    return $ItemsTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converterphotos =
      const ListStringConverter();
  static TypeConverter<Map<String, dynamic>, String> $convertersizeRange =
      const MapStringDynamicConverter();
  static TypeConverter<List<String>, String> $converterseasonTags =
      const ListStringConverter();
  static TypeConverter<List<Map<String, dynamic>>, String>
      $converterloanHistory = const ListMapStringDynamicConverter();
}

class Item extends DataClass implements Insertable<Item> {
  final String id;
  final String familyId;
  final String title;
  final List<String> photos;
  final String category;
  final String gender;
  final String size;
  final Map<String, dynamic> sizeRange;
  final List<String> seasonTags;
  final String? storageLocationId;
  final int quantity;
  final String? notes;
  final DateTime addedAt;
  final DateTime? lastUsedAt;
  final String status;
  final List<Map<String, dynamic>> loanHistory;
  const Item(
      {required this.id,
      required this.familyId,
      required this.title,
      required this.photos,
      required this.category,
      required this.gender,
      required this.size,
      required this.sizeRange,
      required this.seasonTags,
      this.storageLocationId,
      required this.quantity,
      this.notes,
      required this.addedAt,
      this.lastUsedAt,
      required this.status,
      required this.loanHistory});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['family_id'] = Variable<String>(familyId);
    map['title'] = Variable<String>(title);
    {
      map['photos'] =
          Variable<String>($ItemsTable.$converterphotos.toSql(photos));
    }
    map['category'] = Variable<String>(category);
    map['gender'] = Variable<String>(gender);
    map['size'] = Variable<String>(size);
    {
      map['size_range'] =
          Variable<String>($ItemsTable.$convertersizeRange.toSql(sizeRange));
    }
    {
      map['season_tags'] =
          Variable<String>($ItemsTable.$converterseasonTags.toSql(seasonTags));
    }
    if (!nullToAbsent || storageLocationId != null) {
      map['storage_location_id'] = Variable<String>(storageLocationId);
    }
    map['quantity'] = Variable<int>(quantity);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['added_at'] = Variable<DateTime>(addedAt);
    if (!nullToAbsent || lastUsedAt != null) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt);
    }
    map['status'] = Variable<String>(status);
    {
      map['loan_history'] = Variable<String>(
          $ItemsTable.$converterloanHistory.toSql(loanHistory));
    }
    return map;
  }

  ItemsCompanion toCompanion(bool nullToAbsent) {
    return ItemsCompanion(
      id: Value(id),
      familyId: Value(familyId),
      title: Value(title),
      photos: Value(photos),
      category: Value(category),
      gender: Value(gender),
      size: Value(size),
      sizeRange: Value(sizeRange),
      seasonTags: Value(seasonTags),
      storageLocationId: storageLocationId == null && nullToAbsent
          ? const Value.absent()
          : Value(storageLocationId),
      quantity: Value(quantity),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      addedAt: Value(addedAt),
      lastUsedAt: lastUsedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUsedAt),
      status: Value(status),
      loanHistory: Value(loanHistory),
    );
  }

  factory Item.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Item(
      id: serializer.fromJson<String>(json['id']),
      familyId: serializer.fromJson<String>(json['familyId']),
      title: serializer.fromJson<String>(json['title']),
      photos: serializer.fromJson<List<String>>(json['photos']),
      category: serializer.fromJson<String>(json['category']),
      gender: serializer.fromJson<String>(json['gender']),
      size: serializer.fromJson<String>(json['size']),
      sizeRange: serializer.fromJson<Map<String, dynamic>>(json['sizeRange']),
      seasonTags: serializer.fromJson<List<String>>(json['seasonTags']),
      storageLocationId:
          serializer.fromJson<String?>(json['storageLocationId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      notes: serializer.fromJson<String?>(json['notes']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
      lastUsedAt: serializer.fromJson<DateTime?>(json['lastUsedAt']),
      status: serializer.fromJson<String>(json['status']),
      loanHistory:
          serializer.fromJson<List<Map<String, dynamic>>>(json['loanHistory']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'familyId': serializer.toJson<String>(familyId),
      'title': serializer.toJson<String>(title),
      'photos': serializer.toJson<List<String>>(photos),
      'category': serializer.toJson<String>(category),
      'gender': serializer.toJson<String>(gender),
      'size': serializer.toJson<String>(size),
      'sizeRange': serializer.toJson<Map<String, dynamic>>(sizeRange),
      'seasonTags': serializer.toJson<List<String>>(seasonTags),
      'storageLocationId': serializer.toJson<String?>(storageLocationId),
      'quantity': serializer.toJson<int>(quantity),
      'notes': serializer.toJson<String?>(notes),
      'addedAt': serializer.toJson<DateTime>(addedAt),
      'lastUsedAt': serializer.toJson<DateTime?>(lastUsedAt),
      'status': serializer.toJson<String>(status),
      'loanHistory': serializer.toJson<List<Map<String, dynamic>>>(loanHistory),
    };
  }

  Item copyWith(
          {String? id,
          String? familyId,
          String? title,
          List<String>? photos,
          String? category,
          String? gender,
          String? size,
          Map<String, dynamic>? sizeRange,
          List<String>? seasonTags,
          Value<String?> storageLocationId = const Value.absent(),
          int? quantity,
          Value<String?> notes = const Value.absent(),
          DateTime? addedAt,
          Value<DateTime?> lastUsedAt = const Value.absent(),
          String? status,
          List<Map<String, dynamic>>? loanHistory}) =>
      Item(
        id: id ?? this.id,
        familyId: familyId ?? this.familyId,
        title: title ?? this.title,
        photos: photos ?? this.photos,
        category: category ?? this.category,
        gender: gender ?? this.gender,
        size: size ?? this.size,
        sizeRange: sizeRange ?? this.sizeRange,
        seasonTags: seasonTags ?? this.seasonTags,
        storageLocationId: storageLocationId.present
            ? storageLocationId.value
            : this.storageLocationId,
        quantity: quantity ?? this.quantity,
        notes: notes.present ? notes.value : this.notes,
        addedAt: addedAt ?? this.addedAt,
        lastUsedAt: lastUsedAt.present ? lastUsedAt.value : this.lastUsedAt,
        status: status ?? this.status,
        loanHistory: loanHistory ?? this.loanHistory,
      );
  Item copyWithCompanion(ItemsCompanion data) {
    return Item(
      id: data.id.present ? data.id.value : this.id,
      familyId: data.familyId.present ? data.familyId.value : this.familyId,
      title: data.title.present ? data.title.value : this.title,
      photos: data.photos.present ? data.photos.value : this.photos,
      category: data.category.present ? data.category.value : this.category,
      gender: data.gender.present ? data.gender.value : this.gender,
      size: data.size.present ? data.size.value : this.size,
      sizeRange: data.sizeRange.present ? data.sizeRange.value : this.sizeRange,
      seasonTags:
          data.seasonTags.present ? data.seasonTags.value : this.seasonTags,
      storageLocationId: data.storageLocationId.present
          ? data.storageLocationId.value
          : this.storageLocationId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      notes: data.notes.present ? data.notes.value : this.notes,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
      lastUsedAt:
          data.lastUsedAt.present ? data.lastUsedAt.value : this.lastUsedAt,
      status: data.status.present ? data.status.value : this.status,
      loanHistory:
          data.loanHistory.present ? data.loanHistory.value : this.loanHistory,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Item(')
          ..write('id: $id, ')
          ..write('familyId: $familyId, ')
          ..write('title: $title, ')
          ..write('photos: $photos, ')
          ..write('category: $category, ')
          ..write('gender: $gender, ')
          ..write('size: $size, ')
          ..write('sizeRange: $sizeRange, ')
          ..write('seasonTags: $seasonTags, ')
          ..write('storageLocationId: $storageLocationId, ')
          ..write('quantity: $quantity, ')
          ..write('notes: $notes, ')
          ..write('addedAt: $addedAt, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('status: $status, ')
          ..write('loanHistory: $loanHistory')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      familyId,
      title,
      photos,
      category,
      gender,
      size,
      sizeRange,
      seasonTags,
      storageLocationId,
      quantity,
      notes,
      addedAt,
      lastUsedAt,
      status,
      loanHistory);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Item &&
          other.id == this.id &&
          other.familyId == this.familyId &&
          other.title == this.title &&
          other.photos == this.photos &&
          other.category == this.category &&
          other.gender == this.gender &&
          other.size == this.size &&
          other.sizeRange == this.sizeRange &&
          other.seasonTags == this.seasonTags &&
          other.storageLocationId == this.storageLocationId &&
          other.quantity == this.quantity &&
          other.notes == this.notes &&
          other.addedAt == this.addedAt &&
          other.lastUsedAt == this.lastUsedAt &&
          other.status == this.status &&
          other.loanHistory == this.loanHistory);
}

class ItemsCompanion extends UpdateCompanion<Item> {
  final Value<String> id;
  final Value<String> familyId;
  final Value<String> title;
  final Value<List<String>> photos;
  final Value<String> category;
  final Value<String> gender;
  final Value<String> size;
  final Value<Map<String, dynamic>> sizeRange;
  final Value<List<String>> seasonTags;
  final Value<String?> storageLocationId;
  final Value<int> quantity;
  final Value<String?> notes;
  final Value<DateTime> addedAt;
  final Value<DateTime?> lastUsedAt;
  final Value<String> status;
  final Value<List<Map<String, dynamic>>> loanHistory;
  final Value<int> rowid;
  const ItemsCompanion({
    this.id = const Value.absent(),
    this.familyId = const Value.absent(),
    this.title = const Value.absent(),
    this.photos = const Value.absent(),
    this.category = const Value.absent(),
    this.gender = const Value.absent(),
    this.size = const Value.absent(),
    this.sizeRange = const Value.absent(),
    this.seasonTags = const Value.absent(),
    this.storageLocationId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.notes = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.loanHistory = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ItemsCompanion.insert({
    required String id,
    required String familyId,
    required String title,
    required List<String> photos,
    required String category,
    required String gender,
    required String size,
    required Map<String, dynamic> sizeRange,
    required List<String> seasonTags,
    this.storageLocationId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime addedAt,
    this.lastUsedAt = const Value.absent(),
    required String status,
    required List<Map<String, dynamic>> loanHistory,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        familyId = Value(familyId),
        title = Value(title),
        photos = Value(photos),
        category = Value(category),
        gender = Value(gender),
        size = Value(size),
        sizeRange = Value(sizeRange),
        seasonTags = Value(seasonTags),
        addedAt = Value(addedAt),
        status = Value(status),
        loanHistory = Value(loanHistory);
  static Insertable<Item> custom({
    Expression<String>? id,
    Expression<String>? familyId,
    Expression<String>? title,
    Expression<String>? photos,
    Expression<String>? category,
    Expression<String>? gender,
    Expression<String>? size,
    Expression<String>? sizeRange,
    Expression<String>? seasonTags,
    Expression<String>? storageLocationId,
    Expression<int>? quantity,
    Expression<String>? notes,
    Expression<DateTime>? addedAt,
    Expression<DateTime>? lastUsedAt,
    Expression<String>? status,
    Expression<String>? loanHistory,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (familyId != null) 'family_id': familyId,
      if (title != null) 'title': title,
      if (photos != null) 'photos': photos,
      if (category != null) 'category': category,
      if (gender != null) 'gender': gender,
      if (size != null) 'size': size,
      if (sizeRange != null) 'size_range': sizeRange,
      if (seasonTags != null) 'season_tags': seasonTags,
      if (storageLocationId != null) 'storage_location_id': storageLocationId,
      if (quantity != null) 'quantity': quantity,
      if (notes != null) 'notes': notes,
      if (addedAt != null) 'added_at': addedAt,
      if (lastUsedAt != null) 'last_used_at': lastUsedAt,
      if (status != null) 'status': status,
      if (loanHistory != null) 'loan_history': loanHistory,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ItemsCompanion copyWith(
      {Value<String>? id,
      Value<String>? familyId,
      Value<String>? title,
      Value<List<String>>? photos,
      Value<String>? category,
      Value<String>? gender,
      Value<String>? size,
      Value<Map<String, dynamic>>? sizeRange,
      Value<List<String>>? seasonTags,
      Value<String?>? storageLocationId,
      Value<int>? quantity,
      Value<String?>? notes,
      Value<DateTime>? addedAt,
      Value<DateTime?>? lastUsedAt,
      Value<String>? status,
      Value<List<Map<String, dynamic>>>? loanHistory,
      Value<int>? rowid}) {
    return ItemsCompanion(
      id: id ?? this.id,
      familyId: familyId ?? this.familyId,
      title: title ?? this.title,
      photos: photos ?? this.photos,
      category: category ?? this.category,
      gender: gender ?? this.gender,
      size: size ?? this.size,
      sizeRange: sizeRange ?? this.sizeRange,
      seasonTags: seasonTags ?? this.seasonTags,
      storageLocationId: storageLocationId ?? this.storageLocationId,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
      addedAt: addedAt ?? this.addedAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      status: status ?? this.status,
      loanHistory: loanHistory ?? this.loanHistory,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (familyId.present) {
      map['family_id'] = Variable<String>(familyId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (photos.present) {
      map['photos'] =
          Variable<String>($ItemsTable.$converterphotos.toSql(photos.value));
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (size.present) {
      map['size'] = Variable<String>(size.value);
    }
    if (sizeRange.present) {
      map['size_range'] = Variable<String>(
          $ItemsTable.$convertersizeRange.toSql(sizeRange.value));
    }
    if (seasonTags.present) {
      map['season_tags'] = Variable<String>(
          $ItemsTable.$converterseasonTags.toSql(seasonTags.value));
    }
    if (storageLocationId.present) {
      map['storage_location_id'] = Variable<String>(storageLocationId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (lastUsedAt.present) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (loanHistory.present) {
      map['loan_history'] = Variable<String>(
          $ItemsTable.$converterloanHistory.toSql(loanHistory.value));
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemsCompanion(')
          ..write('id: $id, ')
          ..write('familyId: $familyId, ')
          ..write('title: $title, ')
          ..write('photos: $photos, ')
          ..write('category: $category, ')
          ..write('gender: $gender, ')
          ..write('size: $size, ')
          ..write('sizeRange: $sizeRange, ')
          ..write('seasonTags: $seasonTags, ')
          ..write('storageLocationId: $storageLocationId, ')
          ..write('quantity: $quantity, ')
          ..write('notes: $notes, ')
          ..write('addedAt: $addedAt, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('status: $status, ')
          ..write('loanHistory: $loanHistory, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FamiliesTable families = $FamiliesTable(this);
  late final $ChildrenTable children = $ChildrenTable(this);
  late final $StorageLocationsTable storageLocations =
      $StorageLocationsTable(this);
  late final $ItemsTable items = $ItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [families, children, storageLocations, items];
}

typedef $$FamiliesTableCreateCompanionBuilder = FamiliesCompanion Function({
  required String id,
  required List<String> members,
  required Map<String, dynamic> settings,
  Value<int> rowid,
});
typedef $$FamiliesTableUpdateCompanionBuilder = FamiliesCompanion Function({
  Value<String> id,
  Value<List<String>> members,
  Value<Map<String, dynamic>> settings,
  Value<int> rowid,
});

final class $$FamiliesTableReferences
    extends BaseReferences<_$AppDatabase, $FamiliesTable, Family> {
  $$FamiliesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ChildrenTable, List<ChildrenData>>
      _childrenRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.children,
              aliasName:
                  $_aliasNameGenerator(db.families.id, db.children.familyId));

  $$ChildrenTableProcessedTableManager get childrenRefs {
    final manager = $$ChildrenTableTableManager($_db, $_db.children)
        .filter((f) => f.familyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_childrenRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$StorageLocationsTable, List<StorageLocation>>
      _storageLocationsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.storageLocations,
              aliasName: $_aliasNameGenerator(
                  db.families.id, db.storageLocations.familyId));

  $$StorageLocationsTableProcessedTableManager get storageLocationsRefs {
    final manager = $$StorageLocationsTableTableManager(
            $_db, $_db.storageLocations)
        .filter((f) => f.familyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_storageLocationsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ItemsTable, List<Item>> _itemsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.items,
          aliasName: $_aliasNameGenerator(db.families.id, db.items.familyId));

  $$ItemsTableProcessedTableManager get itemsRefs {
    final manager = $$ItemsTableTableManager($_db, $_db.items)
        .filter((f) => f.familyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_itemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$FamiliesTableFilterComposer
    extends Composer<_$AppDatabase, $FamiliesTable> {
  $$FamiliesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
      get members => $composableBuilder(
          column: $table.members,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<Map<String, dynamic>, Map<String, dynamic>,
          String>
      get settings => $composableBuilder(
          column: $table.settings,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  Expression<bool> childrenRefs(
      Expression<bool> Function($$ChildrenTableFilterComposer f) f) {
    final $$ChildrenTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.children,
        getReferencedColumn: (t) => t.familyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChildrenTableFilterComposer(
              $db: $db,
              $table: $db.children,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> storageLocationsRefs(
      Expression<bool> Function($$StorageLocationsTableFilterComposer f) f) {
    final $$StorageLocationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.storageLocations,
        getReferencedColumn: (t) => t.familyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StorageLocationsTableFilterComposer(
              $db: $db,
              $table: $db.storageLocations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> itemsRefs(
      Expression<bool> Function($$ItemsTableFilterComposer f) f) {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.items,
        getReferencedColumn: (t) => t.familyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsTableFilterComposer(
              $db: $db,
              $table: $db.items,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$FamiliesTableOrderingComposer
    extends Composer<_$AppDatabase, $FamiliesTable> {
  $$FamiliesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get members => $composableBuilder(
      column: $table.members, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get settings => $composableBuilder(
      column: $table.settings, builder: (column) => ColumnOrderings(column));
}

class $$FamiliesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FamiliesTable> {
  $$FamiliesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get members =>
      $composableBuilder(column: $table.members, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>, String> get settings =>
      $composableBuilder(column: $table.settings, builder: (column) => column);

  Expression<T> childrenRefs<T extends Object>(
      Expression<T> Function($$ChildrenTableAnnotationComposer a) f) {
    final $$ChildrenTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.children,
        getReferencedColumn: (t) => t.familyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChildrenTableAnnotationComposer(
              $db: $db,
              $table: $db.children,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> storageLocationsRefs<T extends Object>(
      Expression<T> Function($$StorageLocationsTableAnnotationComposer a) f) {
    final $$StorageLocationsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.storageLocations,
        getReferencedColumn: (t) => t.familyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StorageLocationsTableAnnotationComposer(
              $db: $db,
              $table: $db.storageLocations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> itemsRefs<T extends Object>(
      Expression<T> Function($$ItemsTableAnnotationComposer a) f) {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.items,
        getReferencedColumn: (t) => t.familyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.items,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$FamiliesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FamiliesTable,
    Family,
    $$FamiliesTableFilterComposer,
    $$FamiliesTableOrderingComposer,
    $$FamiliesTableAnnotationComposer,
    $$FamiliesTableCreateCompanionBuilder,
    $$FamiliesTableUpdateCompanionBuilder,
    (Family, $$FamiliesTableReferences),
    Family,
    PrefetchHooks Function(
        {bool childrenRefs, bool storageLocationsRefs, bool itemsRefs})> {
  $$FamiliesTableTableManager(_$AppDatabase db, $FamiliesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FamiliesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FamiliesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FamiliesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<List<String>> members = const Value.absent(),
            Value<Map<String, dynamic>> settings = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FamiliesCompanion(
            id: id,
            members: members,
            settings: settings,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required List<String> members,
            required Map<String, dynamic> settings,
            Value<int> rowid = const Value.absent(),
          }) =>
              FamiliesCompanion.insert(
            id: id,
            members: members,
            settings: settings,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$FamiliesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {childrenRefs = false,
              storageLocationsRefs = false,
              itemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (childrenRefs) db.children,
                if (storageLocationsRefs) db.storageLocations,
                if (itemsRefs) db.items
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (childrenRefs)
                    await $_getPrefetchedData<Family, $FamiliesTable,
                            ChildrenData>(
                        currentTable: table,
                        referencedTable:
                            $$FamiliesTableReferences._childrenRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$FamiliesTableReferences(db, table, p0)
                                .childrenRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.familyId == item.id),
                        typedResults: items),
                  if (storageLocationsRefs)
                    await $_getPrefetchedData<Family, $FamiliesTable,
                            StorageLocation>(
                        currentTable: table,
                        referencedTable: $$FamiliesTableReferences
                            ._storageLocationsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$FamiliesTableReferences(db, table, p0)
                                .storageLocationsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.familyId == item.id),
                        typedResults: items),
                  if (itemsRefs)
                    await $_getPrefetchedData<Family, $FamiliesTable, Item>(
                        currentTable: table,
                        referencedTable:
                            $$FamiliesTableReferences._itemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$FamiliesTableReferences(db, table, p0).itemsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.familyId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$FamiliesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FamiliesTable,
    Family,
    $$FamiliesTableFilterComposer,
    $$FamiliesTableOrderingComposer,
    $$FamiliesTableAnnotationComposer,
    $$FamiliesTableCreateCompanionBuilder,
    $$FamiliesTableUpdateCompanionBuilder,
    (Family, $$FamiliesTableReferences),
    Family,
    PrefetchHooks Function(
        {bool childrenRefs, bool storageLocationsRefs, bool itemsRefs})>;
typedef $$ChildrenTableCreateCompanionBuilder = ChildrenCompanion Function({
  required String id,
  required String familyId,
  required String name,
  required DateTime birthdate,
  required String gender,
  required Map<String, dynamic> currentSizeByCategory,
  required List<Map<String, dynamic>> sizeHistory,
  Value<int> rowid,
});
typedef $$ChildrenTableUpdateCompanionBuilder = ChildrenCompanion Function({
  Value<String> id,
  Value<String> familyId,
  Value<String> name,
  Value<DateTime> birthdate,
  Value<String> gender,
  Value<Map<String, dynamic>> currentSizeByCategory,
  Value<List<Map<String, dynamic>>> sizeHistory,
  Value<int> rowid,
});

final class $$ChildrenTableReferences
    extends BaseReferences<_$AppDatabase, $ChildrenTable, ChildrenData> {
  $$ChildrenTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FamiliesTable _familyIdTable(_$AppDatabase db) => db.families
      .createAlias($_aliasNameGenerator(db.children.familyId, db.families.id));

  $$FamiliesTableProcessedTableManager get familyId {
    final $_column = $_itemColumn<String>('family_id')!;

    final manager = $$FamiliesTableTableManager($_db, $_db.families)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_familyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ChildrenTableFilterComposer
    extends Composer<_$AppDatabase, $ChildrenTable> {
  $$ChildrenTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get birthdate => $composableBuilder(
      column: $table.birthdate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gender => $composableBuilder(
      column: $table.gender, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Map<String, dynamic>, Map<String, dynamic>,
          String>
      get currentSizeByCategory => $composableBuilder(
          column: $table.currentSizeByCategory,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<List<Map<String, dynamic>>,
          List<Map<String, dynamic>>, String>
      get sizeHistory => $composableBuilder(
          column: $table.sizeHistory,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  $$FamiliesTableFilterComposer get familyId {
    final $$FamiliesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.familyId,
        referencedTable: $db.families,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FamiliesTableFilterComposer(
              $db: $db,
              $table: $db.families,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ChildrenTableOrderingComposer
    extends Composer<_$AppDatabase, $ChildrenTable> {
  $$ChildrenTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get birthdate => $composableBuilder(
      column: $table.birthdate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gender => $composableBuilder(
      column: $table.gender, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currentSizeByCategory => $composableBuilder(
      column: $table.currentSizeByCategory,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sizeHistory => $composableBuilder(
      column: $table.sizeHistory, builder: (column) => ColumnOrderings(column));

  $$FamiliesTableOrderingComposer get familyId {
    final $$FamiliesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.familyId,
        referencedTable: $db.families,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FamiliesTableOrderingComposer(
              $db: $db,
              $table: $db.families,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ChildrenTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChildrenTable> {
  $$ChildrenTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get birthdate =>
      $composableBuilder(column: $table.birthdate, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
      get currentSizeByCategory => $composableBuilder(
          column: $table.currentSizeByCategory, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<Map<String, dynamic>>, String>
      get sizeHistory => $composableBuilder(
          column: $table.sizeHistory, builder: (column) => column);

  $$FamiliesTableAnnotationComposer get familyId {
    final $$FamiliesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.familyId,
        referencedTable: $db.families,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FamiliesTableAnnotationComposer(
              $db: $db,
              $table: $db.families,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ChildrenTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChildrenTable,
    ChildrenData,
    $$ChildrenTableFilterComposer,
    $$ChildrenTableOrderingComposer,
    $$ChildrenTableAnnotationComposer,
    $$ChildrenTableCreateCompanionBuilder,
    $$ChildrenTableUpdateCompanionBuilder,
    (ChildrenData, $$ChildrenTableReferences),
    ChildrenData,
    PrefetchHooks Function({bool familyId})> {
  $$ChildrenTableTableManager(_$AppDatabase db, $ChildrenTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChildrenTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChildrenTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChildrenTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> familyId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<DateTime> birthdate = const Value.absent(),
            Value<String> gender = const Value.absent(),
            Value<Map<String, dynamic>> currentSizeByCategory =
                const Value.absent(),
            Value<List<Map<String, dynamic>>> sizeHistory =
                const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChildrenCompanion(
            id: id,
            familyId: familyId,
            name: name,
            birthdate: birthdate,
            gender: gender,
            currentSizeByCategory: currentSizeByCategory,
            sizeHistory: sizeHistory,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String familyId,
            required String name,
            required DateTime birthdate,
            required String gender,
            required Map<String, dynamic> currentSizeByCategory,
            required List<Map<String, dynamic>> sizeHistory,
            Value<int> rowid = const Value.absent(),
          }) =>
              ChildrenCompanion.insert(
            id: id,
            familyId: familyId,
            name: name,
            birthdate: birthdate,
            gender: gender,
            currentSizeByCategory: currentSizeByCategory,
            sizeHistory: sizeHistory,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ChildrenTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({familyId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (familyId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.familyId,
                    referencedTable:
                        $$ChildrenTableReferences._familyIdTable(db),
                    referencedColumn:
                        $$ChildrenTableReferences._familyIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ChildrenTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChildrenTable,
    ChildrenData,
    $$ChildrenTableFilterComposer,
    $$ChildrenTableOrderingComposer,
    $$ChildrenTableAnnotationComposer,
    $$ChildrenTableCreateCompanionBuilder,
    $$ChildrenTableUpdateCompanionBuilder,
    (ChildrenData, $$ChildrenTableReferences),
    ChildrenData,
    PrefetchHooks Function({bool familyId})>;
typedef $$StorageLocationsTableCreateCompanionBuilder
    = StorageLocationsCompanion Function({
  required String id,
  required String familyId,
  required String name,
  Value<String?> parentId,
  Value<String?> qrCodeId,
  Value<int> rowid,
});
typedef $$StorageLocationsTableUpdateCompanionBuilder
    = StorageLocationsCompanion Function({
  Value<String> id,
  Value<String> familyId,
  Value<String> name,
  Value<String?> parentId,
  Value<String?> qrCodeId,
  Value<int> rowid,
});

final class $$StorageLocationsTableReferences extends BaseReferences<
    _$AppDatabase, $StorageLocationsTable, StorageLocation> {
  $$StorageLocationsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $FamiliesTable _familyIdTable(_$AppDatabase db) =>
      db.families.createAlias(
          $_aliasNameGenerator(db.storageLocations.familyId, db.families.id));

  $$FamiliesTableProcessedTableManager get familyId {
    final $_column = $_itemColumn<String>('family_id')!;

    final manager = $$FamiliesTableTableManager($_db, $_db.families)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_familyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $StorageLocationsTable _parentIdTable(_$AppDatabase db) =>
      db.storageLocations.createAlias($_aliasNameGenerator(
          db.storageLocations.parentId, db.storageLocations.id));

  $$StorageLocationsTableProcessedTableManager? get parentId {
    final $_column = $_itemColumn<String>('parent_id');
    if ($_column == null) return null;
    final manager =
        $$StorageLocationsTableTableManager($_db, $_db.storageLocations)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$ItemsTable, List<Item>> _itemsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.items,
          aliasName: $_aliasNameGenerator(
              db.storageLocations.id, db.items.storageLocationId));

  $$ItemsTableProcessedTableManager get itemsRefs {
    final manager = $$ItemsTableTableManager($_db, $_db.items).filter(
        (f) => f.storageLocationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_itemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$StorageLocationsTableFilterComposer
    extends Composer<_$AppDatabase, $StorageLocationsTable> {
  $$StorageLocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get qrCodeId => $composableBuilder(
      column: $table.qrCodeId, builder: (column) => ColumnFilters(column));

  $$FamiliesTableFilterComposer get familyId {
    final $$FamiliesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.familyId,
        referencedTable: $db.families,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FamiliesTableFilterComposer(
              $db: $db,
              $table: $db.families,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$StorageLocationsTableFilterComposer get parentId {
    final $$StorageLocationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentId,
        referencedTable: $db.storageLocations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StorageLocationsTableFilterComposer(
              $db: $db,
              $table: $db.storageLocations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> itemsRefs(
      Expression<bool> Function($$ItemsTableFilterComposer f) f) {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.items,
        getReferencedColumn: (t) => t.storageLocationId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsTableFilterComposer(
              $db: $db,
              $table: $db.items,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$StorageLocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $StorageLocationsTable> {
  $$StorageLocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get qrCodeId => $composableBuilder(
      column: $table.qrCodeId, builder: (column) => ColumnOrderings(column));

  $$FamiliesTableOrderingComposer get familyId {
    final $$FamiliesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.familyId,
        referencedTable: $db.families,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FamiliesTableOrderingComposer(
              $db: $db,
              $table: $db.families,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$StorageLocationsTableOrderingComposer get parentId {
    final $$StorageLocationsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentId,
        referencedTable: $db.storageLocations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StorageLocationsTableOrderingComposer(
              $db: $db,
              $table: $db.storageLocations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StorageLocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StorageLocationsTable> {
  $$StorageLocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get qrCodeId =>
      $composableBuilder(column: $table.qrCodeId, builder: (column) => column);

  $$FamiliesTableAnnotationComposer get familyId {
    final $$FamiliesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.familyId,
        referencedTable: $db.families,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FamiliesTableAnnotationComposer(
              $db: $db,
              $table: $db.families,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$StorageLocationsTableAnnotationComposer get parentId {
    final $$StorageLocationsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentId,
        referencedTable: $db.storageLocations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StorageLocationsTableAnnotationComposer(
              $db: $db,
              $table: $db.storageLocations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> itemsRefs<T extends Object>(
      Expression<T> Function($$ItemsTableAnnotationComposer a) f) {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.items,
        getReferencedColumn: (t) => t.storageLocationId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.items,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$StorageLocationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StorageLocationsTable,
    StorageLocation,
    $$StorageLocationsTableFilterComposer,
    $$StorageLocationsTableOrderingComposer,
    $$StorageLocationsTableAnnotationComposer,
    $$StorageLocationsTableCreateCompanionBuilder,
    $$StorageLocationsTableUpdateCompanionBuilder,
    (StorageLocation, $$StorageLocationsTableReferences),
    StorageLocation,
    PrefetchHooks Function({bool familyId, bool parentId, bool itemsRefs})> {
  $$StorageLocationsTableTableManager(
      _$AppDatabase db, $StorageLocationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StorageLocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StorageLocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StorageLocationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> familyId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> parentId = const Value.absent(),
            Value<String?> qrCodeId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StorageLocationsCompanion(
            id: id,
            familyId: familyId,
            name: name,
            parentId: parentId,
            qrCodeId: qrCodeId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String familyId,
            required String name,
            Value<String?> parentId = const Value.absent(),
            Value<String?> qrCodeId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StorageLocationsCompanion.insert(
            id: id,
            familyId: familyId,
            name: name,
            parentId: parentId,
            qrCodeId: qrCodeId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$StorageLocationsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {familyId = false, parentId = false, itemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (itemsRefs) db.items],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (familyId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.familyId,
                    referencedTable:
                        $$StorageLocationsTableReferences._familyIdTable(db),
                    referencedColumn:
                        $$StorageLocationsTableReferences._familyIdTable(db).id,
                  ) as T;
                }
                if (parentId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.parentId,
                    referencedTable:
                        $$StorageLocationsTableReferences._parentIdTable(db),
                    referencedColumn:
                        $$StorageLocationsTableReferences._parentIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (itemsRefs)
                    await $_getPrefetchedData<StorageLocation,
                            $StorageLocationsTable, Item>(
                        currentTable: table,
                        referencedTable: $$StorageLocationsTableReferences
                            ._itemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$StorageLocationsTableReferences(db, table, p0)
                                .itemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.storageLocationId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$StorageLocationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StorageLocationsTable,
    StorageLocation,
    $$StorageLocationsTableFilterComposer,
    $$StorageLocationsTableOrderingComposer,
    $$StorageLocationsTableAnnotationComposer,
    $$StorageLocationsTableCreateCompanionBuilder,
    $$StorageLocationsTableUpdateCompanionBuilder,
    (StorageLocation, $$StorageLocationsTableReferences),
    StorageLocation,
    PrefetchHooks Function({bool familyId, bool parentId, bool itemsRefs})>;
typedef $$ItemsTableCreateCompanionBuilder = ItemsCompanion Function({
  required String id,
  required String familyId,
  required String title,
  required List<String> photos,
  required String category,
  required String gender,
  required String size,
  required Map<String, dynamic> sizeRange,
  required List<String> seasonTags,
  Value<String?> storageLocationId,
  Value<int> quantity,
  Value<String?> notes,
  required DateTime addedAt,
  Value<DateTime?> lastUsedAt,
  required String status,
  required List<Map<String, dynamic>> loanHistory,
  Value<int> rowid,
});
typedef $$ItemsTableUpdateCompanionBuilder = ItemsCompanion Function({
  Value<String> id,
  Value<String> familyId,
  Value<String> title,
  Value<List<String>> photos,
  Value<String> category,
  Value<String> gender,
  Value<String> size,
  Value<Map<String, dynamic>> sizeRange,
  Value<List<String>> seasonTags,
  Value<String?> storageLocationId,
  Value<int> quantity,
  Value<String?> notes,
  Value<DateTime> addedAt,
  Value<DateTime?> lastUsedAt,
  Value<String> status,
  Value<List<Map<String, dynamic>>> loanHistory,
  Value<int> rowid,
});

final class $$ItemsTableReferences
    extends BaseReferences<_$AppDatabase, $ItemsTable, Item> {
  $$ItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FamiliesTable _familyIdTable(_$AppDatabase db) => db.families
      .createAlias($_aliasNameGenerator(db.items.familyId, db.families.id));

  $$FamiliesTableProcessedTableManager get familyId {
    final $_column = $_itemColumn<String>('family_id')!;

    final manager = $$FamiliesTableTableManager($_db, $_db.families)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_familyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $StorageLocationsTable _storageLocationIdTable(_$AppDatabase db) =>
      db.storageLocations.createAlias($_aliasNameGenerator(
          db.items.storageLocationId, db.storageLocations.id));

  $$StorageLocationsTableProcessedTableManager? get storageLocationId {
    final $_column = $_itemColumn<String>('storage_location_id');
    if ($_column == null) return null;
    final manager =
        $$StorageLocationsTableTableManager($_db, $_db.storageLocations)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_storageLocationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ItemsTableFilterComposer extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
      get photos => $composableBuilder(
          column: $table.photos,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gender => $composableBuilder(
      column: $table.gender, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get size => $composableBuilder(
      column: $table.size, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Map<String, dynamic>, Map<String, dynamic>,
          String>
      get sizeRange => $composableBuilder(
          column: $table.sizeRange,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
      get seasonTags => $composableBuilder(
          column: $table.seasonTags,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
      column: $table.addedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastUsedAt => $composableBuilder(
      column: $table.lastUsedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<Map<String, dynamic>>,
          List<Map<String, dynamic>>, String>
      get loanHistory => $composableBuilder(
          column: $table.loanHistory,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  $$FamiliesTableFilterComposer get familyId {
    final $$FamiliesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.familyId,
        referencedTable: $db.families,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FamiliesTableFilterComposer(
              $db: $db,
              $table: $db.families,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$StorageLocationsTableFilterComposer get storageLocationId {
    final $$StorageLocationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.storageLocationId,
        referencedTable: $db.storageLocations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StorageLocationsTableFilterComposer(
              $db: $db,
              $table: $db.storageLocations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photos => $composableBuilder(
      column: $table.photos, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gender => $composableBuilder(
      column: $table.gender, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get size => $composableBuilder(
      column: $table.size, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sizeRange => $composableBuilder(
      column: $table.sizeRange, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get seasonTags => $composableBuilder(
      column: $table.seasonTags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
      column: $table.addedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastUsedAt => $composableBuilder(
      column: $table.lastUsedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get loanHistory => $composableBuilder(
      column: $table.loanHistory, builder: (column) => ColumnOrderings(column));

  $$FamiliesTableOrderingComposer get familyId {
    final $$FamiliesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.familyId,
        referencedTable: $db.families,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FamiliesTableOrderingComposer(
              $db: $db,
              $table: $db.families,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$StorageLocationsTableOrderingComposer get storageLocationId {
    final $$StorageLocationsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.storageLocationId,
        referencedTable: $db.storageLocations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StorageLocationsTableOrderingComposer(
              $db: $db,
              $table: $db.storageLocations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItemsTable> {
  $$ItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get photos =>
      $composableBuilder(column: $table.photos, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<String> get size =>
      $composableBuilder(column: $table.size, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, dynamic>, String>
      get sizeRange => $composableBuilder(
          column: $table.sizeRange, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get seasonTags =>
      $composableBuilder(
          column: $table.seasonTags, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUsedAt => $composableBuilder(
      column: $table.lastUsedAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<Map<String, dynamic>>, String>
      get loanHistory => $composableBuilder(
          column: $table.loanHistory, builder: (column) => column);

  $$FamiliesTableAnnotationComposer get familyId {
    final $$FamiliesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.familyId,
        referencedTable: $db.families,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FamiliesTableAnnotationComposer(
              $db: $db,
              $table: $db.families,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$StorageLocationsTableAnnotationComposer get storageLocationId {
    final $$StorageLocationsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.storageLocationId,
        referencedTable: $db.storageLocations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StorageLocationsTableAnnotationComposer(
              $db: $db,
              $table: $db.storageLocations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ItemsTable,
    Item,
    $$ItemsTableFilterComposer,
    $$ItemsTableOrderingComposer,
    $$ItemsTableAnnotationComposer,
    $$ItemsTableCreateCompanionBuilder,
    $$ItemsTableUpdateCompanionBuilder,
    (Item, $$ItemsTableReferences),
    Item,
    PrefetchHooks Function({bool familyId, bool storageLocationId})> {
  $$ItemsTableTableManager(_$AppDatabase db, $ItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> familyId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<List<String>> photos = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> gender = const Value.absent(),
            Value<String> size = const Value.absent(),
            Value<Map<String, dynamic>> sizeRange = const Value.absent(),
            Value<List<String>> seasonTags = const Value.absent(),
            Value<String?> storageLocationId = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> addedAt = const Value.absent(),
            Value<DateTime?> lastUsedAt = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<List<Map<String, dynamic>>> loanHistory =
                const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ItemsCompanion(
            id: id,
            familyId: familyId,
            title: title,
            photos: photos,
            category: category,
            gender: gender,
            size: size,
            sizeRange: sizeRange,
            seasonTags: seasonTags,
            storageLocationId: storageLocationId,
            quantity: quantity,
            notes: notes,
            addedAt: addedAt,
            lastUsedAt: lastUsedAt,
            status: status,
            loanHistory: loanHistory,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String familyId,
            required String title,
            required List<String> photos,
            required String category,
            required String gender,
            required String size,
            required Map<String, dynamic> sizeRange,
            required List<String> seasonTags,
            Value<String?> storageLocationId = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required DateTime addedAt,
            Value<DateTime?> lastUsedAt = const Value.absent(),
            required String status,
            required List<Map<String, dynamic>> loanHistory,
            Value<int> rowid = const Value.absent(),
          }) =>
              ItemsCompanion.insert(
            id: id,
            familyId: familyId,
            title: title,
            photos: photos,
            category: category,
            gender: gender,
            size: size,
            sizeRange: sizeRange,
            seasonTags: seasonTags,
            storageLocationId: storageLocationId,
            quantity: quantity,
            notes: notes,
            addedAt: addedAt,
            lastUsedAt: lastUsedAt,
            status: status,
            loanHistory: loanHistory,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ItemsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {familyId = false, storageLocationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (familyId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.familyId,
                    referencedTable: $$ItemsTableReferences._familyIdTable(db),
                    referencedColumn:
                        $$ItemsTableReferences._familyIdTable(db).id,
                  ) as T;
                }
                if (storageLocationId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.storageLocationId,
                    referencedTable:
                        $$ItemsTableReferences._storageLocationIdTable(db),
                    referencedColumn:
                        $$ItemsTableReferences._storageLocationIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ItemsTable,
    Item,
    $$ItemsTableFilterComposer,
    $$ItemsTableOrderingComposer,
    $$ItemsTableAnnotationComposer,
    $$ItemsTableCreateCompanionBuilder,
    $$ItemsTableUpdateCompanionBuilder,
    (Item, $$ItemsTableReferences),
    Item,
    PrefetchHooks Function({bool familyId, bool storageLocationId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FamiliesTableTableManager get families =>
      $$FamiliesTableTableManager(_db, _db.families);
  $$ChildrenTableTableManager get children =>
      $$ChildrenTableTableManager(_db, _db.children);
  $$StorageLocationsTableTableManager get storageLocations =>
      $$StorageLocationsTableTableManager(_db, _db.storageLocations);
  $$ItemsTableTableManager get items =>
      $$ItemsTableTableManager(_db, _db.items);
}
