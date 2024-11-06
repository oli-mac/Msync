import 'package:flutter/material.dart';
import 'package:msync/models/song.dart';

class UrlInputDialog extends StatefulWidget {
  const UrlInputDialog({super.key});

  @override
  State<UrlInputDialog> createState() => _UrlInputDialogState();
}

class _UrlInputDialogState extends State<UrlInputDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _artistController = TextEditingController();
  final _urlController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _artistController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Song from URL'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter song title',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _artistController,
              decoration: const InputDecoration(
                labelText: 'Artist',
                hintText: 'Enter artist name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an artist';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'URL',
                hintText: 'Enter audio URL',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a URL';
                }
                if (!Uri.tryParse(value)!.hasAbsolutePath ?? false) {
                  return 'Please enter a valid URL';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final song = Song(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: _titleController.text,
                artist: _artistController.text,
                url: _urlController.text,
                duration: const Duration(seconds: 0),
              );
              Navigator.of(context).pop(song);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
