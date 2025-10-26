import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

import '../providers/pantry_provider.dart';
import '../widgets/add_item.dart';
import '../widgets/new_pantry_prompt.dart';
import '../widgets/pantry_item.dart';
import '../widgets/edit_item.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final pantryProvider = context.read<PantryProvider>();

      final loaded = await pantryProvider.loadPantryItems();

      if (!loaded) {
        String? pantryName;

        // Keep showing the dialog until user enters a name
        while (pantryName == null || pantryName.isEmpty) {
          pantryName = await showDialog<String>(
            context: context,
            barrierDismissible: false,
            builder: (context) => const NewPantryPrompt(),
          );

          if (pantryName == null || pantryName.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('You must create a pantry to continue.')),
            );
          }
        }

        await pantryProvider.createPantry(pantryName);
        await pantryProvider.loadPantryItems();
      }
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

  Future<void> _onItemTapped() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => EditItemDialog(title: 'Enter item', hintText: 'hintText'),
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
                      title: item.name,
                      quantity: item.quantity,
                      incrementQuantity: () {
                        item.quantity++;
                        pantry.updateQuantity(item.id, item.quantity);
                      },
                      decrementQuantity: () {
                        if(item.quantity > 0) {
                          item.quantity--;
                          pantry.updateQuantity(item.id, item.quantity);
                        }
                      },
                      changeQuantity: (int newQuantity) {
                        if(newQuantity >= 0) {
                          item.quantity = newQuantity;
                          pantry.updateQuantity(item.id, item.quantity);
                        }
                      },
                      onTap: () => _onItemTapped(),
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
