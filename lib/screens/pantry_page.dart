import 'package:flutter/material.dart';
import 'login_page.dart'; // Import the login page
import 'package:ez_pantry/screens/scan_page.dart';
import 'package:ez_pantry/widgets/pantry_item.dart';

class PantryPage extends StatelessWidget {
  const PantryPage({super.key});

  void _onScanButtonPressed(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ScanPage()),
    );

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Scanned barcode: $result')),
      );
      print('Scanned barcode: $result');
      // TODO: Call API or update pantry items with this barcode
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content of the Pantry page
          Material(
            child: PantryItemTile(title: 'food')
          ),

          // Login button positioned at the top right
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              icon: const Icon(
                Icons.account_circle_outlined,
                size: 32, // Adjust size as needed
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _onScanButtonPressed(context),
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('Scan'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
