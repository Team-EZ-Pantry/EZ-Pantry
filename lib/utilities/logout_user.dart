/// Clean up and log out the user

import 'package:flutter/material.dart';

import 'session_controller.dart';

void logoutUser(BuildContext context) {
  // Clear user session data
  SessionController.instance.clearSession();

  // Add any additional cleanup here, such as clearing caches or user-specific files
  ImageCache().clear();
  ImageCache().clearLiveImages();

  // Redirect to login screen
  Navigator.pushNamedAndRemoveUntil(context, '/login', (Route<dynamic> route) => false);
  debugPrint('logout_user(): redirected to login screen');

  return;
}
