import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:dbad/data/models/flashcard.dart';
import 'package:dbad/data/services/flashcards_service.dart';

class FlashcardsProvider extends ChangeNotifier {
  final FlashcardsService _service;
  final int categoryId;

  List<Flashcard> _flashcards = [];
  String _searchQuery = '';
  bool _isLoading = false;

  FlashcardsProvider(SupabaseClient client, this.categoryId)
      : _service = FlashcardsService(client) {
    _loadData();
  }

  List<Flashcard> get flashcards => _flashcards;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  void setSearchQuery(String query) {
    _searchQuery = query;
    _loadData();
  }

  Future<Flashcard> getFlashcardById(int id) async {
    return _service.getFlashcardById(id);
  }

  Future<int> createFlashcard(String question, String answer) async {
    final id = await _service.insertFlashcard(categoryId, question, answer);
    await _loadData();
    return id;
  }

  Future<void> updateFlashcard(int id, String question, String answer) async {
    await _service.updateFlashcard(id, question, answer);
    await _loadData();
  }

  Future<void> deleteFlashcard(int id) async {
    await _service.deleteFlashcard(id);
    await _loadData();
  }

  Future<void> _loadData() async {
    _isLoading = true;
    notifyListeners();

    _flashcards = _searchQuery.isEmpty
        ? await _service.getFlashcardsForCategory(categoryId)
        : await _service.getFlashcardsFiltered(categoryId, _searchQuery);

    _isLoading = false;
    notifyListeners();
  }
}
