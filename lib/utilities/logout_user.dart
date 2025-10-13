/// Clean up and log out the user

import 'package:flutter/material.dart';

void logoutUser(BuildContext context) {
  // Clear user session data
  // Add any additional cleanup here, such as clearing caches or user-specific files
  ImageCache().clear();
  ImageCache().clearLiveImages();

  // Redirect to login screen
  Navigator.pushNamedAndRemoveUntil(context, '/login', (Route<dynamic> route) => false);

  debugPrint('User logged out? successfully.');
  return;
}
