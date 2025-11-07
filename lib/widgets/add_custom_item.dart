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

  PantryItemModel customItem =  PantryItemModel(
    id: -1, name: '', quantity: 0, nutritionFacts: Map.identity(), createdAt: DateTime.now()
  );

   late Map<String, TextEditingController> formControllers;

  bool _isSaving = false;

  @override
  void initState() {
    /// Create a from controller for each member of the model
    formControllers = customItem.toJson().map(
      (String key, dynamic value) => MapEntry(key, TextEditingController(text: value.toString())),
    );

    super.initState();
  }

  @override
  void dispose() {
    for (final TextEditingController controller in formControllers.values) {
      controller.dispose();
    }

    super.dispose();
  }

  /// Checks input and saves item if all forms are valid
  Future<void> _onSave() async {
    /// Check inputs
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final int     quantity       = int.tryParse(_quantityController.text.trim()) ?? customItem.quantity;
    final String? expirationDate = _expirationDateController.text.trim().isEmpty
        ? null
        : _expirationDateController.text.trim();

    setState(() => _isSaving = true);

    /// Send data to create new item
    await context.read<PantryProvider>().addCustomItem(customItem);
    
    /// Reload pantry view
    if (mounted) {
      await context.read<PantryProvider>().loadPantryItems();
    }
    
    setState(() => _isSaving = false);

    /// Close Dialog
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
        child: Center(
          child: Column( // Overall Column
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[ 
              const Text('Add Custom Item', style: TextStyle(fontSize: 18)),
              Center( 
                child: Column(
                  children: <Widget>[
                    /// Create Product name and quantity
                    Wrap( 
                      children: formControllers.entries.skip(1).take(2).map<Widget>((MapEntry<String, TextEditingController> entry) {
                        return TextFormField(
                          maxLength: 20,
                          controller: entry.value,
                          decoration: InputDecoration(labelText: entry.key),
                          onChanged: (String value) {
                            // Update the customItem with the new value
                            customItem.toJson()[entry.key] = value;
                          },
                        );
                      }).toList(),
                    ),
                    
                    Wrap( 
                      children: formControllers.entries.skip(4).take(1).map<Widget>((MapEntry<String, TextEditingController> entry) {
                        return TextFormField(
                          maxLength: 20,
                          controller: entry.value,
                          decoration: InputDecoration(labelText: entry.key),
                          onChanged: (String value) {
                            // Update the customItem with the new value
                            customItem.toJson()[entry.key] = value;
                          },
                        );
                      }).toList(),
                    ),

                    const Text('Nutrition Facts', style: TextStyle(fontSize: 18)),
                    // Generate all possible fields from pantry model
                    Wrap( 
                      children: formControllers.entries.skip(5).take(4).map<Widget>((MapEntry<String, TextEditingController> entry) {
                        return SizedBox(
                          width: 190,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              maxLength: 20,
                              controller: entry.value,
                              decoration: InputDecoration(labelText: entry.key),
                              onChanged: (String value) {
                                // Update the customItem with the new value
                                customItem.toJson()[entry.key] = value;
                              },
                            ),
                          )
                        );
                      }).toList(),
                    ),
                  ],
                ),
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
                          if (value != null && value >= 0 && customItem.name == '') {
                            _onSave();
                          } else {
                            if (customItem.name == '') {
                              AlertDialog(
                                  title:   const Text('Invalid Name'),
                                  content: const Text('Name is not valid.'),
                                  actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: const Text('OK'),
                                      ),
                                    ],
                              );
                            } else {
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
      ),
    );
  }
}
