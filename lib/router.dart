import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dbad/providers/flashcards_provider.dart';
import 'package:dbad/screens/home/home_screen.dart';
import 'package:dbad/screens/category/category_screen.dart';
import 'package:dbad/screens/flashcard/flashcard_edit_screen.dart';
import 'package:dbad/screens/game/game_screen.dart';

final goRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [
        ShellRoute(
          builder: (context, state, child) {
            final categoryId = int.parse(state.pathParameters['id']!);
            return ChangeNotifierProvider(
              key: ValueKey(categoryId),
              create: (_) =>
                  FlashcardsProvider(Supabase.instance.client, categoryId),
              child: child,
            );
          },
          routes: [
            GoRoute(
              path: 'category/:id',
              builder: (context, state) {
                final categoryId = int.parse(state.pathParameters['id']!);
                return CategoryScreen(categoryId: categoryId);
              },
              routes: [
                GoRoute(
                  path: 'flashcard/new',
                  builder: (context, state) {
                    return FlashcardEditScreen();
                  },
                ),
                GoRoute(
                  path: 'flashcard/:flashcardId',
                  builder: (context, state) {
                    final flashcardId = int.parse(
                      state.pathParameters['flashcardId']!,
                    );
                    return FlashcardEditScreen(flashcardId: flashcardId);
                  },
                ),
                GoRoute(
                  path: 'play',
                  builder: (context, state) {
                    final flashcards = context
                        .read<FlashcardsProvider>()
                        .flashcards;
                    return GameScreen(flashcards: flashcards);
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
