import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../utilities/session_controller.dart';

Future<int> registerUser({
  required String username,
  required String email,
  required String password,

  /// Constants for status codes
  final int successfulRegistrationCode = 201, /// API returned successful login
  final int badRequestCode             = 400, /// API returned bad request
  final int userConflictCode           = 409, /// API returned user already exists
  final int serverErrorCode            = 500, /// API returned server error

        int registrationCode           = -1,  /// if -1 then unexpected error, 0 if registration succeeded

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

    if (response.statusCode == successfulRegistrationCode) {
      // Success — parse response if needed
      registrationCode = 0;
      final data = jsonDecode(response.body);

      /// Save the token securely
      final SessionController sessionController = SessionController();
      sessionController.saveAuthToken(data['token'] as String);
      debugPrint('saveAuthToken: $data["token"]');

      debugPrint('User registered: $data');

    } else {
      if (response.statusCode == badRequestCode && kDebugMode) {
        debugPrint('registerUser() Bad Request: ${response.body}');
      } else if (response.statusCode == userConflictCode) {
        debugPrint('registerUser() User already exists: ${response.body}');
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
