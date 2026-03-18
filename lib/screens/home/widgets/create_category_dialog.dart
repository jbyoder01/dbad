import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:dbad/providers/categories_provider.dart';

class CreateCategoryDialog extends StatefulWidget {
  const CreateCategoryDialog({super.key});

  @override
  State<CreateCategoryDialog> createState() => _CreateCategoryDialogState();
}

class _CreateCategoryDialogState extends State<CreateCategoryDialog> {
  final _controller = TextEditingController();
  bool _isValid = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Category'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(
          hintText: 'Category name',
        ),
        onChanged: (value) {
          setState(() {
            _isValid = value.trim().isNotEmpty;
          });
        },
        onSubmitted: (_) {
          if (_isValid) {
            _create();
          }
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _isValid ? _create : null,
          child: const Text('Create'),
        ),
        TextButton(
          onPressed: _isValid ? _createAndOpen : null,
          child: const Text('Create & Open'),
        ),
      ],
    );
  }

  Future<void> _create() async {
    final name = _controller.text.trim();
    await context.read<CategoriesProvider>().createCategory(name);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _createAndOpen() async {
    final name = _controller.text.trim();
    final id = await context.read<CategoriesProvider>().createCategory(name);
    if (mounted) {
      Navigator.of(context).pop();
      context.go('/category/$id');
    }
  }
}
