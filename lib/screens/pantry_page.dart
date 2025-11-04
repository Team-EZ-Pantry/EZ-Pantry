/// Screen where user pantry items are seen and edited
library;

/// Core Packages
import 'package:flutter/material.dart';

/// Dependencies
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

/// Internal Imports
import '../models/pantry_item_model.dart';
import '../providers/pantry_provider.dart';
import '../widgets/add_item.dart';
import '../widgets/edit_item.dart';
import '../widgets/new_pantry_prompt.dart';
import '../widgets/pantry_item.dart';
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
      final PantryProvider pantryProvider = context.read<PantryProvider>();

      final bool loaded = await pantryProvider.loadPantryItems();

      if (!loaded) {
        String? pantryName;

        // Keep showing the dialog until user enters a name
        
        while (pantryName == null || pantryName.isEmpty) {
          if (mounted) {
            pantryName = await showDialog<String>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => const NewPantryPrompt(),
            );
          }

          if (mounted && (pantryName == null || pantryName.isEmpty)) {
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
      ///(TODO): Call API or update pantry items with this barcode
    }
  }

  Future<void> _onAddItemButtonPressed() async {
    final String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => const AddItemDialog(title: 'Enter item', hintText: 'hintText'),
    );

    if (result == null) {
      return;
    }
  }

  Future<void> _onItemTapped(PantryItemModel item) async {
    final String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => EditItemDialog(item: item),
    );
    if (result == null) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Material(
            child: Consumer<PantryProvider>(
              builder: (BuildContext context, PantryProvider pantry, Widget? child) {
                if (pantry.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (pantry.items.isEmpty) {
                  return const Center(child: Text('Empty Pantry'));
                }

                return ListView.builder(
                  itemCount: pantry.items.length,
                  itemBuilder: (BuildContext context, int index) {
                    final PantryItemModel item = pantry.items[index];
                    return PantryItemTile(
                      onTap: () => _onItemTapped(item),
                      item: item,
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
        children: <SpeedDialChild>[
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
