import 'package:flutter/foundation.dart' hide Category;
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:dbad/data/models/category.dart';
import 'package:dbad/data/services/categories_service.dart';

class CategoriesProvider extends ChangeNotifier {
  final CategoriesService _service;

  List<Category> _categories = [];
  String _searchQuery = '';
  bool _isLoading = false;

  CategoriesProvider(SupabaseClient client)
      : _service = CategoriesService(client) {
    _loadData();
  }

  List<Category> get categories => _categories;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  void setSearchQuery(String query) {
    _searchQuery = query;
    _loadData();
  }

  Future<Category> getCategoryById(int id) async {
    return _service.getCategoryById(id);
  }

  Future<int> createCategory(String name) async {
    final id = await _service.insertCategory(name);
    await _loadData();
    return id;
  }

  Future<void> deleteCategory(int id) async {
    await _service.deleteCategory(id);
    await _loadData();
  }

  Future<void> updateCategory(int id, String name) async {
    await _service.updateCategory(id, name);
    await _loadData();
  }

  Future<void> _loadData() async {
    _isLoading = true;
    notifyListeners();

    _categories = _searchQuery.isEmpty
        ? await _service.getAllCategories()
        : await _service.getCategoriesFiltered(_searchQuery);

    _isLoading = false;
    notifyListeners();
  }
}
