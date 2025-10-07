import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

Future<bool> registerUser({
  required String username,
  required String email,
  required String password,

  bool registrationSuccess = false,

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

    if (response.statusCode == 201) {
      // Success — parse response if needed
      registrationSuccess = true;
      final data = jsonDecode(response.body);
      debugPrint('User registered: $data');
    } else {
      if (response.statusCode == 400) {
        debugPrint('Bad Request: ${response.body}');
      } else if (response.statusCode == 409) {
        debugPrint('User already exists: ${response.body}');
      } else if (response.statusCode == 500) {
        debugPrint('Server error: ${response.body}');
      } else {
        debugPrint('Unexpected status code: ${response.statusCode}');
      }
    }
  } catch (e) {
    debugPrint('Exception occurred: $e');
  }

  return registrationSuccess;
}
