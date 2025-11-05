/// Adds custom items to pantry
library;

/// Core Packages
import 'package:flutter/material.dart';

/// Dependencies
import 'package:provider/provider.dart';

/// Internal Imports
import '../models/pantry_item_model.dart';
import '../providers/pantry_provider.dart';

class AddCustomItemDialog extends StatefulWidget{
  /// Constructor
  const AddCustomItemDialog({
    super.key,
  });

  @override
  State<AddCustomItemDialog> createState() => _AddCustomItemDialogState();
}

class _AddCustomItemDialogState extends State<AddCustomItemDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _productIdController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _expirationDateController = TextEditingController();

  late PantryItemModel customItem;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _productIdController.dispose();
    _quantityController.dispose();
    _expirationDateController.dispose();
    super.dispose();
  }

  /// Checks input and saves item if all forms are valid
  Future<void> _onSave() async {
    /// Check inputs
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final int quantity = int.tryParse(_quantityController.text.trim()) ?? customItem.quantity;
    final String? expirationDate = _expirationDateController.text.trim().isEmpty
        ? null
        : _expirationDateController.text.trim();

    setState(() => _isSaving = true);
    
    /// Reload pantry view
    await context.read<PantryProvider>().loadPantryItems();

    setState(() => _isSaving = false);

    /// Close Dialog
    Navigator.of(context).pop();
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
                      child: const Icon(Icons.image_not_supported_outlined)
                        ///(TODO): Custom Items may not have photos. Ask team.
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Expanded(
                    child: DefaultTextStyle(
                      style: TextStyle(fontSize: 16),
                      child: Column( // Text information column
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          /// Item Name
                          Text(
                            'ITEM_NAME',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                          ),
                          SizedBox(height: 5),
                          /// Item Expiration
                          Text(
                            'Expires: NULL',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Quantity: NO',
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
                          Text(customItem.calories),
                          const SizedBox(height: 15),
                          const Text('Carbs'),
                          Text(customItem.carbs),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text('Fat'),
                          Text(customItem.fat),
                          const SizedBox(height: 15),
                          const Text('Protein'),
                          Text(customItem.protein, textAlign: TextAlign.center),
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
