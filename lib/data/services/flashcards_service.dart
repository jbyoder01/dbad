import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:dbad/data/models/flashcard.dart';

class FlashcardsService {
  final SupabaseClient _client;

  FlashcardsService(this._client);

  Future<List<Flashcard>> getFlashcardsForCategory(int categoryId) async {
    final data = await _client
        .from('flashcards')
        .select()
        .eq('category_id', categoryId)
        .order('created_at', ascending: false);
    return data.map(Flashcard.fromJson).toList();
  }

  Future<List<Flashcard>> getFlashcardsFiltered(
    int categoryId,
    String query,
  ) async {
    final data = await _client
        .from('flashcards')
        .select()
        .eq('category_id', categoryId)
        .or('question.ilike.%$query%,answer.ilike.%$query%')
        .order('created_at', ascending: false);
    return data.map(Flashcard.fromJson).toList();
  }

  Future<Flashcard> getFlashcardById(int id) async {
    final data = await _client
        .from('flashcards')
        .select()
        .eq('id', id)
        .single();
    return Flashcard.fromJson(data);
  }

  Future<int> insertFlashcard(
    int categoryId,
    String question,
    String answer,
  ) async {
    final data = await _client
        .from('flashcards')
        .insert({
          'category_id': categoryId,
          'question': question,
          'answer': answer,
        })
        .select('id')
        .single();
    return data['id'] as int;
  }

  Future<void> updateFlashcard(int id, String question, String answer) async {
    await _client
        .from('flashcards')
        .update({
          'question': question,
          'answer': answer,
        })
        .eq('id', id);
  }

  Future<void> deleteFlashcard(int id) async {
    await _client.from('flashcards').delete().eq('id', id);
  }

  Future<void> deleteFlashcardsForCategory(int categoryId) async {
    await _client.from('flashcards').delete().eq('category_id', categoryId);
  }
}
