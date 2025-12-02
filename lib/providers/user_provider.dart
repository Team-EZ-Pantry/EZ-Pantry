import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import '../utilities/session_controller.dart'; 

class UserProvider with ChangeNotifier {
  final UserService _userService = UserService();
  
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Register, login, and fetch user profile
  Future<bool> register(String username, String email, String password) async {
    _setLoading(true);
    try {
      // Register
      final String token = await _userService.register(username, email, password);
      
      // Save Token
      SessionController.instance.setSession(token);
      
      // Load User Data
      _user = await _userService.getMe(token);
      
      _error = null;
      return true;
    } catch (e) {
      if (e is SocketException ||
          e is ClientException ||
          e is TimeoutException) {
        _error = 'Network connection failed.';
      } else {
        _error = e.toString().replaceAll('Exception: ', '');
      }

      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Login and fetch user profile
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      // Login
      final String token = await _userService.login(email, password);
      
      // Save Token
      SessionController.instance.setSession(token);

      // Load User Data
      _user = await _userService.getMe(token);

      _error = null;
      return true;
    } catch (e) {
      if (e is SocketException ||
          e is ClientException ||
          e is TimeoutException) {
        _error = 'Network connection failed.';
      } else {
        _error = e.toString().replaceAll('Exception: ', '');
      }

      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Reloads profile (used in Account Page if needed)
  Future<void> loadProfile() async {
    // If user model already exists, don't reload.
    if (_user != null) return; 

    final String? token = SessionController().token;
    if (token == null) return;

    _setLoading(true);
    try {
      _user = await _userService.getMe(token);
      _error = null;
    } catch (e) {
      if (e is SocketException ||
          e is ClientException ||
          e is TimeoutException) {
        _error = 'Network connection failed.';
      } else {
        _error = e.toString().replaceAll('Exception: ', '');
      }

      notifyListeners();
      return;    
      } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateUsername(String token, String newUsername) async {
    final String clean = newUsername.trim();

    // Compare to current username
    if (_user != null && clean == _user!.username) {
      _error = 'New username must be different';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _userService.updateUsername(token, newUsername);
      _error = null;
      return true;
    } catch (e) {
      if (e is SocketException ||
          e is ClientException ||
          e is TimeoutException) {
        _error = 'Network connection failed.';
      } else {
        _error = e.toString().replaceAll('Exception: ', '');
      }

      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> changePassword(
    String token,
    String currentPassword,
    String newPassword,
  ) async {

    if (newPassword == currentPassword) {
      _error = 'New password must be different from the old password';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _userService.updatePassword(token, currentPassword, newPassword);
      _error = null;
      return true;
    } catch (e) {
      if (e is SocketException ||
          e is ClientException ||
          e is TimeoutException) {
        _error = 'Network connection failed.';
      } else {
        _error = e.toString().replaceAll('Exception: ', '');
      }

      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteAccount(String token, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _userService.deleteAccount(token, password);
      _user = null;
      _error = null;
      return true;
    } catch (e) {
      if (e is SocketException ||
          e is ClientException ||
          e is TimeoutException) {
        _error = 'Network connection failed';
      } else {
        _error = e.toString().replaceAll('Exception: ', '');
      }

      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
