import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dbad/data/services/categories_service.dart';

class RenameCategoryDialog extends StatefulWidget {
  final int categoryId;
  final String currentName;
  final ValueChanged<String> onRenamed;

  const RenameCategoryDialog({
    super.key,
    required this.categoryId,
    required this.currentName,
    required this.onRenamed,
  });

  @override
  State<RenameCategoryDialog> createState() => _RenameCategoryDialogState();
}

class _RenameCategoryDialogState extends State<RenameCategoryDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rename Category'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'Category name'),
        textCapitalization: .words,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _save,
          child: const Text('Save'),
        ),
      ],
    );
  }

  Future<void> _save() async {
    final name = _controller.text.trim();
    if (name.isNotEmpty) {
      await context
          .read<CategoriesService>()
          .updateCategory(widget.categoryId, name);
      widget.onRenamed(name);
    }
    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
