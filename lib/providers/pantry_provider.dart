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

  Future<void> loadPantryItems() async {
    _loading = true;
    notifyListeners();

    try {
      _items = await _service.fetchPantryItems();
      print('========================Fetched items: $_items');
    } catch (e) {
      print('Error fetching pantry items: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}

