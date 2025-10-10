import 'package:flutter/foundation.dart';

String checkLogin(String username, String password){
  String loginResult; //

  if (username.isEmpty || password.isEmpty) {
      // Show error if any field is empty
      loginResult = 'All fields are required.';

    } else if (password.length < 6) {
      // Show error if password is too short
      loginResult = 'Password must be at least 6 characters long.';

    } else {
      loginResult = 'OK';
  }
  
  return loginResult;
}
