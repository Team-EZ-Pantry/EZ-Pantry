import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pantry_item.dart';
import '../providers/pantry_provider.dart';


class EditItemDialog extends StatefulWidget{
  final PantryItemModel item;
  
  EditItemDialog({
    Key? key,
    required this.item,
  }) : super(key: key);

  /*
  final String title;
  final String itemName;
  final String? itemExpirationDate;
  final int itemId;
  final int itemQuantity;
  final String? itemBrand = "Welch's Concord";
  */
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
    await context.read<PantryProvider>().updateItem(widget.item.id, widget.item.quantity, widget.item.expirationDate); // example userId = 2

    setState(() => _isSaving = false);

    Navigator.of(context).pop(); // close dialog
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.fromLTRB(6, 5, 6, 6),
        width: double.infinity,
        height: double.infinity,
        child: Column( // Overall Column
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [ 
            IntrinsicHeight(
              child: Row( // Information Row
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Container(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: DefaultTextStyle(
                      style: const TextStyle(fontSize: 16),
                      child: Column( // Text information column
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Product name: ${widget.item.name}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Item brand: ${'brand here'}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Expiration date: ${widget.item.expirationDate ?? 'none'}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Item quantity: ${widget.item.quantity}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 10, color: Colors.grey,),
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