import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/pantry_provider.dart';
import '../providers/search_provider.dart';
import '../utilities/debouncer.dart';
import 'positioned_search_box.dart';

/// Intialize
dynamic searchResults      = '';
int     selectedProductID  = -1;
String selectedProductType = '';

/// Constants
const String customProductKey = 'custom_product';

class AddItemDialog extends StatefulWidget {
  const AddItemDialog({
    super.key,
    required this.title,
    this.hintText = '',
    this.itemName = '',
    this.itemQuantity = 0,
    this.itemExpirationDate = '',
  });

  final String title;
  final String hintText;
  final String itemName;
  final int itemQuantity;
  final String itemExpirationDate;

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _productNameController    = TextEditingController();
  final TextEditingController _quantityController       = TextEditingController();
  final TextEditingController _expirationDateController = TextEditingController();

  // Link product name field and search overlay
  final LayerLink productName = LayerLink(); 

  bool _isSaving = false;

  final Duration debounceDuration = const Duration(
    milliseconds: 600,
  ); // time(milliseconds) to wait before searching
  Timer? debounce;

  @override
  void dispose() {
    _productNameController.dispose();
    _quantityController.dispose();
    _expirationDateController.dispose();
    searchResults = ''; 
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final int selectedProductId = selectedProductID;
    final int quantity = int.tryParse(_quantityController.text.trim()) ?? 0;
    final String expirationDate = _expirationDateController.text.trim();

    setState(() => _isSaving = true);

    // Add custom item if type matches, regular item if it does not
    if (selectedProductType == customProductKey) {
      await context.read<PantryProvider>().addCustomItem(
        selectedProductId,
        quantity,
        expirationDate,
      ); // example userId = 2
    } else {
      await context.read<PantryProvider>().addItem(
        selectedProductId,
        quantity,
        expirationDate,
      ); // example userId = 2
    }
    setState(() => _isSaving = false);
    if (mounted) {
      Navigator.of(context).pop(); // close dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AlertDialog(
          contentPadding: const EdgeInsets.all(12),
          title: Text(widget.title),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CompositedTransformTarget(
                  link: productName,
                  child: TextFormField(
                    controller: _productNameController,
                    autofocus: true,
                    decoration: const InputDecoration(hintText: 'Product name'),
                    validator: (String? value) =>
                        (value == null || value.trim().isEmpty) ? 'Please enter a product name' : null,
                    onChanged: (String value) {
                      if (_productNameController.text.length > 1) {
                        Debouncer(delay: debounceDuration).run(() async {
                          /// Get new results
                          searchResults = await searchAllProducts(_productNameController.text);

                          // Show widget changes from search results
                          setState(() {});
                        },);
                      }
                    },
                  ),
                ),
                
                TextFormField(
                  controller: _quantityController,
                  autofocus: true,
                  decoration: const InputDecoration(hintText: 'Quantity'),
                  validator: (String? v) =>
                      (v == null || v.trim().isEmpty) ? 'Please enter product quantity' : null,
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

          actions: <Widget>[
            TextButton(
              onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _isSaving ? null : _onSave,
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

        /// Show search
        SearchResultsOverlay(
          layerLink:      productName,
          searchResults:  searchResults,
          onItemSelected: (dynamic selectedItem) {
            // Handle selected item
            selectedProductID           = selectedItem['id'] as int;
            _productNameController.text = selectedItem['product_name'].toString();
            selectedProductType         = selectedItem['product_type'].toString();

            // Clear search results
            setState(() {
              searchResults = '';
            });
          },
        ),
      ],
    );
  }
}
