import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanPage extends StatelessWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Barcode')),
      body: MobileScanner(
        onDetect: (BarcodeCapture capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            if (barcode.rawValue != null) {
              final String code = barcode.rawValue!;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Barcode found: $code')),
              );
              debugPrint('Barcode found: $code');

              // TODO(all): Call your API to fetch product info
            }
          }
        },
      ),
    );
  }
}
