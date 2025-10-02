// providers/pantry_provider.dart
import 'package:flutter/material.dart';
import '../models/pantry_item.dart';
import '../services/pantry_service.dart';

class PantryProvider extends ChangeNotifier {
  final PantryService _service = PantryService();

  List<PantryItemModel> _items = [];
  List<PantryItemModel> get items => _items;

  bool _loading = false;
  bool get loading => _loading;

  Future<void> loadPantryItems() async {
    _items = await _service.fetchPantryItems();
    notifyListeners(); // tells widgets to rebuild

    try {
      _items = await _service.fetchPantryItems();
    } catch (e) {
     // _error = e.toString();            // store error
    } finally {
      _loading = false;
      notifyListeners();                // tells UI: loading finished (success or fail)
    }
  }
}
