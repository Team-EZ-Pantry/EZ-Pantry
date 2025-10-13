// providers/pantry_provider.dart
import 'package:flutter/material.dart';
import '../models/pantry_item.dart';
import '../services/pantry_service.dart';

class PantryProvider extends ChangeNotifier {
  final PantryService _service = PantryService();

  List<PantryItemModel> _items = <PantryItemModel>[];

  List<PantryItemModel> get items => _items;

  bool _loading = false;

  bool get loading => _loading;

  void init() {
    // schedule after first frame to avoid calling notifyListeners during build
    Future.microtask(() => loadPantryItems());
  }

  Future<void> loadPantryItems() async {
    _loading = true;
    notifyListeners();

    try {
      _items = await _service.fetchPantryItems();
      debugPrint('========================Fetched items: $_items');
    } catch (e) {
      debugPrint('Error fetching pantry items: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> addItem(String name, int quantity, int userId) async {
    try {
      final PantryItemModel newItem = PantryItemModel(
        id: userId,
        name: name,
        quantity: quantity,
      );

      // Save to backend
      await _service.addItem(newItem);

      // Update local state immediately
      _items.add(newItem);
      notifyListeners();

      print('✅ Added item: ${newItem.name} (${newItem.quantity})');
    } catch (e) {
      print('❌ Error adding pantry item: $e');
      rethrow; // optional: let UI handle error display
    }
  }
}

