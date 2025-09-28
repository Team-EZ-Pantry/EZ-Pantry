import 'package:flutter/material.dart';
import '../main.dart'; // Make sure this imports MyHomePage

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

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
    final username = _usernameController.text;
    final password = _passwordController.text;
    int registrationResult = validateCredentials(username, password);

    if (registrationResult == 0) {
      // Navigate to MyHomePage (home screen)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MyHomePage(title: 'EZ Pantry'),
        ),
      );
    } else {
      // Show error if credentials are incorrect
      if (registrationResult == 1) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Login Failed"),
            content: const Text("Incorrect username."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }


      if (registrationResult == 2) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Login Failed"),
            content: const Text("Incorrect password."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }

      if (registrationResult == 3) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Login Failed"),
            content: const Text("Incorrect username and password."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 40),

              // Username
              const Text(
                "Username",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _usernameController,
                focusNode: _usernameFocus,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter your username",
                ),
                onSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_passwordFocus);
                },
              ),
              const SizedBox(height: 20),

              // Password
              const Text(
                "Password",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                focusNode: _passwordFocus,
                obscureText: true,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter your password",
                ),
                onSubmitted: (_) => _handleLogin(),
              ),
              const SizedBox(height: 30),

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
            ],
          ),
        ),
      ),
    );
  }
}

/**
* Returns a code indicating the validity of the provided username and password.
***/
int validateCredentials(String user, String password) {
    // Dummy validation logic
    RegExp usernameRegExp = RegExp(r'^[a-zA-Z0-9_]{3,16}$');
    RegExp passwordRegExp = RegExp(r'^.{3,16}$');
    bool   passwordValid  = passwordRegExp.hasMatch(user);
    bool   userValid      = usernameRegExp.hasMatch(user);
    int    resultCode     = 0; 

    if (!userValid || !passwordValid) {
      // Failure
      if (!userValid) {
        resultCode += 1;
      }

      if (!passwordValid) {
        resultCode += 2;
      }
    }

    return resultCode; 
  }

// TODO: my life