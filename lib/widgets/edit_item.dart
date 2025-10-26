import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pantry_provider.dart';


class EditItemDialog extends StatefulWidget{
  
  EditItemDialog({Key? key, required this.title, this.itemName = '', this.itemQuantity = 0, this.itemId = 0, this.itemExpirationDate}) : super(key: key);

  final String title;
  final String itemName;
  final String? itemExpirationDate;
  final int itemId;
  final int itemQuantity;

  @override
  State<EditItemDialog> createState() => _EditItemDialogState();
}

class _EditItemDialogState extends State<EditItemDialog> {
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
    await context.read<PantryProvider>().updateItem(productId, quantity, expirationDate); // example userId = 2

    setState(() => _isSaving = false);

    Navigator.of(context).pop(); // close dialog
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        margin: EdgeInsets.all(20),
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [ 
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: _isSaving ? null : _onSave,
                    child: _isSaving
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Save')
                  ),
                ],
              ),
            )
          ]
        ),
      ),
    );
  }
}