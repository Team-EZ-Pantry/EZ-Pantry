import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../utilities/session_controller.dart';

Future<int> loginUser({
  required String email,
  required String password,

  /// Constants for status codes
  final int successfulLoginCode  = 200, /// API returned successful login
  final int badRequestCode       = 400, /// API returned bad request
  final int unauthorizedUserCode = 401, /// API returned user unauthorized
  final int serverErrorCode      = 500, /// API returned server error

        int loginCode            = -1,  /// if -1 then unexpected error, 0 if login succeeded

}) async {
  // for web
  final Uri requestUrl = Uri.parse('http://localhost:3000/api/auth/login');

  // for android emulator
  //final Uri requestUrl = Uri.parse('http://10.0.2.2:3000/api/auth/login');

  final Map<String, String> headers = <String, String>{
    'Content-Type': 'application/json',
  };

  final String body = jsonEncode(<String, String>{
    'email':    email,
    'password': password,
  });

  try {
    final http.Response response = await http.post(requestUrl, headers: headers, body: body);
    
    loginCode = response.statusCode;

    if (response.statusCode == successfulLoginCode) {
      // Success — parse response if needed
      loginCode = 0;
      // ignore: always_specify_types
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      /// Save the token securely
      SessionController.instance.setSession(data['token'] as String);

      debugPrint('AuthToken: $data');
      debugPrint('User Logged in: $data');
    } else {
      if (response.statusCode == badRequestCode && kDebugMode) {
        debugPrint('loginUser() Bad Request: ${response.body}');
      } else if (response.statusCode == unauthorizedUserCode) {
        debugPrint('loginUser() User Unauthorized: ${response.body}');
      } else if (response.statusCode == serverErrorCode) {
        debugPrint('loginUser() Server error: ${response.body}');
      } else {
        debugPrint('loginUser() Unexpected status code: ${response.statusCode}');
      }
    }
  } catch (e) {
    debugPrint('Exception occurred: $e');
  }
  return loginCode;
}
