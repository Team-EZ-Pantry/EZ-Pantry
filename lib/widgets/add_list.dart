/// Widget to add a list to user's shopping lists
library;

// Core packages
import 'dart:async';
import 'package:flutter/material.dart';

// Internal Imports
import '../services/shopping_service.dart';

class AddListDialog extends StatefulWidget {
  const AddListDialog({
    super.key,
    required this.title,
  });

  final String title;
  
  @override
  State<AddListDialog> createState() => _AddListDialogState();
}

class _AddListDialogState extends State<AddListDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _listNameController = TextEditingController();

  bool _isSaving = false;
  @override
  void dispose() {
    _listNameController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    // Is input valid?
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    // Handle submission
    setState(() => _isSaving = true);
    final ShoppingService shoppingService = ShoppingService();
    shoppingService.createShoppingList(_listNameController.text);

    setState(() => _isSaving = false);
    if (mounted) {
      Navigator.of(context).pop(); // close dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AlertDialog(
          contentPadding: const EdgeInsets.all(12),
          title: Text(widget.title),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: _listNameController,
                  autofocus: true,
                  decoration: const InputDecoration(hintText: 'List Name'),
                  validator: (String? value) =>
                    (value == null || value.trim().isEmpty) ? 'Please enter a list name' : null,
                ),
              ],
            ),
          ),

          actions: <Widget>[
            TextButton(
              onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _isSaving ? null : _onSave,
              child: _isSaving
                // true
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                // false  
                : const Text('Save'),
            ),
          ],
        ),
      ],
    );
  }
}
