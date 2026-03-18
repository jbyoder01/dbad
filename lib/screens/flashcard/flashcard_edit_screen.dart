import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:dbad/data/daos/flashcards_dao.dart';

class FlashcardEditScreen extends StatefulWidget {
  final int categoryId;
  final int? flashcardId;

  const FlashcardEditScreen({
    super.key,
    required this.categoryId,
    this.flashcardId,
  });

  bool get isEditing => flashcardId != null;

  @override
  State<FlashcardEditScreen> createState() => _FlashcardEditScreenState();
}

class _FlashcardEditScreenState extends State<FlashcardEditScreen> {
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _loadFlashcard();
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  Future<void> _loadFlashcard() async {
    setState(() {
      _isLoading = true;
    });
    final flashcard = await context.read<FlashcardsDao>().getFlashcardById(
      widget.flashcardId!,
    );
    if (mounted) {
      _questionController.text = flashcard.question;
      _answerController.text = flashcard.answer;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Flashcard' : 'New Flashcard'),
        actions: [
          TextButton(onPressed: _save, child: const Text('Save')),
          if (widget.isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _confirmDelete,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: _questionController,
                        decoration: const InputDecoration(
                          labelText: 'Question',
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _answerController,
                        decoration: const InputDecoration(
                          labelText: 'Answer',
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    ),
                  ],
                ),
              ),
          ),
    );
  }

  Future<void> _save() async {
    final question = _questionController.text.trim();
    final answer = _answerController.text.trim();
    if (question.isEmpty || answer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Both fields are required.')),
      );
      return;
    }

    final dao = context.read<FlashcardsDao>();
    if (widget.isEditing) {
      await dao.updateFlashcard(widget.flashcardId!, question, answer);
    } else {
      await dao.insertFlashcard(widget.categoryId, question, answer);
    }

    if (mounted) {
      context.pop();
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Flashcard'),
        content: const Text('Are you sure you want to delete this flashcard?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await context.read<FlashcardsDao>().deleteFlashcard(
                widget.flashcardId!,
              );
              if (ctx.mounted) {
                Navigator.of(ctx).pop();
              }
              if (mounted) {
                context.pop();
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
