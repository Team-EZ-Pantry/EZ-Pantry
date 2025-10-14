import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionController {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  String? _authToken;

  Future<void> saveAuthToken(String token) async {
    _authToken = token;
    await _secureStorage.write(key: 'authToken', value: token);
  }

  Future<String?> getAuthToken() async {
    if (_authToken != null && _authToken!.isNotEmpty) {
      print('Token from memory: $_authToken');
      return _authToken;
    }

    _authToken = await _secureStorage.read(key: 'authToken');

    print('Token from storage: $_authToken');
    return _authToken;
  }

  Future<void> clearAuthToken() async {
    _authToken = '';
    await _secureStorage.delete(key: 'authToken');
  }

  bool checkAuthToken() {
    return _authToken != null && _authToken != '';
  }
}

