import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:dbad/data/models/category.dart';

class CategoriesService {
  final SupabaseClient _client;

  CategoriesService(this._client);

  Future<List<Category>> getAllCategories() async {
    final data = await _client
        .from('categories')
        .select()
        .order('name');
    return data.map(Category.fromJson).toList();
  }

  Future<List<Category>> getCategoriesFiltered(String query) async {
    final data = await _client
        .from('categories')
        .select()
        .ilike('name', '%$query%')
        .order('name');
    return data.map(Category.fromJson).toList();
  }

  Future<Category> getCategoryById(int id) async {
    final data = await _client
        .from('categories')
        .select()
        .eq('id', id)
        .single();
    return Category.fromJson(data);
  }

  Future<int> insertCategory(String name) async {
    final data = await _client
        .from('categories')
        .insert({'name': name})
        .select('id')
        .single();
    return data['id'] as int;
  }

  Future<void> updateCategory(int id, String name) async {
    await _client
        .from('categories')
        .update({'name': name})
        .eq('id', id);
  }

  Future<void> deleteCategory(int id) async {
    await _client.from('categories').delete().eq('id', id);
  }
}
