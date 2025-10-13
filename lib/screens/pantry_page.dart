import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import '../widgets/pantry_item.dart';
import '../providers/pantry_provider.dart';
import '../widgets/add_item.dart';
import 'add-item_page.dart';
import 'scan_page.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pantryProvider = context.read<PantryProvider>();
      pantryProvider.loadPantryItems();
    });
  }

  Future<void> _onScanButtonPressed(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => const ScanPage()),
    );

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Scanned barcode: $result')),
      );
      debugPrint('Scanned barcode: $result');
      // TODO: Call API or update pantry items with this barcode
    }
  }

  Future<void> _onAddItemButtonPressed() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AddItemDialog(title: 'Enter item', hintText: 'hintText'),
    );
    if (result == null) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Material(
            child: Consumer<PantryProvider>(
              builder: (BuildContext context, pantry, child) {
                if (pantry.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (pantry.items.isEmpty) {
                  return const Center(child: Text('Empty Pantry'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  itemCount: pantry.items.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = pantry.items[index];
                    return PantryItemTile(
                      title: item.name, // or item.title depending on your model
                      quantity: item.quantity,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: Colors.blue,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.qr_code_scanner),
            label: 'Scan Item',
            onTap: () => _onScanButtonPressed(context),
          ),
          SpeedDialChild(
            child: const Icon(Icons.menu),
            label: 'Add Item',
            onTap: () => _onAddItemButtonPressed(),
          ),
        ],
      ),
    );
  }
}
