import 'package:flutter/foundation.dart';

int checkLogin(String username, String password){
  int loginResult = -1; //

  if (username == 'dev' && password == 'dev'){
    debugPrint('checkLogin: Login accepted.');
    loginResult = 0;
  }
  else
  {
    debugPrint('checkLogin: Fail');
  }
  
  return loginResult;
}
