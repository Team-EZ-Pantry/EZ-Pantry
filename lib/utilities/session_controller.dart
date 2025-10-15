import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionController {
  SessionController._internal();

  static final SessionController _instance = SessionController._internal();
  static SessionController get instance => _instance;

  String? _authToken;

  final secureStorage = const FlutterSecureStorage();


  Future<void> setSession(String token) async {
    _authToken = token;
    await secureStorage.write(key: '_authToken', value: token);

    debugPrint('_authToken set: $token');
  }

  Future<void> loadSession() async {
    _authToken = await secureStorage.read(key: '_authToken');

    debugPrint('_authToken loaded: $_authToken');
  }

  Future<String?> getauthToken() async {
    if (_authToken != null && _authToken!.isNotEmpty) {
      debugPrint('Token from memory: $_authToken');
      return _authToken;
    }

    _authToken = await secureStorage.read(key: 'authToken');

    debugPrint('Token from storage: $_authToken');
    return _authToken;
  }

  Future<void> clearSession() async {
    await secureStorage.delete(key: 'authToken');
    _authToken = null;
    
    debugPrint('AuthToken cleared');
  }

  bool checkAuthToken() {

    debugPrint('Valid AuthToken: ${_authToken != null && _authToken != ''}');
    return _authToken != null && _authToken != '';
  }
}
