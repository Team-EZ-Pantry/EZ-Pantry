import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionController {
  static final SessionController _instance = SessionController._internal();
  factory SessionController() => _instance;
  SessionController._internal();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  String? _authToken;

  Future<void> saveAuthToken(String token) async {
    _authToken = token;
    await _secureStorage.write(key: 'authToken', value: token);
  }

  Future<String?> getAuthToken() async {
    if (_authToken != null) {
      return _authToken;
    }
    
    _authToken = await _secureStorage.read(key: 'authToken');
    return _authToken;
  }

  Future<void> clearAuthToken() async {
    _authToken = null;
    await _secureStorage.delete(key: 'authToken');
  }
}

