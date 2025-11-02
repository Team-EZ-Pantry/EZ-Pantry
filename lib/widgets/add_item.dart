import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/pantry_item.dart';
import '../providers/pantry_provider.dart';
import '../providers/search_provider.dart';
import '../utilities/debouncer.dart';
import 'positioned_search_box.dart';

dynamic searchResults = '';

/// Intialize search

class AddItemDialog extends StatefulWidget {
  AddItemDialog({
    Key? key,
    required this.title,
    this.hintText = '',
    this.itemName = '',
    this.itemQuantity = 0,
    this.itemExpirationDate = '',
  }) : super(key: key);

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

  final _productNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _expirationDateController = TextEditingController();

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
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final productId = int.parse(_productNameController.text.trim());
    final quantity = int.tryParse(_quantityController.text.trim()) ?? 0;
    final expirationDate = _expirationDateController.text.trim();

    setState(() => _isSaving = true);

    // Send directly to the provider
    await context.read<PantryProvider>().addItem(
      productId,
      quantity,
      expirationDate,
    ); // example userId = 2

    setState(() => _isSaving = false);

    Navigator.of(context).pop(); // close dialog
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AlertDialog(
          contentPadding: EdgeInsets.all(12),
          title: Text(widget.title),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _productNameController,
                  autofocus: true,
                  decoration: const InputDecoration(hintText: 'Product name'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Please enter product number' : null,
                  onChanged: (String value) {
                    if (_productNameController.text.length > 1) {
                      Debouncer(delay: debounceDuration).run(() async {
                        /// Get new results
                        searchResults = await searchAllProducts(_productNameController.text);

                        // Show widget changes from search results
                        setState(() {});
                      });
                    }
                  },
                ),

                TextFormField(
                  controller: _quantityController,
                  autofocus: true,
                  decoration: const InputDecoration(hintText: 'Quantity'),
                  validator: (v) =>
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

          actions: [
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
        // --- Overlay List for searchResults ---
        SearchResultsOverlay(
          searchResults: searchResults,
          onItemSelected: (String selectedItemID) {
            // Handle selected item
            _productNameController.text = selectedItemID;

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
