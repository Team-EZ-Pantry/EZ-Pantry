import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionController {
  SessionController._internal();

  static final SessionController _instance = SessionController._internal();
  static SessionController get instance => _instance;

  String? _authToken;

  final secureStorage = const FlutterSecureStorage();

  Future<void> setSession(String token) async {
    _authToken = token;
    await secureStorage.write(key: 'authToken', value: token);

    debugPrint('authToken set: $token');
  }

  Future<void> loadSession() async {
    _authToken = await secureStorage.read(key: 'authToken');

    debugPrint('authToken loaded: $_authToken');
  }

  Future<String?> getAuthToken() async {
    if (kDebugMode)
    {
      debugPrint('Starting getAuthToken()');
    }
    
    if (_authToken != null && _authToken!.isNotEmpty) {
      debugPrint('authToken from memory: $_authToken');
      return _authToken;
    }

    _authToken = await secureStorage.read(key: 'authToken');

    debugPrint('authToken from storage: $_authToken');
    return _authToken;
  }

  Future<void> clearSession() async {
    await secureStorage.delete(key: 'authToken');
    _authToken = null;

    debugPrint('authToken cleared');
  }

  bool checkAuthToken() {

    debugPrint('Valid authToken: ${_authToken != null && _authToken != ''}');
    return _authToken != null && _authToken != '';
  }
}
