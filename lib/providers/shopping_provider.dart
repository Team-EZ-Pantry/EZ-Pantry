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
    // By default loads the most recently created shopping list
    Future.microtask(() => loadShoppingListItems(0));
  }

  Future<void> createShoppingList(String shoppingListName) async {
    try {
      await _service.createShoppingList(shoppingListName);
    } catch (e) {
      debugPrint('Error creating shopping list: $e');
    }
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
}
