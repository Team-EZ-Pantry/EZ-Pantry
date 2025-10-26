//*********************************//
// Get search results from backend //
//*********************************//

/// Dart imports
import 'dart:convert';
import 'package:flutter/foundation.dart';

/// External packages
import 'package:http/http.dart' as http;

/// Internal imports
import '../models/pantry_item.dart';
import '../utilities/session_controller.dart';


/// Variables
int    searchLimit = 10; // number of results to return

String searchQuery = 'beef'; // to be set when searching
String baseUrl     = 'http://localhost:3000/api/products/search?';

Map<String, dynamic> decodedJson   = <String, dynamic>{};

List<dynamic>        foundProducts = <dynamic>[];

Future<List<PantryItemModel>> searchAllItems(String searchQuery) async {
    final Map<String, String> header = <String, String>{
      'Content-Type':  'application/json',
      'Authorization': 'Bearer ${await SessionController.instance.getAuthToken()}',
    };

    debugPrint('Search Started');

  final http.Response response = await http.get(
        Uri.parse('$baseUrl/q=$searchQuery&limit=$searchLimit'),
        headers: header,
    );
    
    debugPrint('Search Response');

    if (response.statusCode == 200) {
     debugPrint('Response body: ${response.body}');

      decodedJson   = jsonDecode(response.body)    as Map<String, dynamic>;
      foundProducts = decodedJson['foundProducts'] as List<dynamic>;

      return foundProducts
          .map((dynamic item) => PantryItemModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('searchPantryItems(): Failed to load items. Code: ${response.statusCode}');
    }
  }
