/// Adds custom items to pantry
library;

/// Core Packages
import 'package:flutter/material.dart';

/// Dependencies
import 'package:provider/provider.dart';

/// Internal Imports
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
  final TextEditingController _nameController = TextEditingController();

  /// A list containing 
  /// 1. Field Text title 
  /// 2. corresponding key it stores values in.
  final Map<String, String> _formFields = <String, String>{
    'Product Name':       'product_name',
    'Quantity':           'quantity',
    'Expiration Date':    'expiration_date',
    'Image URL':          'image_url',
    'Calories(per 100g)': 'calories_per_100g',
    'Protien(per 100g)':  'protein_per_100g',
    'Carbs(per 100g)':    'carbs_per_100g',
    'Fat(per 100g)':      'fat_per_100g',
    'Nutrition Facts':    'nutrition',
  };

  final Map<String, dynamic> _customItem = <String, dynamic>{};

  bool _isSaving = false;

  @override
  void initState() {
    _nameController.text = '';

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();

    super.dispose();
  }

  /// Checks input and saves item if all forms are valid
  Future<void> _onSave() async {
    /// Check inputs
    // if (!(_formKey.currentState?.validate() ?? false)) {
    //   debugPrint('Form validation failed.');
    //   return;
    // }

    setState(() => _isSaving = true);

    /// Send data to create new item
    await context.read<PantryProvider>().defineCustomItem(_customItem);

    
    
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
                    Wrap( 
                      children: <Widget>[
                      SizedBox(
                        width: 230,
                        /// Product Name field
                        child: TextFormField(
                          maxLength: 30,
                          controller: _nameController,
                          decoration: InputDecoration(labelText: _formFields.entries.elementAt(0).key),
                          onChanged: (String value) {
                            // Update _customItem values with a key specified by the values of _formFields 
                            _customItem[_formFields.entries.elementAt(2).value] = value;
                          }
                        ),
                      ),

                      const SizedBox(width:70),

                      /// 
                      SizedBox( 
                        width: 80,
                        /// Quantity field
                        child: TextFormField(
                          decoration: InputDecoration(labelText: _formFields.entries.elementAt(1).key),
                          onChanged: (String value) {
                            if (value as int > 0) {
                              _customItem[_formFields.entries.elementAt(1).value] = value;
                            } else {
                              _customItem[_formFields.entries.elementAt(1).value] = 0;
                            }
                          }
                        ),)
                    ]
                  ),

                    Wrap( 
                      children: _formFields.entries.skip(2).take(3).map<Widget>((MapEntry<String, String> entry) {
                        return TextFormField(
                          maxLength: 20,
                          decoration: InputDecoration(labelText: entry.key),
                          onChanged: (String value) {
                            // Update _customItem values with a key specified by the values of _formFields 
                            _customItem[entry.value] = value;
                          },
                        );
                      }).toList(),
                    ),

                    const Text('Nutrition Facts', style: TextStyle(fontSize: 18)),
                    // Generate all possible fields from pantry model
                    Wrap( 
                      children: _formFields.entries.skip(5).take(4).map<Widget>((MapEntry<String, String> entry) {
                        return SizedBox(
                          width: 150,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              maxLength: 20,
                              decoration: InputDecoration(labelText: entry.key),
                              onChanged: (String value) {
                                // Update the _customItem with the new value
                                _customItem[entry.value] = value;
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
                        final bool nameIsValid = _customItem['product_name'] != '' 
                                              && _customItem['product_name'] != null;
                        if(!_isSaving) {
                          if (nameIsValid) {
                            debugPrint('SAVING STARTED');
                            _onSave();
                          } else {
                            if (!nameIsValid) {
                              AlertDialog(
                                  title:   const Text('Missing Name'),
                                  content: const Text('Please enter a name.'),
                                  actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: const Text('OK'),
                                      ),
                                    ],
                              );
                            } else {
                              
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
