/// Adds custom items to pantry
/// * Also called by barcode scanner service
library;

/// Core Packages
import 'package:flutter/material.dart';

/// Dependencies
import 'package:provider/provider.dart';

/// Internal Imports
import '../providers/pantry_provider.dart';

class AddCustomItemDialog extends StatefulWidget {
  /// Constructor
  const AddCustomItemDialog({super.key});

  @override
  State<AddCustomItemDialog> createState() => _AddCustomItemDialogState();
}

class _AddCustomItemDialogState extends State<AddCustomItemDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  // Initialize Json Array
  // Will be body of final request
  final Map<String, dynamic> _customItem = <String, dynamic>{};

  /// A list of optional fields that will dynamically render, this list contains:
  /// 1. Field Text title
  /// 2. corresponding key it stores values in.
  /// 3. The kind of type input should be(String, int)
  /// Does not yet properly handle token lists such as Nutrition Facts
  final List<List<String>> _extraFormFields = <List<String>>[
    <String>['Expiration Date', 'expiration_date', 'int'],
    <String>['Image URL', 'image_url', 'String'],
    <String>['Calories(per 100g)', 'calories_per_100g', 'int'],
    <String>['Protein(per 100g)', 'protein_per_100g', 'int'],
    <String>['Carbs(per 100g)', 'carbs_per_100g', 'int'],
    <String>['Fat(per 100g)', 'fat_per_100g', 'int'],
    <String>['Nutrition Facts', 'nutrition', 'Map<String, dynamic>'],
    <String>['Protein(per 100g)', 'protein_per_100g', 'int'],
    <String>['Protein(per 100g)', 'protein_per_100g', 'int'],
    <String>['Protein(per 100g)', 'protein_per_100g', 'int'],
    <String>['Protein(per 100g)', 'protein_per_100g', 'int'],
    <String>['Protein(per 100g)', 'protein_per_100g', 'int'],
    <String>['Protein(per 100g)', 'protein_per_100g', 'int'],
    <String>['Protein(per 100g)', 'protein_per_100g', 'int'],
  ];

  bool _isSaving = false;

  @override
  void initState() {
    _nameController.text = '';
    _quantityController.text = '0';

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  /// Checks input and saves item if all forms are valid
  Future<void> _onSave() async {
    int? newProductID;
    final int quantity = int.tryParse(_quantityController.text.trim()) ?? 0;

    /// Check input
    if (_nameController.text == '') {
      return;
    }

    setState(() => _isSaving = true);

    /// Send data to create new item
    newProductID = await context.read<PantryProvider>().defineCustomItem(_customItem);

    if (quantity > 0 && newProductID != -1 && mounted) {
      await context.read<PantryProvider>().addCustomItem(
        newProductID,
        quantity,
        _customItem['expirationDate'] as String,
      );
    }

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
      insetPadding: const EdgeInsets.all(30),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Add Custom Item', style: TextStyle(fontSize: 18)),

              const SizedBox(height: 10),

              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 400,

                        /// Near where character limit is at
                      ),
                      child: TextFormField(
                        maxLength: 30,
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Product Name*'),
                        onChanged: (String value) {
                          _customItem['product_name'] = value;
                        },
                      ),
                    ),

                    /// Quantity field
                    SizedBox(
                      width: 80,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _quantityController,

                        /// Input is parsed at onSave(), used to determine if item should added after being defined
                        decoration: const InputDecoration(labelText: 'Quantity'),
                      ),
                    ),

                    /// Create first few form fields
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Wrap(
                          // Displays first 3 items
                          children: List.generate(2, (int index) {
                            return ConstrainedBox(
                              constraints: const BoxConstraints(minWidth: 150, maxWidth: 300),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  keyboardType: _extraFormFields[index][2] == 'int'
                                      ? TextInputType.number
                                      : TextInputType.text,
                                  decoration: InputDecoration(
                                    labelText: _extraFormFields[index][0],
                                  ),
                                  onChanged: (String value) {
                                    /// Handle input based on type indicated in list
                                    if (_extraFormFields[index][2] == 'int') {
                                      /// Parse as integer
                                      _customItem[_extraFormFields[index][1]] =
                                          int.tryParse(value) ?? 0;
                                    } else if (_extraFormFields[index][2] == 'String') {
                                      /// Parse as String
                                      _customItem[_extraFormFields[index][1]] = value;
                                    } else if (_extraFormFields[index][2] ==
                                        'Map<String, dynamic>') {
                                      /// Parse as String
                                      _customItem[_extraFormFields[index][1]] =
                                          value as Map<String, dynamic>;
                                    } else {
                                      /// Type may be incorrect
                                      debugPrint('_extraFormField[$index]: handling unkown type');
                                      _customItem[_extraFormFields[index][1]] = value;
                                    }
                                  },
                                ),
                              ),
                            );
                          }),
                        ),

                        const Padding(
                          padding: EdgeInsetsGeometry.symmetric(horizontal: 5, vertical: 15),
                          child: Text('Extra Nutrition Facts', style: TextStyle(fontSize: 18)),
                        ),

                        ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 250,
                            minHeight: 50,
                            maxWidth: 300,
                            minWidth: 100,
                          ),

                          /// Height of scrolling box
                          child: SingleChildScrollView(
                            // Generate the rest of extra form fields
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // Note that length is subtracted by any index offset
                              children: List.generate(_extraFormFields.length - 2, (int index) {
                                index += 2; // Skip first 3 fields, start at index[0 + offset]
                                return ConstrainedBox(
                                  constraints: const BoxConstraints(minWidth: 150, maxWidth: 250),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      keyboardType: _extraFormFields[index][2] == 'int'
                                          ? TextInputType
                                                .number // if True
                                          : TextInputType.text, // if False
                                      decoration: InputDecoration(
                                        labelText: _extraFormFields[index][0],
                                      ),
                                      onChanged: (String value) {
                                        /// Handle input based on type indicated in list
                                        if (_extraFormFields[index][2] == 'int') {
                                          /// Parse as integer
                                          _customItem[_extraFormFields[index][1]] =
                                              int.tryParse(value) ?? 0;
                                        } else if (_extraFormFields[index][2] == 'String') {
                                          /// Parse as String
                                          _customItem[_extraFormFields[index][1]] = value;
                                        } else if (_extraFormFields[index][2] ==
                                            'Map<String, dynamic>') {
                                          /// Parse as String
                                          _customItem[_extraFormFields[index][1]] =
                                              value as Map<String, dynamic>;
                                        } else {
                                          /// Type may be incorrect
                                          debugPrint(
                                            '_extraFormField[$index]: handling unkown type',
                                          );
                                          _customItem[_extraFormFields[index][1]] = value;
                                        }
                                      },
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      ],
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
                        if (_nameController.text != '') {
                          _onSave();
                        } else {
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Name Empty'),
                              content: const Text('Please enter a name.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
