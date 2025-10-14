// services/pantry_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pantry_item.dart';
import '../utilities/session_controller.dart';

class PantryService {
  final String baseUrl = 'http://localhost:3000/api/pantry';


  Future<int> getPantryId() async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await SessionController().getAuthToken()}',
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
      // Access pantry_id
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
      'Authorization': 'Bearer ${await SessionController().getAuthToken()}',
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
      'Authorization': 'Bearer ${await SessionController().getAuthToken()}',
    };

    final url = Uri.parse('$baseUrl/$getPantryId()/products');

    final response = await http.post(
      url,
      headers: header,
      body: jsonEncode(<String, Object>{
        'productId': item.id,
        'quantity': item.quantity,
        'expiration_date': item.expirationDate,
      }),
    );

    if(response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add item: ${response.body}');
    }
  }
}
