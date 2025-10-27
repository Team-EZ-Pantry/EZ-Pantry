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

String baseUrl     = 'http://localhost:3000/api/searchResults/search?';

Map<String, dynamic> decodedJson   = <String, dynamic>{};

List<dynamic>        foundsearchResults = List<dynamic>.empty();

Future<List<dynamic>> searchAllItems(String searchQuery) async {
    final Map<String, String> header = <String, String>{
      'Content-Type':  'application/json',
      'Authorization': 'Bearer ${await SessionController.instance.getAuthToken()}',
    };

    debugPrint('Search Started');

  final http.Response response = await http.get(
        Uri.parse(baseUrl + 'q=$searchQuery&limit=$searchLimit'),
        headers: header,
    );

    if (response.statusCode == 200) {
      /// Request successful
      debugPrint('Response body: ${response.body}');

      final Map<String, dynamic> decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> searchResults = decoded['products'] as List<dynamic>;

      return searchResults
          .map((dynamic item) => PantryItemModel.fromJson(item as Map<String, dynamic>))
          .toList();

    } else {
      debugPrint('URL: ' + baseUrl + 'q=$searchQuery&limit=$searchLimit');
      debugPrint(response.body);
      debugPrint(header.entries.toString());
      throw Exception('searchAllItems(): Failed to load items. Code: ${response.statusCode}');
    }
  }
