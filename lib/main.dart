import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dbad/app.dart';
import 'package:dbad/data/database.dart';
import 'package:dbad/data/daos/categories_dao.dart';
import 'package:dbad/data/daos/flashcards_dao.dart';
import 'package:dbad/providers/categories_provider.dart';

void main() {
  final database = AppDatabase();

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: database),
        Provider<CategoriesDao>.value(value: database.categoriesDao),
        Provider<FlashcardsDao>.value(value: database.flashcardsDao),
        ChangeNotifierProvider(
          create: (context) => CategoriesProvider(
            context.read<CategoriesDao>(),
          ),
        ),
      ],
      child: const App(),
    ),
  );
}
