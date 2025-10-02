import 'package:flutter/material.dart';
import 'login_page.dart'; // Import the login page
import 'package:ez_pantry/screens/scan_page.dart';
import 'package:ez_pantry/widgets/pantry_item.dart';
import 'package:provider/provider.dart';
import '../providers/pantry_provider.dart';

class PantryPage extends StatefulWidget {
  const PantryPage({super.key});

  @override
  State<PantryPage> createState() => _PantryPageState();
}

class _PantryPageState extends State<PantryPage> {
  @override
  void initState() {
    super.initState();
    // Safe to call provider here
    final pantryProvider = context.read<PantryProvider>();
    pantryProvider.loadPantryItems();
  }

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
          Material(
            child: Consumer<PantryProvider>(
              builder: (context, pantry, child) {
                if (pantry.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (pantry.items.isEmpty) {
                  return const Center(child: Text("Empty Pantry"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  itemCount: pantry.items.length,
                  itemBuilder: (context, index) {
                    final item = pantry.items[index];
                    return PantryItemTile(
                      title: item.title, // or item.title depending on your model
                    );
                  },
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
