// providers/shopping_provider.dart
import 'package:flutter/material.dart';
import '../models/shopping_list_item_model.dart';
import '../models/shopping_list_model.dart';
import '../services/shopping_service.dart';

class ShoppingProvider extends ChangeNotifier {
  final ShoppingService _service = ShoppingService();

  List<ShoppingListModel> _lists = <ShoppingListModel>[];
  List<ShoppingListModel> get lists => _lists;

  List<ShoppingListItemModel> _items = <ShoppingListItemModel>[];
  List<ShoppingListItemModel> get items => _items;

  bool _loading = false;

  bool get loading => _loading;

  void init() {
    // schedule after first frame to avoid calling notifyListeners during build
    // Load all shopping lists initially
    Future.microtask(() => loadShoppingLists());
    // By default loads the most recently created shopping list (or the list at index 0)
    Future.microtask(() => loadShoppingListItems(_lists[0].listId));
  }

  Future<bool> loadShoppingLists() async {
    _loading = true;
    notifyListeners();

    try {
      _lists = await _service.getShoppingLists();
      debugPrint('Fetched shopping lists: $_lists');
      return true; // Shopping lists loaded successfully
    } catch (e) {
      debugPrint('Error fetching shopping lists: $e');
      return false; // Shopping lists not found or some other failure
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> loadShoppingListItems(int listId) async {
    _loading = true;
    notifyListeners();
    try {
      debugPrint('Fetched shopping list id: $listId in provider');
      _items = await _service.fetchShoppingListItems(listId);
      debugPrint('Fetched items: $_items');
      return true; // Shopping list items loaded successfully
    } catch (e) {
      debugPrint('Error fetching shopping list items: $e');
      return false; // Shopping list items not found or some other failure
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> createShoppingList(String shoppingListName) async {
    try {
      await _service.createShoppingList(shoppingListName);
    } catch (e) {
      debugPrint('Error creating shopping list: $e');
    }
  }

  Future<void> deleteShoppingList(int listId) async {
    try {
      await _service.deleteShoppingList(listId);
      loadShoppingLists();
      notifyListeners();

      debugPrint('✅ Deleted shopping list: listID: $listId');
    } catch (e) {
      debugPrint('❌ Error deleting shopping list: $e');
      rethrow; // optional: let UI handle error display
    }
  }

  Future<void> addItem(int listId, int productId, int quantity, [String? itemText]) async {
    try {

      // Save to backend
      await _service.addItem(listId, productId, quantity, itemText);
      loadShoppingListItems(listId);
      notifyListeners();

      debugPrint('✅ Added item: productID: $productId, quantity: $quantity');
    } catch (e) {
      debugPrint('❌ Error adding item to shopping list: $e');
      rethrow; // optional: let UI handle error display
    }
  }

  Future<void> addCustomItem(int listId, int customProductId, int quantity, [String? itemText]) async {
    try {

      // Save to backend
      await _service.addCustomItem(listId, customProductId, quantity, itemText);
      loadShoppingListItems(listId);
      notifyListeners();

      debugPrint('✅ Added custom item: $itemText');
    } catch (e) {
      debugPrint('❌ Error adding custom item to shopping list: $e');
      rethrow; // optional: let UI handle error display
    }
  }

  Future<void> toggleItem(int listId, int productId) async {
    try {
      await _service.toggleItem(listId, productId);
      loadShoppingListItems(listId);
      notifyListeners();

      debugPrint('Toggled item: productID: $productId');
    } catch (e) {
      debugPrint('Error toggling item in shopping list: $e');
    }
  }

  Future<void> deleteItem(int listId, int productId) async {
    try {
      await _service.deleteItem(listId, productId);
      loadShoppingListItems(listId);
      notifyListeners();

      debugPrint('✅ Deleted item: productID: $productId');
    } catch (e) {
      debugPrint('❌ Error deleting item from shopping list: $e');
      rethrow; // optional: let UI handle error display
    }
  }
}
