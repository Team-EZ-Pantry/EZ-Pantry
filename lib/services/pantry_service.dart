// services/pantry_service.dart
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../models/pantry_item_model.dart';
import '../utilities/session_controller.dart';

class PantryService {
  // for web
  final String baseUrl = 'http://localhost:3000/api';

  // for android emulator
  //final String baseUrl = 'http://10.0.2.2:3000/api/pantry';

  // run this when plugging an android phone into your pc for testing
  // C:\Users\(user)\AppData\Local\Android\Sdk\platform-tools\adb reverse tcp:3000 tcp:3000
  // or add adb to path then just run
  // adb reverse tcp:3000 tcp:3000

  Future<int> getPantryId() async {
    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await SessionController.instance.getAuthToken()}',
    };

    final http.Response response = await http.get(
      Uri.parse('$baseUrl/pantry/'),
      headers: headers,
    );

    debugPrint('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;

      final List<dynamic> pantries = data['pantries'] as List<dynamic>;
      if (pantries.isEmpty) {
        throw Exception('No pantries found for this user.');

      }

      final int pantryId = pantries[0]['pantry_id'] as int;
      debugPrint('Pantry ID: $pantryId ------------------------------------------------------');
      return pantryId;
    } else {
      throw Exception('Failed to fetch pantry ID: ${response.statusCode}');
    }
  }

  Future<List<PantryItemModel>> fetchPantryItems(int pantryId) async {

    final Map<String, String> header = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await SessionController.instance.getAuthToken()}',
    };

    debugPrint('Request headers: $header');

    final http.Response response = await http.get(
        Uri.parse('$baseUrl/pantry/$pantryId'),
        headers: header,
    );
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded = jsonDecode(response.body) as Map<String, dynamic>;

      final List<dynamic> products = decoded['pantry']['products'] as List<dynamic>;

      var newProducts = products
          .map((dynamic item) => PantryItemModel.fromJson(item as Map<String, dynamic>));

      return newProducts.toList();
    } else {
      debugPrint('Response body: ${response.body}');
      throw Exception('Failed to load pantry items');
    }
  }

  Future<void> addItem(int productId, int quantity, String expirationDate) async {

    final Map<String, String> header = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await SessionController.instance.getAuthToken()}',
    };

    final int pantryId = await getPantryId(); // async returns a String
    final Uri url = Uri.parse('$baseUrl/pantry/$pantryId/products/$productId');

    final http.Response response = await http.post(
      url,
      headers: header,
      body: jsonEncode(<String, Object>{
        'quantity': quantity,
        'expiration_date': expirationDate,
      }),
    );

    if(response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add item: ${response.body}');
    }
  }

  /// Add custom item to pantry
  /// * Returns ID if successful
  /// * Returns -1 if request is not sucessful
  Future<void> addCustomItem(int customProductId, int quantity, String? expirationDate) async {
    final int pantryId = await getPantryId(); // async returns a String
    final url = Uri.parse('$baseUrl/pantry/$pantryId/custom-products/$customProductId');

    final header = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await SessionController.instance.getAuthToken()}',
    };

    final http.Response response = await http.post(
      // Request URL
      url,
      headers: header,
      body: jsonEncode(<String, dynamic>{
        'quantity': quantity,
        'expirationDate': expirationDate,
      }),
    );

    if(response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add item: ${response.body}');
    } 

  }

  Future<void> deleteItem(int productId) async {
    final int pantryId = await getPantryId();
    final url = Uri.parse('$baseUrl/pantry/$pantryId/products/$productId');
    final header = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await SessionController.instance.getAuthToken()}',
    };

    final http.Response response = await http.delete(
      url,
      headers: header,
    );

    if(response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to delete item: ${response.body}');
    } 
  }

  Future<int> defineCustomItem(Map<String, dynamic> customItem) async {
    int newProductID = -1; // ID given upon failure

    debugPrint('DEFINE custom item==================');
    final Map<String, String> header = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await SessionController.instance.getAuthToken()}',
    };

    final http.Response response = await http.post(
      Uri.parse('$baseUrl/products/custom'),
      headers: header,
      body: jsonEncode(customItem)
    );

    if(response.statusCode != 200 && response.statusCode != 201) {
      debugPrint('Error Code: ${response.statusCode} ');
      throw Exception('Failed to defineCustomItem(): ${response.body}');
    } else {
      final Map<String, dynamic>decoded = jsonDecode(response.body) as Map<String, dynamic>;
      
      // Json property that contains new id
      final int? productIdFromJson = decoded['customProduct']?['custom_product_id'] as int;

      if (productIdFromJson != null) {
        newProductID = productIdFromJson;
      } else {
        debugPrint('Failed to get new custom_product_id, returning -1');
      }
    }

    return newProductID;
  }

  Future<void> updateExpirationDate(int productId, String expirationDate) async {
    final Map<String, String> header = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await SessionController.instance.getAuthToken()}',
    };

    final int pantryId = await getPantryId(); // async returns a String

    final Uri url = Uri.parse('$baseUrl/pantry/$pantryId/products/$productId/expiration');

      debugPrint(expirationDate);
      debugPrint(jsonEncode(<String, String> {
        'expirationDate': '$expirationDate',
      }));
    final http.Response response = await http.patch(
      url,
      headers: header,
      body: jsonEncode(<String, String> {
        'expirationDate': expirationDate,
      }),
    );

    if(response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to change expiration date: ${response.body}');
    }
  }

  Future<void> updateQuantity(int productId, int quantity) async {

    final Map<String, String> header = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await SessionController.instance.getAuthToken()}',
    };

    final int pantryId = await getPantryId();

    final Uri url = Uri.parse('$baseUrl/pantry/$pantryId/products/$productId/quantity');

    final String requestBody = jsonEncode(<String, Object> {
        'quantity' : '$quantity',
      });

    final http.Response response = await http.patch(
      url,
      headers: header,
      body: requestBody
    );

    if(response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to change quantity: ${response.body}');
    }
  }

  Future<void> createPantry(String pantryName) async {

    final Map<String, String> header = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await SessionController.instance.getAuthToken()}',
    };

    final Uri url = Uri.parse('$baseUrl/pantry/');

    final http.Response response = await http.post(
        url,
        headers: header,
        body: jsonEncode(<String, Object> {
          'name': pantryName,
        }),
    );

    if(response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create pantry: ${response.body}');
    }
  }

  Future<PantryItemModel> getItemByBarcode(String barcode) async {
    final Map<String, String> header = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await SessionController.instance.getAuthToken()}',
    };

    final Uri url = Uri.parse('$baseUrl/products/barcode/$barcode');

    final http.Response response = await http.get(
      url,
      headers: header,
    );

    if (response.statusCode == 200) {
      debugPrint('Response body: ${response.body}');

      // Decode JSON into a Map
      final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;

      // Access the 'product' part of the JSON
      final Map<String, dynamic> productJson = data['product'] as Map<String, dynamic>;

      // Use your model's fromJson constructor
      final PantryItemModel product = PantryItemModel.fromJson(productJson);
      debugPrint('Product: ${product.name}');
      return product;
    } else {
      debugPrint('Response body: ${response.body}');
      throw Exception('Failed to load pantry items');
    }
  }

}