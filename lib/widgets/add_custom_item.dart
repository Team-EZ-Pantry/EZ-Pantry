/// Adds custom items to pantry
/// * Has its own speed dial button
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
  Map<int, String?> errors = <int, String?>{}; // store error messages for each index(auto generated field)

  // Initialize Json Array
  // Will be body of final request
  Map<String, dynamic> _customItem = <String, dynamic>{};

  /// A list of optional fields that will dynamically render, this list contains:
  /// 1. Field Text title
  /// 2. corresponding key it stores values in.
  /// 3. The kind of type input should be(String, int)
  /// Does not yet properly handle token lists such as Nutrition Facts
  final List<List<String>> _extraFormFields = <List<String>>[
    <String>['Expiration Date', 'expirationDate', 'int'],
    <String>['Image URL', 'image_url', 'String'],
    <String>['Calories(per 100g)', 'calories_per_100g', 'int'],
    <String>['Protein(per 100g)', 'protein_per_100g', 'int'],
    <String>['Carbs(per 100g)', 'carbs_per_100g', 'int'],
    <String>['Fat(per 100g)', 'fat_per_100g', 'int'],
    // Nutrition facts not be handled completely
    <String>['Nutrition Facts', 'nutrition', 'Map<String, dynamic>'],
    <String>['Protein(per 100g)', 'protein_per_100g', 'int'],
    <String>['Protein(per 100g)', 'protein_per_100g', 'int'],
  ];

  bool _isSaving = false;

  @override
  void initState() {
    _nameController.text     = '';
    _quantityController.text = '0';
    super.initState();
  }

  @override
  /// Reset variables on widget close
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _customItem = <String, dynamic>{};  

    super.dispose();
  }

  /// Checks input, defines custom item, and creates number of items if specified
  Future<void> _onSave() async {
    int? newProductID;
    final int quantity = int.tryParse(_quantityController.text.trim()) ?? 0;
    final String? expirationDate = _customItem['expirationDate'] as String?;

    /// Check input
    if (_nameController.text == '') {
      return;
    }

    setState(() => _isSaving = true);

    /// Send data to create new item
    newProductID = await context.read<PantryProvider>().defineCustomItem(_customItem);

    // Create new item if quantity specified
    if (quantity > 0 && newProductID != -1 && mounted) {
      await context.read<PantryProvider>().addCustomItem(
        newProductID,
        quantity,
        expirationDate,
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

  /// Generate fields of a length starting at the index offset
  /// * Generates fields based on external variable _extraFormFields
  /// * Provides error messages back to errors[]
  List<Widget> generateFields(int length, int indexOffset) {
    // Note that length is subtracted by any index offset
    return List.generate(length - indexOffset, (int index) {
      index += indexOffset; // Skip fields before offset, start at index[0 + offset]
      return ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 150, maxWidth: 300),
        child: Padding(
          padding: const EdgeInsetsGeometry.only(right: 10, top: 10),
          child: TextFormField(
            keyboardType: _extraFormFields[index][2] == 'int'
                ? TextInputType.number
                : TextInputType.text,
            decoration: InputDecoration(
              labelText: _extraFormFields[index][0],
              errorText: errors[index],
            ), // error shows below field),
            onChanged: (String value) {
              setState(() {/// Allows error messages to be displayed
                /// Handle input based on type indicated in list
                final String fieldType = _extraFormFields[index][2];
              
                if (fieldType == 'int') {
                  /// Parse as integer
                  final int? parsedInt = int.tryParse(value);
                  if (parsedInt != null) {
                    _customItem[_extraFormFields[index][1]] = parsedInt; 
                    errors[index] = null; 
                  } else {
                    if (value != ''){
                      errors[index] = 'Please enter a valid number.';
                    } else {
                      errors[index] = null;
                    }
                    _customItem[_extraFormFields[index][1]] = 0;
                  }
                } else if (fieldType == 'String') {
                  /// Parse as String
                  _customItem[_extraFormFields[index][1]] = value;
                  errors[index] = null;
                } else if (fieldType == 'Map<String, dynamic>') {
                  /// Parse as String
                  _customItem[_extraFormFields[index][1]] = value as Map<String, dynamic>;
                  errors[index] = null;
                } else {
                  /// Type may be incorrect
                  debugPrint('_extraFormField[$index]: handling unkown type');
                  errors[index] = null;
                  _customItem[_extraFormFields[index][1]] = value;
                }
              });
            },
          ),
        ),
      );
    });
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
                    /// Product Name field
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 400,

                        /// Near maxLength width
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
                    Wrap(
                      // Displays first 2 items
                      // Starts at index 0
                      children: generateFields(2, 0),
                    ),

                    const Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 5, vertical: 15),
                      child: Text('Extra Nutrition Facts', style: TextStyle(fontSize: 18)),
                    ),

                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 250,
                        minHeight: 50,
                        minWidth: 100,
                      ),

                      /// Height of scrolling box
                      child: SingleChildScrollView(
                        // Generate the rest of extra form fields
                        child: Wrap(children: generateFields(_extraFormFields.length, 3)),
                      ),
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
