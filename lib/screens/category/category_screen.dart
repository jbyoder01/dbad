import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:dbad/data/daos/categories_dao.dart';
import 'package:dbad/data/database.dart';
import 'package:dbad/providers/flashcards_provider.dart';
import 'package:dbad/screens/category/widgets/flashcard_tile.dart';
import 'package:dbad/screens/category/widgets/rename_category_dialog.dart';

class CategoryScreen extends StatefulWidget {
  final int categoryId;

  const CategoryScreen({super.key, required this.categoryId});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  Category? _category;

  @override
  void initState() {
    super.initState();
    _loadCategory();
  }

  Future<void> _loadCategory() async {
    final category = await context.read<CategoriesDao>().getCategoryById(
      widget.categoryId,
    );
    if (mounted) {
      setState(() {
        _category = category;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_category?.name ?? ''),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _category != null
                ? () {
                    showDialog(
                      context: context,
                      builder: (_) => RenameCategoryDialog(
                        categoryId: widget.categoryId,
                        currentName: _category!.name,
                        onRenamed: (name) {
                          setState(() {
                            _category = _category!.copyWith(name: name);
                          });
                        },
                      ),
                    );
                  }
                : null,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Consumer<FlashcardsProvider>(
              builder: (context, provider, _) {
                return TextField(
                  decoration: _searchDecoration,
                  onChanged: provider.setSearchQuery,
                );
              },
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Consumer<FlashcardsProvider>(
                builder: (context, provider, _) {
                  if (provider.flashcards.isEmpty) {
                    return Center(
                      child: Text(
                        provider.searchQuery.isEmpty
                            ? 'No flashcards yet.\nTap "Add Flashcard" to get started.'
                            : 'No flashcards match your search.',
                        textAlign: TextAlign.center,
                        style: _emptyStyle(context),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: provider.flashcards.length,
                    itemBuilder: (context, index) {
                      return FlashcardTile(
                        flashcard: provider.flashcards[index],
                        categoryId: widget.categoryId,
                      );
                    },
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Consumer<FlashcardsProvider>(
                    builder: (context, provider, _) {
                      return FilledButton.icon(
                        onPressed: provider.flashcards.isEmpty
                            ? null
                            : () => context.go(
                                '/category/${widget.categoryId}/play',
                              ),
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Start'),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context.go(
                      '/category/${widget.categoryId}/flashcard/new',
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Flashcard'),
                  ),
                ),
              ],
            ),
            SafeArea(top: false, child: const SizedBox(height: 16)),
          ],
        ),
      ),
    );
  }
}

const _searchDecoration = InputDecoration(
  hintText: 'Search flashcards...',
  prefixIcon: Icon(Icons.search),
  border: OutlineInputBorder(),
  isDense: true,
);

TextStyle _emptyStyle(BuildContext context) {
  return TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant);
}
