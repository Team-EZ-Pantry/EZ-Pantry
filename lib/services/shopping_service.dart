// services/pantry_service.dart
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../models/pantry_item_model.dart';
import '../utilities/session_controller.dart';

class ShoppingService {
  // for web
  final String baseUrl = 'http://localhost:3000/api';

  // for android emulator
  //final String baseUrl = 'http://10.0.2.2:3000/api/shoppingList';

  // run this when plugging an android phone into your pc for testing
  // C:\Users\(user)\AppData\Local\Android\Sdk\platform-tools\adb reverse tcp:3000 tcp:3000
  // or add adb to path then just run
  // adb reverse tcp:3000 tcp:3000

  Future<int> getShoppingListId() async {
    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await SessionController.instance.getAuthToken()}',
    };

    final http.Response response = await http.get(
      Uri.parse('$baseUrl/shoppingList/'),
      headers: headers,
    );

    debugPrint('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;

      final List<dynamic> shoppingLists = data['shoppingLists'] as List<dynamic>;
      if (shoppingLists.isEmpty) {
        throw Exception('No shopping lists found for this user.');

      }

      final int listId = shoppingLists[0]['shopping_list_id'] as int;
      debugPrint('Shopping List ID: $listId ------------------------------------------------------');
      return listId;
    } else {
      throw Exception('Failed to fetch shopping list ID: ${response.statusCode}');
    }
  }

  Future<List<PantryItemModel>> fetchShoppingListItems(int listId) async {

    final Map<String, String> header = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await SessionController.instance.getAuthToken()}',
    };

    debugPrint('Request headers: $header');

    final http.Response response = await http.get(
        Uri.parse('$baseUrl/shoppingList/$listId'),
        headers: header,
    );

    if (response.statusCode == 200) {
     debugPrint('Response body: ${response.body}');

      final Map<String, dynamic> decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> products = decoded['shoppingList']['products'] as List<dynamic>;

      return products
          .map((dynamic item) => PantryItemModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load shopping list items');
    }
  }

  Future<void> addItem(int productId, int quantity) async {

    final Map<String, String> header = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await SessionController.instance.getAuthToken()}',
    };

    final int listId = await getShoppingListId(); // async returns a String
    final Uri url = Uri.parse('$baseUrl/shoppingList/$listId/products');

    final http.Response response = await http.post(
      url,
      headers: header,
      body: jsonEncode(<String, Object>{
        'productId': productId,
        'quantity': quantity,
      }),
    );

    if(response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add item: ${response.body}');
    }
  }

  /*
  Future<void> updateQuantity(int productId, int quantity) async {

    final Map<String, String> header = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await SessionController.instance.getAuthToken()}',
    };

    final int listId = await getShoppingListId();

    final Uri url = Uri.parse('$baseUrl/shoppingList/$listId/products/$productId/quantity');

    final http.Response response = await http.put(
      url,
      headers: header,
      body: jsonEncode(<String, Object> {
        'quantity': quantity,
      }),
    );

    if(response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to change quantity: ${response.body}');
    }
  }
  */

  Future<void> createShoppingList(String shoppingListName) async {

    final Map<String, String> header = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await SessionController.instance.getAuthToken()}',
    };

    final Uri url = Uri.parse('$baseUrl/');

    final http.Response response = await http.post(
        url,
        headers: header,
        body: jsonEncode(<String, Object> {
          'name': shoppingListName,
        }),
    );

    if(response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create shopping list: ${response.body}');
    }
  }
}
