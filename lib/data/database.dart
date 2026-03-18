import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'package:dbad/data/tables/categories.dart';
import 'package:dbad/data/tables/flashcards.dart';
import 'package:dbad/data/daos/categories_dao.dart';
import 'package:dbad/data/daos/flashcards_dao.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [Categories, Flashcards],
  daos: [CategoriesDao, FlashcardsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'dbad.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
