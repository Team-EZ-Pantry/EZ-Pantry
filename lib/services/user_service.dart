import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class UserService {
  final String baseUrl = 'http://localhost:3000/api'; 

  Future<String> register(String username, String email, String password) async {
    final http.Response response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: { 'Content-Type': 'application/json' },
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      debugPrint('Registration successful');
      final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['token'] as String;
    } else {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Registration failed');
    }
  }

  Future<String> login(String email, String password) async {
    final http.Response response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: { 'Content-Type': 'application/json' },
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['token'] as String; 
    } else {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Login failed');
    }
  }

  Future<User> getMe(String token) async {
    final http.Response response = await http.get(
      Uri.parse('$baseUrl/user/me'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
      return User.fromJson(data['user'] as Map<String, dynamic>);
    } else {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Failed to get user profile');
    }
  }

  Future<User> updateUsername(String token, String newUsername) async {
    final http.Response response = await http.patch(
      Uri.parse('$baseUrl/user/username'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'username': newUsername}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> userData = json.decode(response.body) as Map<String, dynamic>;
      return User.fromJson(userData['user'] as Map<String, dynamic>);
    } else {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Failed to update username');
    }
  }

  Future<void> updatePassword(String token, String password, String newPassword) async {
    final http.Response response = await http.patch(
      Uri.parse('$baseUrl/user/password'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'password': password,
        'newPassword': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      debugPrint('Password changed successfully');
      return;
    } else {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Failed to update password');
    }
  }

  Future<void> deleteAccount(String token, String password) async {
    final http.Response response = await http.delete(
      Uri.parse('$baseUrl/user/me'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'password': password
      }),
    );

    if (response.statusCode == 200) {
      debugPrint('User deleted sucessfully');
      return;
    } else {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Failed to delete account');
    }
  }
}
