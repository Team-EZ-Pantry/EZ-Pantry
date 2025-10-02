// services/pantry_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pantry_item.dart';

class PantryService {
  final String baseUrl = "http://localhost:3000";

  Future<List<PantryItemModel>> fetchPantryItems() async {
    final response = await http.get(Uri.parse("$baseUrl/pantry"));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => PantryItemModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load pantry items");
    }
  }
}
