import 'package:flutter/foundation.dart';

import 'package:dbad/data/models/flashcard.dart';
import 'package:dbad/data/services/flashcards_service.dart';

class GameProvider extends ChangeNotifier {
  final FlashcardsService _service;

  List<Flashcard> _cards = [];
  int _currentIndex = 0;
  bool _isComplete = false;
  bool _isLoading = true;

  GameProvider(this._service);

  List<Flashcard> get cards => List.unmodifiable(_cards);
  int get currentIndex => _currentIndex;
  int get totalCards => _cards.length;
  bool get isComplete => _isComplete;
  bool get isLoading => _isLoading;

  Future<void> loadCards(int categoryId) async {
    _isLoading = true;
    notifyListeners();

    _cards = await _service.getFlashcardsForCategory(categoryId);
    _cards.shuffle();
    _currentIndex = 0;
    _isComplete = _cards.isEmpty;
    _isLoading = false;
    notifyListeners();
  }

  void onPageChanged(int index) {
    if (index >= _cards.length) {
      markComplete();
      return;
    }
    _currentIndex = index;
    notifyListeners();
  }

  void markComplete() {
    _isComplete = true;
    notifyListeners();
  }
}
