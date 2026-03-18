import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

class Flashcard extends StatefulWidget {
  final String question;
  final String answer;

  const Flashcard({super.key, required this.question, required this.answer});

  @override
  State<Flashcard> createState() => _FlashcardState();
}

class _FlashcardState extends State<Flashcard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flipController;
  late final Animation<double> _flipAnimation;
  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _flipAnimation = CurvedAnimation(
      parent: _flipController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _toggleFlip() {
    _isFlipped = !_isFlipped;
    if (_isFlipped) {
      _flipController.forward();
    } else {
      _flipController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleFlip,
      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (context, _) {
          final angle = _flipAnimation.value * pi;
          final showBack = _flipAnimation.value >= 0.5;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: showBack
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(pi),
                    child: _buildCard(
                      context,
                      label: 'ANSWER',
                      text: widget.answer,
                      color: Theme.of(context).colorScheme.secondaryContainer,
                    ),
                  )
                : _buildCard(
                    context,
                    label: 'QUESTION',
                    text: widget.question,
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
          );
        },
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String label,
    required String text,
    required Color color,
  }) {
    return Card(
      color: color,
      elevation: 8,
      child: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            spacing: 16,
            children: [
              Text(label, style: _labelStyle(context)),
              Flexible(
                child: MarkdownBody(
                  data: text,
                  styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                      .copyWith(
                        p: _cardTextStyle,
                        code: _cardTextStyle.copyWith(
                          fontFamily: 'monospace',
                          fontSize: 18,
                        ),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

TextStyle _labelStyle(BuildContext context) {
  return TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 2,
    color: Theme.of(context).colorScheme.onSurfaceVariant,
  );
}

const _cardTextStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w500);
