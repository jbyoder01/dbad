import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:dbad/data/models/flashcard.dart';

class FlashcardTile extends StatelessWidget {
  final Flashcard flashcard;
  final int categoryId;

  const FlashcardTile({
    super.key,
    required this.flashcard,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        flashcard.question,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        flashcard.answer,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: _subtitleStyle(context),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.go(
        '/category/$categoryId/flashcard/${flashcard.id}',
      ),
    );
  }
}

TextStyle _subtitleStyle(BuildContext context) {
  return TextStyle(
    color: Theme.of(context).colorScheme.onSurfaceVariant,
  );
}
