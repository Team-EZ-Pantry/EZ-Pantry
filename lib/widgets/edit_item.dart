/// Editing dialog for pantry items
library;

/// Core Packages
import 'package:flutter/material.dart';

/// Dependencies
import 'package:provider/provider.dart';

/// Internal Imports
import '../models/pantry_item_model.dart';
import '../providers/pantry_provider.dart';


class EditItemDialog extends StatefulWidget{
  
  const EditItemDialog({
    super.key,
    required this.item,
  });

  final PantryItemModel item;

  @override
  State<EditItemDialog> createState() => _EditItemDialogState();
}

class _EditItemDialogState extends State<EditItemDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _productIdController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _expirationDateController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _quantityController.text = widget.item.quantity.toString();
    _expirationDateController.text = widget.item.expirationDate ?? '';
  }

  @override
  void dispose() {
    _productIdController.dispose();
    _quantityController.dispose();
    _expirationDateController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final int quantity = int.tryParse(_quantityController.text.trim()) ?? widget.item.quantity;
    final String? expirationDate = _expirationDateController.text.trim().isEmpty
        ? null
        : _expirationDateController.text.trim();

    setState(() => _isSaving = true);

    await context.read<PantryProvider>().updateQuantity(widget.item.id, quantity);
    if(mounted && expirationDate != null) {
      await context.read<PantryProvider>().updateExpirationDate(widget.item.id, expirationDate);
    }
    
    if (mounted) {
      await context.read<PantryProvider>().loadPantryItems();
    }

    setState(() => _isSaving = false);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: const EdgeInsets.all(50),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column( // Overall Column
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[ 
            IntrinsicHeight(
              child: Row( // Information Row
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: widget.item.imageUrl != null && widget.item.imageUrl!.isNotEmpty
                          ? Image.network(
                              widget.item.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                // Fallback if the URL fails to load
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.broken_image, color: Colors.grey),
                                );
                              },
                            )
                      : Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: DefaultTextStyle(
                      style: const TextStyle(fontSize: 16),
                      child: Column( // Text information column
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.item.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Expires: ${widget.item.expirationDate ?? 'none'}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Quantity: ${widget.item.quantity}',
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
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 20),
                  const Text('Edit', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _expirationDateController,
                    decoration: const InputDecoration(
                      labelText: 'Expiration Date',
                      hintText: 'YYYY-MM-DD',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: <Widget>[
                const SizedBox(height: 20),
                const Text('Nutrition Facts', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 15),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,        // in the future, let's add: energy-kcal, energy-kcal per serving,
                        children: <Widget>[                                          // nutrition score, salt, sodium, sugar, vitamins?, serving size
                          const Text('Calories'),
                          Text(widget.item.calories),
                          const SizedBox(height: 15),
                          const Text('Carbs'),
                          Text(widget.item.carbs),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text('Fat'),
                          Text(widget.item.fat),
                          const SizedBox(height: 15),
                          const Text('Protein'),
                          Text(widget.item.protein, textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if(!_isSaving){
                        final int? value = int.tryParse(_quantityController.text);
                        if (value != null && value >= 0) {
                          _onSave();
                        }
                        else{
                          showDialog<void>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Invalid Quantity'),
                                content: const Text('Quantity must be 0 or more.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                          );
                        }
                      }
                    },
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
