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

  /// Add a custom product
  Future<void> addCustomItem(int productId, int quantity, String? expirationDate) async {
    try {
      // Save to backend
      await _service.addCustomItem(productId, quantity, expirationDate);
      loadPantryItems();
      notifyListeners();

      debugPrint('Added custom item: productID: $productId, quantity: $quantity');
    } catch (e) {
      debugPrint('addCustomItem() Error: $e');
      rethrow; // optional: let UI handle error display
    }
  }

  /// Send details of a user's custom product
  /// * Returns custom_product_id or -1
  Future<int> defineCustomItem(Map<String, dynamic> customItem) async {
    int newProductID;
    try {
      newProductID = await _service.defineCustomItem(customItem);

      loadPantryItems();
      notifyListeners();

      debugPrint('Defined Custom Item: $customItem');
    } catch (e) {
      debugPrint('defineCustomItem() Error: $e');
      rethrow; // optional: let UI handle error display
    }
    return newProductID;
  }

  /*Future<void> updateQuantity(int productId, int quantity) async {
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
    }*/

  // Handle both regular and custom products
  Future<void> updateQuantity(PantryItemModel item, int quantity) async {
    try {
      if (item.productType == 'custom_product') {
        await _service.updateCustomQuantity(item.id, quantity);
      } else {
        await _service.updateQuantity(item.id, quantity);
      }
      
      item.quantity = quantity; // Update local model
      notifyListeners();
    } catch(e) {
      debugPrint('Error updating quantity: $e');
    }
  }

  Future<void> updateExpirationDate(PantryItemModel item, String expirationDate) async {
    try {
      if (item.productType == 'custom_product') {
        await _service.updateCustomExpirationDate(item.id, expirationDate);
      } else {
        await _service.updateExpirationDate(item.id, expirationDate);
      }

      //item.expirationDate = expirationDate; // Update local model
      notifyListeners();
    } catch(e) {
      debugPrint('Error updating expiration: $e');
    }
  }

  // Delete a product
  Future<void> deleteItem(PantryItemModel item) async {
    try {
      if( item.productType == 'custom_product') {
        await _service.deleteCustomItem(item.id);
      } else {
        await _service.deleteItem(item.id);
      }

      loadPantryItems();
      notifyListeners();
      debugPrint('✅ Deleted item: productID: $item.id');
    } catch (e) {
      debugPrint('❌ Error deleting pantry item: $e');
      rethrow; // optional: let UI handle error display
    }
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
