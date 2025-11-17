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

  Future<List<int>> getShoppingList() async {
    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await SessionController.instance.getAuthToken()}',
    };

    final http.Response response = await http.get(
      Uri.parse('$baseUrl/shopping-list/'),
      headers: headers,
    );

    debugPrint('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;

      final List<int> shoppingLists = data['shoppingLists'] as List<int>;
      if (shoppingLists.isEmpty) {
        throw Exception('No shopping lists found for this user.');

      }
      final List<int> listIds = shoppingLists.map<int>((int item) => data['shoppingLists']['shopping_list_id'] as int)
      .toList();

      debugPrint('Shopping List ID: $listIds ------------------------------------------------------');
      return listIds;
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
        Uri.parse('$baseUrl/shopping-list/$listId'),
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

  Future<void> deleteShoppingList(int listId) async{
    final Map<String, String> header = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await SessionController.instance.getAuthToken()}',
    };

    final int listId = await getShoppingList();
    final Uri url = Uri.parse('$baseUrl/shopping-list/$listId/');

    final http.Response response = await http.delete(
      url,
      headers: header,
    );

    if(response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to delete shopping list: ${response.body}');
    }
  }

  Future<void> addItem(int productId, int quantity, [String? itemText]) async {

    itemText ??= '';

    final Map<String, String> header = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await SessionController.instance.getAuthToken()}',
    };

    final int listId = await getShoppingList(); // async returns a String
    final Uri url = Uri.parse('$baseUrl/shopping-list/$listId/items/');

    final http.Response response = await http.post(
      url,
      headers: header,
      body: jsonEncode(<String, Object>{
        'productId': productId,
        'text': itemText,
        'quantity': quantity,
      }),
    );

    if(response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add item: ${response.body}');
    }
  }

  Future<void> addCustomItem(int customProductId, int quantity, [String? itemText]) async {

    itemText ??= '';

    final Map<String, String> header = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await SessionController.instance.getAuthToken()}',
    };

    final int listId = await getShoppingList(); // async returns a String
    final Uri url = Uri.parse('$baseUrl/shopping-list/$listId/items/');

    final http.Response response = await http.post(
      url,
      headers: header,
      body: jsonEncode(<String, Object>{
        'customProductId': customProductId,
        'text': itemText,
        'quantity': quantity,
      }),
    );

    if(response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add item: ${response.body}');
    }
  }

  Future<void> toggleItem(int productId) async{

    final Map<String, String> header = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await SessionController.instance.getAuthToken()}',
    };

    final int listId = await getShoppingList();
    final Uri url = Uri.parse('$baseUrl/shopping-list/$listId/items/$productId/toggle');

    final http.Response response = await http.patch(
      url,
      headers: header
    );

    if(response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to toggle item: ${response.body}');
    }
  }

  Future<void> deleteItem(int productId) async{

    final Map<String, String> header = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await SessionController.instance.getAuthToken()}',
    };

    final int listId = await getShoppingList();
    final Uri url = Uri.parse('$baseUrl/shopping-list/$listId/items/$productId');

    final http.Response response = await http.delete(
      url,
      headers: header
    );

    if(response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to toggle item: ${response.body}');
    }
  }

  Future<void> createShoppingList(String shoppingListName) async {

    final Map<String, String> header = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await SessionController.instance.getAuthToken()}',
    };

    final Uri url = Uri.parse('$baseUrl/shopping-list/');

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
