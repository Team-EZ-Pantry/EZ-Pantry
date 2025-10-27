// services/pantry_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pantry_item.dart';
import '../utilities/session_controller.dart';

class PantryService {
  // for web
  final String baseUrl = 'http://localhost:3000/api/pantry';

  // for android emulator
  //final String baseUrl = 'http://10.0.2.2:3000/api/pantry';

  Future<int> getPantryId() async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await SessionController.instance.getAuthToken()}',
    };

    final response = await http.get(
      Uri.parse('$baseUrl/'),
      headers: headers,
    );

    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;

      final List<dynamic> pantries = data['pantries'] as List<dynamic>;
      if (pantries.isEmpty) {
        throw Exception('No pantries found for this user.');

      }

      final int pantryId = pantries[0]['pantry_id'] as int;
      print('Pantry ID: $pantryId ------------------------------------------------------');
      return pantryId;
    } else {
      throw Exception('Failed to fetch pantry ID: ${response.statusCode}');
    }
  }

  Future<List<PantryItemModel>> fetchPantryItems(int pantryId) async {

    final header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await SessionController.instance.getAuthToken()}',
    };

    print('Request headers: $header');

    final response = await http.get(
        Uri.parse('$baseUrl/$pantryId'),
        headers: header,
    );

    if (response.statusCode == 200) {
     print('Response body: ${response.body}');

      final Map<String, dynamic> decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> products = decoded['pantry']['products'] as List<dynamic>;

      return products
          .map((dynamic item) => PantryItemModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load pantry items');
    }
  }

  Future<void> addItem(PantryItemModel item) async {

    final header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await SessionController.instance.getAuthToken()}',
    };

    final pantryId = await getPantryId(); // async returns a String
    final url = Uri.parse('$baseUrl/$pantryId/products');

    final response = await http.post(
      url,
      headers: header,
      body: jsonEncode(<String, Object>{
        'productId': item.id,
        'quantity': item.quantity,
        'expiration_date': ?item.expirationDate,
      }),
    );

    if(response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add item: ${response.body}');
    }
  }

  Future<void> updateItem({
    int? productId,
    int? quantity,
    String? expirationDate,
  }) async {
    final header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await SessionController.instance.getAuthToken()}',
    };

    final pantryId = await getPantryId(); // async returns a String

    final url = Uri.parse('$baseUrl/$pantryId/products/$productId');

    final Map<String, Object> body = {};

    if (quantity != null) body['quantity'] = quantity;
    if (expirationDate != null)  body['expirationDate'] = expirationDate;

    final response = await http.put(
      url,
      headers: header,
      body: jsonEncode(body),
    );

    if(response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to change item details: ${response.body}');
    }
  }

  Future<void> updateQuantity(int productId, int quantity) async {

    final header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await SessionController.instance.getAuthToken()}',
    };

    final pantryId = await getPantryId(); // async returns a String

    final url = Uri.parse('$baseUrl/$pantryId/products/$productId/quantity');

    final response = await http.put(
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

  Future<void> createPantry(String pantryName) async {

    final header = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await SessionController.instance.getAuthToken()}',
    };

    final url = Uri.parse('$baseUrl/');

    final response = await http.post(
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
}
