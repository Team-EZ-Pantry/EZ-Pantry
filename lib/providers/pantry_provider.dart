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

  Future<bool> loadPantryItems() async {
    _loading = true;
    notifyListeners();

    try {
      final pantryId = await _service.getPantryId();
      debugPrint('Fetched pantry id: $pantryId in provider');
      _items = await _service.fetchPantryItems(pantryId);
      debugPrint('Fetched items: $_items');
      return true; // Pantry loaded successfully
    } catch (e) {
      debugPrint('Error fetching pantry items: $e');
      return false; // Pantry not found or some other failure
    } finally {
      _loading = false;
      notifyListeners();
    }
  }


  Future<void> addItem(int productId, int quantity, String expirationDate) async {
    try {

      // Save to backend
      await _service.addItem(productId, quantity, expirationDate);
      loadPantryItems();
      notifyListeners();

      print('✅ Added item: productID: $productId, quantity: $quantity');
    } catch (e) {
      print('❌ Error adding pantry item: $e');
      rethrow; // optional: let UI handle error display
    }
  }

  Future<void> updateExpirationDate(int productId, String expirationDate) async {
    try {
      await _service.updateExpirationDate(productId, expirationDate);
      notifyListeners();

      print('Updated expiration of $productId to $expirationDate');
    } catch(e) {
      print('Error updating expiration: $e');
    }
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    try {
      await _service.updateQuantity(productId, quantity);
      notifyListeners();

      print('Updated quantity of $productId to $quantity');
    } catch(e) {
      print('Error updating quantity: $e');
      }
    }

    void removeItemAt(int index) {
      items.removeAt(index);
      notifyListeners();
    }

  Future<void> createPantry(String pantryName) async {
    try {
      await _service.createPantry(pantryName);
    } catch (e) {
      debugPrint('Error creating pantry: $e');
    }
  }
}


