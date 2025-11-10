// providers/pantry_provider.dart
import 'package:flutter/material.dart';
import '../models/pantry_item_model.dart';
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
      final int pantryId = await _service.getPantryId();
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

      debugPrint('✅ Added item: productID: $productId, quantity: $quantity');
    } catch (e) {
      debugPrint('❌ Error adding pantry item: $e');
      rethrow; // optional: let UI handle error display
    }
  }

  Future<void> updateExpirationDate(int productId, String expirationDate) async {
    try {
      await _service.updateExpirationDate(productId, expirationDate);
      notifyListeners();

      debugPrint('Updated expiration of $productId to $expirationDate');
    } catch(e) {
      debugPrint('Error updating expiration: $e');
    }
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    try {
      await _service.updateQuantity(productId, quantity);
      notifyListeners();

      debugPrint('Updated quantity of $productId to $quantity');
    } catch(e) {
      debugPrint('Error updating quantity: $e');
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

  Future<PantryItemModel?> getItemByBarcode(String barcode) async {
    try {
      final PantryItemModel product = await _service.getItemByBarcode(barcode);
      return product;
    } catch (e) {
      debugPrint('Error getting item by barcode: $e');
      return null;
    }
  }
}
