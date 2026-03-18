// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flashcards_dao.dart';

// ignore_for_file: type=lint
mixin _$FlashcardsDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoriesTable get categories => attachedDatabase.categories;
  $FlashcardsTable get flashcards => attachedDatabase.flashcards;
  FlashcardsDaoManager get managers => FlashcardsDaoManager(this);
}

class FlashcardsDaoManager {
  final _$FlashcardsDaoMixin _db;
  FlashcardsDaoManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db.attachedDatabase, _db.categories);
  $$FlashcardsTableTableManager get flashcards =>
      $$FlashcardsTableTableManager(_db.attachedDatabase, _db.flashcards);
}
