import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../models/pantry_item_model.dart';
import '../providers/pantry_provider.dart';
import 'package:provider/provider.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final MobileScannerController _controller = MobileScannerController();
  bool _isDialogShowing = false;

  Future<void> _handleBarcode(String barcode) async {
    if (_isDialogShowing) return; // Prevent multiple dialogs
    _isDialogShowing = true;

    final pantryProvider = context.read<PantryProvider>();

    try {
      final PantryItemModel? pantryItem = await pantryProvider.getItemByBarcode(barcode);
/*
      if (pantryItem == null) {
        // Item not found
        await showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            title: Text('Item Not Found'),
            content: Text('No product found for this barcode.'),
          ),
        );
        _isDialogShowing = false;
        _controller.start();
        return;
      }*/
      debugPrint('Scanning barcode: $barcode');
      await _barcodeDialog(context, barcode, pantryItem!, pantryProvider);
    } catch (e) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to handle barcode: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }

    _isDialogShowing = false;
    _controller.start(); // Resume scanning
  }

  Future<void> _barcodeDialog(
      BuildContext context,
      String barcode,
      PantryItemModel pantryItem,
      PantryProvider pantryProvider,
      ) async {
    final quantityController = TextEditingController();
    final expirationController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Barcode Found'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Code: $barcode'),
            Text('Product: ${pantryItem.name}'),
            const SizedBox(height: 10),
            Ink.image(
              image: NetworkImage(
                'https://images.openfoodfacts.org/images/products/004/180/050/1694/front_en.11.400.jpg',
              ),
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantity',
                hintText: 'Enter quantity',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: expirationController,
              decoration: const InputDecoration(
                labelText: 'Expiration Date (optional)',
                hintText: 'YYYY-MM-DD',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cancel
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final quantityText = quantityController.text.trim();
              final expirationDate = expirationController.text.trim();

              if (quantityText.isEmpty) return; // Require quantity
              final int quantity = int.tryParse(quantityText) ?? 1;
              await pantryProvider.addItem(
                pantryItem.id,
                quantity,
                expirationDate,
              );

              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Barcode')),
      body: MobileScanner(
        controller: _controller,
        onDetect: (BarcodeCapture capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            final String? code = barcode.rawValue;
            if (code != null && !_isDialogShowing) {
              _controller.stop(); // Pause scanning
              _handleBarcode(code);
              debugPrint('Barcode found: $code');
            }
          }
        },
      ),
    );
  }
}

