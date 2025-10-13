import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../main.dart'; // Correct relative path to import MyHomePage
import '../providers/login_request.dart';
import '../utilities/checkLogin.dart';
import '../widgets/text_form_feld.dart';
import 'registration_page.dart'; // Import RegistrationPage class

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController    = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  final FocusNode _emailFocus                     = FocusNode();
  final FocusNode _passwordFocus                  = FocusNode();

  final double elementSpacing                     = 15;

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
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    final String loginCheck = checkLogin(email, password);

    if (loginCheck != 'OK') {
      showDialog<ErrorDescription>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Login Failed'),
          content: Text(loginCheck),
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
    else
    {
      try {
        final int requestResponse = await loginUser(email: email, password: password);
      
        // On success, navigate to MyHomePage (home screen)
        if (requestResponse == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<ActionDispatcher>(
              builder: (BuildContext context) => const MyHomePage(title: 'EZ Pantry'),
            ),
          );
        } else {
          // Show error if credentials are incorrect
          showDialog<ErrorDescription>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Login Failed'),
              content: const Text('Incorrect email or password.'),
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
        debugPrint('Exception occurred: $e');
      }
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
            children: <Widget>[
              Image.asset(
                '../../assets/logo/logo.png', // Ensure this path matches your asset structure
                height: 300,
                width: 500,
              ),
                SizedBox(height: elementSpacing + 20),

                /// email field
                RegistrationLoginTextField(
                  label: 'Email',
                  focusNode: _emailFocus,
                  hintText: 'Enter your email',
                  controller: _emailController,
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
                        MaterialPageRoute<SystemNavigator>(
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
