import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionController {
  SessionController._internal();

  static final SessionController _instance = SessionController._internal();
  static SessionController get instance => _instance;

  String? authToken;


  Future<void> setSession(String token) async {
    const secureStorage = FlutterSecureStorage();
    this.authToken = token;

    await secureStorage.write(key: 'authToken', value: token);

    debugPrint('AuthToken set: $token');
  }

  Future<void> loadSession() async {
    const secureStorage = FlutterSecureStorage();
    authToken = await secureStorage.read(key: 'authToken');

    debugPrint('AuthToken loaded: $authToken');
  }

  Future<String?> getAuthToken() async {
    if (authToken != '' || authToken != null) {
      return authToken;
    }

    const secureStorage = FlutterSecureStorage();
    authToken = await secureStorage.read(key: 'authToken');
    
    debugPrint('AuthToken retrieved: $authToken');

    return authToken;
  }

  Future<void> clearSession() async {
    const secureStorage = FlutterSecureStorage();
    await secureStorage.delete(key: 'authToken');
    authToken = null;
    debugPrint('AuthToken cleared');
  }

  bool checkAuthToken() {

    debugPrint('Valid AuthToken: ${authToken != null && authToken != ''}');
    return authToken != null && authToken != '';
  }
}

