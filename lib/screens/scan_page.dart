import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
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

  void _handleBarcode(String code) async {
    if (_isDialogShowing) return; // Prevent multiple dialogs
    _isDialogShowing = true;

    final pantryProvider = context.read<PantryProvider>();

    final quantityController = TextEditingController();
    final expirationController = TextEditingController();

    try {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Barcode Found'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Code: $code'),       // fetch object and display somewhere around here
              const SizedBox(height: 10),
              Ink.image(
                image: NetworkImage('https://images.openfoodfacts.org/images/products/004/180/050/1694/front_en.11.400.jpg'),
                width: 100,   // desired width
                height: 100,  // desired height
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


                final product = await pantryProvider.getItemByBarcode(code);

                await pantryProvider.addItem(product.id, quantity, expirationDate);

                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        ),
      );
    } catch (e) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to add item: $e'),
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
          }
      ),
    );
  }
}