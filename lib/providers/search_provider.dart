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

String baseUrl     = 'http://localhost:3000/api/products/search?';

Future<dynamic> searchAllItems(String searchQuery) async {
    final Map<String, String> header = <String, String>{
      'Content-Type':  'application/json',
      'Authorization': 'Bearer ${await SessionController.instance.getAuthToken()}',
    };

    debugPrint('Search Started, URL: ' + baseUrl + 'q=$searchQuery&limit=$searchLimit');

  final http.Response response = await http.get(
        Uri.parse(baseUrl + 'q=$searchQuery&limit=$searchLimit'),
        headers: header,
    );

    if (response.statusCode == 200) {
      /// Request successful
      debugPrint('Response body: ${response.body}');

      final searchResults = jsonDecode(response.body);
      debugPrint('==================');

      print(searchResults.runtimeType);

      return searchResults;    
          
    } else {
      debugPrint('URL: ' + baseUrl + 'q=$searchQuery&limit=$searchLimit');
      debugPrint(response.body);
      debugPrint(header.entries.toString());
      if (searchQuery.isEmpty)
      {
        return '';
      }
      throw Exception('searchAllItems(): Failed to load items. Code: ${response.statusCode}');
    }
  }
