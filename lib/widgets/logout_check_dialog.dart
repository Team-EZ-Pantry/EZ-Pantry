import 'package:flutter/material.dart';

class LogoutCheckDialog extends StatelessWidget {
  final VoidCallback onStayLoggedIn;
  final VoidCallback onConfirmLogout;

  const LogoutCheckDialog({
    Key? key,
    required this.onStayLoggedIn,
    required this.onConfirmLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Logout'),
      content: const Text('Are you sure you want to log out?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onStayLoggedIn();
          },
          child: const Text('Stay Logged In'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirmLogout();
          },
          child: const Text('Log Out'),
        ),
      ],
    );
  }
}