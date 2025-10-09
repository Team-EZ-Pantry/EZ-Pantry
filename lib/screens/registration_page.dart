import 'dart:math';

import 'package:flutter/material.dart';
import '../main.dart';                           // Make sure this imports MyHomePage
import '../providers/registration_request.dart';
import '../widgets/login_registration_TextFormField.dart'; // Import the registration function

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _emailController    = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  final FocusNode _emailFocus                     = FocusNode();
  final FocusNode _usernameFocus                  = FocusNode();
  final FocusNode _passwordFocus                  = FocusNode();

  final int badRequestCode                        = 400;
  final int userConflictCode                      = 409;
  final int serverErrorCode                       = 500;

  final double elementSpacing                        = 15;

  @override
  void initState() {
    super.initState();
    // Request focus after first frame to reliably show keyboard
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _emailFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _handleRegistration() async {
    final String email    = _emailController.text;
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    String errorDialog = 'Improper Error.';

    if (email.isEmpty || username.isEmpty || password.isEmpty) {
      // Show error if any field is empty
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Registration Failed'),
          content: const Text('All fields are required.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      // Show error if email format is invalid
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Registration Failed'),
          content: const Text('Please enter a valid email address.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    if (password.length < 6) {
      // Show error if password is too short
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Registration Failed'),
          content: const Text('Password must be at least 6 characters long.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    try {
      final int requestResponse = await registerUser(username: username, email: email, password: password);
      // On success, navigate to MyHomePage (home screen)
      if (requestResponse == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const MyHomePage(title: 'EZ Pantry'),
          ),
        );
      }
      else {
        // Show error dialog on failure
        if (requestResponse == badRequestCode){
                errorDialog = 'Bad Request: Please check your input.';
              } else if (requestResponse == userConflictCode) {
                errorDialog = 'User already exists. Please choose a different email.';
              } else if (requestResponse == serverErrorCode) {
                errorDialog = 'Server error. Please try again later.';
              } else {
                errorDialog = 'An unexpected error occurred. Please try again.';
            }
            
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Registration Failed'),
            content: Text(errorDialog),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Show error dialog on failure
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Registration Failed'),
          content: Text('Error: $e'),
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
      appBar: AppBar(
        title: const Text('Register'),
      ),
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
              
              /// Email field
              RegistrationLoginTextField(
                label: 'Email',
                focusNode: _emailFocus,
                hintText: 'Enter your email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                onSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_usernameFocus);
                },
              ),

              SizedBox(height: elementSpacing),

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
                onSubmitted: (_) => _handleRegistration(),
              ),

              SizedBox(height: elementSpacing + 5),

              /// Register Button
              ElevatedButton(
                onPressed: _handleRegistration,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.fromLTRB(100,15,100,15),
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),  
    );
  }
}
