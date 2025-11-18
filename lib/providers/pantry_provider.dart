// providers/pantry_provider.dart
import 'package:flutter/material.dart';
import '../models/pantry_item_model.dart';
import '../models/pantry_model.dart';
import '../services/pantry_service.dart';

class PantryProvider extends ChangeNotifier {
  final PantryService _service = PantryService();

  List<PantryModel> _pantries = <PantryModel>[];
  List<PantryModel> get pantries => _pantries;

  List<PantryItemModel> _items = <PantryItemModel>[];
  List<PantryItemModel> get items => _items;

  bool _loading = false;

  bool get loading => _loading;

  void init() {
    // schedule after first frame to avoid calling notifyListeners during build
    // By default loads the most recently created pantry
    Future.microtask(() => loadPantryItems(pantries[0].pantryId));
  }

  Future<bool> loadPantries() async {
    _loading = true;
    notifyListeners();

    try {
      _pantries = await _service.getShoppingLists();
      debugPrint('Fetched pantry: $_pantries');
      return true; // pantries loaded successfully
    } catch (e) {
      debugPrint('Error fetching pantry: $e');
      return false; // pantries not found or some other failure
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> loadPantryItems(int pantryId) async {
    _loading = true;
    notifyListeners();

    try {
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


  Future<void> addItem(int pantryId, int productId, int quantity, String expirationDate) async {
    try {

      // Save to backend
      await _service.addItem(pantryId, productId, quantity, expirationDate);
      loadPantryItems(pantryId);
      notifyListeners();

      debugPrint('✅ Added item: productID: $productId, quantity: $quantity');
    } catch (e) {
      debugPrint('❌ Error adding pantry item: $e');
      rethrow; // optional: let UI handle error display
    }
  }

  Future<void> updateExpirationDate(int pantryId, int productId, String expirationDate) async {
    try {
      await _service.updateExpirationDate(pantryId, productId, expirationDate);
      notifyListeners();

      debugPrint('Updated expiration of $productId to $expirationDate');
    } catch(e) {
      debugPrint('Error updating expiration: $e');
    }
  }

  Future<void> updateQuantity(int pantryId, int productId, int quantity) async {
    try {
      await _service.updateQuantity(pantryId, productId, quantity);
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
