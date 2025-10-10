import 'package:flutter/material.dart';

class AddItemDialog extends StatefulWidget{
  
  AddItemDialog({Key? key, required this.title, this.hintText = '', this.itemName = '', this.itemQuantity = 0, this.itemSize = ''}) : super(key: key);


  final String title;
  final String hintText;
  String itemName;
  int itemQuantity;
  String itemSize;

 
  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _sizeController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    // Validate first
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final value = _nameController.text.trim();
    setState(() => _isSaving = true);

    // We return the value to the caller (who will save to DB).
    // If you wanted this dialog to save directly, you could call
    // your DB function here instead.
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(12),
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              autofocus: true,
              decoration: InputDecoration(hintText: widget.hintText),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter product name' : null,
            ),
            TextFormField(
              controller: _quantityController,
              autofocus: true,
              decoration: InputDecoration(hintText: widget.hintText),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter product quantity' : null,
            ),
            TextFormField(
              controller: _sizeController,
              autofocus: true,
              decoration: InputDecoration(hintText: widget.hintText),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter product size' : null,
            ),
          ],
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