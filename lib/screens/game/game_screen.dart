import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:dbad/data/models/flashcard.dart';
import 'package:dbad/screens/flashcard/widgets/flashcard.dart' as widgets;

class GameScreen extends StatefulWidget {
  final List<Flashcard> flashcards;

  const GameScreen({super.key, required this.flashcards});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final PageController _pageController = PageController();
  late final List<Flashcard> _cards;
  int _currentIndex = 0;
  bool _isComplete = false;

  @override
  void initState() {
    super.initState();
    _cards = List.of(widget.flashcards)..shuffle();
    _isComplete = _cards.isEmpty;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    if (index >= _cards.length) {
      setState(() {
        _isComplete = true;
      });
      return;
    }
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isComplete) {
      return Scaffold(
        appBar: AppBar(title: const Text('Done!')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'You reviewed all ${_cards.length} cards!',
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
        title: Text('Card ${_currentIndex + 1} of ${_cards.length}'),
      ),
      body: SafeArea(
        top: false,
        child: PageView.builder(
          controller: _pageController,
          itemCount: _cards.length + 1,
          onPageChanged: _onPageChanged,
          itemBuilder: (context, index) {
            if (index >= _cards.length) {
              return const SizedBox.shrink();
            }
            final card = _cards[index];
            return Padding(
              padding: const EdgeInsets.all(16),
              child: widgets.Flashcard(
                question: card.question,
                answer: card.answer,
              ),
            );
          },
        ),
      ),
    );
  }
}

const _completionStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w500);
