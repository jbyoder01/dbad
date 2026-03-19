import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:dbad/data/services/flashcards_service.dart';
import 'package:dbad/providers/flashcards_provider.dart';
import 'package:dbad/providers/game_provider.dart';
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
        GoRoute(
          path: 'category/:id',
          builder: (context, state) {
            final categoryId = int.parse(state.pathParameters['id']!);
            return ChangeNotifierProvider(
              create: (context) => FlashcardsProvider(
                context.read<FlashcardsService>(),
                categoryId,
              ),
              child: CategoryScreen(categoryId: categoryId),
            );
          },
          routes: [
            GoRoute(
              path: 'flashcard/new',
              builder: (context, state) {
                final categoryId = int.parse(state.pathParameters['id']!);
                return FlashcardEditScreen(categoryId: categoryId);
              },
            ),
            GoRoute(
              path: 'flashcard/:flashcardId',
              builder: (context, state) {
                final categoryId = int.parse(state.pathParameters['id']!);
                final flashcardId =
                    int.parse(state.pathParameters['flashcardId']!);
                return FlashcardEditScreen(
                  categoryId: categoryId,
                  flashcardId: flashcardId,
                );
              },
            ),
            GoRoute(
              path: 'play',
              builder: (context, state) {
                final categoryId = int.parse(state.pathParameters['id']!);
                final service = context.read<FlashcardsService>();
                return ChangeNotifierProvider(
                  create: (_) => GameProvider(service)..loadCards(categoryId),
                  child: const GameScreen(),
                );
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
