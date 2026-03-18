import 'package:drift/drift.dart';

import 'package:dbad/data/database.dart';
import 'package:dbad/data/tables/flashcards.dart';

part 'flashcards_dao.g.dart';

@DriftAccessor(tables: [Flashcards])
class FlashcardsDao extends DatabaseAccessor<AppDatabase>
    with _$FlashcardsDaoMixin {
  FlashcardsDao(super.db);

  Stream<List<Flashcard>> watchFlashcardsForCategory(int categoryId) {
    return (select(flashcards)
          ..where((t) => t.categoryId.equals(categoryId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Stream<List<Flashcard>> watchFlashcardsFiltered(
    int categoryId,
    String query,
  ) {
    return (select(flashcards)
          ..where(
            (t) =>
                t.categoryId.equals(categoryId) &
                (t.question.like('%$query%') | t.answer.like('%$query%')),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Future<List<Flashcard>> getFlashcardsForCategory(int categoryId) {
    return (select(flashcards)
          ..where((t) => t.categoryId.equals(categoryId)))
        .get();
  }

  Future<Flashcard> getFlashcardById(int id) {
    return (select(flashcards)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<int> insertFlashcard(int categoryId, String question, String answer) {
    return into(flashcards).insert(
      FlashcardsCompanion.insert(
        categoryId: categoryId,
        question: question,
        answer: answer,
      ),
    );
  }

  Future<void> updateFlashcard(int id, String question, String answer) {
    return (update(flashcards)..where((t) => t.id.equals(id))).write(
      FlashcardsCompanion(
        question: Value(question),
        answer: Value(answer),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> deleteFlashcard(int id) {
    return (delete(flashcards)..where((t) => t.id.equals(id))).go();
  }

  Future<void> deleteFlashcardsForCategory(int categoryId) {
    return (delete(flashcards)..where((t) => t.categoryId.equals(categoryId)))
        .go();
  }
}
