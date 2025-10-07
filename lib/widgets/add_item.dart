import 'package:flutter/material.dart';

class AddItemDialog extends StatefulWidget{
  final String title;
  final String hintText;

  const AddItemDialog({Key? key, required this.title, this.hintText = ''}) : super(key: key);

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    // Validate first
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final value = _controller.text.trim();
    setState(() => _isSaving = true);

    // We return the value to the caller (who will save to DB).
    // If you wanted this dialog to save directly, you could call
    // your DB function here instead.
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(hintText: widget.hintText),
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter a value' : null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _onSave,
          child: _isSaving
            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
            : const Text('Save'),
        ),
      ],
    );
  }
}