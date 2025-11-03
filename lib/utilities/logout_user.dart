/// Log out the user and do any data cleanup the SessionController does not do.
/// - Redirects given context to login page
library;

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
