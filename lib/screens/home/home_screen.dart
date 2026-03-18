import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dbad/providers/categories_provider.dart';
import 'package:dbad/screens/home/widgets/category_tile.dart';
import 'package:dbad/screens/home/widgets/create_category_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Text('DBAD', style: _headerStyle),
              const SizedBox(height: 24),
              Consumer<CategoriesProvider>(
                builder: (context, provider, _) {
                  return TextField(
                    decoration: _searchDecoration,
                    onChanged: provider.setSearchQuery,
                  );
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Consumer<CategoriesProvider>(
                  builder: (context, provider, _) {
                    if (provider.categories.isEmpty) {
                      return Center(
                        child: Text(
                          provider.searchQuery.isEmpty
                              ? 'No categories yet.\nTap + to create one.'
                              : 'No categories match your search.',
                          textAlign: TextAlign.center,
                          style: _emptyStyle(context),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: provider.categories.length,
                      itemBuilder: (context, index) {
                        return CategoryTile(
                          category: provider.categories[index],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const CreateCategoryDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

const _headerStyle = TextStyle(
  fontSize: 48,
  fontWeight: FontWeight.bold,
  letterSpacing: 4,
);

const _searchDecoration = InputDecoration(
  hintText: 'Search categories...',
  prefixIcon: Icon(Icons.search),
  border: OutlineInputBorder(),
);

TextStyle _emptyStyle(BuildContext context) {
  return TextStyle(
    color: Theme.of(context).colorScheme.onSurfaceVariant,
  );
}
