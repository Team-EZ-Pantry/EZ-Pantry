import 'dart:math';

import 'package:flutter/material.dart';
import '../main.dart'; // Correct relative path to import MyHomePage
import '../utilities/check_login.dart';
import '../widgets/login_registration_TextFormField.dart';
import 'registration_page.dart'; // Import RegistrationPage class

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  final FocusNode _usernameFocus                  = FocusNode();
  final FocusNode _passwordFocus                  = FocusNode();

  final double elementSpacing                     = 15;

  @override
  void initState() {
    super.initState();
    // Request focus after first frame to reliably show keyboard
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _usernameFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    if (checkLogin(username, password) == 0) {
      // Navigate to MyHomePage (home screen)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const MyHomePage(title: 'EZ Pantry'),
        ),
      );
    } else {
      // Show error if credentials are incorrect
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Login Failed'),
          content: const Text('Incorrect username or password.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                '../../assets/logo/logo.png', // Ensure this path matches your asset structure
                height: 300,
                width: 500,
              ),
                SizedBox(height: elementSpacing + 20),

                /// Username field
                RegistrationLoginTextField(
                  label: 'Username',
                  focusNode: _usernameFocus,
                  hintText: 'Enter your username',
                  controller: _usernameController,
                  onSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_passwordFocus);
                  },
                ),

                SizedBox(height: elementSpacing),

                /// Password field
                RegistrationLoginTextField(
                  label: 'Password',
                  focusNode: _passwordFocus,
                  hintText: 'Enter your password',
                  controller: _passwordController,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _handleLogin(),
                ),

                SizedBox(height: elementSpacing + 5),

                // Login Button
                ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 18),
                  ),
                ),

                /// Sign Up Text Button
                Padding(
                  padding:  const EdgeInsets.only(top: 20.0), 
                  child: TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => const RegistrationPage()),
                      ),
                  child: const Text('New user? Sign up' ),) ,),
            ],
          ),
        ),
      ),
    );
  }
}
