import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

Future<int> registerUser({
  required String username,
  required String email,
  required String password,

  int registrationSuccess = -1, /// if -1 then unexpected error, 0 if success

  int badRequestCode = 400,
  int userConflictCode = 409, 
  int serverErrorCode = 500,
  

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
    registrationSuccess = response.statusCode;

    if (response.statusCode == 201) {
      // Success — parse response if needed
      registrationSuccess = 0;
      final data = jsonDecode(response.body);
      debugPrint('User registered: $data');
    } else {
      if (response.statusCode == badRequestCode) {
        debugPrint('$badRequestCode Bad Request: ${response.body}');
      } else if (response.statusCode == userConflictCode) {
        debugPrint('$userConflictCode User already exists: ${response.body}');
      } else if (response.statusCode == serverErrorCode) {
        debugPrint('$serverErrorCode Server error: ${response.body}');
      } else {
        debugPrint('Unexpected status code: ${response.statusCode}');
      }
    }
  } catch (e) {
    debugPrint('Exception occurred: $e');
  }

  return registrationSuccess;
}
