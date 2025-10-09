import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<int> registerUser({
  required String username,
  required String email,
  required String password,

        int registrationCode    = -1,  /// if -1 then unexpected error, 0 if registration succeeded
  final int badRequestCode      = 400, /// API returned bad request
  final int userConflictCode    = 409, /// API returned user already exists
  final int serverErrorCode     = 500, /// API returned server error

}) async {
  final Uri requestUrl = Uri.parse('http://localhost:3000/api/auth/register');

  final Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  final String body = jsonEncode({
    'username': username,
    'email':    email,
    'password': password,
  });

  try {
    final http.Response response = await http.post(requestUrl, headers: headers, body: body);
    registrationCode = response.statusCode;

    if (response.statusCode == 201) {
      // Success — parse response if needed
      registrationCode = 0;
      final data = jsonDecode(response.body);
      debugPrint('User registered: $data');

    } else {
      if (response.statusCode == badRequestCode && kDebugMode) {
        debugPrint('registerUser() Bad Request: ${response.body}');
      } else if (response.statusCode == userConflictCode) {
        debugPrint('regeisterUser() User already exists: ${response.body}');
      } else if (response.statusCode == serverErrorCode) {
        debugPrint('registerUser() Server error: ${response.body}');
      } else {
        debugPrint('registerUser() Unexpected status code: ${response.statusCode}');
      }
    }
  } catch (e) {
    debugPrint('Exception occurred: $e');
  }
  return registrationCode;
}
