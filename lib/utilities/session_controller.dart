import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionController {
  // Singleton pattern
  SessionController._internal();
  static final SessionController _instance = SessionController._internal();
  
  // Factory constructor returns the singleton instance
  factory SessionController() => _instance;
  
  // Also provide static getter for convenience
  static SessionController get instance => _instance;

  String? _authToken;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  // Synchronous getter for token
  String? get token => _authToken;

  /// Set session token (call after login)
  Future<void> setSession(String token) async {
    _authToken = token;
    await secureStorage.write(key: 'authToken', value: token);
    debugPrint('authToken set: $token');
  }

  /// Load session from secure storage (call on app startup)
  Future<void> loadSession() async {
    _authToken = await secureStorage.read(key: 'authToken');
    debugPrint('authToken loaded: $_authToken');
  }

  /// Get auth token (async version)
  Future<String?> getAuthToken() async {
    if (kDebugMode) {
      debugPrint('Starting getAuthToken()');
    }
    
    // Return from memory if available
    if (_authToken != null && _authToken!.isNotEmpty) {
      debugPrint('authToken from memory: $_authToken');
      return _authToken;
    }
    
    // Load from storage if not in memory
    _authToken = await secureStorage.read(key: 'authToken');
    debugPrint('authToken from storage: $_authToken');
    return _authToken;
  }

  /// Clear session (call on logout)
  Future<void> clearSession() async {
    await secureStorage.delete(key: 'authToken');
    _authToken = null;
    debugPrint('authToken cleared');
  }

  // Check if user has valid auth token
  bool checkAuthToken() {
    final hasToken = _authToken != null && _authToken != '';
    debugPrint('Valid authToken: $hasToken');
    return hasToken;
  }

  // Check if user is logged in (synchronous)
  bool get isLoggedIn => _authToken != null && _authToken!.isNotEmpty;
}