// providers/pantry_provider.dart
import 'package:flutter/material.dart';
import '../models/pantry_item_model.dart';
import '../services/shopping_service.dart';

class ShoppingProvider extends ChangeNotifier {
  final ShoppingService _service = ShoppingService();

  List<PantryItemModel> _items = <PantryItemModel>[];
  List<PantryItemModel> get items => _items;

  bool _loading = false;

  bool get loading => _loading;

  void init() {
    // schedule after first frame to avoid calling notifyListeners during build
    Future.microtask(() => loadShoppingListItems());
  }

  Future<bool> loadShoppingListItems() async {
    _loading = true;
    notifyListeners();

    

    try {
      final int listId = await _service.getShoppingList();
      debugPrint('Fetched shopping list id: $listId in provider');
      _items = await _service.fetchShoppingListItems(listId);
      debugPrint('Fetched items: $_items');
      return true; // Pantry loaded successfully
    } catch (e) {
      debugPrint('Error fetching shopping list items: $e');
      return false; // Pantry not found or some other failure
    } finally {
      _loading = false;
      notifyListeners();
    }
  }


  Future<void> addItem(int productId, int quantity) async {
    try {

      // Save to backend
      await _service.addItem(productId, quantity);
      loadShoppingListItems();
      notifyListeners();

      debugPrint('✅ Added item: productID: $productId, quantity: $quantity');
    } catch (e) {
      debugPrint('❌ Error adding item to shopping list: $e');
      rethrow; // optional: let UI handle error display
    }
  }

  /*
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
    */

  Future<void> createShoppingList(String shoppingListName) async {
    try {
      await _service.createShoppingList(shoppingListName);
    } catch (e) {
      debugPrint('Error creating shopping list: $e');
    }
  }
}
