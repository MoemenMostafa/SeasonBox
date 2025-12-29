import 'package:drift/drift.dart';
import 'package:drift/web.dart';

LazyDatabase connect() {
  return LazyDatabase(() async {
    return WebDatabase.withStorage(DriftWebStorage.indexedDb('seasonbox_db'));
  });
}
