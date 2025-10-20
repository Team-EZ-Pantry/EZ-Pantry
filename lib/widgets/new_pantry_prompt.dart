import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewPantryPrompt extends StatefulWidget {
  const NewPantryPrompt({super.key});

  @override
  State<NewPantryPrompt> createState() => _NewPantryPromptState();
}

class _NewPantryPromptState extends State<NewPantryPrompt> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final name = _controller.text.trim();
    if (name.isNotEmpty) {
      Navigator.pop(context, name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Pantry'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(
          labelText: 'Pantry Name',
          hintText: 'Enter pantry name',
          border: OutlineInputBorder(),
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(50),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
