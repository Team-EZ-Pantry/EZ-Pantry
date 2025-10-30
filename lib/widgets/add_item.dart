import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pantry_item.dart';
import '../providers/pantry_provider.dart';
import '../providers/search_provider.dart';

dynamic searchResults  = '';
dynamic pendingResults = '';

class AddItemDialog extends StatefulWidget{
  
  AddItemDialog({Key? key, required this.title, this.hintText = '', this.itemName = '', this.itemQuantity = 0, this.itemExpirationDate = ''}) : super(key: key);

  final String title;
  final String hintText;
        String itemName;
        String itemExpirationDate;
  
        int itemQuantity;

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final _formKey = GlobalKey<FormState>();

  final _productNameController    = TextEditingController();
  final _quantityController       = TextEditingController();
  final _expirationDateController = TextEditingController();

  bool  _isSaving                 = false;

  final int debounceTime = 500; // time(milliseconds) to wait before searching

  @override
  void dispose() {
    _productNameController.dispose();
    _quantityController.dispose();
    _expirationDateController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final productId = int.parse(_productNameController.text.trim());
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
      content:  Stack( children: [ 
        Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _productNameController,
                autofocus: true,
                decoration: const InputDecoration(hintText: 'Product name'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter product number' : null,
                onChanged: (String value) {
                  if (_productNameController.text.length > 1) {
                    /// Create search dialog to select product from list
                    Timer (Duration(milliseconds: debounceTime), () async {
                      /// Get first search results
                      debugPrint('Search Query Set');
                      
                      _productNameController.text.trim();
                      
                      // Hold changes to be set in new state
                      pendingResults = await searchAllItems(_productNameController.text);  

                      setState(() {  
                        // Makes add item dialog show the changes from search results
                        searchResults = pendingResults; 
                      },);

                      },  
                    );
                  }
                  else
                  {
                    setState(() {
                      searchResults = '';  // Clear search boxes of previous data
                    });
                  }
                },
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
        
        // --- Overlay List for searchResults ---
          if (searchResults != '') 
            Positioned(
              left: 0,
              right: 0,
              top: 55, // Adjust to sit below TextFormField
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 150),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: searchResults['count'] as int,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(searchResults['products'][index]['product_name'] as String),
                        onTap: () {
                          setState(() {
                            searchResults = '';
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
        
      ] 
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