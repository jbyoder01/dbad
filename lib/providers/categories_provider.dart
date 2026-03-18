import 'dart:async';

import 'package:flutter/foundation.dart' hide Category;

import 'package:dbad/data/daos/categories_dao.dart';
import 'package:dbad/data/database.dart';

class CategoriesProvider extends ChangeNotifier {
  final CategoriesDao _dao;

  List<Category> _categories = [];
  String _searchQuery = '';
  StreamSubscription<List<Category>>? _subscription;

  CategoriesProvider(this._dao) {
    _subscribe();
  }

  List<Category> get categories => _categories;
  String get searchQuery => _searchQuery;

  void setSearchQuery(String query) {
    _searchQuery = query;
    _subscribe();
    notifyListeners();
  }

  Future<int> createCategory(String name) {
    return _dao.insertCategory(name);
  }

  Future<void> deleteCategory(int id) {
    return _dao.deleteCategory(id);
  }

  Future<void> updateCategory(int id, String name) {
    return _dao.updateCategory(id, name);
  }

  void _subscribe() {
    _subscription?.cancel();
    final stream = _searchQuery.isEmpty
        ? _dao.watchAllCategories()
        : _dao.watchCategoriesFiltered(_searchQuery);
    _subscription = stream.listen((data) {
      _categories = data;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
