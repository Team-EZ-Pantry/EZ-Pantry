// services/pantry_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pantry_item.dart';

class PantryService {
  final String baseUrl = 'http://localhost:3000/api';

  Future<List<PantryItemModel>> fetchPantryItems() async {
    final response = await http.get(Uri.parse('$baseUrl/pantry'));

    if (response.statusCode == 200) {
      print('Response body: ${response.body}');

      // Decode JSON into a List<dynamic>
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;

      // Cast each element to Map<String, dynamic>
      return data
          .map((dynamic item) => PantryItemModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception("Failed to load pantry items");
    }
  }
}
