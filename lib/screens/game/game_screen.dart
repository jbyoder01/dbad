import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:dbad/providers/game_provider.dart';
import 'package:dbad/screens/flashcard/widgets/flashcard.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, _) {
        if (game.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive()),
          );
        }

        if (game.isComplete) {
          return Scaffold(
            appBar: AppBar(title: const Text('Done!')),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'You reviewed all ${game.totalCards} cards!',
                    style: _completionStyle,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () => context.pop(),
                    child: const Text('Done'),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Card ${game.currentIndex + 1} of ${game.totalCards}'),
          ),
          body: SafeArea(
            top: false,
            child: PageView.builder(
              controller: _pageController,
              itemCount: game.totalCards + 1,
              onPageChanged: (index) => game.onPageChanged(index),
              itemBuilder: (context, index) {
                if (index >= game.totalCards) {
                  return const SizedBox.shrink();
                }
                final card = game.cards[index];
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Flashcard(
                    question: card.question,
                    answer: card.answer,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

const _completionStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w500);
