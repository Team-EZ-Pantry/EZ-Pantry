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
import '../widgets/add_custom_item.dart';
import '../widgets/add_item.dart';
import '../widgets/edit_item.dart';
import '../widgets/new_pantry_prompt.dart';
import '../widgets/pantry_item.dart';
import 'scan_page.dart';

// TEMPORARY FIX access to pantry service to check for existing pantry
import '../services/pantry_service.dart';

class PantryPage extends StatefulWidget {
  const PantryPage({super.key});

  @override
  State<PantryPage> createState() => _PantryPageState();
}

class _PantryPageState extends State<PantryPage> {
  
  // TEMPORARY FIX access to pantry service to check for existing pantry
  final PantryService _service = PantryService();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final PantryProvider pantryProvider = context.read<PantryProvider>();

      // TEMPORARY FIX to stop the alert from popping up when we already have a pantry
      // First, check if user already has a pantry
      try {
        final int pantryId = await _service.getPantryId();
        debugPrint('User already has pantry ID: $pantryId');
        
        // If we got a pantry ID, load items
        await pantryProvider.loadPantryItems();
        return; // Exit - user has pantry
      } catch (e) {
        debugPrint('No pantry found or error: $e');
        // Continue to create new pantry
      }

      // Only show dialog if no pantry exists
      String? pantryName;

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

  Future<void> _onCustomItemButtonPressed() async {
    final String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => const AddCustomItemDialog(),
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
            color: Colors.grey[300],
            child: Consumer<PantryProvider>(
              builder: (BuildContext context, PantryProvider pantry, Widget? child) {
                if (pantry.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (pantry.items.isEmpty) {
                  return const Center(child: Text('Empty Pantry'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: pantry.items.length,
                  itemBuilder: (BuildContext context, int index) {
                    final PantryItemModel item = pantry.items[index];
                    
                    return PantryItemTile(
                      onTap: () => _onItemTapped(item),
                      item: item,
                      incrementQuantity: () {
                        final int newQuantity = item.quantity + 1;
                        item.quantity = newQuantity; // Update UI immediately
                        pantry.updateQuantity(item, newQuantity); // Pass the item
                      },
                      decrementQuantity: () {
                        if (item.quantity > 0) {
                          final int newQuantity = item.quantity - 1;
                          item.quantity = newQuantity; // Update UI immediately
                          pantry.updateQuantity(item, newQuantity); // Pass the item
                        }
                      },
                      changeQuantity: (int newQuantity) {
                        if (newQuantity >= 0) {
                          item.quantity = newQuantity; // Update UI immediately
                          pantry.updateQuantity(item, newQuantity); // Pass the item
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
        buttonSize: const Size(70, 70),
        childrenButtonSize: const Size (70, 70),
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
          SpeedDialChild(
            child: const Icon(Icons.new_label),
            label: 'Custom Item',
            onTap: () => _onCustomItemButtonPressed(),
          ),
        ],
      ),
    );
  }
}
