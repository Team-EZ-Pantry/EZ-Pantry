//*********************************//
// Get search results from backend //
//*********************************//

/// Dart imports
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';

/// External packages
import 'package:http/http.dart' as http;

/// Internal imports
import '../utilities/session_controller.dart';

/// Constants
const int searchLimit           = 10;                          // Number of results returned
const String baseUrl            = 'http://localhost:3000';     // Server URL
const Duration debounceDuration = Duration(milliseconds: 600); // time to wait before searching

/// Variables
Timer? _debounce;

/// Returns true when a timer is up
bool debounceTimer() {
  bool canStart = false;
  
  /// Stops previous timers
  if (_debounce != null) {
    _debounce!.cancel();
  }

  _debounce = Timer(debounceDuration, () {
    canStart = true;
  },);

  return canStart;
}

/// Search API for all products.
/// Returns empty string if input is not valid.
Future<dynamic> searchAllProducts(String searchQuery) async {
  /// Check input
  if (searchQuery.length < 2) {
    /// API does not accept short queries
    debugPrint('Invalid search query.');
    return '';
  }

  /// Validate input
  searchQuery.trim();

  /// Prepare request
  debugPrint('Search Query Set');                   

  final Map<String, String> header = <String, String>{
    'Content-Type':  'application/json',
    'Authorization': 'Bearer ${await SessionController.instance.getAuthToken()}',
  };

  /// Start Request
  debugPrint('Search Started, URL: ${baseUrl}q=$searchQuery&limit=$searchLimit');

  final http.Response response = await http.get(
    Uri.parse('$baseUrl/api/products/search?q=$searchQuery&limit=$searchLimit'),
    headers: header,
  );

  /// Handle Request
  if (response.statusCode == 200) {
    /// Success
    debugPrint('Search Results: ${response.body}');
    return jsonDecode(response.body);        

  } else {
    debugPrint(response.body);
    debugPrint(header.entries.toString());
    throw Exception('searchAllProducts(): Failed to load items. Code: ${response.statusCode}');
  }
}
