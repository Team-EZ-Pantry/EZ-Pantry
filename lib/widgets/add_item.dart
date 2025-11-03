import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pantry_provider.dart';


class AddItemDialog extends StatefulWidget{
  
  AddItemDialog({Key? key, required this.title, this.hintText = '', this.itemName = '', this.itemQuantity = 0, this.itemExpirationDate = ''}) : super(key: key);

  final String title;
  final String hintText;
  final String itemName;
  final int itemQuantity;
  final String itemExpirationDate;

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _productIdController = TextEditingController();
  final _quantityController = TextEditingController();
  final _expirationDateController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _productIdController.dispose();
    _quantityController.dispose();
    _expirationDateController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final productId = int.parse(_productIdController.text.trim());
    final quantity = int.tryParse(_quantityController.text.trim()) ?? 0;
    final expirationDate = _expirationDateController.text.trim();

    setState(() => _isSaving = true);

    // Send directly to the provider
    await context.read<PantryProvider>().addItem(productId, quantity, expirationDate); // example userId = 2

    setState(() => _isSaving = false);

    Navigator.of(context).pop(); // close dialog
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
              controller: _productIdController,
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Product #'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter product number' : null,
            ),
            TextFormField(
              controller: _quantityController,
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Quantity'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter product quantity' : null,
            ),
            TextFormField(
              controller: _expirationDateController,
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Expiration date (optional)'),
              //validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter product expiration date' : null,
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