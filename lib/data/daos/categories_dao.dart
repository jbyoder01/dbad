import 'package:drift/drift.dart';

import 'package:dbad/data/database.dart';
import 'package:dbad/data/tables/categories.dart';
import 'package:dbad/data/tables/flashcards.dart';

part 'categories_dao.g.dart';

@DriftAccessor(tables: [Categories, Flashcards])
class CategoriesDao extends DatabaseAccessor<AppDatabase>
    with _$CategoriesDaoMixin {
  CategoriesDao(super.db);

  Stream<List<Category>> watchAllCategories() {
    return (select(categories)
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  Stream<List<Category>> watchCategoriesFiltered(String query) {
    return (select(categories)
          ..where((t) => t.name.like('%$query%'))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  Future<Category> getCategoryById(int id) {
    return (select(categories)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<int> insertCategory(String name) {
    return into(categories).insert(
      CategoriesCompanion.insert(name: name),
    );
  }

  Future<void> updateCategory(int id, String name) {
    return (update(categories)..where((t) => t.id.equals(id))).write(
      CategoriesCompanion(
        name: Value(name),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteCategory(int id) {
    return transaction(() async {
      await (delete(flashcards)..where((t) => t.categoryId.equals(id))).go();
      await (delete(categories)..where((t) => t.id.equals(id))).go();
    });
  }
}
