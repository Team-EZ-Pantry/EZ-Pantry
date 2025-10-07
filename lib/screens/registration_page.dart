import 'package:flutter/material.dart';
import '../main.dart'; // Make sure this imports MyHomePage
import '../providers/registration_request.dart'; // Import the registration function

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _emailController    = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  final FocusNode _emailFocus         = FocusNode();
  final FocusNode _usernameFocus      = FocusNode();
  final FocusNode _passwordFocus      = FocusNode();

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

    try {
      // On success, navigate to MyHomePage (home screen)
      if (await registerUser(username: username, email: email, password: password)) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const MyHomePage(title: 'EZ Pantry'),
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0,0,16.0,0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('logo/logo.png', 
                        height: 300,
                        width: 500,
            ),

            TextField(
              controller: _emailController,
              focusNode: _emailFocus,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => _usernameFocus.requestFocus(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _usernameController,
              focusNode: _usernameFocus,
              decoration: const InputDecoration(labelText: 'Username'),
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => _passwordFocus.requestFocus(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              focusNode: _passwordFocus,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _handleRegistration(),
            ),
            const SizedBox(height: 32),

             // Login Button
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
    );
  }
}
