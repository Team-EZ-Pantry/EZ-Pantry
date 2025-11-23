import 'dart:async';

import 'package:flutter/material.dart';

import '../services/shopping_service.dart';

/// Intialize
dynamic searchResults      = '';
int     selectedProductID  = -1;
String selectedProductType = '';

/// Constants
const String customProductKey = 'custom_product';

class AddListDialog extends StatefulWidget {
  const AddListDialog({
    super.key,
    required this.title,
    this.hintText = '',
    this.listName = '',
  });

  final String title;
  final String hintText;
  final String listName;
  
  @override
  State<AddListDialog> createState() => _AddListDialogState();
}

class _AddListDialogState extends State<AddListDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _listNameController    = TextEditingController();

  bool _isSaving = false;

  @override
  void dispose() {
    _listNameController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
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
                SizedBox(width: MediaQuery.sizeOf(context).width * .9),
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
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save'),
            ),
          ],
        ),
      ],
    );
  }
}
