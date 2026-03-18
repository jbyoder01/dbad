import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:dbad/data/daos/flashcards_dao.dart';
import 'package:dbad/data/database.dart';

class FlashcardsProvider extends ChangeNotifier {
  final FlashcardsDao _dao;
  final int categoryId;

  List<Flashcard> _flashcards = [];
  String _searchQuery = '';
  StreamSubscription<List<Flashcard>>? _subscription;

  FlashcardsProvider(this._dao, this.categoryId) {
    _subscribe();
  }

  List<Flashcard> get flashcards => _flashcards;
  String get searchQuery => _searchQuery;

  void setSearchQuery(String query) {
    _searchQuery = query;
    _subscribe();
    notifyListeners();
  }

  Future<int> createFlashcard(String question, String answer) {
    return _dao.insertFlashcard(categoryId, question, answer);
  }

  Future<void> updateFlashcard(int id, String question, String answer) {
    return _dao.updateFlashcard(id, question, answer);
  }

  Future<void> deleteFlashcard(int id) {
    return _dao.deleteFlashcard(id);
  }

  void _subscribe() {
    _subscription?.cancel();
    final stream = _searchQuery.isEmpty
        ? _dao.watchFlashcardsForCategory(categoryId)
        : _dao.watchFlashcardsFiltered(categoryId, _searchQuery);
    _subscription = stream.listen((data) {
      _flashcards = data;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
